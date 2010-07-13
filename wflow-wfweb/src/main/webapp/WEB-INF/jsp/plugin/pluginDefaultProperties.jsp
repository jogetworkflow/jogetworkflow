<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.pluginDefaultProperties.label.title"/>
    </div>

    <div id="main-body-content" style="text-align: left">
        <dl>
            <dt><fmt:message key="general.plugin.configuration.label.pluginName"/></dt>
            <dd>${plugin.name}&nbsp;</dd>
            <dt><fmt:message key="general.plugin.configuration.label.pluginDescription"/></dt>
            <dd>${plugin.description}&nbsp;</dd>
            <dt><fmt:message key="general.plugin.configuration.label.pluginVersion"/></dt>
            <dd>${plugin.version}&nbsp;</dd>
        </dl>

        <form action="${pageContext.request.contextPath}/web/settings/plugin/default/submit" class="form" method="POST">
            <fieldset>
                <legend><fmt:message key="general.plugin.configuration.label.pluginProperties"/></legend>
                <input type="hidden" name="pluginName" value="${pluginName}"/>

                <c:import url = "/WEB-INF/jsp/common/pluginConfig.jsp"/>

            </fieldset>
        </form>
    </div>
<commons:popupFooter />