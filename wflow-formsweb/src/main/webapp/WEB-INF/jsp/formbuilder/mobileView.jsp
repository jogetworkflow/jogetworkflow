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

</head>
<body style="background:white; margin:0px; padding:0px">
    <form id="formbuilder_export_form" enctype="multipart/form-data" method="post" action="${pageContext.request.contextPath}/web/formbuilder/mobileSubmit" name="formbuilder_export_form">
        ${html}

        <input type="hidden" name="id" value="${id}">
        <input type="hidden" name="processId" value="${processId}">
        <input type="hidden" name="activityId" value="${activityId}">
        <input type="hidden" name="processDefId" value="${processDefId}">
        <input type="hidden" name="activityDefId" value="${activityDefId}">
        <input type="hidden" name="version" value="${version}">
        <input type="hidden" name="username" value="${username}">
        <input type="submit" value="Submit">
    </form>
</body>
</html>