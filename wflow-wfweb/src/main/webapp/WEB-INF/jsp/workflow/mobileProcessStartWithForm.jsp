<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:mobileHeader/>

        <div id="main-body-header">
            <div id="main-body-header-title">
                ${process.name}
            </div>
            <div id="main-body-header-subtitle">
                ${process.packageId} (version ${process.version})
            </div>
        </div>

    <div id="main-body-content-mobile" style="text-align: left">
        <div class="assignmentForm">
            <c:if test="${!empty errorList}">
                <p class="mobileFormErrors">
                <c:forEach items="${errorList}" var="error">
                    <span class="form-errors"><fmt:message key="wflowClient.assignment.mobile.error.isRequired"><fmt:param value="${error}"/></fmt:message></span><br/>
                </c:forEach>
                </p>
            </c:if>
            <c:import url="/web/formbuilder/mobileView/${form.formId}?username=${username}&processDefId=${process.id}&activityDefId=runProcess&version=${process.version}"/>
        </div>
    </div>

<commons:mobileFooter />
