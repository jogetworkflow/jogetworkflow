<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:popupHeader />

    <div id="main-body-header">
        <fmt:message key="usersAdmin.user.edit.label.title"/>
    </div>

    <div id="main-body-content">

        <c:url var="url" value="/web/directory/client/user/profile/submit" />
        <form:form action="${url}" method="POST" commandName="user" cssClass="form">
            <form:hidden path="id"/>
            <form:hidden path="username"/>

            <form:errors path="*" cssClass="form-errors"/>
            <c:if test="${error!=null}"><span class="form-errors" style="display:block"><fmt:message key="${error}"/></span></c:if>

            <fieldset>
                <legend><fmt:message key="usersAdmin.user.edit.label.details"/></legend>
                <div class="form-row">
                    <label for="username"><fmt:message key="usersAdmin.user.edit.label.user.name"/></label>
                    <span class="form-input">${user.username}</span>
                </div>
                <div class="form-row">
                    <label for="firstName"><fmt:message key="usersAdmin.user.edit.label.first.name"/></label>
                    <span class="form-input"><form:input path="firstName" /> * </span>
                </div>
                <div class="form-row">
                    <label for="lastName"><fmt:message key="usersAdmin.user.edit.label.last.name"/></label>
                    <span class="form-input"><form:input path="lastName" /></span>
                </div>
                <div class="form-row">
                    <label for="password"><fmt:message key="usersAdmin.user.edit.label.password"/></label>
                    <span class="form-input"><form:password path="password" showPassword="true"/> * </span>
                </div>
                <div class="form-row">
                    <label for="confirmPassword"><fmt:message key="usersAdmin.user.edit.label.confirm.password"/></label>
                    <span class="form-input"><form:password path="confirmPassword" showPassword="true"/> * </span>
                </div>
                <div class="form-row">
                    <label for="email"><fmt:message key="usersAdmin.user.edit.label.email"/></label>
                    <span class="form-input"><form:input path="email" /></span>
                </div>
                <div class="form-row">
                    <label for="timeZone"><fmt:message key="usersAdmin.user.edit.label.timeZone"/></label>
                    <span class="form-input">
                        <select name="timeZone" id="timeZone">
                            <option selected value="0"><fmt:message key="general.method.label.select"/></option>
                            <c:forEach items="${timeZoneList}" var="timeZone">
                                <c:choose>
                                    <c:when test="${user.timeZone == timeZone.key}">
                                        <option selected value="${timeZone.key}">${timeZone.value}</option>
                                    </c:when>
                                    <c:otherwise>
                                        <option value="${timeZone.key}">${timeZone.value}</option>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </select>
                    </span>
                </div>
            </fieldset>
            <div class="form-buttons">
                <span class="button"><input type="submit" value="<fmt:message key="general.method.label.save"/>"/></span>
                <span class="button"><input type="button" value="<fmt:message key="general.method.label.close"/>" onclick="closeDialog()" /></span>
            </div>
        </form:form>
    </div>

    <script>
        function closeDialog() {
            if (parent && parent.userProfileCloseDialog) {
                parent.userProfileCloseDialog();
            }
            return false;
        }
    </script>
<commons:popupFooter />
