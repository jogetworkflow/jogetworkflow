<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="wflowForm.list.label.title"/>
    </div>
    
    <div id="main-body-content">
        <div id="main-body-content-filter">
            <fmt:message key="wflowForm.list.label.categoryFilter"/>
            <select onchange="filter(JsonDataTable, '&categoryId=', this.options[this.selectedIndex].value)">
                <option></option>
                <c:forEach items="${categoryList}" var="category">
                    <c:set var="selected"><c:if test="${category.id == param.categoryId}"> selected</c:if></c:set>
                    <option value="${category.id}" ${selected}>${category.name}</option>
                </c:forEach>
            </select>
        </div>

        <div id="main-body-content-filter">
            <fmt:message key="wflowForm.list.label.subFormOption"/>
            <input type="radio" name="subFormType" id="subFormNormal" value="normal" checked="checked"> <fmt:message key="wflowForm.list.label.subFormOptionNormal"/>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="radio" name="subFormType" id="subFormLink" value="link"> <fmt:message key="wflowForm.list.label.subFormOptionLink"/>
        </div>

        <div id="main-body-content-filter">
            <fmt:message key="wflowForm.list.label.isFromParentProcess"/>
            
            &nbsp;&nbsp;&nbsp;&nbsp;
            <input type="checkbox" name="isFromParentProcess" id="isFromParentProcess" value="yes"> <fmt:message key="wflowForm.list.label.yes"/>
        </div>

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/list?${pageContext.request.queryString}"
                   var="JsonDataTable"
                   divToUpdate="formList"
                   jsonData="data"
                   rowsPerPage="10"
                   width="100%"
                   sort="name"
                   desc="false"
                   checkbox="true"
                   checkboxId="id"
                   checkboxButton1="general.method.label.submit"
                   checkboxCallback1="submitSubForm"
                   checkboxSelectSingle="true"
                   checkboxSelection="true"
                   fields="['id','name','version','created','modified','categoryName']"
                   column1="{key: 'name', label: 'wflowForm.list.label.formName', sortable: true}"
                   column2="{key: 'version', label: 'wflowForm.list.label.version', sortable: true}"
                   column3="{key: 'categoryName', label: 'wflowForm.list.label.categoryName', sortable: false}"
                   column4="{key: 'created', label: 'wflowForm.list.label.created', sortable: false}"
                   column5="{key: 'modified', label: 'wflowForm.list.label.modified', sortable: false}"
                   />
    </div>
    
    <script>
        function filter(jsonTable, url, value){
            var newUrl = url + value;
            jsonTable.load(jsonTable.url + newUrl);
        }

        function submitSubForm(id){
            if($('#subFormNormal').attr('checked')){
                if($('#isFromParentProcess').attr('checked'))
                    parent.formbuilder_load_subform(id, null, null, null, true);
                else
                    parent.formbuilder_load_subform(id);
            }else if($('#subFormLink').attr('checked')){
                if($('#isFromParentProcess').attr('checked'))
                    parent.formbuilder_load_subformAsLink(id, null, null, null, true);
                else
                    parent.formbuilder_load_subformAsLink(id);
            }
        }
    </script>
    
<commons:popupFooter />