<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<jsp:useBean id="selectedMap" class="java.util.HashMap"/>
<c:set var="pathInfo" value="${requestScope['javax.servlet.forward.path_info']}" />
<c:set target="${selectedMap}" property="home" value="${fn:startsWith(pathInfo,'/client') ? 'active-' : ''}" />
<c:set target="${selectedMap}" property="processes" value="${fn:startsWith(pathInfo,'/admin') || fn:startsWith(pathInfo,'/form') ? 'active-' : ''}" />
<c:set target="${selectedMap}" property="monitoring" value="${fn:startsWith(pathInfo,'/monitoring') ? 'active-' : ''}" />
<c:set target="${selectedMap}" property="users" value="${fn:startsWith(pathInfo,'/directory') ? 'active-' : ''}" />
<c:set target="${selectedMap}" property="settings" value="${fn:startsWith(pathInfo,'/settings') ? 'active-' : ''}" />
<c:set target="${selectedMap}" property="help" value="${fn:startsWith(pathInfo,'/help') ? 'active-' : ''}" />

<c:set target="${selectedMap}" property="inbox" value="${fn:startsWith(pathInfo,'/client/assignment/inbox') ? 'active-' : ''}" />
<c:set target="${selectedMap}" property="run" value="${fn:startsWith(pathInfo,'/client/process/list') ? 'active-' : ''}" />
<c:set target="${selectedMap}" property="history" value="${fn:startsWith(pathInfo,'/client/assignment/history') ? 'active-' : ''}" />

<%
    String directoryManagerImpl = WorkflowUtil.getSystemSetupValue("directoryManagerImpl");
    pageContext.setAttribute("directoryManagerImpl", directoryManagerImpl);

    String taskCountPollingInterval = "30";
    String temp = WorkflowUtil.getSystemSetupValue("taskCountPollingInterval");
    if(temp != null && temp.trim().length() > 0){
        taskCountPollingInterval = temp;
    }
    pageContext.setAttribute("taskCountPollingInterval", taskCountPollingInterval);
%>

    <c:if test="${param.anonymous == 'false'}">
        <c:if test="${param.admin == 'true'}">

        <ul id="nav">
            <li class="${selectedMap['home']}home">
                <a class="home" style="overflow: hidden;">
                    <div class="menu-title"><fmt:message key="general.tab.home.title"/></div>
                    <div class="menu-description">
                        <fmt:message key="general.tab.home.description"/>
                    </div>
                </a>
                <div class="dropdown">
                    <div class="top_home"></div>
                    <ul>
                        <li><a class="sec-home01" href="${pageContext.request.contextPath}/web/client/assignment/inbox"><span class="menu-item"><fmt:message key="general.tab.home.inbox"/></span> (<span id="inbox">0</span>)<br /><em><fmt:message key="general.tab.home.inbox.description"/></em></a></li>
                        <li><a class="sec-home02" href="${pageContext.request.contextPath}/web/client/process/list"><span class="menu-item"><fmt:message key="general.tab.home.startProcess"/></span> <br /><em><fmt:message key="general.tab.home.startProcess.description"/></em></a></li>
                        <li><a class="sec-home03" href="${pageContext.request.contextPath}/web/client/assignment/history"><span class="menu-item"><fmt:message key="general.tab.home.taskHistory"/></span> <br /><em><fmt:message key="general.tab.home.taskHistory.description"/></em></a></li>
                    </ul>
                    <div class="bottom"></div>
                </div>
            </li>
            <li class="${selectedMap['processes']}design">
                <a class="design">
                    <div class="menu-title"><fmt:message key="general.tab.designProcess.title"/></div>
                    <div class="menu-description">
                        <fmt:message key="general.tab.designProcess.description"/>
                    </div>
                </a>
                <div class="dropdown">
                    <div class="top_design"></div>
                    <ul>
                        <li><a class="sec-design01" href="${pageContext.request.contextPath}/web/admin/package/upload"><span class="menu-item"><fmt:message key="general.tab.designProcess.newProcess"/></span><br /><em><fmt:message key="general.tab.designProcess.newProcess.description"/></em></a></li>
                        <li><a class="sec-design02" href="${pageContext.request.contextPath}/web/admin/process/configure/list"><span class="menu-item"><fmt:message key="general.tab.designProcess.updateProcess"/></span><br /><em><fmt:message key="general.tab.designProcess.updateProcess.description"/></em></a></li>
                        <%--<li><a class="sec-design03" href="${pageContext.request.contextPath}/web/admin/process/configure/import"><span class="menu-item"><fmt:message key="general.tab.designProcess.importPackage"/></span><br /><em><fmt:message key="general.tab.designProcess.importPackage.description"/></em></a></li>--%>
                        <li><a class="sec-design04" href="${pageContext.request.contextPath}/web/admin/form/category/list"><span class="menu-item"><fmt:message key="general.tab.designProcess.form"/></span><br /><em><fmt:message key="general.tab.designProcess.form.description"/></em></a></li>
                        <li><a class="sec-design05" href="${pageContext.request.contextPath}/web/admin/userview/list"><span class="menu-item"><fmt:message key="general.tab.designProcess.userview"/></span><br /><em><fmt:message key="general.tab.designProcess.userview.description"/></em></a></li>
                    </ul>
                    <div class="bottom"></div>
                </div>
            </li>
            <li class="${selectedMap['monitoring']}monitor">
                <a class="monitor">
                    <div class="menu-title"><fmt:message key="general.tab.monitorProcess.title"/></div>
                    <div class="menu-description">
                        <fmt:message key="general.tab.monitorProcess.description"/>
                    </div>
                </a>
                <div class="dropdown">
                    <div class="top_monitor"></div>
                    <ul>
                        <li><a class="sec-monitor01" href="${pageContext.request.contextPath}/web/monitoring/running/process/list"><span class="menu-item"><fmt:message key="general.tab.monitorProcess.runningProcess"/></span><br /><em><fmt:message key="general.tab.monitorProcess.runningProcess.description"/></em></a></li>
                        <li><a class="sec-monitor02" href="${pageContext.request.contextPath}/web/monitoring/completed/process/list"><span class="menu-item"><fmt:message key="general.tab.monitorProcess.completedProcess"/></span><br /><em><fmt:message key="general.tab.monitorProcess.completedProcess.description"/></em></a></li>
                        <li><a class="sec-monitor03" href="${pageContext.request.contextPath}/web/monitoring/audittrail/list"><span class="menu-item"><fmt:message key="general.tab.monitorProcess.auditTrail"/></span><br /><em><fmt:message key="general.tab.monitorProcess.auditTrail.description"/></em></a></li>
                        <li><a class="sec-monitor04" href="${pageContext.request.contextPath}/web/monitoring/workflow/sla/list"><span class="menu-item"><fmt:message key="general.tab.monitorProcess.sla"/></span><br /><em><fmt:message key="general.tab.monitorProcess.sla.description"/></em></a></li>
                    </ul>
                    <div class="bottom"></div>
                </div>
            </li>
            <li class="${selectedMap['users']}user">
                <c:set var="classSuffix"></c:set>
                <c:set var="inlineStyle"></c:set>
                <c:set var="userDesc">
                    <fmt:message key="general.tab.setupUser.description"/>
                </c:set>
                <c:if test="${!empty directoryManagerImpl}">
                    <c:set var="userDesc"><fmt:message key="general.tab.setupUser.descriptionDisabled"/></c:set>
                    <c:set var="classSuffix">-disabled disabled</c:set>
                    <c:set var="inlineStyle">style="display: none"</c:set>
                </c:if>

                <a class="user${classSuffix}">
                    <div class="menu-title"><fmt:message key="general.tab.setupUser.title"/></div>
                    <div class="menu-description">
                        ${userDesc}
                    </div>
                </a>
                <div class="dropdown${classSuffix}" ${inlineStyle}>
                    <div class="top_user"></div>
                    <ul>
                        <li><a class="sec-user01" href="${pageContext.request.contextPath}/web/directory/admin/organization/list"><span class="menu-item"><fmt:message key="general.tab.setupUser.orgChart"/></span><br /><em><fmt:message key="general.tab.setupUser.orgChart.description"/></em></a></li>
                        <li><a class="sec-user02" href="${pageContext.request.contextPath}/web/directory/admin/group/list"><span class="menu-item"><fmt:message key="general.tab.setupUser.group"/></span><br /><em><fmt:message key="general.tab.setupUser.group.description"/></em></a></li>
                        <li><a class="sec-user03" href="${pageContext.request.contextPath}/web/directory/admin/user/list"><span class="menu-item"><fmt:message key="general.tab.setupUser.user"/></span><br /><em><fmt:message key="general.tab.setupUser.user.description"/></em></a></li>
                    </ul>
                    <div class="bottom"></div>
                </div>
            </li>
            <li class="${selectedMap['settings']}setting">
                <a class="setting">
                    <div class="menu-title"><fmt:message key="general.tab.setting.title"/></div>
                    <div class="menu-description">
                        <fmt:message key="general.tab.setting.description"/>
                    </div>
                </a>
                <div class="dropdown last">
                    <div class="top_setting"></div>
                    <ul>
                        <li><a class="sec-setting01" href="${pageContext.request.contextPath}/web/settings/setup/list"><span class="menu-item"><fmt:message key="general.tab.setting.systemSetup"/></span><br /><em><fmt:message key="general.tab.setting.systemSetup.description"/></em></a></li>
                        <li><a class="sec-setting02" href="${pageContext.request.contextPath}/web/settings/plugin/list"><span class="menu-item"><fmt:message key="general.tab.setting.plugin"/></span><br /><em><fmt:message key="general.tab.setting.plugin.description"/></em></a></li>
                        <li><a class="sec-setting03" href="${pageContext.request.contextPath}/web/settings/form/variable/list"><span class="menu-item"><fmt:message key="general.tab.setting.formVariable"/></span><br /><em><fmt:message key="general.tab.setting.formVariable.description"/></em></a></li>
                        <li><a class="sec-setting04" href="${pageContext.request.contextPath}/web/settings/resource/message/list"><span class="menu-item"><fmt:message key="general.tab.setting.message"/></span><br /><em><fmt:message key="general.tab.setting.message.description"/></em></a></li>
                        <li><a class="sec-setting05" href="${pageContext.request.contextPath}/web/settings/version"><span class="menu-item"><fmt:message key="general.tab.setting.version"/></span><br /><em><fmt:message key="general.tab.setting.version.description"/></em></a></li>
                    </ul>
                    <div class="bottom"></div>
                </div>
            </li>
            
        </ul>
        </c:if>
        <c:if test="${param.admin == 'false'}">
            <ul id="nav">
                <li class="${selectedMap['inbox']}inbox">
                    <a class="inbox" href="${pageContext.request.contextPath}/web/client/assignment/inbox">
                        <div class="menu-title"><fmt:message key="general.tab.home.inbox"/></div>
                    </a>
                </li>
                <li class="${selectedMap['run']}run">
                    <a class="run" href="${pageContext.request.contextPath}/web/client/process/list">
                        <div class="menu-title"><fmt:message key="general.tab.home.startProcess"/></div>
                    </a>
                </li>
                <li class="${selectedMap['history']}history">
                    <a class="history" href="${pageContext.request.contextPath}/web/client/assignment/history">
                        <div class="menu-title"><fmt:message key="general.tab.home.taskHistory"/></div>
                    </a>
                </li>
            </ul>
        </c:if>

        <script>
            <!--
            updatePendingTaskCount();

            var taskCountPollingInterval = ${taskCountPollingInterval} * 1000;

            var pendingTaskCountTimer = null;
            function updatePendingTaskCount(){
                var text = "<fmt:message key="general.tab.home.inbox"/>";
                var path = "${pageContext.request.contextPath}/web/json/workflow/assignment/list/pending/count?rnd=" + new Date().valueOf().toString();

                $.get(path, function(response){
                    var obj = eval("(" + response + ")");
                    $("#inbox").text(obj.total);
                })
            }

            if(taskCountPollingInterval > 0){
                pendingTaskCountTimer  = setInterval("updatePendingTaskCount()", taskCountPollingInterval);
            }

            //-->
        </script>

    </c:if>
