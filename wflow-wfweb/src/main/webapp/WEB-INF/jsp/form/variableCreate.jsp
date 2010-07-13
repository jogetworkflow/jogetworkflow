<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.variable.new.label.title"/>
    </div>
    <div id="main-body-content">
        <c:url var="url" value="" />
        <form:form id="variableForm" action="${pageContext.request.contextPath}/web/settings/form/variable/create/submit" commandName="formVariable" cssClass="form" onsubmit="appendPluginSelection()">
            <input type="hidden" id="pluginName" name="pluginName" value=""/>

            <form:errors path="*" cssClass="form-errors"/>
            <fieldset>
                <legend><fmt:message key="wflowAdmin.variable.new.label.details"/></legend>
                <div class="form-row">
                    <label for="field1"><fmt:message key="wflowAdmin.variable.new.label.name"/></label>
                    <span class="form-input"><form:input path="name" cssErrorClass="form-input-error" /> *</span>
                </div>
            </fieldset>
            
            <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/plugin/list?pluginType=Form Variable&${pageContext.request.queryString}"
                           var="pluginJsonDataTable"
                           divToUpdate="pluginList"
                           jsonData="data"
                           rowsPerPage="10"
                           width="100%"
                           sort="name"
                           desc="false"
                           checkbox="true"
                           checkboxId="id"
                           checkboxSelectSingle="true"
                           fields="['id','name','description','version']"
                           column1="{key: 'name', label: 'wflowAdmin.variable.new.label.pluginName', sortable: true}"
                           column2="{key: 'description', label: 'wflowAdmin.variable.new.label.pluginDescription', sortable: true}"
                           column3="{key: 'version', label: 'wflowAdmin.variable.new.label.pluginVersion', sortable: false}"
                           />
                           
            <div class="form-buttons">
                <input class="form-button" type="submit" value="<fmt:message key="general.method.label.save"/>" />
                <input class="form-button" type="button" value="<fmt:message key="general.method.label.cancel"/>" onclick="closeDialog()"/>
            </div>
        </form:form>

    </div>

    
    <script type="text/javascript">
        function appendPluginSelection(){
            /*
            var form = $('#variableForm');
            var selectedPlugins = pluginJsonDataTable.getSelectedRows();
            for(i in selectedPlugins){
                form.append('<input type="hidden" name="pluginName" value="' + selectedPlugins[i] + '">');
            }
            */
            var selectedPlugin = pluginJsonDataTable.getSelectedRows();
            $('#pluginName').val(selectedPlugin);
        }

        function closeDialog() {
            if (parent && parent.closeDialog) {
                parent.closeDialog();
            }
            return false;
        }
    </script>

<commons:popupFooter />

