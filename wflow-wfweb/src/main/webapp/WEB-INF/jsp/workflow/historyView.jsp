<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowClient.history.view.label.title"
    helpTitle="wflowHelp.assignment.history.list.title"
    help="wflowHelp.assignment.history.list.content"
/>

    <div id="main-body-content">
        <dl>
            <dt><fmt:message key="wflowClient.history.view.label.name"/></dt>
            <dd>${activity.name}&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.state"/></dt>
            <dd>${activity.state}&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.serviceLevelMonitor"/></dt>
            <dd>${serviceLevelMonitor}&nbsp;</dd>

            <c:if test="${trackWflowActivity.status == 'Pending'}">
                <dt><fmt:message key="wflowClient.history.view.label.list.of.pending"/></dt>
                <dd>
                    <c:choose>
                        <c:when test="${assignUserSize>1}">
                            <c:forEach var="assignmentUser" items="${trackWflowActivity.assignmentUsers}" varStatus="index">
                                    <c:choose>
                                        <c:when test="${index.count < assignUserSize}">
                                            <span><c:out value="${assignmentUser}, "/></span>
                                        </c:when>
                                        <c:otherwise>
                                            <span><c:out value="${assignmentUser}"/></span>
                                        </c:otherwise>
                                    </c:choose>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="assignmentUser" items="${trackWflowActivity.assignmentUsers}">
                                ${assignmentUser}
                            </c:forEach>
                        </c:otherwise>
                       </c:choose>
                   &nbsp;</dd>
                </c:if>


            <c:if test="${trackWflowActivity.status != 'Pending'}">
                <dt><fmt:message key="wflowClient.history.view.label.accepted.user"/></dt>
                <dd>${trackWflowActivity.nameOfAcceptedUser}&nbsp;</dd>
            </c:if>
            <dt><fmt:message key="wflowClient.history.view.label.priority"/></dt>
            <dd>${trackWflowActivity.priority}&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.created.time"/></dt>
            <dd><fmt:formatDate value="${trackWflowActivity.createdTime}" pattern="EEE, dd-MM-yyyy hh:mm aa" timeZone="${selectedTimeZone}" />&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.started.time"/></dt>
            <dd><fmt:formatDate value="${trackWflowActivity.startedTime}" pattern="EEE, dd-MM-yyyy hh:mm aa" timeZone="${selectedTimeZone}" />&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.date.limit"/></dt>
            <dd>${trackWflowActivity.limit}&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.due.date"/></dt>
            <dd><fmt:formatDate value="${trackWflowActivity.due}" pattern="EEE, dd-MM-yyyy hh:mm aa" timeZone="${selectedTimeZone}" />&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.delay"/></dt>
            <dd>${trackWflowActivity.delay}&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.finish.time"/></dt>
            <dd><fmt:formatDate value="${trackWflowActivity.finishTime}" pattern="EEE, dd-MM-yyyy hh:mm aa" timeZone="${selectedTimeZone}" />&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.time.consuming.from.date.created"/></dt>
            <dd>${trackWflowActivity.timeConsumingFromDateCreated}&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.time.consuming.from.date.started"/><dt>
            <dd>${trackWflowActivity.timeConsumingFromDateStarted}&nbsp;</dd>
            <dt><fmt:message key="wflowClient.history.view.label.current.process.status"/><dt>
            <dd>${processStatus}&nbsp;</dd>
        </dl>
        <div class="form-buttons">
            <c:if test="${!empty formId}">
                <span class="button"><input class="form-button" type="button" value="View Form" onclick="viewForm()"/></span>
            </c:if>
        </div>

        <div id="main-body-content-subheader">
            <fmt:message key="wflowClient.history.view.label.currentRunningActivity.title"/>
        </div>
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/assignment/history/activity/list?processId=${activity.processId}"
                       var="JsonDataTable"
                       divToUpdate="activityList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="dateCreated"
                       desc="true"
                       fields="['activityId','activityName','version','dateCreated','state','acceptedUser','assignmentUser']"
                       column1="{key: 'activityId', label: 'wflowClient.history.view.label.activityId', sortable: true, hide:true}"
                       column2="{key: 'activityName', label: 'wflowClient.history.view.label.activityName', sortable: true, width: '160'}"
                       column3="{key: 'version', label: 'wflowClient.history.view.label.version', sortable: false, hide:true}"
                       column4="{key: 'state', label: 'wflowClient.history.view.label.state', sortable: true, width: '140'}"
                       column5="{key: 'acceptedUser', label: 'wflowClient.history.view.label.accepted.user', sortable: true, width: '100'}"
                       column6="{key: 'assignmentUser', label: 'wflowClient.history.view.label.list.of.pending', sortable: false}"
                       column7="{key: 'dateCreated', label: 'wflowClient.history.view.label.created.time', sortable: true, hide:true}"
                       />
        
    </div>

<script>
    <ui:popupdialog var="popupDialog" src=""/>

    var callback = {
        success: function(){
            window.location.reload(true);
        }
    }

    function viewForm(){
        var url = '${pageContext.request.contextPath}/web/formbuilder/view/${formId}?overlay=true&processId=${activity.processId}&activityId=${activity.id}';
        popupDialog.src = url;
        popupDialog.init();
    }
</script>

<commons:footer />

