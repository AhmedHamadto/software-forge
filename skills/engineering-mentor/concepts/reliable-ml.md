# Reliable Machine Learning (Cathy Chen et al.) — Teaching Content

## Validation

### Deep (first exposure)

A model that performs well on your test set might perform terribly in production, and the gap between offline evaluation and real-world performance is one of the central themes of this book. The authors dedicate their testing chapters to the discipline of validation — the systematic process of ensuring that a model actually works before, during, and after deployment. Validation is not a single metric on a holdout set; it is a multi-layered strategy that checks the data, the model, and the interaction between the model and real users.

Offline evaluation is the starting point. Precision, recall, and F1 are not interchangeable — the right metric depends on the cost of errors. In a spam filter, high precision (few false positives) matters because users hate losing legitimate email. In cancer screening, high recall (few false negatives) matters because missing a diagnosis is catastrophic. The authors stress that choosing the wrong offline metric means optimizing for the wrong thing, and no amount of training will fix that. Beyond aggregate metrics, you need to evaluate performance across slices: does the model work equally well for different user segments, input types, or edge cases? A model with 95% overall accuracy that fails completely on a minority class is not a 95%-good model — it is a model with a blind spot that will cause real harm.

Online evaluation bridges the gap between test set performance and production reality. A/B testing compares the new model against the current one on live traffic, measuring business metrics (conversion rate, engagement, revenue) rather than just statistical metrics. The authors warn that A/B tests require careful design: sufficient sample size, proper randomization, and awareness of novelty effects where users initially engage with anything new. Data quality audits run continuously in production, checking that incoming data matches the schema and distribution the model was trained on. Label consistency checks ensure that when human labels are used for retraining, the labeling criteria have not drifted from the original definitions. Data leakage detection verifies that features available during training are actually available at prediction time — a surprisingly common bug where a feature that perfectly predicts the outcome is only available after the fact.

Without rigorous validation at every layer, ML systems degrade in ways that are invisible until the damage is done. A model can be statistically excellent on paper and operationally harmful in practice. The authors argue that validation is not a phase of the project — it is a continuous process that runs alongside the model for its entire lifetime.

### Refresher (subsequent exposure)

Validation is a multi-layered, continuous process: choose offline metrics that match the cost of errors (precision vs. recall), evaluate across data slices not just aggregates, use A/B testing for online validation against business metrics, and run ongoing data quality audits, label consistency checks, and data leakage detection. A model is only as reliable as its validation strategy.

### Socratic Questions

- Your medical imaging model has 97% overall accuracy, but when a colleague evaluates it on images from a specific hospital's equipment, accuracy drops to 61%. Your aggregate test set did not reveal this. What validation practice would have caught this before deployment, and how would you structure your evaluation?
- You deploy a new recommendation model via A/B test and see a 20% increase in click-through rate in the first week. Your product manager wants to roll it out to 100% of users immediately. What concerns would you raise about this result, and what would you want to verify before full rollout?
- A feature in your training data called `time_since_resolution` perfectly predicts customer churn. The model achieves 99% accuracy in offline evaluation but performs no better than random in production. What likely happened, and how would you detect this type of problem systematically?

---

## Robustness

### Deep (first exposure)

A model that works well on clean, in-distribution data is not necessarily a reliable model. The reliability chapters of this book focus on robustness — the ability of an ML system to maintain acceptable performance when inputs are noisy, adversarial, or drawn from conditions the model has never seen. In production, inputs are never as clean as your test set. Users make typos, cameras capture blurry images, sensors malfunction, and bad actors deliberately craft inputs to fool your model. Robustness is not a nice-to-have; it is what separates a prototype from a production system.

Adversarial inputs are deliberately crafted to exploit model weaknesses. In image classification, imperceptible pixel perturbations can cause a model to confidently misclassify a stop sign as a speed limit sign. In NLP, subtle word substitutions can flip a sentiment model's prediction. The authors explain that adversarial robustness is not just an academic concern — it matters for any model that processes user-provided input, because users (or attackers) will eventually provide inputs that look nothing like your training data. Out-of-distribution (OOD) detection is the complementary concern: knowing when the model is being asked to make a prediction on input that is fundamentally different from anything it was trained on. A model trained on English text that receives Japanese input should not return a confident prediction — it should signal uncertainty. Confidence calibration ensures that when the model says it is 90% confident, it is actually correct 90% of the time. Overconfident predictions on unfamiliar inputs are dangerous because downstream systems and users treat high confidence as a signal to act without verification.

Fairness across operating conditions means the model should not silently degrade for certain populations, geographies, or edge cases. The authors describe how a facial recognition system that works well in controlled lighting fails disproportionately for darker skin tones in low-light conditions — not because of explicit bias in the training process, but because the training data under-represented that operating condition. Edge case performance requires dedicated testing: what happens when the input is empty, extremely long, contains special characters, or combines features in unusual ways? The authors advocate for structured robustness testing that systematically explores these boundaries rather than relying on random test samples that are unlikely to cover the corners where models fail.

Robust ML systems are designed with the assumption that reality will surprise you. The authors argue that building robustness in — through adversarial testing, OOD detection, calibrated confidence, fairness audits, and edge case suites — is far cheaper than discovering fragility in production through user complaints, safety incidents, or quiet performance degradation that erodes trust over months.

### Refresher (subsequent exposure)

Robustness means maintaining performance under adversarial inputs, out-of-distribution data, and edge cases. Build in OOD detection so the model signals uncertainty on unfamiliar inputs, calibrate confidence scores so they reflect actual accuracy, test systematically across operating conditions for fairness, and design adversarial and edge case test suites rather than relying on random samples.

### Socratic Questions

- Your text classification model is deployed in a customer support chatbot. A user discovers that adding the phrase "ignore previous instructions" to their message causes the model to misclassify every ticket as low priority. What robustness practices would have identified this vulnerability, and how would you defend against it?
- Your autonomous vehicle perception model was trained on data from California and performs well in testing. It is deployed to a fleet in Finland during winter. Accuracy on pedestrian detection drops significantly. What robustness concept explains this failure, and what would a robust deployment process have included?
- Your loan approval model reports 95% confidence on every prediction, whether it is clearly qualified applicants or edge cases the model has never seen before. Why is this a problem for the humans reviewing its recommendations, and what would a well-calibrated model look like?
