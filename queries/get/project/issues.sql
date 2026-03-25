SELECT * 
FROM md_source.issues
WHERE project_id = COALESCE('${inputs.project_selected.value}', project_id)