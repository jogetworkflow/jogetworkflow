<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil,org.joget.commons.util.HostManager"%>

<c:set var="isVirtualHostEnabled" value="<%= HostManager.isVirtualHostEnabled() %>"/>

<commons:header
    title="wflowAdmin.plugin.list.label.title"
    helpTitle="wflowHelp.plugin.list.title"
    help="wflowHelp.plugin.list.content"
/>

    <div id="main-body-content">
        <div id="main-body-content-filter">
            <form>
            <fmt:message key="wflowAdmin.plugin.list.label.typeFilter"/>
            <select onchange="location.href='?pluginType=' + this.options[this.selectedIndex].value">
                <option></option>
                <c:forEach items="${pluginTypeList}" var="pluginType">
                    <c:set var="selected"><c:if test="${pluginType == param.pluginType}"> selected</c:if></c:set>
                    <option value="${pluginType}" ${selected}>${pluginType}</option>
                </c:forEach>
            </select>
            </form>
        </div>

        <div id="main-body-content-filter">
            <fmt:message key="general.method.label.search"/> <input id="searchCondition" type="text" onkeyup="triggerSearchTimer()">
        </div>

        <form name="uninstallPlugin" action="${pageContext.request.contextPath}/web/settings/plugin/uninstall" method="POST" onsubmit="return uninstall()">
        <div id="pluginList" style="height: 400px; overflow-y:scroll">
            <c:forEach var="plugin" items="${sortedPluginList}" varStatus="rowCounter">
                <c:choose>
                    <c:when test="${rowCounter.count % 2 == 0}">
                        <c:set var="rowStyle" scope="page" value="even"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="rowStyle" scope="page" value="odd"/>
                    </c:otherwise>
                </c:choose>
                <div class="pluginRow main-body-row ${rowStyle}">
                    <span class="row-content">
                        <input type="checkbox" name="selectedPlugins" value="${sortedPluginList[plugin.key]['class'].name}"/>&nbsp;
                    </span>
                    <span class="row-content">
                        <div class="pluginName">${sortedPluginList[plugin.key].name}</div>
                        <div class="pluginDescription"><i>${sortedPluginList[plugin.key].description}</i></div>

                    </span>
                    <span class="row-button" style="text-align: right">
                        ver ${sortedPluginList[plugin.key].version}<br>
                        <%
                            java.util.Map.Entry ent = (java.util.Map.Entry) pageContext.getAttribute("plugin");
                            java.util.Map map = (java.util.Map) request.getAttribute("sortedPluginList");
                            org.joget.plugin.base.Plugin plugin = (org.joget.plugin.base.Plugin) map.get(ent.getKey());
                            if(plugin instanceof org.joget.plugin.base.AuditTrailPlugin){
                        %>
                        <input type="button" value="<fmt:message key="wflowAdmin.plugin.list.label.configurePlugin"/>" onclick="configurePlugin('${sortedPluginList[plugin.key]['class'].name}')"/>
                        <%  } else if (!(plugin instanceof org.joget.directory.model.service.DirectoryManagerPlugin)){ %>
                        <input type="button" value="<fmt:message key="wflowAdmin.plugin.list.label.configurePluginDefault"/>" onclick="configurePluginDefault('${sortedPluginList[plugin.key]['class'].name}')"/>
                        <%  } %>
                    </span>
                </div>
            </c:forEach>
            <div id="noPluginFound" style="display:none" class="pluginRow main-body-row ${rowStyle}">
                <span class="row-content">
                    <fmt:message key="wflowAdmin.plugin.list.label.noPluginFound"/>
                </span>
            </div>
        </div>

        <div class="form-buttons">
            <input id="reload-button" class="form-button" type="button" value="<fmt:message key="wflowAdmin.plugin.list.label.reloadPlugin"/>" onclick="reloadPlugin()"/>
            <c:if test="${!isVirtualHostEnabled}">
                <input class="form-button" type="submit" value="<fmt:message key="wflowAdmin.plugin.list.label.uninstall"/>"/>
                <input class="form-button" type="button" value="<fmt:message key="wflowAdmin.plugin.list.label.uploadPlugin"/>" onclick="uploadPlugin()"/>
            </c:if>
        </div>
        </form>
    </div>

    <script>
        <ui:popupdialog var="popupDialog" src=""/>
        function uploadPlugin(){
            popupDialog.src = "${pageContext.request.contextPath}/web/settings/plugin/upload";
            popupDialog.init();
        }

        function reloadPlugin(){
            var callback = {
                success: function(){
                    document.location.reload(true);
                }
            }
            ConnectionManager.post("${pageContext.request.contextPath}/web/settings/plugin/refresh", callback, "");
            $("#reload-button").attr("disabled", "disabled");
        }

        function uninstall(){
            if($('input[@type="checkbox"][@checked]').length > 0){
                if(confirm("<fmt:message key="wflowAdmin.plugin.list.label.uninstallConfirm"/>")) {
                    return true;
                }
                return false;
            }else
                return false;
        }

        var searchTimer = null;
        function triggerSearchTimer(){
            clearTimeout(searchTimer);
            searchTimer = setTimeout("searchPlugin()", 500);
        }

        function searchPlugin(){
            var found = false;
            var searchCondition = $('#searchCondition').val().toLowerCase();

            $.each($('.pluginRow'), function(i, v){
                var pluginName = $(this).find(".pluginName").text().toLowerCase();
                var pluginDescription = $(this).find(".pluginDescription").text().toLowerCase();

                if(pluginName.indexOf(searchCondition) == -1 && pluginDescription.indexOf(searchCondition) == -1)
                    $(v).hide();
                else{
                    found = true;
                    $(v).show();
                }
            })

            if(!found)
                $('#noPluginFound').show()
            else
                $('#noPluginFound').hide();
        }

        function configurePlugin(pluginName){
            popupDialog.src = "${pageContext.request.contextPath}/web/settings/plugin/configure?pluginName=" + pluginName;
            popupDialog.init();
        }

        function configurePluginDefault(pluginName){
            popupDialog.src = "${pageContext.request.contextPath}/web/settings/plugin/default?pluginName=" + pluginName;
            popupDialog.init();
        }
    </script>
<commons:footer />