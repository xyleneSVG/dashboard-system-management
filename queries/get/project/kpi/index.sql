SELECT
  status_normalized,
  COUNT(*) as issue_count
FROM ${project_issues}
GROUP BY status_normalized
ORDER BY issue_count DESC