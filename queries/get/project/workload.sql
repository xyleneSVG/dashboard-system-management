SELECT
  layer,
  status_normalized,
  COUNT(*) as issue_count
FROM ${project_issues},
GROUP BY 1, 2
ORDER BY 1