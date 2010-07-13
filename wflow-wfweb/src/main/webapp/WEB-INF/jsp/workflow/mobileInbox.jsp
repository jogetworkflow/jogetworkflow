<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:mobileHeader
    title="wflowClient.inbox.list.label.title"
/>

<div class="mobileInfo">
    <fmt:message key="wflowClient.assignment.mobile.inbox.noOfAssignment"><fmt:param value="${total}"/></fmt:message>
</div>
<div id="assignmentList" class="mobileListing">
    <ul>
        <c:forEach items="${assignmentList}" var="assignment">
            <li>
                <a href="${pageContext.request.contextPath}/web/client/mobile/assignment/view/${assignment.activityId}">
                    <span class="date"><fmt:formatDate value="${assignment.dateCreated}" type="both" dateStyle="medium" timeStyle="short" timeZone="${selectedTimeZone}" /></span>
                    <span>${assignment.processName} - ${assignment.activityName}</span>
                </a><br/>
            </li>
        </c:forEach>
    </ul>
</div>

<commons:mobileFooter />
