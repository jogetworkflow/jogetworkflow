<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowClient.userview.list.label.title"
    helpTitle="wflowHelp.userview.list.title"
    help="wflowHelp.userview.list.content"
/>

    <div id="main-body-content">
        <!--
        <div id="main-body-content-filter">
            <fmt:message key="wflowClient.filter.by.process.id"/>
            <select onchange="filter(userviewByProcessDef, '&processDefinitionId=', this.options[this.selectedIndex].value)">
                <option></option>
                <c:forEach items="${processList}" var="processList">
                    <option value="${processList.id}" ${selected}>${processList.name}</option>
                </c:forEach>
            </select>
        </div>
        -->
        
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/userview/list?${pageContext.request.queryString}"
                   var="userviewByProcessDef"
                   divToUpdate="userviewByProcessDef"
                   jsonData="data"
                   rowsPerPage="10"
                   sort="setupName"
                   desc="false"
                   width="100%"
                   href="${pageContext.request.contextPath}/web/admin/userview/edit/view/"
                   hrefParam="id"
                   hrefQuery="false"
                   hrefDialog="false"
                   hrefDialogWidth="600px"
                   hrefDialogHeight="400px"
                   hrefDialogTitle="Process Dialog"
                   checkbox="true"                  
                   checkboxButton1="wflowClient.userview.list.label.createUserview"
                   checkboxCallback1="createUserview"
                   checkboxButton2="wflowClient.userview.list.import"
                   checkboxCallback2="importUserview"
                   checkboxButton3="wflowClient.userview.list.delete"
                   checkboxCallback3="removeUserview"
                   searchItems="setupName|Setup Name"
                   fields="['id', 'setupName', 'created', 'processDefinitionId']"
                   column1="{key: 'setupName', label: 'wflowClient.userview.list.label.setupName', sortable: true}"
                   column2="{key: 'dateCreated', label: 'wflowClient.userview.list.label.dateCreated', sortable: true, width: '150'}"
                   />
    </div>

<script type="text/javascript">
    function createUserview(){
        document.location = '${pageContext.request.contextPath}/web/admin/userview/create';
    }

    function removeUserview(selectedList){
         if (confirm('<fmt:message key='wflowClient.userview.list.removeUserview.confirm'/>')) {
                var callback = {
                    success : function() {
                        //parent.closeDialog();
                        alert("<fmt:message key='wflowClient.userview.list.removed'/>");
                        document.location = '${pageContext.request.contextPath}/web/admin/userview/list';
                        //parent.location.reload(true);
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/admin/userview/removeMultiple', callback, 'userviewIds='+selectedList);
            }
    }

    function importUserview(){
        document.location = '${pageContext.request.contextPath}/web/admin/userview/import';
    }
</script>

<commons:footer />
