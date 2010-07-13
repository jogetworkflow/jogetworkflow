<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="usersAdmin.user.view.label.title"
    path1="${pageContext.request.contextPath}/web/directory/admin/user/view/${user.id}"
    name1="usersAdmin.main.body.path.user.view"
    helpTitle="wflowHelp.user.view.title"
    help="wflowHelp.user.view.content"
/>
    
    <div id="main-body-content">
        <dl>
            <dt><fmt:message key="usersAdmin.user.view.label.user.name"/></dt>
            <dd>${user.username}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.user.view.label.first.name"/></dt>
            <dd>${user.firstName}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.user.view.label.last.name"/></dt>
            <dd>${user.lastName}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.user.view.label.email"/></dt>
            <c:choose>
                <c:when test="${user.email == ''}">
                    <dd> - </dd>
                </c:when>
                <c:otherwise>
                    <dd>${user.email}&nbsp;</dd>
                </c:otherwise>
            </c:choose>
            
            <dt><fmt:message key="usersAdmin.user.view.label.status"/></dt>
            <c:choose>
                <c:when test="${user.active==1}">
                    <dd><fmt:message key="usersAdmin.user.view.label.active"/></dd>
                </c:when>
                <c:otherwise>
                    <dd><fmt:message key="usersAdmin.user.view.label.inactive"/></dd>
                </c:otherwise>
            </c:choose>

            <dt><fmt:message key="usersAdmin.user.view.label.role"/></dt>
            <dd>${roleString}&nbsp;</dd>
            
            <dt><fmt:message key="usersAdmin.user.view.label.timeZone"/></dt>
            <dd>${timeZone}&nbsp;</dd>
        </dl>
        <div id="main-body-content-subheader">
            <fmt:message key="usersAdmin.employment.view.label.title"/>
        </div>
        <dl>
            <dt><fmt:message key="usersAdmin.organization.view.label.name"/>&nbsp;</dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/view/${employment.department.organization.id}">${employment.department.organization.name}</a>&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.gradeName"/></dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/grade/view/${employment.gradeId}">${employment.grade.name}</a>&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.department.view.label.name"/></dt>
            <dd><a href="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${employment.department.id}">${employment.department.name}</a>&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.employeeCode"/></dt>
            <dd>${employment.employeeCode}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.employmentRole"/></dt>
            <dd>${employment.role}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.start.date"/></dt>
            <dd>${employment.startDate}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.end.date"/></dt>
            <dd>${employment.endDate}&nbsp;</dd>
            <dt><fmt:message key="usersAdmin.employment.view.label.hod"/></dt>
            <c:choose>
                <c:when test="${employment.department.hod == employment}">
                    <dd><fmt:message key="usersAdmin.employment.view.hod.yes"/></dd>
                </c:when>
                <c:otherwise>
                    <dd><fmt:message key="usersAdmin.employment.view.hod.no"/></dd>
                </c:otherwise>
            </c:choose>
            <dt><fmt:message key="usersAdmin.employment.view.label.report.to"/></dt>
            <dd>${employmentReportToSelected.firstName} ${employmentReportToSelected.lastName}&nbsp;</dd>

            <!--dt>Organization</dt>
            <dd>
                <c:choose>
                    <c:when test="${empSize>1}">
                        <c:forEach items="${user.employments}" var="emp" varStatus="index">
                            <c:choose>
                                <c:when test="${emp.department!=null && emp.department.organization!=null}">
                                     <c:choose>
                                        <c:when test="${index.count < empSize}">
                                            <span><c:out value="${emp.department.organization.name}, "/></span>
                                        </c:when>
                                    </c:choose>
                                </c:when>
                                <c:when test="${emp.grade!=null && emp.grade.organiation!=null}">
                                     <c:choose>
                                        <c:when test="${index.count < empSize}">
                                            <span><c:out value="${emp.grade.organization.name}, "/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span><c:out value="and ${emp.grade.orgazation.name}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${user.employments}" var="emp">
                            <c:choose>
                                <c:when test="${emp.department!=null && emp.department.organization!=null}">
                                    <span><c:out value="${emp.department.organization.name}"/></span>
                                </c:when>
                                <c:when test="${emp.grade!=null && emp.grade.organization!=null}">
                                    <span><c:out value="${emp.grade.organization.name}"/></span>
                                </c:when>
                            </c:choose>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </dd>

            <dt>Department</dt>
            <dd>
                <c:choose>
                    <c:when test="${empSize>1}">
                        <c:forEach items="${user.employments}" var="emp" varStatus="index">
                            <c:choose>
                                <c:when test="${index.count < empSize}">
                                    <span><c:out value="${emp.department.name}, "/></span>
                                </c:when>
                                <c:otherwise>
                                    <span><c:out value="and ${emp.department.name}"/></span>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${user.employments}" var="emp">
                            <span><c:out value="${emp.department.name}"/></span>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </dd-->
   
            
        </dl>
        
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.user.view.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.user.view.label.delete"/>" onclick="del()"/></span>
        </div>
        
        <div id="main-body-content-subheader">
        	<fmt:message key="usersAdmin.group.list.label.subtitle"/>
        </div> 
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/admin/user/group/list?userId=${user.id}" 
                       var="JsonDataTable"
                       divToUpdate="groupList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/directory/admin/group/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       fields="['id','name','description']"
                       column1="{key: 'name', label: 'usersAdmin.user.view.label.group.list.name', sortable: true}"
                       column2="{key: 'description', label: 'usersAdmin.user.view.label.group.list.description', sortable: false}"
                       />
        
        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.user.view.button.assign.groups"/>" onclick="assign()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="usersAdmin.user.view.button.unassign.groups"/>" onclick="unassign()"/></span>
        </div>
    </div>

    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/user/edit?userId=${user.id}"/>
        
        function edit(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
            popupDialog2.close();
            popupDialog3.close();
        }

        <ui:popupdialog var="popupDialog2" src="${pageContext.request.contextPath}/web/directory/admin/group/assign?userId=${user.id}"/>
        
        function assign(){
            popupDialog2.init();
        }

        <ui:popupdialog var="popupDialog3" src="${pageContext.request.contextPath}/web/directory/admin/group/unassign?userId=${user.id}"/>
        
        function unassign(){
            popupDialog3.init();
        }

        function del(){
            if (confirm('<fmt:message key="usersAdmin.user.view.confirmation.delete"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/directory/admin/user/list';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/directory/admin/user/remove', callback, 'userId=${user.id}'); 
            }
        }
    </script>

<commons:footer />