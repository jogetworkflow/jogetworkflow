<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:set var="pathInfo" value="${requestScope['javax.servlet.forward.path_info']}"/>
<c:if test="${!empty pathInfo}">
    <c:set var="tokenizer" value="<%= new java.util.StringTokenizer(pageContext.getAttribute(\"pathInfo\").toString(), \"/\") %>"/>
    <c:set var="module" value="<%= ((java.util.StringTokenizer)pageContext.getAttribute(\"tokenizer\")).nextToken() %>"/>
    <c:set var="submodule" value="<%= (((java.util.StringTokenizer)pageContext.getAttribute(\"tokenizer\")).hasMoreTokens()) ? \".\" + ((java.util.StringTokenizer)pageContext.getAttribute(\"tokenizer\")).nextToken() : \"\" %>"/>
    <c:set var="sidebarKey" value="${module}${submodule}" />
</c:if>

        <c:choose>
            <c:when test="${!empty sidebarKey}">
                <fmt:message key="sidebar.help.${sidebarKey}" />
            </c:when>
            <c:otherwise>
                <fmt:message key="sidebar.help.general" />
            </c:otherwise>
        </c:choose>