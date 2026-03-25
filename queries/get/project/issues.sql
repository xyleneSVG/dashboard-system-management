SELECT * FROM md_source.issues
WHERE project_id = '${inputs.project_selected.value}'
  AND CAST(to_timestamp(CAST(created_on AS BIGINT) / 1000) AS DATE) >= '${inputs.date_filter.start}' 
  AND CAST(to_timestamp(CAST(created_on AS BIGINT) / 1000) AS DATE) <= '${inputs.date_filter.end}'