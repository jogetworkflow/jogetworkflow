<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="usersAdmin.organization.new.label.title"/>
    </div>

    <div id="main-body-content">       
        <c:url var="url" value="/web/directory/admin/organization/save" />
        <form:form action="${url}" method="POST" commandName="organization" cssClass="form">

            <form:errors path="*" cssClass="form-errors"/>
            <c:if test="${errors!=null}">
                <c:forEach items="${errors}" var="error" >
                    <span class="form-errors" style="display:block"><fmt:message key="${error}"/></span>
                </c:forEach>
            </c:if>

            <fieldset>
                <legend><fmt:message key="usersAdmin.organization.new.label.details"/></legend>
                <div class="form-row">
                    <label for="id"><fmt:message key="usersAdmin.organization.new.label.code"/></label>
                    <span class="form-input"><form:input path="id" cssErrorClass="form-input-error" /> * </span>
                </div>  
                <div class="form-row">
                    <label for="name"><fmt:message key="usersAdmin.organization.new.label.name"/></label>
                    <span class="form-input"><form:input path="name" cssErrorClass="form-input-error" /> * </span>
                </div>       
                <div class="form-row">
                    <label for="description"><fmt:message key="usersAdmin.organization.new.label.description"/></label>
                    <span class="form-input"><form:textarea path="description" /></span>
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
    </script>
<commons:popupFooter />
