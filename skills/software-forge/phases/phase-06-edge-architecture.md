# Phase 6: Edge Architecture Design

**Applies to:** Edge/IoT+ML
**Source:** IoT architecture patterns, *Release It!* edge extensions
**Output:** Edge architecture section appended to system design doc

### Questions to Ask

**Device Constraints:**
1. What hardware? (CPU, GPU, RAM, storage, connectivity)
2. Power source? (battery, vehicle power, mains)
3. Physical environment? (temperature range, vibration, dust, moisture)
4. What sensors? (cameras, GPS, accelerometer, etc.)

**Offline-First Design:**
5. Expected connectivity patterns? (always-on, intermittent, shift-based)
6. Maximum offline duration to survive? (hours, days)
7. Local queue strategy? (SQLite, file queue, memory buffer)
8. Queue overflow policy? (oldest-first eviction, priority-based, compress)
9. Sync strategy on reconnect? (batch upload, priority queue, bandwidth-aware)

**Resource Budgeting:**
10. CPU/GPU budget split? (inference %, upload %, logging %, OS overhead %)
11. Memory budget? (model size + working memory + queue + buffers)
12. Storage budget? (model files + offline queue + logs + OS)
13. Bandwidth budget? (payload size x frequency x fleet size = daily data volume)
14. Frame rate vs accuracy trade-off? (every frame, 1/sec, triggered)

**Fleet Management:**
15. How many devices? Current and projected?
16. Device provisioning workflow? (certificate issuance, registration, initial config)
17. OTA update strategy? (Greengrass, custom, staged rollout %)
18. Health monitoring? (heartbeat interval, metrics reported, alerting thresholds)
19. Decommissioning? (certificate revocation, data cleanup)

### Deliverable

```markdown
## Edge Architecture

### Device Profile
- Hardware: [Specs]
- Constraints: [Power, connectivity, environment]
- Sensors: [List with interfaces]

### Offline Strategy
- Queue: [Technology, max size, overflow policy]
- Sync: [Strategy, priority]
- Max Offline Duration: [Hours/days]

### Resource Budget
| Resource | Budget | Allocation |
|----------|--------|------------|
| CPU/GPU | 100% | Inference %, Upload %, Other % |
| RAM | [Size] | Model %, Queue %, OS % |
| Storage | [Size] | Models %, Queue %, Logs % |
| Bandwidth | [Daily] | Detections %, Telemetry %, Updates % |

### Fleet Management
- Fleet Size: [Current -> Projected]
- Provisioning: [Workflow]
- OTA Updates: [Strategy, rollout %]
- Health Monitoring: [Metrics, intervals, alerts]

### Decision Log — Phase 6: Edge Architecture
- **[Topic]:** Chose [X] over [Y] because [reasoning].
- **Rejected:** [Alternative] — [why it was rejected].
- **User correction:** [If the user corrected a direction, capture what changed and why].
```
