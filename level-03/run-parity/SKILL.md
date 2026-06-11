---
name: run-parity
description: Runs parity tests on a template path. Use when the user asks to "run parity", "test parity", or "validate" a template, with or without a specific path.
---
# Run Parity

## Overview

Parity is a visual regression test that renders a template using its payload and compares the output against a known-good baseline. It confirms a template is production-ready.

## How to run

From the `templates/` directory:

```bash
PARITY_FILTER="<path/to/template>" npm run parity
```

## Steps

1. **Extract the template path** from the user's message (e.g., `_examples/campaign_starter/email`, `test/sandbox/matt-lucas/my-campaign`).
   - If no path is provided, ask: "Which template path should I run parity on?"
   - The path should be relative to the `templates/` directory.

2. **Run the command:**
   ```bash
   PARITY_FILTER="<template_path>" npm run parity
   ```

3. **Report the result:**
   - If parity passes → confirm success to the user.
   - If parity fails → share the failure output and offer to investigate.

## Note on running without a filter

When run without `PARITY_FILTER`, the script (`bin/parity-test-changed-only.sh`) auto-detects changed templates by diffing against `origin/master` and runs parity only on those. Always pass `PARITY_FILTER` explicitly when targeting a specific template.
