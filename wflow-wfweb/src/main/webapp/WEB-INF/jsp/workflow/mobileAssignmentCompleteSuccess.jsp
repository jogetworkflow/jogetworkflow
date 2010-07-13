<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:set var="headerTitle"><fmt:message key="wflowClient.assignment.view.label.title"/></c:set>
<commons:mobileHeader title="${headerTitle}" />

    <c:if test="${!empty param.css}">
        <link rel="stylesheet" type="text/css" href="${param.css}">
    </c:if>

    <div id="mobileInfo">
        <p>
            <fmt:message key="wflowClient.assignment.mobile.view.label.success"/>
        </p>
    </div>

<commons:mobileFooter />