<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<%
    String directoryManagerImpl = WorkflowUtil.getSystemSetupValue("directoryManagerImpl");
%>
<c:set var="directoryManagerImpl" value="<%= directoryManagerImpl %>"/>

<commons:header
    title="wflowAdmin.processConfiguration.view.label.title"
    path1="${pageContext.request.contextPath}/web/admin/process/configure/view/${process.encodedId}"
    name1="wflowAdmin.main.body.path.processConfiguration.view"
    helpTitle="wflowHelp.process.configure.view.title"
    help="wflowHelp.process.configure.view.content"
/>

    <div id="main-body-content">
        <div id="xpdlThumbnailLoading">
            <img src="${pageContext.request.contextPath}/images/new/loading.gif">
            <fmt:message key="wflowAdmin.processConfiguration.view.label.xpdlThumbnailLoading"/>
        </div>
        <a id="xpdlThumbnail" href="${pageContext.request.contextPath}/web/images/xpdl/${process.encodedId}" target="_blank"></a>
        <dl>
            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.packageName"/></dt>
            <dd>${process.packageName}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.processName"/></dt>
            <dd>${process.name}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.version"/></dt>
            <dd>${process.version}&nbsp;</dd>

        </dl>
        <div id="advancedView" style="display: none">
            <dl>
                <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.packageId"/></dt>
                <dd>${process.packageId}&nbsp;</dd>
                <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.processDefId"/></dt>
                <dd>${process.id}&nbsp;</dd>
                <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.description"/></dt>
                <dd>${process.description}&nbsp;</dd>
                <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.category"/></dt>
                <dd>${process.category}&nbsp;</dd>
                <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.latest"/></dt>
                <dd>${process.latest}&nbsp;</dd>
                <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.linkToRunProcess"/></dt>
                <dd>${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/client/process/start/${fn:replace(process.id, '#', ':')}</dd>
            </dl>
        </div>
        <div class="form-buttons">
            <a id="showAdvancedInfo" onclick="showAdvancedInfo()"><fmt:message key="wflowAdmin.processConfiguration.view.label.showAdditionalInfo"/></a>
            <a style="display: none" id="hideAdvancedInfo" onclick="hideAdvancedInfo()"><fmt:message key="wflowAdmin.processConfiguration.view.label.hideAdditionalInfo"/></a>
        </div>
        <div class="form-buttons">
            <button onclick="runProcess()"><fmt:message key="wflowAdmin.processConfiguration.view.label.startProcess"/></button>
            <button onclick="launchDesigner()"><fmt:message key="wflowAdmin.processConfiguration.view.label.launchDesigner"/></button>
            <button onclick="updateProcess()"><fmt:message key="wflowAdmin.processConfiguration.view.label.updateProcess"/></button>
            <button onclick="exportPackage()"><fmt:message key="wflowAdmin.processConfiguration.view.label.exportPackage"/></button>
            <button onclick="deleteProcess()"><fmt:message key="wflowAdmin.processConfiguration.view.label.deleteProcess"/></button>
        </div>


        <div id="main-body-content-subheader">
            <fmt:message key="wflowAdmin.processConfiguration.view.label.processDetail"/>
        </div>

        <div id="processTabView">
            <ul>
                <li class="selected"><a href="#participantList"><span><fmt:message key="wflowAdmin.processConfiguration.view.label.participantList"/></span></a></li>
                <li><a href="#activityList"><span><fmt:message key="wflowAdmin.processConfiguration.view.label.activityList"/></span></a></li>
                <li><a href="#variableList"><span><fmt:message key="wflowAdmin.processConfiguration.view.label.variableList"/></span></a></li>
            </ul>
            <div>

                <div id="participantList">
                    <div class="tabSummary"><fmt:message key="wflowAdmin.processConfiguration.view.summary.participantList"/></div>
                    <c:forEach var="participant" items="${participantList}" varStatus="rowCounter">
                        <c:choose>
                            <c:when test="${rowCounter.count % 2 == 0}">
                                <c:set var="rowStyle" scope="page" value="even"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="rowStyle" scope="page" value="odd"/>
                            </c:otherwise>
                        </c:choose>
                        <div class="main-body-row ${rowStyle}">
                            <span class="row-content" helpTitle="|||Id: ${participant.id}">
                                ${participant.name}
                                <c:if test="${participant.packageLevel}">
                                <fmt:message key="wflowAdmin.processConfiguration.view.label.participantPackageLevel"/>
                                </c:if>
                            </span>
                            <span class="row-button">
                                <input type="button" value="<fmt:message key="wflowAdmin.processConfiguration.view.label.addEditParticipantMapping"/>" onclick="addEditUser('${participant.id}')"/>
                            </span>
                            <div style="clear: both; padding-left: 1em; padding-top: 0.5em;">
                                <div id="participant_${participant.id}" style="padding-left: 1em; padding-top: 0.5em;">
                                    <c:set var="mappedList" value="${participantMap[participant.id]}"/>
                                    <c:set var="isPlugin" value="false"/>
                                    <c:forEach var="x" items="${mappedList}">
                                        <dl>
                                        <% Object obj = pageContext.getAttribute("x"); %>
                                        <c:set var="isArrayList" value="<%= obj instanceof java.util.ArrayList %>"/>
                                        <c:choose>
                                            <c:when test="${isArrayList}">
                                                <c:choose>
                                                    <c:when test="${x[0]['class'].simpleName == 'Group'}">

                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd>${x[0]['class'].simpleName}&nbsp;</dd>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.value"/></dt>
                                                            <dd>
                                                            <c:forEach var="y" items="${x}" varStatus="count">
                                                                <span class="participant-remove">
                                                                    <a onClick="participantRemoveMappingSingle($(this).parent(),'${participant.id}','${y.id}');"> <img src="${pageContext.request.contextPath}/images/joget/cross-circle.png"/></a>
                                                                    <c:choose>
                                                                        <c:when test="${!empty directoryManagerImpl}">
                                                                            ${y.name}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="${pageContext.request.contextPath}/web/directory/admin/group/view/${y.id}">${y.name}</a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </c:forEach>
                                                            </dd>

                                                    </c:when>
                                                    <c:when test="${x[0]['class'].simpleName == 'User'}">
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd>${x[0]['class'].simpleName}&nbsp;</dd>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.value"/></dt>
                                                            <dd>
                                                            <c:forEach var="y" items="${x}" varStatus="count">
                                                                <span class="participant-remove">
                                                                    <a onClick="participantRemoveMappingSingle($(this).parent(),'${participant.id}','${y.id}');"> <img src="${pageContext.request.contextPath}/images/joget/cross-circle.png"/></a>
                                                                    <c:choose>
                                                                        <c:when test="${!empty directoryManagerImpl}">
                                                                            ${y.username}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="${pageContext.request.contextPath}/web/directory/admin/user/view/${y.id}">${y.username}</a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </c:forEach>
                                                            </dd>
                                                    </c:when>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="simpleClassName" value="${x['class'].simpleName}" />
                                                <c:if test="${!empty simpleClassName}">
                                                    <c:set var="cglibIndex" value="<%= pageContext.getAttribute(\"simpleClassName\").toString().indexOf(\"$$\") %>" />
                                                    <c:if test="${cglibIndex > 0}">
                                                        <c:set var="simpleClassName" value="<%= pageContext.getAttribute(\"simpleClassName\").toString().substring(0, Integer.parseInt(pageContext.getAttribute(\"cglibIndex\").toString())) %>"/>
                                                    </c:if>
                                                </c:if>

                                                <c:choose>
                                                    <c:when test="${simpleClassName == 'Group'}">
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd>${simpleClassName}&nbsp;</dd>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.value"/></dt>
                                                            <dd>
                                                                <c:choose>
                                                                    <c:when test="${!empty directoryManagerImpl}">
                                                                        ${x.name}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${pageContext.request.contextPath}/web/directory/admin/group/view/${x.id}">${x.name}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                    </c:when>
                                                    <c:when test="${simpleClassName == 'Department'}">
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd>${simpleClassName}&nbsp;</dd>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.value"/></dt>
                                                            <dd>
                                                                <c:choose>
                                                                    <c:when test="${!empty directoryManagerImpl}">
                                                                        ${x.name}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${pageContext.request.contextPath}/web/directory/admin/organization/department/view/${x.id}">${x.name}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                    </c:when>
                                                    <c:when test="${simpleClassName == 'User'}">
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd>${simpleClassName}&nbsp;</dd>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.value"/></dt>
                                                            <dd>
                                                                <c:choose>
                                                                    <c:when test="${!empty directoryManagerImpl}">
                                                                        ${x.username}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${pageContext.request.contextPath}/web/directory/admin/user/view/${x.id}">${x.username}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                    </c:when>
                                                    <c:when test="${simpleClassName == 'Grade'}">
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd>${simpleClassName}&nbsp;</dd>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.value"/></dt>
                                                            <dd>
                                                                <c:choose>
                                                                    <c:when test="${!empty directoryManagerImpl}">
                                                                        ${x.name}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <a href="${pageContext.request.contextPath}/web/directory/admin/grade/view/${x.id}">${x.name}</a>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </dd>
                                                    </c:when>
                                                    <c:when test="${simpleClassName == 'String'}">
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd>${x}&nbsp;</dd>
                                                    </c:when>
                                                    <c:otherwise>
                                                            <c:set var="isPlugin" value="true"/>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.type"/></dt>
                                                            <dd><fmt:message key="wflowAdmin.processConfiguration.view.label.plugin"/></dd>
                                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.pluginName"/></dt>
                                                            <dd>${x.name} <fmt:message key="wflowAdmin.processConfiguration.view.label.ver"/> ${x.version}&nbsp;</dd>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                            <dt>&nbsp;</dt>
                                            <dd>
                                                <div>
                                                <input type="button" class="smallbutton" value="<fmt:message key="wflowAdmin.participantMapping.view.label.removeMapping"/>" onclick="participantRemoveMapping('${participant.id}')"/>
                                                <c:if test="${isPlugin == true}">
                                                    <input type="button" class="smallbutton" value="<fmt:message key="wflowAdmin.participantMapping.view.label.configurePlugin"/>" onclick="participantConfigurePlugin('${participant.id}')"/>
                                                </c:if>
                                                </div>
                                            </dd>
                                        </dl>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div id="activityList" style="height_: 300px; overflow-y_: scroll">
                    <div class="tabSummary"><fmt:message key="wflowAdmin.processConfiguration.view.summary.activityList"/></div>
                    <c:forEach var="activity" items="${activityList}" varStatus="rowCounter">
                        <c:choose>
                            <c:when test="${rowCounter.count % 2 == 0}">
                                <c:set var="rowStyle" scope="page" value="even"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="rowStyle" scope="page" value="odd"/>
                            </c:otherwise>
                        </c:choose>

                        <div class="main-body-row ${rowStyle}" style="min-height: 50px">
                            <span class="row-content" helpTitle="|||Id: ${activity.id}">
                                <c:set var="activityDisplayName" value="${activity.name}"/>
                                <c:if test="${empty activity.name}">
                                    <c:set var="activityDisplayName" value="${activity.id}"/>
                                </c:if>
                                    ${activityDisplayName} <c:if test="${activity.type ne 'normal'}">(${activity.type})</c:if> 
                            </span>
                            <span class="row-button">

                                <c:choose>
                                    <c:when test="${activity.type == 'tool'}">
                                        <input type="button" value="<fmt:message key="wflowAdmin.processConfiguration.view.label.addEditPluginMapping"/>" onclick="addEditPlugin('${activity.id}')"/>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="button" value="<fmt:message key="wflowAdmin.processConfiguration.view.label.addEditFormMapping"/>" onclick="addEditForm('${activity.id}')"/>
                                    </c:otherwise>
                                </c:choose>

                            </span>
                            <div style="clear: both; padding-left: 1em; padding-top: 0.5em;">
                                <div id="activityForm_${activity.id}" style="padding-left: 1em; padding-top: 0.5em;">
                                    <c:set var="plugin" value="${pluginMap[activity.id]}"/>
                                    <c:if test="${plugin ne null}">
                                        <dl>
                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.pluginName"/></dt>
                                            <dd>${plugin.name}&nbsp;</dd>
                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.pluginVersion"/></dt>
                                            <dd>${plugin.version}&nbsp;</dd>
                                            <dt>&nbsp;</dt>
                                            <dd>
                                                <div>
                                                    <input type="button" class="smallbutton" value="<fmt:message key="wflowAdmin.activityAddPlugin.view.label.removePlugin"/>" onclick="activityRemovePlugin('${activity.id}')"/>
                                                    <input type="button" class="smallbutton" value="<fmt:message key="wflowAdmin.activityAddPlugin.view.label.configurePlugin"/>" onclick="activityConfigurePlugin('${activity.id}')"/>
                                                </div>
                                            </dd>
                                        </dl>
                                    </c:if>

                                    <c:set var="formList" value="${formMap[activity.id]}"/>
                                    <c:forEach var="form" items="${formList}">
                                        <% Object testForm = pageContext.getAttribute("form"); %>
                                        <c:set var="isFormArrayList" value="<%= testForm instanceof java.util.ArrayList %>"/>
                                        <c:if test="${!isFormArrayList}">
                                            <c:if test="${form['class'].simpleName == 'Form'}">
                                                <dl>
                                                    <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.formName"/></dt>
                                                    <dd><a href="${pageContext.request.contextPath}/web/admin/form/general/view/${form.id}">${form.name}</a></dd>
                                                    <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.formCategory"/></dt>
                                                    <dd><a href="${pageContext.request.contextPath}/web/admin/form/category/view/${form.category.id}">${form.category.name}</a></dd>
                                                    <dt>&nbsp;</dt>
                                                    <dd><div><input type="button" class="smallbutton" value="<fmt:message key="wflowAdmin.activityAddForm.view.label.removeMapping"/>" onclick="activityRemoveForm('${activity.id}')"/></div></dd>
                                                </dl>
                                            </c:if>
                                            <c:if test="${form['class'].simpleName == 'String'}">
                                                <dl>
                                                    <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.formExternal"/></dt>
                                                    <dd><a target="_blank" href="${form}">${form}</a></dd>
                                                    <dt>&nbsp;</dt>
                                                    <dd><div><input type="button" class="smallbutton" value="<fmt:message key="wflowAdmin.activityAddForm.view.label.removeMapping"/>" onclick="activityRemoveForm('${activity.id}')"/></div></dd>
                                                </dl>
                                            </c:if>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${activity.type != 'tool'}">
                                        <dl>
                                            <dt><fmt:message key="wflowAdmin.processConfiguration.view.label.showContinueAssignment"/></dt>
                                            <c:set var="showNext" value=""/>
                                            <c:if test="${!empty activitySetupList[activity.id] && activitySetupList[activity.id].continueNextAssignment == 1}">
                                                <c:set var="showNext" value="checked"/>
                                            </c:if>
                                            <dd><input type="checkbox" name="showNextAssigment" ${showNext} onchange="toggleContinueNextAssignment('${process.id}','${activity.id}', this)"></dd>
                                        </dl>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <div id="variableList">
                    <div class="tabSummary"><fmt:message key="wflowAdmin.processConfiguration.view.summary.variableList"/></div>
                    <c:forEach var="variable" items="${variableList}" varStatus="rowCounter">
                        <c:choose>
                            <c:when test="${rowCounter.count % 2 == 0}">
                                <c:set var="rowStyle" scope="page" value="even"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="rowStyle" scope="page" value="odd"/>
                            </c:otherwise>
                        </c:choose>

                        <div class="main-body-row ${rowStyle}" style="min-height: 50px">
                            <span class="row-content">
                                ${variable.id}<br>
                            </span>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    <div style="display:none"><div id="updateInformation">
        <div style="height: 100px; width: 500px; margin:0">
            <p>
                <fmt:message key="wflowAdmin.processConfiguration.view.msg.update.information"/>
            </p>
            <div style="text-align:center">
                <button onclick="goLatest()"><fmt:message key="general.method.label.ok"/></button>
                <button id="closeInfo"><fmt:message key="general.method.label.cancel"/></button>
            </div>
        </div>
    </div></div>

    <script>
        var image = new Image();
        image.src = "${pageContext.request.contextPath}/web/images/xpdl/thumbnail/${process.encodedId}?rnd=" + new Date().valueOf().toString();
        $(image).load(function(){
            $('#xpdlThumbnail').append(image);
            $('#xpdlThumbnailLoading').hide();
        });

        $(document).ready(function() {
            $('span.row-content[@helpTitle]').cluetip({
                    splitTitle: '|||',
                    showTitle: false,
                    arrows: true,
                    positionBy: 'mouse',
                    dropShadow: false,
                    hoverIntent: false,
                    sticky: true,
                    mouseOutClose: true,
                    closePosition: 'title'}
            );
        });

        var tabView = new TabView('processTabView', 'top');
        tabView.init();
        <c:if test="${!empty param.tab}">
            tabView.select('#${param.tab}');
        </c:if>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/form/edit/${form.id}"/>

        var reloadCallback = {
            success: function(){
                //get current selected tab
                var selectedTabId = $('#processTabView .ui-tabs-selected a').attr('href');
                selectedTabId = selectedTabId.replace('#', '');

                var urlQueryString = document.location.search;
                if(urlQueryString == ''){
                    document.location.href = document.location.href + "?tab=" + selectedTabId;
                }else{
                    if(urlQueryString.indexOf('tab') == -1){
                        document.location.href = document.location.href + "&tab=" + selectedTabId;
                    }else{
                        document.location.href = document.location.href.replace(urlQueryString, '') + "?tab=" + selectedTabId;
                    }
                }
            }
        }

        function closeDialog() {
            popupDialog.close();
        }

        function updateProcess(){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/process/configure/updateXpdl?packageId=${process.packageId}";
            popupDialog.init();
        }

        function exportPackage(){
            document.location = '${pageContext.request.contextPath}/web/admin/package/export/${process.encodedId}';
        }

        function deleteProcess(){
            if (confirm('<fmt:message key="wflowAdmin.processConfiguration.view.label.deleteProcess.confirm"/>')) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/admin/process/configure/list';
                    }
                }
                var request = ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/configure/remove', callback, 'packageId=${process.packageId}&version=${process.version}');
            }
        }

        function runProcess(){
            popupDialog.src = "${pageContext.request.contextPath}/web/client/process/view/${process.encodedId}";
            popupDialog.init();
        }

        function launchDesigner(){
            $("#updateInformation").dialog({modal:true, height:150, width:550, resizable:false, show: 'slide',overlay: {opacity: 0.5, background: "black"},zIndex: 15001});
            $("#closeInfo").click(function(){$("#updateInformation").dialog("close")});
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
            var url = "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/web/admin/process/xpdl/${process.encodedId}";
            var path = 'http://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}';
            document.location = '<%= designerwebBaseUrl %>/wflow-designerweb/designer/webstart.jsp?url=' + encodeURIComponent(url) + '&path=' + encodeURIComponent(path) + '&update=update&locale=<%= locale %>&username=${username}&hash=${loginHash}';
        }

        function goLatest(){
            var goLatestCallback = {
                    success : function(response) {
                        var process = eval('(' + response + ')');
                        document.location = '${pageContext.request.contextPath}/web/admin/process/configure/view/'+escape(process.encodedId);
                    }
            }

            ConnectionManager.get('${pageContext.request.contextPath}/web/json/workflow/process/latest/${process.encodedId}', goLatestCallback);
        }

        function addEditForm(activityId){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/process/activity/form/add?activityId=" + activityId + "&processId=${process.encodedId}&version=${process.version}";
            popupDialog.init();
        }

        function addEditPlugin(activityId){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/process/activity/plugin/add?activityId=" + activityId + "&processId=${process.encodedId}&version=${process.version}";
            popupDialog.init();
        }

        function addEditUser(participantId){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/process/participant/user/add?participantId=" + participantId + "&processId=${process.encodedId}&version=${process.version}";
            popupDialog.init();
            //document.location = "${pageContext.request.contextPath}/web/admin/process/participant/user/add?participantId=" + participantId + "&processId=${process.encodedId}&version=${process.version}";
        }

        function activityRemoveForm(activityId){
            if (confirm("<fmt:message key="wflowAdmin.processConfiguration.view.label.removeForm.confirm"/>")) {
                var params = "activityId=" + activityId + "&processId=${process.encodedId}&version=${process.version}";
                ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/activity/form/remove', reloadCallback, params);
            }
        }

        function activityRemovePlugin(activityId){
            if (confirm("<fmt:message key="wflowAdmin.processConfiguration.view.label.removePlugin.confirm"/>")) {
                var params = "activityId=" + activityId + "&processId=${process.encodedId}&version=${process.version}";
                ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/activity/plugin/remove', reloadCallback, params);
            }
        }

        function activityConfigurePlugin(activityId){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/process/activity/plugin/configure?activityId=" + activityId + "&processId=${process.encodedId}&version=${process.version}";
            popupDialog.init();
        }

        function participantRemoveMapping(participantId){
            if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.removeConfirm"/>")) {
                var params = "participantId=" + participantId + "&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}";
                ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/participant/user/remove', reloadCallback, params);
            }
        }

        function participantRemoveMappingSingle(obj, participantId, value){
            var removeItem = {
                    success : function(response) {
                        $(obj).hide('slow');
                        if($(obj).parent().find('.participant-remove:visible').length == 2){
                            $(obj).parent().find('.participant-remove:visible').find('img').remove();
                        }
                    }
            }
            if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.removeConfirm"/>")) {
                var params = "participantId=" + participantId + "&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}&value=" + value;
                ConnectionManager.post('${pageContext.request.contextPath}/web/admin/process/participant/user/removeSingle', removeItem, params);
            }
        }

        function participantConfigurePlugin(participantId){
            popupDialog.src = "${pageContext.request.contextPath}/web/admin/process/participant/user/plugin/config?participantId=" + participantId + "&packageId=${process.packageId}&processId=${process.encodedId}&version=${process.version}";
            popupDialog.init();
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

        function showXpdlImage(){
            popupDialog.src = "${pageContext.request.contextPath}/web/images/xpdl/${process.encodedId}";
            popupDialog.init();

        }

        function toggleContinueNextAssignment(processId, activityId, checkbox){
            var params = "activityId=" + activityId + "&processId=${process.encodedId}&showNextAssignment="+$(checkbox).attr('checked');
            ConnectionManager.post('${pageContext.request.contextPath}/web/process/configuration/activity/setup', null, params);
        }
    </script>
<commons:footer />
