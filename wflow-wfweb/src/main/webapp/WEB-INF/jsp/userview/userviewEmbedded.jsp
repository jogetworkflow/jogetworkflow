<%@ page import="org.joget.workflow.util.WorkflowUtil,java.util.Date"%>
<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<commons:popupHeader title="${userviewSetup.setupName}"/>

<%
    String css = request.getContextPath() + "/css/userview.css";
%>

<c:set var="userFullName" value="<%= WorkflowUtil.getCurrentUserFullName() %>"/>

<link rel="stylesheet" type="text/css" href="<%= css %>">
<c:if test="${!empty userviewSetup.cssLink}">
    <link rel="stylesheet" type="text/css" href="${userviewSetup.cssLink}">
</c:if>
<c:if test="${!empty userviewSetup.css}">
    <style>
        ${userviewSetup.css}
    </style>
</c:if>
<jsp:include page="/WEB-INF/jsp/includes/rtl.jsp" />
<script type="text/javascript">
    function markAsBold(task){
        for(var column in task){
            if(column != 'formMetaData.id'){
                task[column] = "<span class=\"pendingTask\">" + task[column] + "</span>";
            }
        }
    }

    function checkAssignment(jsonObject){
        if(jsonObject.data != undefined && jsonObject.data.length == undefined){
            if(jsonObject.data.activityId != undefined){
                markAsBold(jsonObject.data);
            }
        }else{
            for(var i in jsonObject.data){
                if(jsonObject.data[i].activityId != undefined){
                    markAsBold(jsonObject.data[i]);
                }
            }
        }

        return jsonObject;
    }
</script>

<div id="container">
    <div id="userviewHeader">
        <div id="userviewHeaderTitle">
            <a href="${pageContext.request.contextPath}/web/userview/${userviewId}">${userviewSetup.setupName}</a>
        </div>
        <c:if test="${!empty userviewSetup.header}">
            <div id="customUserviewHeader">
                ${userviewSetup.header}
            </div>
        </c:if>
        <div id="userviewHeaderDate">
             <fmt:formatDate value="<%= new Date()%>" pattern="dd MMM yyyy"/>
        </div>
        <div id="userviewHeaderUser">
            Welcome, <a href="javascript: editUserProfile()">${userFullName}</a>

            <script>
                <ui:popupdialog var="userProfilePopupDialog" src="${pageContext.request.contextPath}/web/directory/client/user/profile/edit"/>

                function editUserProfile(){
                    userProfilePopupDialog.init();
                }

                function userProfileCloseDialog() {
                    userProfilePopupDialog.close();
                }
            </script>

        </div>
        <div id="userviewHeaderLogout">
            <a href="${pageContext.request.contextPath}/j_spring_security_logout"><fmt:message key="general.header.logout"/></a>
        </div>
    </div>
    <div id="userviewBody" style="text-align: left">
        <div id="userviewBodyLeftMenu">
            <c:if test="${showStartProcess == 'true'}">
            <div id="startProcess">              
                <div id="startProcessLabel"><a href="javascript: startProcess();"> ${userviewSetup.startProcessLabel}</a></div>
            </div>
            </c:if>
            <div id="inbox">
                <div id="inboxLabel"><a href="${pageContext.request.contextPath}/web/userview/${userviewId}">
                    <c:choose>
                    <c:when test="${!empty userviewSetup.inboxLabel}">
                        ${userviewSetup.inboxLabel}
                    </c:when>
                    <c:otherwise>
                        <fmt:message key="wflowClient.userview.inbox"/>
                    </c:otherwise>
                    </c:choose>
                </a></div>
            </div>

            <div id="activityList">
                <c:forEach items="${categoryActivityMap}" var="category">
                    <div class="categoryLabel">${category.key}</div>
                    <ul>
                        <c:forEach items="${category.value}" var="activity">
                            <c:if test="${param.detail == activity.userviewActivityObj.id}">
                                <c:set var="currentTitle" value="${activity.wfActivityObj.name}"/>
                            </c:if>
                            <li>
                                <a href="${pageContext.request.contextPath}/web/userview/${userviewId}?detail=${activity.userviewActivityObj.id}">${activity.wfActivityObj.name} 
                                <c:if test="${activity.wfActivityObj.latestActivityCount > 0}">
                                    &nbsp;(${activity.wfActivityObj.latestActivityCount})
                                </c:if>
                                </a><br/>
                            </li>
                        </c:forEach>
                    </ul>
                </c:forEach>
            </div>

            <c:if test="${!empty userviewSetup.menu}">
                <div id="customUserviewMenu">
                    ${userviewSetup.menu}
                </div>
            </c:if>
        </div>
        <div id="userviewBodyContent">
            <div id="userview">
                <c:choose>
                <c:when test="${!empty detail}">

                    <c:if test="${!empty currentTitle}">
                        <h3>${currentTitle}</h3>
                    </c:if>
                    
                    <c:if test="${!empty tableHeader}">
                        <div id="main-body-content-header">
                            ${tableHeader}
                        </div>
                    </c:if>

                    <c:if test="${!empty filterTypes}">
                        <div id="main-body-content-filter">
                            <form>
                                <fmt:message key="wflowClient.userview.filterBy"/>
                                <select id="filterType">
                                    <option selected value=""></option>
                                    <c:forEach items="${filterTypes}" var="filterType">
                                        <option value="${filterType.key}">${filterType.value}</option>
                                    </c:forEach>
                                </select>
                                <input id="filter" value="" onChange=""/>
                                <input id="search" type="button" value="<fmt:message key='wflowClient.userview.search'/>"/>
                            </form>
                        </div>
                    </c:if>

                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/userview/view/${detail}?${pageContext.request.queryString}"
                                  var="userviewActivityList"
                                  divToUpdate="userviewDetail"
                                  jsonData="data"
                                  rowsPerPage="10"
                                  sort="dynamicForm.id"
                                  desc="true"
                                  width="100%"
                                  href="${pageContext.request.contextPath}/web/userview/form/view/${detail}"
                                  hrefParam="formMetaData.id"
                                  hrefQuery="false"
                                  hrefDialog="true"
                                  customPreProcessor="checkAssignment"
                                  fields="['formMetaData.id']"
                                  dynamicColumn="${columns}"
                                  />

                    <c:if test="${!empty tableFooter}">
                        <div id="main-body-content-footer">
                            ${tableFooter}
                        </div>
                    </c:if>

                </c:when>
                <c:otherwise>
                    <c:choose>
                    <c:when test="${!empty userviewSetup.inboxLabel}">
                        <h3>${userviewSetup.inboxLabel}</h3>
                    </c:when>
                    <c:otherwise>
                        <h3><fmt:message key="wflowClient.userview.inbox"/></h3>
                    </c:otherwise>
                    </c:choose>

                    <ui:jsontable url="${pageContext.request.contextPath}/web/json/userview/inbox/${userviewId}?${pageContext.request.queryString}"
                                  var="userview"
                                  divToUpdate="userviewDetail"
                                  jsonData="data"
                                  rowsPerPage="10"
                                  sort="dateCreated"
                                  desc="true"
                                  width="100%"
                                  href="${pageContext.request.contextPath}/web/client/assignment/view/"
                                  hrefParam="activityId"
                                  hrefQuery="false"
                                  hrefDialog="true"
                                  fields="['activityId','activityName','processName','dateCreated','acceptedStatus','due']"
                                  column1="{key: 'activityName', label: 'wflowClient.inbox.list.label.activityName', sortable: false, width: '260'}"
                                  column2="{key: 'dateCreated', label: 'wflowClient.inbox.list.label.dateCreated', sortable: true, width: '120'}"
                                  column3="{key: 'serviceLevelMonitor', label: 'wflowClient.inbox.list.label.serviceLevelMonitor', sortable: true}"
                                  column4="{key: 'due', label: 'wflowClient.inbox.list.label.due', sortable: true}"
                                  />
                </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div style="clear: both"></div>
    </div>

    
    <c:if test="${!empty userviewSetup.footer}">
        <div id="customUserviewFooter">
            ${userviewSetup.footer}
        </div>
    </c:if>
</div>
<c:set var="runDirectly" value=""/>
<c:if test="${userviewSetup.runProcessDirectly == 1}">
    <c:set var="runDirectly" value="?runDirectly=true"/>
</c:if>
<script type="text/javascript">

    <ui:popupdialog var="popupDialog" src="${pageContext.request.contextPath}/web/client/process/view/${userviewSetup.startProcessDefId}${runDirectly}"/>

    function startProcess(){
        popupDialog.init();
    }

    $(document).ready(function(){
        $('#search').click(function(){
            filter(userviewActivityList, '&filterType=' + $('#filterType').val() + '&filter=' + $('#filter').val(), '');
        })

        if ($.browser.mozilla) {
            $("#filter").keypress(checkForEnter);
        } else {
            $("#filter").keydown(checkForEnter);
        }
    })

    function checkForEnter(event) {
        if (event.keyCode == 13) {
            filter(userviewActivityList, '&filterType=' + $('#filterType').val() + '&filter=' + $('#filter').val(), '');
            return false;
        }
    }

    //override popup dialog close dialog function
    var oriPopupCloseDialog = PopupDialog.closeDialog;

    PopupDialog.closeDialog = function(){
        oriPopupCloseDialog();
        setTimeout("window.location.reload()", 1000);
    }
</script>
<commons:popupFooter />
