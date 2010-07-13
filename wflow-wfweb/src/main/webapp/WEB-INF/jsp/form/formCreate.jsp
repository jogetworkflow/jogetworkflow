<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="formsAdmin.form.new.label.title"/>
    </div>
    <div id="main-body-content">
        
        <c:url var="url" value="" /> 
        <form:form id="createForm" action="${pageContext.request.contextPath}/web/admin/form/general/create/submit" commandName="form" cssClass="form">
        
            <c:if test="${!empty param.activityId}">
                <input type="hidden" name="activityId" value="${param.activityId}">
                <input type="hidden" name="processId" value="${param.processId}">
                <input type="hidden" name="version" value="${param.version}">
                
            </c:if>

            <input type="hidden" name="redirect" value="${param.redirect}">

            <form:errors path="*" cssClass="form-errors"/>
            <fieldset>
                <legend><fmt:message key="formsAdmin.form.new.label.details"/></legend>
                <div class="form-row">
                    <label for="field1"><fmt:message key="formsAdmin.form.new.label.id"/></label>
                    <span class="form-input"><form:input path="id" cssErrorClass="form-input-error" /> *</span>
                </div>   
                <div class="form-row">
                    <label for="field1"><fmt:message key="formsAdmin.form.new.label.formName"/></label>
                    <span class="form-input"><form:input path="name" cssErrorClass="form-input-error" /> *</span>
                </div>       
                <div class="form-row">
                    <label for="field2"><fmt:message key="formsAdmin.form.new.label.tableName"/></label>
                    <span class="form-input"><form:input path="tableName" id="tableName" maxlength="28" autocomplete="off" /> *</span>
                </div>
                <div class="form-row">
                    <label for="field2"><fmt:message key="formsAdmin.form.new.label.category"/></label>
                    <span class="form-input">
                        <form:select path="categoryId" id="formCategoryId">
                            <!--option value="-"><fmt:message key="formsAdmin.form.new.label.categoryDefault"/></option-->
                            <form:options items="${categories}" itemValue="id" itemLabel="name"/>
                        </form:select>
                    </span>
                    <span class="form-buttons">
                        <input id="newCategoryButton" type="button" value="<fmt:message key="general.method.label.addnewcategory"/>" onclick="addNewCategory()">
                    </span>
                </div>

                <div id="newCategory">
                    <div class="form">
                        <fieldset>
                            <legend><fmt:message key="formsAdmin.category.new.label.details"/></legend>
                            <div class="form-row">
                                <label for="id"><fmt:message key="formsAdmin.category.new.label.id"/></label>
                                <span class="form-input"><input type="text" id="categoryId" /> *</span>
                            </div>
                            <div class="form-row">
                                <label for="name"><fmt:message key="formsAdmin.category.new.label.name"/></label>
                                <span class="form-input"><input type="text" id="categoryName" /> *</span>
                            </div>
                            <div class="form-row">
                                <label for="description"><fmt:message key="formsAdmin.category.new.label.description"/></label>
                                <span class="form-input"><textarea id="categoryDescription"></textarea></span>
                            </div>
                        </fieldset>

                        <div class="form-buttons">
                            <input class="form-button" type="button" value="<fmt:message key="general.method.label.save"/>" onclick="submitCategory()" />
                            <input class="form-button" type="button" value="<fmt:message key="general.method.label.cancel"/>" onclick="hideCategory()">
                        </div>
                    </div>
                </div>

            </fieldset>
            <fieldset>
                <legend><fmt:message key="formsAdmin.form.new.label.copyForm"/></legend>
                <div class="form-row">
                    <label for="copyFormId"><fmt:message key="formsAdmin.form.new.label.copyFormId"/></label>
                    <span class="form-input">
                        <input type="text" id="copyFormId" name="copyFormId" readonly value="${param.copyFormId}"/>
                    </span>
                    <c:if test="${empty param.copyFormId}">
                        <span class="form-buttons">
                            <input id="chooseFormButton" type="button" value="<fmt:message key="formsAdmin.form.new.label.chooseForm"/>" onclick="chooseForm()">
                        </span>
                    </c:if>
                </div>
                <c:if test="${empty param.copyFormId}">
                    <div id="chooseForm">
                        <fieldset>
                            <legend><fmt:message key="formsAdmin.form.new.label.chooseForm"/></legend>
                            <div id="main-body-content-filter">
                                <fmt:message key="wflowAdmin.activityAddForm.view.label.filterByCategory"/>
                                <select onchange="filter(JsonDataTable, '&categoryId=', this.options[this.selectedIndex].value)">
                                    <option></option>
                                    <c:forEach items="${categoryList}" var="category">
                                        <c:set var="selected"><c:if test="${category.id == param.categoryId}"> selected</c:if></c:set>
                                        <option value="${category.id}" ${selected}>${category.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/list?${pageContext.request.queryString}"
                                          var="JsonDataTable"
                                          divToUpdate="formList"
                                          jsonData="data"
                                          rowsPerPage="10"
                                          width="700px"
                                          sort="name"
                                          desc="false"
                                          checkbox="true"
                                          checkboxId="id"
                                          checkboxButton1="general.method.label.select"
                                          checkboxCallback1="updateCopyFormId"
                                          checkboxButton2="general.method.label.cancel"
                                          checkboxCallback2="hideChooseFormDiv"
                                          checkboxSelectSingle="true"
                                          fields="['id','name','version','created','modified','categoryName']"
                                          column1="{key: 'name', label: 'wflowAdmin.activityAddForm.view.label.formList.formName', sortable: true}"
                                          column2="{key: 'version', label: 'wflowAdmin.activityAddForm.view.label.formList.version', sortable: false}"
                                          column3="{key: 'categoryName', label: 'wflowAdmin.activityAddForm.view.label.formList.categoryName', sortable: false}"
                                          column4="{key: 'created', label: 'wflowAdmin.activityAddForm.view.label.formList.created', sortable: false}"
                                          column5="{key: 'modified', label: 'wflowAdmin.activityAddForm.view.label.formList.modified', sortable: false}"
                                          />
                        </fieldset>
                    </div>
                </c:if>
            </fieldset>
            <div class="form-buttons">
                <input class="form-button" type="button" value="<fmt:message key="general.method.label.save"/>"  onclick="validateField()"/>
                <input class="form-button" type="button" value="<fmt:message key="general.method.label.cancel"/>" onclick="closeDialog()"/>
            </div>
        </form:form>
    </div>
    
    <script type="text/javascript">
        var preventRecursiveClick = 0;
        $(document).ready(function(){
            
            var loadTableNameData = {
                success : function(response){
                    var data = eval('(' + response + ')');
                    
                    $("#tableName").autocomplete(data.tableName, {minChars: 0});
                    $("#tableName").click(function(){
                        if(preventRecursiveClick < 1){
                            preventRecursiveClick = preventRecursiveClick + 1;
                            $("#tableName").trigger("click");
                        }else{
                            preventRecursiveClick = 0;
                        }
                    });
                    $("#tableName").focus(function(){
                        $("#tableName").trigger("click");
                    });
                }
            }
            ConnectionManager.get('${pageContext.request.contextPath}/web/json/form/getAllTableName', loadTableNameData);

            var categoryId = '${param.categoryId}';
            if(categoryId.length > 0){
                $('#formCategoryId option[value=' + categoryId + ']').attr('selected', 'true');
            }
        });

        function filter(jsonTable, url, value){
            var newUrl = url + value;
            jsonTable.load("${pageContext.request.contextPath}/web/json/form/list?" + newUrl);
        }

        function validateField(){
            var match = /^[\w]+$/.test($("#tableName").attr("value"));
            var idMatch = /^[0-9a-zA-Z_-]+$/.test($("#id").attr("value"));
            if(!idMatch || !match){
                var alertString = '';
                if(!idMatch){
                    alertString = '<fmt:message key="formsAdmin.form.new.label.formIdInvalid"/>';
                    $("#id").focus();
                }
                if(!idMatch && !match){
                    alertString += '\n';
                }
                if(!match){
                    alertString += '<fmt:message key="formsAdmin.category.new.label.tableNameInvalid"/>';
                }
                if(idMatch && !match){
                    $("#tableName").focus();
                }
                alert(alertString);
            }else{
                $("#createForm").submit();
            }
        }

        $('#newCategory').hide();
        $('#chooseForm').hide();

        function submitCategory(){
            var categoryId=$('#categoryId').val();
            var categoryName=$('#categoryName').val();
            var categoryDescription=$('#categoryDescription').val();
            var cidMatch = /^[0-9a-zA-Z_-]+$/.test(categoryId);

            if(categoryId=='') alert('<fmt:message key="Category.id[not.blank]"/>');
            else if(!cidMatch) alert('<fmt:message key="Category.id[regexp]"/>');
            else if(categoryName=='') alert('<fmt:message key="Category.name[not.blank]" />');
            else {
                var url='${pageContext.request.contextPath}/web/json/form/category/create/submit';
                var params='categoryId='+categoryId+'&categoryName='+categoryName+'&categoryDescription='+categoryDescription;

                submitCategoryCallback = {
                    success: function(json){
                        var data = eval('('+json+')');
                        var status = data.status;
                        var categoryIdExist = data.categoryIdExist;

                        if(status=='success' && !categoryIdExist) {
                            var catId = $('#categoryId').val();
                            var catName = $('#categoryName').val();
                            
                            var option = '<option id="'+catId+'" value="'+catId+'" selected>'+catName+'</option>';
                            $('#formCategoryId').append(option);

                            hideCategory();
                        } else {
                            alert('<fmt:message key="formsAdmin.category.new.label.categoryIdInvalid"/>');
                        }
                    }
                }

                ConnectionManager.post(url, submitCategoryCallback, params);
            }
        }

        function addNewCategory(){
            $('#newCategory').slideToggle('show');
            $('#newCategoryButton').attr('disabled', true);
        }

        function hideCategory(){
            $('#newCategory').slideToggle('hide');
            $('#newCategoryButton').attr('disabled', false);
            $('#categoryId').val('');
            $('#categoryName').val('');
            $('#categoryDescription').val('');
        }

        function chooseForm(){
            $('#chooseForm').slideToggle('show');
            $('#chooseFormButton').attr('disabled', true);
        }

        function hideChooseFormDiv(id){
            $('#chooseForm').slideToggle('hide');
            $('#chooseFormButton').attr('disabled', false);
        }

        function updateCopyFormId(id){
            $('#copyFormId').val(id);
            hideChooseFormDiv(id);
        }
        
        function closeDialog() {
            if (parent && parent.PopupDialog.closeDialog) {
                parent.PopupDialog.closeDialog();
            }
            return false;
        }
    </script>
    
<commons:popupFooter />

