# Notification hook

Show a native desktop notification when Claude Code sends a notification. The alert uses the message from the hook payload, or a fallback message if none is provided. Supports macOS, Linux, and Windows; on Linux, it uses a terminal bell when `notify-send` is unavailable.

Add this to your `.claude/settings.json` to enable the notification hook:

```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "sh \"${CLAUDE_PROJECT_DIR}/.claude/hooks/notify.sh\""
          }
        ]
      }
    ]
  }
}
```

Add `notify.sh` to your `.claude/hooks` folder.
