<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<commons:popupHeader title="asd"/>

    <div id="main-body-header">
        <div id="main-body-header-title">
            <fmt:message key="wflowClient.userview.label.userviewActivityFormView"/>
        </div>
    </div>

    <div id="main-body-content" style="text-align: left">
        <c:choose>
            <c:when test="${empty formId && empty formUrl}">
                <c:choose>
                    <c:when test="${completed eq 'true' && !empty historyFormId}">
                        <script type="text/javascript">
                            document.location = '${pageContext.request.contextPath}/web/formbuilder/view/${historyFormId}?overlay=true&processId=${processId}&activityId=${activityId}';
                        </script>
                    </c:when>
                    <c:when test="${hasAssignment eq 'true'}">
                        <script type="text/javascript">
                            document.location = '${pageContext.request.contextPath}/web/client/assignment/view/${activityId}?saveLabel=${buttonSaveLabel}&completeLabel=${buttonCompleteLabel}&withdrawLabel=${buttonWithdrawLabel}&cancelLabel=${buttonCancelLabel}&save=${buttonSaveShow}&withdraw=${buttonWithdrawShow}';
                        </script>
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="wflowClient.userview.label.noFormAvailable"/>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:when test="${!empty formId}">
                <c:import url="/web/formbuilder/view/${formId}?processId=${processId}&overlay=true"/>
            </c:when>
            <c:when test="${!empty formUrl}">
                <iframe id="userviewExternalForm" src="${formUrl}?processId=${processId}&username=${username}" frameborder="0" style="height:440px;width:740px"></iframe>
            </c:when>
        </c:choose>

        <c:choose>
            <c:when test="${!(empty formId && empty formUrl) && hasAssignment eq 'true'}">
                <div class="form-buttons">
                    <span class="button"><input type="button" id="continue" value="<fmt:message key="wflowClient.userview.label.continue"/>" onclick="assignmentView()" /></span>
                </div>
                <script type="text/javascript">
                    function assignmentView(){
                        document.location = '${pageContext.request.contextPath}/web/client/assignment/view/${activityId}?saveLabel=${buttonSaveLabel}&completeLabel=${buttonCompleteLabel}&withdrawLabel=${buttonWithdrawLabel}&cancelLabel=${buttonCancelLabel}&save=${buttonSaveShow}&withdraw=${buttonWithdrawShow}';
                    }
                </script>
            </c:when>
            <c:when test="${!(empty formId && empty formUrl) && completed eq 'true' && !empty historyFormId}">
                <div class="form-buttons">
                    <span class="button"><input type="button" id="continue" value="<fmt:message key="wflowClient.userview.label.continue"/>" onclick="historyFormView()" /></span>
                </div>
                <script type="text/javascript">
                    function historyFormView(){
                        document.location = '${pageContext.request.contextPath}/web/formbuilder/view/${historyFormId}?overlay=true&processId=${processId}&activityId=${activityId}';
                    }
                </script>
            </c:when>
        </c:choose>
    </div>
    
<commons:popupFooter />
