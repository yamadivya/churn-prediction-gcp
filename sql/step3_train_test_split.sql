CREATE OR REPLACE TABLE `churn-prediction-divya.churn_project.train` AS
SELECT * FROM `churn-prediction-divya.churn_project.features`
WHERE MOD(ABS(FARM_FINGERPRINT(customer_id)), 10) < 8;

CREATE OR REPLACE TABLE `churn-prediction-divya.churn_project.test` AS
SELECT * FROM `churn-prediction-divya.churn_project.features`
WHERE MOD(ABS(FARM_FINGERPRINT(customer_id)), 10) >= 8;

SELECT
  'train' AS dataset,
  COUNT(*) AS total_rows,
  COUNTIF(churned = 1) AS churned,
  ROUND(COUNTIF(churned = 1) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `churn-prediction-divya.churn_project.train`
UNION ALL
SELECT
  'test' AS dataset,
  COUNT(*) AS total_rows,
  COUNTIF(churned = 1) AS churned,
  ROUND(COUNTIF(churned = 1) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `churn-prediction-divya.churn_project.test`;

