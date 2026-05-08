import json
import re
from typing import Any


def parse_json_safe(text: str) -> dict[str, Any]:
    cleaned = text.strip()
    # Strip fenced code block (```json ... ``` or ``` ... ```)
    cleaned = re.sub(r"^```(?:json)?\s*\n?", "", cleaned)
    cleaned = re.sub(r"\n?```\s*$", "", cleaned)
    cleaned = cleaned.strip()
    return json.loads(cleaned)
