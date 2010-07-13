<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowAdmin.activity.list.label.title"
    helpTitle="wflowHelp.activity.list.title"
    help="wflowHelp.activity.list.content"
/>

    <div id="main-body-content">
        <div id="main-body-content-filter">
            <form>
            <fmt:message key="wflowAdmin.filter.by.process.id"/>
            <select onchange="filter(JsonDataTable, '&processId=', this.options[this.selectedIndex].value)">
                <option></option>
                <c:forEach items="${processList}" var="processId">
                    <c:set var="selected"><c:if test="${processId == param.processId}"> selected</c:if></c:set>
                    <option value="${processId}" ${selected}>${processId}</option>
                </c:forEach>
            </select>
            </form>
        </div>

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/monitoring/activity/list?${pageContext.request.queryString}" 
                       var="JsonDataTable"
                       divToUpdate="activityList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/monitoring/activity/view"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       fields="['id','name', 'dateCreated', 'serviceLevelMonitor']"
                       column1="{key: 'id', label: 'wflowAdmin.activity.list.label.id', sortable: true}"
                       column2="{key: 'name', label: 'wflowAdmin.activity.list.label.name', sortable: true}"
                       column3="{key: 'state', label: 'wflowAdmin.activity.list.label.state', sortable: false}"
                       column4="{key: 'dateCreated', label: 'wflowAdmin.activity.list.label.dateCreated', sortable: false}"
                       column5="{key: 'serviceLevelMonitor', label: 'wflowAdmin.activity.list.label.serviceLevelMonitor', sortable: false}"
                       />

        <div class="form-buttons">
        	<!--input class="form-button" type="button" value="<fmt:message key="general.method.label.create"/>" onclick="onCreate()"/-->
       	</div>
    </div>
    
    <!--script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/directory/admin/organization/new"/>
        
        function onCreate(){
            popupDialog.init();
        }
        
        function closeDialog() {
            popupDialog.close();
        }

    </script-->

<commons:footer />