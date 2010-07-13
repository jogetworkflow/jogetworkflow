<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowAdmin.running.process.view.label.title"
    path1="${pageContext.request.contextPath}/web/monitoring/running/process/view/${wfProcess.instanceId}"
    name1="wflowAdmin.main.body.path.running.process.view"
    helpTitle="wflowHelp.running.process.view.title"
    help="wflowHelp.running.process.view.content"
/>

    <div id="main-body-content">

        <dl>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.id"/></dt>
            <dd>${wfProcess.instanceId}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.version"/></dt>
            <dd>${wfProcess.version}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.name"/></dt>
            <dd><a target="_blank" href="${pageContext.request.contextPath}/web/admin/process/configure/view/<c:out value='${fn:replace(wfProcess.id, "#", "%3A")}'/>">${wfProcess.name}</a>&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.state"/></dt>
            <dd>${wfProcess.state}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.serviceLevelMonitor"/></dt>
            <dd>${serviceLevelMonitor}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.startedTime"/></dt>
            <dd>${trackWflowProcess.startedTime}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.limit"/></dt>
            <dd>${trackWflowProcess.limit}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.due"/></dt>
            <dd>${trackWflowProcess.due}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.delay"/></dt>
            <dd>${trackWflowProcess.delay}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.finishTime"/></dt>
            <dd>${trackWflowProcess.finishTime}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.time.consuming.from.date.created"/></dt>
            <dd>${trackWflowProcess.timeConsumingFromDateCreated}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.running.process.view.label.time.consuming.from.date.started"/></dt>
            <dd>${trackWflowProcess.timeConsumingFromDateStarted}&nbsp;</dd>
        </dl>

        <div class="form-buttons">
            <input class="form-button" type="button" value="<fmt:message key="wflowAdmin.running.process.view.label.viewGraph"/>" onclick="return viewGraph()" />
            <c:set var="processState" value="${wfProcess.state}"/>
            <c:if test="<%= pageContext.getAttribute(\"processState\") != null && pageContext.getAttribute(\"processState\").toString().startsWith(\"open\") %>">
                <input class="form-button" type="button" value="<fmt:message key="wflowAdmin.running.process.view.label.abortProcess"/>" onclick="abortProcessInstance()" />
            </c:if>
            <input class="form-button" type="button" value="<fmt:message key="general.method.label.remove.instance"/>" onclick="removeProcessInstance()" />
            <input class="form-button" type="button" value="<fmt:message key="general.method.label.reevaluate"/>" onclick="reevaluateProcessInstance()" />
        </div>

        <div id="main-body-content-subheader">
        	<fmt:message key="wflowAdmin.activity.list.label.subtitle"/>
        </div>
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/monitoring/activity/list?processId=${wfProcess.instanceId}"
                       var="JsonDataTable"
                       divToUpdate="activityList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="id"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/monitoring/activity/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       fields="['id','name','serviceLevelMonitor']"
                       column1="{key: 'id', label: 'wflowAdmin.activity.list.label.id', sortable: true}"
                       column2="{key: 'name', label: 'wflowAdmin.activity.list.label.name', sortable: true}"
                       column3="{key: 'state', label: 'wflowAdmin.activity.list.label.state', sortable: false}"
                       column4="{key: 'serviceLevelMonitor', label: 'wflowAdmin.activity.list.label.serviceLevelMonitor', sortable: false}"
                       />
        <div id="activityList"></div>
    </div>

    <script>
        function removeProcessInstance(){
            if (confirm('<fmt:message key='wflowAdmin.running.process.view.label.removeProcess.confirm'/>')) {
                var callback = {
                    success : function() {
                        //parent.closeDialog();
                        alert("<fmt:message key='wflowAdmin.running.process.view.label.running.process.instance.removed'/>");
                        document.location = '${pageContext.request.contextPath}/web/monitoring/running/process/list';
                        //parent.location.reload(true);
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/monitoring/running/process/remove', callback, 'wfProcessId=${wfProcess.instanceId}');
            }
        }

        function abortProcessInstance(){
            if (confirm('<fmt:message key='wflowAdmin.running.process.view.label.abortProcess.confirm'/>')) {
                var callback = {
                    success : function() {
                        //parent.closeDialog();
                        alert("<fmt:message key='wflowAdmin.running.process.view.label.running.process.instance.aborted'/>");
                        document.location = '${pageContext.request.contextPath}/web/monitoring/running/process/list';
                        //parent.location.reload(true);
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/monitoring/running/process/abort', callback, 'wfProcessId=${wfProcess.instanceId}');
            }
        }

        function reevaluateProcessInstance(){
               var callback = {
                    success : function() {
                        //parent.closeDialog();
                        alert("<fmt:message key='wflowAdmin.running.process.view.label.running.process.instance.reevaluated'/>");
                        //document.location = '${pageContext.request.contextPath}/web/monitoring/process/list';
                        //parent.location.reload(true);
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/monitoring/running/process/reevaluate', callback, 'wfProcessId=${wfProcess.instanceId}');

        }

        function viewGraph() {
            var url = '${pageContext.request.contextPath}/web/monitoring/process/graph/${wfProcess.instanceId}';
            window.open(url);
            return false;
        }
    </script>

<commons:footer />
