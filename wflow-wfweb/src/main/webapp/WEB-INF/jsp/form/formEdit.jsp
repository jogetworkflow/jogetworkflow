<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="formsAdmin.form.edit.label.title"/>
    </div>

    <div id="main-body-content">        
        <c:url var="url" value="/web/admin/form/general/save" />
        <form:form action="${url}" method="POST" commandName="form" cssClass="form">
            <form:errors path="*" cssClass="errorBox" />
            <form:hidden path="id"/>
            <form:hidden path="tableName"/>
            <form:errors path="*" cssClass="form-errors" />
            <fieldset>
                <legend><fmt:message key="formsAdmin.form.new.label.details"/></legend>
                <div class="form-row">
                    <label for="name"><fmt:message key="formsAdmin.form.new.label.formName"/></label>
                    <span class="form-input"><form:input path="name" cssErrorClass="form-input-error" /> * <span class="form-input-message"><form:errors path="name"/></span></span>
                </div>
                <div class="form-row">
                    <label for="categoryId"><fmt:message key="formsAdmin.form.new.label.category"/></label>
                    <span class="form-input">
                        <form:select path="categoryId">
                            <form:options items="${categories}" itemValue="id" itemLabel="name"/>
                        </form:select> *
                    </span>
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
