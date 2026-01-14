# DeepGruble MCP Server Standards

Org-wide MCP (Model Context Protocol) server definitions.

## Org-Wide Servers

| Server   | Purpose                              |
| -------- | ------------------------------------ |
| `github` | GitHub API (issues, PRs, code search) |

## Project-Specific Servers

Projects can add their own MCP servers by creating:
```
.deepgruble/mcp/servers.json
```

Common project-specific servers:
- `shadcn` - shadcn/ui component installation
- `next-devtools` - Next.js development tools

## Usage

Run the sync script from your project directory:

```bash
/path/to/.github/.deepgruble/mcp/sync-mcp.sh /path/to/project
```

This merges org-wide and project-specific configs into:
- `.mcp.json` (Claude Code)
- `.cursor/mcp.json` (Cursor)

## Environment Variables

```bash
export MCP_GITHUB_TOKEN="your-github-personal-access-token"
```
