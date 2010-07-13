<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.group.view.label.title"
    path1="${pageContext.request.contextPath}/web/directory/admin/group/view/${group.id}"
    name1="Group View"
    helpTitle="wflowHelp.group.view.title"
    help="wflowHelp.group.view.content"
/>
    
    <div id="main-body-content">
        
        <dl>
            <dt><fmt:message key="usersAdmin.group.view.label.id"/></dt>
            <dd>${group.id}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.group.view.label.name"/></dt>
            <dd>${group.name}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.group.view.label.description"/></dt>
            <dd>${group.description}&nbsp;</dd>
        </dl>
        
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="general.method.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="general.method.label.delete"/>" onclick="del()"/></span>
        </div>
        
        <div id="main-body-content-subheader">
        	<fmt:message key="usersAdmin.user.list.label.subtitle"/>
        </div> 
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/group/user/list?groupId=${group.id}" 
                       var="JsonDataTable"
                       divToUpdate="userList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="firstName"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/user/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       fields="['id','firstName','lastName']"
                       column1="{key: 'firstName', label: 'usersAdmin.group.view.label.first.name', sortable: true}"
                       column2="{key: 'lastName', label: 'usersAdmin.group.view.label.last.name', sortable: false}"
                       />
        
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.group.view.button.assign.users"/>" onclick="assign()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.group.view.button.unassign.users"/>" onclick="unassign()"/></span> 
        </div>
    </div>

    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/group/edit?groupId=${group.id}"/>
        
        function edit(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
            popupDialog2.close();
            popupDialog3.close();
        }

        <ui:popupdialog var="popupDialog2" src="${pageContext.request.contextPath}/web/directory/admin/user/assign?groupId=${group.id}"/>
        
        function assign(){
            popupDialog2.init();
        }
        
        <ui:popupdialog var="popupDialog3" src="${pageContext.request.contextPath}/web/directory/admin/user/unassign?groupId=${group.id}"/>
        
        function unassign(){
            popupDialog3.init();
        }

        function del(){
            if (confirm('<fmt:message key="usersAdmin.group.view.confirmation.remove"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/group/list';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/group/remove', callback, 'groupId=${group.id}'); 
            }
        }
    </script>

<commons:footer />