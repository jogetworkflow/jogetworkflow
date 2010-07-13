<%@ tag import="org.springframework.security.context.SecurityContextHolder"%>
<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ attribute name="title" %>
<c:if test="${empty title}"><c:set var="title"><fmt:message key="general.header.appTitle"/></c:set></c:if>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta content="width=320; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" name="viewport"/>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <title>
            <c:set var="setTitle"><fmt:message key="${title}"/></c:set>
            ${fn:replace(setTitle, "???", "")}
        </title>

        <jsp:include page="/WEB-INF/jsp/includes/css.jsp" />
        <jsp:include page="/WEB-INF/jsp/includes/scripts.jsp" />
        <link rel="stylesheet" type="text/css" media="screen, handheld" href="${pageContext.request.contextPath}/css/mobile.css">
    </head>
    <body class="mobileBody">
        <c:set var="user" value="<%= SecurityContextHolder.getContext().getAuthentication().getPrincipal() %>"/>
        <c:set var="isAnonymous" value="<%= (jspContext.getAttribute(\"user\") instanceof String) %>"/>
        <div id="mobileAppInfo">
            <fmt:message key="general.header.appTitle"/>
        </div>
        <c:if test="${!isAnonymous}">
            <div id="mobileMenu">
                <a id="inbox" href="${pageContext.request.contextPath}/web/client/mobile/assignment/inbox"><div id="inbox"><fmt:message key="general.tab.home.inbox"/></div></a>
                <a id="runProcess" href="${pageContext.request.contextPath}/web/client/mobile/process/list"><div><fmt:message key="general.tab.home.startProcess"/></div></a>
                <a id="logout" href="${pageContext.request.contextPath}/j_spring_security_logout"><div><fmt:message key="general.header.logout"/></div></a>
            </div>
            <div style="clear:both"></div>
        </c:if>


