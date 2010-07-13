<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header />

    <div id="main-body-content">

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/organization/department/list/(*:organizationId)"
                       var="JsonDataTable"
                       divToUpdate="departmentList" 
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
                       fields="['id','name','description']"
                       column1="{key: 'name', label: 'usersAdmin.department.list.label.name', sortable: true}"
                       column2="{key: 'description', label: 'usersAdmin.department.list.label.description', sortable: false}"
                       />
        <div id="departmentList"></div>

    </div>

<commons:footer />