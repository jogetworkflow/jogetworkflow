<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowAdmin.message.view.label.title"
    path1="${pageContext.request.contextPath}/web/settings/resource/message/view/${message.id}"
    name1="wflowAdmin.main.body.path.message.view"
    helpTitle="wflowHelp.message.view.title"
    help="wflowHelp.message.view.content"
/>

    <div id="main-body-content">
        <dl>
            <dt><fmt:message key="wflowAdmin.message.view.label.key"/></dt>
            <dd>${message.key}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.message.view.label.locale"/></dt>
            <dd>${message.locale}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.message.view.label.message"/></dt>
            <dd>${message.message}&nbsp;</dd>
        </dl>

        <div class="form-buttons">
            <span class="button"><input class="form-button" type="button" value="<fmt:message key="general.method.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input class="form-button" type="button" value="<fmt:message key="general.method.label.delete"/>" onclick="del()"/></span>
        </div>
    </div>

    <script>
        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/settings/resource/message/edit/${message.id}"/>

        function edit(){
            popupDialog.src = "${pageContext.request.contextPath}/web/settings/resource/message/edit/${message.id}";
            popupDialog.init();
        }

        function del(){
            if (confirm("<fmt:message key="wflowAdmin.message.view.label.deleteConfirm"/>")) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/settings/resource/message/list';
                    }
                }
                ConnectionManager.post('${pageContext.request.contextPath}/web/settings/resource/message/delete', callback, 'id=${message.id}');
            }
        }

        function closeDialog() {
            popupDialog.close();
        }
    </script>
<commons:footer />
