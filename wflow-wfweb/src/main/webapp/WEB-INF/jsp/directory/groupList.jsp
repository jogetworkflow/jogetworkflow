<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.group.list.label.title"
    helpTitle="wflowHelp.group.list.title"
    help="wflowHelp.group.list.content"
/>
    
    <div id="main-body-content">

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/group/list?${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="groupList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/group/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       checkbox="true"
                       checkboxButton1="usersAdmin.group.list.label.create"
                       checkboxCallback1="onCreate"
                       checkboxButton2="general.method.label.delete"
                       checkboxCallback2="removeGroup"
                       searchItems="name|Group Name"
                       fields="['id', 'name','description']"
                       column1="{key: 'name', label: 'usersAdmin.group.list.label.name', sortable: true}"
                       column2="{key: 'description', label: 'usersAdmin.group.list.label.description', sortable: false}"
                       />
    </div>
    
    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/group/new"/>
        
        function onCreate(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
        }

        function removeGroup(selectedList){
            if (confirm('<fmt:message key="usersAdmin.group.view.confirmation.remove"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/group/list';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/group/removeMultiple', callback, 'groupIds='+selectedList);
            }
        }
    </script>

<commons:footer />

