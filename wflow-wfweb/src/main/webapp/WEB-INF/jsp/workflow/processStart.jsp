<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>


<c:set var="headerTitle"><fmt:message key="wflowClient.startProcess.view.label.startProcess"/></c:set>
<commons:popupHeader title="${headerTitle}" />

<script>
    <c:choose>
        <c:when test="${flag == 'true'}">
           document.location = '${pageContext.request.contextPath}/web/client/assignment/view/${activityId}?${queryString}';
        </c:when>
        <c:when test="${!empty complete}">
           var complete = '${complete}';
           if(complete != 'true'){
                document.location = complete;
           }
        </c:when>
    </c:choose>
</script>

    <div id="main-body-content">
        <p>
            <fmt:message key="wflowClient.startProcess.view.label.started" />
        </p>
    </div>

<commons:popupFooter />


