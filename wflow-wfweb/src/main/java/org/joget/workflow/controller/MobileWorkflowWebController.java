package org.joget.workflow.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.ActivityForm;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.joget.commons.util.TimeZoneUtil;
import org.joget.directory.model.User;
import org.joget.form.model.Form;
import org.joget.form.util.FormUtil;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowFacade;
import org.joget.workflow.model.WorkflowPackage;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.WorkflowProcessResult;
import org.joget.workflow.model.WorkflowVariable;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.util.WorkflowUtil;
import org.springframework.beans.factory.annotation.Autowired;

@Controller
public class MobileWorkflowWebController {

    @Autowired
    private WorkflowFacade workflowFacade;

    @RequestMapping(value = "/client/mobile/process/start/(*:processId)")
    public String mobileProcessStart(ModelMap map, HttpServletRequest request, @RequestParam("processId") String processDefId) {
        //decode process def id (to default value)
        processDefId = processDefId.replaceAll(":", "#");
        processDefId = workflowFacade.getConvertedLatestProcessDefId(processDefId);
        map.addAttribute("queryString", request.getQueryString());
        map.addAttribute("complete", request.getParameter("complete"));

        Enumeration enumeration = request.getParameterNames();
        Map<String, String> variables = new HashMap();

        //loop through all parameters to get the workflow variables
        while (enumeration.hasMoreElements()) {
            String paramName = String.valueOf(enumeration.nextElement());
            if (paramName.startsWith("var_")) {
                variables.put(paramName.replace("var_", ""), request.getParameter(paramName));
            }
        }

        if (workflowFacade.isUserInWhiteList(processDefId)) {

            String version = processDefId.split("#")[1];
            Collection<ActivityForm> activityForm = workflowFacade.getFormByActivity(processDefId, Integer.parseInt(version), "runProcess");
            if (activityForm.isEmpty()) {

                WorkflowProcessResult result = workflowFacade.processStart(processDefId);
                if (result != null && result.getActivities() != null && result.getActivities().size() > 0) {
                    WorkflowActivity activityStarted = (WorkflowActivity)result.getActivities().iterator().next();
                    String activityId = activityStarted.getId();
                    map.addAttribute("flag", "true");
                    map.addAttribute("activityId", activityId);
                    return "redirect:/web/client/mobile/assignment/view/" + activityId;
                } else {
                    map.addAttribute("flag", "false");
                    return "workflow/mobileProcessStarted";
                }
            } else {
                map.addAttribute("process", workflowFacade.getProcess(processDefId));
                map.addAttribute("form", activityForm.iterator().next());
                map.addAttribute("username", workflowFacade.getCurrentUsername());
                map.addAttribute("version", version);

                return "workflow/mobileProcessStartWithForm";
            }
        } else {
            return "workflow/mobileProcessStartNoPermission";
        }
    }

    @RequestMapping(value = "/client/mobile/process/list")
    public String mobileProcessList(ModelMap map, @RequestParam(value = "packageId", required = false) String packageId, @RequestParam(value = "allVersion", required = false) String allVersion, @RequestParam(value = "checkWhiteList", required = false) Boolean checkWhiteList) throws IOException {

        if(packageId != null && packageId.trim().length() >0){
            Collection<WorkflowProcess> processList = null;

            if (allVersion != null && allVersion.equals("yes")) {
                processList = workflowFacade.getProcessList(null, false, 0, -1, packageId, true, checkWhiteList);
            } else {
                processList = workflowFacade.getProcessList(null, false, 0, -1, packageId, false, checkWhiteList);
            }

            map.put("processList", processList);
        }else{
            Collection<WorkflowPackage> packageList = workflowFacade.getPackageList();
            map.addAttribute("packageList", packageList);
        }

        return "workflow/mobileProcessList";
    }

    @RequestMapping("/client/mobile/process/view/(*:processId)")
    public String mobileProcessView(ModelMap map, HttpServletRequest request, @RequestParam("processId") String processId) throws IOException {

        //decode process def id (to default value)
        processId = processId.replaceAll(":", "#");

        WorkflowProcess process = workflowFacade.getProcess(processId);
        map.addAttribute("process", process);
        map.addAttribute("queryString", request.getQueryString());

        return "workflow/mobileProcessView";
    }

    @RequestMapping(value = "/client/mobile/assignment/inbox")
    public String mobileAssignmentInbox(ModelMap map) throws IOException {
        Collection<WorkflowAssignment> assignmentList = workflowFacade.getAssignmentPendingAndAcceptedList(null, null, null, "dateCreated", true, 0, -1);

        User user = workflowFacade.getUserByUsername(workflowFacade.getCurrentUsername());
        String gmt = "";
        if (user != null) {
            gmt = user.getTimeZone();
        }
        map.put("total", assignmentList.size());
        map.addAttribute("selectedTimeZone", TimeZoneUtil.getTimeZoneByGMT(gmt));
        map.put("assignmentList", assignmentList);
        return "workflow/mobileInbox";
    }

    @RequestMapping(value = "/client/mobile/assignment/view/(*:activityId)")
    public String mobileAssignmentView(ModelMap map,
            HttpServletRequest request,
            @RequestParam("activityId") String activityId,
            @RequestParam(value = "accept", required = false) String accept) throws IOException {
        WorkflowAssignment assignment = workflowFacade.getAssignment(activityId);

        if (assignment != null) {
            if (Boolean.valueOf(accept).booleanValue() || (assignment.getAssigneeList().size() == 1 && !Boolean.valueOf(accept).booleanValue())) {
                if (assignment != null && !assignment.isAccepted()) {
                    workflowFacade.assignmentAccept(activityId);
                    assignment = workflowFacade.getAssignment(activityId);
                }
            }

            Collection<ActivityForm> form = new ArrayList();

            if (assignment != null) {
                form = workflowFacade.getFormByActivity(assignment.getProcessDefId(), Integer.parseInt(assignment.getProcessVersion()), assignment.getActivityDefId());
            }

            for (ActivityForm temp : form) {
                if (temp.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_EXTERNAL)) {
                    String formUrl = WorkflowUtil.processVariable(temp.getFormUrl(), null, assignment);
                    if (formUrl.indexOf("?") >= 0) {
                        formUrl += "&";
                    } else {
                        formUrl += "?";
                    }
                    temp.setFormUrl(formUrl);
                }
            }

            map.addAttribute("assignment", assignment);

            map.addAttribute("form", form);
            map.addAttribute("username", workflowFacade.getCurrentUsername());
        } else {
            map.addAttribute("error", "nullAssignment");
        }

        User user = workflowFacade.getUserByUsername(workflowFacade.getCurrentUsername());
        String gmt = "";
        if (user != null) {
            gmt = user.getTimeZone();
        }

        map.addAttribute("selectedTimeZone", TimeZoneUtil.getTimeZoneByGMT(gmt));

        return "workflow/mobileAssignmentView";
    }

    @RequestMapping(value = "/client/mobile/assignment/complete/(*:activityId)")
    public String assignmentMobileComplete(ModelMap map, @RequestParam("activityId") String activityId) throws IOException {
        WorkflowAssignment assignment = workflowFacade.getAssignment(activityId);

        String processId = assignment.getProcessId();
        String formId = null;

        //set workflow variable form form data
        Collection<ActivityForm> activityFormList = workflowFacade.getFormByActivity(assignment.getProcessDefId(), Integer.parseInt(assignment.getProcessVersion()), assignment.getActivityDefId());
        if (activityFormList.size() > 0) {
            ActivityForm activityForm = activityFormList.iterator().next();

            if (!activityForm.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_EXTERNAL)) {
                formId = activityForm.getFormId();
                Form form = workflowFacade.getFormById(activityForm.getFormId());
                Form draftForm = workflowFacade.loadDraftDynamicForm(form.getTableName(), processId, activityId);
                if (draftForm != null) {
                    Map<String, String> formData = draftForm.getCustomProperties();

                    form = workflowFacade.getFormById(formData.get("formId"));
                    Iterator it = formData.entrySet().iterator();
                    while (it.hasNext()) {
                        Map.Entry<String, String> pairs = (Map.Entry<String, String>) it.next();
                        String variableName = FormUtil.getWorkflowVariableName(form.getData(), pairs.getKey());
                        if (variableName != null && variableName.trim().length() != 0) {
                            //check if the variable exists in process variable definition list
                            Collection<WorkflowVariable> variableList = workflowFacade.getAssignmentVariableList(activityId);
                            for (WorkflowVariable var : variableList) {
                                if (var.getId().equals(variableName)) {
                                    if (pairs.getValue().trim().length() > 0) {
                                        LogUtil.info(getClass().getName(), "VARIABLE: " + variableName + " = " + pairs.getValue());
                                        workflowFacade.assignmentVariable(activityId, variableName, pairs.getValue());
                                    } else {
                                        if (!FormUtil.isIgnoreVariableIfEmpty(form.getData(), pairs.getKey())) {
                                            LogUtil.info(getClass().getName(), "VARIABLE: " + variableName + " = " + pairs.getValue());
                                            workflowFacade.assignmentVariable(activityId, variableName, pairs.getValue());
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        if (formId != null && formId.trim().length() > 0) {
            //merge or convert draft data to live
            Form form = workflowFacade.getFormById(formId);
            if (form != null) {
                workflowFacade.mergeDraftToLive(form.getTableName(), processId, activityId);
            }
        }

        workflowFacade.assignmentComplete(activityId);
        LogUtil.info(getClass().getName(), "Assignment " + activityId + " completed");

        return "workflow/mobileAssignmentCompleteSuccess";
    }
}