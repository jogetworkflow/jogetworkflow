<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<%@ attribute name="title" required="false" %>
<%@ attribute name="help" required="false" %>
<%@ attribute name="helpTitle" required="false" %>
<%@ tag dynamic-attributes="attributeMap" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <title><fmt:message key="general.header.appTitle"/></title>

    <!-- Page-specific styles -->
    <jsp:include page="/WEB-INF/jsp/includes/css.jsp" />
    <jsp:include page="/WEB-INF/jsp/includes/scripts.jsp" />

</head>
<body>

<div id="contain">
    <!-- top info puller -->
    <div id="topInfo">
        <fmt:message key="general.header.topInfoContent"/>
    </div>
    <div id="topInfo_Puller">
        <div id="appTitle" class="float_left">
            <fmt:message key="general.header.appTitle"/>
        </div>
        <div class="float_left">
            <a href="javascript:toggleTopInfo();" title="<fmt:message key="general.header.topInfo"/>"><div id="puller"></div></a>
        </div>

        <script>
            function toggleTopInfo(){
                $('#topInfo').slideToggle('slow', null);
            }
        </script>

        <div id="userInfo">
            <c:set var="isAnonymous" value="false"/>
            <c:set var="isAdmin" value="true"/>
            <c:set var="username" value="admin"/>
            <c:if test="${!isAnonymous}">
                <c:set var="username" value="${user.username}"/>
                <div class="white_text float_left">${username}</div>
                <div class="divider_1 float_left"></div>
                <div class="float_left"><a href="${pageContext.request.contextPath}/j_spring_security_logout" class="white_text user_link"><fmt:message key="general.header.logout"/></a></div>
            </c:if>
            <c:if test="${isAnonymous}">
                <div class="float_left"><a href="${pageContext.request.contextPath}/web/login" class="white_text user_link"><fmt:message key="general.header.login"/></a></div>
            </c:if>
        </div>
    </div>
    <!-- close workflow info puller -->

    <div class="clear">
        <jsp:include page="/WEB-INF/jsp/includes/menu.jsp?anonymous=${isAnonymous}&admin=${isAdmin}" flush="true" />
    </div>
    <div class="clear"></div>
    <div class="spacing"></div>

    <div id="info" style="display:none">
        <div class="info_box">
            <span class="info_box_close">
                <!--a onclick="new Message('','','').close();">[close]</a-->
            </span>
            <div class="info_box_header">Notification/Alert/Error/Information/Feedback</div>
            <div class="info_box_text">
                <i>description goes here</i>
            </div>
        </div>
        <div class="spacing"></div>
    </div>
    <div class="clear"></div>

    <!-- content -->
    <div class="container_top">
        <div class="float_left"></div>
        <div class="float_right"></div>
    </div>

    <div id="content_container">
        <!-- breadcrumbs -->
        <div id="breadcrumbs">
            <div class="float_left">
                <a href="">
                    <fmt:message key="general.main.body.path.home"/>
                </a>
            </div>

            <script>
                //first level breadcrumb
                var temp = '<div class="bulletpoint">'
                         + '<img src="${pageContext.request.contextPath}/images/new/bulletpoint.gif" width="2" height="2" />'
                         + '</div>'
                         + '<div class="float_left">'
                         //+ '<a href="${attributeMap[path]}" class="site_location"><fmt:message key="${attributeMap[name]}"/></a>';
                         + $('.ui-tabs-selected .navHeader').text()
                         + '</div>';
                $('#breadcrumbs').append(temp);

                //second level breadcrumb
                var baseUrl = '${requestScope['javax.servlet.forward.path_info']}';
                var contextPath = '${pageContext.request.contextPath}' + '/web';
                $.each($('#menuTabView div .ui-tabs-nav li a'), function(i, v){
                    var href = $(v).attr('href');
                    var tempHref = href.replace(contextPath, '');

                    //var tempHref = '/settings/form/variable/list';
                    //var baseUrl = '/settings/form/variable/view/b85467ba-4552-102c-a67e-735861dd325f';

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
                        var temp = '<div class="bulletpoint">'
                                 + '<img src="${pageContext.request.contextPath}/images/new/bulletpoint.gif" width="2" height="2" />'
                                 + '</div>'
                                 + '<div class="float_left">'
                                 + '<a href="' + href + '" class="site_location">' + $(v).text() + '</a>';
                                 + '</div>';
                        $('#breadcrumbs').append(temp);
                    }
                })
            </script>

            <c:forEach var="count" begin="0" end="10">
                <c:set var="path">path${count}</c:set>
                <c:set var="name">name${count}</c:set>
                <c:if test="${!empty attributeMap[path] && !empty attributeMap[name]}">
                    <div class="bulletpoint">
                        <img src="${pageContext.request.contextPath}/images/new/bulletpoint.gif" width="2" height="2" />
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
        <!-- close breadcrumbs -->

        <div class="float_left">
            <div id="content_header">
                <div class="float_left"></div>
                <div id="title">
                   <!-- Retrieve message from resource bundle if the key is exist, otherwise, display the default value -->
                    <c:set var="setTitle"><fmt:message key="${title}"/></c:set>
                    ${fn:replace(setTitle, "???", "")}
                </div>
                <div class="float_right"></div>
                <c:if test="${!empty help}">
                <div id="content_header_help" helpTitle="<fmt:message key="${helpTitle}"/>|||<fmt:message key="${help}"/>"></div>
                    <script type="text/javascript">
                        $(document).ready(function(){
                            $('#content_header_help').cluetip({
                                splitTitle: '|||',
                                arrows: true,
                                activation: 'click'
                            });
                        });
                    </script>
                </c:if>
            </div>
            <div id="content_box"><div style="padding: 20px 10px 20px 10px;">
