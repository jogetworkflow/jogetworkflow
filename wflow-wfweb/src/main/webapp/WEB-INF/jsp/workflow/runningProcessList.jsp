<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowAdmin.running.process.list.label.title"
    helpTitle="wflowHelp.running.process.list.title"
    help="wflowHelp.running.process.list.content"
/>

    <div id="main-body-content">

        <div id="main-body-content-filter">
            <form>
            <fmt:message key="wflowAdmin.filter.by.package"/>
            <select onchange="filter(JsonDataTable, '&packageId=', this.options[this.selectedIndex].value)">
                <option></option>
            <c:forEach items="${packageList}" var="workflowPackage">
                <c:set var="selected"><c:if test="${workflowPackage.packageId == param.packageId}"> selected</c:if></c:set>
                <option value="${workflowPackage.packageId}" ${selected}>${workflowPackage.packageName}</option>
            </c:forEach>
            </select>
            </form>
        </div>

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/monitoring/running/process/list?${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="processList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="createdTime"
                       desc="true"
                       href="${pageContext.request.contextPath}/web/monitoring/running/process/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       checkbox="true"
                       checkboxButton1="wflowAdmin.running.process.list.label.delete"
                       checkboxCallback1="removeProcessInstances"
                       searchItems="processId|Process Id, processName|Process Name, version|Version"
                       fields="['id', 'version', 'name', 'state', 'startedTime', 'due', 'serviceLevelMonitor']"
                       column1="{key: 'id', label: 'wflowAdmin.running.process.list.label.id', sortable: true}"
                       column2="{key: 'startedTime', label: 'wflowAdmin.running.process.list.label.startedTime', sortable: true}"
                       column3="{key: 'name', label: 'wflowAdmin.running.process.list.label.name', sortable: true}"
                       column4="{key: 'version', label: 'wflowAdmin.running.process.list.label.version', sortable: false}"
                       column5="{key: 'state', label: 'wflowAdmin.running.process.list.label.state', sortable: false}"
                       column6="{key: 'due', label: 'wflowAdmin.running.process.list.label.due', sortable: false}"
                       column7="{key: 'serviceLevelMonitor', label: 'wflowAdmin.running.process.list.label.serviceLevelMonitor', sortable: false}"
                       />
    </div>

<commons:footer />

<script>
    function removeProcessInstances(selectedList){
         if (confirm('<fmt:message key='wflowAdmin.running.process.view.label.removeProcess.confirm'/>')) {
                var callback = {
                    success : function() {
                        //parent.closeDialog();
                        alert("<fmt:message key='wflowAdmin.running.process.view.label.running.process.instance.removed'/>");
                        document.location = '${pageContext.request.contextPath}/web/monitoring/running/process/list';
                        //parent.location.reload(true);
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/monitoring/running/process/removeMultiple', callback, 'wfProcessIds='+selectedList);
            }
    }
</script>
