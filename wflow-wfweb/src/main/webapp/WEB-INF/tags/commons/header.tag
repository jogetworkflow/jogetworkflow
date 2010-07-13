<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ tag import="org.joget.workflow.util.WorkflowUtil"%>

<%@ attribute name="title" required="false" %>
<%@ attribute name="help" required="false" %>
<%@ attribute name="helpTitle" required="false" %>
<%@ tag dynamic-attributes="attributeMap" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<%
    String directoryManagerImpl = WorkflowUtil.getSystemSetupValue("directoryManagerImpl");
    ((PageContext) jspContext).setAttribute("directoryManagerImpl", directoryManagerImpl);
%>

<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <title><fmt:message key="general.header.appTitle"/></title>

    <!-- Page-specific styles -->
    <jsp:include page="/WEB-INF/jsp/includes/css.jsp" />
    <jsp:include page="/WEB-INF/jsp/includes/scripts.jsp" />
    <jsp:include page="/WEB-INF/jsp/includes/rtl.jsp" />
</head>
<body>

<c:set var="username" value="<%= WorkflowUtil.getCurrentUsername() %>"/>
<c:set var="isAnonymous" value="<%= WorkflowUtil.isCurrentUserAnonymous() %>"/>
<c:set var="isAdmin" value="<%= WorkflowUtil.isCurrentUserInRole(WorkflowUtil.ROLE_ADMIN) %>"/>

    <div id="site" class="container">
        <div id="header">
        <div class="static">
            <fmt:message key="general.header.appTitle"/>
            <div class="login">

                <c:if test="${!isAnonymous}">
                    <c:choose>
                        <c:when test="${!empty directoryManagerImpl}">
                            ${username}
                        </c:when>
                        <c:otherwise>
                            <a href="javascript: editUserProfile()">${username}</a>

                            <script>
                                <ui:popupdialog var="userProfilePopupDialog" src="${pageContext.request.contextPath}/web/directory/client/user/profile/edit"/>

                                function editUserProfile(){
                                    userProfilePopupDialog.init();
                                }

                                function userProfileCloseDialog() {
                                    userProfilePopupDialog.close();
                                }
                            </script>

                        </c:otherwise>
                    </c:choose>

                    &nbsp;&nbsp; | &nbsp;&nbsp;
                    <a href="${pageContext.request.contextPath}/j_spring_security_logout"><fmt:message key="general.header.logout"/></a>
                </c:if>
                <c:if test="${isAnonymous}">
                    <a href="${pageContext.request.contextPath}/web/login"><fmt:message key="general.header.login"/></a>
                </c:if>

            </div>
        </div>


        <h1><a href="${pageContext.request.contextPath}/web/index">&nbsp;</a></h1>
        <jsp:include page="/WEB-INF/jsp/includes/menu.jsp?anonymous=${isAnonymous}&admin=${isAdmin}" flush="true" />

        
        </div>
        
        <div id="subheader" class="clearboth">

            <div id="breadcrumbs">
                <div class="float_left">
                    <fmt:message key="general.main.body.path.here"/>
                </div>

                <script>
                    //first level breadcrumb
                    var firstText = $("li[class^='active-'] .menu-title").text();
                    if (firstText) {
                        var temp = '<div class="bulletpoint">'
                            + '<img src="${pageContext.request.contextPath}/images/joget/icn_arrowblack.gif" width="15" height="10" align="top" />'
                            + '</div>'
                            + '<div class="float_left">'
                            + firstText
                            + '</div>';
                        $('#breadcrumbs').append(temp);
                    }

                    //second level breadcrumb
                    var baseUrl = '${requestScope['javax.servlet.forward.path_info']}';
                    var contextPath = '${pageContext.request.contextPath}' + '/web';
                    $.each($('#nav li div ul li a'), function(i, v){
                        var href = $(v).attr('href');
                        var tempHref = href.replace(contextPath, '');

                        var numOfSlash = tempHref.split('/').length-1;
                        while(numOfSlash > 3){
                            var index = tempHref.lastIndexOf('/');
                            tempHref = tempHref.substring(0, index);
                            numOfSlash--;
                        }

                        var numOfSlash = baseUrl .split('/').length-1;
                        while(numOfSlash > 3){
                            var index = baseUrl .lastIndexOf('/');
                            baseUrl = baseUrl .substring(0, index);
                            numOfSlash--;
                        }

                        if(tempHref == baseUrl){
                            $(v).css('font-weight', 'bold');

                        var temp = '<div class="bulletpoint">'
                                + '<img src="${pageContext.request.contextPath}/images/joget/icn_arrowblack.gif" width="15" height="10" align="top" />'
                                + '</div>'
                                + '<div class="float_left">'
                                + '<a href="' + href + '" class="site_location">' + $(v).find(".menu-item").text() + '</a>';
                                + '</div>';
                            $('#breadcrumbs').append(temp);
                        }
                    })
                </script>

                <c:forEach var="count" begin="0" end="2">
                    <c:set var="path">path${count}</c:set>
                    <c:set var="name">name${count}</c:set>
                    <c:if test="${!empty attributeMap[path] && !empty attributeMap[name]}">
                        <div class="bulletpoint">
                            <img src="${pageContext.request.contextPath}/images/joget/icn_arrowblack.gif" width="15" height="10" align="top" />
                        </div>
                        <div class="float_left">
                            <!-- Retrieve message from resource bundle if the key is exist, otherwise, display the default value -->
                            <c:set var="setAttributeMap"><fmt:message key="${attributeMap[name]}"/></c:set>

                            <a href="${attributeMap[path]}" class="site_location">
                                ${fn:replace(setAttributeMap, "???", "")}
                            </a>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            

            <ul id="guide">
                <li><a class="guide-title"><fmt:message key="general.footer.sidebar"/></a>
                    <div class="guide-dropdown">
                        <div class="guide-top"></div>
                        <ul>
                            <li><jsp:include page="/WEB-INF/jsp/includes/sidebar.jsp"/></li>
                        </ul>
                        <div class="guide-bottom"></div>
                    </div>
                </li>
            </ul>

            <div id="get-help">
                <a href="http://www.joget.org/help?src=wmc" target="www.joget.org">
                    <img src="${pageContext.request.contextPath}/images/joget/icon_help_small.png"/>
                    <span><fmt:message key="general.footer.getHelp"/></span>
                </a>
            </div>

        </div>
    </div>

    <div class="clearboth"></div>

    <div id="contain">
        <!-- content -->
        <div class="container_top">
            <div class="float_left"></div>
            <div class="float_right"></div>
        </div>

        <div id="content_container">
            <!-- breadcrumbs -->
            
            <!-- close breadcrumbs -->

            <div id="content_header">
                <div class="float_left"></div>
                <div id="title">
                   <!-- Retrieve message from resource bundle if the key is exist, otherwise, display the default value -->
                    <c:set var="setTitle"><fmt:message key="${title}"/></c:set>
                    ${fn:replace(setTitle, "???", "")}
                </div>
                <div class="float_right"></div>
            </div>
            <div id="content_box">
