package org.joget.commons.web;

import org.joget.commons.util.LogUtil;
import java.util.Date;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HomeController {

    @RequestMapping({"/home", "/home/(*:message)"})
    public String home(ModelMap map, @RequestParam(value = "message", required = false) String message) {
        if (map != null && message != null) {
            LogUtil.info(getClass().getName(), "message: " + message);
            map.addAttribute("message", message);
        }
        return "home";
    }

    @RequestMapping("/sample/form")
    public String tempForm(ModelMap map) {
        map.addAttribute("date", new Date());
        return "sample/form";
    }
}
