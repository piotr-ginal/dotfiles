import sys

MAP_LINK_HINTS_LINE_BASE = "map f LinkHints.activate"
HOST_SELECTOR_SEPARATOR = "##"
ENTRY_SEPARATOR: str = ";"
SELECTOR_LIST_SEPARATOR: str = ","
EXCLUDE_ON_HOST_KEY_FORMAT: str = 'excludeOnHost="{host_regex_to_selector_list}"'

HOST_REGEX_TO_SELECTOR_MAP: dict[str, list[str]] = {
    "github.com": [
        ".ContributionCalendar-day",
    ],
}


def main() -> None:
    entries: list[str] = []

    for host_regex, selectors in HOST_REGEX_TO_SELECTOR_MAP.items():
        selector_list_str = SELECTOR_LIST_SEPARATOR.join(selectors)
        entries.append(f"{host_regex}{HOST_SELECTOR_SEPARATOR}{selector_list_str}")

    host_regex_to_selector_list: str = ENTRY_SEPARATOR.join(entries)
    exclude_key_str: str = EXCLUDE_ON_HOST_KEY_FORMAT.format(
        host_regex_to_selector_list=host_regex_to_selector_list,
    )

    sys.stdout.write(f"{MAP_LINK_HINTS_LINE_BASE} {exclude_key_str}\n")


if __name__ == "__main__":
    main()
