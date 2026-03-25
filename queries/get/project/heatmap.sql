SELECT 
  CAST(epoch_ms(CAST(modified_on AS BIGINT)) AS DATE) as completion_date,
  COUNT(*) as completed_issues
FROM ${project_issues}
WHERE status_normalized = 'done'
GROUP BY 1
ORDER BY 1