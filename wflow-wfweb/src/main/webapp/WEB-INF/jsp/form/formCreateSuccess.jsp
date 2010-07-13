<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<script type="text/javascript">
    window.open("${pageContext.request.contextPath}/web/formbuilder/admin/edit/${form.id}");
    <c:choose>
        <c:when test="${redirect==true}">
            parent.location = '${pageContext.request.contextPath}/web/admin/form/general/view/${form.id}';
        </c:when>
        <c:otherwise>
            parent.location.reload(true);
        </c:otherwise>
    </c:choose>
</script>