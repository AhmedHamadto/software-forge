# Recommended MCP Servers & Skills

Software Forge works without any external tools. Every phase falls
back to a question-based approach grounded in engineering books.
These free tools enhance specific phases when available.

## Phase-to-Tool Mapping

| Phase | Tool | Type | What It Adds | Install |
|-------|------|------|-------------|---------|
| 10 UI Design | Figma MCP (official) | MCP | Pull real design tokens | `claude mcp add --transport http figma https://mcp.figma.com/mcp` |
| 10 UI Design | rshankras/claude-code-apple-skills | Skills | 100+ iOS/macOS skills (deep companion for iOS projects) | `npx add-skill rshankras/claude-code-apple-skills` |
| 12 Motion Design | Design Motion Principles | Skill | Three-lens motion audit (Kowalski/Krehel/Tompkins) | `git clone ... && cp -r skills/* ~/.claude/skills/` |
| 12 Motion Design | Motion AI Kit | MCP+Skills | 330+ examples, /motion-audit, perf classification | motion.dev/docs/ai-kit (Motion+, one-time payment) |
| 15 Implementation | Context7 | MCP | Current library docs (not stale training data) | `claude mcp add context7 -- npx -y @context7/mcp` |
| 15 Implementation | typescript-lsp | Plugin | Real type checking, go-to-definition | `claude plugin install typescript-lsp@claude-plugins-official` |
| 16 Security | Trail of Bits skills | Skills | Security research, vulnerability detection | `npx add-skill trailofbits/skills` |
| 16 Security | claude-code-owasp | Skill | OWASP Top 10:2025, ASVS 5.0, 20+ language quirks | `github.com/agamm/claude-code-owasp` |
| 16 Security | security-guidance | Plugin | Passive vulnerability scanning | `claude plugin install security-guidance@claude-plugins-official` |
| 19 Polish | Built-in /simplify | Bundled | Three-agent parallel code review (built into Claude Code) | Already available — just type /simplify |

## Creative Tools (Optional)

| Tool | Type | What It Does | Install |
|------|------|-------------|---------|
| Blender MCP | MCP | AI-controlled 3D modeling | `claude mcp add blender -- uvx blender-mcp` |
| Spline MCP | MCP | Interactive 3D web experiences | github.com/aydinfer/spline-mcp-server |
| GSAP MCP | MCP | Scroll/timeline/path animations | github.com/guptaanant682/infi_gsap_mcp |

## How Software Forge Uses These

Software Forge checks for available tools at the start of design phases.
If a relevant MCP or skill is connected, it uses it. If not, it falls
back to the book-grounded question-based approach. You never need any
of these to get full value from Software Forge.
