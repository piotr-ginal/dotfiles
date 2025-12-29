#!/usr/bin/env python3

import sys
import textwrap

COMMENT_TOKEN: str = "#"  # noqa: S105
SCISSORS_LINE: str = "# ------------------------ >8 ------------------------"


def wrap_text_to_lines(text: str, width: int) -> list[str]:
    if not text.strip():
        return [""]
    return textwrap.wrap(text, width=width, break_long_words=True, break_on_hyphens=False)


def format_text(input_text: str) -> str:
    lines = input_text.splitlines()

    result_lines = []
    scissors_found = False
    first_line = True

    for line in lines:
        if line == SCISSORS_LINE:
            scissors_found = True
            result_lines.append(line)
            continue

        if scissors_found or line.startswith(COMMENT_TOKEN):
            result_lines.append(line)
        elif first_line:
            wrapped = wrap_text_to_lines(line, 50)
            result_lines.extend(wrapped)
            first_line = False
        else:
            wrapped = wrap_text_to_lines(line, 72)
            result_lines.extend(wrapped)

    return "\n".join(result_lines)


def main() -> None:
    input_text = sys.stdin.read()
    formatted_text = format_text(input_text)
    sys.stdout.write(formatted_text)


if __name__ == "__main__":
    main()
