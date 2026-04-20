#  Customer Churn Prediction — GCP + BigQuery ML

A complete end-to-end machine learning pipeline built
entirely in SQL using Google Cloud Platform and BigQuery ML.

##  Project Overview
- **Dataset:** Telco Customer Churn (7,043 customers)
- **Model:** Logistic Regression (BigQuery ML)
- **Goal:** Predict which customers are likely to churn
- **Result:** AUC of 0.827, catching 72% of churners

##  Model Performance
| Metric | Score |
|--------|-------|
| ROC AUC | 0.827 |
| Recall | 0.720 |
| Accuracy | 0.749 |
| F1 Score | 0.623 |

##  Architecture
Raw CSV (Kaggle) → GCS Bucket → BigQuery → Feature Engineering → BigQuery ML → Predictions

##  Project Structure
- `sql/01_data_verification.sql` — Fix data quality issues
- `sql/02_feature_engineering.sql` — Engineer 13 features
- `sql/03_train_test_split.sql` — 80/20 split
- `sql/04_train_model.sql` — Train logistic regression
- `sql/05_model_evaluation.sql` — Evaluate + confusion matrix
- `sql/06_feature_importance.sql` — Feature attribution
- `sql/07_predictions.sql` — Risk score all customers

##  Business Results
| Risk Tier | Customers | Revenue at Risk |
|-----------|-----------|-----------------|
|  HIGH | 1,090 | $74,411/month |
|  MEDIUM | 1,768 | $79,760/month |
|  LOW | 4,185 | $48,094/month |

##  Top Churn Drivers
1. Contract type (Month-to-month = highest risk)
2. Internet service (Fiber optic churns most)
3. Tenure segment (New customers = 56% churn rate)
4. Payment method (Electronic check = high risk)

##  Tools Used
- Google Cloud Storage (GCS)
- BigQuery + BigQuery ML
- SQL only — no Python needed!

##  How to Reproduce
1. Download dataset from [Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
2. Upload CSV to GCS bucket
3. Run SQL files in order 01 to 07 in BigQuery
4. View predictions in `churn_project.churn_predictions`
