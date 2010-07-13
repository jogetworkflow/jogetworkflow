<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.form.util.FormUtil" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" debug="true">

<head>
  <title>${name}</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <!--<script language="javascript" type="text/javascript" src="lib/firebug/firebug.js"></script>-->

<%
    String formCss = request.getContextPath() + "/lib/css/formbuilder.css";
    String temp = FormUtil.getSystemSetupValue("formCss");
    if(temp != null && temp.length() > 0){
        formCss = temp;
    }

    String rightToLeft = FormUtil.getSystemSetupValue("rightToLeft");
    pageContext.setAttribute("rightToLeft", rightToLeft);
%>

  <c:if test="${rightToLeft == 'true'}">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/lib/css/formbuilder_rtl.css">
  </c:if>

  <link rel="stylesheet" type="text/css" href="<%= formCss %>">

  <script type="text/javascript" language="javascript" src="${pageContext.request.contextPath}/lib/jquery/jquery-1.2.6.min.js" ></script>
  <script type="text/javascript" language="javascript" src="${pageContext.request.contextPath}/lib/formbuilder/formbuilder.init.js.jsp?id=${id}&view=true&processId=${param.processId}&activityId=${param.activityId}&version=${param.version}&processRequesterId=${param.processRequesterId}&numOfSubForm=${numOfSubForm}&preview=${param.preview}&username=${param.username}&overlay=${param.overlay}&parentProcessId=${param.parentProcessId}&processDefId=${fn:replace(param.processDefId, "#", "%23")}" ></script>
</head>
<body style="background:white; margin:0px; padding:0px">
    <div id="formbuilder_main">
      <img src="${pageContext.request.contextPath}/lib/img/loadingAnimation.gif" alt="alt" width="208" height="13" />
    </div>
</body>
</html> 