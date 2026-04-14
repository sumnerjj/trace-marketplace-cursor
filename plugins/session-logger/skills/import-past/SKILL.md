---
name: import-past
description: Upload past Cursor session transcripts from this machine to Trace
---

Upload historical session transcripts from Cursor to Trace. Runs the same PII redaction as live captures.

The script checks several candidate directories for Cursor transcripts:
- `~/.cursor/sessions/`
- `~/.cursor/chats/`
- `~/.cursor/transcripts/`
- `~/Library/Application Support/Cursor/User/globalStorage/transcripts/`

First, kick off the backfill — the script will report how many transcripts it finds (or tell you if none of the candidate paths have `.jsonl` files):

```bash
nohup "${CURSOR_PLUGIN_ROOT}/bin/backfill-transcripts" > /dev/null 2>&1 &
echo "Backfill started (PID $!)"
```

Tell the user:
- Progress log: `tail -f ~/.trace/backfill-cursor.log`
- If no transcripts are found, they can set `CURSOR_TRANSCRIPT_DIR=/path/to/transcripts` and re-run — the script honors that env var as a fallback
- Already-uploaded sessions skipped automatically
- Safe to re-run
