<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />
<style>
    #externalFormIFrameStyle{
        width: 360px;
        height: 150px;
    }
</style>

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.activityAddForm.view.label.title"/>
    </div>

    <div id="main-body-content" style="text-align: left">
        <div id="formTabView">
            <ul>
                <li class="selected"><a href="#formList"><span><fmt:message key="wflowAdmin.activityAddForm.view.label.tab.formList"/></span></a></li>
                <li><a href="#externalForm"><span><fmt:message key="wflowAdmin.activityAddForm.view.label.tab.formExternal"/></span></a></li>
            </ul>
            <div>
                <div id="formList">
                    <br>
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

                    <%-- for multi-form support
                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/list?${pageContext.request.queryString}"
                                   var="JsonDataTable"
                                   divToUpdate="formList2"
                                   jsonData="data"
                                   rowsPerPage="10"
                                   width="100%"
                                   sort="name"
                                   desc="false"
                                   href=""
                                   hrefParam="id"
                                   hrefQuery="true"
                                   hrefDialog="false"
                                   hrefDialogWidth="600px"
                                   hrefDialogHeight="400px"
                                   hrefDialogTitle="Form Dialog"
                                   checkboxButton1="general.method.label.submit"
                                   checkboxCallback1="submitForm"
                                   checkboxButton2="wflowAdmin.activityAddForm.view.label.createForm"
                                   checkboxCallback2="createForm"
                                   checkbox="true"
                                   fields="['id','name','created','modified','categoryName']"
                                   column1="{key: 'name', label: 'wflowAdmin.activityAddForm.view.label.formList.formName', sortable: true}"
                                   column2="{key: 'categoryName', label: 'wflowAdmin.activityAddForm.view.label.formList.categoryName', sortable: false}"
                                   column3="{key: 'created', label: 'wflowAdmin.activityAddForm.view.label.formList.created', sortable: false}"
                                   column4="{key: 'modified', label: 'wflowAdmin.activityAddForm.view.label.formList.modified', sortable: false}"
                                   />
                    --%>
                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/form/list?${pageContext.request.queryString}"
                                   var="JsonDataTable"
                                   divToUpdate="formList2"
                                   jsonData="data"
                                   rowsPerPage="10"
                                   width="100%"
                                   sort="name"
                                   desc="false"
                                   href="${pageContext.request.contextPath}/web/admin/process/activity/form/add/submit?activityId=${activity.id}&processId=${process.encodedId}&version=${process.version}&"
                                   hrefParam="id"
                                   hrefQuery="true"
                                   hrefDialog="false"
                                   hrefDialogWidth="600px"
                                   hrefDialogHeight="400px"
                                   hrefDialogTitle="Form Dialog"
                                   checkboxButton1="wflowAdmin.activityAddForm.view.label.createForm"
                                   checkboxCallback1="createForm"
                                   fields="['id','name','version','created','modified','categoryName']"
                                   column1="{key: 'name', label: 'wflowAdmin.activityAddForm.view.label.formList.formName', sortable: true}"
                                   column2="{key: 'version', label: 'wflowAdmin.activityAddForm.view.label.formList.version', sortable: false}"
                                   column3="{key: 'categoryName', label: 'wflowAdmin.activityAddForm.view.label.formList.categoryName', sortable: false}"
                                   column4="{key: 'created', label: 'wflowAdmin.activityAddForm.view.label.formList.created', sortable: false}"
                                   column5="{key: 'modified', label: 'wflowAdmin.activityAddForm.view.label.formList.modified', sortable: false}"
                                   />
                </div>

                <div id="externalForm">
                    <br>
                    <form method="post" action="${pageContext.request.contextPath}/web/admin/process/activity/form/add/submit" class="form">
                        <input type="hidden" name="type" value="external"/>
                        <input type="hidden" name="activityId" value="${activity.id}"/>
                        <input type="hidden" name="processId" value="${process.id}"/>
                        <input type="hidden" name="version" value="${process.version}"/>
                        
                        <div class="form-row">
                            <label for="externalFormUrl"><fmt:message key="wflowAdmin.activityAddForm.view.label.formExternalUrl"/></label>
                            <span class="form-input">
                                <input id="externalFormUrl" type="text" name="externalFormUrl" size="70" value="${externalFormUrl}"/>
                            </span>
                        </div>
                        <div class="form-row">
                            <label for="externalFormIFrameStyle"><fmt:message key="wflowAdmin.activityAddForm.view.label.formIFrameStyle"/></label>
                            <span class="form-input">
                                <textarea id="externalFormIFrameStyle" name="externalFormIFrameStyle">${externalFormIFrameStyle}</textarea>
                            </span>
                        </div>
                        <div class="form-buttons">
                            <input class="form-button" type="submit" value="<fmt:message key="general.method.label.submit"/>" />
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script>
        var tabView = new TabView('formTabView', 'top');
        tabView.init();

        <c:if test="${param.activityId == 'runProcess'}">
            tabView.disable(1);
        </c:if>

        if("${externalFormUrl}" != ""){
            tabView.select(1);
        }
        
        function filter(jsonTable, url, value){
            var newUrl = url + value;
            jsonTable.load(jsonTable.url + newUrl);
        }

        function createForm(){
            document.location = "${pageContext.request.contextPath}/web/admin/form/general/create?activityId=${activity.id}&processId=${process.encodedId}&version=${process.version}&redirect=false";
        }

        <%-- for multi-form support
        function submitForm(id){
            var callback = {
                success : function() {
                    parent.location.reload(true);
                }
            }
            var params = "id=" + id + "&activityId=${activity.id}&processId=${process.encodedId}&version=${process.version}";
            ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/activity/form/add/submit', callback, params);
        }
        --%>
            
        function sel(formId){
            var callback = {
                success : function() {
                    document.location.reload(true);
                }
            }
            var params = "formId=" + formId + "&activityId=${activity.id}&processId=${process.encodedId}&version=${process.version}";
            ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/activity/form/add', callback, params); 
        }
    </script>
<commons:popupFooter />
