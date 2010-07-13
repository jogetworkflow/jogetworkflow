<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<commons:header
    title="wflowAdmin.packageImport.view.label.title"
    path1="${pageContext.request.contextPath}/web/admin/process/configure/import"
    name1="wflowAdmin.main.body.path.importPackage"
    helpTitle="wflowHelp.package.import.title"
    help="wflowHelp.package.import.content"
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
        <form method="post" action="${pageContext.request.contextPath}/web/admin/process/configure/import/submit" class="form" enctype="multipart/form-data">
            <div class="form-row">
                <label for="packageZip" class="upload"><fmt:message key="wflowAdmin.packageImport.view.label.processXpdlFile"/></label>
                <span class="form-input">
                    <input id="packageZip" type="file" name="packageZip"/>
                </span>
            </div>
            <div class="form-buttons">
                <input class="form-button" type="submit" value="<fmt:message key="general.method.label.upload"/>" />
            </div>
        </form>
    </div>

<commons:footer />

