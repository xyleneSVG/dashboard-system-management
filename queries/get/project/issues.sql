SELECT * FROM md_source.issues
WHERE project_id = '${inputs.project_selected.value}'
  AND (
    '${inputs.date_filter.start}' = '' 
    OR '${inputs.date_filter.start}' IS NULL
    OR CAST(to_timestamp(CAST(created_on AS BIGINT) / 1000) AS DATE) 
       BETWEEN '${inputs.date_filter.start}' AND '${inputs.date_filter.end}'
  )