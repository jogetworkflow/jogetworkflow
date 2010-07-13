<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header 
    title="wflowAdmin.message.list.label.title"
    helpTitle="wflowHelp.message.list.title"
    help="wflowHelp.message.list.content"
/>

    <div id="main-body-content">
        <div id="main-body-content-filter">
            <form>
            <fmt:message key="wflowAdmin.message.list.label.localeFilter"/>
            <select onchange="filter(JsonDataTable, '&locale=', this.options[this.selectedIndex].value)">
                <option></option>
            <c:forEach items="${localeList}" var="locale">
                <c:set var="selected"><c:if test="${locale == param.locale}"> selected</c:if></c:set>
                <option value="${locale}" ${selected}>${locale}</option>
            </c:forEach>
            </select>
            </form>
        </div>

        <ui:jsontable url="${pageContext.request.contextPath}/web/json/workflow/resource/message/list?${pageContext.request.queryString}"
                   var="JsonDataTable"
                   divToUpdate="messageList"
                   jsonData="data"
                   rowsPerPage="10"
                   width="100%"
                   sort="key"
                   desc="false"
                   href="${pageContext.request.contextPath}/web/settings/resource/message/view"
                   hrefParam="id"
                   hrefQuery="false"
                   hrefDialog="false"
                   searchItems="key|Key, message|Message"
                   fields="['id', 'key','locale','message']"
                   column1="{key: 'key', label: 'wflowAdmin.message.list.label.key', sortable: true}"
                   column2="{key: 'locale', label: 'wflowAdmin.message.list.label.locale', sortable: false}"
                   column3="{key: 'message', label: 'wflowAdmin.message.list.label.message', sortable: false}"
                   />
        <div id="main-body-actions">
            <input class="form-button" type="button" onclick="createMessage()" value="<fmt:message key="wflowAdmin.message.list.label.createMessage"/>">
            <button onclick="importPOFile()"><fmt:message key="wflowAdmin.message.list.label.importPOFile"/></button>
        </div>
    </div>

    <script type="text/javascript">

        <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/settings/resource/message/create"/>
        
        function createMessage(){
            popupDialog.init();
        }

        function closeDialog(){
            popupDialog.close();
        }

        function importPOFile(){
           location.href="${pageContext.request.contextPath}/web/settings/resource/message/import";
        }
    </script>

<commons:footer />