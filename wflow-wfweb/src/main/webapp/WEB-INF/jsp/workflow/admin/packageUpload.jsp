<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<commons:header 
    title="wflowAdmin.designNewProcess.view.label.title"
    helpTitle="wflowHelp.package.upload.title"
    help="wflowHelp.package.upload.content"
/>

    <div id="main-body-content">
        <div id="main-body-content-left">
            <div class="main-body-content-subheader-inner">
                <fmt:message key="wflowAdmin.designNewProcess.view.label.stepOne"/>
            </div>

            <div class="main-body-content-inner">
                <div id="package-design-image">
                    <img valign="middle" border="0" src="${pageContext.request.contextPath}/images/v2/ic_workflow.png" width="90" height="102" />
                </div>
                <div id="package-design-body">
                    <a href="#" onclick="launchDesigner();return false"><fmt:message key="wflowAdmin.designNewProcess.view.label.launchDesigner"/></a>
                    <script src="${pageContext.request.contextPath}/js/deployJava.js"></script>
                    <script>
                        if (!deployJava.isWebStartInstalled("1.5.0")) {
                            document.write('<div class="form-error"><fmt:message key="wflowAdmin.designNewProcess.view.label.webstartUnavailable"/></div>');
                        }
                    </script>
                </div>
            </div>
        </div>

        <div id="main-body-content-right">
            <div class="main-body-content-subheader-inner">
                <fmt:message key="wflowAdmin.designNewProcess.view.label.stepTwo"/>
            </div>

            <div class="main-body-content-inner">
                <div id="package-upload-image">
                    <img valign="middle" border="0" src="${pageContext.request.contextPath}/images/v2/ic_xpdl.png" width="90" height="102" />
                </div>
                <div id="package-upload-body">
                    <c:if test="${errorMessage != null}">
                        <div class="form-error">
                            ${errorMessage}
                        </div>
                    </c:if>

                    <c:url var="url" value="" />
                    <form method="post" action="${pageContext.request.contextPath}/web/admin/package/upload/submit" class="form" enctype="multipart/form-data">
                        <div class="form-row">
                            <label for="field1" class="upload"><fmt:message key="wflowAdmin.designNewProcess.view.label.processXpdlFile"/></label>
                            <span class="form-input">
                                <input type="file" name="packageXpdl"/>
                            </span>
                        </div>
                        <div id="package-upload-buttons">
                            <input class="form-button" type="submit" value="<fmt:message key="general.method.label.upload"/>" />
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <div id="main-body-content-separator"></div>
    </div>

<script>
    function launchDesigner(){
        <%
            String designerwebBaseUrl = "http://" + pageContext.getRequest().getServerName() + ":" + pageContext.getRequest().getServerPort();
            if(WorkflowUtil.getSystemSetupValue("designerwebBaseUrl") != null && WorkflowUtil.getSystemSetupValue("designerwebBaseUrl").length() > 0)
                designerwebBaseUrl = WorkflowUtil.getSystemSetupValue("designerwebBaseUrl");

            if(designerwebBaseUrl.endsWith("/"))
                designerwebBaseUrl = designerwebBaseUrl.substring(0, designerwebBaseUrl.length()-1);

            String locale = "en";
            if(WorkflowUtil.getSystemSetupValue("systemLocale") != null && WorkflowUtil.getSystemSetupValue("systemLocale").length() > 0)
                locale = WorkflowUtil.getSystemSetupValue("systemLocale");
        %>
                
        var path = 'http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}';
        document.location = '<%= designerwebBaseUrl %>/wflow-designerweb/designer/webstart.jsp?path=' + encodeURIComponent(path) + '&deploy=deploy&locale=<%= locale %>';
    }
</script>

<commons:footer />

