#!/usr/bin/env python3

import configparser
import sys
from pathlib import Path

FIREFOX_PROFILES_CONFIG_PATH: Path = Path.home() / ".mozilla" / "firefox" / "profiles.ini"


def parse_profile_from_config(config_path: Path) -> Path | None:

    # TODO(ginal): maybe a different error for "is not file" path
    if not config_path.exists() or not config_path.is_file():
        raise FileNotFoundError

    config = configparser.ConfigParser()

    config.read(config_path)

    for section in config.sections():
        if not section.startswith("Install"):  # section in format f"Install{install_hash}"
            continue

        if not config.has_option(section, "Default"):  # Key contains path relative to config path
            continue

        candidate_profile_dir = config_path.parent / config.get(section, "Default")

        if not candidate_profile_dir.is_dir():
            continue

        return candidate_profile_dir

    return None


def main() -> int:
    config = parse_profile_from_config(FIREFOX_PROFILES_CONFIG_PATH)

    if config is None:
        return 1

    sys.stdout.write(f"{config}\n")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
