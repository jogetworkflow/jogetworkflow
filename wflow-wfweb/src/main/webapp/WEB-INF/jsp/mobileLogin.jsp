<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:mobileHeader
    title="general.login.label.title"
/>

<div id="login">

    <div id="main-body-content">
        <c:set var="subheader"><fmt:message key="general.login.label.subheader" /></c:set>
        <c:if test="${!empty subheader}">
            <div id="main-body-content-subheader">
                ${subheader}
            </div>
        </c:if>

        <c:if test="${!empty param.login_error}">
            <div id="main-body-message">
                <fmt:message key="general.login.label.loginError" /> <c:out value="${SPRING_SECURITY_LAST_EXCEPTION.message}"/>.
            </div>
        </c:if>

        <form id="loginForm" name="loginForm" action="<c:url value='/j_spring_security_check'/>" method="POST">
            <table>
            <tr><td><fmt:message key="general.login.label.username" />: </td><td><input type='text' id='j_username' name='j_username' value='<c:if test="${not empty param.login_error}"><c:out value="${SPRING_SECURITY_LAST_USERNAME}"/></c:if>'/></td></tr>
            <tr><td><fmt:message key="general.login.label.password" />:</td><td><input type='password' id='j_password' name='j_password'></td></tr>
            </table>

            <div id="main-body-actions">
                <input name="submit" type="submit" value="<fmt:message key="general.login.label.login" />" />
            </div>
        </form>

    </div>

</div>

<div id="revision"><fmt:message key="general.login.label.revision" /></div>

<commons:mobileFooter />




