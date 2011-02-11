<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="java.io.File,org.joget.commons.util.SetupManager,org.joget.commons.util.HostManager"%>

<c:set var="isVirtualHostEnabled" value="<%= HostManager.isVirtualHostEnabled() %>"/>

<commons:header
    title="wflowAdmin.setup.list.label.title"
    helpTitle="wflowHelp.setup.list.title"
    help="wflowHelp.setup.list.content"
/>

<style>
    .row-content{
        display: block;
        float: none;
    }

    .form-input{
        width: 50%
    }

    .form-input input, .form-input textarea{
        width: 100%
    }

    .row-title{
        font-weight: bold;
    }
</style>

    <div id="main-body-content">

        <c:if test="${!isVirtualHostEnabled}">
        <div class="main-body-row">
            <span class="row-content">
                <div class="form-row">
                    <label for="profileList"><fmt:message key="wflowAdmin.setup.list.label.selectProfile"/></label>
                    <span class="form-input">
                        <select id="profileList">
                            <c:forEach items="${profileList}" var="profile">
                                <c:set var="selected"><c:if test="${profile == currentProfile}"> selected</c:if></c:set>
                                <option ${selected}>${profile}</option>
                            </c:forEach>
                        </select>
                        <button type="button" onclick="changeProfile()"><fmt:message key="wflowAdmin.setup.list.label.switchProfile"/></button>
                        <button type="button" onclick="deleteProfile()"><fmt:message key="wflowAdmin.setup.list.label.deleteProfile"/></button>
                    </span>
                </div>
            </span>
        </div>
        </c:if>

        <div id="settingList">
            <ul>
                <li class="selected"><a href="#generalSetup"><span><fmt:message key="wflowAdmin.setup.list.label.general"/></span></a></li>
                <c:if test="${!isVirtualHostEnabled}"><li><a href="#datasourceSetup"><span><fmt:message key="wflowAdmin.setup.list.label.datasource"/></span></a></li></c:if>
                <li><a href="#connectorSetup"><span><fmt:message key="wflowAdmin.setup.list.label.connector"/></span></a></li>
                <li><a href="#ntlmSetup"><span><fmt:message key="wflowAdmin.setup.list.label.ntlmSetting"/></span></a></li>
            </ul>
            <div>
                <div id="generalSetup">
                    <form method="post" action="${pageContext.request.contextPath}/web/settings/setup/submit">
                    <div class="main-body-content-subheader">
                        <span><fmt:message key="wflowAdmin.setup.list.header.uiSettings"/></span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="css"><fmt:message key="wflowAdmin.setup.list.label.css"/></label>
                                <span class="form-input">
                                    <input id="css" type="text" name="css" value="${settingMap['css']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> ${pageContext.request.contextPath}/css/new.css</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="customCss"><fmt:message key="wflowAdmin.setup.list.label.customCss"/></label>
                                <span class="form-input">
                                    <textarea rows="15" id="customCss" type="text" name="customCss">${settingMap['customCss']}</textarea>
                                </span>
                            </div>
                        </span>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/web/settings/setup/submit">
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="formCss"><fmt:message key="wflowAdmin.setup.list.label.formCss"/></label>
                                <span class="form-input">
                                    <input id="formCss" type="text" name="formCss" value="${settingMap['formCss']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> ${pageContext.request.contextPath}/lib/css/formbuilder.css</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="systemLocale"><fmt:message key="wflowAdmin.setup.list.label.systemLocale"/></label>
                                <span class="form-input">
                                    <select id="systemLocale" name="systemLocale">
                                        <option></option>
                                        <c:forEach var="locale" items="${localeList}">
                                            <c:set var="selected"><c:if test="${locale == settingMap['systemLocale']}"> selected</c:if></c:set>
                                            <option ${selected}>${locale}</option>
                                        </c:forEach>
                                    </select>
                                    <br>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> en_US</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="rightToLeft"><fmt:message key="wflowAdmin.setup.list.label.rightToLeft"/></label>
                                <c:set var="checked"></c:set>
                                <c:if test="${settingMap['rightToLeft'] == 'true'}">
                                    <c:set var="checked">checked</c:set>
                                </c:if>
                                <input type="checkbox" id="rightToLeft" name="rightToLeft" ${checked} />
                            </div>
                        </span>
                    </div>
                    <div class="main-body-content-subheader">
                        <span><fmt:message key="wflowAdmin.setup.list.header.timeSettings"/></span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="taskCountPollingInterval"><fmt:message key="wflowAdmin.setup.list.label.taskCountPollingInterval"/></label>
                                <span class="form-input">
                                    <input id="taskCountPollingInterval" type="text" name="taskCountPollingInterval" value="${settingMap['taskCountPollingInterval']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> 30</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="deadlineCheckerInterval"><fmt:message key="wflowAdmin.setup.list.label.deadlineCheckerInterval"/></label>
                                <span class="form-input">
                                    <input id="deadlineCheckerInterval" type="text" name="deadlineCheckerInterval" value="${settingMap['deadlineCheckerInterval']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> 0</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="welcomeMessageDelay"><fmt:message key="wflowAdmin.setup.list.label.welcomeMessageDelay"/></label>
                                <span class="form-input">
                                    <input id="welcomeMessageDelay" type="text" name="welcomeMessageDelay" value="${settingMap['welcomeMessageDelay']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> 3</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-content-subheader">
                        <span><fmt:message key="wflowAdmin.setup.list.header.saSettings"/></span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="masterLoginUsername"><fmt:message key="wflowAdmin.setup.list.label.masterLoginUsername"/></label>
                                <span class="form-input">
                                    <input id="masterLoginUsername" type="text" name="masterLoginUsername" value="${settingMap['masterLoginUsername']}"/>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="masterLoginPassword"><fmt:message key="wflowAdmin.setup.list.label.masterLoginPassword"/></label>
                                <span class="form-input">
                                    <input id="masterLoginPassword" type="password" name="masterLoginPassword" value="${settingMap['masterLoginPassword']}"/>
                                    <i><fmt:message key="wflowAdmin.setup.list.label.masterLoginHash"/><span id="masterLoginHash">-</span></i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="dataFileBasePath"><fmt:message key="wflowAdmin.setup.list.label.dataFileBasePath"/></label>
                                <span class="form-input">
                                    <input id="dataFileBasePath" type="text" name="dataFileBasePath" value="${settingMap['dataFileBasePath']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> <%= new java.io.File(SetupManager.getBaseDirectory()).getAbsolutePath() %></i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="designerwebBaseUrl"><fmt:message key="wflowAdmin.setup.list.label.designerwebBaseUrl"/></label>
                                <span class="form-input">
                                    <input id="designerwebBaseUrl" type="text" name="designerwebBaseUrl" value="${settingMap['designerwebBaseUrl']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> http://${pageContext.request.serverName}:${pageContext.request.serverPort}</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="deleteProcessOnCompletion"><fmt:message key="wflowAdmin.setup.list.label.deleteProcessOnCompletion"/></label>
                                <c:set var="checked"></c:set>
                                <c:if test="${settingMap['deleteProcessOnCompletion'] == 'true'}">
                                    <c:set var="checked">checked</c:set>
                                </c:if>
                                <input type="checkbox" id="deleteProcessOnCompletion" name="deleteProcessOnCompletion" ${checked} />
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="mediumWarningLevel"><fmt:message key="wflowAdmin.setup.list.label.mediumWarningLevel"/></label>
                                <span class="form-input">
                                    <input id="mediumWarningLevel" type="text" name="mediumWarningLevel" value="${settingMap['mediumWarningLevel']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> 20</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="criticalWarningLevel"><fmt:message key="wflowAdmin.setup.list.label.criticalWarningLevel"/></label>
                                <span class="form-input">
                                    <input id="criticalWarningLevel" type="text" name="criticalWarningLevel" value="${settingMap['criticalWarningLevel']}"/>
                                    <i><span><fmt:message key="wflowAdmin.setup.list.label.default"/></span> 50</i>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="form-buttons">
                        <input class="form-button" type="submit" value="<fmt:message key="general.method.label.submit"/>" />
                    </div>
                    </form>
                </div>

                <c:if test="${!isVirtualHostEnabled}">
                <div id="datasourceSetup">
                    <form id="datasourceForm" method="post" action="${pageContext.request.contextPath}/web/settings/setup/datasource/submit">
                    
                    <div class="main-body-row">
                        <div class="row-title"><fmt:message key="wflowAdmin.setup.list.label.directoryDatasource"/></div>
                        <span class="row-content">
                            <div class="form-row">
                                <label for="directoryDriver"><fmt:message key="wflowAdmin.setup.list.label.driverName"/></label>
                                <span class="form-input">
                                    <input id="directoryDriver" type="text" name="directoryDriver" value="${settingMap['directoryDriver']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="directoryUrl"><fmt:message key="wflowAdmin.setup.list.label.url"/></label>
                                <span class="form-input">
                                    <input id="directoryUrl" type="text" name="directoryUrl" value="${settingMap['directoryUrl']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="directoryUser"><fmt:message key="wflowAdmin.setup.list.label.user"/></label>
                                <span class="form-input">
                                    <input id="directoryUser" type="text" name="directoryUser" value="${settingMap['directoryUser']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="directoryPassword"><fmt:message key="wflowAdmin.setup.list.label.password"/></label>
                                <span class="form-input">
                                    <input id="directoryPassword" type="password" name="directoryPassword" value="${settingMap['directoryPassword']}"/>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <div class="row-title"><fmt:message key="wflowAdmin.setup.list.label.formDatasource"/></div>
                        <span class="row-content">
                            <div class="form-row">
                                <label for="formDriver"><fmt:message key="wflowAdmin.setup.list.label.driverName"/></label>
                                <span class="form-input">
                                    <input id="formDriver" type="text" name="formDriver" value="${settingMap['formDriver']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="formUrl"><fmt:message key="wflowAdmin.setup.list.label.url"/></label>
                                <span class="form-input">
                                    <input id="formUrl" type="text" name="formUrl" value="${settingMap['formUrl']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="formUser"><fmt:message key="wflowAdmin.setup.list.label.user"/></label>
                                <span class="form-input">
                                    <input id="formUser" type="text" name="formUser" value="${settingMap['formUser']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="formPassword"><fmt:message key="wflowAdmin.setup.list.label.password"/></label>
                                <span class="form-input">
                                    <input id="formPassword" type="password" name="formPassword" value="${settingMap['formPassword']}"/>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <div class="row-title"><fmt:message key="wflowAdmin.setup.list.label.workflowDatasource"/></div>
                        <span class="row-content">
                            <div class="form-row">
                                <label for="workflowDriver"><fmt:message key="wflowAdmin.setup.list.label.driverName"/></label>
                                <span class="form-input">
                                    <input id="workflowDriver" type="text" name="workflowDriver" value="${settingMap['workflowDriver']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="workflowUrl"><fmt:message key="wflowAdmin.setup.list.label.url"/></label>
                                <span class="form-input">
                                    <input id="workflowUrl" type="text" name="workflowUrl" value="${settingMap['workflowUrl']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="workflowUser"><fmt:message key="wflowAdmin.setup.list.label.user"/></label>
                                <span class="form-input">
                                    <input id="workflowUser" type="text" name="workflowUser" value="${settingMap['workflowUser']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="workflowPassword"><fmt:message key="wflowAdmin.setup.list.label.password"/></label>
                                <span class="form-input">
                                    <input id="workflowPassword" type="password" name="workflowPassword" value="${settingMap['workflowPassword']}"/>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <div class="row-title"><fmt:message key="wflowAdmin.setup.list.label.sharkDatasource"/></div>
                        <span class="row-content">
                            <div class="form-row">
                                <label for="sharkDriver"><fmt:message key="wflowAdmin.setup.list.label.driverName"/></label>
                                <span class="form-input">
                                    <input id="sharkDriver" type="text" name="sharkDriver" value="${settingMap['sharkDriver']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="sharkUrl"><fmt:message key="wflowAdmin.setup.list.label.url"/></label>
                                <span class="form-input">
                                    <input id="sharkUrl" type="text" name="sharkUrl" value="${settingMap['sharkUrl']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="sharkUser"><fmt:message key="wflowAdmin.setup.list.label.user"/></label>
                                <span class="form-input">
                                    <input id="sharkUser" type="text" name="sharkUser" value="${settingMap['sharkUser']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="sharkPassword"><fmt:message key="wflowAdmin.setup.list.label.password"/></label>
                                <span class="form-input">
                                    <input id="sharkPassword" type="password" name="sharkPassword" value="${settingMap['sharkPassword']}"/>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <div class="row-title"><fmt:message key="wflowAdmin.setup.list.label.reportDatasource"/></div>
                        <span class="row-content">
                            <div class="form-row">
                                <label for="reportDriver"><fmt:message key="wflowAdmin.setup.list.label.driverName"/></label>
                                <span class="form-input">
                                    <input id="reportDriver" type="text" name="reportDriver" value="${settingMap['reportDriver']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="reportUrl"><fmt:message key="wflowAdmin.setup.list.label.url"/></label>
                                <span class="form-input">
                                    <input id="reportUrl" type="text" name="reportUrl" value="${settingMap['reportUrl']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="reportUser"><fmt:message key="wflowAdmin.setup.list.label.user"/></label>
                                <span class="form-input">
                                    <input id="reportUser" type="text" name="reportUser" value="${settingMap['reportUser']}"/>
                                </span>
                            </div>
                            <div class="form-row">
                                <label for="reportPassword"><fmt:message key="wflowAdmin.setup.list.label.password"/></label>
                                <span class="form-input">
                                    <input id="reportPassword" type="password" name="reportPassword" value="${settingMap['reportPassword']}"/>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="main-body-row" id="testConnection" style="display: none">
                        <b>Testing Connections:</b>
                        <div id="directoryTestConnection">Testing <i>directory</i> datasource...<span class="connectionStatus"></span></div>
                        <div id="formTestConnection">Testing <i>form</i> datasource...<span class="connectionStatus"></span></div>
                        <div id="workflowTestConnection">Testing <i>workflow</i> datasource...<span class="connectionStatus"></span></div>
                        <div id="sharkTestConnection">Testing <i>shark</i> datasource...<span class="connectionStatus"></span></div>
                        <div id="reportTestConnection">Testing <i>report</i> datasource...<span class="connectionStatus"></span></div>
                    </div>
                    <div class="form-buttons">
                        <input class="form-button" id="saveDatasource" type="button" value="<fmt:message key="general.method.label.save"/>" onclick="submitDatasource()" />
                        <input class="form-button" id="saveDatasourceAsNew" type="button" value="<fmt:message key="wflowAdmin.setup.list.label.saveAsNewProfile"/>" onclick="submitDatasource(true)" />
                        <fmt:message key="wflowAdmin.setup.list.label.newProfileName"/>
                        <input id="newProfileName" type="text" name="profileName" />
                    </div>
                    </form>
                </div>
                </c:if>

                <div id="connectorSetup">
                    <div class="main-body-row">
                        <span class="row-content">
                                <fmt:message key="wflowAdmin.setup.list.label.directoryManagerImpl"/>

                                <c:set var="selected">
                                    <fmt:message key="wflowAdmin.setup.list.label.defaultPlugin"/>
                                </c:set>
                                <c:if test="${!empty settingMap['directoryManagerImpl']}">
                                    <c:set var="selected" value="${settingMap['directoryManagerImpl']}"/>
                                </c:if>

                                <dl>
                                    <dt><fmt:message key="wflowAdmin.setup.list.label.currentPluginName"/></dt>
                                    <dd>${selected}&nbsp;</dd>
                                    <c:if test="${!empty settingMap['directoryManagerImpl']}">
                                        <dt><fmt:message key="wflowAdmin.setup.list.label.currentPluginClassName"/></dt>
                                        <dd>${directoryManagerClassName}&nbsp;</dd>
                                        <c:if test="${directoryManagerConfigError}">
                                            <dt>&nbsp;</dt>
                                            <dd><fmt:message key="wflowAdmin.setup.list.label.currentPluginConfigError"/></dd>
                                        </c:if>
                                    </c:if>
                                    <dt>&nbsp;</dt>
                                    <dd>
                                        <c:if test="${!empty settingMap['directoryManagerImpl']}">
                                            <button type="button" class="smallbutton" onclick="removeDirectoryManagerImpl()"><fmt:message key="wflowAdmin.setup.list.label.removePlugin"/></button>
                                            <button type="button" class="smallbutton" onclick="configDirectoryManagerImpl('${settingMap['directoryManagerImpl']}')"><fmt:message key="wflowAdmin.setup.list.label.configPlugin"/></button>
                                        </c:if>
                                    </dd>
                                </dl>
                        </span>
                    </div>
                    <div class="main-body-row">
                        <span class="row-content">
                                <dl>
                                    <dt><fmt:message key="wflowAdmin.setup.list.label.selectPlugin"/></dt>
                                    <dd>
                                        <c:if test="${!empty directoryManagerPluginList}">
                                            <select name="directoryManagerImpl" id="directoryManagerImpl">
                                                <c:forEach items="${directoryManagerPluginList}" var="plugin">
                                                    <option value="${plugin['class'].name}">${plugin.name} - ${plugin.version}</option>
                                                </c:forEach>
                                            </select>
                                            <div>
                                                <button type="button" class="smallbutton" onclick="selectDirectoryManagerImpl()"><fmt:message key="wflowAdmin.setup.list.label.selectPlugin"/></button>
                                            </div>
                                        </c:if>
                                        <c:if test="${empty directoryManagerPluginList}">
                                            <fmt:message key="wflowAdmin.setup.list.label.selectPluginNoPlugin"/>
                                        </c:if>
                                    </dd>
                                </dl>
                        </span>
                    </div>
                </div>

                <div id="ntlmSetup">
                    <form method="post" action="${pageContext.request.contextPath}/web/settings/setup/submit">
                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="enableNtlm"><fmt:message key="wflowAdmin.setup.list.label.enableNtlm"/></label>
                                <c:set var="checked"></c:set>
                                <c:if test="${settingMap['enableNtlm'] == 'true'}">
                                    <c:set var="checked">checked</c:set>
                                </c:if>
                                <input id="enableNtlm" type="checkbox" name="enableNtlm" ${checked}/>
                            </div>
                        </span>
                    </div>

                    <div class="main-body-row">
                        <span class="row-content">
                            <div class="form-row">
                                <label for="ntlmDefaultDomain"><fmt:message key="wflowAdmin.setup.list.label.ntlmDefaultDomain"/></label>
                                <span class="form-input">
                                    <input id="ntlmDefaultDomain" type="text" name="ntlmDefaultDomain" value="${settingMap['ntlmDefaultDomain']}"/>
                                </span>
                            </div>
                        </span>
                        <span class="row-content">
                            <div class="form-row">
                                <label for="ntlmDomainController"><fmt:message key="wflowAdmin.setup.list.label.ntlmDomainController"/></label>
                                <span class="form-input">
                                    <input id="ntlmDomainController" type="text" name="ntlmDomainController" value="${settingMap['ntlmDomainController']}"/>
                                </span>
                            </div>
                        </span>
                        <span class="row-content">
                            <div class="form-row">
                                <label for="ntlmNetbiosWins"><fmt:message key="wflowAdmin.setup.list.label.ntlmNetbiosWins"/></label>
                                <span class="form-input">
                                    <input id="ntlmNetbiosWins" type="text" name="ntlmNetbiosWins" value="${settingMap['ntlmNetbiosWins']}"/>
                                </span>
                            </div>
                        </span>
                    </div>
                    <div class="form-buttons">
                        <input class="form-button" type="submit" value="<fmt:message key="general.method.label.submit"/>" />
                    </div>
                    </form>
                </div>

            </div>
        </div>
    </div>

<script>
    var tabView = new TabView('settingList', 'top');
    tabView.init();
    <c:if test="${!empty param.tab}">
        tabView.select('#${param.tab}');
    </c:if>

    //masterLoginHash
    var loginHashDeliminator = '<%= org.joget.directory.model.User.LOGIN_HASH_DELIMINATOR %>';
    if($('#masterLoginPassword').val() != '' && $('#masterLoginUsername').val() != ''){
        $('#masterLoginHash').text($.md5($('#masterLoginUsername').val() + loginHashDeliminator + $('#masterLoginPassword').val()));
    }
    $('#masterLoginUsername, #masterLoginPassword').keyup(function(){
        if($('#masterLoginPassword').val() != '' && $('#masterLoginUsername').val() != ''){
            $('#masterLoginHash').text($.md5($('#masterLoginUsername').val() + loginHashDeliminator + $('#masterLoginPassword').val()));
        }else{
            $('#masterLoginHash').text("-");
        }
    });

    var profileList= [];
    <c:forEach items="${profileList}" var="profile">
        profileList.push('${profile}');
    </c:forEach>

    var datasources = ['directory', 'form', 'workflow', 'shark', 'report'];
    function submitDatasource(asNewProfile){
        var connectionCount = 0;

        $('#saveDatasource').attr('disabled', 'disabled');
        $('#saveDatasourceAsNew').attr('disabled', 'disabled');

        var success = new Array();
        for(i in datasources)
            success[datasources[i]] = false;
        
        $('#testConnection').show();

        for(i in datasources){
            var testUrl = "${pageContext.request.contextPath}/web/json/workflow/testConnection";
            var testCallback = {
                success : function(o){
                    connectionCount++;
                    
                    var obj = eval('(' + o + ')');
                    if(obj.success == true){
                        $('#testConnection #' + obj.datasource + 'TestConnection .connectionStatus').html('<span class="connection-ok"><fmt:message key="wflowAdmin.setup.list.label.connectionOk"/></span>');
                        success[obj.datasource] = true;

                        //check if all success
                        var allSuccess = true;
                        for(key in success){
                            if(success[key] == false){
                                allSuccess = false;
                                break;
                            }
                        }

                        if(allSuccess && connectionCount == datasources.length){
                            $('#saveDatasource').removeAttr('disabled');
                            $('#saveDatasourceAsNew').removeAttr('disabled');

                            if(asNewProfile && asNewProfile == true)
                                saveAsNewProfile();
                            else
                                $('#datasourceForm').submit();
                        }
                    }else{
                        $('#testConnection #' + obj.datasource + 'TestConnection .connectionStatus').html('<span class="connection-fail"><fmt:message key="wflowAdmin.setup.list.label.connectionFail"/></span>');
                        $('#saveDatasource').removeAttr('disabled');
                        $('#saveDatasourceAsNew').removeAttr('disabled');
                    }
                }
            };
            var img = '<img src="${pageContext.request.contextPath}/images/new/loading.gif">';
            $('#testConnection #' + datasources[i] + 'TestConnection .connectionStatus').html(img);

            var driver   = $('#' + datasources[i] + 'Driver').val();
            var url      = $('#' + datasources[i] + 'Url').val();
            var user     = $('#' + datasources[i] + 'User').val();
            var password = $('#' + datasources[i] + 'Password').val();
            var testParam = "datasource=" + datasources[i] + "&driver=" + driver + "&url=" + url + "&user=" + user + "&password=" + password;

            ConnectionManager.post(testUrl, testCallback, testParam);
        }
    }
    
    var callback = {
        success: function(){
            //get current selected tab
            var selectedTabId = $('#settingList .ui-tabs-selected a').attr('href');
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

    function arrayToObject(array){
        var obj = {};
        for(var i=0; i<array.length; i++){
            obj[array[i]]='';
        }
        return obj;
    }

    function changeProfile(){
        if(confirm("<fmt:message key="wflowAdmin.setup.list.label.switchProfileConfirm"/>")) {
            var param = "profileName=" + $('#profileList').val();
            ConnectionManager.post("${pageContext.request.contextPath}/web/settings/setup/profile/change", callback, param);
        }
    }

    function deleteProfile(){
        if(confirm("<fmt:message key="wflowAdmin.setup.list.label.deleteProfileConfirm"/>")) {
            var currentProfile = '${currentProfile}';
            if($('#profileList').val() == currentProfile)
                alert("<fmt:message key="wflowAdmin.setup.list.label.deleteProfileInvalid"/>")
            else{
                var param = "profileName=" + $('#profileList').val();
                ConnectionManager.post("${pageContext.request.contextPath}/web/settings/setup/profile/delete", callback, param);
            }
        }
    }
    
    function saveAsNewProfile(){
        if(confirm("<fmt:message key="wflowAdmin.setup.list.label.saveAsProfileConfirm"/>")) {
            var newProfileName = $('#newProfileName').val();
            if(!/^[a-zA-Z0-9]+[a-zA-Z0-9 ]*$/.test(newProfileName)){
                alert('<fmt:message key="wflowAdmin.setup.list.label.saveAsProfileInvalid"/>');
                $('#newProfileName').focus();
            }else if(newProfileName in arrayToObject(profileList)){
                alert('<fmt:message key="wflowAdmin.setup.list.label.saveAsProfileExist"/>');
                $('#newProfileName').focus();
            }else{
                var param = $('#datasourceForm').serialize();
                ConnectionManager.post("${pageContext.request.contextPath}/web/settings/setup/profile/create", callback, param);
            }
        }
    }

    <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/settings/setup/directoryManagerImpl/config"/>

    function selectDirectoryManagerImpl(){
        popupDialog.src = "${pageContext.request.contextPath}/web/settings/setup/directoryManagerImpl/config?directoryManagerImpl=" + $('#directoryManagerImpl').val();
        popupDialog.init();
    }

    function configDirectoryManagerImpl(pluginName){
        popupDialog.src = "${pageContext.request.contextPath}/web/settings/setup/directoryManagerImpl/config?directoryManagerImpl=" + pluginName;
        popupDialog.init();
    }

    function removeDirectoryManagerImpl(){
        if(confirm("<fmt:message key="wflowAdmin.setup.list.label.removePluginConfirm"/>")) {
            ConnectionManager.post("${pageContext.request.contextPath}/web/settings/setup/directoryManagerImpl/remove", callback, null);
        }
    }
</script>

<commons:footer />