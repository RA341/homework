import json
import os
import urllib.request

BASE_URL = os.getenv("CHROMETROL_URL", "http://localhost:8998").rstrip("/")
HEADERS = {"Accept": "application/json"}


def _get(endpoint: str) -> dict:
    req = urllib.request.Request(
        f"{BASE_URL}/{endpoint}", headers=HEADERS, method="GET"
    )
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode("utf-8"))


def status() -> dict:
    return _get("status")


def start() -> dict:
    return _get("start")


def stop() -> dict:
    return _get("stop")