<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

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
                            <li class="selected"><a href="#hod"><span><fmt:message key="wflowAdmin.participantMapping.view.label.hod"/></span></a></li>
                            <li><a href="#department"><span><fmt:message key="wflowAdmin.participantMapping.view.label.department"/></span></a></li>
                        </ul>
                        <div>
                            <div id="hod">
                                <fmt:message key="wflowAdmin.participantMapping.view.label.hod.filterByOrganization"/>
                                <select onchange="filter(hodDataTable, '&organizationId=', this.options[this.selectedIndex].value)">
                                    <option></option>
                                    <c:forEach items="${organizationList}" var="organization">
                                        <c:set var="selected"><c:if test="${organization.id == param.organizationId}"> selected</c:if></c:set>
                                        <option value="${organization.id}" ${selected}>${organization.name}</option>
                                    </c:forEach>
                                </select>

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
    </script>
<commons:popupFooter />
