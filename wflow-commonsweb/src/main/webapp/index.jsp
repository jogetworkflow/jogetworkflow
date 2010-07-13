<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

<commons:header />

    <div id="main-body-path">
        <ul>
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/#">Path</a></li>
        </ul>
    </div>

    <div id="main-body-header">
        Main Body Header (main-body-header)
    </div>

    <div id="main-body-subheader">
        Main Body Subheader (main-body-subheader)
    </div>

    <div id="main-body-side">
        Main Body Side (main-body-side)
    </div>
    
    <div id="main-body-content">
        
        MAIN BODY CONTENT (main-body-content)
        
        <div id="main-body-actions">
            Actions (main-body-actions)
            <button>Add</button>
        </div>

    </div>

    <div id="main-body-footer">
        Main Body Footer (main-body-footer)
    </div>

<commons:footer />

