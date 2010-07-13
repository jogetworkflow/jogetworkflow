<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowAdmin.setup.version.label.title"
    helpTitle="wflowHelp.setup.version.title"
    help="wflowHelp.setup.version.content"
/>

    <div id="main-body-content">

        <div id="main-body-content-subheader"><fmt:message key="general.login.label.revision" /></div>
        <div class="form-row">
            <div id="changes"></div>
        </div>

    </div>

<script>
    var url = "http://www.joget.org/updates/changes";
    var callbackUpdate = function(data) {
        var changesDiv = document.getElementById("changes");
        changesDiv.innerHTML = data.content;
    }
    ConnectionManager.get(url, null, null, true);
</script>

<commons:footer />

