# Phase 5: ML Pipeline Design

**Applies to:** Edge/IoT+ML
**Source:** *Designing Machine Learning Systems* (Chip Huyen)
**Output:** ML pipeline doc at `docs/plans/YYYY-MM-DD-<topic>-ml-pipeline.md`

### Questions to Ask

**Data Pipeline:**
1. What is the training data source? (labeled images, sensor data, logs)
2. How is data labeled? (manual, semi-automated, active learning)
3. What is the labeling quality control process?
4. Data versioning strategy? (DVC, S3 versioning, git-lfs)
5. Class imbalance — what's the distribution? Augmentation strategy?
6. Train/val/test split strategy? (random, temporal, geographic)

**Model Lifecycle:**
7. Model architecture selection criteria? (accuracy vs latency vs size)
8. Experiment tracking? (MLflow, W&B, spreadsheet)
9. Model versioning scheme? (dev/staging/prod, semver)
10. Export format for deployment? (ONNX, TensorRT, CoreML, .pt)
11. Model size budget? (edge device storage + memory constraints)

**Deployment & Serving:**
12. How does a new model reach production? (OTA, manual flash, staged rollout)
13. Canary deployment? (% of fleet on new model before full rollout)
14. Rollback strategy? (automatic on metric degradation, manual)
15. A/B testing — how do you compare model versions in production?

**Monitoring & Retraining:**
16. What metrics define model health? (precision, recall, F1, latency)
17. How is drift detected? (data drift, concept drift, prediction drift)
18. What triggers retraining? (metric threshold, scheduled, manual)
19. Human-in-the-loop feedback loop — how long from detection to retraining?
20. Cold start — what happens when the model encounters a new environment?

### Deliverable

```markdown
## ML Pipeline Design

### Data Pipeline
- Source: [Where training data comes from]
- Labeling: [Process, QC, tooling]
- Versioning: [Strategy]
- Splits: [Train/val/test ratios and strategy]

### Model Lifecycle
- Architecture: [Model, why chosen]
- Experiment Tracking: [Tool/process]
- Versioning: [Scheme]
- Export: [Format, size budget]

### Deployment
- Delivery: [OTA/manual, canary %]
- Rollback: [Trigger and process]

### Monitoring
- Health Metrics: [What to track]
- Drift Detection: [Method and thresholds]
- Retraining Trigger: [Conditions]
- Feedback Loop Latency: [Time from detection to retrained model deployed]
```
