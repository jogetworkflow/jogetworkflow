<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.employment.view.label.title"
    path1="${pageContext.request.contextPath}/web/directory/admin/organization/view/${employment.department.organization.id}"
    name1="usersAdmin.main.body.path.organization.view"
    path2="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${employment.department.id}"
    name2="usersAdmin.main.body.path.department.view"
    path3="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${employment.id}"
    name3="usersAdmin.main.body.path.employment.view"
    helpTitle="wflowHelp.employment.view.title"
    help="wflowHelp.employment.view.content"
/>
    
    <div id="main-body-content">
        
        <dl>
            <dt><fmt:message key="usersAdmin.organization.view.label.name"/></dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/view/${employment.department.organization.id}">${employment.department.organization.name}</a>&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.department.view.label.name"/></dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${employment.department.id}">${employment.department.name}</a>&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.employeeCode"/></dt>
            <dd>${employment.user.firstName} ${employment.user.lastName}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.start.date"/></dt>
            <dd>${employment.startDate}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.end.date"/></dt>
            <dd>${employment.endDate}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.hod"/></dt>

            <c:choose>
                <c:when test="${employment.department.hod == employment}">
                    <dd><fmt:message key="usersAdmin.employment.view.hod.yes"/></dd>
                </c:when>
                <c:otherwise>
                    <dd><fmt:message key="usersAdmin.employment.view.hod.no"/></dd>
                </c:otherwise>
            </c:choose>
        </dl>
		
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="general.method.label.edit"/>" onclick="edit()"/></span>

            <c:choose>
                <c:when test="${employment.department.hod != null && employment.department.hod.id == employment.id}">
                    <span class="button"><input type="button" value="<fmt:message key="general.method.label.remove.hod"/>" onclick="removeHod()"/></span>
                </c:when>
                <c:otherwise>
                    <span class="button"><input type="button" value="<fmt:message key="general.method.label.set.hod"/>" onclick="setHod()"/></span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
       
    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/organization/employee/edit?employmentId=${employment.id}"/>
        
        function edit(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
        }

        function setHod(){
          var callback = {
                success : function() {
                    parent.location.reload(true);
                    alert("<fmt:message key='usersAdmin.employment.view.label.employment.assigned.as.hod'/>")
                }
            }
            var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/employee/sethod', callback, 'employmentId=${employment.id}');
        }
        
        function removeHod(){
           var callback = {
                success : function() {
                    parent.location.reload(true);
                    alert("<fmt:message key='usersAdmin.employment.view.label.hod.removed'/>")
                }
            }
            var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/employee/removehod', callback, 'employmentId=${employment.id}');
        }
    </script>

<commons:footer />