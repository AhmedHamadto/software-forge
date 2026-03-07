# Designing Machine Learning Systems (Chip Huyen) — Teaching Content

## Data Pipelines

### Deep (first exposure)

Most machine learning failures are data failures. Huyen makes this point emphatically in Chapters 4 and 5: the model is only as good as the data it trains on, and "garbage in, garbage out" is not a cliche — it is the single most common root cause of ML systems that underperform in production. Before you worry about model architecture or hyperparameter tuning, you need to get data collection, labeling, versioning, and splitting right. Each of these stages is a potential source of silent corruption that will not surface until your model is making bad predictions in front of real users.

Data collection and labeling are where bias enters the system. If your training data is collected from a source that over-represents certain demographics, your model inherits that skew. If labelers disagree on what constitutes a "positive" example and you do not measure inter-annotator agreement, your labels are noisy and your model is learning from inconsistency. Huyen emphasizes that data quality audits — checking for missing values, duplicate records, label distribution shifts, and annotation consistency — should be as rigorous as code reviews. Versioning your datasets (not just your code) is essential because you need to reproduce any past result and trace a bad prediction back to the data that caused it.

Consider a fraud detection model trained on transaction data. You split the data randomly into train, validation, and test sets. But transactions are time-ordered — a random split means your model sees future transactions during training and learns temporal patterns it will not have access to in production. This is data leakage, and it inflates your offline metrics dramatically. In production, the model underperforms and nobody understands why, because the test set metrics looked excellent. The correct approach is a temporal split: train on the past, validate on the near future, test on the further future. Similarly, if only 0.1% of transactions are fraudulent, naive training produces a model that predicts "not fraud" for everything and achieves 99.9% accuracy. Class imbalance strategies — oversampling, undersampling, class weights, or synthetic data generation — are not optional refinements; they are prerequisites for a model that actually detects fraud.

Without disciplined data pipelines, every downstream decision is built on a shaky foundation. Huyen's core argument is that ML engineering is primarily data engineering. The teams that invest in automated data validation, schema enforcement, label quality monitoring, and proper versioning ship reliable models. The teams that treat data as someone else's problem spend most of their time debugging model performance issues that are actually data issues.

### Refresher (subsequent exposure)

Data quality is the foundation of ML — collection bias, labeling inconsistency, improper train/test splits, and class imbalance cause more production failures than model architecture choices. Version your datasets alongside your code, use temporal splits for time-series data, and treat data validation with the same rigor as code review.

### Socratic Questions

- Your image classification model achieves 96% accuracy on the test set but performs poorly in production. You discover that the training images were all taken in studio lighting, while production images come from user phone cameras in varied conditions. What data pipeline practices would have caught this before deployment?
- You are building a content moderation model and your labeling team has an inter-annotator agreement rate of 62%. A colleague says this is fine because "the model will learn the average." Why is this reasoning dangerous, and what would you do before training?
- Your dataset has a 98/2 split between negative and positive examples. A junior engineer reports that the model achieves 98% accuracy and asks if it is ready for production. What questions would you ask, and what metrics would you look at instead?

---

## Model Lifecycle

### Deep (first exposure)

Training a model that works on a test set is the beginning of the work, not the end. Huyen devotes Chapters 6 through 9 to the lifecycle that follows: experiment tracking, model versioning, deployment strategies, monitoring, and retraining. In a mature ML system, the model in production is one version among many, surrounded by infrastructure that tracks how it got there, watches how it performs, and decides when it needs to be replaced. Without this infrastructure, ML in production is a black box that degrades silently.

Experiment tracking means recording every training run — the code version, data version, hyperparameters, metrics, and artifacts — so that any result can be reproduced and any decision can be justified. Model versioning extends this to the deployment artifact itself: which model is running in production right now, which one was running last week, and can you roll back in five minutes if something goes wrong? Huyen describes deployment strategies borrowed from software engineering. Shadow deployment runs the new model alongside the current one, comparing predictions without serving the new model's output to users. Canary deployment serves the new model to a small percentage of traffic and monitors for regressions before expanding. Blue-green deployment maintains two full environments and switches traffic between them. Each strategy trades off between risk, infrastructure cost, and time to full rollout.

Consider a recommendation system that was trained six months ago. User behavior has shifted — new product categories are popular, seasonal trends have changed, and the user base has grown into new demographics. The model's click-through rate has been declining for weeks, but nobody noticed because there was no monitoring for prediction distribution drift or performance metric decay. By the time someone investigates, revenue has already been impacted. Monitoring for drift — comparing the distribution of incoming features and model outputs against the training distribution — provides an early warning. Retraining triggers can be automated: when drift exceeds a threshold, or when online metrics fall below a target, a pipeline kicks off to retrain on recent data, validate against a holdout set, and promote to production through the same deployment strategy used for the initial launch.

The model lifecycle is a loop, not a line. Huyen stresses that teams who treat ML deployment as a one-time event end up with stale models, no ability to roll back, and no understanding of why performance changed. The teams that build the lifecycle infrastructure — experiment tracking, versioning, staged deployment, monitoring, and automated retraining — can iterate safely and respond to the real world as it changes.

### Refresher (subsequent exposure)

The model lifecycle is a continuous loop: track experiments, version models, deploy through staged strategies (shadow, canary, blue-green), monitor for drift and performance decay, and trigger retraining when needed. Treat deployment as the beginning of the operational phase, not the end of the project.

### Socratic Questions

- You deploy a new fraud detection model directly to 100% of traffic on a Friday afternoon. Over the weekend, it flags 40% of legitimate transactions as fraudulent. What deployment strategy would have caught this, and what monitoring would have alerted you before Monday?
- Your ML team has trained 200 models over the past year, but nobody can reproduce the results from the model currently in production because the training scripts and data have changed since then. What experiment tracking and versioning practices would prevent this?
- Your recommendation model's click-through rate has dropped 15% over three months, but the model's offline evaluation metrics on the original test set are unchanged. What is likely happening, and what monitoring would have detected this earlier?
