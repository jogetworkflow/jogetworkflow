<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:mobileHeader
    title="wflowClient.startProcess.list.label.title"
/>

<c:if test="${empty param.packageId}">
    <div class="mobileInfo">
        <fmt:message key="wflowClient.assignment.mobile.runProcess.selectPackage" />
    </div>
    <div id="packageList" class="mobileListing">
        <ul>
            <c:forEach items="${packageList}" var="package">
                <li>
                    <a href="${pageContext.request.contextPath}/web/client/mobile/process/list?packageId=${package.packageId}&checkWhiteList=true">
                        ${package.packageName}
                    </a><br/>
                </li>
            </c:forEach>
        </ul>
    </div>
</c:if>
<c:if test="${!empty param.packageId}">
    <div class="mobileInfo">
        <c:choose>
            <c:when test="${param.allVersion eq 'yes'}">
                <a href="${pageContext.request.contextPath}/web/client/mobile/process/list?checkWhiteList=true&packageId=${param.packageId}"><fmt:message key="wflowClient.assignment.mobile.runProcess.hideOldProcess" /></a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/web/client/mobile/process/list?checkWhiteList=true&allVersion=yes&packageId=${param.packageId}"><fmt:message key="wflowClient.assignment.mobile.runProcess.showOldProcess" /></a>
            </c:otherwise>
        </c:choose>
    </div>
    <div id="processList" class="mobileListing">
        <ul>
            <c:forEach items="${processList}" var="process">
                <li>
                    <c:set var="id">${fn:replace(process.id, "#", "%23")}</c:set>

                    <a href="${pageContext.request.contextPath}/web/client/mobile/process/view/${id}">
                        ${process.name} (ver. ${process.version})
                    </a><br/>
                </li>
            </c:forEach>
        </ul>
    </div>
</c:if>

<commons:mobileFooter />
