SELECT * 
FROM md_source.issues
WHERE 
  (
    NULLIF('${inputs.project_selected.value}', '') IS NULL
    OR project_id = '${inputs.project_selected.value}'
  )
AND CAST(to_timestamp(CAST(created_on AS BIGINT) / 1000) AS DATE)
BETWEEN 
  COALESCE(NULLIF('${inputs.date_filter.start}', ''), '1970-01-01')
  AND COALESCE(NULLIF('${inputs.date_filter.end}', ''), CURRENT_DATE)