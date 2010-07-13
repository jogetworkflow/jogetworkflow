<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowClient.history.list.label.title"
    helpTitle="wflowHelp.assignment.history.list.title"
    help="wflowHelp.assignment.history.list.content"
/>

    <div id="main-body-content">
            <div id="main-body-content-filter">
                <form>
                <fmt:message key="wflowClient.filter.by.package"/>
                <select onchange="filter(assignmentHistory, '&packageId=', this.options[this.selectedIndex].value)">
                    <option></option>
                <c:forEach items="${packageList}" var="workflowPackage">
                    <c:set var="selected"><c:if test="${workflowPackage.packageId == param.packageId}"> selected</c:if></c:set>
                    <option value="${workflowPackage.packageId}" ${selected}>${workflowPackage.packageName}</option>
                </c:forEach>
                </select>
                </form>
            </div>
            <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/assignment/history?${pageContext.request.queryString}"
                       var="assignmentHistory"
                       divToUpdate="assignmentHistory"
                       jsonData="data"
                       rowsPerPage="10"
                       sort="dateCreated"
                       desc="true"
                       width="100%"
                       href="${pageContext.request.contextPath}/web/client/assignment/history/view/"
                       hrefParam="activityId"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       searchItems="processId|Process Id, processName|Process Name, activityName|Activity Name"
                       fields="['activityId', 'activityName', 'dateCreated', 'processId', 'processName', 'dateCompleted', 'version']"
                       column1="{key: 'processId', label: 'wflowClient.history.list.label.processId', sortable: true, hide:true}"
                       column2="{key: 'processName', label: 'wflowClient.history.list.label.processName', sortable: false, width: '150'}"
                       column3="{key: 'processStatus', label: 'wflowClient.history.list.label.processStatus', sortable: false, width: '100'}"
                       column4="{key: 'activityId', label: 'wflowClient.history.list.label.activityId', sortable: false, hide: true}"
                       column5="{key: 'activityName', label: 'wflowClient.history.list.label.activityName', sortable: false, width: '260'}"
                       column6="{key: 'version', label: 'wflowClient.history.list.label.version', sortable: false, hide:true}"
                       column7="{key: 'dateCreated', label: 'wflowClient.history.list.label.dateCreated', sortable: true, width: '120'}"
                       column8="{key: 'dateCompleted', label: 'wflowClient.history.list.label.dateCompleted', sortable: true, width: '120'}"
                       />
    </div>

<commons:footer />
