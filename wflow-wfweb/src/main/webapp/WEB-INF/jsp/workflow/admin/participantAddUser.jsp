<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<%
    String directoryManagerImpl = WorkflowUtil.getSystemSetupValue("directoryManagerImpl");
%>
<c:set var="directoryManagerImpl" value="<%= directoryManagerImpl %>"/>

<commons:popupHeader />

<style>
    .form-row label{
        width: auto;
    }
</style>

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.participantMapping.view.label.title"/>
    </div>

    <div id="main-body-content" style="text-align: left">
        <div class="tabSummary"><fmt:message key="wflowAdmin.participantMapping.view.summary.title"/></div>

        <div id="userTabView">
            <ul>
                <li class="selected"><a href="#userGroup"><span><fmt:message key="wflowAdmin.participantMapping.view.label.userGroup"/></span></a></li>
                <li><a href="#orgChart"><span><fmt:message key="wflowAdmin.participantMapping.view.label.orgChart"/></span></a></li>
                <li><a href="#workflowVariable"><span><fmt:message key="wflowAdmin.participantMapping.view.label.workflowVariable"/></span></a></li>
                <li><a href="#plugin"><span><fmt:message key="wflowAdmin.participantMapping.view.label.plugin"/></span></a></li>
            </ul>            
            <div>
                <div id="userGroup">
                    
                    <div id="userGroupTabView">
                        <ul>
                            <li class="selected"><a href="#group"><span><fmt:message key="wflowAdmin.participantMapping.view.label.group"/></span></a></li>
                            <li><a href="#user"><span><fmt:message key="wflowAdmin.participantMapping.view.label.user"/></span></a></li>
                        </ul>            
                        <div>
                            <div id="group">
                                <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/dynamic/admin/group/list?${pageContext.request.queryString}"
                                               var="groupDataTable"
                                               divToUpdate="groupList" 
                                               jsonData="data"
                                               rowsPerPage="10"
                                               width="100%"
                                               height="200"
                                               sort="name"
                                               desc="false"
                                               href=""
                                               hrefParam="id"
                                               hrefQuery="false"
                                               hrefDialog="false"
                                               hrefDialogWidth="600px"
                                               hrefDialogHeight="400px"
                                               hrefDialogTitle=""
                                               checkbox="true"
                                               checkboxId="id"
                                               checkboxButton1="general.method.label.submit"
                                               checkboxCallback1="submitGroup"
                                               checkboxSelection="true"
                                               checkboxSelectionTitle="Selected Groups"
                                               searchItems="name|Group Name"
                                               fields="['id','name','description']"
                                               column1="{key: 'name', label: 'wflowAdmin.participantMapping.view.label.group.groupName', sortable: true}"
                                               column2="{key: 'description', label: 'wflowAdmin.participantMapping.view.label.group.groupDescription', sortable: false}"
                                               /> 
                            </div>   
                            <div id="user">
                                <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/dynamic/admin/user/list?${pageContext.request.queryString}"
                                               var="userDataTable"
                                               divToUpdate="userList" 
                                               jsonData="data"
                                               rowsPerPage="10"
                                               width="100%"
                                               height="200"
                                               sort="firstName"
                                               desc="false"
                                               href=""
                                               hrefParam="id"
                                               hrefQuery="false"
                                               hrefDialog="false"
                                               hrefDialogWidth="600px"
                                               hrefDialogHeight="400px"
                                               hrefDialogTitle=""
                                               checkbox="true"
                                               checkboxId="id"
                                               checkboxButton1="general.method.label.submit"
                                               checkboxCallback1="submitUser"
                                               checkboxSelection="true"
                                               checkboxSelectionTitle="Selected Users"
                                               searchItems="name|Username/First Name"
                                               fields="['id','username','firstName','lastName']"
                                               column1="{key: 'username', label: 'wflowAdmin.participantMapping.view.label.user.username', sortable: true}"
                                               column2="{key: 'firstName', label: 'wflowAdmin.participantMapping.view.label.user.firstName', sortable: true}"
                                               column3="{key: 'lastName', label: 'wflowAdmin.participantMapping.view.label.user.lastName', sortable: true}"
                                               />
                            </div>   
                        </div>
                    </div>
                    
                </div>
                <div id="orgChart">
                    <div id="orgChartTabView">
                        <ul>
                            <li class="selected"><a href="#requester"><span><fmt:message key="wflowAdmin.participantMapping.view.label.performer"/></span></a></li>
                            <li><a href="#hod"><span><fmt:message key="wflowAdmin.participantMapping.view.label.hod"/></span></a></li>
                            <li><a href="#department"><span><fmt:message key="wflowAdmin.participantMapping.view.label.department"/></span></a></li>
                        </ul>            
                        <div>
                            <div id="requester">
                                <form name="requesterOrgChart" method="POST" action="${pageContext.request.contextPath}/web/admin/process/participant/user/add/submit">
                                    <input type="hidden" name="packageId" value="${process.packageId}"/>
                                    <input type="hidden" name="processId" value="${process.id}"/>
                                    <input type="hidden" name="version" value="${process.version}"/>
                                    <input type="hidden" name="participantId" value="${participant.id}"/>
                                    <div class="form-row">
                                    <label for="requester">
                                        <input id="requester" type="radio" name="participantType" value="requester" checked="checked"> <fmt:message key="wflowAdmin.participantMapping.view.label.performer.performer"/>
                                    </label>
                                    </div>
                                    <div class="form-row">
                                    <label for="requesterHod">
                                        <input id="requesterHod" type="radio" name="participantType" value="requesterHod"> <fmt:message key="wflowAdmin.participantMapping.view.label.performer.hod"/>
                                    </label>
                                    </div>  
                                    <div class="form-row">
                                    <label for="requesterSubordinates">
                                        <input id="requesterSubordinates" type="radio" name="participantType" value="requesterSubordinates"> <fmt:message key="wflowAdmin.participantMapping.view.label.performer.subordinate"/>
                                    </label>
                                    </div>  
                                    <div class="form-row">
                                    <label for="requesterDepartment">
                                        <input id="requesterDepartment" type="radio" name="participantType" value="requesterDepartment"> <fmt:message key="wflowAdmin.participantMapping.view.label.performer.department"/>
                                    </label>
                                    </div>
                                    <div class="form-row">
                                        <label for="activity"><fmt:message key="wflowAdmin.participantMapping.view.label.performer.activity"/></label>
                                        <span class="form-input">
                                            <select id="activity" name="activity">
                                                <option value=""><fmt:message key="wflowAdmin.participantMapping.view.label.performer.previousActivity"/></option>
                                                <c:forEach var="activity" items="${activityList}" varStatus="rowCounter">
                                                    <option value="${activity.id}">${activity.name}</option>
                                                </c:forEach>
                                            </select>
                                        </span>
                                    </div>
                                    <div class="form-buttons">
                                        <button type="submit" value="Submit"><fmt:message key="general.method.label.submit"/></button>
                                    </div>
                                </form>
                            </div>
                            <div id="hod">
                                <c:if test="${empty directoryManagerImpl}">
                                    <fmt:message key="wflowAdmin.participantMapping.view.label.hod.filterByOrganization"/>
                                    <select onchange="filter(hodDataTable, '&organizationId=', this.options[this.selectedIndex].value)">
                                        <option></option>
                                        <c:forEach items="${organizationList}" var="organization">
                                            <c:set var="selected"><c:if test="${organization.id == param.organizationId}"> selected</c:if></c:set>
                                            <option value="${organization.id}" ${selected}>${organization.name}</option>
                                        </c:forEach>
                                    </select>
                                </c:if>
                                <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/dynamic/admin/department/list?${pageContext.request.queryString}"
                                               var="hodDataTable"
                                               divToUpdate="hodList" 
                                               jsonData="data"
                                               rowsPerPage="10"
                                               width="100%"
                                               height="200"
                                               sort="e.name"
                                               desc="false"
                                               href=""
                                               hrefParam="id"
                                               hrefQuery="false"
                                               hrefDialog="false"
                                               hrefDialogWidth="600px"
                                               hrefDialogHeight="400px"
                                               hrefDialogTitle=""
                                               checkbox="true"
                                               checkboxId="id"
                                               checkboxButton1="general.method.label.submit"
                                               checkboxCallback1="submitHod"
                                               checkboxSelectSingle="true"
                                               checkboxSelection="true"
                                               checkboxSelectionTitle="Selected Departments"
                                               fields="['id','name','description']"
                                               column1="{key: 'name', label: 'wflowAdmin.participantMapping.view.label.hod.departmentName', sortable: true}"
                                               column2="{key: 'description', label: 'wflowAdmin.participantMapping.view.label.hod.departmentDescription', sortable: false}"
                                               />
                            </div>
                            <div id="department">
                                <c:if test="${empty directoryManagerImpl}">
                                    <label for="departmentGrade"><fmt:message key="wflowAdmin.participantMapping.view.label.department.filterByGrade"/></label>
                                    <span class="form-input">
                                        <select id="departmentGrade" name="departmentGrade">
                                            <option></option>
                                            <c:forEach var="grade" items="${gradeList}" varStatus="rowCounter">
                                                <option value="${grade.id}">${grade.name}</option>
                                            </c:forEach>
                                        </select>
                                    </span>
                                    <br><br>

                                    <fmt:message key="wflowAdmin.participantMapping.view.label.department.filterByOrganization"/>
                                    <select onchange="filter(departmentDataTable, '&organizationId=', this.options[this.selectedIndex].value)">
                                        <option></option>
                                        <c:forEach items="${organizationList}" var="organization">
                                            <c:set var="selected"><c:if test="${organization.id == param.organizationId}"> selected</c:if></c:set>
                                            <option value="${organization.id}" ${selected}>${organization.name}</option>
                                        </c:forEach>
                                    </select>
                                </c:if>
                                <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/dynamic/admin/department/list?${pageContext.request.queryString}"
                                               var="departmentDataTable"
                                               divToUpdate="departmentList" 
                                               jsonData="data"
                                               rowsPerPage="10"
                                               width="100%"
                                               height="200"
                                               sort="e.name"
                                               desc="false"
                                               href=""
                                               hrefParam="id"
                                               hrefQuery="false"
                                               hrefDialog="false"
                                               hrefDialogWidth="600px"
                                               hrefDialogHeight="400px"
                                               hrefDialogTitle=""
                                               checkbox="true"
                                               checkboxId="id"
                                               checkboxButton1="general.method.label.submit"
                                               checkboxCallback1="submitDepartment"
                                               checkboxSelectSingle="true"
                                               checkboxSelection="true"
                                               checkboxSelectionTitle="Selected Departments"
                                               fields="['id','name','description']"
                                               column1="{key: 'name', label: 'wflowAdmin.participantMapping.view.label.department.departmentName', sortable: true}"
                                               column2="{key: 'description', label: 'wflowAdmin.participantMapping.view.label.department.departmentDescription', sortable: false}"
                                               />
                            </div>
                        </div>
                    </div>
                </div>
                <div id="workflowVariable">
                    <form name="workflowVariable" method="POST" action="${pageContext.request.contextPath}/web/admin/process/participant/user/add/submit">
                        <input type="hidden" name="packageId" value="${process.packageId}"/>
                        <input type="hidden" name="processId" value="${process.id}"/>
                        <input type="hidden" name="version" value="${process.version}"/>
                        <input type="hidden" name="participantId" value="${participant.id}"/>
                        <input type="hidden" name="participantType" value="workflowVariable"/>
                        <div class="form-row">
                            <label for="workflowVariable"><fmt:message key="wflowAdmin.participantMapping.view.label.workflowVariable"/></label>
                            <span class="form-input">
                                <select name="workflowVariable">
                                    <option></option>
                                    <c:forEach var="workflowVariable" items="${workflowVariableList}" varStatus="rowCounter">
                                        <option value="${workflowVariable.id}">${workflowVariable.id}</option>
                                    </c:forEach>
                                </select>
                            </span>
                        </div>  
                        <div class="form-row">
                            <label style="vertical-align: top" for="workflowVariable"><fmt:message key="wflowAdmin.participantMapping.view.label.workflowVariable.type"/></label>
                            <span class="form-input">
                                <div class="form-row">
                                    <label for="workflowVariableTypeGroup">
                                        <input id="workflowVariableTypeGroup" type="radio" name="workflowVariableType" value="group" checked="checked"> <fmt:message key="wflowAdmin.participantMapping.view.label.workflowVariable.group"/>
                                    </label>
                                </div> 
                                <div class="form-row">
                                    <label for="workflowVariableTypeUser">
                                        <input id="workflowVariableTypeUser" type="radio" name="workflowVariableType" value="user"> <fmt:message key="wflowAdmin.participantMapping.view.label.workflowVariable.user"/>
                                    </label>
                                </div> 
                                <div class="form-row">
                                    <label for="workflowVariableTypeDepartment">
                                        <input id="workflowVariableTypeDepartment" type="radio" name="workflowVariableType" value="department"> <fmt:message key="wflowAdmin.participantMapping.view.label.workflowVariable.department"/>
                                    </label>
                                </div> 
                                <div class="form-row">
                                    <label for="workflowVariableTypeDepartmentHod">
                                        <input id="workflowVariableTypeDepartmentHod" type="radio" name="workflowVariableType" value="department_hod"> <fmt:message key="wflowAdmin.participantMapping.view.label.workflowVariable.hod"/>
                                    </label>
                                </div> 
                            </span>
                        </div>  
                        <div class="form-buttons">
                            <button type="submit" value="Submit"><fmt:message key="general.method.label.submit"/></button>
                        </div>
                    </form>
                </div>
                <div id="plugin">
                    <br>
                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/plugin/list?pluginType=Participant&${pageContext.request.queryString}"
                       var="JsonDataTable"
                       divToUpdate="pluginList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       height="200"
                       sort="name"
                       desc="false"
                       href=""
                       hrefParam="id"
                       hrefQuery="true"
                       hrefDialog="false"
                       checkbox="true"
                       checkboxId="id"
                       checkboxButton1="general.method.label.submit"
                       checkboxCallback1="submitPlugin"
                       checkboxSelectSingle="true"
                       fields="['id','name',''description,'version']"
                       column1="{key: 'name', label: 'wflowAdmin.participantMapping.view.label.plugin.pluginName', sortable: true}"
                       column2="{key: 'description', label: 'wflowAdmin.participantMapping.view.label.plugin.pluginDescription', sortable: true}"
                       column3="{key: 'version', label: 'wflowAdmin.participantMapping.view.label.plugin.pluginVersion', sortable: false}"
                       />
                </div>
            </div>
        </div>
    </div>

    <script>    
        var tabView = new TabView('userTabView', 'top');
        tabView.init();
    
        var userGroupTabView = new TabView('userGroupTabView', 'top');
        userGroupTabView.init();
        
        var orgChartTabView = new TabView('orgChartTabView', 'top');
        orgChartTabView.init();

        function show(){
            $('#temp').slideDown('slow');
        }

        function parentRefresh(){
            var parentUrlQueryString = parent.location.search;
            if(parentUrlQueryString == '')
                parent.location.href = parent.location.href + "?tab=participantList";
            else{
                if(parentUrlQueryString.indexOf('tab') == -1)
                    parent.location.href = parent.location.href + "&tab=participantList";
                else{

                    parent.location.href = parent.location.href.replace(parentUrlQueryString, '') + "?tab=participantList";
                }
            }
        }

        function submitGroup(id){
            if(id.length > 0){
                if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.submitConfirm"/>")) {
                    var callback = {
                        success : function() {
                            parentRefresh()
                        }
                    }
                    var params = "group=" + escape(id) + "&participantId=${participant.id}&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}&participantType=group";
                    ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/participant/user/add/submit', callback, params); 
                }
            }
        }
        
        function submitUser(id){
            if(id.length > 0){
                if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.submitConfirm"/>")) {
                    var callback = {
                        success : function() {
                            parentRefresh()
                        }
                    }
                    var params = "user=" + escape(id) + "&participantId=${participant.id}&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}&participantType=user";
                    ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/participant/user/add/submit', callback, params); 
                }
            }
        }
          
        function submitHod(id){
            if(id.length > 0){
                if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.submitConfirm"/>")) {
                    var callback = {
                        success : function() {
                            parentRefresh()
                        }
                    }
                    var params = "department=" + escape(id) + "&participantId=${participant.id}&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}&participantType=hod";
                    ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/participant/user/add/submit', callback, params); 
                }
            }
        }
        
        function submitDepartment(id){
            if(id.length > 0){
                if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.submitConfirm"/>")) {
                    var callback = {
                        success : function() {
                            parentRefresh()
                        }
                    }
                    
                    //get grade id
                    var e = document.getElementById("departmentGrade");
                    var val = e.options[e.selectedIndex].value;
                    var grade = '';
                    if(val != '')
                        grade = "Grade&grade=" + escape(val);
                    
                    var params = "department=" + escape(id) + "&participantId=${participant.id}&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}&participantType=department" + grade;
                    ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/participant/user/add/submit', callback, params); 
                }
            }
        }

        <ui:popupdialog var="popupDialog" src=""/>
        function submitPlugin(id){
            if(id.length > 0){
                if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.submitConfirm"/>")) {
                    var callback = {
                        success : function(response) {
                            var paramString = response;
                            document.location = "${pageContext.request.contextPath}/web/admin/process/participant/user/plugin/config?" + paramString;
                        }
                    }
                    var params = "plugin=" + escape(id) + "&participantId=${participant.id}&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}";
                    ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/participant/user/plugin/add/submit', callback, params);
                }
            }
        }
    </script>
<commons:popupFooter />
