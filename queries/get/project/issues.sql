SELECT * FROM md_source.issues
WHERE project_id = COALESCE('${inputs.project_selected.value}', project_id)
AND CAST(to_timestamp(CAST(created_on AS BIGINT) / 1000) AS DATE)
BETWEEN 
  COALESCE('${inputs.date_filter.start}', '1970-01-01')
  AND COALESCE('${inputs.date_filter.end}', CURRENT_DATE)