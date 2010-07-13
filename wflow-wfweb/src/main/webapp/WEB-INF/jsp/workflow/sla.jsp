<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowAdmin.sla.list.label.title"
    helpTitle="wflowHelp.sla.list.title"
    help="wflowHelp.sla.list.content"
/>

    <div id="main-body-content">
       <div id="main-body-content-filter">
            <form>
            <fmt:message key="wflowAdmin.filter.by.process.definition"/>
            <select onchange="filter(slaTable, '&processDefId=', escape(this.options[this.selectedIndex].value))">
                <option></option>
            <c:forEach items="${processDefinitionList}" var="processDefinition">
                <c:set var="selected"><c:if test="${processDefinition.id == param.processDefId}"> selected</c:if></c:set>
                <option value="${processDefinition.id}" ${selected}>${processDefinition.name} - Version ${processDefinition.version}</option>
            </c:forEach>
            </select>
            </form>
       </div>
        
       <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/sla/list?${pageContext.request.queryString}"
                       var="slaTable"
                       divToUpdate="slaList"
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       fields="['activityName', 'minDelay', 'maxDelay','ratioWithDelay','ratioOnTime','serviceLevelMonitor']"
                       column1="{key: 'activityName', label: 'wflowClient.sla.label.activity.name', sortable: false}"
                       column2="{key: 'serviceLevelMonitor', label: 'wflowClient.sla.label.serviceLevelMonitor', sortable: false}"
                       column3="{key: 'ratioWithDelay', label: 'wflowClient.sla.label.ratio.with.delay', sortable: false}"
                       column4="{key: 'ratioOnTime', label: 'wflowClient.sla.label.ratio.on.time', sortable: false}"
                       column5="{key: 'minDelay', label: 'wflowClient.sla.label.min.delay', sortable: false}"
                       column6="{key: 'maxDelay', label: 'wflowClient.sla.label.max.delay', sortable: false}"
                       />
    </div>

<commons:footer />