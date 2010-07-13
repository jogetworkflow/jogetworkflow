<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<commons:header
    title="wflowAdmin.packageImport.view.label.title"
    helpTitle="wflowHelp.package.import.title"
    help="wflowHelp.package.import.content"
/>

    <div id="main-body-content">
        <c:if test="${errorList != null}">
            <div class="import-error">
                <div style="borderx: 1px dashed #aaa; backgroundx: #e5e5e5; padding: 0.5em">
                <c:forEach var="error" items="${errorList}">
                    <div style="margin-bottom: 5px">${error}</div>
                </c:forEach>
                </div>
                <p><fmt:message key="wflowAdmin.packageImport.view.label.missingElementInfo"/></p>
            </div>
        </c:if>

        <div class="form-buttons">
            <input class="form-button" type="button" onclick="confirmError()" value="<fmt:message key="general.method.label.continue"/>" />
        </div>
    </div>

<script>
    function confirmError(){
        document.location = '${pageContext.request.contextPath}/web/admin/process/configure/import/confirm?tempFileName=${tempFileName}';
    }

</script>

<commons:footer />

