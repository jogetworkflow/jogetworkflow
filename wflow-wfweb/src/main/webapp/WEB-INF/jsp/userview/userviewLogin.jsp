<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<commons:popupHeader title="${userviewSetup.setupName}"/>

<%
    String css = request.getContextPath() + "/css/userview.css";
%>

<link rel="stylesheet" type="text/css" href="<%= css %>">

<link rel="stylesheet" type="text/css" href="<%= css %>">
<c:if test="${!empty userviewSetup.cssLink}">
    <link rel="stylesheet" type="text/css" href="${userviewSetup.cssLink}">
</c:if>
<c:if test="${!empty userviewSetup.css}">
    <style>
        ${userviewSetup.css}
    </style>
</c:if>
<jsp:include page="/WEB-INF/jsp/includes/rtl.jsp" />

<div id="container">
    <div id="userviewHeader">
        <div id="userviewHeaderTitle">
            ${userviewSetup.setupName}
        </div>
        <c:if test="${!empty userviewSetup.header}">
            <div id="customUserviewHeader">
                ${userviewSetup.header}
            </div>
        </c:if>
    </div>

    <div id="userviewBody" style="text-align: left">
        <c:if test="${!empty param.login_error}">
            <div id="main-body-message">
                <fmt:message key="general.login.label.loginError" /> <c:out value="${SPRING_SECURITY_LAST_EXCEPTION.message}"/>.
            </div>
        </c:if>
        <form id="loginForm" name="loginForm" action="<c:url value='/j_spring_security_check'/>" method="POST">
            <table>
            <tr><td><fmt:message key="general.login.label.username" />: </td><td><input type='text' id='j_username' name='j_username' value='<c:if test="${not empty param.login_error}"><c:out value="${SPRING_SECURITY_LAST_USERNAME}"/></c:if>'/></td></tr>
            <tr><td><fmt:message key="general.login.label.password" />:</td><td><input type='password' id='j_password' name='j_password'></td></tr>
            <%--<tr><td><input type="checkbox" name="_spring_security_remember_me"></td><td><fmt:message key="general.login.label.rememberMe" /></td></tr>--%>
            </table>

            <div id="main-body-actions">
                <input name="submit" type="submit" value="<fmt:message key="general.login.label.login" />" />
            </div>
        </form>
    </div>

    <div style="clear: both"/>
    <c:if test="${!empty userviewSetup.footer}">
        <div id="customUserviewFooter">
            ${userviewSetup.footer}
        </div>
    </c:if>
</div>

<commons:popupFooter />