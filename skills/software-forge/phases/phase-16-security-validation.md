# Phase 16: Security Validation

**Applies to:** Full-Stack, Voice, Edge/IoT+ML, Mobile (with backend)
**Invoke:** `/security-audit` and/or `/web-app-security-audit`

Run BEFORE deployment. Verify that security-by-design decisions from Phase 3 were actually implemented.

**For Edge/IoT projects, additionally verify:**
- Device certificates: valid, unique per device, rotation scheduled
- MQTT topic security: devices can only publish to their own topics
- Firmware integrity: signed updates, verified on device
- Physical security: what credentials are on the device if someone steals it?

**Output:** Security audit report
