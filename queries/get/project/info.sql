SELECT *
FROM md_source.project_tree
WHERE project_id = '${inputs.project_selected.value}'
LIMIT 1