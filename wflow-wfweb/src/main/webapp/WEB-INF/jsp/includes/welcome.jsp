<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<%
    String welcomeMessageDelay = "3";
    String temp = WorkflowUtil.getSystemSetupValue("welcomeMessageDelay");
    if(temp != null && temp.trim().length() > 0){
        welcomeMessageDelay = temp;
    }
    pageContext.setAttribute("welcomeMessageDelay", welcomeMessageDelay);
%>

        <div id="getting-started">
            <%--<div id="getting-started-container">--%>
                <iframe id="frame" src="http://www.joget.org/updates/welcome" frameborder="0">

                </iframe>

                <a href="http://www.joget.org/help?src=wmc" target="www.joget.org" id="link">
                    <div id="getting-started-title">
                        <img src="${pageContext.request.contextPath}/images/joget/icon_help_small.png"/>
                        <span><fmt:message key="general.login.label.gettingStarted" /></span>
                    </div>

                    <img id="getting-started-diagram" src="${pageContext.request.contextPath}/images/joget/diagram_help.png"/>
                </a>
            <%--</div>--%>
        </div>

        <div class="clear"></div>

        <script type="text/javascript">
            var delay = <%= welcomeMessageDelay %> * 1000;

            if(delay > 0){
                setTimeout(function() {
                    BubbleDialog.show($("#j_username"), $("#getting-started"), '-60', '0');
                }, delay);

                var image = new Image();
                image.src = "http://www.joget.org/images/welcome.png";
                $(image).load(function(){
                    $('#link').hide();
                    $('#frame').show();
                });
            }
        </script>