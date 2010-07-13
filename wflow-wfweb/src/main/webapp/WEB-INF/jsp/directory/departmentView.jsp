<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.deparment.view.label.title"
    path1="${pageContext.request.contextPath}/web/directory/admin/organization/view/${department.organization.id}"
    name1="usersAdmin.main.body.path.organization.view"
    path2="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${department.id}"
    name2="usersAdmin.main.body.path.department.view"
    helpTitle="wflowHelp.department.view.title"
    help="wflowHelp.department.view.content"
/>
    
    <div id="main-body-content">
        
        <dl>
            <dt><fmt:message key="usersAdmin.organization.view.label.name"/></dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/view/${department.organization.id}">${department.organization.name}</a></dd>
            <dt><fmt:message key="usersAdmin.department.view.label.name"/></dt>
            <dd>${department.name}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.department.view.label.description"/></dt>
            <dd>${department.description}&nbsp;</dd>
            <c:set var="parent" value="${department.parent}"/>
            <c:if test="${!empty parent}">
            <dt><fmt:message key="usersAdmin.department.view.label.parent"/>&nbsp;</dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${parent.id}">${parent.name}</a></dd>
            </c:if>
            <dt><fmt:message key="usersAdmin.department.view.label.hod"/></dt>
            <dd>
                <c:choose>
                    <c:when test="${!empty department.hod}">
                        <a href="${pageContext.request.contextPath}/web/directory/admin/organization/employee/view/${department.hod.id}">${department.hod.user.username}</a>
                    </c:when>
                    <c:otherwise>
                        -
                    </c:otherwise>
                </c:choose>
            </dd>
		</dl>
		
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.delete"/>" onclick="del()"/></span>
        </div>
        
        
        <div id="main-body-content-subheader">
        	<fmt:message key="usersAdmin.subdeparment.list.label.subtitle"/>
        </div> 
               
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/subdepartment/list?departmentId=${department.id}&${pageContext.request.queryString}"
                       var="JsonSubDeptDataTable"
                       divToUpdate="subdepartmentList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/organization/department/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth=""
                       hrefDialogHeight=""
                       hrefDialogTitle="Form Dialog"
                       checkbox="true"
                       checkboxButton1="usersAdmin.department.view.label.createSubdepartment"
                       checkboxCallback1="createSubDepartment"
                       checkboxButton2="wflowAdmin.running.process.list.label.delete"
                       checkboxCallback2="removeSubDept"
                       fields="['id','name','description']"
                       column1="{key: 'name', label: 'usersAdmin.department.view.label.name', sortable: true}"
                       column2="{key: 'description', label: 'usersAdmin.department.view.label.description', sortable: false}"
                       />
        <div id="subdepartmentList"></div>
               
        <div id="main-body-content-subheader">
            <fmt:message key="usersAdmin.employment.list.label.subtitle"/>
        </div> 
        
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/employee/list?departmentId=${department.id}&${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="employeeList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="employeeCode"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/organization/employee/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth=""
                       hrefDialogHeight=""
                       hrefDialogTitle="Form Dialog"
                       fields="['id','firstName','lastName','startDate','endDate']"
                       column1="{key: 'firstName', label: 'usersAdmin.department.view.label.first.name', sortable: true}"
                       column2="{key: 'lastName', label: 'usersAdmin.department.view.label.last.name', sortable: false}"
                       column3="{key: 'startDate', label: 'usersAdmin.department.view.label.start.date', sortable: true}"
                       column4="{key: 'endDate', label: 'usersAdmin.department.view.label.end.date', sortable: false}"
                       />

	<div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.assign"/>" onclick="assignEmployment()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.unassign"/>" onclick="unassignEmployment()"/></span>
        </div>

    </div>

    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/organization/department/edit?departmentId=${department.id}"/>
        
        function edit(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
            popupDialog2.close();
            popupDialog3.close();
            popupDialog4.close();
            popupDialog5.close();
        }
        
        <ui:popupdialog var="popupDialog2" src="${pageContext.request.contextPath}/web/directory/admin/organization/subdepartment/new?departmentId=${department.id}&organizationId=${department.organization.id}"/>
        
        function createSubDepartment(){
            popupDialog2.init();
        }
        
        <ui:popupdialog var="popupDialog3" src="${pageContext.request.contextPath}/web/directory/admin/organization/employee/assign?departmentId=${department.id}"/>
        
        function assignEmployment(){
            popupDialog3.init();
        }

        <ui:popupdialog var="popupDialog4" src="${pageContext.request.contextPath}/web/directory/admin/organization/employee/unassign?departmentId=${department.id}"/>
        
        function unassignEmployment(){
            popupDialog4.init();
        }

        <ui:popupdialog var="popupDialog5" src="${pageContext.request.contextPath}/web/directory/admin/organization/employee/new?departmentId=${department.id}"/>
        
        function createEmployment(){
            popupDialog5.init();
        }

        function del(){
            if (confirm('<fmt:message key="usersAdmin.department.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/view/${department.organization.id}';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/department/remove', callback, 'departmentId=${department.id}');
            }
        }

        function removeSubDept(selectedList){
            if (confirm('<fmt:message key="usersAdmin.department.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${department.id}';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/department/removeMultiple', callback, 'departmentIds='+selectedList);
            }
        }
    </script>
<commons:footer />