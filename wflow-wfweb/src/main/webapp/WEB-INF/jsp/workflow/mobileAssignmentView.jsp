<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:mobileHeader/>

        <div id="main-body-header">
            <c:choose>
                <c:when test="${error != null && error == 'nullAssignment'}">
                    <div id="main-body-header-title">
                        <fmt:message key="wflowClient.assignment.view.label.nullAssignmentTitle"/>
                    </div>
                </c:when>
                <c:otherwise>
                    <div id="main-body-header-title">
                        ${assignment.activityName}
                    </div>
                    <div id="main-body-header-subtitle">
                        ${assignment.processName} (version ${assignment.processVersion})
                    </div>
                    <div id="main-body-header-date">
                        <fmt:formatDate value="${assignment.dateCreated}" type="both" dateStyle="medium" timeStyle="short" timeZone="${selectedTimeZone}" />
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    <div id="main-body-content-mobile" style="text-align: left">

        <c:choose>
            <c:when test="${error != null && error == 'nullAssignment'}">
                <fmt:message key="wflowClient.assignment.view.label.nullAssignmentDescription"/>
            </c:when>
            <c:otherwise>
                <c:if test="${!assignment.accepted}">
                <c:url var="url" value="/web/client/mobile/assignment/view/${assignment.activityId}?accept=true" />
                    <div class="mobileInfo"><fmt:message key="wflowClient.assignment.view.label.multipleAssignee"/></div>
                    <form id="assignmentForm" name="assignmentForm" method="POST" action="${url}">
                        <input type="submit" value="<fmt:message key="wflowClient.assignment.view.label.accept"/>"/>
                    </form>
                </c:if>
                <c:if test="${assignment.accepted}">
                    <c:set var="formExist" value="false"/>
                    <c:if test="${form[0] != null}">
                        <c:set var="formExist" value="true"/>
                        <div class="assignmentForm">
                            <c:choose>
                                <c:when test="${form[0].type == 'EXTERNAL'}">
                                    <iframe src="${form[0].formUrl}processId=${assignment.processId}&activityId=${assignment.activityId}&version=${assignment.processVersion}&processRequesterId=${assignment.processRequesterId}&username=${username}" frameborder="0" style="border: 0px; width: 100%; height: 300px"></iframe>
                                </c:when>
                                <c:otherwise>
                                    <c:if test="${!empty errorList}">
                                        <p class="mobileFormErrors">
                                        <c:forEach items="${errorList}" var="error">
                                            <span class="form-errors" ><fmt:message key="wflowClient.assignment.mobile.error.isRequired"><fmt:param value="${error}"/></fmt:message></span><br/>
                                        </c:forEach>
                                        </p>
                                    </c:if>
                                    <c:import url="/web/formbuilder/mobileView/${form[0].formId}?processId=${assignment.processId}&activityId=${assignment.activityId}&version=${assignment.processVersion}&processRequesterId=${assignment.processRequesterId}&username=${username}"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                 </c:if>
            </c:otherwise>
        </c:choose>
    </div>

<commons:mobileFooter />
