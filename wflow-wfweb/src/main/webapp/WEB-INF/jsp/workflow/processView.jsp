<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <c:if test="${!empty param.css}">
        <link rel="stylesheet" type="text/css" href="${param.css}">
    </c:if>

    <div id="start-process-content-outer">
        <div id="start-process-content-inner">
            <div id="start-process-title">
                ${process.name} -   ${process.packageName} (version ${process.version})
            </div>
            <c:url var="url" value="/web/client/process/start/${process.encodedId}?${queryString}" />
            <form id="processForm" name="processForm" method="POST" action="${url}">

                <c:if test="${param.embed != 'true' || empty param.embed}">
                <div>
                    <a id="showAdvancedInfo" onclick="showAdvancedInfo()"><fmt:message key="wflowAdmin.processConfiguration.view.label.showAdditionalInfo"/></a>
                    <a style="display: none" id="hideAdvancedInfo" onclick="hideAdvancedInfo()"><fmt:message key="wflowAdmin.processConfiguration.view.label.hideAdditionalInfo"/></a>
                    <div id="advancedView" style="display: none">
                        <dl>
                            <dt><fmt:message key="wflowClient.startProcess.view.label.packageId"/></dt>
                            <dd>${process.packageId}&nbsp;</dd>
                            <dt><fmt:message key="wflowClient.startProcess.view.label.processDefId"/></dt>
                            <dd>${process.id}&nbsp;</dd>
                            <dt><fmt:message key="wflowClient.startProcess.view.label.description"/></dt>
                            <dd>${process.description}&nbsp;</dd>
                            <!--
                            <dt>Variables</dt>
                            <dd>
                                <c:forEach var="variable" items="${param}">
                                    <c:if test="${fn:startsWith(variable, 'var_')}">
                                        ${variable}
                                    </c:if>
                                </c:forEach>
                            </dd>
                            -->
                        </dl>
                    </div>
                </div>
                </c:if>
                <div  class="start-process-button" >
                    <input type="submit" value="<fmt:message key="wflowClient.startProcess.view.label.start"/>" onclick="return startProcess()" />
                </div>
             </form>
        </div>
        <a href="javascript:closeDialog('${param.cancel}')"><fmt:message key="wflowClient.startProcess.view.label.cancelStart"/></a>
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
                parent.PopupDialog.closeDialog();
                return false;
            }else{
                document.location = cancel;
            }
        }

        function startProcess(){
            if(confirm('<fmt:message key="wflowClient.startProcess.view.label.startConfirm"/>')){
                setTimeout(function() { $('#start').attr('disabled', 'disabled') }, 0);
                return true;
            }
            else {
                return false;
            }
        }

        function showAdvancedInfo(){
            $('#advancedView').slideToggle('slow');
            $('#showAdvancedInfo').hide();
            $('#hideAdvancedInfo').show();
        }

        function hideAdvancedInfo(){
            $('#advancedView').slideToggle('slow');
            $('#showAdvancedInfo').show();
            $('#hideAdvancedInfo').hide();
        }
    </script>
<commons:popupFooter />