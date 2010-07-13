<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.organization.list.label.title"
    helpTitle="wflowHelp.organization.list.title"
    help="wflowHelp.organization.list.content"
/>

    <div id="main-body-content">
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/list?${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="organizationList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/organization/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       checkbox="true"
                       checkboxButton1="usersAdmin.organization.list.label.create"
                       checkboxCallback1="onCreate"
                       checkboxButton2="general.method.label.delete"
                       checkboxCallback2="removeOrganization"
                       searchItems="name|Organization Name"
                       fields="['id','name','description']"
                       column1="{key: 'name', label: 'usersAdmin.organization.list.label.name', sortable: true}"
                       column2="{key: 'description', label: 'usersAdmin.organization.list.label.description', sortable: false}"
                       />
    </div>
    
    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/organization/new"/>
        
        function onCreate(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
        }

        function removeOrganization(selectedList){
             if (confirm('<fmt:message key="usersAdmin.organization.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/list';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/removeMutliple', callback, 'organizationIds='+selectedList);
            }
        }
    </script>

<commons:footer />

