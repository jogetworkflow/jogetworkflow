<%@ page isErrorPage="true" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <title></title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath()%>/css/new.css">
    </head>
    <body>

        <p>&nbsp;</p>

        <div id="contain">

            <!-- content -->
            <div class="container_top">
                <div class="float_left"></div>
                <div class="float_right"></div>
            </div>

            <div id="content_container">
                <!-- breadcrumbs -->
                <div id="breadcrumbs">
                    <div class="float_left">
                        <a href="">
                            Page Not Found (Code 404)
                        </a>
                    </div>
                </div>
                <!-- close breadcrumbs -->

                <div class="float_left">
                    <div id="content_header">
                        <div class="float_left"></div>
                        <div id="title">
                            Page Not Found
                        </div>
                        <div class="float_right"></div>

                    </div>
                    
                    <div id="content_box" style="overflow:auto">
                        <div style="padding: 20px 10px 20px 10px; height:350px">
                            Sorry, the page requested is not found.
                            <br><br>
                            If you have been brought to this page unintentionally, please report the previous URL for troubleshooting purposes.
                            <p>&nbsp;</p>
                            <p>&nbsp;</p>
                            <p>
                                <a href="${pageContext.request.contextPath}/" style="font-size:1.5em">Click here to go back to the main page</a>
                            </p>
                        </div>
                    </div>

                    <div id="content_bottom">
                        <div class="float_left"></div>
                        <div class="float_right"></div>
                    </div>
                    <!-- end content_box -->
                </div>
                <!-- end float_left -->

                <div id="side">
                    <div>
                        <div id="sidebar_top"><img src="${pageContext.request.contextPath}/images/new/sidebar_top.gif" height="9"/></div>
                        <div id="sidebar">
                            <h2>Error</h2>
                            <p>
                            Please check the address bar to ensure that you have the correct URL.
                            </p>
                        </div>
                        <div id="sidebar_bottom"><img src="${pageContext.request.contextPath}/images/new/sidebar_bottom.gif" height="8"/></div>
                    </div>
                </div>

                <div class="clear"><img src="${pageContext.request.contextPath}/images/new/clear.gif" height="30" width="1" /></div>
            </div>

            <div id="container_bottom">
                <div class="float_left"></div>
                <div id="footer">
                    <fmt:message key="general.footer.copyright"/>
                </div>
                <div class="float_right"></div>
            </div>

        </div>

    </body>
</html>