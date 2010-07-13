<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<commons:header
    title="wflowClient.userview.import.label.title"
    path1="${pageContext.request.contextPath}/web/admin/userview/list"
    name1="general.tab.designProcess.userview"
    path2="${pageContext.request.contextPath}/web/admin/userview/import"
    name2="wflowClient.userview.import.label.title"
    helpTitle="wflowHelp.userview.import.title"
    help="wflowHelp.userview.import.content"
/>

    <div id="main-body-content">
        <c:if test="${errorList != null}">
            <div class="import-error">
                <div style="borderx: 1px dashed #aaa; backgroundx: #e5e5e5; padding: 0.5em">
                <c:forEach var="error" items="${errorList}">
                    <div style="margin-bottom: 5px">${error}</div>
                </c:forEach>
                </div>
                <p><fmt:message key="wflowAdmin.userview.import.view.label.missingElementInfo"/></p>
            </div>
        </c:if>

        <div class="form-buttons">
            <input id="confirmError" class="form-button" type="button" onclick="confirmError()" value="<fmt:message key="general.method.label.continue"/>" />
        </div>
    </div>

<script>
    function confirmError(){
        $('#confirmError').attr('disabled', 'disabled');
        document.location = '${pageContext.request.contextPath}/web/admin/userview/import/confirm?tempFileName=${tempFileName}';
    }

</script>

<commons:footer />

