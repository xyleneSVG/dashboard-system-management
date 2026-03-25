<script>
    export let data = []; 
    export let node = null; 
    export let pathCol = "full_path";
    export let assigneeCol = "assignee"; // Tambahkan kolom assignee

    // State untuk buka-tutup folder
    let expanded = false; 

    function toggle() {
        expanded = !expanded;
    }

    // Fungsi Transformasi (Hanya jalan di Root/Level paling atas)
    function transformToTree(nodes) {
        if (!nodes || nodes.length === 0) return [];
        const root = [];
        nodes.forEach((item) => {
            const pathParts = item[pathCol]?.split('/').filter(Boolean).map(p => p.trim()) || [];
            let currentLevel = root;

            pathParts.forEach((part, index) => {
                let existingPath = currentLevel.find((p) => p.name === part);
                const isLast = index === pathParts.length - 1;

                if (!existingPath) {
                    existingPath = { 
                        name: part, 
                        children: [], 
                        isLast: isLast,
                        // Ambil info assignee kalau ini adalah file (leaf node)
                        assignee: isLast ? (item[assigneeCol] || 'Unassigned') : null 
                    };
                    currentLevel.push(existingPath);
                }
                currentLevel = existingPath.children;
            });
        });
        return root;
    }

    $: treeData = !node ? transformToTree(data) : [];
</script>

{#if !node}
    <ul class="tree-root">
        {#each treeData as childNode}
            <svelte:self node={childNode} {pathCol} {assigneeCol} />
        {/each}
    </ul>
{:else}
    <li class="tree-node">
        <!-- svelte-ignore a11y-click-events-have-key-events -->
        <div class="node-content" on:click={toggle} role="button" tabindex="0">
            {#if node.children.length > 0}
                <span class="arrow" class:expanded>{expanded ? '▼' : '▶'}</span>
                <span class="icon">📁</span>
            {:else}
                <span class="arrow-spacer"></span>
                <span class="icon">📄</span>
            {/if}
            
            <span class="label" class:project-link={node.isLast}>
                {node.name}
            </span>

            {#if node.isLast && node.assignee}
                <span class="assignee-tag">👤 {node.assignee}</span>
            {/if}
        </div>

        {#if expanded && node.children.length > 0}
            <ul>
                {#each node.children as child}
                    <svelte:self node={child} {pathCol} {assigneeCol} />
                {/each}
            </ul>
        {/if}
    </li>
{/if}

<style>
    .tree-root { list-style: none; padding-left: 0; font-family: 'Inter', sans-serif; font-size: 13px; color: #e0e0e0; }
    ul { list-style: none; padding-left: 1rem; border-left: 1px solid #333; margin: 2px 0 2px 8px; }
    .tree-node { margin: 4px 0; }
    
    .node-content { 
        display: flex; 
        align-items: center; 
        gap: 6px; 
        cursor: pointer; 
        padding: 4px 8px;
        border-radius: 4px;
        transition: background 0.2s;
    }
    
    .node-content:hover { background: #222; }
    
    .arrow { font-size: 8px; width: 10px; transition: transform 0.2s; color: #888; }
    .arrow-spacer { width: 10px; }
    .icon { font-size: 14px; }
    
    .label { white-space: nowrap; }
    .project-link { color: #4dabf7; font-weight: 600; }
    
    .assignee-tag {
        font-size: 11px;
        background: #333;
        color: #aaa;
        padding: 1px 8px;
        border-radius: 10px;
        margin-left: 10px;
        border: 1px solid #444;
    }

    .expanded { color: #fff; }
</style>