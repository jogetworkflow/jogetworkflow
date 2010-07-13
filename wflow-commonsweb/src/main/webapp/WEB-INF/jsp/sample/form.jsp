<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header />

    <div id="main-body-path">
        (main-body-path)
        <ul>
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/#">Path</a></li>
        </ul>
    </div>

    <div id="main-body-header">
        Main Body Header (main-body-header)
    </div>

    <div id="main-body-content-subheader">
        Main Body Subheader (main-body-subheader)
    </div>

    <div id="main-body-side">
        Main Body Side (main-body-side)
    </div>
    
    <div id="main-body-content">
        
        MAIN BODY CONTENT (main-body-content)
        
        SAMPLE FORM
        
        <c:url var="url" value="#" /> 
        <form:form action="${url}" commandName="date" cssClass="form">
            <div class="form-header">Form Header (form-header)</div>
                <form:errors path="*" cssClass="form-errors" />
                <fieldset>
                    <legend>Form Fieldset</legend>
                    <div class="form-row">
                        <label for="field1">Field 1:</label>
                        <span class="form-input"><form:input path="time" cssErrorClass="form-input-error" /> <span class="form-input-message"><form:errors path="time"/></span></span>
                    </div>       
                    <div class="form-row">
                        <label for="field2">Field 2:</label>
                        <span class="form-input"><form:input path="time" /></span>
                    </div>
                </fieldset>
                <fieldset>
                    <legend>Form Fieldset</legend>
                    <div class="form-row">
                        <label for="field3">Field 3:</label>
                        <span class="form-input"><form:input path="time" /></span>
                    </div>       
                    <div class="form-row">
                        <label for="field4">Field 4:</label>
                        <span class="form-input"><form:input path="time" /></span>
                    </div>
                </fieldset>
                <div class="form-buttons">
                    Form Buttons
                    <input class="form-button" type="submit" value="Save" />
                    <input class="form-button" type="button" value="Cancel" />
                </div>
            <div class="form-footer">Form Footer</div>
        </form:form>
        
        <div id="main-body-actions">
            Actions (main-body-actions)
            <button>Add</button>
        </div>

    </div>

    <div id="main-body-footer">
        Main Body Footer (main-body-footer)
    </div>

<commons:footer />

