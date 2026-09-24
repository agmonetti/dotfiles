#!/usr/bin/env python3
"""Icons for minimized windows on the active Hyprland workspace."""

import json
import subprocess

ICONS = {
    "firefox": "󰈹",
    "kitty": "",
    "zen": "󰖟",
}
FALLBACK = "󰖯"


def render(workspace_id, clients):
    icons = []
    origin_tag = f"minimized_ws_{workspace_id}"
    for client in clients:
        tags = client.get("tags", [])
        if "minimized" in tags and origin_tag in tags:
            icons.append(ICONS.get(client.get("class", "").lower(), FALLBACK))
    return " ".join(icons)


def main():
    try:
        workspace = json.loads(subprocess.check_output(["hyprctl", "-j", "activeworkspace"], text=True))
        clients = json.loads(subprocess.check_output(["hyprctl", "-j", "clients"], text=True))
    except (OSError, subprocess.CalledProcessError, json.JSONDecodeError):
        return
    print(render(workspace["id"], clients))


if __name__ == "__main__":
    main()
