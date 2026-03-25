SELECT 
  COALESCE(NULLIF(assignee, ''), 'Unassigned') as assignee_id,
  id as task_id,
  title_clean as task_name,
  estimation,
  spent_time,
  (spent_time - estimation) as overtime_amount
FROM ${project_issues}
WHERE spent_time > estimation
ORDER BY overtime_amount DESC