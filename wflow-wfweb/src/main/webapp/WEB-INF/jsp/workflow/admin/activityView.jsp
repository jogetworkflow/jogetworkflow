<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowAdmin.activity.view.label.title"
    path1="${pageContext.request.contextPath}/web/monitoring/activity/view/${activity.id}"
    name1="wflowAdmin.main.body.path.activity.view"
    helpTitle="wflowHelp.activity.view.title"
    help="wflowHelp.activity.view.content"
/>
    
    <div id="main-body-content">
        <dl>
            <dt><fmt:message key="wflowAdmin.activity.view.label.name"/></dt>
            <dd>${activity.name}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.state"/></dt>
            <dd>${activity.state}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.serviceLevelMonitor"/></dt>
            <dd>${serviceLevelMonitor}&nbsp;</dd>
            
            <c:if test="${trackWflowActivity.status == 'Pending'}">
                <dt><fmt:message key="wflowAdmin.activity.view.label.list.of.pending"/></dt>
                <dd>
                    <c:choose>
                        <c:when test="${assignUserSize > 1}">
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
                <dt><fmt:message key="wflowAdmin.activity.view.label.accepted.user"/></dt>
                <dd>${trackWflowActivity.nameOfAcceptedUser}&nbsp;</dd>
            </c:if>
            
            <dt><fmt:message key="wflowAdmin.activity.view.label.priority"/></dt>
            <dd>${trackWflowActivity.priority}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.created.time"/></dt>
            <dd>${trackWflowActivity.createdTime}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.started.time"/></dt>
            <dd>${trackWflowActivity.startedTime}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.date.limit"/></dt>
            <dd>${trackWflowActivity.limit}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.due.date"/></dt>
            <dd>${trackWflowActivity.due}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.delay"/></dt>
            <dd>${trackWflowActivity.delay}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.finish.time"/></dt>
            <dd>${trackWflowActivity.finishTime}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.time.consuming.from.date.created"/></dt>
            <dd>${trackWflowActivity.timeConsumingFromDateCreated}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.activity.view.label.time.consuming.from.date.started"/><dt>
            <dd>${trackWflowActivity.timeConsumingFromDateStarted}&nbsp;</dd>
        </dl>

        <div class="form-buttons">
            <c:if test="${activity.state == 'open.not_running.not_started'}">
                    <span class="button"><input class="form-button" type="button" value="<fmt:message key="wflowAdmin.activity.view.label.reevaluate"/>" onclick="reevaluate()"/></span>
                    <span class="button"><input class="form-button" type="button" value="<fmt:message key="wflowAdmin.activity.view.label.reevaluateForUser"/>" onclick="showReevaluateForUser()"/></span>

            </c:if>
            <c:if test="${activity.state != 'closed.completed' && activity.state != 'closed.terminated' && activity.state != 'closed.aborted'}">
                <input class="form-button" type="button" value="<fmt:message key="general.method.label.reassign"/>" onclick="addSingerUser()" />
                <input class="form-button" type="button" value="<fmt:message key="general.method.label.complete"/>" onclick="completeActivity()" />
            </c:if>

            <c:if test="${!empty formId}">
                <span class="button"><input class="form-button" type="button" value="<fmt:message key="wflowAdmin.activity.view.label.viewForm"/>" onclick="viewForm()"/></span>
            </c:if>
        </div>

        <div id="reevaluateForUser" style="display: none">
            <fmt:message key="wflowAdmin.activity.view.label.reevaluateForUserSelectUser"/>
            <select id="reevaluateUser">
                <c:forEach var="assignmentUser" items="${trackWflowActivity.assignmentUsers}">
                    <option>${assignmentUser}</option>
                </c:forEach>
            </select>
            <input id="reevaluateForUserSubmit" class="form-button" type="button" value="<fmt:message key="wflowAdmin.activity.view.label.reevaluateForUserSubmit"/>" onclick="reevaluateForUser()"/>
        </div>
        
        <div id="main-body-content-subheader">
            <fmt:message key="wflowAdmin.activity.view.label.variableList.title"/>
        </div>
        
        <c:forEach var="variable" items="${variableList}" varStatus="rowCounter">
            <div class="form-row">
                <label for="${variable.name}">${variable.name}</label>
                <span class="input">
                    <c:choose>
                        <c:when test="${activity.state != 'closed.completed' && activity.state != 'closed.terminated' && activity.state != 'closed.aborted'}">
                            <input name="${variable.name}" type="text" id="${variable.name}" value="${variable.val}"/>
                            <input type="button" value="set" onclick="setVariable('${variable.name}')"/>
                        </c:when>
                        <c:otherwise>
                            <input name="${variable.name}" type="text" id="${variable.name}" value="${variable.val}" disabled="true"/> 
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </c:forEach>
    </div>

<script>
    <ui:popupdialog var="popupDialog" src=""/>

    var callback = {
        success: function(){
            window.location.reload(true);
        }
    }
    
    function reevaluate(){
        ConnectionManager.post("${pageContext.request.contextPath}/web/json/monitoring/activity/reevaluate", callback, "activityId=${activity.id}");
    }
    
    function setVariable(variable){
        var url = "${pageContext.request.contextPath}/web/json/monitoring/activity/variable/${activity.id}/" + escape(variable);
        var value = $('#' + variable).attr('value');
        
        ConnectionManager.post(url, callback, "value=" + escape(value));
        
    }

    function viewForm(){
        var url = '${pageContext.request.contextPath}/web/formbuilder/view/${formId}?overlay=true&processId=${activity.processId}&activityId=${activity.id}';
        popupDialog.src = url;
        popupDialog.init();
    }


    function addSingerUser(){
        popupDialog.src = "${pageContext.request.contextPath}/web/monitoring/running/activity/addSingleUser?state=${activity.state}&processDefId=${activity.encodedProcessDefId}&activityId=${activity.id}&processId=${activity.processId}";
        popupDialog.init();
    }

    function completeActivity(){
       
        ConnectionManager.post("${pageContext.request.contextPath}/web/monitoring/running/activity/complete", callback, "state=${activity.state}&processDefId=${activity.processDefId}&activityId=${activity.id}&processId=${activity.processId}");
       
    }

    function showReevaluateForUser(){
        $('#reevaluateForUser').slideDown();
    }

    function reevaluateForUser(){
        $('#reevaluateForUserSubmit').attr('disabled', 'disabled');
        $('#reevaluateForUserSubmit').val('<fmt:message key="wflowAdmin.activity.view.label.reevaluateForUserLoading"/>')

        var url = "${pageContext.request.contextPath}/web/json/monitoring/user/reevaluate";
        var value = $('#reevaluateUser').val();

        ConnectionManager.post(url, callback, "username=" + escape(value));
    }
</script>

<commons:footer />
