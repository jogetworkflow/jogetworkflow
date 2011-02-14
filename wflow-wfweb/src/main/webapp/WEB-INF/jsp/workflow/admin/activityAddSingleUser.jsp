<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

<div id="main-body-header">
    <fmt:message key="wflowAdmin.activity.reassign.user"/>
</div>

<div id="main-body-content" style="text-align: left">
    <p id="userToReplace">
        <label><fmt:message key="wflowAdmin.activity.reassign.selectUser"/></label>
        <select id="replaceUser" name="replaceUser">
            <c:forEach var="assignmentUser" items="${trackWflowActivity.assignmentUsers}" varStatus="index">
                <option value="${assignmentUser}">${assignmentUser}</option>
            </c:forEach>
        </select>
    </p>
    <div id="user">
        <ui:jsontable url="${pageContext.request.contextPath}/web/json/directory/dynamic/admin/user/list?${pageContext.request.queryString}"
                      var="userDataTable"
                      divToUpdate="userList"
                      jsonData="data"
                      rowsPerPage="10"
                      width="100%"
                      height="200"
                      sort="firstName"
                      desc="false"
                      href=""
                      hrefParam="username"
                      hrefQuery="false"
                      hrefDialog="false"
                      hrefDialogWidth="600px"
                      hrefDialogHeight="400px"
                      hrefDialogTitle=""
                      checkbox="true"
                      checkboxSelectSingle="true"
                      checkboxId="username"
                      checkboxButton1="general.method.label.submit"
                      checkboxCallback1="submitUser"
                      checkboxSelection="true"
                      checkboxSelectionTitle="Selected Users"
                      searchItems="name|Username/First Name"
                      fields="['id','username','firstName','lastName']"
                      column1="{key: 'username', label: 'wflowAdmin.participantMapping.view.label.user.username', sortable: true}"
                      column2="{key: 'firstName', label: 'wflowAdmin.participantMapping.view.label.user.firstName', sortable: true}"
                      column3="{key: 'lastName', label: 'wflowAdmin.participantMapping.view.label.user.lastName', sortable: true}"
                      />
    </div>   
</div>
<script>
    function submitUser(username){
        if(username.length > 0){
            if (confirm("<fmt:message key="wflowAdmin.participantMapping.view.label.submitConfirm"/>")) {
                var callback = {
                    success : function() {
                       parent.location.reload(true);
                    }
                }
                var replaceUser = $('#replaceUser').val();
                if($('#replaceUser option[value="'+username+'"]').length > 0){
                    alert('<fmt:message key="wflowAdmin.activity.reassign.error"/>');
                }else{
                    var params = "username=" + escape(username) + "&state=${state}&processDefId=${processDefId}&activityId=${activityId}&processId=${processId}&replaceUser=" + escape(replaceUser);
                    ConnectionManager.post('${pageContext.request.contextPath}/web/monitoring/running/activity/reassign', callback, params);
                }
            }
        }
    }
</script>
