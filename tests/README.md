# Tests

Software Forge skills are prompt-based — they contain instructions, not executable code. Testing is done by:

1. **Install verification**: `./install.sh --list` confirms all skills are discoverable
2. **Manual testing**: Invoke each skill in Claude Code and verify the procedure runs correctly
3. **Regression testing**: After changes, re-run affected skills against a sample project

Automated test infrastructure for validating skill outputs is planned. Contributions welcome — see [CONTRIBUTING.md](../CONTRIBUTING.md).
