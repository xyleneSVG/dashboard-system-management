SELECT 
  id as task_id,
  title_clean as task_name,
  CASE 
    WHEN complexity = 'low' THEN 1
    WHEN complexity = 'medium' THEN 2
    WHEN complexity = 'high' THEN 3
    ELSE 0 
  END as complexity_score,
  spent_time,
  status_normalized
FROM ${project_issues}
WHERE spent_time > 0 