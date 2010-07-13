<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.main.body.path.subdepartment.view"
    name1="usersAdmin.main.body.path.organization.view"
    path1="${pageContext.request.contextPath}/web/directory/admin/organization/view/${subdepartment.organization.id}"
    name2="usersAdmin.main.body.path.department.view"
    path2="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${parentId}"
    helpTitle="wflowHelp.subdepartment.view.title"
    help="wflowHelp.subdepartment.view.content"
/>
    
    <div id="main-body-content">
        
        <dl>
            <dt><fmt:message key="usersAdmin.organization.view.label.name"/></dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/view/${subdepartment.organization.id}">${subdepartment.organization.name}</a></dd>
            <dt><fmt:message key="usersAdmin.department.view.label.parent"/></dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/subdepartment/view/${subdepartment.parent.id}">${subdepartment.parent.name}</a></dd>
            <dt><fmt:message key="usersAdmin.department.view.label.name"/></dt>
            <dd>${subdepartment.name}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.department.view.label.description"/></dt>
            <dd>${subdepartment.description}&nbsp;</dd>
	</dl>
		
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.delete"/>" onclick="del()"/></span>
        </div>
        
        
        <div id="main-body-content-subheader">
        	<fmt:message key="usersAdmin.subdeparment.list.label.subtitle"/>
        </div> 
               
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/subdepartment/list?departmentId=${subdepartment.id}"
                       var="JsonSubDeptDataTable"
                       divToUpdate="subdepartmentList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       height="200"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/organization/subdepartment/view"
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
        
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/employee/list?departmentId=${subdepartment.id}"
                       var="JsonDataTable"
                       divToUpdate="employeeList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       height="200"
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
        <div id="employeeList"></div>

	<div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.assign"/>" onclick="assignEmployment()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.department.view.label.unassign"/>" onclick="unassignEmployment()"/></span>
        </div>

    </div>

     <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/organization/department/edit?departmentId=${subdepartment.id}"/>
        
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

        <ui:popupdialog var="popupDialog2" src="${pageContext.request.contextPath}/web/directory/admin/organization/subdepartment/new?departmentId=${subdepartment.id}&organizationId=${subdepartment.organization.id}"/>
        
        function createSubDepartment(){
            popupDialog2.init();
        }

        <ui:popupdialog var="popupDialog3" src="${pageContext.request.contextPath}/web/directory/admin/organization/employee/assign?departmentId=${subdepartment.id}"/>
        
        function assignEmployment(){
            popupDialog3.init();
        }

        <ui:popupdialog var="popupDialog4" src="${pageContext.request.contextPath}/web/directory/admin/organization/employee/unassign?departmentId=${subdepartment.id}"/>
        
        function unassignEmployment(){
            popupDialog4.init();
        }

        <ui:popupdialog var="popupDialog5" src="${pageContext.request.contextPath}/web/directory/admin/organization/employee/new?departmentId=${subdepartment.id}"/>
        
        function createEmployment(){
            popupDialog5.init();
        }
        
        function del(){
            if (confirm('<fmt:message key="usersAdmin.department.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/view/${subdepartment.organization.id}';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/department/remove', callback, 'departmentId=${subdepartment.id}');
            }
        }

        function removeSubDept(selectedList){
            if (confirm('<fmt:message key="usersAdmin.department.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/subdepartment/view/${subdepartment.id}';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/department/removeMultiple', callback, 'departmentIds='+selectedList);
            }
        }
    </script>
<commons:footer />