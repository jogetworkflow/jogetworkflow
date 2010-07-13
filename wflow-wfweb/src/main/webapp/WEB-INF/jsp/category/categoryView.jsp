<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="formsAdmin.category.view.label.title"
    path1="${pageContext.request.contextPath}/web/admin/form/category/view/${category.id}"
    name1="formsAdmin.main.body.path.category.view"
    helpTitle="wflowHelp.category.view.title"
    help="wflowHelp.category.view.content"
/>

    <div id="main-body-content">
        <dl>
            <dt><fmt:message key="formsAdmin.category.view.label.name"/></dt>
            <dd>${category.name}&nbsp;</dd>
            <dt><fmt:message key="formsAdmin.category.view.label.description"/></dt>
            <dd>${category.description}&nbsp;</dd>
        </dl>
        
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="general.method.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="formsAdmin.category.view.label.deleteCategory"/>" onclick="del()"/></span>
        </div>

        <div id="main-body-content-subheader">
            <fmt:message key="formsAdmin.category.view.label.formList"/>
        </div>
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/list?categoryId=${category.id}&${pageContext.request.queryString}" 
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
                       hrefDialogWidth=""
                       hrefDialogHeight=""
                       hrefDialogTitle="Form Dialog"
                       checkbox="true"
                       checkboxButton1="formsAdmin.form.list.label.createForm"
                       checkboxCallback1="createForm"
                       checkboxButton2="general.method.label.delete"
                       checkboxCallback2="removeForm"
                       fields="['id','name','version','tableName','created','modified']"
                       column1="{key: 'name', label: 'formsAdmin.form.list.label.name', sortable: true}"
                       column2="{key: 'version', label: 'formsAdmin.form.list.label.version', sortable: false}"
                       column3="{key: 'tableName', label: 'formsAdmin.form.list.label.tableName', sortable: true}"
                       column4="{key: 'created', label: 'formsAdmin.form.list.label.created', sortable: false}"
                       column5="{key: 'modified', label: 'formsAdmin.form.list.label.modified', sortable: false}"
                       />
        <div id="formList"></div>
    </div>

    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/admin/form/category/edit/${category.id}"/>
        
        function edit(){
            popupDialog.init();
        }
        
        function del(){
            if (confirm("<fmt:message key="formsAdmin.category.view.label.deleteConfirm"/>")) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/admin/form/category/list';
                    }
                }
                ConnectionManager.post('${pageContext.request.contextPath}/web/admin/form/category/delete', callback, 'categoryId=${category.id}');
            }
        }
        
        function closeDialog() {
            popupDialog.close();
        }

         <ui:popupdialog var="popupDialogCreate" src="${pageContext.request.contextPath}/web/admin/form/general/create?categoryId=${category.id}&redirect=true"/>

        function createForm(ids){
            popupDialogCreate.init();
        }

        function removeForm(ids){
            if (confirm('<fmt:message key='formsAdmin.form.list.label.removeForm.confirm'/>')) {
                var callback = {
                    success : function() {
                        alert("<fmt:message key='formsAdmin.form.list.label.removeForm.removed'/>");
                        document.location = '${pageContext.request.contextPath}/web/admin/form/category/view/${category.id}';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/admin/form/general/deleteMultiple', callback, 'ids='+ids);
            }
        }
    </script>
<commons:footer />
