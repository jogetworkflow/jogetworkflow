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
                            Oops, a problem has occurred (Code 500)
                        </a>
                    </div>
                </div>
                <!-- close breadcrumbs -->

                <div class="float_left">
                    <div id="content_header" style="width:900px">
                        <div class="float_left"></div>
                        <div id="title">
                            Oops, a problem has occurred.
                        </div>
                        <div class="float_right"></div>

                    </div>

                    <div id="content_box" style="width:898px; min-height:350px">
                        <div style="padding: 20px 10px 20px 10px;">
                            <div style="width:700px">
                                Oops, sorry but an unintended problem has occurred.
                                <br><br>
                                Please click on the link below to display the full error message.
                                If you would like to help report this incident, please copy the full error message and send it to your administrator.
                                <p>&nbsp;</p>
                                <p>&nbsp;</p>
                            </div>

                            <div>
                                <script type="text/javascript">
                                    function showStackTrace() {
                                        document.getElementById("stack_trace").style.display = "block";
                                    }
                                </script>
                                <a href="#" onclick="showStackTrace()">Show Error Message</a>
                                <p>&nbsp;</p>
                                <p>&nbsp;</p>
                            </div>

                            <div id="stack_trace" style="display:none; overflow:auto">
                                <hr />
                                <pre><% exception.printStackTrace(new java.io.PrintWriter(out));%></pre>
                            </div>
                        </div>
                    </div>

                    <div id="content_bottom" style="width:900px">
                        <div class="float_left"></div>
                        <div class="float_right"></div>
                    </div>
                    <!-- end content_box -->
                </div>
                <!-- end float_left -->

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