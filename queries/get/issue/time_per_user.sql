SELECT 
  COALESCE(NULLIF(assignee, ''), 'Unassigned') as assignee_id,
  SUM(estimation) as total_estimasi,
  SUM(spent_time) as total_aktual
FROM ${project_issues}
WHERE assignee IS NOT NULL AND assignee != ''
GROUP BY 1