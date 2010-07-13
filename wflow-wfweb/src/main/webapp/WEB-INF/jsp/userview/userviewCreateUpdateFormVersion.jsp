<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>
<commons:popupHeader />

    <div id="main-body-header">
        <div id="main-body-header-title">
            <fmt:message key="wflowClient.userview.new.label.updateActivityFormVersion"/>
        </div>
    </div>

    <div id="main-body-content" style="text-align: left">
        <c:forEach var="entry" items="${formMap}">
            <c:set var="currentVersion" value="${entry.key}"/>
            <c:set var="formName" value="${formNameMap[entry.key]}"/>
            <div class="form-row">
                <label class="long-label">
                    <c:choose>
                    <c:when test='${fn:contains(formName, "_ver_")}'>
                        <c:set var="end" value='${fn:indexOf(formName, "_ver_")}'/>
                        <c:out value="${fn:substring(formName, 0, end)}"/>
                    </c:when>
                    <c:otherwise>
                        <c:out value="${formName}"/>
                    </c:otherwise>
                    </c:choose>
                </label>
                <span class="form-input">
                    <select class="updateForm" id="${entry.key}">
                        <c:forEach var="version" items="${entry.value}">
                            <c:set var="e" value='${fn:indexOf(version.key, ",")}'/>
                            <c:set var="id" value='${fn:substring(version.key,0, e)}'/>
                            <c:set var="selected"><c:if test="${id == currentVersion}"> selected</c:if></c:set>
                           <option ${selected} value="${version.key}">${version.value}</option>
                        </c:forEach>
                    </select>
                    <c:if test="${!empty formVersionIsLatestMap[entry.key]}">
                        <fmt:message key="wflowClient.userview.new.label.isLatest"/>
                    </c:if>
                </span>
            </div>
        </c:forEach>

        <div class="form-buttons">
            <span class="button">
                <input type="button" onclick="submitFormVersion()" value="<fmt:message key="general.method.label.submit"/>"/>
            </span>
        </div>
    </div>

<script type="text/javascript">
    function submitFormVersion(){
        $.each($('.updateForm'), function(i, v){
            var formId = $(v).attr('id');
            var selectedFormId = $(v).val().split(",")[0];
            var selectedFormName = $(v).val().split(",")[1];

            $.each($(".activityBlock", window.parent.document), function(i2, v2){
                var formIdInput = $(v2).find('input[name="activityForm"]');
                if($(formIdInput).val() != ''){
                    if($(formIdInput).val() == formId){
                        $(formIdInput).val(selectedFormId);
                        var link = '<a target="_blank" href="${pageContext.request.contextPath}/web/admin/form/general/view/' + selectedFormId + '">' + selectedFormName + '</a>';
                        $(v2).find('.activityForm').html(link);
                    }
                }
            });
        });
        window.parent.popupDialog.close();
    }
</script>

<commons:popupFooter />
