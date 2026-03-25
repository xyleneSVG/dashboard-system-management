SELECT 
  COALESCE(NULLIF(assignee, ''), 'Unassigned') as assignee_id, 
  status_normalized, 
  COUNT(*) as issue_count
FROM ${project_issues}
GROUP BY 1, 2
ORDER BY 3 DESC