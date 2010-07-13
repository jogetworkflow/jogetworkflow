<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.message.edit.label.title"/>
    </div>
    <div id="main-body-content">

        <c:url var="url" value="" />
        <form:form action="${pageContext.request.contextPath}/web/settings/resource/message/save" commandName="message" cssClass="form">
            <form:errors path="*" cssClass="form-errors"/>
            <form:hidden path="id"/>
            <fieldset>
                <legend><fmt:message key="wflowAdmin.message.edit.label.details"/></legend>
                <div class="form-row">
                    <label for="field1"><fmt:message key="wflowAdmin.message.edit.label.key"/></label>
                    <span class="form-input"><form:input path="key" cssErrorClass="form-input-error" /> *</span>
                </div>
                <div class="form-row">
                    <label for="field1"><fmt:message key="wflowAdmin.message.edit.label.locale"/></label>
                    <span class="form-input">
                        <form:select path="locale">
                            <form:options items="${localeList}"/>
                        </form:select>
                    </span>
                </div>
                <div class="form-row">
                    <label for="field2"><fmt:message key="wflowAdmin.message.edit.label.message"/></label>
                    <span class="form-input"><form:input path="message" id="tableName"/> *</span>
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

