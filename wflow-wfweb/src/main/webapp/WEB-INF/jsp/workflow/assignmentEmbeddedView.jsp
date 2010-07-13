<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:set var="headerTitle"><fmt:message key="wflowClient.assignment.view.label.title"/></c:set>
<commons:popupHeader title="${headerTitle}" />

<style>
    #assignmentExternalForm{
        border: 0px;
        width: 100%;
        height: 300px;
    }
</style>

    <c:if test="${!empty param.css}">
        <link rel="stylesheet" type="text/css" href="${param.css}">
    </c:if>

    <div id="main-body-content-embedded" style="text-align: left">

        <c:choose>
            <c:when test="${error != null && error == 'nullAssignment'}">
                <fmt:message key="wflowClient.assignment.view.label.nullAssignmentDescription"/>
            </c:when>
            <c:otherwise>

                <c:url var="url" value="/web/json/workflow/assignment/accept/${assignment.activityId}" />
                <form id="assignmentForm" name="assignmentForm" method="POST"></form>
                    <c:if test="${assignment.accepted}">
                    <c:set var="formExist" value="false"/>
                    <c:if test="${form[0] != null}">
                        <c:set var="formExist" value="true"/>
                        <div class="assignmentForm">
                            <c:choose>
                                <c:when test="${form[0].type == 'EXTERNAL'}">
                                    <iframe id="assignmentExternalForm" src="${form[0].formUrl}processId=${assignment.processId}&activityId=${assignment.activityId}&version=${assignment.processVersion}&processRequesterId=${assignment.processRequesterId}&username=${username}&redirect=${param.complete}" frameborder="0" style="${form[0].formIFrameStyle}"></iframe>
                                </c:when>
                                <c:otherwise>
                                    <!--iframe src="/wflow-formsweb/web/form/view/${form[0].formId}?processId=${assignment.processId}&activityId=${assignment.activityId}&version=${assignment.processVersion}&username=${username}" style="border: 0px; width: 100%; height: 300px"></iframe-->
                                        <c:import url="/web/formbuilder/view/${form[0].formId}?processId=${assignment.processId}&activityId=${assignment.activityId}&version=${assignment.processVersion}&processRequesterId=${assignment.processRequesterId}&username=${username}"/>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                    </c:if>

                    <c:if test="${!empty assignment.activityId  && (form[0].type != 'EXTERNAL' || !assignment.accepted)}">
                    <div class="form-buttons">
                        <c:set var="saveLabel"><fmt:message key="wflowClient.assignment.view.label.save"/></c:set>
                        <c:set var="completeLabel"><fmt:message key="wflowClient.assignment.view.label.complete"/></c:set>
                        <c:set var="withdrawLabel"><fmt:message key="wflowClient.assignment.view.label.withdraw"/></c:set>
                        <c:set var="cancelLabel"><fmt:message key="wflowClient.assignment.view.label.cancel"/></c:set>
                        <c:if test="${!empty param.saveLabel}">
                            <c:set var="saveLabel" value="${param.saveLabel}"></c:set>
                        </c:if>
                        <c:if test="${!empty param.completeLabel}">
                            <c:set var="completeLabel" value="${param.completeLabel}"></c:set>
                        </c:if>
                        <c:if test="${!empty param.withdrawLabel}">
                            <c:set var="withdrawLabel" value="${param.withdrawLabel}"></c:set>
                        </c:if>
                        <c:if test="${!empty param.cancelLabel}">
                            <c:set var="cancelLabel" value="${param.cancelLabel}"></c:set>
                        </c:if>

                        <c:if test="${assignment.accepted}">
                            <c:if test="${formExist}">
                                <c:if test="${param.save != 'false'}">
                                    <span class="button"><input type="button" id="save" value="${saveLabel}" onclick="submitForm('${param.save}', null, true)" /></span>
                                </c:if>
                                <c:if test="${param.reset != 'false'}">
                                    <span class="button"><input type="button" id="reset" value="<fmt:message key="wflowClient.assignment.view.label.reset"/>" onclick="resetForm('${param.reset}')" /></span>
                                </c:if>
                            </c:if>
                            <c:if test="${param.complete != 'false'}">
                                <span class="button"><input type="button" id="complete" value="${completeLabel}" onclick="assignmentComplete('${param.complete}')" /></span>
                            </c:if>
                            <c:if test="${param.withdraw != 'false'}">
                                <span class="button"><input type="button" id="withdraw" value="${withdrawLabel}" onclick="assignmentWithdraw('${param.withdraw}')" /></span>
                            </c:if>
                        </c:if>
                        <c:if test="${!assignment.accepted}">
                        <span class="button"><input type="button" id="accept" value="<fmt:message key="wflowClient.assignment.view.label.accept"/>" onclick="assignmentAccept()" /></span>
                        </c:if>
                        <c:if test="${param.cancel != 'false'}">
                            <span class="button"><input id="cancel" type="button" value="${cancelLabel}" onclick="closeDialog('${param.cancel}')" /></span>
                        </c:if>
                    </div>
                    </c:if>
                
            </c:otherwise>
        </c:choose>
        
        
    </div>
            
<script>
    $(document).ready(function(){
        var cancel = '${param.cancel}';

        if(cancel == '' || cancel == 'false'){
            if(window.parent == window)
                $("#cancel").hide();

            try{
                parent.PopupDialogCache;
            }catch(e){
                $("#cancel").hide();
            }
        }
    })

    function closeDialog(cancel) {
        if(cancel == undefined || cancel == '' || cancel == 'false'){
            PopupDialog.closeDialog();
            return false;
        }else{
            document.location = cancel;
        }
    }

    function refreshAll() {
        if (window.parent && window.parent.assignmentAcceptedList) {
            window.parent.assignmentAcceptedList.refresh();
        }
        if (window.parent && window.parent.assignmentPendingList) {
            window.parent.assignmentPendingList.refresh();
        }
        if (window.parent && window.parent.assignmentAcceptedTree) {
            window.parent.assignmentAcceptedTree.refresh();
        }
        if (window.parent && window.parent.assignmentPendingTree) {
            window.parent.assignmentPendingTree.refresh();
        }
        if (window.parent && window.parent.xssAssignmentPendingTree) {
            window.parent.xssAssignmentPendingTree.refresh();
        }
        if (window.parent && window.parent.xssAssignmentAcceptedTree) {
            window.parent.xssAssignmentAcceptedTree.refresh();
        }
        return false;
    }

    function assignmentCompleteSendRequest(url, reload, redirect){
        $('#complete').attr('disabled', 'disabled');
        var callbackSr = {
            success: function(o) {
                var obj = eval('(' + o + ')');
                if(redirect){
                    var param = (redirect.indexOf('?') == -1) ? "?processId=" : "&processId=";
                    var path = redirect + param + obj.processId;
                    document.location = path;
                }else{
                    refreshAll();
                    if(reload) document.location.reload(true);
                }
            },
            failure: function(o) { alert("Could not send request") }
        };
        ConnectionManager.post(url, callbackSr, null);

        if(!reload && !redirect)
            closeDialog();

        return false;
    }

    function sendRequest(url, reload, redirect) {
        $('#complete').attr('disabled', 'disabled');
        var callbackSr = {
            success: function(o) {
                if(redirect) document.location = redirect;
                else{
                    refreshAll();
                    if(reload) document.location.reload(true);
                }
            },
            failure: function(o) { alert("Could not send request") }
        };
        ConnectionManager.post(url, callbackSr, null);
        
        if(!reload && !redirect)
            closeDialog();

        return false;
    }

    function setVariable(variable, value){
        var url = "${pageContext.request.contextPath}/web/json/workflow/assignment/variable/${assignment.activityId}/" + escape(variable);
        
        ConnectionManager.post(url, null, "value=" + escape(value));
    }
                
    function assignmentComplete(complete) {
        if (confirm('<fmt:message key="wflowClient.assignment.view.label.confirm"/>')) {
            <c:choose>
                <c:when test="${form[0].type == 'EXTERNAL'}">
                    var url = "${pageContext.request.contextPath}/web/json/workflow/assignment/complete/${assignment.activityId}";
                </c:when>
                <c:otherwise>
                    var url = "${pageContext.request.contextPath}/web/json/workflow/assignment/complete/${assignment.activityId}";
                </c:otherwise>
            </c:choose>
            
            var form = document.forms["assignmentForm"];

            <c:if test="${assignment.accepted}">
            <c:if test="${form[0] == null}">
            //get & set variable
            var e = document.getElementById("variable");
            if (e) {
                var inputs = e.getElementsByTagName('input');
                for(i=0; i<inputs.length; i++){
                    setVariable(inputs[i].name, inputs[i].value);
                }
            }
            </c:if>
            </c:if>
            
            //save form (if any)
            <c:if test="${formExist}">
                if(complete != 'true')
                    submitForm(null, function(){assignmentCompleteSendRequest(url, null, complete)});
                else
                    submitForm(null, function(){assignmentCompleteSendRequest(url)});
            </c:if>
            <c:if test="${!formExist}">
                //complete assignment
                if(complete != 'true')
                    assignmentCompleteSendRequest(url, null, complete);
                else
                    assignmentCompleteSendRequest(url);
            </c:if>

            
        }
        return false;
    }
    
    function assignmentWithdraw(withdraw) {
        if (confirm('<fmt:message key="wflowClient.assignment.view.label.confirm"/>')) {
            $('#withdraw').attr('disabled', 'disabled');
            var url = "${pageContext.request.contextPath}/web/json/workflow/assignment/withdraw/${assignment.activityId}";

            if(withdraw != 'true')
                sendRequest(url, null, withdraw);
            else
                sendRequest(url);
        }
        return false;
    }
    
    function assignmentAccept() {
        if (confirm('<fmt:message key="wflowClient.assignment.view.label.confirm"/>')) {
            $('#accept').attr('disabled', 'disabled');
            var url = "${pageContext.request.contextPath}/web/json/workflow/assignment/accept/${assignment.activityId}";
            sendRequest(url, true);            
        }
        return false;
    }
    
</script>
<commons:popupFooter />
