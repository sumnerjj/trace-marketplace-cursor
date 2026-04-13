# Trace Marketplace (Cursor)

A Cursor plugin that automatically uploads session transcripts to Supabase. Share your coding sessions so we can review what went wrong and build better tools.

## Install

One-liner:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/sumnerjj/trace-marketplace-cursor/main/install.sh)
```

Or manually:

```bash
git clone https://github.com/sumnerjj/trace-marketplace-cursor ~/.cursor/plugins/local/session-logger
```

Reload Cursor after installing (Developer: Reload Window).

## How it works

Once installed, the plugin runs in the background. When a session ends, it uploads the full transcript to Supabase via a `sessionEnd` hook. Each session is stored as a single row, updated in place.

The Cursor version also captures:
- **User email** (from Cursor login, for account linking)
- **Session duration** (milliseconds)
- **Platform tag** (`cursor`)

All transcripts are PII-redacted before upload — emails, usernames, and file paths are scrubbed.

## Debug

Check the log at `~/.cursor/session-logger.log` to verify uploads are working.

## Plugin structure

```
plugins/session-logger/
├── .cursor-plugin/
│   └── plugin.json         # Manifest
├── hooks.json              # sessionEnd hook for auto-upload
├── bin/
│   ├── upload-transcript   # Upload script (curl-based)
│   └── redact-pii          # PII redaction filter
└── skills/
    └── export-session/
        └── SKILL.md        # Manual export skill
```
