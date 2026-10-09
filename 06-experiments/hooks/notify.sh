#!/bin/sh
# Notification hook: show a native OS alert with Claude Code's message.
# Reads the hook's JSON payload on stdin and uses the "message" field if present.

# Add this to your .claude/settings.json to enable the notification hook:
# {
#   "hooks": {
#     "Notification": [
#       {
#         "matcher": "",
#         "hooks": [
#           {
#             "type": "command",
#             "command": "sh \"${CLAUDE_PROJECT_DIR}/.claude/hooks/notify.sh\""
#           }
#         ]
#       }
#     ]
#   }
# }


title="Claude Code"
msg=$(sed -n 's/.*"message"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)
[ -n "$msg" ] || msg="Claude Code is waiting for you"

case "$(uname -s)" in
  Darwin)
    osascript -e 'on run argv' \
      -e 'display notification (item 2 of argv) with title (item 1 of argv)' \
      -e 'end run' "$title" "$msg"
    ;;
  Linux)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send "$title" "$msg"
    else
      printf '\a' > /dev/tty 2>/dev/null
    fi
    ;;
  MINGW* | MSYS* | CYGWIN*)
    # Windows toast via built-in WinRT APIs (no extra modules). Text is passed via env vars to avoid quoting issues.
    NOTIFY_TITLE="$title" NOTIFY_MSG="$msg" powershell.exe -NoProfile -NonInteractive -Command '
      [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
      $xml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
      $t = $xml.GetElementsByTagName("text")
      $t.Item(0).AppendChild($xml.CreateTextNode($env:NOTIFY_TITLE)) | Out-Null
      $t.Item(1).AppendChild($xml.CreateTextNode($env:NOTIFY_MSG)) | Out-Null
      $appId = "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe"
      [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show([Windows.UI.Notifications.ToastNotification]::new($xml))
    '
    ;;
esac

exit 0
