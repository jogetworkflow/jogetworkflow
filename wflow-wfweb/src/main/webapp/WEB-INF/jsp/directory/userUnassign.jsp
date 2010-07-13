<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

<script src="${pageContext.request.contextPath}/js/json/util.js"></script>

    <div id="main-body-header">
        <fmt:message key="usersAdmin.user.unassign.label.title"/>
    </div>

    <div id="main-body-content"> 
         <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/group/unassign/list?userId=${userId}" 
                       var="JsonDataTable2"
                       divToUpdate="formList2" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       checkbox="true"
                       checkboxId="id"
                       checkboxButton1="general.method.label.unassign"
                       checkboxButton2="general.method.label.close"
                       checkboxCallback1="unassign"
                       checkboxCallback2="closeDialog"
                       checkboxSelection="true"
                       searchItems="name|Group Name"
                       fields="['id','name','description']"
                       column1="{key: 'name', label: 'usersAdmin.user.unassign.label.name', sortable: true}"
                       column2="{key: 'description', label: 'usersAdmin.user.unassign.label.description', sortable: true}"
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
            var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/group/unassign/submit', callback, 'assignId='+id+'&userId=${userId}');
        }
        
        
        function closeDialog() {
            if (parent && parent.closeDialog) {
                parent.closeDialog();
            }
            return false;
        }
    </script>
    
<commons:popupFooter />