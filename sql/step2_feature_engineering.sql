CREATE OR REPLACE TABLE `churn-prediction-divya.churn_project.features` AS

SELECT
  customer_id,

  -- TENURE BUCKETS (risk bands based on loyalty)
  CASE
    WHEN tenure <= 3  THEN 'new'
    WHEN tenure <= 12 THEN 'developing'
    WHEN tenure <= 36 THEN 'established'
    ELSE                   'loyal'
  END AS tenure_segment,

  -- AVG MONTHLY SPEND (normalised spend signal)
  SAFE_DIVIDE(total_charges, tenure)              AS avg_monthly_spend,

  -- PAYMENT RISK SCORE (0.0 to 1.0 scale)
  CASE
    WHEN tenure = 0  THEN 0.5                     -- unknown, default mid-risk
    ELSE SAFE_DIVIDE(total_charges, tenure * MonthlyCharges)
  END AS payment_consistency_score,

  -- SERVICE COUNT (how many add-ons subscribed)
  (
    CASE WHEN OnlineSecurity   = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN OnlineBackup     = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN TechSupport      = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN StreamingTV      = 'Yes' THEN 1 ELSE 0 END +
    CASE WHEN StreamingMovies  = 'Yes' THEN 1 ELSE 0 END
  )                                               AS service_count,

  -- SENIOR + DEPENDENT RISK FLAG
  CASE
    WHEN is_senior = 1
     AND Partner = 'No'
     AND Dependents = 'No' THEN 1
    ELSE 0
  END AS high_risk_demographic,

  --  RAW NUMERIC FEATURES (kept as-is)
  tenure,
  MonthlyCharges                                  AS monthly_charges,
  COALESCE(total_charges, MonthlyCharges)         AS total_charges,

  --  CATEGORICAL FEATURES (BigQuery ML auto encodes these)
  Contract                                        AS contract_type,
  PaymentMethod                                   AS payment_method,
  InternetService                                 AS internet_service,
  PaperlessBilling                                AS paperless_billing,
  gender,

  -- LABEL (what we're predicting)
  churned

FROM `churn-prediction-divya.churn_project.customers_clean`;

-- Preview the engineered features
SELECT *
FROM `churn-prediction-divya.churn_project.features`
LIMIT 10;

-- Churn rate by tenure segment
SELECT
  tenure_segment,
  COUNT(*)                                          AS total_customers,
  COUNTIF(churned = 1)                              AS churned,
  ROUND(COUNTIF(churned = 1) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `churn-prediction-divya.churn_project.features`
GROUP BY tenure_segment
ORDER BY churn_rate_pct DESC;

SELECT
  contract_type,
  COUNT(*)                                          AS total_customers,
  COUNTIF(churned = 1)                              AS churned,
  ROUND(COUNTIF(churned = 1) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `churn-prediction-divya.churn_project.features`
GROUP BY contract_type
ORDER BY churn_rate_pct DESC;

SELECT
  service_count,
  COUNT(*)                                          AS total_customers,
  ROUND(COUNTIF(churned = 1) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `churn-prediction-divya.churn_project.features`
GROUP BY service_count
ORDER BY service_count;