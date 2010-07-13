<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="general.login.label.title"
    path1="${pageContext.request.contextPath}/web/login"
    name1="general.main.body.path.login"
    helpTitle="wflowHelp.login.title"
    help="wflowHelp.login.content"
/>

<div id="login">

    <div id="main-body-content">
        <div id="login-app-title"><fmt:message key="general.header.appTitle"/></div>

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
            <%--<tr><td><input type="checkbox" name="_spring_security_remember_me"></td><td><fmt:message key="general.login.label.rememberMe" /></td></tr>--%>
            </table>

            <div id="main-body-actions">
                <input name="submit" type="submit" value="<fmt:message key="general.login.label.login" />" />
            </div>
        </form>

        <jsp:include page="/WEB-INF/jsp/includes/welcome.jsp" />

    </div>

</div>

<div id="revision"><fmt:message key="general.login.label.revision" /></div>

<script type="text/javascript">
    $(document).ready(
        function() {
            $("#j_username").focus();
        }
    );
</script>

<commons:footer />




