<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="usersAdmin.employment.new.label.title"/>
    </div>

    <div id="main-body-content">
        
        <c:url var="url" value="/web/directory/admin/organization/employee/save"/>
        <form:form action="${url}" method="POST" commandName="employment" cssClass="form">

            <form:errors path="*" cssClass="form-errors"/>

            <fieldset>
                <legend><fmt:message key="usersAdmin.employment.new.label.details"/></legend>
                <div class="form-row">
                    <label for="employeeCode"><fmt:message key="usersAdmin.employment.new.label.code"/></label>
                    <span class="form-input"><form:input path="employeeCode" cssErrorClass="form-input-error" /> *</span>
                </div>
                <div class="form-row">
                    <label for="description"><fmt:message key="usersAdmin.employment.new.label.start.date"/></label>
                    <form:input path="startDate" />

                </div>
                 <div class="form-row">
                    <label for="description"><fmt:message key="usersAdmin.employment.new.label.end.date"/></label>
                    <form:input path="endDate" /> 
                </div>
                <div class="form-row">
                    <label for="field2"><fmt:message key="usersAdmin.employment.new.label.user"/></label>
                    <span class="form-input">
                        <form:select path="userId">
                            <form:option value="-" label="--Please Select--"/>
                            <form:options items="${users}" itemValue="id" itemLabel="firstName"/>
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
