<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<jsp:include page="/WEB-INF/jsp/includes/scripts.jsp" />

[<a id="processTreeRefresh" class="sidebarTreeRefresh" href="#" onclick="{ xssProcessTree.refresh(); }">refresh</a>]    

<div id="json_processTree" class="sidebarTree">
    <ui:jsontree   var="xssProcessTree" 
                divToUpdate="xssProcessTree"
                title="Start Process"
                url="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/json/workflow/process/list/package"
                baseUrl="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web"
                nodeLabel="label"
                nodeKey="id"
                nodeCount="count"
                href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/client/process/view/"
                hrefParam="processId"
                xss="true"
    />
    <div id="xssProcessTree"></div>
</div>
    

