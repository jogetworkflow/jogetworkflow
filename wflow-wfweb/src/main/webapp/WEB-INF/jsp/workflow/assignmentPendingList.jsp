<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowClient.pendingList.list.label.title"
    helpTitle="wflowHelp.assignment.pending.list.title"
    help="wflowHelp.assignment.pending.list.content"
/>

    <div id="main-body-content">
            <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/assignment/list/pending" 
                       var="assignmentPendingList"
                       divToUpdate="assignmentPendingList" 
                       jsonData="data"
                       rowsPerPage="10"
                       sort="dateCreated"
                       desc="true"
                       width="100%"
                       href="${pageContext.request.contextPath}/web/client/assignment/view/"
                       hrefParam="activityId"
                       hrefQuery="false"
                       hrefDialog="true"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       fields="['activityId','processName','activityName','processVersion', 'dateCreated', 'due', 'serviceLevelMonitor', 'processId']"
                       column1="{key: 'processName', label: 'wflowClient.pendingList.list.label.processName', sortable: false}"
                       column2="{key: 'activityName', label: 'wflowClient.pendingList.list.label.activityName', sortable: false}"
                       column3="{key: 'processVersion', label: 'wflowClient.pendingList.list.label.processVersion', sortable: false}"
                       column4="{key: 'dateCreated', label: 'wflowClient.pendingList.list.label.dateCreated', sortable: true}"
                       column5="{key: 'due', label: 'wflowClient.pendingList.list.label.due', sortable: false}"
                       column6="{key: 'serviceLevelMonitor', label: 'wflowClient.pendingList.list.label.serviceLevelMonitor', sortable: false}"
                       column7="{key: 'processId', label: 'wflowClient.pendingList.list.label.processId', sortable: true}"
                       />
    </div>

<commons:footer />
