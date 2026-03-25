SELECT 
  assignee as source,
  layer as target,
  COUNT(*) as value
FROM ${project_issues}
WHERE assignee IS NOT NULL AND assignee != ''
  AND layer IS NOT NULL AND layer != ''
GROUP BY 1, 2