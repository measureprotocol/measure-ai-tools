#!/usr/bin/env python3
"""
Measure ClickUp CLI
Thin wrapper around the ClickUp REST API v2.
Uses only Python stdlib — no extra dependencies required.

Setup:
    export CLICKUP_API_TOKEN="your_personal_api_token"
    Get a token at: https://app.clickup.com/settings/apps

Usage:
    clickup get <task-id>                     Print task name, status, assignees, URL
    clickup status <task-id> <status>         Update task status
    clickup comment <task-id> <message>       Add a comment to a task
    clickup assign <task-id> <username>       Assign task to a workspace member
    clickup unassign <task-id> <username>     Remove assignee from a task

Examples:
    clickup get abc123
    clickup status abc123 "in progress"
    clickup comment abc123 "Branch feature_user-auth created."
    clickup assign abc123 john
"""

import json
import os
import sys
import urllib.error
import urllib.request

API_BASE = "https://api.clickup.com/api/v2"
WORKSPACE_ID = os.environ.get("CLICKUP_WORKSPACE_ID", "24512284")


# ---------------------------------------------------------------------------
# HTTP helpers
# ---------------------------------------------------------------------------

def _token() -> str:
    token = os.environ.get("CLICKUP_API_TOKEN", "").strip()
    if not token:
        _die(
            "CLICKUP_API_TOKEN is not set.\n"
            "  Add to your shell profile:  export CLICKUP_API_TOKEN='your_token'\n"
            "  Get a token at: https://app.clickup.com/settings/apps"
        )
    return token


def _request(method: str, path: str, body: dict | None = None) -> dict:
    url = f"{API_BASE}{path}"
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Authorization": _token(),
            "Content-Type": "application/json",
        },
        method=method,
    )
    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        body_text = e.read().decode()
        try:
            msg = json.loads(body_text).get("err", body_text)
        except Exception:
            msg = body_text
        _die(f"ClickUp API error {e.code}: {msg}")


def _die(msg: str) -> None:
    print(f"Error: {msg}", file=sys.stderr)
    sys.exit(1)


# ---------------------------------------------------------------------------
# Commands
# ---------------------------------------------------------------------------

def cmd_get(task_id: str) -> None:
    task = _request("GET", f"/task/{task_id}")
    status = task.get("status", {}).get("status", "unknown")
    assignees = ", ".join(a.get("username", "") for a in task.get("assignees", [])) or "none"
    url = task.get("url", "")
    print(f"Name:      {task.get('name')}")
    print(f"Status:    {status}")
    print(f"Assignees: {assignees}")
    if url:
        print(f"URL:       {url}")


def cmd_status(task_id: str, status: str) -> None:
    _request("PUT", f"/task/{task_id}", {"status": status})
    print(f"Task {task_id} status → '{status}'")


def cmd_comment(task_id: str, message: str) -> None:
    _request("POST", f"/task/{task_id}/comment", {"comment_text": message})
    print(f"Comment added to task {task_id}")


def _find_member(username: str) -> dict:
    """Return the member dict for a given username, or exit with an error."""
    data = _request("GET", f"/team/{WORKSPACE_ID}/member")
    members = data.get("members", [])
    match = next(
        (m for m in members if m.get("user", {}).get("username") == username),
        None,
    )
    if not match:
        names = [m.get("user", {}).get("username", "") for m in members]
        _die(f"User '{username}' not found. Workspace members: {', '.join(names)}")
    return match


def cmd_assign(task_id: str, username: str) -> None:
    member = _find_member(username)
    user_id = member["user"]["id"]
    _request("PUT", f"/task/{task_id}", {"assignees": {"add": [user_id]}})
    print(f"Task {task_id} assigned to {username}")


def cmd_unassign(task_id: str, username: str) -> None:
    member = _find_member(username)
    user_id = member["user"]["id"]
    _request("PUT", f"/task/{task_id}", {"assignees": {"rem": [user_id]}})
    print(f"Task {task_id} unassigned from {username}")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

COMMANDS = {
    "get":      (cmd_get,      2, "<task-id>"),
    "status":   (cmd_status,   3, "<task-id> <status>"),
    "comment":  (cmd_comment,  3, "<task-id> <message...>"),
    "assign":   (cmd_assign,   3, "<task-id> <username>"),
    "unassign": (cmd_unassign, 3, "<task-id> <username>"),
}


def main() -> None:
    args = sys.argv[1:]

    if not args or args[0] in ("-h", "--help"):
        print(__doc__)
        sys.exit(0)

    command = args[0]
    if command not in COMMANDS:
        _die(f"Unknown command: '{command}'. Available: {', '.join(COMMANDS)}")

    fn, min_args, usage = COMMANDS[command]

    # 'comment' allows extra words: join everything after task-id into message
    if command == "comment":
        if len(args) < min_args:
            _die(f"Usage: clickup {command} {usage}")
        fn(args[1], " ".join(args[2:]))
    else:
        if len(args) < min_args:
            _die(f"Usage: clickup {command} {usage}")
        fn(*args[1:min_args])


if __name__ == "__main__":
    main()
