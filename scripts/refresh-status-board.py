"""
Leest de frontmatter van elk Projects/{naam}/{naam}.md en genereert Projects/_status.md.
Nooit met de hand bewerken.
Gebruik: python scripts/refresh-status-board.py
"""

import os
import re
from pathlib import Path
from datetime import datetime

VAULT = Path(__file__).parent.parent
PROJECTS = VAULT / "Projects"
OUTPUT = PROJECTS / "_status.md"


def parse_frontmatter(text):
    match = re.match(r"^---\n(.*?)\n---", text, re.DOTALL)
    if not match:
        return {}
    result = {}
    for line in match.group(1).splitlines():
        if ":" in line:
            key, _, val = line.partition(":")
            result[key.strip()] = val.strip()
    return result


def first_body_lines(text, n=2):
    in_front = False
    count = 0
    lines = []
    for line in text.splitlines():
        if line.strip() == "---":
            in_front = not in_front
            continue
        if in_front:
            continue
        if line.strip():
            lines.append(line.strip())
            count += 1
            if count >= n:
                break
    return " ".join(lines)


rows = []
for project_dir in sorted(PROJECTS.iterdir()):
    if not project_dir.is_dir() or project_dir.name.startswith("_"):
        continue
    index = project_dir / f"{project_dir.name}.md"
    if not index.exists():
        continue
    text = index.read_text(encoding="utf-8")
    fm = parse_frontmatter(text)
    mtime = datetime.fromtimestamp(index.stat().st_mtime).strftime("%Y-%m-%d")
    status = fm.get("status", "onbekend")
    preview = first_body_lines(text)
    rows.append((project_dir.name, status, mtime, preview))

lines = [
    "---",
    "type: status-board",
    f"date: {datetime.now().strftime('%Y-%m-%d')}",
    "status: gegenereerd",
    "tags: [status, overzicht]",
    "---",
    "",
    "Automatisch gegenereerd door `scripts/refresh-status-board.py`. Nooit met de hand bewerken.",
    "",
    "| Project | Status | Laatst aangeraakt | Context |",
    "|---|---|---|---|",
]
for name, status, mtime, preview in rows:
    lines.append(f"| [[{name}]] | {status} | {mtime} | {preview} |")

OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"Status-board bijgewerkt: {OUTPUT}")
