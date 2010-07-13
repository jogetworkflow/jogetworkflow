<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.organization.view.label.title"
    path1="${pageContext.request.contextPath}/web/directory/admin/organization/view/${organization.id}"
    name1="usersAdmin.main.body.path.organization.view"
    helpTitle="wflowHelp.organization.view.title"
    help="wflowHelp.organization.view.content"
    />

<div id="main-body-content">

    <dl>
        <dt><fmt:message key="usersAdmin.organization.view.label.name"/></dt>
        <dd>${organization.name}&nbsp;</dd>
        <dt><fmt:message key="usersAdmin.organization.view.label.description"/></dt>
        <dd>${organization.description}&nbsp;</dd>
    </dl>

    <div class="form-buttons">
        <span class="button"><input type="button" value="<fmt:message key="usersAdmin.organization.view.label.edit"/>" onclick="edit()"/></span>
        <span class="button"><input type="button" value="<fmt:message key="usersAdmin.organization.view.label.delete"/>" onclick="del()"/></span>
    </div>

    <div id="main-body-content-subheader">
        <fmt:message key="usersAdmin.department.list.label.subtitle"/>
    </div>

    <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/department/list?organizationId=${organization.id}&${pageContext.request.queryString}"
                  var="JsonDeptDataTable"
                  divToUpdate="departmentList"
                  jsonData="data"
                  rowsPerPage="10"
                  width="100%"
                  height="200"
                  sort="e.name"
                  desc="false"
                  href="${pageContext.request.contextPath}/web/directory/admin/organization/department/view"
                  hrefParam="id"
                  hrefQuery="false"
                  hrefDialog="false"
                  hrefDialogWidth=""
                  hrefDialogHeight=""
                  hrefDialogTitle="Form Dialog"
                  checkbox="true"
                  checkboxButton1="usersAdmin.organization.view.label.createDepartment"
                  checkboxCallback1="createDepartment"
                  checkboxButton2="wflowAdmin.running.process.list.label.delete"
                  checkboxCallback2="removeDepartment"
                  fields="['id','name','description']"
                  column1="{key: 'name', label: 'usersAdmin.organization.view.department.list.label.name', sortable: true}"
                  column2="{key: 'description', label: 'usersAdmin.organization.view.department.list.label.description', sortable: false}"
                  column3="{key: 'parentDepartment', label: 'usersAdmin.organization.view.department.list.label.parentDepartment', sortable: false}"
                  />
    <div id="main-body-content-subheader">
        <fmt:message key="usersAdmin.grade.list.label.subtitle"/>
    </div>

    <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/grade/list?organizationId=${organization.id}&${pageContext.request.queryString}"
                  var="JsonGradeDataTable"
                  divToUpdate="gradeList"
                  jsonData="data"
                  rowsPerPage="10"
                  width="100%"
                  height="200"
                  sort="e.name"
                  desc="false"
                  href="${pageContext.request.contextPath}/web/directory/admin/organization/grade/view"
                  hrefParam="id"
                  hrefQuery="false"
                  hrefDialog="false"
                  hrefDialogWidth=""
                  hrefDialogHeight=""
                  hrefDialogTitle="Form Dialog"
                  checkbox="true"
                  checkboxButton1="usersAdmin.organization.view.label.createGrade"
                  checkboxCallback1="createGrade"
                  checkboxButton2="wflowAdmin.running.process.list.label.delete"
                  checkboxCallback2="removeGrade"
                  fields="['id','name','description']"
                  column1="{key: 'name', label: 'usersAdmin.organization.view.grade.list.label.name', sortable: true}"
                  column2="{key: 'description', label: 'usersAdmin.organization.view.grade.list.label.description', sortable: false}"
                  />
    </div>

<script>
    <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/organization/edit?organizationId=${organization.id}"/>
    
    function edit(){
        popupDialog.init();
    }
        
    function closeDialog(){
        popupDialog.close();
        popupDialog2.close();
        popupDialog3.close();
    }

    <ui:popupdialog var="popupDialog2" src="${pageContext.request.contextPath}/web/directory/admin/organization/department/new?organizationId=${organization.id}"/>
        
    function createDepartment(){
        popupDialog2.init();
    }

    <ui:popupdialog var="popupDialog3" src="${pageContext.request.contextPath}/web/directory/admin/organization/grade/new?organizationId=${organization.id}"/>
        
    function createGrade(){
        popupDialog3.init();
    }
        
    function del(){
        if (confirm('<fmt:message key="usersAdmin.organization.view.confirmation.delete"/>')) {
            var callback = {
                success : function() {
                    document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/list';
                }
            }
            var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/remove', callback, 'organizationId=${organization.id}');
        }
    }

    function removeDepartment(selectedDept){
        if (confirm('<fmt:message key="usersAdmin.department.view.confirmation.delete"/>')) {           
            var callback = {
                success : function() {
                    document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/view/${organization.id}';
                }
            }
            var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/department/removeMultiple', callback, 'departmentIds='+selectedDept);
        }
    }

    function removeGrade(selectedList){
        if (confirm('<fmt:message key="usersAdmin.grade.view.confirmation.delete"/>')) {
            var callback = {
                success : function() {
                    document.location = '${pageContext.request.contextPath}/web/directory/admin/organization/view/${organization.id}';
                }
            }
            var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/organization/grade/removeMultiple', callback, 'gradeIds='+selectedList);
        }
    }
</script>

<commons:footer />
