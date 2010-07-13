<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowAdmin.audittrail.list.label.title"
    helpTitle="wflowHelp.audit.trail.list.title"
    help="wflowHelp.audit.trail.list.content"
/>

    <div id="main-body-content">
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/audittrail/list?${pageContext.request.queryString}"
                   var="JsonDataTable"
                   divToUpdate="auditTrailList"
                   jsonData="data"
                   rowsPerPage="10"
                   width="100%"
                   sort="timestamp"
                   desc="true"
                   href=""
                   hrefParam="id"
                   hrefQuery="false"
                   hrefDialog="false"
                   dateComparison="true"
                   fields="['username', 'clazz','method','message','timestamp']"
                   column1="{key: 'timestamp', label: 'wflowAdmin.audittrail.list.label.timestamp', sortable: true}"
                   column2="{key: 'username', label: 'wflowAdmin.audittrail.list.label.username', sortable: true}"
                   column3="{key: 'method', label: 'wflowAdmin.audittrail.list.label.method', sortable: true}"
                   column4="{key: 'message', label: 'wflowAdmin.audittrail.list.label.message', sortable: false}"
                   column5="{key: 'clazz', label: 'wflowAdmin.audittrail.list.label.clazz', sortable: true}"
                   />
    </div>

<commons:footer />