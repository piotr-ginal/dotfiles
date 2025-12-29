#!/usr/bin/env python3
import argparse
import json
import sys
from pathlib import Path


def format_json_file(file_path: Path, *, indent: int = 4, in_place: bool = False) -> None:
    try:
        data = json.loads(file_path.read_text(encoding="utf-8"))

        formatted_json = json.dumps(data, indent=indent, sort_keys=True, ensure_ascii=False)

        if in_place:
            file_path.write_text(formatted_json, encoding="utf-8")
        else:
            sys.stdout.write(formatted_json)

    except (IsADirectoryError, FileNotFoundError):
        sys.stdout.write(f"file {file_path} not found\n")
        sys.exit(1)
    except json.JSONDecodeError:
        sys.stdout.write(f"{file_path} not a valid json file\n")
        sys.exit(1)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("file")
    parser.add_argument("-i", "--in-place", action="store_true")
    parser.add_argument("--indent", type=int, default=4)

    args = parser.parse_args()
    format_json_file(Path(args.file).resolve(), indent=args.indent, in_place=args.in_place)


if __name__ == "__main__":
    main()
