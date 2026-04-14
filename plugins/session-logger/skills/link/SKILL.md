---
name: link
description: Link this plugin to your Trace account using a code from the web app
---

Link this plugin to a Trace account. The user should provide a link code as an argument.

If no code was provided in "$ARGUMENTS", ask the user for their link code. They can generate one at https://trace-web-app.fly.dev/link

Once you have the code, run this command to link:

```bash
# Read user_id from the canonical location, with fallbacks for older installs
if [ -f "${HOME}/.trace/user-id" ]; then
  PLUGIN_USER_ID=$(cat "${HOME}/.trace/user-id")
elif [ -f "${CURSOR_PLUGIN_DATA:-/dev/null}/session-logger-user-id" ]; then
  PLUGIN_USER_ID=$(cat "${CURSOR_PLUGIN_DATA}/session-logger-user-id")
elif [ -f "${HOME}/.cursor/session-logger-user-id" ]; then
  PLUGIN_USER_ID=$(cat "${HOME}/.cursor/session-logger-user-id")
else
  PLUGIN_USER_ID=""
fi

if [ -z "$PLUGIN_USER_ID" ]; then
  echo "ERROR: No plugin user ID found. Run a session first to generate one, then try linking again."
  exit 1
fi

curl -s -X POST https://trace-web-app.fly.dev/api/link/claim \
  -H "Content-Type: application/json" \
  -d "{\"code\": \"$ARGUMENTS\", \"plugin_user_id\": \"$PLUGIN_USER_ID\"}"
```

If the response contains "Linked successfully" or "Already linked":

1. Tell the user their account is linked and new Cursor sessions will appear in their Trace dashboard at https://trace-web-app.fly.dev/dashboard automatically.

2. Then check for past Cursor sessions. Try the common paths:

   ```bash
   PAST_COUNT=0
   for DIR in "${HOME}/.cursor/sessions" "${HOME}/.cursor/chats" "${HOME}/.cursor/transcripts" "${HOME}/Library/Application Support/Cursor/User/globalStorage/transcripts"; do
     if [ -d "$DIR" ]; then
       COUNT=$(find "$DIR" -type f -name "*.jsonl" 2>/dev/null | wc -l | tr -d ' ')
       PAST_COUNT=$((PAST_COUNT + COUNT))
     fi
   done
   echo "Found $PAST_COUNT past Cursor transcripts"
   ```

3. If past transcripts exist, ask the user: *"You have N past Cursor sessions on this machine. Would you like to upload them to Trace too? They'll go through the same PII redaction. (y/n)"*

4. If they say yes, start the backfill in the background:

   ```bash
   nohup "${CURSOR_PLUGIN_ROOT}/bin/backfill-transcripts" > /dev/null 2>&1 &
   echo "Backfill started. Progress at ~/.trace/backfill-cursor.log"
   ```

   Tell them it paces at ~1 session/second and they can monitor with `tail -f ~/.trace/backfill-cursor.log`, and that they can always trigger it later with `/session-logger:import-past`.

5. If no past transcripts were found, note that their Cursor version may store transcripts in a non-standard location — they can still set `CURSOR_TRANSCRIPT_DIR=/path/to/dir` and run `/session-logger:import-past` later.

If the response contains an error, show the error message and suggest they generate a new code at https://trace-web-app.fly.dev/link
