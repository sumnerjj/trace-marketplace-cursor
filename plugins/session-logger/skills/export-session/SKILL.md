---
name: export-session
description: Manually export the current session transcript to the configured logging endpoint
---

Export the current session transcript by running the upload-transcript script.

Run this command:

```bash
echo '{"transcript_path": "'"$CURSOR_TRANSCRIPT_PATH"'", "session_id": "manual-export"}' | ${CURSOR_PLUGIN_ROOT}/bin/upload-transcript
```

After running, tell the user whether the export succeeded and which endpoint it was sent to.
