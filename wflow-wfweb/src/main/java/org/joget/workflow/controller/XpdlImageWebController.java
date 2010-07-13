package org.joget.workflow.controller;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.WorkflowFacade;
import org.joget.workflow.util.XpdlImageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class XpdlImageWebController {

    @Autowired
    private WorkflowFacade workflowFacade;

    @RequestMapping("/images/xpdl/thumbnail/(*:processDefId)")
    public void getXpdlThumbnail(OutputStream out, @RequestParam("processDefId") String processDefId, HttpServletRequest request, HttpServletResponse response) {
        try{
            response.setContentType("image/jpeg");

            processDefId = processDefId.replaceAll(":", "#");

            File file = XpdlImageUtil.getXpdlThumbnail(workflowFacade.getDesignerwebBaseUrl(request), processDefId);
            byte[] bbuf = new byte[65536];
            DataInputStream in = new DataInputStream(new FileInputStream(file));

            int length = 0;
            while ((in != null) && ((length = in.read(bbuf)) != -1)) {
                out.write(bbuf, 0, length);
            }

            in.close();
            out.flush();
            out.close();
        }catch(Exception ex){
            LogUtil.error(this.getClass().getName(), ex, "Failed to get XPDL thumbnail [processDefId=" + processDefId + "]");
        }
    }

    @RequestMapping("/images/xpdl/(*:processDefId)")
    public void getXpdlImage(OutputStream out, @RequestParam("processDefId") String processDefId, HttpServletRequest request, HttpServletResponse response) {
        try{
            response.setContentType("image/jpeg");

            processDefId = processDefId.replaceAll(":", "#");

            File file = XpdlImageUtil.getXpdlImage(workflowFacade.getDesignerwebBaseUrl(request), processDefId);
            byte[] bbuf = new byte[65536];
            DataInputStream in = new DataInputStream(new FileInputStream(file));

            int length = 0;
            while ((in != null) && ((length = in.read(bbuf)) != -1)) {
                out.write(bbuf, 0, length);
            }

            in.close();
            out.flush();
            out.close();
        }catch(Exception ex){
            LogUtil.error(this.getClass().getName(), ex, "Failed to get XPDL image [processDefId=" + processDefId + "]");
        }
    }
}
