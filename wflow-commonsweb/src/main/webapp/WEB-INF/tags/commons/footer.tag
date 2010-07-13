<%@ include file="/WEB-INF/jsp/includes/taglibs.jsp" %>

                    </div></div>

                    <div id="content_bottom">
                    <div class="float_left"></div>
                    <div class="float_right"></div>
                    </div>
                    <!-- end content_box -->
                </div>
                <!-- end float_left -->

                <div id="side">
                    <div>
                        <div id="sidebar_top"></div>
                        <div id="sidebar">
                            <h2><fmt:message key="general.footer.sidebar"/></h2>
                            <jsp:include page="/WEB-INF/jsp/includes/sidebar.jsp"/>
                        </div>
                        <div id="sidebar_bottom"></div>
                    </div>
                </div>
                <!-- end sidebar -->

                <div class="clear" style="height: 30px"></div>
            </div>
            <!-- end container-content -->

            <div id="container_bottom">
                <div class="float_left"></div>
                <div id="footer">
                    <fmt:message key="general.footer.copyright"/>
                </div>
                <div class="float_right"></div>
            </div>

        </div>
        <!-- end doc -->

    </body>
</html>
