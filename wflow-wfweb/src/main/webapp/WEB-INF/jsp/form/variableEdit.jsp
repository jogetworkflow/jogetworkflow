<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.variable.edit.label.title"/>
    </div>
    <div id="main-body-content">
        <c:url var="url" value="" />
        <form:form id="variableForm" action="${pageContext.request.contextPath}/web/settings/form/variable/edit/submit" commandName="formVariable" cssClass="form">
            <form:hidden path="id"/>

            <form:errors path="*" cssClass="form-errors"/>
            <fieldset>
                <legend><fmt:message key="wflowAdmin.variable.edit.label.details"/></legend>
                <div class="form-row">
                    <label for="field1"><fmt:message key="wflowAdmin.variable.edit.label.name"/></label>
                    <span class="form-input"><form:input path="name" cssErrorClass="form-input-error" /> *</span>
                </div>
            </fieldset>

            <div class="form-buttons">
                <input class="form-button" type="submit" value="<fmt:message key="general.method.label.save"/>" />
                <input class="form-button" type="button" value="<fmt:message key="general.method.label.cancel"/>" onclick="closeDialog()"/>
            </div>
        </form:form>
    </div>

    <script type="text/javascript">
        function closeDialog() {
            if (parent && parent.closeDialog) {
                parent.closeDialog();
            }
            return false;
        }
    </script>

<commons:popupFooter />

