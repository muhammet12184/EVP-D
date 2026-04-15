#!/usr/bin/env python3
"""Split ev_unified_professional.csv into one CSV per brand.

Each brand section in the source file is delimited by a header row of the form
`=== Brand Name ===;;;;;;`. This script writes each section to its own file
under `brands/<slug>.csv`, keeping the same header row as the source file.
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "ev_unified_professional.csv"
OUT_DIR = ROOT / "brands"

SECTION_RE = re.compile(r"^=== (.+?) ===")


def slugify(name: str) -> str:
    name = name.lower()
    name = re.sub(r"[()]", "", name)
    name = re.sub(r"[\s/,]+", "-", name)
    name = re.sub(r"[^a-z0-9-]", "", name)
    name = re.sub(r"-+", "-", name).strip("-")
    return name


def main() -> None:
    lines = SOURCE.read_text(encoding="utf-8").splitlines()
    header = lines[0]

    OUT_DIR.mkdir(parents=True, exist_ok=True)

    current_name: str | None = None
    current_rows: list[str] = []
    written: list[tuple[str, Path, int]] = []

    def flush() -> None:
        if current_name is None:
            return
        slug = slugify(current_name)
        path = OUT_DIR / f"{slug}.csv"
        body = "\n".join([header, *current_rows]) + "\n"
        path.write_text(body, encoding="utf-8")
        written.append((current_name, path, len(current_rows)))

    for line in lines[1:]:
        m = SECTION_RE.match(line)
        if m:
            flush()
            current_name = m.group(1).strip()
            current_rows = []
            continue
        if current_name is None or not line.strip():
            continue
        current_rows.append(line)

    flush()

    for name, path, count in written:
        print(f"{name:50s} -> {path.relative_to(ROOT)} ({count} rows)")


if __name__ == "__main__":
    main()
