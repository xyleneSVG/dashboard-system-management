---
queries:
  - list_project: get/list/projects.sql
  - project_issues: get/project/issues.sql
  - project_info: get/project/info.sql
  - project_kpi: get/project/kpi/index.sql
  - project_kpi_total: get/project/kpi/total.sql
  - project_heatmap: get/project/heatmap.sql
  - project_workload: get/project/workload.sql
  - issue_assignee: get/issue/assignee.sql
  - issue_overtime: get/issue/overtime.sql
  - issue_time_per_user: get/issue/time_per_user.sql
  - issue_overdue: get/issue/overdue.sql
  - issue_trend: get/issue/trend.sql
  - issue_jobdesk: get/issue/jobdesk.sql
  - issue_scatter: get/issue/scatter.sql
---

<script>
  import DirectoryTree from '../components/DirectoryTree.svelte';
</script>

# System Management Dashboard

Monitor metrics, work status, and overall team performance.

<Grid cols=2 gapSize=lg>
  <Dropdown 
      name="project_selected" 
      data={list_project} 
      value="project_id"
      label="display_name" 
      title="Select Project"
  />

<DateRange 
      name="date_filter" 
      title="Date Range Filter"
      defaultValue="Last 365 Days"
  />
</Grid>

---

{#if project_info.length > 0}

## 📌 Project Information: {inputs.project_selected.label}

<Grid cols=2 gapSize=sm>
  <div>
    <b>Project ID:</b> {inputs.project_selected.value}
  </div>
  <div>
    <b>Root Project:</b> {project_info[0].root_project}
  </div>
</Grid>

{:else}

## 📌 Project Information

<Alert status="info">
No project data available for this selection
</Alert>

{/if}

<br/>

### 🧠 Auto-Insights & Alerts

{#if issue_overdue.length > 0}
<Alert status="negative">
⚠️ <b>CRITICAL WARNING:<b/> There are {issue_overdue.length} tasks currently overdue. Immediate follow-up is required to prevent further project delays.
</Alert>
{/if}

<Alert status="info">
  <b>Project Summary:</b> <br/>
  <b>Time Efficiency:</b> {issue_overtime.length} tasks have exceeded their original estimation. <br/>
  <b>Project Progress:</b> {project_kpi.filter(x => x.status_normalized === 'done')[0]?.issue_count || 0} tasks have been successfully completed to date. <br/>
  <b>Team Activity:</b> {issue_assignee.length} team members are actively contributing to this period. <br/>
</Alert>

---

<Tabs>

  <Tab label="📊 Overview & Trends">

    <br/>

    ### 🎯 Key Performance Indicators (KPI)

    <Grid cols=4>
      {#if project_kpi_total.length > 0}
      <BigValue
        data={project_kpi_total}
        value=total_issues
        title="Total Issues"
      />
      {/if}

      {#if project_kpi.length > 0}
        {#each project_kpi as row}
          <BigValue data={[row]} value=issue_count title={row.status_normalized} />
        {/each}
      {/if}
    </Grid>

    {#if project_kpi_total.length === 0 && project_kpi.length === 0}
      <Alert status="info">No KPI data available for this period</Alert>
    {/if}

    <br/>

    <div>

      ### 🔎 Work Status Distribution

      {#if project_kpi.length > 0}
      <ECharts
        style="height:300px"
        config={{
          tooltip: { formatter: '{b}: {c} ({d}%)' },
          legend: { orient: 'vertical', left: 'left' },
          series: [{
            type: 'pie', radius: '70%',
            data: project_kpi.map(item => ({
              name: item.status_normalized,
              value: item.issue_count,
              itemStyle: { color: item.status_normalized === 'done' ? '#4CAF50' : (item.status_normalized === 'todo' ? '#D3D3D3' : undefined) }
            }))
          }]
        }}
      />
      {:else}
        <Alert status="info">
          No status distribution data to display
        </Alert>
      {/if}
    </div>

    <div>

      ### 🔥 Completion Intensity (Heatmap)

      {#if project_heatmap.length > 0}
        <CalendarHeatmap
          data={project_heatmap} date=completion_date value=completed_issues
          colorScale={[['rgb(159, 254, 233)', 'rgb(159, 254, 227)'], ['rgb(59, 218, 41)', 'rgb(50, 218, 41)']]}
        />
      {:else}
        <Alert status="info">
          No completed tasks in this period
        </Alert>
      {/if}
    </div>

    <br/>

    ### 📈 Daily Task Creation Trend
    {#if issue_trend.length > 0}
      <LineChart data={issue_trend} x=tanggal y=jumlah_task yAxisTitle="Task Count" />
    {:else}
      <Alert status="info">
        No task creation trend available
      </Alert>
    {/if}

  </Tab>

  <Tab label="👥 Team Workload">

    <br/>

      <div>

        ### 📈 Distribution by System Layer

        {#if project_workload.length > 0}
          <BarChart data={project_workload} x=layer y=issue_count series=status_normalized type=stacked />
        {:else}
          <Alert status="info">
            No workload distribution data available
          </Alert>
        {/if}
      </div>

      <div>

        ### 💥 Workload per Team Member

        {#if issue_assignee.length > 0}
        <BarChart data={issue_assignee} x=assignee_id y=issue_count series=status_normalized type=stacked swapXY=true colorPalette={['#4CAF50', '#FFC107', '#D3D3D3']} />
        {:else}
          <Alert status="info">
            No assignee workload data available
          </Alert>
        {/if}
      </div>

    <br/>

    <Grid cols=2 gapSize=md>
      <div>

         ### 🏆 Top Contributors

         {#if issue_assignee.length > 0}
         <DataTable data={issue_assignee} rows=5 />
         {:else}
         <Alert status="info">No contributor data.</Alert>
         {/if}
      </div>
      <div>

         ### 🐢 Bottlenecks (Overdue by User)

         {#if issue_overdue.length > 0}
         <DataTable data={issue_overdue} rows=5 columns={[
            { id: 'assignee_id', title: 'Assignee' },
            { id: 'task_name', title: 'Task Name' },
            { id: 'due_date', title: 'Due Date', fmt: 'date' }
         ]} />
         {:else}
         <Alert status="positive">No bottlenecks found 🎉</Alert>
         {/if}
      </div>
    </Grid>

    <br/>

    ### 🔀 Team Member by System Layer
    {#if issue_jobdesk.length > 0}
      <SankeyDiagram data={issue_jobdesk} sourceCol=source targetCol=target valueCol=value />
    {:else}
      <Alert status="info">
        No workflow routing data available
      </Alert>
    {/if}

    <br/>

    ### 📂 Project Directory Structure

    <DirectoryTree 
        data={project_issues} 
        pathCol="full_path" 
    />

    <br/>

    ### 📋 Detailed Issue List
    {#if project_issues.length > 0}
    <DataTable data={project_issues} search=true rows=10 columns={[
      { id: 'id', title: 'ID' },
      { id: 'title_clean', title: 'Task Name' },
      { id: 'layer', title: 'Layer' },
      { id: 'complexity', title: 'Complexity' },
      { id: 'status_normalized', title: 'Status' }
    ]} />
    {:else}
      <Alert status="warning">
        No issues found for the selected filters
      </Alert>
    {/if}

  </Tab>

  <Tab label="⏱️ Time Evaluation">

    <br/>

    ### 🎯 Time vs Complexity Analysis
    Observe the correlation between task complexity and time spent.

    {#if issue_scatter.length > 0}
    <ScatterPlot
      data={issue_scatter}
      x=complexity_score
      y=spent_time
      series=status_normalized
      tooltipTitle=task_name
    />
    {:else}
      <Alert status="info">
        No complexity vs time data available
      </Alert>
    {/if}

    <br/>

    <Grid cols=2 gapSize=md>
      <div>

        ### ⏱️ Estimated vs Actual (Per User)

        {#if issue_time_per_user.length > 0}
          <BarChart
            data={issue_time_per_user}
            x=assignee_id
            y={['total_estimasi', 'total_aktual']}
            type=grouped
            colorPalette={['#D3D3D3', '#FF5722']}
          />
        {:else}
          <Alert status="info">
            No estimation vs actual data available
          </Alert>
        {/if}
      </div>

      <div>

        ### 🚨 Overtime Tasks List

        {#if issue_overtime.length > 0}
          <DataTable data={issue_overtime} rows=5 columns={[
            { id: 'assignee_id', title: 'Assignee' },
            { id: 'task_name', title: 'Task Name' },
            { id: 'estimation', title: 'Est.' },
            { id: 'spent_time', title: 'Actual' },
            { id: 'overtime_amount', title: 'Overtime', align: 'right' }
          ]} />
        {:else}
          <Alert status="positive">
            No overtime tasks 🎉
          </Alert>
        {/if}
      </div>
    </Grid>

    <br/>

    ### ⚠️ Overdue Tasks Warning

    {#if issue_overdue.length > 0}
    <DataTable data={issue_overdue} columns={[
      { id: 'task_id', title: 'ID' },
      { id: 'task_name', title: 'Task Name' },
      { id: 'assignee_id', title: 'Assignee' },
      { id: 'due_date', title: 'Due Date', fmt: 'date' },
      { id: 'status_normalized', title: 'Status' }
    ]} />
    {:else}
      <Alert status="positive">
        No overdue tasks 🎉
      </Alert>
    {/if}

  </Tab>

</Tabs>
