import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// ---------------------------------------------------------------------------
// Auth
// ---------------------------------------------------------------------------

const PAT = process.env.AIRTABLE_PAT;
if (!PAT) {
  console.error("Error: AIRTABLE_PAT environment variable is required.");
  console.error("Set it in your MCP client config (see README.md).");
  process.exit(1);
}

// ---------------------------------------------------------------------------
// HTTP helpers
// ---------------------------------------------------------------------------

const BASE_URL = "https://api.airtable.com";

async function airtableGet(path: string, params?: Record<string, string>) {
  const url = new URL(`${BASE_URL}${path}`);
  if (params) {
    for (const [key, value] of Object.entries(params)) {
      if (value !== undefined && value !== "") url.searchParams.set(key, value);
    }
  }

  const res = await fetch(url.toString(), {
    headers: { Authorization: `Bearer ${PAT}` },
  });

  const body = await res.json();

  if (!res.ok) {
    const message =
      (body as { error?: { message?: string } }).error?.message ??
      res.statusText;
    throw new Error(`Airtable API error ${res.status}: ${message}`);
  }

  return body;
}

async function airtablePatch(path: string, payload: object) {
  const res = await fetch(`${BASE_URL}${path}`, {
    method: "PATCH",
    headers: {
      Authorization: `Bearer ${PAT}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(payload),
  });

  const body = await res.json();

  if (!res.ok) {
    const message =
      (body as { error?: { message?: string } }).error?.message ??
      res.statusText;
    throw new Error(`Airtable API error ${res.status}: ${message}`);
  }

  return body;
}

function ok(data: unknown) {
  return {
    content: [{ type: "text" as const, text: JSON.stringify(data, null, 2) }],
  };
}

function err(error: unknown) {
  const message = error instanceof Error ? error.message : String(error);
  return {
    content: [{ type: "text" as const, text: `Error: ${message}` }],
    isError: true,
  };
}

// ---------------------------------------------------------------------------
// MCP server
// ---------------------------------------------------------------------------

const server = new McpServer({ name: "airtable", version: "1.0.0" });

// ------------------------------------------------------------------
// list_bases — discover which bases the PAT can access
// ------------------------------------------------------------------
server.registerTool(
  "list_bases",
  {
    title: "List Airtable Bases",
    description:
      "Returns all Airtable bases accessible with your Personal Access Token. " +
      "Use this to find a base ID (looks like appXXXXXXXX) before querying records.",
  },
  async () => {
    try {
      const data = await airtableGet("/v0/meta/bases");
      return ok(data);
    } catch (e) {
      return err(e);
    }
  }
);

// ------------------------------------------------------------------
// list_tables — see tables inside a base
// ------------------------------------------------------------------
server.registerTool(
  "list_tables",
  {
    title: "List Tables in a Base",
    description:
      "Returns all tables in an Airtable base, including their field schemas. " +
      "Use this to find table IDs/names and understand the available fields.",
    inputSchema: {
      baseId: z.string().describe("Airtable base ID (e.g. appXXXXXXXX)"),
    },
  },
  async ({ baseId }) => {
    try {
      const data = await airtableGet(`/v0/meta/bases/${baseId}/tables`);
      return ok(data);
    } catch (e) {
      return err(e);
    }
  }
);

// ------------------------------------------------------------------
// list_records — paginated record retrieval
// ------------------------------------------------------------------
server.registerTool(
  "list_records",
  {
    title: "List Records from a Table",
    description:
      "Retrieves records from an Airtable table. Returns up to 100 records per call. " +
      "If the response includes an 'offset' value, pass it back to get the next page.",
    inputSchema: {
      baseId: z.string().describe("Airtable base ID (e.g. appXXXXXXXX)"),
      tableId: z
        .string()
        .describe("Table ID (e.g. tblXXXXXXXX) or exact table name"),
      pageSize: z
        .number()
        .int()
        .min(1)
        .max(100)
        .default(100)
        .describe("Number of records to return (1–100, default 100)"),
      offset: z
        .string()
        .optional()
        .describe(
          "Pagination token from a previous list_records response. Omit for the first page."
        ),
    },
  },
  async ({ baseId, tableId, pageSize, offset }) => {
    try {
      const params: Record<string, string> = { pageSize: String(pageSize) };
      if (offset) params.offset = offset;
      const data = await airtableGet(`/v0/${baseId}/${tableId}`, params);
      return ok(data);
    } catch (e) {
      return err(e);
    }
  }
);

// ------------------------------------------------------------------
// get_record — fetch a single record by ID
// ------------------------------------------------------------------
server.registerTool(
  "get_record",
  {
    title: "Get a Single Record",
    description:
      "Fetches a specific Airtable record by its record ID. " +
      "Returns the record's fields and metadata.",
    inputSchema: {
      baseId: z.string().describe("Airtable base ID (e.g. appXXXXXXXX)"),
      tableId: z
        .string()
        .describe("Table ID (e.g. tblXXXXXXXX) or exact table name"),
      recordId: z.string().describe("Record ID (e.g. recXXXXXXXX)"),
    },
  },
  async ({ baseId, tableId, recordId }) => {
    try {
      const data = await airtableGet(`/v0/${baseId}/${tableId}/${recordId}`);
      return ok(data);
    } catch (e) {
      return err(e);
    }
  }
);

// ------------------------------------------------------------------
// update_record — update one or more fields on a record
// ------------------------------------------------------------------
server.registerTool(
  "update_record",
  {
    title: "Update a Record",
    description:
      "Updates one or more fields on an existing Airtable record. " +
      "Only the fields you provide will be changed — other fields are untouched. " +
      'Example fields object: {"Status": "Done", "Notes": "Reviewed on Monday"}',
    inputSchema: {
      baseId: z.string().describe("Airtable base ID (e.g. appXXXXXXXX)"),
      tableId: z
        .string()
        .describe("Table ID (e.g. tblXXXXXXXX) or exact table name"),
      recordId: z.string().describe("Record ID (e.g. recXXXXXXXX)"),
      fields: z
        .record(z.unknown())
        .describe(
          "Fields to update as a JSON object. Keys are field names, values are the new values. " +
            'Example: {"Status": "In Review", "Notes": "Updated by MCP"}'
        ),
    },
  },
  async ({ baseId, tableId, recordId, fields }) => {
    try {
      const data = await airtablePatch(`/v0/${baseId}/${tableId}/${recordId}`, {
        fields,
      });
      return ok(data);
    } catch (e) {
      return err(e);
    }
  }
);

// ------------------------------------------------------------------
// search_records — filter records with an Airtable formula
// ------------------------------------------------------------------
server.registerTool(
  "search_records",
  {
    title: "Search Records by Formula",
    description:
      "Finds records matching an Airtable filter formula. " +
      "Use Airtable formula syntax, e.g.: {Status} = 'In Progress' or SEARCH('keyword', {Notes}). " +
      "Returns matching records (up to pageSize).",
    inputSchema: {
      baseId: z.string().describe("Airtable base ID (e.g. appXXXXXXXX)"),
      tableId: z
        .string()
        .describe("Table ID (e.g. tblXXXXXXXX) or exact table name"),
      filterByFormula: z
        .string()
        .describe(
          "Airtable formula to filter records. " +
            "Examples: {Status} = 'Done'  |  AND({Assignee} = 'Alice', {Priority} = 'High')  |  SEARCH('bug', {Title})"
        ),
      pageSize: z
        .number()
        .int()
        .min(1)
        .max(100)
        .default(100)
        .describe("Max records to return (1–100, default 100)"),
    },
  },
  async ({ baseId, tableId, filterByFormula, pageSize }) => {
    try {
      const data = await airtableGet(`/v0/${baseId}/${tableId}`, {
        filterByFormula,
        pageSize: String(pageSize),
      });
      return ok(data);
    } catch (e) {
      return err(e);
    }
  }
);

// ---------------------------------------------------------------------------
// Start
// ---------------------------------------------------------------------------

const transport = new StdioServerTransport();
await server.connect(transport);
