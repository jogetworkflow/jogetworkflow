package org.joget.workflow.controller;

import javax.servlet.http.HttpServletRequest;
import org.joget.commons.util.MobileUtil;
import org.joget.workflow.model.service.UserviewSetupManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.ui.AbstractProcessingFilter;
import org.springframework.security.ui.savedrequest.SavedRequest;
import org.springframework.security.util.UrlUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LoginController {

    @Autowired
    private UserviewSetupManager userviewSetupManager;

    @RequestMapping("/index")
    public String index() {
        return "index";
    }

    @RequestMapping("/login")
    public String login(ModelMap map, HttpServletRequest request) {
        SavedRequest savedRequest = (SavedRequest)request.getSession().getAttribute(AbstractProcessingFilter.SPRING_SECURITY_SAVED_REQUEST_KEY);
        String savedUrl = "";
        if (savedRequest != null) {
            savedUrl = UrlUtils.getRequestUrl(savedRequest);
        } else if (request.getHeader("referer") != null) { //for userview logout
            savedUrl = request.getHeader("referer");
        }

        //mobile login
        if (savedUrl.contains("web/client/mobile/")) {
            if(savedRequest == null){
                return "redirect:/web/client/mobile/assignment/inbox";
            }
            return "mobileLogin";
        }
        if(MobileUtil.mobileDeviceDetect(request)){
            return "redirect:/web/client/mobile/assignment/inbox";
        }
        
        if (savedUrl.contains("web/userview")) {
            String id = savedUrl.substring(savedUrl.lastIndexOf("/") + 1);
            if (id.contains("?")) {
                id = id.substring(0, id.indexOf("?"));
            }
            if(savedRequest == null){
                return "redirect:/web/userview/" + id;
            }
            map.addAttribute("userviewSetup", userviewSetupManager.getUserviewSetup(id));
            return "userview/userviewLogin";
        }
        
        return "login";
    }
}
