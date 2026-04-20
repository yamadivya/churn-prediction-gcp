SELECT *
FROM ML.EVALUATE(
  MODEL `churn-prediction-divya.churn_project.churn_classifier`,
  (SELECT * FROM `churn-prediction-divya.churn_project.test`)
);

SELECT
  churned                 AS actual,
  predicted_churned       AS predicted,
  COUNT(*)                AS count
FROM ML.PREDICT(
  MODEL `churn-prediction-divya.churn_project.churn_classifier`,
  (SELECT * FROM `churn-prediction-divya.churn_project.test`)
)
GROUP BY actual, predicted
ORDER BY actual, predicted;

SELECT *
FROM ML.GLOBAL_EXPLAIN(
  MODEL `churn-prediction-divya.churn_project.churn_classifier`
)
ORDER BY attribution DESC;

SELECT
  churned                 AS actual,
  predicted_churned       AS predicted,
  COUNT(*)                AS count
FROM ML.PREDICT(
  MODEL `churn-prediction-divya.churn_project.churn_classifier`,
  (SELECT * FROM `churn-prediction-divya.churn_project.test`)
)
GROUP BY actual, predicted
ORDER BY actual, predicted;

