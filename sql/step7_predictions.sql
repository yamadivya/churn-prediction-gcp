CREATE OR REPLACE TABLE `churn-prediction-divya.churn_project.churn_predictions` AS

SELECT
  f.customer_id,
  predicted_churned,
  ROUND(p.prob, 4)                          AS churn_probability,

  -- Risk tier
  CASE
    WHEN p.prob >= 0.75 THEN 'HIGH RISK'
    WHEN p.prob >= 0.45 THEN 'MEDIUM RISK'
    ELSE                     'LOW RISK'
  END AS risk_tier,

  -- Revenue at risk
  ROUND(p.prob * f.monthly_charges, 2)      AS expected_revenue_at_risk,

  f.monthly_charges,
  f.contract_type,
  f.tenure_segment,
  f.internet_service,
  f.payment_method

FROM ML.PREDICT(
  MODEL `churn-prediction-divya.churn_project.churn_classifier`,
  (SELECT * FROM `churn-prediction-divya.churn_project.features`)
) AS pred
CROSS JOIN UNNEST(predicted_churned_probs) AS p
JOIN `churn-prediction-divya.churn_project.features` f
  USING (customer_id)
WHERE p.label = 1;

select * from churn-prediction-divya.churn_project.churn_predictions
limit 10;

-- Risk tier summary
SELECT
  risk_tier,
  COUNT(*)                        AS total_customers,
  ROUND(AVG(churn_probability), 3) AS avg_churn_probability,
  ROUND(SUM(expected_revenue_at_risk), 2) AS total_revenue_at_risk
FROM `churn-prediction-divya.churn_project.churn_predictions`
GROUP BY risk_tier
ORDER BY total_revenue_at_risk DESC;