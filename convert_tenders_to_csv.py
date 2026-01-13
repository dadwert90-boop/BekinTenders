"""
Convert tenders_rows.xlsx into a staging CSV compatible with schema.sql.
This uses only the standard library (zipfile + ElementTree) to avoid extra installs.
"""

import csv
import pathlib
import re
import zipfile
from typing import Dict, List, Optional

WORKBOOK_PATH = pathlib.Path("tenders_rows.xlsx")
OUTPUT_CSV = pathlib.Path("staging_tenders.csv")


def column_index(column_letters: str) -> int:
    """Translate Excel column letters (A, B, AA, etc.) to a zero-based index."""
    total = 0
    for ch in column_letters:
        total = total * 26 + (ord(ch) - 64)
    return total - 1


def load_shared_strings(zf: zipfile.ZipFile) -> Dict[int, str]:
    """Return shared string table."""
    if "xl/sharedStrings.xml" not in zf.namelist():
        return {}

    from xml.etree import ElementTree as ET

    root = ET.fromstring(zf.read("xl/sharedStrings.xml"))
    strings = []
    for si in root.findall("{http://schemas.openxmlformats.org/spreadsheetml/2006/main}si"):
        parts = [
            (t.text or "")
            for t in si.findall(
                ".//{http://schemas.openxmlformats.org/spreadsheetml/2006/main}t"
            )
        ]
        strings.append("".join(parts))
    return {i: s for i, s in enumerate(strings)}


def read_rows(path: pathlib.Path) -> List[List[Optional[str]]]:
    """Read worksheet #1 into a list of rows with empty slots filled as None."""
    with zipfile.ZipFile(path) as zf:
        shared_strings = load_shared_strings(zf)
        from xml.etree import ElementTree as ET

        sheet = ET.fromstring(zf.read("xl/worksheets/sheet1.xml"))
        ns = {"a": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}

        rows_with_indices: List[Dict[int, Optional[str]]] = []
        for row in sheet.findall(".//a:row", ns):
            cols: Dict[int, Optional[str]] = {}
            for cell in row.findall("a:c", ns):
                ref = cell.attrib.get("r", "")
                match = re.match(r"([A-Z]+)(\\d+)", ref)
                if not match:
                    continue
                col_idx = column_index(match.group(1))
                value_node = cell.find("a:v", ns)
                value = value_node.text if value_node is not None else None
                if cell.get("t") == "s" and value is not None:
                    value = shared_strings.get(int(value), "")
                cols[col_idx] = value
            rows_with_indices.append(cols)

        if not rows_with_indices:
            raise ValueError("Worksheet has no rows")

        header_row = rows_with_indices[0]
        header_width = max(header_row) + 1
        normalized: List[List[Optional[str]]] = []
        for cols in rows_with_indices:
            normalized.append([cols.get(i) for i in range(header_width)])
        return normalized


def main() -> None:
    rows = read_rows(WORKBOOK_PATH)
    header, data = rows[0], rows[1:]

    with OUTPUT_CSV.open("w", newline="", encoding="utf-8") as fh:
        writer = csv.writer(fh)
        writer.writerow(header)
        for row in data:
            # Strip leading/trailing whitespace (the source has leading tabs).
            writer.writerow([(value.strip() if isinstance(value, str) else value) for value in row])

    print(f"Wrote {len(data)} rows to {OUTPUT_CSV}")


if __name__ == "__main__":
    main()
