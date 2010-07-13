<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

<script src="${pageContext.request.contextPath}/js/json/util.js"></script>
    <div id="main-body-header">
        <fmt:message key="usersAdmin.group.unassign.label.title"/>
    </div>

    <div id="main-body-content"> 
         <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/user/unassign/list?groupId=${groupId}" 
                       var="JsonDataTable2"
                       divToUpdate="formList2" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="firstName"
                       desc="false"
                       checkbox="true"
                       checkboxId="id"
                       checkboxButton1="general.method.label.unassign"
                       checkboxButton2="general.method.label.close"
                       checkboxCallback1="unassign"
                       checkboxCallback2="closeDialog"
                       checkboxSelection="true"
                       searchItems="name|Username/First Name"
                       fields="['id', 'username','firstName','lastName']"
                       column1="{key: 'username', label: 'usersAdmin.group.unassign.label.user.login', sortable: true}"
                       column2="{key: 'firstName', label: 'usersAdmin.group.unassign.label.first.name', sortable: false}"
                       column3="{key: 'lastName', label: 'usersAdmin.group.unassign.label.last.name', sortable: false}"
                       />
    </div>
    
    <script>
        function unassign(id){
           var callback = {
                success : function() {
                    //parent.closeDialog();
                    parent.location.reload(true);
                }
            }
            var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/user/unassign/submit', callback, 'assignId='+id+'&groupId=${groupId}');
        }
        
        
        function closeDialog() {
            if (parent && parent.closeDialog) {
                parent.closeDialog();
            }
            return false;
        }
    </script>
    
<commons:popupFooter />