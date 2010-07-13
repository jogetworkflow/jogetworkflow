<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="wflowAdmin.processConfiguration.view.label.title"/>
    </div>

    <div id="main-body-content" style="text-align: left">
        <form method="post" action="${pageContext.request.contextPath}/web/admin/package/update/submit" class="form" enctype="multipart/form-data">
            <input type="hidden" name="packageId" value="${packageId}">
            <div class="form-row">
                <label for="field1" class="upload"><fmt:message key="wflowAdmin.processConfiguration.view.label.processXpdlFile"/></label>
                <span class="form-input">
                    <input type="file" name="packageXpdlUpdate"/>
                </span>
            </div>
            <div class="form-buttons">
                <input class="form-button" type="submit" value="<fmt:message key="general.method.label.upload"/>" />
            </div>
        </form>
    </div>
            
<commons:popupFooter />