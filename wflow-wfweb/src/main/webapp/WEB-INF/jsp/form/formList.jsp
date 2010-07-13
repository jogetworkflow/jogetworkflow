<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="formsAdmin.form.list.label.title"
    helpTitle="wflowHelp.form.list.title"
    help="wflowHelp.form.list.content"
/>
        
    <div id="main-body-content">
        <div id="main-body-content-filter">
            <form>
            <fmt:message key="formsAdmin.form.list.label.categoryFilter"/>
            <select onchange="filter(JsonDataTable, '&categoryId=', this.options[this.selectedIndex].value)">
                <option></option>
            <c:forEach items="${categoryList}" var="category">
                <c:set var="selected"><c:if test="${category.id == param.categoryId}"> selected</c:if></c:set>
                <option value="${category.id}" ${selected}>${category.name}</option>
            </c:forEach>
            </select>
            </form>
        </div>
        
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/list?${pageContext.request.queryString}"
                   var="JsonDataTable"
                   divToUpdate="formList"
                   jsonData="data"
                   rowsPerPage="10"
                   width="100%"
                   sort="name"
                   desc="false"
                   href="${pageContext.request.contextPath}/web/admin/form/general/view"
                   hrefParam="id"
                   hrefQuery="false"
                   hrefDialog="false"
                   hrefDialogWidth="600px"
                   hrefDialogHeight="400px"
                   hrefDialogTitle="Form Dialog"
                   fields="['id','name','version','tableName','created','modified','categoryName']"
                   column1="{key: 'name', label: 'formsAdmin.form.list.label.name', sortable: true}"
                   column2="{key: 'version', label: 'formsAdmin.form.list.label.version', sortable: false}"
                   column3="{key: 'tableName', label: 'formsAdmin.form.list.label.tableName', sortable: true}"
                   column4="{key: 'categoryName', label: 'formsAdmin.form.list.label.category', sortable: false}"
                   column5="{key: 'created', label: 'formsAdmin.form.list.label.created', sortable: false}"
                   column6="{key: 'modified', label: 'formsAdmin.form.list.label.modified', sortable: false}"
                   />
        <div id="main-body-actions">
            <input type="button" onclick="createForm()" value="<fmt:message key="formsAdmin.form.list.label.createForm"/>">
        </div>
    </div>

    <script type="text/javascript">
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/admin/form/general/create"/>
        
        function createForm(){
            popupDialog.init();
        }
        
        function closeDialog(){
            popupDialog.close();
        }
    </script>
    
<commons:footer />