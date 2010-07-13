package org.joget.workflow.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class AuditTrailWebController {

    @RequestMapping("/monitoring/audittrail/list")
    public String auditTrailList() {

        return "/audittrail/auditTrailList";
    }
}
