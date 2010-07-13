<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.activityAddPlugin.view.label.title"/>
    </div>

    <div id="main-body-content" style="text-align: left">
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/plugin/list?pluginType=Application&${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="pluginList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/admin/process/activity/plugin/add/submit?activityId=${activity.id}&processId=${process.encodedId}&version=${process.version}&"
                       hrefParam="id"
                       hrefQuery="true"
                       hrefDialog="false"
                       fields="['id','name','description','version']"
                       column1="{key: 'name', label: 'wflowAdmin.activityAddPlugin.view.label.pluginName', sortable: true}"
                       column2="{key: 'description', label: 'wflowAdmin.activityAddPlugin.view.label.pluginDescription', sortable: true}"
                       column3="{key: 'version', label: 'wflowAdmin.activityAddPlugin.view.label.pluginVersion', sortable: false}"
                       />

    </div>
<commons:popupFooter />
