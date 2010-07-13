<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="usersAdmin.employment.edit.label.title"/>
    </div>

    <div id="main-body-content">

        <c:url var="url" value="/web/directory/admin/organization/employee/submit" />
        <form:form action="${url}" method="POST" commandName="employment" cssClass="form">
            <form:hidden path="id"/>

            <form:errors path="*" cssClass="form-errors"/>

            <fieldset>
                <legend><fmt:message key="usersAdmin.department.edit.label.details"/></legend>
               
                <div class="form-row">
                    <label for="employeeCode"><fmt:message key="usersAdmin.employment.edit.label.code"/></label>
                    <span class="form-input"><form:input path="employeeCode" /></span>
                </div>
                <div class="form-row">
                    <label for="startDate"><fmt:message key="usersAdmin.employment.edit.label.start.date"/></label>
                    <form:input path="startDate" />

                </div>
                 <div class="form-row">
                    <label for="endDate"><fmt:message key="usersAdmin.employment.edit.label.end.date"/></label>
                    <form:input path="endDate" /> 
                </div>
                <div class="form-row">
                    <label for="field2"><fmt:message key="usersAdmin.employment.edit.label.grade"/></label>
                    <span class="form-input">
                        <form:select path="gradeId">
                            <form:option value="-" label="--Please Select--"/>
                            <form:options items="${grades}" itemValue="id" itemLabel="name"/>
                        </form:select>
                    </span>
                </div>
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
        
        Calendar.show("startDate");
        Calendar.show("endDate");
    </script>

<commons:popupFooter />
