<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowAdmin.variable.list.label.title"
    helpTitle="wflowHelp.variable.list.title"
    help="wflowHelp.variable.list.content"
/>

    <div id="main-body-content">
        <div>
            <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/variable/list?${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="variableList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/settings/form/variable/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Form Variable Dialog"
                       fields="['id','name','pluginName']"
                       column1="{key: 'name', label: 'wflowAdmin.variable.list.label.name', sortable: true, width: '300'}"
                       column2="{key: 'pluginName', label: 'wflowAdmin.variable.list.label.pluginName', sortable: false, width: '300'}"
                       />
        </div>
        <div id="main-body-actions">
            <input type="button" onclick="createVariable()" value="<fmt:message key="wflowAdmin.variable.list.label.createVariable"/>">
        </div>
    </div>

    <script type="text/javascript">
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/settings/form/variable/create"/>

        function createVariable(){
            popupDialog.init();
        }

        function closeDialog(){
            popupDialog.close();
            JsonDataTable.refresh();
        }
    </script>

<commons:footer />