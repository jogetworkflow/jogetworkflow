<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<%@ page import="org.joget.workflow.util.WorkflowUtil"%>

<%
    String css = request.getContextPath() + "/css/joget.css";
    String temp = WorkflowUtil.getSystemSetupValue("css");
    if(temp != null && temp.length() > 0)
        css = temp;
%>
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/joget/joget.ico"/>
    <link rel="stylesheet" type="text/css" href="<%= css %>">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/header.css">
    <style>
        <%= WorkflowUtil.getSystemSetupValue("customCss") %>
    </style>
