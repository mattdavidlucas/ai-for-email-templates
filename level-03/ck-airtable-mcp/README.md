# Airtable MCP Server

An MCP (Model Context Protocol) server that lets you read and update Airtable records directly from **Cursor** or **Claude Desktop**. Use natural language to query tables, inspect records, and update fields like Status or Notes — no manual API calls needed.

---

## What it does

| Tool | Description |
|------|-------------|
| `list_bases` | Discover all Airtable bases your token can access |
| `list_tables` | See all tables and their field schemas in a base |
| `list_records` | Retrieve records from a table (paginated, up to 100 per call) |
| `get_record` | Fetch a single record by ID |
| `update_record` | Update one or more fields on a record |
| `search_records` | Filter records using an Airtable formula |

---

## Prerequisites

- **Node.js 18 or later** — [download here](https://nodejs.org)
- An **Airtable Personal Access Token** with the correct scopes (see below)

---

## Step 1 — Create a Personal Access Token

1. Go to [airtable.com/create/tokens](https://airtable.com/create/tokens)
2. Click **Create new token**
3. Give it a name (e.g. `cursor-mcp`)
4. Add these **scopes**:
   - `data.records:read` — read records
   - `data.records:write` — update records
   - `schema.bases:read` — list bases and tables
5. Under **Access**, choose the specific bases you want to allow (recommended), or select all bases
6. Click **Create token** and copy the token — you won't see it again

> **Keep your token private.** Do not commit it to git or share it in Slack. Store it only in your MCP config file (see Step 3).

---

## Step 2 — Install & Build

Clone or download this repo, then install dependencies and compile:

```bash
cd ck-airtable-mcp
npm install
npm run build
```

This creates a `dist/` folder with the compiled server. You'll point your MCP client at `dist/index.js`.

---

## Step 3 — Configure Your MCP Client

You need to tell Cursor or Claude Desktop where the server is and pass your PAT as an environment variable.

### Cursor

Edit (or create) `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "airtable": {
      "command": "node",
      "args": ["/absolute/path/to/ck-airtable-mcp/dist/index.js"],
      "env": {
        "AIRTABLE_PAT": "your_personal_access_token_here"
      }
    }
  }
}
```

Replace `/absolute/path/to/ck-airtable-mcp` with the actual path on your machine (e.g. `/Users/yourname/Sites/ck-airtable-mcp`).

Then **restart Cursor**. You should see "airtable" appear in the MCP servers list in Cursor settings.

### Claude Desktop

Edit `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or `%APPDATA%\Claude\claude_desktop_config.json` (Windows):

```json
{
  "mcpServers": {
    "airtable": {
      "command": "node",
      "args": ["/absolute/path/to/ck-airtable-mcp/dist/index.js"],
      "env": {
        "AIRTABLE_PAT": "your_personal_access_token_here"
      }
    }
  }
}
```

Then **restart Claude Desktop**.

---

## Step 4 — Verify it works

In Cursor or Claude, ask:

> "List my Airtable bases"

You should get a JSON list of bases with their names and IDs. If you see an error, check:
- The path in `args` is correct and absolute
- Your PAT is valid and has the right scopes
- You ran `npm run build` and the `dist/` folder exists

---

## Usage Examples

Once connected, you can ask questions like:

**Exploring your data:**
- "List my Airtable bases"
- "Show me the tables in base appXXXXXXXX"
- "List records from the Tasks table in base appXXXXXXXX"
- "Get record recXXXXXXXX from the Projects table"

**Searching:**
- "Find all records in Tasks where Status is 'In Progress'"
- "Search for records where the Assignee field is 'Alice'"
- "Show me high-priority items in the Backlog table"

**Updating:**
- "Update record recXXXXXXXX in the Tasks table — set Status to 'Done'"
- "Add a note to record recXXXXXXXX: 'Reviewed and approved'"
- "Mark record recXXXXXXXX as complete"

---

## Tool Reference

### `list_bases`
Returns all bases your PAT can access.

No parameters.

---

### `list_tables`
Returns all tables in a base, including field names and types.

| Parameter | Type | Description |
|-----------|------|-------------|
| `baseId` | string | Base ID, e.g. `appXXXXXXXX` |

---

### `list_records`
Returns records from a table. If there are more than `pageSize` records, the response includes an `offset` value — pass it back in a second call to get the next page.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `baseId` | string | — | Base ID |
| `tableId` | string | — | Table ID or exact table name |
| `pageSize` | number | 100 | Records per page (1–100) |
| `offset` | string | — | Pagination token from a previous response |

---

### `get_record`
Returns a single record by ID.

| Parameter | Type | Description |
|-----------|------|-------------|
| `baseId` | string | Base ID |
| `tableId` | string | Table ID or name |
| `recordId` | string | Record ID, e.g. `recXXXXXXXX` |

---

### `update_record`
Updates fields on a record. Only the fields you specify are changed.

| Parameter | Type | Description |
|-----------|------|-------------|
| `baseId` | string | Base ID |
| `tableId` | string | Table ID or name |
| `recordId` | string | Record ID |
| `fields` | object | Fields to update, e.g. `{"Status": "Done", "Notes": "text"}` |

---

### `search_records`
Returns records matching an Airtable filter formula.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `baseId` | string | — | Base ID |
| `tableId` | string | — | Table ID or name |
| `filterByFormula` | string | — | Airtable formula, e.g. `{Status} = 'Done'` |
| `pageSize` | number | 100 | Max records to return (1–100) |

**Formula examples:**
```
{Status} = 'In Progress'
AND({Assignee} = 'Alice', {Priority} = 'High')
SEARCH('keyword', {Notes})
NOT({Done})
```

---

## Troubleshooting

**"AIRTABLE_PAT environment variable is required"**
The server started without the env variable. Check your MCP config has the `env` block with `AIRTABLE_PAT`.

**"Airtable API error 403"**
Your PAT doesn't have permission for that base or scope. Check the token's scopes and access settings at [airtable.com/create/tokens](https://airtable.com/create/tokens).

**"Airtable API error 404"**
The base ID, table ID, or record ID doesn't exist or your token can't access it.

**Tools don't appear in Cursor/Claude**
Make sure you ran `npm run build`, the `dist/index.js` file exists, and you restarted the client after editing the config.

---

## Development

```bash
# Watch mode — recompiles on file changes
npm run dev

# Manual build
npm run build
```

The entire server is in `src/index.ts`. All 6 tools are defined there alongside two small HTTP helpers (`airtableGet` and `airtablePatch`).
