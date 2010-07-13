<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="formsAdmin.category.edit.label.title"/>
    </div>

    <div id="main-body-content">        
        <c:url var="url" value="/web/admin/form/category/save" />
        <form:form action="${url}" method="POST" commandName="category" cssClass="form">
            <form:errors path="*" cssClass="errorBox" />
            <form:hidden path="id"/>
            <form:errors path="*" cssClass="form-errors" />
            <fieldset>
                <legend><fmt:message key="formsAdmin.category.edit.label.details"/></legend>
                <div class="form-row">
                    <label for="name"><fmt:message key="formsAdmin.category.edit.label.name"/></label>
                    <span class="form-input"><form:input path="name" cssErrorClass="form-input-error" /> * <span class="form-input-message"><form:errors path="name"/></span></span>
                </div>       
                <div class="form-row">
                    <label for="description"><fmt:message key="formsAdmin.category.edit.label.description"/></label>
                    <span class="form-input"><form:textarea path="description" /></span>
                </div>
            </fieldset>
            <div class="form-buttons">
                <span class="button"><input type="submit" value="<fmt:message key="general.method.label.save"/>"/></span>
                <span class="button"><input type="button" value="<fmt:message key="general.method.label.cancel"/>" onclick="closeDialog()" /></span>
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
