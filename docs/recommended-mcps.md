# Recommended MCP Servers & Skills

Software Forge works without any external tools. Every phase falls
back to a question-based approach grounded in engineering books.
However, these free tools dramatically enhance specific phases
when available.

## Phase-to-Tool Mapping

| Phase | Tool | Type | What It Adds | Install |
|-------|------|------|-------------|---------|
| 10 UI Design | Figma MCP (official) | MCP | Pull real design tokens, components, layout | `claude mcp add --transport http figma https://mcp.figma.com/mcp` |
| 12 Motion Design | Design Motion Principles | Skill | Three-lens motion audit (Kowalski/Krehel/Tompkins) | `cp -r design-motion-principles/skills/* ~/.claude/skills/` |
| 12 Motion Design | Motion AI Kit | MCP+Skills | 330+ examples, /motion-audit, perf classification | motion.dev/docs/ai-kit (requires Motion+, one-time payment) |
| 15 Implementation | Context7 | MCP | Current library docs (not stale training data) | `claude mcp add context7 -- npx -y @context7/mcp` |
| 15 Implementation | typescript-lsp | Plugin | Real type checking, go-to-definition | `claude plugin install typescript-lsp@claude-plugins-official` |
| 16 Security | security-guidance | Plugin | Passive vulnerability scanning during coding | `claude plugin install security-guidance@claude-plugins-official` |
| 19 Polish | ui-polish-review (built-in) | Skill | Already included in Software Forge | — |
| 19 Polish | ux-usability-review (built-in) | Skill | Already included in Software Forge | — |

## Creative Tools (Optional)

| Tool | Type | What It Does | Install |
|------|------|-------------|---------|
| Blender MCP | MCP | AI-controlled 3D modeling, scene creation | `claude mcp add blender -- uvx blender-mcp` |
| Spline MCP | MCP | Interactive 3D web experiences | github.com/aydinfer/spline-mcp-server |
| GSAP MCP | MCP | Advanced scroll/timeline/path animations | github.com/guptaanant682/infi_gsap_mcp |

## How Software Forge Uses These

Software Forge checks for available tools at the start of each
design phase. If a relevant MCP or skill is connected, it uses
it to accelerate the phase. If not, it falls back to the book-
grounded question-based approach. You never need any of these
to get full value from Software Forge.
