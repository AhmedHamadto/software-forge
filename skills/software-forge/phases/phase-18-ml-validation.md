# Phase 18: ML Validation

**Applies to:** Edge/IoT+ML
**Source:** *Designing Machine Learning Systems* (Chip Huyen), *Reliable Machine Learning* (Cathy Chen et al.)
**Output:** ML validation report

### Validation Checklist

Run after implementation, before production deployment:

1. **Model Performance:**
   - Precision, recall, F1 on held-out test set
   - Performance per class (not just aggregate)
   - Performance on edge cases (night, rain, dust, unusual angles)
   - Latency on target hardware (not just dev machine)

2. **Data Quality:**
   - Label consistency audit (sample and re-label, measure agreement)
   - Data leakage check (training data contaminating test set)
   - Distribution shift check (training data vs production data)

3. **Robustness:**
   - Adversarial inputs (unusual lighting, occlusion, camera artifacts)
   - Out-of-distribution detection (does the model know when it doesn't know?)
   - Confidence calibration (does 90% confidence mean 90% accuracy?)

4. **Fairness & Bias:**
   - Performance across operating conditions (time of day, weather, road type)
   - False positive/negative rates across conditions
   - Are some environments systematically underrepresented?

5. **Operational Readiness:**
   - Model loads correctly on target hardware
   - Inference fits within resource budget (Phase 6)
   - Offline queue handles expected volume
   - Monitoring pipeline captures metrics correctly

### Deliverable

```markdown
## ML Validation Report

### Performance
| Metric | Overall | Class A | Class B | Edge Cases |
|--------|---------|---------|---------|------------|
| Precision | | | | |
| Recall | | | | |
| F1 | | | | |
| Latency (ms) | | | | |

### Data Quality
- Label Agreement: [%]
- Leakage Check: [Pass/Fail]
- Distribution Shift: [Within/Outside tolerance]

### Robustness
- Adversarial: [Results]
- OOD Detection: [Method, threshold]
- Calibration: [ECE score]

### Go/No-Go Decision
[Ready / Needs retraining / Needs more data]
```
