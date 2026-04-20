CREATE OR REPLACE MODEL `churn-prediction-divya.churn_project.churn_classifier`
OPTIONS (
  --  Model type
  model_type             = 'logistic_reg',

  --  Tell it which column to predict
  input_label_cols       = ['churned'],

  --  Handle class imbalance
  -- 26% churned vs 74% stayed → upweight churned class
  class_weights          = [
    STRUCT('0', 1.0),   -- stayed  → weight 1
    STRUCT('1', 3.0)    -- churned → weight 3
  ],

  -- Regularisation (prevents overfitting)
  l1_reg                 = 0.1,
  l2_reg                 = 0.1,

  -- Training settings
  max_iterations         = 50,
  learn_rate_strategy    = 'line_search',

  -- We handle splits ourselves
  data_split_method      = 'NO_SPLIT',

  -- Enable feature importance
  enable_global_explain  = TRUE
)
AS
SELECT
  -- Features
  tenure_segment,
  avg_monthly_spend,
  payment_consistency_score,
  service_count,
  high_risk_demographic,
  tenure,
  monthly_charges,
  total_charges,
  contract_type,
  payment_method,
  internet_service,
  paperless_billing,
  gender,

  -- Label
  churned

FROM `churn-prediction-divya.churn_project.train`;