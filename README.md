# AI-Driven Email Production System

These are the scripts, Cursor rules and commands, and agent skills I built at Credit Karma (2025 to 2026) to turn marketing email and push message production from a manual, developer-only workflow into something a marketer could run in minutes.

The full story (why I built it, how it evolved, and what it changed for the team) lives on my site as a case study: **[Creating an AI-Driven Email Production System](https://mattdavidlucas.github.io/ai-driven-production-system)**.

This repo is just the artifacts, organized into the three stages described in the case study.

## What's here

### `level-01/` — Shell scripts (Gemini Enterprise era)

| File | What it does |
| --- | --- |
| [`gostarter.sh`](level-01/gostarter.sh) | Generates a net new marketing email (with optional push), cloning boilerplate and replacing placeholder campaign metadata |
| [`goclone.sh`](level-01/goclone.sh) | Clones an existing email or push and swaps in new campaign metadata |
| [`gosplit.sh`](level-01/gosplit.sh) | Splits a block of copy into individual numbered `.hbs` files for creative experiments |
| [`goreplace.sh`](level-01/goreplace.sh) | Find and replace across a campaign directory |
| [`litmus-qa.sh`](level-01/litmus-qa.sh) | Sends built HTML to Litmus via the Mailgun `messages` endpoint, which creates the test and posts it to Slack |

### `level-02/` — Cursor rules and commands

| File | What it does |
| --- | --- |
| [`rule-marketing_template_best_practices.md`](level-02/rule-marketing_template_best_practices.md) | Ruleset of do's and don'ts for marketing email templates |
| [`command-template_builder.md`](level-02/command-template_builder.md) | The main one: ingests a Google Doc, design specs, and campaign metadata, and outputs fully coded Handlebars and JSON emails |
| [`command-qa.md`](level-02/command-qa.md) | QA pass on a marketing email or push |
| [`command-parity_test.md`](level-02/command-parity_test.md) | Runs the build command in an interactive Terminal inside Cursor's chat |
| [`command-cleanup_html.md`](level-02/command-cleanup_html.md), [`command-cleanup_text.md`](level-02/command-cleanup_text.md), [`command-json_array.md`](level-02/command-json_array.md) | Formatting utilities |
| [`ck-email-module-samples/`](level-02/ck-email-module-samples/) | Sample `.hbs` modules generated with Plan Mode and the Figma MCP |

### `level-03/` — Claude Code agent skills and MCP

| Directory | What it does |
| --- | --- |
| [`template-builder/`](level-03/template-builder) | Skill version of the Cursor template builder, with `references` and `scripts` giving the agent full context on build process and standards |
| [`template-qa/`](level-03/template-qa) | Skill version of the QA command, with much deeper context on QA standards |
| [`run-parity/`](level-03/run-parity) | Runs the build command |
| [`email-design-to-template/`](level-03/email-design-to-template) | Unfinished. Intended to map our Figma Email Design System to repo components so a user could drop in a PNG of a design and get a coded email. Initial testing was promising |
| [`ck-airtable-mcp/`](level-03/ck-airtable-mcp) | TypeScript MCP server for pulling email template request details from Airtable during an agent chat |
