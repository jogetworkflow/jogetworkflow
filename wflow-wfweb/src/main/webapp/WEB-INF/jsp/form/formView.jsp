<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="formsAdmin.form.view.label.title"
    path0="${pageContext.request.contextPath}/web/admin/form/category/list"
    name0="formsAdmin.main.body.path.form.list"
    path1="${pageContext.request.contextPath}/web/admin/form/category/view/${form.categoryId}"
    name1="formsAdmin.main.body.path.category.view"
    path2="${pageContext.request.contextPath}/web/admin/form/general/view/${form.id}"
    name2="formsAdmin.main.body.path.form.view"
    helpTitle="wflowHelp.form.view.title"
    help="wflowHelp.form.view.content"
/>

    <div id="main-body-content">  
        <dl>
            <dt><fmt:message key="formsAdmin.form.view.label.name"/></dt>
            <dd>${form.name}&nbsp;</dd>
            <dt><fmt:message key="formsAdmin.form.view.label.tableName"/></dt>
            <dd>${form.tableName}&nbsp;</dd>
            <dt><fmt:message key="formsAdmin.form.view.label.category"/></dt>
            <dd><a target="_blank" href="${pageContext.request.contextPath}/web/admin/form/category/view/${form.category.id}">${form.category.name}</a>&nbsp;</dd>
            <dt><fmt:message key="formsAdmin.form.view.label.created"/></dt>
            <dd>${form.created}&nbsp;</dd>
            <dt><fmt:message key="formsAdmin.form.view.label.modified"/></dt>
            <dd>${form.modified}&nbsp;</dd>
        </dl>
    
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="formsAdmin.form.view.label.launchDesigner"/>" onclick="openDesigner('${form.id}')" /></span>
            <span class="button"><input type="button" value="<fmt:message key="formsAdmin.form.view.label.preview"/>" onclick="previewForm('${form.id}')" /></span>
            <span class="button"><input type="button" value="<fmt:message key="formsAdmin.form.view.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="formsAdmin.form.view.label.delete"/>" onclick="del()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="formsAdmin.form.view.label.copyForm"/>" onclick="copyForm()"/></span>
        </div>

        <div id="formDetail">
            <ul>
                <li class="selected"><a href="#parentForm"><span><fmt:message key="formsAdmin.form.view.label.parentFormList"/></span></a></li>
                <li><a href="#formActivity"><span><fmt:message key="formsAdmin.form.view.label.activityList"/></span></a></li>
                <li><a href="#formData"><span><fmt:message key="formsAdmin.form.view.data.label.title"/></span></a></li>
            </ul>
            <div>
                <div id="parentForm">
                    <br/>
                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/parents/${form.id}?${pageContext.request.queryString}"
                                   var="JsonDataTable"
                                   divToUpdate="parentFormList"
                                   jsonData="data"
                                   rowsPerPage="10"
                                   width="100%"
                                   sort="created"
                                   desc="false"
                                   href="${pageContext.request.contextPath}/web/admin/form/general/view/"
                                   hrefParam="id"
                                   hrefQuery="false"
                                   hrefDialog="false"
                                   fields="['id','name','version','tableName','created','modified','category']"
                                   column1="{key: 'name', label: 'formsAdmin.form.view.label.parentFormList.name', sortable: true}"
                                   column2="{key: 'version', label: 'formsAdmin.form.view.label.parentFormList.version', sortable: false}"
                                   column3="{key: 'tableName', label: 'formsAdmin.form.view.label.parentFormList.tableName', sortable: true}"
                                   column4="{key: 'categoryName', label: 'formsAdmin.form.view.label.parentFormList.category', sortable: false}"
                                   column5="{key: 'created', label: 'formsAdmin.form.view.label.parentFormList.created', sortable: false}"
                                   column6="{key: 'modified', label: 'formsAdmin.form.view.label.parentFormList.modified', sortable: false}"
                                   />
                </div>
                <div id="formActivity">
                    <br/>
                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/process/list/${form.id}?${pageContext.request.queryString}"
                                   var="JsonDataTable"
                                   divToUpdate="formProcessActivityList"
                                   jsonData="data"
                                   rowsPerPage="10"
                                   width="100%"
                                   sort="created"
                                   desc="false"
                                   href="${pageContext.request.contextPath}/web/admin/process/configure/view/"
                                   hrefParam="processDefId"
                                   hrefQuery="false"
                                   hrefDialog="false"
                                   fields="['processDefId','packageName','processName','version','activityName']"
                                   column1="{key: 'packageName', label: 'formsAdmin.form.view.label.activityList.packageName', sortable: false}"
                                   column2="{key: 'processName', label: 'formsAdmin.form.view.label.activityList.processName', sortable: false}"
                                   column3="{key: 'version', label: 'formsAdmin.form.view.label.activityList.version', sortable: false}"
                                   column4="{key: 'activityName', label: 'formsAdmin.form.view.label.activityList.activityName', sortable: false}"
                                   />
                </div>
                <div id="formData">
                    <br/>
                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/data/list/${form.id}?${pageContext.request.queryString}"
                                   var="JsonDataTable"
                                   divToUpdate="dataList"
                                   jsonData="data"
                                   rowsPerPage="10"
                                   width="100%"
                                   sort="created"
                                   desc="false"
                                   href="${pageContext.request.contextPath}/web/formbuilder/view/${form.id}?preview=true&"
                                   hrefParam="processId"
                                   hrefQuery="true"
                                   hrefDialog="true"
                                   hrefDialogWindowName="formUserview"
                                   fields="['id','processId','version','username','created','modified']"
                                   column1="{key: 'processId', label: 'formsAdmin.form.view.data.label.processInstanceId', sortable: true}"
                                   column2="{key: 'version', label: 'formsAdmin.form.view.data.label.version', sortable: true}"
                                   column3="{key: 'username', label: 'formsAdmin.form.view.data.label.username', sortable: true}"
                                   column4="{key: 'created', label: 'formsAdmin.form.view.data.label.created', sortable: true}"
                                   column5="{key: 'modified', label: 'formsAdmin.form.view.data.label.modified', sortable: true}"
                                   />
                </div>
            </div>
        </div>
        
    </div>

    <script>
        var tabView = new TabView('formDetail', 'top');
        tabView.init();

        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/admin/form/general/edit/${form.id}"/>
        
        function edit(){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/form/general/edit/${form.id}";
            popupDialog.init();
        }
        
        function del(){
            if (confirm("<fmt:message key="formsAdmin.form.view.label.deleteConfirm"/>")) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/admin/form/category/view/${form.category.id}';
                    }
                }
                ConnectionManager.post('${pageContext.request.contextPath}/web/admin/form/general/delete', callback, 'formId=${form.id}');
            }
        }

        function copyForm(){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/form/general/create?copyFormId=${form.id}&redirect=true";
            popupDialog.init();
        }
    
        function openDesigner(formId){
            window.open("${pageContext.request.contextPath}/web/formbuilder/admin/edit/" + formId);
        }

        function previewForm(formId){
            window.open("${pageContext.request.contextPath}/web/formbuilder/view/" + formId + "?preview=true");
        }
        
        function closeDialog() {
            popupDialog.close();
        }
    </script>
<commons:footer />
