<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header
    title="wflowAdmin.variable.view.label.title"
    path1="${pageContext.request.contextPath}/web/settings/form/variable/view/${formVariable.id}"
    name1="wflowAdmin.main.body.path.variable.view"
    helpTitle="wflowHelp.variable.view.title"
    help="wflowHelp.variable.view.content"
/>

    <div id="main-body-content">
        <dl>
            <dt><fmt:message key="wflowAdmin.variable.view.label.name"/></dt>
            <dd>${formVariable.name}&nbsp;</dd>
            <dt><fmt:message key="wflowAdmin.variable.view.label.pluginName"/></dt>
            <dd>${formVariable.pluginName}&nbsp;</dd>
        </dl>

        <div class="form-buttons">
            <span class="button"><input type="button" value="<fmt:message key="wflowAdmin.variable.view.label.configure"/>" onclick="configure()" /></span>
            <span class="button"><input type="button" value="<fmt:message key="wflowAdmin.variable.view.label.edit"/>" onclick="edit()"/></span>
            <span class="button"><input type="button" value="<fmt:message key="wflowAdmin.variable.view.label.delete"/>" onclick="del()"/></span>
        </div>

        <div id="main-body-content-subheader">
            <fmt:message key="wflowAdmin.variable.view.preview.label.title"/>
        </div>

        <div id="resultPreview">
            <ul>
                <li class="selected"><a href="#select"><span><fmt:message key="wflowAdmin.variable.view.preview.tab.selectBox"/></span></a></li>
                <li><a href="#radio"><span><fmt:message key="wflowAdmin.variable.view.preview.tab.radioButton"/></span></a></li>
                <li><a href="#checkbox"><span><fmt:message key="wflowAdmin.variable.view.preview.tab.checkBox"/></span></a></li>
            </ul>
            <div>
                <div id="select">
                    <br>
                    <select>
                    <c:forEach var="entry" items="${resultPreview}">
                        <option value="${entry.key}">${entry.value}</option>
                    </c:forEach>
                    </select>
                    <select size="10">
                    <c:forEach var="entry" items="${resultPreview}">
                        <option value="${entry.key}">${entry.value}</option>
                    </c:forEach>
                    </select>
                </div>

                <div id="radio">
                    <br>
                    <c:forEach var="entry" items="${resultPreview}">
                        <input type="radio" name="radio" value="${entry.key}">&nbsp;${entry.value}<br>
                    </c:forEach>
                </div>

                <div id="checkbox">
                    <br>
                    <c:forEach var="entry" items="${resultPreview}">
                        <input type="checkbox" name="checkbox" value="${entry.key}">&nbsp;${entry.value}<br>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        var tabView = new TabView('resultPreview', 'top');
        tabView.init();

        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/settings/form/variable/edit/${formVariable.id}"/>

        function configure(){
            popupDialog.src = "${pageContext.request.contextPath}/web/settings/form/variable/configure?id=${formVariable.id}";
            popupDialog.init();
        }

        function edit(){
            popupDialog.src = "${pageContext.request.contextPath}/web/settings/form/variable/edit/${formVariable.id}";
            popupDialog.init();
        }

        function del(){
            if (confirm("<fmt:message key="wflowAdmin.variable.view.label.deleteConfirm"/>")) {
                var callback = {
                    success : function() {
                        document.location = '${pageContext.request.contextPath}/web/settings/form/variable/list';
                    }
                }
                ConnectionManager.post('${pageContext.request.contextPath}/web/settings/form/variable/delete', callback, 'formVariableId=${formVariable.id}');
            }
        }

        function closeDialog() {
            popupDialog.close();
        }
    </script>
<commons:footer />
