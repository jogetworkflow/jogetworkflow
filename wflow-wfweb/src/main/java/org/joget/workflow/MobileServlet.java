package org.joget.workflow;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MobileServlet extends HttpServlet{

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  {
        String destination  ="/web/client/mobile/assignment/inbox";
        response.sendRedirect(request.getContextPath()+response.encodeRedirectURL(destination));
    }
}
