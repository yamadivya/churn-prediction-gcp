-- See first 10 rows
SELECT * 
FROM `churn-prediction-divya.churn_project.raw_customers`
LIMIT 10;

SELECT
  COUNT(*)                                              AS total_rows,
  COUNTIF(TotalCharges = ' ')                           AS blank_total_charges,
  COUNTIF(tenure = 0)                                   AS zero_tenure_customers,
  COUNTIF(Churn = 'Yes')                                AS churned,
  COUNTIF(Churn = 'No')                                 AS stayed,
  ROUND(COUNTIF(Churn = 'Yes') * 100.0 / COUNT(*), 2)  AS churn_rate_pct
FROM `churn-prediction-divya.churn_project.raw_customers`;


CREATE OR REPLACE TABLE `churn-prediction-divya.churn_project.customers_clean` AS
SELECT
  customerID                                              AS customer_id,
  gender,
  SeniorCitizen                                           AS is_senior,
  Partner,
  Dependents,
  tenure,
  PhoneService,
  MultipleLines,
  InternetService,
  OnlineSecurity,
  OnlineBackup,
  DeviceProtection,
  TechSupport,
  StreamingTV,
  StreamingMovies,
  Contract,
  PaperlessBilling,
  PaymentMethod,
  MonthlyCharges,

  -- Fix TotalCharges: blank spaces : NULL : FLOAT
  SAFE_CAST(NULLIF(TRIM(TotalCharges), '') AS FLOAT64)    AS total_charges,

  -- Fix Churn: Yes/No : 1/0 for BigQuery ML
  CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END               AS churned

FROM `churn-prediction-divya.churn_project.raw_customers`;

SELECT
  COUNT(*)                        AS total_rows,
  COUNTIF(total_charges IS NULL)  AS null_total_charges,
  COUNTIF(churned = 1)            AS churned_count,
  COUNTIF(churned = 0)            AS stayed_count,
  MIN(tenure)                     AS min_tenure,
  MAX(tenure)                     AS max_tenure,
  ROUND(AVG(MonthlyCharges), 2)   AS avg_monthly_charges
FROM `churn-prediction-divya.churn_project.customers_clean`;

-- Confirm both tables exist in your dataset
SELECT
  table_name,
  creation_time
FROM `churn-prediction-divya.churn_project.INFORMATION_SCHEMA.TABLES`;