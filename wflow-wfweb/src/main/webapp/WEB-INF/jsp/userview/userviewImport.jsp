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

        <c:if test="${errorMessage != null}">
            <div class="form-error">
                ${errorMessage}
            </div>
        </c:if>

        <c:if test="${errorList != null}">
            <div class="form-error">
                <div style="borderx: 1px dashed #aaa; backgroundx: #e5e5e5; padding: 0.5em">
                <c:forEach var="error" items="${errorList}">
                    <div style="border-bottomx: 1px solid #ccc; margin-bottom: 5px">${error}</div>
                </c:forEach>
                </div>
            </div>
        </c:if>

        <c:url var="url" value="" />
        <form method="post" action="${pageContext.request.contextPath}/web/admin/userview/import/submit" class="form" enctype="multipart/form-data" onsubmit="upload()">
            <div class="form-row">
                <label for="packageZip" class="upload"><fmt:message key="wflowClient.userview.import.label.packageZip"/></label>
                <span class="form-input">
                    <input id="packageZip" type="file" name="packageZip"/>
                </span>
            </div>
            <div class="form-buttons">
                <input id="submit" class="form-button" type="submit" value="<fmt:message key="general.method.label.upload"/>" />
            </div>
        </form>
    </div>

<script>
    function upload(){
        $('#submit').attr('disabled', 'disabled');
        return true;
    }
</script>

<commons:footer />

