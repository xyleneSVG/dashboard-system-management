SELECT 
  id as task_id,
  title_clean as task_name,
  COALESCE(NULLIF(assignee, ''), 'Unassigned') as assignee_id,
  status_normalized,
  due_date
FROM ${project_issues}
WHERE status_normalized != 'done' 
  AND due_date IS NOT NULL 
  AND due_date < CURRENT_DATE
ORDER BY due_date ASC