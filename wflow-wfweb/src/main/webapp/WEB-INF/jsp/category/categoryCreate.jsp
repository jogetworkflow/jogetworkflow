<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="formsAdmin.category.new.label.title"/>
    </div>
    
    <div id="main-body-content">
        <form:form action="${pageContext.request.contextPath}/web/admin/form/category/create/submit" commandName="category" cssClass="form">

            <form:errors path="*" cssClass="form-errors" />
            <fieldset>
                <legend><fmt:message key="formsAdmin.category.new.label.details"/></legend>
                <div class="form-row">
                    <label for="id"><fmt:message key="formsAdmin.category.new.label.id"/></label>
                    <span class="form-input"><form:input id="id" path="id" cssErrorClass="form-input-error" /> *</span>
                </div> 
                <div class="form-row">
                    <label for="name"><fmt:message key="formsAdmin.category.new.label.name"/></label>
                    <span class="form-input"><form:input id="name" path="name" cssErrorClass="form-input-error" /> *</span>
                </div>       
                <div class="form-row">
                    <label for="description"><fmt:message key="formsAdmin.category.new.label.description"/></label>
                    <span class="form-input"><form:textarea id="description" path="description" /></span>
                </div>
            </fieldset>
            <div class="form-buttons">
                <input class="form-button" type="submit" value="<fmt:message key="general.method.label.save"/>" />
                <input class="form-button" type="button" value="<fmt:message key="general.method.label.cancel"/>" onclick="closeDialog()"/>
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

