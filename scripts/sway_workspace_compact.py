#!/usr/bin/env python3
from __future__ import annotations

import argparse
import glob
import json
import logging
import operator
import os
import re
import shlex
import subprocess  # noqa: S404
from pathlib import Path

SWAYMSG = "swaymsg"

ROOT_CONFIG_FILES: tuple[Path, ...] = (
    Path("~/.config/sway/config").expanduser(),
    Path("/etc/sway/config"),
)

WORKSPACE_OUTPUT_PATTERN = re.compile(
    r"^workspace\s+(?:number\s+)?(?P<number>\d+)\s+output\s+(?P<output>\S+)\s*$",
)

LOG = logging.getLogger("sway-workspace-compact")


def configure_logging(*, debug: bool = False) -> None:
    env_level = os.environ.get("LOG_LEVEL", "").upper().strip()
    if debug:
        level = logging.DEBUG
    elif env_level:
        level = getattr(logging, env_level, logging.INFO)
    else:
        level = logging.INFO

    logging.basicConfig(
        level=level,
        format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    )


def run_command(argv: list[str]) -> str:
    LOG.debug("Running command: %r", argv)
    completed = subprocess.run(  # noqa: S603
        argv,
        check=True,
        capture_output=True,
        text=True,
    )
    out = completed.stdout.strip()
    LOG.debug("Command output (trimmed): %r", out)
    return out


def sway_json(message_type: str) -> dict | list:
    LOG.debug("Query sway IPC message type: %s", message_type)
    return json.loads(run_command([SWAYMSG, "-t", message_type]))


def remove_comment_and_trim(line: str) -> str:
    before_hash = line.split("#", 1)[0]
    return before_hash.strip()


def expand_included_config_lines(
    path: Path,
    *,
    visited_files: set[Path] | None = None,
) -> list[str]:
    visited_files = visited_files or set()

    resolved = _resolve_existing_path(path)
    if resolved is None:
        LOG.debug("Config path does not exist (skipping): %s", path)
        return []

    if resolved in visited_files:
        LOG.debug("Already visited config file (cycle/duplicate, skipping): %s", resolved)
        return []
    visited_files.add(resolved)

    if resolved.is_dir():
        LOG.debug("Config path is a directory (skipping): %s", resolved)
        return []

    LOG.info("Discovered config file: %s", resolved)

    lines: list[str] = []
    for raw_line in resolved.read_text(encoding="utf-8", errors="replace").splitlines():
        line = remove_comment_and_trim(raw_line)
        if not line:
            continue

        tokens = _safe_split(line)
        if tokens is None:
            LOG.debug("Could not shlex-split line (keeping as-is): %r", line)
            lines.append(line)
            continue

        if _is_include(tokens):
            lines.extend(_expand_include_tokens(tokens, visited_files))
            continue

        lines.append(line)

    return lines


def _resolve_existing_path(path: Path) -> Path | None:
    try:
        return path.expanduser().resolve(strict=True)
    except FileNotFoundError:
        return None


def _safe_split(line: str) -> list[str] | None:
    try:
        return shlex.split(line, posix=True)
    except ValueError:
        return None


def _is_include(tokens: list[str]) -> bool:
    return len(tokens) >= 2 and tokens[0] == "include"  # noqa: PLR2004


def _expand_include_tokens(tokens: list[str], visited_files: set[Path]) -> list[str]:
    include_pattern = Path(tokens[1]).expanduser()
    LOG.info("Processing include pattern: %s", include_pattern)

    expanded_lines: list[str] = []
    matches = sorted(glob.glob(str(include_pattern)))  # noqa: PTH207
    if not matches:
        LOG.debug("Include pattern had no matches: %s", include_pattern)

    for match in matches:
        LOG.info("Include matched file: %s", match)
        expanded_lines.extend(
            expand_included_config_lines(Path(match), visited_files=visited_files),
        )
    return expanded_lines


def parse_reserved_workspaces_by_output(flattened_lines: list[str]) -> dict[str, list[int]]:
    by_output: dict[str, set[int]] = {}

    for line in flattened_lines:
        match = WORKSPACE_OUTPUT_PATTERN.match(line)
        if not match:
            continue

        number = int(match.group("number"))
        output = match.group("output")
        by_output.setdefault(output, set()).add(number)
        LOG.debug("Reserved workspace parsed: output=%s number=%s (from %r)", output, number, line)

    result = {output: sorted(numbers) for output, numbers in by_output.items()}
    LOG.info("Parsed reserved workspaces by output: %s", result)
    return result


def list_active_outputs() -> list[str]:
    outputs = sway_json("get_outputs")
    names = [entry["name"] for entry in outputs]
    LOG.info("Active outputs: %s", names)
    return names


def list_existing_workspace_numbers_on_output(output_name: str) -> list[int]:
    workspaces = sway_json("get_workspaces")
    numbers: list[int] = []
    for ws in workspaces:
        if ws.get("output") != output_name:
            continue
        num = int(ws.get("num", -1))
        if num > 0:
            numbers.append(num)
    numbers_sorted = sorted(numbers)
    LOG.info("Existing workspaces on %s: %s", output_name, numbers_sorted)
    return numbers_sorted


def rename_workspace_number(source: int, target: int) -> None:
    # Most important log: what was renamed to what
    LOG.info("Renaming workspace: %s -> %s", source, target)
    try:
        completed = subprocess.run(  # noqa: S603
            [SWAYMSG, "rename", "workspace", "number", str(source), "to", str(target)],
            check=True,
            capture_output=True,
            text=True,
        )
        if completed.stdout.strip():
            LOG.debug("swaymsg stdout: %s", completed.stdout.strip())
        if completed.stderr.strip():
            LOG.debug("swaymsg stderr: %s", completed.stderr.strip())
    except subprocess.CalledProcessError as e:
        # Keep the important info in logs
        stderr = (e.stderr or "").strip()
        stdout = (e.stdout or "").strip()
        LOG.exception(
            "Rename failed: %s -> %s (returncode=%s stdout=%r stderr=%r)",
            source,
            target,
            e.returncode,
            stdout,
            stderr,
        )
        raise


def build_compaction_renames(existing: list[int], reserved: list[int]) -> list[tuple[int, int]]:
    count = min(len(existing), len(reserved))
    renames: list[tuple[int, int]] = []

    for i in range(count):
        source = existing[i]
        target = reserved[i]
        if source != target:
            renames.append((source, target))

    if not renames:
        return []

    moving_down = any(t < s for s, t in renames)
    if moving_down:
        renames.sort(key=operator.itemgetter(0))  # source ascending
    else:
        renames.sort(key=operator.itemgetter(0), reverse=True)  # source descending

    return renames


def build_fallback_renames(existing: list[int]) -> list[tuple[int, int]]:
    if not existing:
        return []

    target = existing[0]
    renames: list[tuple[int, int]] = []
    for source in existing:
        if source != target:
            renames.append((source, target))
        target += 1

    if not renames:
        return []

    moving_down = any(t < s for s, t in renames)
    if moving_down:
        renames.sort(key=operator.itemgetter(0))  # source ascending
    else:
        renames.sort(key=operator.itemgetter(0), reverse=True)

    return renames


def load_flattened_config_lines() -> list[str]:
    flattened: list[str] = []
    for root in ROOT_CONFIG_FILES:
        LOG.debug("Loading root config: %s", root)
        flattened.extend(expand_included_config_lines(root))
    LOG.info("Flattened config line count: %d", len(flattened))
    return flattened


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Compact Sway workspace numbers per-output based on config reservations.")
    p.add_argument("--debug", action="store_true", help="Enable debug logging (also supports LOG_LEVEL env var).")
    return p.parse_args(argv)


def _warn_if_shifting_up(*, output_name: str, renames: list[tuple[int, int]]) -> None:
    ups = [(s, t) for s, t in renames if t > s]

    if len(ups) == 0:
        return

    LOG.warning(
        "Output %s: plan includes shifting UP workspace numbers (may be unexpected): %s",
        output_name,
        ups,
    )


def main(argv: list[str] | None = None) -> int:
    args = parse_args(argv)
    configure_logging(debug=args.debug)

    flattened = load_flattened_config_lines()
    reserved_by_output = parse_reserved_workspaces_by_output(flattened)

    for output_name in list_active_outputs():
        existing = list_existing_workspace_numbers_on_output(output_name)
        if not existing:
            LOG.debug("No existing workspaces on %s, skipping", output_name)
            continue

        reserved = reserved_by_output.get(output_name)
        if reserved:
            renames = build_compaction_renames(existing, reserved)
            _warn_if_shifting_up(output_name=output_name, renames=renames)
            LOG.info(
                "Rename plan for %s (compaction): existing=%s reserved=%s renames=%s",
                output_name,
                existing,
                reserved,
                renames,
            )
        else:
            renames = build_fallback_renames(existing)
            LOG.info("Rename plan for %s (fallback): existing=%s renames=%s", output_name, existing, renames)

        if not renames:
            LOG.info("No renames needed for %s", output_name)
            continue

        for source, target in renames:
            rename_workspace_number(source, target)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
