<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowClient.startProcess.list.label.title"
    helpTitle="wflowHelp.process.list.title"
    help="wflowHelp.process.list.content"
/>

    <div id="main-body-content">

       <div id="main-body-content-filter">
            <form style="float:left">
            <fmt:message key="wflowClient.filter.by.package"/>
            <select id="packageFilter" onchange="filter(processTable, '&allVersion=' + $('#versionFilter').val() + '&packageId=', this.options[this.selectedIndex].value)">
                <option></option>
                <c:forEach items="${packageList}" var="workflowPackage">
                    <c:set var="selected"><c:if test="${workflowPackage.packageId == param.packageId}"> selected</c:if></c:set>
                    <option value="${workflowPackage.packageId}" ${selected}>${workflowPackage.packageName}</option>
                </c:forEach>
            </select>
            </form>
            <form style="float:right">
            <fmt:message key="wflowClient.filter.by.version"/>
            <select id="versionFilter" onchange="filter(processTable, '&packageId=' + $('#packageFilter').val() + '&allVersion=', this.options[this.selectedIndex].value)">
                <option selected value="no">No</option>
                <option value="yes">Yes</option>
            </select>
            </form>
            <div style="clear: both"></div>
        </div>

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/process/list?checkWhiteList=true&${pageContext.request.queryString}"
                       var="processTable"
                       divToUpdate="processList" 
                       jsonData="data"
                       rowsPerPage="10"
                       width="100%"
                       sort="name"
                       desc="false"
                       href="${pageContext.request.contextPath}/web/client/process/view/"
                       hrefParam="id"
                       hrefQuery="false"
                       hrefDialog="true"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       fields="['id','packageId', 'packageName', 'name','version']"
                       column1="{key: 'packageName', label: 'wflowClient.startProcess.list.label.packageName', sortable: true}"
                       column2="{key: 'name', label: 'wflowClient.startProcess.list.label.name', sortable: true}"
                       column3="{key: 'version', label: 'wflowClient.startProcess.list.label.version', sortable: false}"
                       />
    </div>

    <script type="text/javascript">
        function toggleEmbedCode(){
            var embedToggleCallback = function() {
                $('#embed-code textarea').focus().select();
            };
            $("#embed-code").toggle("slow", embedToggleCallback );
        }
    </script>

    <div style="float:right;position: relative;margin-bottom:5px;">
        <span id="embed-icon"><a onclick="toggleEmbedCode();"><fmt:message key="wflowClient.startProcess.embedCode"/></a></span>
    </div>

    <div style="clear:both;"></div>

    <div id="embed-code" name="embed-code">
        <textarea>
            <link rel="stylesheet" type="text/css" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/css/workflow.portlet.css">
            <script type="text/javascript" src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/js/jquery/jquery-1.2.6.pack.js"></script>
            <script type="text/javascript" src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/js/json/util.js"></script>
            <div id="processList1"><center><img src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/images/joget/portlet_loading.gif"/></center></div>
            <script type="text/javascript" >$(document).ready(function(){$.getScript('${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/js/workflow/processList.js?id=2&rows=${rows}&divId=processList1',null);});</script>
        </textarea>
        
    </div>

<commons:footer />
