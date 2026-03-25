SELECT 
  CAST(to_timestamp(CAST(created_on AS BIGINT) / 1000) AS DATE) as tanggal,
  COUNT(*) as jumlah_task
FROM ${project_issues}
WHERE created_on IS NOT NULL
GROUP BY 1
ORDER BY 1 ASC