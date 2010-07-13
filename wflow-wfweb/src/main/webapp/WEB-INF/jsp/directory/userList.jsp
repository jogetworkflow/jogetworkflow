<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.user.list.label.title"
    helpTitle="wflowHelp.user.list.title"
    help="wflowHelp.user.list.content"
/>

    <div id="main-body-content">

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/user/list?${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="userList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="username"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/user/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       checkbox="true"
                       checkboxButton1="usersAdmin.user.list.label.create"
                       checkboxCallback1="onCreate"
                       checkboxButton2="general.method.label.delete"
                       checkboxCallback2="removeUser"
                       searchItems="username|Username/First Name"
                       fields="['id', 'username','firstName','lastName']"
                       column1="{key: 'username', label: 'usersAdmin.user.list.label.user.name', sortable: true}"
                       column2="{key: 'firstName', label: 'usersAdmin.user.list.label.first.name', sortable: false}"
                       column3="{key: 'lastName', label: 'usersAdmin.user.list.label.last.name', sortable: false}"
                       />
    </div>

    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/user/new"/>
        
        function onCreate(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
        }

        function removeUser(selectedList){
            if (confirm('<fmt:message key="usersAdmin.user.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/user/list';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/user/removeMultiple', callback, 'userIds='+selectedList);
            }
        }
    </script>

<commons:footer />

