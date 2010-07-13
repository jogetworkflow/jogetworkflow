<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowAdmin.processConfiguration.list.label.title"
    helpTitle="wflowHelp.process.configure.list.title"
    help="wflowHelp.process.configure.list.content"
/>

<script>
    function convert(process){
        process.id = process.id.replace(/#/g, ':');
    }
    
    function convertProcessId(jsonObject){
        if(jsonObject.data != undefined && jsonObject.data.length == undefined){
            convert(jsonObject.data);
        }else{
            for(var i in jsonObject.data){
                convert(jsonObject.data[i]);
            }
        }

        return jsonObject;
    }
</script>

    <div id="main-body-content">
        <div id="main-body-content-filter">
            <form style="float:left">
            <fmt:message key="wflowAdmin.filter.by.package"/>
            <select id="packageFilter" onchange="filter(processTable, '&allVersion=' + $('#versionFilter').val() + '&packageId=', this.options[this.selectedIndex].value)">
                <option></option>
                <c:forEach items="${packageList}" var="workflowPackage">
                    <c:set var="selected"><c:if test="${workflowPackage.packageId == param.packageId}"> selected</c:if></c:set>
                    <option value="${workflowPackage.packageId}" ${selected}>${workflowPackage.packageName}</option>
                </c:forEach>
            </select>
            </form>
            <form style="float:right">
            <fmt:message key="wflowAdmin.filter.by.version"/>
            <select id="versionFilter" onchange="filter(processTable, '&packageId=' + $('#packageFilter').val() + '&allVersion=', this.options[this.selectedIndex].value)">
                <option selected value="no">No</option>
                <option value="yes">Yes</option>
            </select>
            </form>
            <div style="clear: both"></div>
        </div>

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/process/list?${pageContext.request.queryString}" 
                       var="processTable"
                       divToUpdate="processList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/admin/process/configure/view/"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="false"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       customPreProcessor="convertProcessId"
                       fields="['id','packageId','packageName','name','version']"
                       column1="{key: 'packageId', label: 'wflowAdmin.processConfiguration.list.label.packageId', sortable: true, hide:true}"
                       column2="{key: 'packageName', label: 'wflowAdmin.processConfiguration.list.label.packageName', sortable: true, width: '200'}"
                       column3="{key: 'name', label: 'wflowAdmin.processConfiguration.list.label.name', sortable: true, width: '310'}"
                       column4="{key: 'version', label: 'wflowAdmin.processConfiguration.list.label.version', sortable: false, width: '50'}"
                       />
        <div id="main-body-actions">
            <div>
                <button onclick="createProcess()"><fmt:message key="general.tab.designProcess.newProcess"/></button>
                <button onclick="importProcess()"><fmt:message key="general.tab.designProcess.importPackage"/></button>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function createProcess(){
            location.href="${pageContext.request.contextPath}/web/admin/package/upload";
        }

        function importProcess(){
            location.href="${pageContext.request.contextPath}/web/admin/process/configure/import";
        }
    </script>

<commons:footer />
