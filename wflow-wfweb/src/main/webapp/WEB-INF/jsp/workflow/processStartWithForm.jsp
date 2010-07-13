<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:set var="headerTitle"><fmt:message key="wflowClient.startProcess.view.label.startProcess"/></c:set>
<commons:popupHeader title="${headerTitle}" />

    <c:if test="${!empty param.css}">
        <link rel="stylesheet" type="text/css" href="${param.css}">
    </c:if>

    <c:if test="${param.embed != 'true' || empty param.embed}">
        <div id="main-body-header">
            <div id="main-body-header-title">
                ${process.name}
            </div>
            <div id="main-body-header-subtitle">
                ${process.packageId} (version ${process.version})
            </div>
        </div>
    </c:if>

    <div id="main-body-content" style="text-align: left">
        <c:import url="/web/formbuilder/view/${form.formId}?username=${username}&activityId=runProcess&version=${process.version}&processDefId=${process.encodedId}&parentProcessId=${parentProcessId}"/>

        <div class="form-buttons">
            <c:set var="completeLabel"><fmt:message key="wflowClient.assignment.view.label.complete"/></c:set>
            <c:set var="cancelLabel"><fmt:message key="wflowClient.assignment.view.label.cancel"/></c:set>
            <c:if test="${!empty param.completeLabel}">
                <c:set var="completeLabel" value="${param.completeLabel}"></c:set>
            </c:if>
            <c:if test="${!empty param.cancelLabel}">
                <c:set var="cancelLabel" value="${param.cancelLabel}"></c:set>
            </c:if>

            <c:if test="${param.complete != 'false'}">
                <span class="button"><input type="button" id="complete" value="${completeLabel}" onclick="formComplete('${param.complete}')" /></span>
            </c:if>
            <c:if test="${param.reset == 'true'}">
                <span class="button"><input type="button" id="reset" value="<fmt:message key="wflowClient.assignment.view.label.reset"/>" onclick="resetForm('${param.reset}')" /></span>
            </c:if>
            <c:if test="${param.cancel != 'false'}">
                <span class="button"><input id="cancel" type="button" value="${cancelLabel}" onclick="closeDialog('${param.cancel}')" /></span>
            </c:if>
        </div>

    </div>

<script type="text/javascript">
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
            parent.PopupDialog.closeDialog();
            return false;
        }else{
            document.location = cancel;
            return false;
        }
    }

    function refreshAll() {
        if (window.parent && window.parent.assignmentInbox) {
            window.parent.assignmentInbox.refresh();
        }
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
        if (window.parent && window.parent.xssAssignmentAcceptedTree) {
            window.parent.xssAssignmentAcceptedTree.refresh();
        }
        if (window.parent && window.parent.updatePendingTaskCount) {
            window.parent.updatePendingTaskCount();
        }

        return false;
    }

    function formComplete(complete){
        if(performValidation()){
            $('#complete').attr("disabled", "disabled");
            submitForm(null, function(response){
                response = eval("(" + response + ")");

                if(response.activityId == undefined){
                    if(complete && complete != 'true') {
                        document.location = complete;
                    }
                    else {
                        document.location='${pageContext.request.contextPath}/web/client/process/started/' + response.processId + "?${queryString}";
                    }
                }else{
                    document.location='${pageContext.request.contextPath}/web/client/assignment/view/' + response.activityId + "?${queryString}";
                }
            });
        }
    }
</script>
<commons:popupFooter />
