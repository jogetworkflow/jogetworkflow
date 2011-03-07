<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:set var="headerTitle"><fmt:message key="wflowClient.assignment.completed.label.title"/></c:set>
<commons:popupHeader title="${headerTitle}" />

    <c:if test="${!empty param.css}">
        <link rel="stylesheet" type="text/css" href="${param.css}">
    </c:if>

    <c:if test="${param.embed != 'true' || empty param.embed}">
        <div id="main-body-header">
            <div id="main-body-header-title">
                <fmt:message key="wflowClient.assignment.completed.label.title"/>
            </div>
        </div>
    </c:if>
    
    <div id="main-body-content" style="text-align: left">
        <fmt:message key="wflowClient.assignment.completed.label.description"/><br/><br/>
        <a href="${pageContext.request.contextPath}/web/client/assignment/inbox"><fmt:message key="wflowClient.assignment.completed.label.clickHereToReturnToInbox"/></a>
    </div>
<commons:popupFooter />
