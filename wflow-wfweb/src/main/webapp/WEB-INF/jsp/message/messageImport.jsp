<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<commons:header
    title="wflowAdmin.message.import.label.title"
    path1="${pageContext.request.contextPath}/web/settings/resource/message/import"
    name1="wflowAdmin.message.import.label.title"
    helpTitle="wflowHelp.message.list.title"
    help="wflowHelp.message.list.content"
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

        <form method="post" action="${pageContext.request.contextPath}/web/settings/resource/message/import/submit" class="form" enctype="multipart/form-data">
            <div class="form-row">
                <label for="localeFile" class="upload"><fmt:message key="wflowAdmin.message.import.label.POFile"/></label>
                <span class="form-input">
                    <input id="localeFile" type="file" name="localeFile"/>
                </span>
            </div>
            <div class="form-buttons">
                <input class="form-button" type="submit" value="<fmt:message key="wflowAdmin.message.import.label.importMessage"/>" />
            </div>
        </form>
    </div>

<commons:footer />

