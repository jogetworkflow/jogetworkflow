<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:mobileHeader />

    <c:if test="${!empty param.css}">
        <link rel="stylesheet" type="text/css" href="${param.css}">
    </c:if>
    
    <div id="start-process-content">
        <div id="mobile-start-process-title">
            <span id="packageName">${process.packageName}</span>
            <span id="processName">${process.name} (ver. ${process.version})</span>
        </div>
        <div class="mobileMoreInfo">
            <c:if test="${empty param.detail}">
                <a id="showAdvancedInfo" href="${pageContext.request.contextPath}/web/client/mobile/process/view/${process.encodedId}?detail=true&${queryString}"><fmt:message key="wflowAdmin.processConfiguration.view.label.showAdditionalInfo"/></a>
            </c:if>
            <c:if test="${!empty param.detail && param.detail eq 'true'}">
                <div>
                    <span class="label"><fmt:message key="wflowClient.startProcess.view.label.packageId"/> : </span>
                    <span class="value">${process.packageId}</span><br />
                    <span class="label"><fmt:message key="wflowClient.startProcess.view.label.processDefId"/> : </span>
                    <span class="value">${process.id}</span><br />
                    <span class="label"><fmt:message key="wflowClient.startProcess.view.label.description"/> : </span>
                    <span class="value">${process.description}</span><br />
                </div>
            </c:if>
        </div>
        <c:url var="url" value="/web/client/mobile/process/start/${process.encodedId}?${queryString}" />
        <form id="processForm" name="processForm" method="POST" action="${url}">
            <input type="submit" value="<fmt:message key="wflowClient.startProcess.view.label.start"/>"/>
        </form>
    </div>
<commons:mobileFooter />