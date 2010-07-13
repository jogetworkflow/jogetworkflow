<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:set var="headerTitle"><fmt:message key="wflowClient.startProcess.view.label.startProcess"/></c:set>
<commons:popupHeader title="${headerTitle}" />

<c:if test="${param.embed != 'true' || empty param.embed}">
    <div id="main-body-header">
        <c:if test="${!empty process.name}">
            <div id="main-body-header-title">
                ${process.name}
            </div>
            <div id="main-body-header-subtitle">
                ${process.packageId} (version ${process.version})
            </div>
        </c:if>
    </div>
</c:if>

<div id="main-body-content">
    <p>
        <fmt:message key="wflowClient.startProcess.view.label.started" />
    </p>
</div>

<commons:popupFooter />
