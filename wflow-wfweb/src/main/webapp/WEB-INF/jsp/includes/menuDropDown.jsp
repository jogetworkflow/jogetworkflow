
<div id="menu">
    <div id="menuDropDown">
        <ul class="nav">
            <li><a href="#workflowClient">Workflow Client</a>

            <ul>
                <li><a href="${pageContext.request.contextPath}/web/client/process/list">Start a Process</a></li>
                <li><a href="${pageContext.request.contextPath}/web/client/assignment/list">Assignment List</a>

                    <ul class="first-of-type">
                        <li><a href="${pageContext.request.contextPath}/web/client/assignment/pending/list">Pending Tasks</a></li>
                        <li><a href="${pageContext.request.contextPath}/web/client/assignment/accepted/list">Accepted Tasks</a></li>
                    </ul>

                </li>
            </ul>

            <li><a href="#workflowAdmin">Workflow Admin</a>

                <ul>
                    <li><a href="/wflow-designerweb/webstart/launch.jnlp">Design a New Process</a></li>
                    <li><a href="${pageContext.request.contextPath}/web/admin/package/upload">Upload Process</a></li>
                    <li><a href="${pageContext.request.contextPath}/web/admin/process/configure/list">Configure Processes</a></li>
                    <li><a href="#">Monitoring</a>

                        <ul>
                            <li><a href="${pageContext.request.contextPath}/web/monitoring/process/list">Running Processes</a></li>
                            <li><a href="${pageContext.request.contextPath}/web/monitoring/activity/list">Running Activities</a></li>
                        </ul>

                    </li>
                </ul>

            </li>

            <li><a href="#formsAdmin">Forms Admin</a>

                <ul>
                    <li><a href="${pageContext.request.contextPath}/web/form/list">Form List</a></li>
                    <li><a href="${pageContext.request.contextPath}/web/form/variable/list">Form Variable List</a></li>
                    <li><a href="${pageContext.request.contextPath}/web/form/category/list">Category List</a></li>
                </ul>

            </li>

            <li><a href="#directoryAdmin">Users Admin</a>

                <ul>
                    <li><a href="${pageContext.request.contextPath}/web/directory/admin/user/list">Manage Users</a></li>
                    <li><a href="${pageContext.request.contextPath}/web/directory/admin/group/list">Manage Groups</a></li>
                    <li><a href="${pageContext.request.contextPath}/web/directory/admin/organization/list">Manage Organization Chart</a></li>
                </ul>

            </li>

            <li><a href="#help">Help</a>

                <ul>
                    <li><a href="#">About</a></li>
                </ul>

            </li>

        </ul>
    </div>
</div>
<script type="text/javascript">
    Menu.show("menuDropDown");
</script>
