<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<c:if test="${!jsonUiInRequest}">

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery/themes/themeroller/jquery-ui-themeroller.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery/flexigrid/css/flexigrid/flexigrid.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery/dynatree/skin/ui.dynatree.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/jquery.ui.tab.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery/autocomplete/jquery.autocomplete.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquery-1.2.6.pack.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/ui/packed/jquery.ui.all.packed.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/flexigrid/flexigrid.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquerycssmenu/jquerycssmenu.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/dynatree/jquery.dynatree.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/json/ui.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/json/util.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/autocomplete/lib/jquery.bgiframe.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/autocomplete/jquery.autocomplete.pack.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/md5/jquery.md5.js"></script>

    <!-- jquery clue tip -->
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery/jquerycluetip/css/jquery.cluetip.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquerycluetip/jquery.dimensions.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquerycluetip/jquery.hoverIntent.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery/jquerycluetip/jquery.cluetip.js"></script>

    <c:set var="jsonUiInRequest" scope="request" value="true"/>
</c:if>
