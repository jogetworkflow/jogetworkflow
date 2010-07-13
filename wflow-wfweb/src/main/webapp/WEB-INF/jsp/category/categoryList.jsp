<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="formsAdmin.main.body.path.category"
    helpTitle="wflowHelp.category.list.title"
    help="wflowHelp.category.list.content"
/>
    
    <div id="main-body-content">
        <div>
            <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/category/list?${pageContext.request.queryString}" 
                       var="JsonDataTable"
                       divToUpdate="categoryList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/admin/form/category/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Category Dialog"
                       fields="['id','name','description']"
                       column1="{key: 'name', label: 'formsAdmin.category.list.label.name', sortable: true}"
                       column2="{key: 'description', label: 'formsAdmin.category.list.label.description', sortable: true}"
                       />
            <div id="categoryList"></div>
        </div>
        <div id="main-body-actions">
            <input type="button" onclick="createCategory()" value="<fmt:message key="formsAdmin.category.list.label.createCategory"/>">
        </div>
    </div>

    <script type="text/javascript">
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/admin/form/category/create"/>
        
        function createCategory(){
            popupDialog.init();
        }
        
        function closeDialog(){
            popupDialog.close();
        }
    </script>

<commons:footer />