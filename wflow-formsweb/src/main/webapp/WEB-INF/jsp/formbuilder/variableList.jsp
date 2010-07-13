<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
    </div>

    <div id="main-body-content">
        <div>
            <ui:jsontable url="${pageContext.request.contextPath}/web/formbuilder/variable/json/list?${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="formVariableList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       checkbox="true"
                       checkboxId="id"
                       checkboxButton1="general.method.label.submit"
                       checkboxCallback1="submitFormVariable"
                       checkboxSelectSingle="true"
                       checkboxSelection="true"
                       fields="['id','name','pluginName']"
                       column1="{key: 'name', label: 'wflowForm.variable.list.label.variableName', sortable: true, width: '300'}"
                       column2="{key: 'pluginName', label: 'wflowForm.variable.list.label.pluginName', sortable: false, width: '300'}"
                       />
        </div>
    </div>

    <script>
        function submitFormVariable(id){
            parent.setFormVariable(id);
        }
    </script>

<commons:popupFooter />