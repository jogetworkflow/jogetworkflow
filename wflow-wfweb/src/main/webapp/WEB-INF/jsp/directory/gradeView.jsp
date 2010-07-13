<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.grade.view.label.title"
    path1="${pageContext.request.contextPath}/web/directory/admin/organization/view/${grade.organization.id}"
    name1="usersAdmin.main.body.path.organization.view"
    path2="${pageContext.request.contextPath}/web/directory/admin/organization/grade/view/${grade.id}"
    name2="usersAdmin.main.body.path.grade.view"
    helpTitle="wflowHelp.grade.view.title"
    help="wflowHelp.grade.view.content"
/>
    
    <div id="main-body-content">
        <dl>
            <dt><fmt:message key="usersAdmin.grade.view.label.id"/></dt>
            <dd>${grade.id}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.grade.view.label.name"/></dt>
            <dd>${grade.name}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.grade.view.label.description"/></dt>
            <dd>${grade.description}&nbsp;</dd>
		</dl>
        
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="general.method.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="general.method.label.delete"/>" onclick="del()"/></span>
        </div>
    </div>

    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/organization/grade/edit?organizationId=${organization.id}&gradeId=${grade.id}"/>
        
        function edit(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
        }

        function del(){
            if (confirm('<fmt:message key="usersAdmin.grade.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/view/${grade.organization.id}';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/grade/remove', callback, 'gradeId=${grade.id}');
            }
        }
    </script>

<commons:footer />