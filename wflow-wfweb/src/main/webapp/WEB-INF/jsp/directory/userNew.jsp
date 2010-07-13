<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="usersAdmin.user.new.label.title"/>
    </div>

    <div id="main-body-content">    

        <c:url var="url" value="/web/directory/admin/user/save" />
        <form:form action="${url}" method="POST" commandName="user" cssClass="form">

            <form:errors path="*" cssClass="form-errors"/>
            <c:if test="${error!=null}"><span class="form-errors" style="display:block"><fmt:message key="${error}"/></span></c:if>
            
            <fieldset>
                <legend><fmt:message key="usersAdmin.user.new.label.details"/></legend>
                <div class="form-row">
                    <label for="username"><fmt:message key="usersAdmin.user.new.label.user.name"/></label>
                    <span class="form-input"><form:input path="username" cssErrorClass="form-input-error" /> * </span>
                </div>       
                <div class="form-row">
                    <label for="firstName"><fmt:message key="usersAdmin.user.new.label.first.name"/></label>
                    <span class="form-input"><form:input path="firstName" cssErrorClass="form-input-error" /> * </span>
                </div>
                <div class="form-row">
                    <label for="lastName"><fmt:message key="usersAdmin.user.new.label.last.name"/></label>
                    <span class="form-input"><form:input path="lastName" cssErrorClass="form-input-error" /></span>
                </div>
                <div class="form-row">
                    <label for="password"><fmt:message key="usersAdmin.user.new.label.password"/></label>
                    <span class="form-input"><form:password path="password" showPassword="true" cssErrorClass="form-input-error" /> * </span>
                </div>
                <div class="form-row">
                    <label for="confirmPassword"><fmt:message key="usersAdmin.user.new.label.confirm.password"/></label>
                    <span class="form-input"><form:password path="confirmPassword" showPassword="true" cssErrorClass="form-input-error" /> * </span>
                </div>
                <div class="form-row">
                    <label for="email"><fmt:message key="usersAdmin.user.new.label.email"/></label>
                    <span class="form-input"><form:input path="email" /></span>
                </div>
                <div class="form-row">
                    <label for="role"><fmt:message key="usersAdmin.user.new.label.role"/></label>
                    <span class="form-input">
                        <select multiple="true" size="5" id="role" name="roles">
                            <c:choose>
                                <c:when test="${user.roles==null}">
                                    <c:forEach items="${roleList}" var="role" varStatus="status">
                                        <c:choose>
                                            <c:when test="${status.index == 0}">
                                                <option selected value="${role.id}">${role.name}</option>
                                            </c:when>
                                            <c:otherwise>
                                                <option value="${role.id}">${role.name}</option>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach items="${roleList}" var="role">
                                        <c:set var="validate" value="true"/>
                                        <c:forEach items="${selectedRoles}" var="selectedRole">
                                            <c:if test="${selectedRole == role.id}">
                                                <option selected value="${role.id}">${role.name}</option>
                                                <c:set var="validate" value="false"/>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${validate=='true'}">
                                            <option value="${role.id}">${role.name}</option>
                                            <c:set var="validate" value="false"/>
                                        </c:if>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>                            
                        </select>
                    </span>
                </div>
                <div class="form-row">
                    <label for="timeZone"><fmt:message key="usersAdmin.user.new.label.timeZone"/></label>
                    <span class="form-input">
                        <select name="timeZone" id="timeZone">
                            <option selected value="0"><fmt:message key="general.method.label.select"/></option>
                            <c:forEach items="${timeZoneList}" var="timeZone">
                                <c:choose>
                                    <c:when test="${user.timeZone == timeZone.key}">
                                        <option selected value="${timeZone.key}">${timeZone.value}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${timeZone.key}">${timeZone.value}</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
                    </span>
                </div>
                <div class="form-seperator"></div>

                <fieldset>
                    <legend><fmt:message key="usersAdmin.employment.new.label.details"/></legend>
                    <div class="form-row">
                        <label for="employeeCode"><fmt:message key="usersAdmin.employment.new.label.code"/></label>
                        <span class="form-input"><input type="text" name="employmentCode"/></span>
                    </div>
                    <div class="form-row">
                        <label for="description"><fmt:message key="usersAdmin.employment.new.label.start.date"/></label>
                        <span class="form-input"><input type="text" id="startDateId" name="startDate"/></span>
                    </div>
                     <div class="form-row">
                        <label for="description"><fmt:message key="usersAdmin.employment.new.label.end.date"/></label>
                        <span class="form-input"><input type="text" id="endDateId" name="endDate"/></span>
                    </div>
                    <div class="form-row">
                        <label for="role"><fmt:message key="usersAdmin.employment.new.label.employmentRole"/></label>
                        <span class="form-input"><input type="text" name="employmentRole"/></span>
                    </div>
                </fieldset>
                
                <fieldset>
                    <legend><fmt:message key="usersAdmin.orgdeptgrade.new.label.details"/></legend>
                   
                   <div class="form-row">
                        <label for="role"><fmt:message key="usersAdmin.organization.new.label.name"/></label>
                        <span class="form-input">
                             <select id="organizationId" name="organizationName" onchange="updateDepartmentGrade(this.id)">
                                <option value="0"><fmt:message key="general.method.label.select"/></option>
                                <c:forEach items="${organizations}" var="organization">
                                    <c:choose>
                                        <c:when test="${organization.id != organizationName}">
                                            <option value="${organization.id}">${organization.name}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option selected value="${organization.id}">${organization.name}</option>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </select>
                        </span>
                    </div>
                   
                    <div class="form-row">
                        <label for="role"><fmt:message key="usersAdmin.grade.new.label.name"/></label>
                        <span class="form-input">
                             <select name="gradeName" id="gradeName">
                                <option value="0"><fmt:message key="general.method.label.select"/></option>
                                <c:forEach items="${grades}" var="grade">
                                    <c:choose>
                                        <c:when test="${grade.id != gradeName}">
                                            <option value="${grade.id}">${grade.name}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option selected value="${grade.id}">${grade.name}</option>
                                        </c:otherwise>
                                    </c:choose>
                               </c:forEach>
                            </select>
                        </span>
                    </div>

                    <div class="form-row">
                        <label for="role"><fmt:message key="usersAdmin.department.new.label.name"/></label>
                        <span class="form-input">
                             <select name="departmentName" id="departmentName" onchange="enabledHod(this.id)">
                                <option value="0"><fmt:message key="general.method.label.select"/></option>
                                <c:forEach items="${departments}" var="department">
                                    <c:choose>
                                        <c:when test="${department.id != departmentName}">
                                            <option value="${department.id}">${department.treeStructure} ${department.name}</option>
                                        </c:when>
                                        <c:otherwise>
                                            <option selected value="${department.id}">${department.treeStructure} ${department.name}</option>
                                        </c:otherwise>
                                    </c:choose>
                               </c:forEach>
                            </select>
                        </span>
                    </div>

                    <div class="form-row">
                        <label for="hod"><fmt:message key="usersAdmin.department.new.label.hod"/></label>
                        <span class="form-input">
                            <select id="setHodId" name="setHod">
                                <option selected value="0"><fmt:message key="usersAdmin.employment.view.hod.no"/></option>
                            </select>
                        </span>
                    </div>

                    <div class="form-row">
                        <label for="reportTo"><fmt:message key="usersAdmin.employment.new.label.report.to"/></label>
                        <span class="form-input">
                            <select id="employmentReportToId" name="employmentReportTo">
                                <option selected value="0"><fmt:message key="general.method.label.select"/></option>
                                <c:forEach items="${employments}" var="employment">
                                    <option value="${employment.id}">${employment.user.firstName} ${employment.user.lastName}</option>
                                </c:forEach>
                            </select>
                        </span>
                    </div>

                   <script>
                       function enabledHod(deptId){
                            if(document.getElementById(deptId).value=="0") $('#setHodId').html('<option value="0"><fmt:message key="usersAdmin.employment.view.hod.no"/></option>');
                           else {
                               $('#setHodId').html('<option value="0"><fmt:message key="usersAdmin.employment.view.hod.no"/></option>');
                               $('#setHodId').append('<option value="1"><fmt:message key="usersAdmin.employment.view.hod.yes"/></option>');
                           }
                       }
                       
                       function updateDepartmentGrade(orgId){
                           
                           var callback = {
                                success : function(data) {
                                    var obj = eval('(' + data + ')');
                                    var departments = obj.departments;
                                    var grades = obj.grades;
                                    
                                    if(departments!=null && departments.length){
                                        $('#departmentName').html('<option value="0"><fmt:message key="general.method.label.select"/></option>');
                                        for(i=0; i<departments.length; i++){
                                            if(departments[i].parent == null){
                                                $('#departmentName').append('<option value="' + departments[i].id + '">' + departments[i].name + '</option>');
                                            } else {
                                                $('#departmentName').append('<option value="' + departments[i].id + '">' + departments[i].recursive + departments[i].name + '</option>');      
                                            }
                                        }
                                    } else {
                                        $('#departmentName').html('<option value="0"><fmt:message key="general.method.label.select"/></option>');
                                        if(departments != null){
                                            $('#departmentName').append('<option value="' + departments.id + '">' + departments.name + '</option>');
                                        }
                                    }
                                    
                                    if(grades!=null && grades.length){
                                        $('#gradeName').html('<option value="0"><fmt:message key="general.method.label.select"/></option>');
                                        for(j=0; j<grades.length; j++){                                            
                                            $('#gradeName').append('<option value="' + grades[j].id + '">' + grades[j].name + '</option>');
                                        }
                                    }else{
                                        $('#gradeName').html('<option value="0"><fmt:message key="general.method.label.select"/></option>');
                                        if(grades != null){                                           
                                            $('#gradeName').append('<option value="' + grades.id + '">' + grades.name + '</option>');
                                        }
                                    }
                                }
                            }
                            
                            if(document.getElementById(orgId).value!='0'){
                                var request = ConnectionManager.get('${pageContext.request.contextPath}/web/json/directory/admin/user/update/organizationgrade', callback, 'rnd=' + new Date().valueOf().toString() + '&orgId='
                                    +document.getElementById(orgId).value);                         
                            } else {
                                var department = document.getElementById("departmentName");
                                var grade = document.getElementById("gradeName");
                                    
                                $('#departmentName').html('<option value="0"><fmt:message key="general.method.label.select"/></option>');
 
                                $('#gradeName').html('<option value="0"><fmt:message key="general.method.label.select"/></option>');
                                
                            }
                       }
                   </script>
                    
                </fieldset>
                
            </fieldset>
            <div class="form-buttons">
                <span class="button"><input type="submit" value="<fmt:message key="general.method.label.save"/>"/></span>
                <span class="button"><input type="button" value="<fmt:message key="general.method.label.close"/>" onclick="closeDialog()" /></span>
            </div>
        </form:form>
    </div>

    <script>
        function closeDialog() {
            if (parent && parent.closeDialog) {
                parent.closeDialog();
            }
            return false;
        }

        Calendar.show("startDateId");
        Calendar.show("endDateId");
    </script>
<commons:popupFooter />
