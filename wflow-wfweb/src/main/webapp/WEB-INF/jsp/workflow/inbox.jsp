<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowClient.inbox.list.label.title"
    helpTitle="wflowHelp.assignment.inbox.list.title"
    help="wflowHelp.assignment.inbox.list.content"
/>
<link rel="alternate" type="application/rss+xml" title="<fmt:message key="wflowClient.rss.label.inboxTitle"/>" href="${pageContext.request.contextPath}${rssLink}">
<script>
    function markAsPending(task){
        task.processName = "<span class=\"pendingTask\">" + task.processName + "</span>";
        task.activityName = "<span class=\"pendingTask\">" + task.activityName + "</span>";
        task.processVersion = "<span class=\"pendingTask\">" + task.processVersion + "</span>";
        task.dateCreated = "<span class=\"pendingTask\">" + task.dateCreated + "</span>";
        task.processId = "<span class=\"pendingTask\">" + task.processId + "</span>";
        task.due = "<span class=\"pendingTask\">" + task.due + "</span>";
    }

    function checkAccepted(jsonObject){
        if(jsonObject.data != undefined && jsonObject.data.length == undefined){
            if(jsonObject.data.acceptedStatus == false){
                markAsPending(jsonObject.data);
            }
        }else{
            for(var i in jsonObject.data){
                if(jsonObject.data[i].acceptedStatus == false){
                    markAsPending(jsonObject.data[i]);
                }
            }
        }

        return jsonObject;
    }
</script>

    <div id="main-body-content">
            <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/assignment/list"
                       var="assignmentInbox"
                       divToUpdate="assignmentInbox"
                       jsonData="data"
                       rowsPerPage="10"
                       sort="dateCreated"
                       desc="true"
                       width="100%"
                       href="${pageContext.request.contextPath}/web/client/assignment/view/"
                       hrefParam="activityId"
                       hrefQuery="false"
                       hrefDialog="true"
                       hrefDialogWidth="600px"
                       hrefDialogHeight="400px"
                       hrefDialogTitle="Process Dialog"
                       customPreProcessor="checkAccepted"
                       fields="['activityId','processName','activityName','processVersion', 'dateCreated', 'processId', 'acceptedStatus', 'serviceLevelMonitor', 'due']"
                       column1="{key: 'processName', label: 'wflowClient.inbox.list.label.processName', sortable: false, width: '150'}"
                       column2="{key: 'activityName', label: 'wflowClient.inbox.list.label.activityName', sortable: false, width: '260'}"
                       column3="{key: 'processVersion', label: 'wflowClient.inbox.list.label.processVersion', sortable: false, hide:true}"
                       column4="{key: 'dateCreated', label: 'wflowClient.inbox.list.label.dateCreated', sortable: true, width: '120'}"
                       column5="{key: 'processId', label: 'wflowClient.inbox.list.label.processId', sortable: true, hide:true}"
                       column6="{key: 'serviceLevelMonitor', label: 'wflowClient.inbox.list.label.serviceLevelMonitor', sortable: true}"
                       column7="{key: 'due', label: 'wflowClient.inbox.list.label.due', sortable: true}"
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
        <span id="embed-icon"><a onclick="toggleEmbedCode()"><fmt:message key="wflowClient.inbox.embedCode"/></a></span>
        <span id="rss-icon"><a href="${pageContext.request.contextPath}${rssLink}"><span><fmt:message key="wflowClient.inbox.rss"/></span></a></span>
    </div>
    
    <div style="clear:both;"></div>

    <div id="embed-code" name="embed-code">
        <textarea>
    	<link rel="stylesheet" type="text/css" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/css/workflow.portlet.css">
	<script type="text/javascript" src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/js/jquery/jquery-1.2.6.pack.js"></script>
	<script type="text/javascript" src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/js/json/util.js"></script>
        <div id="inbox1"><center><img src="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/images/joget/portlet_loading.gif"/></center></div>
        <script type="text/javascript" >$(document).ready(function(){ $.getScript('${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/js/workflow/inbox.js?id=1&rows=5&divId=inbox1',null);	});	</script>
        </textarea>
    </div>

<commons:footer />
