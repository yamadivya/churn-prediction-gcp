SELECT *
FROM ML.GLOBAL_EXPLAIN(
  MODEL `churn-prediction-divya.churn_project.churn_classifier`
)
ORDER BY attribution DESC;