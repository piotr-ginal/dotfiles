#!/usr/bin/env python3
from __future__ import annotations

import glob
import json
import operator
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


def run_command(argv: list[str]) -> str:
    completed = subprocess.run(  # noqa: S603
        argv,
        check=True,
        capture_output=True,
        text=True,
    )
    return completed.stdout.strip()


def sway_json(message_type: str) -> dict | list:
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
        return []

    if resolved in visited_files:
        return []
    visited_files.add(resolved)

    if resolved.is_dir():
        return []

    lines: list[str] = []
    for raw_line in resolved.read_text(encoding="utf-8", errors="replace").splitlines():
        line = remove_comment_and_trim(raw_line)
        if not line:
            continue

        tokens = _safe_split(line)
        if tokens is None:
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

    expanded_lines: list[str] = []
    for match in sorted(glob.glob(str(include_pattern))):  # noqa: PTH207
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

    return {output: sorted(numbers) for output, numbers in by_output.items()}


def list_active_outputs() -> list[str]:
    outputs = sway_json("get_outputs")
    return [entry["name"] for entry in outputs]


def list_existing_workspace_numbers_on_output(output_name: str) -> list[int]:
    workspaces = sway_json("get_workspaces")
    numbers: list[int] = []
    for ws in workspaces:
        if ws.get("output") != output_name:
            continue
        num = int(ws.get("num", -1))
        if num > 0:
            numbers.append(num)
    return sorted(numbers)


def rename_workspace_number(source: int, target: int) -> None:
    subprocess.run(  # noqa: S603
        [SWAYMSG, "rename", "workspace", "number", str(source), "to", str(target)],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def build_compaction_renames(existing: list[int], reserved: list[int]) -> list[tuple[int, int]]:
    count = min(len(existing), len(reserved))
    renames: list[tuple[int, int]] = []

    for i in range(count):
        source = existing[i]
        target = reserved[i]
        if source != target:
            renames.append((source, target))

    renames.sort(key=operator.itemgetter(0), reverse=True)
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

    renames.sort(key=operator.itemgetter(0), reverse=True)
    return renames


def load_flattened_config_lines() -> list[str]:
    flattened: list[str] = []
    for root in ROOT_CONFIG_FILES:
        flattened.extend(expand_included_config_lines(root))
    return flattened


def main() -> int:
    flattened = load_flattened_config_lines()
    reserved_by_output = parse_reserved_workspaces_by_output(flattened)

    for output_name in list_active_outputs():
        existing = list_existing_workspace_numbers_on_output(output_name)
        if not existing:
            continue

        reserved = reserved_by_output.get(output_name)
        renames = build_compaction_renames(existing, reserved) if reserved else build_fallback_renames(existing)

        for source, target in renames:
            rename_workspace_number(source, target)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
