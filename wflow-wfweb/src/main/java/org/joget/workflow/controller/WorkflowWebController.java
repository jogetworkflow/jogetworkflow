package org.joget.workflow.controller;

import au.com.bytecode.opencsv.CSVWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.DatabaseResourceBundleMessageSource;
import org.joget.commons.util.FileStore;
import org.joget.commons.util.LogUtil;
import org.joget.directory.model.Department;
import org.joget.directory.model.Grade;
import org.joget.directory.model.Group;
import org.joget.directory.model.Organization;
import org.joget.directory.model.User;
import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.dao.grade.GradeDao;
import org.joget.directory.model.dao.group.GroupDao;
import org.joget.directory.model.dao.organization.OrganizationDao;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.form.model.Form;
import org.joget.form.model.service.FormManager;
import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.ActivityPlugin;
import org.joget.workflow.model.ParticipantDirectory;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowFacade;
import java.io.IOException;
import java.util.Collection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowParticipant;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.WorkflowVariable;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.dao.ActivityPluginDao;
import org.joget.workflow.model.dao.ParticipantDirectoryDao;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import org.springframework.web.multipart.MultipartFile;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.joget.workflow.util.WorkflowUtil;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;
import java.util.HashSet;
import java.util.Arrays;
import java.util.Locale;
import java.util.StringTokenizer;
import java.util.TreeMap;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joget.commons.util.MobileUtil;
import org.joget.commons.util.SetupManager;
import org.joget.commons.util.TimeZoneUtil;
import org.joget.directory.model.Employment;
import org.joget.workflow.model.ActivitySetup;
import org.joget.workflow.model.PluginDefaultProperties;
import org.joget.workflow.model.dao.PluginDefaultPropertiesDao;
import org.joget.workflow.model.WorkflowPackage;
import org.joget.workflow.model.WorkflowProcessResult;
import org.joget.workflow.model.service.ImportExportManager;
import org.joget.workflow.util.XpdlImageUtil;
import org.springframework.beans.factory.annotation.Qualifier;

@Controller
public class WorkflowWebController {

    public static final String PACKAGE_ZIP_PREFIX = "package-";

    @Autowired
    private WorkflowUserManager workflowUserManager;
    @Autowired
    private WorkflowFacade workflowFacade;
    @Autowired
    private FormManager formManager;
    @Autowired
    private PluginManager pluginManager;
    @Autowired
    private ActivityPluginDao activityPluginDao;
    @Autowired
    private ActivityFormDao activityFormDao;
    @Autowired
    private ParticipantDirectoryDao participantDirectoryDao;
    @Autowired
    @Qualifier("main")
    private DirectoryManager directoryManager;
    @Autowired
    private GroupDao groupDao;
    @Autowired
    private OrganizationDao organizationDao;
    @Autowired
    private DepartmentDao departmentDao;
    @Autowired
    private GradeDao gradeDao;
    @Autowired
    private DatabaseResourceBundleMessageSource drbms;
    @Autowired
    private ImportExportManager importExportManager;
    @Autowired
    private PluginDefaultPropertiesDao pluginDefaultPropertiesDao;
    @Autowired
    private SetupManager setupManager;

    public WorkflowFacade getWorkflowFacade() {
        return workflowFacade;
    }

    public void setWorkflowFacade(WorkflowFacade workflowFacade) {
        this.workflowFacade = workflowFacade;
    }

    @RequestMapping(value = "/client/process/start/(*:processId)")
    public String processStart(ModelMap map, HttpServletRequest request, @RequestParam("processId") String processDefId, @RequestParam(required=false, value="parentProcessId") String parentProcessId) throws Exception {

        //decode process def id (to default value)
        processDefId = processDefId.replaceAll(":", "#");
        processDefId = workflowFacade.getConvertedLatestProcessDefId(processDefId);

        //escape every parameters in query string to prevent xss
        String encodedQueryString = "";
        String queryString = request.getQueryString();
        if (queryString != null) {
            String[] paramPairs = queryString.split("&");
            for(String paramPair : paramPairs){
                String[] temp = paramPair.split("=");
                if(temp.length == 2){
                    String decodedParam = URLDecoder.decode(temp[1], "UTF-8");
                    decodedParam = decodedParam.replaceAll("<", "&lt;").replaceAll(">", "&gt;");

                    encodedQueryString += temp[0] + "=" + URLEncoder.encode(decodedParam, "UTF-8") + "&";
                }else if(temp.length == 1){
                    encodedQueryString += temp[0] + "&";
                }
            }
            //remove trailing '&'
            encodedQueryString = encodedQueryString.substring(0, encodedQueryString.length() - 1);
        }

        map.addAttribute("queryString", encodedQueryString);
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

            // check for correct process definition ID format
            String[] defArray = processDefId.split("#");
            if (defArray.length < 2) {
                return "error404.jsp";
            }

            String version = defArray[1];
            Collection<ActivityForm> activityForm = activityFormDao.getFormByActivity(processDefId, Integer.parseInt(version), "runProcess");
            if (activityForm.isEmpty()) {

                WorkflowProcessResult result = null;
                if (parentProcessId != null && parentProcessId.trim().length() > 0) {
                    result = workflowFacade.processStartWithLinking(processDefId, parentProcessId, variables);
                } else {
                    result = workflowFacade.processStart(processDefId, variables);
                }
                if (result != null && result.getActivities() != null && result.getActivities().size() > 0) {
                    WorkflowActivity activityStarted = (WorkflowActivity)result.getActivities().iterator().next();
                    String activityId = activityStarted.getId();
                    map.addAttribute("flag", "true");
                    map.addAttribute("activityId", activityId);
                } else {
                    map.addAttribute("flag", "false");
                }

                return "workflow/processStart";
            } else {
                map.addAttribute("process", workflowFacade.getProcess(processDefId));
                map.addAttribute("form", activityForm.iterator().next());
                map.addAttribute("username", workflowUserManager.getCurrentUsername());
                map.addAttribute("version", version);
                map.addAttribute("parentProcessId", parentProcessId);

                return "workflow/processStartWithForm";
            }
        } else {
            return "workflow/processStartNoPermission";
        }
    }

    @RequestMapping(value = "/client/process/startaccept/(*:processId)")
    public String processStartAndAccept(ModelMap map, @RequestParam("processId") String processDefId) {

        //decode process def id (to default value)
        processDefId = processDefId.replaceAll(":", "#");

        if (workflowFacade.isUserInWhiteList(processDefId)) {
            WorkflowProcessResult result = workflowFacade.processStart(processDefId);
            if (result != null && result.getActivities() != null && result.getActivities().size() > 0) {
                WorkflowActivity activityStarted = (WorkflowActivity)result.getActivities().iterator().next();
                String activityId = activityStarted.getId();
                map.addAttribute("flag", "true");
                map.addAttribute("activityId", activityId);

                // accept assignment
                workflowFacade.assignmentAccept(activityId);
                return "redirect:/web/client/assignment/view/" + activityId;
            } else {
                map.addAttribute("flag", "false");
                return "workflow/processStart";
            }
        } else {
            return "workflow/processStartNoPermission";
        }
    }

    @RequestMapping(value = "/client/process/startaccept/embedded/(*:processId)")
    public String processEmbeddedStartAndAccept(ModelMap map, @RequestParam("processId") String processDefId, @RequestParam(value = "complete", required = false) String complete, @RequestParam(value = "withdraw", required = false) String withdraw, @RequestParam(value = "cancel", required = false) String cancel, @RequestParam(value = "save", required = false) String save, @RequestParam(value = "reset", required = false) String reset) {

        //decode process def id (to default value)
        processDefId = processDefId.replaceAll(":", "#");

        WorkflowProcessResult result = workflowFacade.processStart(processDefId);
        if (result != null && result.getActivities() != null && result.getActivities().size() > 0) {
            WorkflowActivity activityStarted = (WorkflowActivity)result.getActivities().iterator().next();
            String activityId = activityStarted.getId();
            map.addAttribute("flag", "true");
            map.addAttribute("activityId", activityId);

            // accept assignment
            workflowFacade.assignmentAccept(activityId);

            if (complete == null) {
                complete = "true";
            }
            if (withdraw == null) {
                withdraw = "true";
            }
            if (cancel == null) {
                cancel = "true";
            }
            if (save == null) {
                save = "true";
            }
            if (reset == null) {
                reset = "true";
            }

            return "redirect:/web/client/assignment/view/embedded/" + activityId + "?complete=" + complete + "&withdraw=" + withdraw + "&save=" + save + "&cancel=" + cancel + "&reset=" + reset;
        } else {
            map.addAttribute("flag", "false");
            return "workflow/processStart";
        }

    }

    @RequestMapping(value = "/client/process/started/(*:processId)")
    public String processStarted(ModelMap map, @RequestParam(value = "processId") String processId) {
        WorkflowProcess process = workflowFacade.getRunningProcessById(processId);
        map.addAttribute("process", process);
        return "workflow/processStarted";
    }

    @RequestMapping(value = "/client/process/list")
    public String processList(ModelMap map, HttpServletRequest request, @RequestParam(value = "packageId", required = false) String packageId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException {
        Collection<WorkflowPackage> packageList = workflowFacade.getPackageList();
        map.addAttribute("packageList", packageList);
        return "workflow/processList";
    }

    @RequestMapping("/monitoring/running/process/list")
    public String packageList(ModelMap model) {
        Collection<WorkflowPackage> packageList = workflowFacade.getPackageList();
        model.addAttribute("packageList", packageList);

        return "workflow/runningProcessList";
    }

    @RequestMapping("/monitoring/running/process/view/(*:id)")
    public String runningProcessView(ModelMap model, @RequestParam("id") String processId) {
        WorkflowProcess wfProcess = workflowFacade.getRunningProcessById(processId);

        double serviceLevelMonitor = workflowFacade.getServiceLevelMonitorForRunningProcess(processId);

        if (serviceLevelMonitor > 0) {
            if (serviceLevelMonitor < 25) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_green\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 25 && serviceLevelMonitor < 50) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_green_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 50 && serviceLevelMonitor < 75) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 75 && serviceLevelMonitor < 100) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow_red\">&nbsp;</span>");
            } else {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_red\">&nbsp;</span>");
            }
        } else {
            model.addAttribute("serviceLevelMonitor", "-");
        }

        WorkflowProcess trackWflowProcess = workflowFacade.getRunningProcessInfo(processId);
        model.addAttribute("wfProcess", wfProcess);
        model.addAttribute("trackWflowProcess", trackWflowProcess);
        return "workflow/runningProcessView";
    }

    @RequestMapping("/monitoring/completed/process/list")
    public String completedPackageList(ModelMap model) {
        Collection<WorkflowPackage> packageList = workflowFacade.getPackageList();
        model.addAttribute("packageList", packageList);
        return "workflow/completedProcessList";
    }

    @RequestMapping("/monitoring/completed/process/view/(*:id)")
    public String completedProcessView(ModelMap model, @RequestParam("id") String processId) {
        WorkflowProcess wfProcess = workflowFacade.getRunningProcessById(processId);

        double serviceLevelMonitor = workflowFacade.getServiceLevelMonitorForRunningProcess(processId);

        if (serviceLevelMonitor > 0) {
            if (serviceLevelMonitor < 25) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_green\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 25 && serviceLevelMonitor < 50) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_green_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 50 && serviceLevelMonitor < 75) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 75 && serviceLevelMonitor < 100) {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow_red\">&nbsp;</span>");
            } else {
                model.addAttribute("serviceLevelMonitor", "<span class=\"dot_red\">&nbsp;</span>");
            }
        } else {
            model.addAttribute("serviceLevelMonitor", "-");
        }

        WorkflowProcess trackWflowProcess = workflowFacade.getRunningProcessInfo(processId);
        model.addAttribute("wfProcess", wfProcess);
        model.addAttribute("trackWflowProcess", trackWflowProcess);
        return "workflow/completedProcessView";
    }

    @RequestMapping("/monitoring/running/process/remove")
    public String removeRunningProcessInstance(ModelMap model, @RequestParam("wfProcessId") String wfProcessId) {
        workflowFacade.removeProcessInstance(wfProcessId);
        return "workflow/runningProcessList";
    }

    @RequestMapping("/monitoring/running/process/removeMultiple")
    public String removeMultipleRunningProcessInstance(ModelMap model, @RequestParam("wfProcessIds") String wfProcessIds) {
        StringTokenizer strToken = new StringTokenizer(wfProcessIds, ",");
        while (strToken.hasMoreTokens()) {
            String wfProcessId = (String) strToken.nextElement();
            workflowFacade.removeProcessInstance(wfProcessId);
        }
        return "workflow/runningProcessList";
    }

    @RequestMapping("/monitoring/completed/process/remove")
    public String removeCompletedProcessInstance(ModelMap model, @RequestParam("wfProcessId") String wfProcessId) {
        workflowFacade.removeProcessInstance(wfProcessId);
        return "workflow/completedProcessList";
    }

    @RequestMapping("/monitoring/completed/process/removeMultiple")
    public String removeMultipleCompletedProcessInstance(ModelMap model, @RequestParam("wfProcessIds") String wfProcessIds) {
        StringTokenizer strToken = new StringTokenizer(wfProcessIds, ",");
        while (strToken.hasMoreTokens()) {
            String wfProcessId = (String) strToken.nextElement();
            workflowFacade.removeProcessInstance(wfProcessId);
        }
        return "workflow/completedProcessList";
    }

    @RequestMapping("/monitoring/running/process/reevaluate")
    public String reevaluateProcess(ModelMap model, @RequestParam("wfProcessId") String wfProcessId) {
        workflowFacade.reevaluateAssignmentsForProcess(wfProcessId);
        return "workflow/runningProcessList";
    }

    @RequestMapping(value = "/monitoring/running/process/abort")
    public String processAbort(ModelMap map, @RequestParam("wfProcessId") String processId) {
        boolean aborted = workflowFacade.processAbort(processId);

        map.addAttribute("aborted", aborted);

        return "redirect:/web/monitoring/running/process/view/" + processId;
    }

    @RequestMapping(value = "/monitoring/running/activity/addSingleUser")
    public String addSingleUser(ModelMap map, @RequestParam("state") String state, @RequestParam("processDefId") String processDefId, @RequestParam("activityId") String activityId, @RequestParam("processId") String processId) {
        map.addAttribute("activityId", activityId);
        map.addAttribute("processId", processId);
        map.addAttribute("state", state);
        map.addAttribute("processDefId", processDefId);

        WorkflowActivity trackWflowActivity = workflowFacade.getRunningActivityInfo(activityId);
        map.addAttribute("trackWflowActivity", trackWflowActivity);

        return "workflow/admin/activityAddSingleUser";
    }

    @RequestMapping(value = "/monitoring/activity/view/(*:id)")
    public String activityView(ModelMap map, @RequestParam("id") String activityId) {
        WorkflowActivity wflowActivity = workflowFacade.getActivityById(activityId);
        Collection<WorkflowVariable> variableList = workflowFacade.getActivityVariableList(activityId);
        double serviceLevelMonitor = workflowFacade.getServiceLevelMonitorForRunningActivity(activityId);
        WorkflowActivity trackWflowActivity = workflowFacade.getRunningActivityInfo(activityId);

        map.addAttribute("activity", wflowActivity);
        map.addAttribute("variableList", variableList);

        if (serviceLevelMonitor > 0) {
            if (serviceLevelMonitor < 25) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_green\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 25 && serviceLevelMonitor < 50) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_green_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 50 && serviceLevelMonitor < 75) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 75 && serviceLevelMonitor < 100) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow_red\">&nbsp;</span>");
            } else {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_red\">&nbsp;</span>");
            }
        } else {
            map.addAttribute("serviceLevelMonitor", "-");
        }

        if (trackWflowActivity != null) {
            map.addAttribute("trackWflowActivity", trackWflowActivity);
            String[] assignmentUsers = trackWflowActivity.getAssignmentUsers();
            if (assignmentUsers != null && assignmentUsers.length > 0) {
                map.addAttribute("assignUserSize", assignmentUsers.length);
            }
        }

        //get form
        String processDefId = wflowActivity.getProcessDefId();
        String version = processDefId.split("#")[1];
        Collection<ActivityForm> formList = activityFormDao.getFormByActivity(wflowActivity.getProcessDefId(), Integer.parseInt(version), wflowActivity.getActivityDefId());

        if (formList != null && !formList.isEmpty()) {
            ActivityForm form = formList.iterator().next();

            if (form.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_SINGLE)) {
                map.addAttribute("version", version);
                map.addAttribute("formId", form.getFormId());
            }
        }

        return "workflow/admin/activityView";
    }

    @RequestMapping(value = "/monitoring/workflow/sla/list")
    public String slaList(ModelMap map) {
        map.addAttribute("processDefinitionList", workflowFacade.getProcessList("name", false, 0, -1, "", true, false));
        return "workflow/sla";
    }

    @RequestMapping("/client/process/view/(*:processId)")
    public String processView(ModelMap map, HttpServletRequest request, @RequestParam("processId") String processId, @RequestParam(value="runDirectly", required = false) String runDirectly) throws Exception {

        if(runDirectly != null &&  "true".equals(runDirectly)){
            return processStart(map, request, processId, null);
        }

        //decode process def id (to default value)
        processId = processId.replaceAll(":", "#");

        WorkflowProcess process = workflowFacade.getProcess(processId);
        map.addAttribute("process", process);
        map.addAttribute("queryString", request.getQueryString());
        return "workflow/processView";
    }

    @RequestMapping("/monitoring/process/graph/(*:id)")
    public String runningProcessGraphView(ModelMap model, @RequestParam("id") String processId) {
        // get process info
        WorkflowProcess wfProcess = workflowFacade.getRunningProcessById(processId);

        // get process xpdl
        byte[] xpdlBytes = workflowFacade.getPackageContent(wfProcess.getPackageId(), wfProcess.getVersion());
        if (xpdlBytes != null) {
            String xpdl = new String(xpdlBytes);

            // get running activities
            Collection<String> runningActivityIdList = new ArrayList<String>();
            List<WorkflowActivity> activityList = workflowFacade.getActivityList("id", Boolean.FALSE, 0, 10000, processId);
            for (WorkflowActivity wa : activityList) {
                if (wa.getState().indexOf("open") >= 0) {
                    runningActivityIdList.add(wa.getActivityDefId());
                }
            }
            String[] runningActivityIds = (String[]) runningActivityIdList.toArray(new String[0]);

            model.addAttribute("wfProcess", wfProcess);
            model.addAttribute("xpdl", xpdl);
            model.addAttribute("runningActivityIds", runningActivityIds);
        }

        return "workflow/runningProcessGraphView";
    }

    @RequestMapping(value = "/client/assignment/pending/list")
    public String assignmentPendingList(ModelMap map, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException {
        return "workflow/assignmentPendingList";
    }

    @RequestMapping(value = "/client/assignment/accepted/list")
    public String assignmentAcceptedList(ModelMap map, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException {
        return "workflow/assignmentAcceptedList";
    }

    @RequestMapping(value = "/client/assignment/inbox")
    public String assignmentInbox(ModelMap map, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException {
        User user = directoryManager.getUserByUsername(workflowUserManager.getCurrentUsername());

        if(user != null){
            map.addAttribute("rssLink", "/web/rss/workflow/assignment/list?j_username="+user.getUsername()+"&hash="+user.getLoginHash());
        }
        return "workflow/inbox";
    }

    @RequestMapping(value = "/client/assignment/history")
    public String assignmentHistory(ModelMap map, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException {
        Collection<WorkflowPackage> packageList = workflowFacade.getPackageList();
        map.addAttribute("packageList", packageList);

        return "workflow/history";
    }

    @RequestMapping(value = "/client/assignment/history/view/(*:id)")
    public String assignmentHistoryView(ModelMap map, @RequestParam("id") String activityId) {
        WorkflowActivity wflowActivity = workflowFacade.getActivityById(activityId);

        double serviceLevelMonitor = workflowFacade.getServiceLevelMonitorForRunningActivity(activityId);
        WorkflowActivity trackWflowActivity = workflowFacade.getRunningActivityInfo(activityId);

        map.addAttribute("activity", wflowActivity);

        if (serviceLevelMonitor > 0) {
            if (serviceLevelMonitor < 25) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_green\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 25 && serviceLevelMonitor < 50) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_green_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 50 && serviceLevelMonitor < 75) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow\">&nbsp;</span>");
            } else if (serviceLevelMonitor >= 75 && serviceLevelMonitor < 100) {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow_red\">&nbsp;</span>");
            } else {
                map.addAttribute("serviceLevelMonitor", "<span class=\"dot_red\">&nbsp;</span>");
            }
        } else {
            map.addAttribute("serviceLevelMonitor", "-");
        }

        if (trackWflowActivity != null) {
            map.addAttribute("trackWflowActivity", trackWflowActivity);
            String[] assignmentUsers = trackWflowActivity.getAssignmentUsers();
            if (assignmentUsers != null && assignmentUsers.length > 0) {
                map.addAttribute("assignUserSize", assignmentUsers.length);
            }
        }

        //get form
        String processDefId = wflowActivity.getProcessDefId();
        String version = processDefId.split("#")[1];
        Collection<ActivityForm> formList = activityFormDao.getFormByActivity(wflowActivity.getProcessDefId(), Integer.parseInt(version), wflowActivity.getActivityDefId());

        if (formList != null && !formList.isEmpty()) {
            ActivityForm form = formList.iterator().next();

            if (form.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_SINGLE)) {
                map.addAttribute("version", version);
                map.addAttribute("formId", form.getFormId());
            }
        }

        String processIntId = wflowActivity.getProcessId();
        WorkflowProcess wfProcess = workflowFacade.getRunningProcessById(processIntId);

        if (wfProcess != null) {
            map.addAttribute("processStatus", (wfProcess.getState() != null) ? wfProcess.getState() : "");
        }

        User user = directoryManager.getUserByUsername(workflowUserManager.getCurrentUsername());
        String gmt = "";
        if (user != null) {
            gmt = user.getTimeZone();
        }

        map.addAttribute("selectedTimeZone", TimeZoneUtil.getTimeZoneByGMT(gmt));

        return "workflow/historyView";
    }

    @RequestMapping({"/client/assignment/view/(*:activityId)", "/client/assignment/login/view/(*:activityId)"})
    public String assignmentView(ModelMap map,
            HttpServletRequest request,
            @RequestParam("activityId") String activityId,
            @RequestParam(value = "accept", required = false) String accept) throws IOException {

        if(MobileUtil.mobileDeviceDetect(request)){
            return "redirect:/web/client/mobile/assignment/view/"+activityId;
        }

        WorkflowAssignment assignment = workflowFacade.getAssignment(activityId);

        if (assignment != null) {
            if (Boolean.valueOf(accept).booleanValue() || (assignment.getAssigneeList().size() == 1 && !Boolean.valueOf(accept).booleanValue())) {
                if (assignment != null && !assignment.isAccepted()) {
                    workflowFacade.assignmentAccept(activityId);
                    assignment = workflowFacade.getAssignment(activityId);
                }
            }

            Collection<WorkflowVariable> variableList = workflowFacade.getAssignmentVariableList(activityId);
            Collection<ActivityForm> form = new ArrayList();

            if (assignment != null) {
                form = activityFormDao.getFormByActivity(assignment.getProcessDefId(), Integer.parseInt(assignment.getProcessVersion()), assignment.getActivityDefId());
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

            double serviceLevelMonitor = workflowFacade.getServiceLevelMonitorForRunningActivity(activityId);

            if (serviceLevelMonitor > 0) {
                if (serviceLevelMonitor < 25) {
                    map.addAttribute("serviceLevelMonitor", "<span class=\"dot_green\">&nbsp;</span>");
                } else if (serviceLevelMonitor >= 25 && serviceLevelMonitor < 50) {
                    map.addAttribute("serviceLevelMonitor", "<span class=\"dot_green_yellow\">&nbsp;</span>");
                } else if (serviceLevelMonitor >= 50 && serviceLevelMonitor < 75) {
                    map.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow\">&nbsp;</span>");
                } else if (serviceLevelMonitor >= 75 && serviceLevelMonitor < 100) {
                    map.addAttribute("serviceLevelMonitor", "<span class=\"dot_yellow_red\">&nbsp;</span>");
                } else {
                    map.addAttribute("serviceLevelMonitor", "<span class=\"dot_red\">&nbsp;</span>");
                }
            } else {
                map.addAttribute("serviceLevelMonitor", "-");
            }

            map.addAttribute("variableList", variableList);
            map.addAttribute("form", form);
            map.addAttribute("username", workflowUserManager.getCurrentUsername());
        } else {
            map.addAttribute("error", "nullAssignment");
        }

        User user = directoryManager.getUserByUsername(workflowUserManager.getCurrentUsername());
        String gmt = "";
        if (user != null) {
            gmt = user.getTimeZone();
        }

        map.addAttribute("selectedTimeZone", TimeZoneUtil.getTimeZoneByGMT(gmt));

        if (MobileUtil.mobileDeviceDetect(request)) {
            return "workflow/assignmentMobileView";
        } else {
            return "workflow/assignmentView";
        }
    }

    @RequestMapping({"/client/assignment/completed"})
    public String assignmentCompletedAndRedirect(ModelMap map) throws IOException {
        return "workflow/assignmentCompleted";
    }

    @RequestMapping("/client/assignment/view/embedded/(*:activityId)")
    public String assignmentEmbeddedView(ModelMap map,
            HttpServletRequest request,
            @RequestParam("activityId") String activityId,
            @RequestParam(value = "accept", required = false) String accept) throws IOException {
        assignmentView(map, request, activityId, accept);
        return "workflow/assignmentEmbeddedView";
    }

    @RequestMapping("/client/assignment/process/view/(*:processId)")
    public String assignmentViewByProcess(ModelMap map, @RequestParam("processId") String processId, @RequestParam(value = "accept", required = false) String accept) throws IOException {
        WorkflowAssignment assignment = workflowFacade.getAssignmentByProcess(processId);
        if (Boolean.valueOf(accept).booleanValue()) {
            // auto accept
            if (assignment != null && !assignment.isAccepted()) {
                workflowFacade.assignmentAccept(assignment.getActivityId());
                assignment = workflowFacade.getAssignment(assignment.getActivityId());
            }
        }

        Collection<WorkflowVariable> variableList = null;
        if (assignment != null) {
            variableList = workflowFacade.getAssignmentVariableList(assignment.getActivityId());
        }

        Collection<ActivityForm> form = new ArrayList();

        if (assignment != null) {
            form = activityFormDao.getFormByActivity(assignment.getProcessDefId(), Integer.parseInt(assignment.getProcessVersion()), assignment.getActivityDefId());
        }

        map.addAttribute("assignment", assignment);
        map.addAttribute("variableList", variableList);
        map.addAttribute("form", form);
        map.addAttribute("username", workflowUserManager.getCurrentUsername());
        return "workflow/assignmentView";
    }

    @RequestMapping("/client/assignment/process/view/embedded/(*:processId)")
    public String assignmentEmbeddedViewByProcess(ModelMap map, @RequestParam("processId") String processId, @RequestParam(value = "accept", required = false) String accept) throws IOException {
        assignmentViewByProcess(map, processId, accept);
        return "workflow/assignmentEmbeddedView";
    }

    @RequestMapping("/admin/package/upload")
    public String packageUpload(ModelMap map) throws IOException {
        User user = directoryManager.getUserByUsername(workflowUserManager.getCurrentUsername());
        map.addAttribute("loginHash", user.getLoginHash());
        map.addAttribute("username", user.getUsername());
        return "workflow/admin/packageUpload";
    }

    @RequestMapping(value = "/admin/package/upload/submit", method = RequestMethod.POST)
    public String packageUploadSubmit(ModelMap map, HttpServletRequest request) throws IOException {
        MultipartFile packageXpdl = FileStore.getFile("packageXpdl");

        String packageId = "";
        try {
            packageId = workflowFacade.processUpload(null, packageXpdl.getBytes());

            List<WorkflowProcess> processList = workflowFacade.getProcessList("", Boolean.TRUE, 0, 10000, packageId, Boolean.FALSE, Boolean.FALSE);
            for(WorkflowProcess process : processList){
                XpdlImageUtil.generateXpdlImage(workflowFacade.getDesignerwebBaseUrl(request), process.getId(), true);
            }

        } catch (Throwable e) {
            map.addAttribute("errorMessage", e.getMessage());
            return "workflow/admin/packageUpload";
        }

        return "redirect:/web/admin/process/configure/list?packageId=" + packageId;
    }

    @RequestMapping(value = "/admin/package/update/submit", method = RequestMethod.POST)
    public String packageUpdateSubmit(ModelMap map, @RequestParam("packageId") String packageId, HttpServletRequest request) throws IOException {
        MultipartFile packageXpdl = FileStore.getFile("packageXpdlUpdate");

        try {
            workflowFacade.processUpload(packageId, packageXpdl.getBytes());

            List<WorkflowProcess> processList = workflowFacade.getProcessList("", Boolean.TRUE, 0, 10000, packageId, Boolean.FALSE, Boolean.FALSE);
            for (WorkflowProcess process : processList) {
                XpdlImageUtil.generateXpdlImage(workflowFacade.getDesignerwebBaseUrl(request), process.getId(), true);
            }
        } catch (Throwable e) {
            map.addAttribute("errorMessage", e.getMessage());
            return "workflow/admin/processConfigureUpdateXpdl";
        }

        map.addAttribute("packageId", packageId);
        return "workflow/admin/processConfigureUpdateXpdlSuccess";
    }

    @RequestMapping("/admin/process/configure/list")
    public String processConfigureList(ModelMap map) {
        Collection<WorkflowPackage> packageList = workflowFacade.getPackageList();
        map.addAttribute("packageList", packageList);
        return "workflow/admin/processConfigureList";
    }

    @RequestMapping("/admin/process/configure/remove")
    public String processConfigureRemove(ModelMap map, @RequestParam("packageId") String pId, @RequestParam("version") String version) {
        String packageId = pId.split("#")[0];

        // delete and unload process
        workflowFacade.processDeleteAndUnloadVersion(packageId, version);

        return "redirect:/web/admin/process/configure/list";
    }

    @RequestMapping("/admin/process/configure/updateXpdl")
    public String processConfigureUpdateXpdl(ModelMap map, @RequestParam("packageId") String packageId) {
        map.addAttribute("packageId", packageId);
        return "workflow/admin/processConfigureUpdateXpdl";
    }

    @RequestMapping("/admin/process/configure/view/(*:processId)")
    public String processConfigureView(ModelMap map, @RequestParam("processId") String processId) {

        //decode process def id (to default value)
        processId = processId.replaceAll(":", "#");

        WorkflowProcess process = workflowFacade.getProcess(processId);

        if (process == null) {
            return "redirect:/web/admin/process/configure/list";
        }

        //get activity list
        Collection<WorkflowActivity> activityList = workflowFacade.getProcessActivityDefinitionList(processId);

        //add 'Run Process' activity to activityList
        WorkflowActivity runProcessActivity = new WorkflowActivity();
        runProcessActivity.setId("runProcess");
        runProcessActivity.setName("Run Process");
        runProcessActivity.setType("normal");
        activityList.add(runProcessActivity);

        //remove route
        Iterator iterator = activityList.iterator();
        while (iterator.hasNext()) {
            WorkflowActivity activity = (WorkflowActivity) iterator.next();
            if (activity.getType().equals(WorkflowActivity.TYPE_ROUTE)) {
                iterator.remove();
            }
        }

        //get activity plugin mapping
        Map<String, Plugin> pluginMap = new HashMap<String, Plugin>();
        for (WorkflowActivity activity : activityList) {
            ActivityPlugin activityPlugin = activityPluginDao.getPlugin(processId, Integer.parseInt(process.getVersion()), activity.getId());
            if (activityPlugin != null) {
                Plugin plugin = pluginManager.getPlugin(activityPlugin.getPluginName());
                pluginMap.put(activity.getId(), plugin);
            }
        }

        //get activity form mapping
        Map<String, Collection<Form>> formMap = new HashMap<String, Collection<Form>>();
        for (WorkflowActivity activity : activityList) {
            Collection<ActivityForm> activityFormList = activityFormDao.getFormByActivity(processId, Integer.parseInt(process.getVersion()), activity.getId());

            Collection formList = new ArrayList();
            for (ActivityForm activityForm : activityFormList) {
                if (!activityForm.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_EXTERNAL)) {
                    if (activityForm.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_SINGLE)) {
                        Form form = formManager.getFormById(activityForm.getFormId());
                        formList.add(form);
                    } else if (activityForm.getType().contains(ActivityFormDao.ACTIVITY_FORM_TYPE_MULTI)) {
                    }
                } else {
                    formList.add(activityForm.getFormUrl());
                }
            }

            formMap.put(activity.getId(), formList);
        }

        //get activity setup
        Map<String, ActivitySetup> activitySetupList = new HashMap<String, ActivitySetup>();
        for (WorkflowActivity activity : activityList) {
            ActivitySetup setup = workflowFacade.getActivitySetup(processId, activity.getId());

            if(setup != null){
                activitySetupList.put(activity.getId(), setup);
            }
        }

        //get variable list
        Collection<WorkflowVariable> variableList = workflowFacade.getProcessVariableDefinitionList(processId);

        //get participant list
        Collection<WorkflowParticipant> participantList = workflowFacade.getParticipantList(processId);

        WorkflowParticipant processStartWhiteList = new WorkflowParticipant();
        processStartWhiteList.setId("processStartWhiteList");
        processStartWhiteList.setName(drbms.getMessage("wflowAdmin.processConfiguration.view.label.processStartWhiteList", new Object[]{}, Locale.getDefault()));
        processStartWhiteList.setPackageLevel(false);
        participantList.add(processStartWhiteList);

        //get participant mapping
        Map<String, Collection> participantMap = new TreeMap<String, Collection>();
        for (WorkflowParticipant participant : participantList) {
            Collection<ParticipantDirectory> participantDirectoryList = null;
            List mappedObject = new ArrayList();

            if (!participant.isPackageLevel()) {
                participantDirectoryList = participantDirectoryDao.getMappingByParticipantId(process.getPackageId(), processId, Integer.parseInt(process.getVersion()), participant.getId());
            } else {
                participantDirectoryList = participantDirectoryDao.getMappingByParticipantId(process.getPackageId(), null, Integer.parseInt(process.getVersion()), participant.getId());
            }

            for (ParticipantDirectory pd : participantDirectoryList) {
                mappedObject.add(getParticipantMappingObject(pd, processId));
            }

            participantMap.put(participant.getId(), mappedObject);
        }

        map.addAttribute("process", process);
        map.addAttribute("activityList", activityList);
        map.addAttribute("pluginMap", pluginMap);
        map.addAttribute("formMap", formMap);
        map.addAttribute("variableList", variableList);
        map.addAttribute("participantList", participantList);
        map.addAttribute("participantMap", participantMap);
        map.addAttribute("activitySetupList", activitySetupList);

        //for launching workflow designer
        User user = directoryManager.getUserByUsername(workflowUserManager.getCurrentUsername());
        map.addAttribute("loginHash", user.getLoginHash());
        map.addAttribute("username", user.getUsername());

        return "workflow/admin/processConfigureView";
    }

    @RequestMapping("/admin/process/activity/plugin/add")
    public String activityAddPlugin(ModelMap map, @RequestParam("activityId") String activityId, @RequestParam("processId") String processId, @RequestParam("version") String version) {
        WorkflowProcess process = workflowFacade.getProcess(processId);
        WorkflowActivity activity = workflowFacade.getActivityById(processId, activityId);
        map.addAttribute("process", process);
        map.addAttribute("activity", activity);
        return "workflow/admin/activityAddPluginList";
    }

    @RequestMapping("/admin/process/activity/plugin/add/submit")
    public String activityAddPluginSubmit(ModelMap map, @RequestParam("activityId") String activityId, @RequestParam("processId") String processId, @RequestParam("version") String version, @RequestParam("id") String pluginName) throws UnsupportedEncodingException {
        //remove existing plugin
        activityPluginDao.removePluginFromActivity(processId, Integer.parseInt(version), activityId);

        String activityPluginId = activityPluginDao.setPluginToActivity(pluginName, processId, Integer.parseInt(version), activityId);
        map.addAttribute("activityId", activityId);
        map.addAttribute("processId", URLEncoder.encode(processId, "UTF-8"));
        map.addAttribute("version", version);
        return "workflow/admin/activityAddPluginSuccess";
    }

    @RequestMapping("/admin/process/activity/plugin/remove")
    public String activityRemovePlugin(@RequestParam("activityId") String activityId, @RequestParam("processId") String processId, @RequestParam("version") String version) {
        activityPluginDao.removePluginFromActivity(processId, Integer.parseInt(version), activityId);
        return "workflow/admin/activityAddPluginSuccess";
    }

    @RequestMapping("/admin/process/activity/plugin/configure")
    public String activityPluginConfigure(ModelMap map, @RequestParam("processId") String processId, @RequestParam("activityId") String activityId, @RequestParam("version") String version) throws IOException {
        ActivityPlugin activityPlugin = activityPluginDao.getPlugin(processId, Integer.parseInt(version), activityId);
        Plugin plugin = pluginManager.getPlugin(activityPlugin.getPluginName());

        Map propertyMap = new HashMap();
        if (activityPlugin.getPluginProperties() != null && activityPlugin.getPluginProperties().trim().length() > 0) {
            propertyMap = CsvUtil.getPluginPropertyMap(activityPlugin.getPluginProperties());
        }

        PluginDefaultProperties pluginDefaultProperties = pluginDefaultPropertiesDao.find(activityPlugin.getPluginName());
        Map defaultPropertyMap = new HashMap();
        if (pluginDefaultProperties != null) {
            String properties = pluginDefaultProperties.getPluginProperties();
            if (properties != null && properties.trim().length() > 0) {
                defaultPropertyMap = CsvUtil.getPluginPropertyMap(properties);
            }
        }

        map.addAttribute("plugin", plugin);
        map.addAttribute("propertyMap", propertyMap);
        map.addAttribute("defaultPropertyMap", defaultPropertyMap);
        map.addAttribute("activityPluginId", activityPlugin.getId());
        return "workflow/admin/activityPluginConfig";
    }

    @RequestMapping("/admin/process/activity/plugin/configure/submit")
    public String activityPluginConfigureSubmit(ModelMap map, @RequestParam("activityPluginId") String activityPluginId, HttpServletRequest request) {
        //remove existing properties
        activityPluginDao.removePluginProperties(activityPluginId);

        //request params
        Map<String, String> propertyMap = new HashMap();
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //ignore the parameter "activityPluginId"
            if (!paramName.equals("activityPluginId")) {
                String[] paramValue = (String[]) request.getParameterValues(paramName);
                propertyMap.put(paramName, CsvUtil.getDeliminatedString(paramValue));
            }
        }

        StringWriter sw = new StringWriter();
        try {
            CSVWriter writer = new CSVWriter(sw);
            Iterator it = propertyMap.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<String, String> pairs = (Map.Entry) it.next();
                writer.writeNext(new String[]{pairs.getKey(), pairs.getValue()});
            }
            writer.close();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
        activityPluginDao.setPluginProperties(activityPluginId, sw.toString());

        return "workflow/admin/activityPluginConfigSuccess";
    }

    @RequestMapping("/admin/process/activity/form/add")
    public String activityAddForm(ModelMap map, @RequestParam("activityId") String activityId, @RequestParam("processId") String processId, @RequestParam("version") String version) {
        WorkflowProcess process = workflowFacade.getProcess(processId);
        WorkflowActivity activity = workflowFacade.getActivityById(processId, activityId);

        if (activityId.equals("runProcess")) {
            activity = new WorkflowActivity();
            activity.setId("runProcess");
            activity.setName("Run Process");
        }

        Collection<ActivityForm> existingFormList = activityFormDao.getFormByActivity(processId, Integer.parseInt(version), activityId);
        if (existingFormList.iterator().hasNext()) {
            ActivityForm af = existingFormList.iterator().next();
            if(af.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_EXTERNAL)){
                map.addAttribute("externalFormUrl", af.getFormUrl());
                map.addAttribute("externalFormIFrameStyle", af.getFormIFrameStyle());
            }
        }

        map.addAttribute("process", process);
        map.addAttribute("activity", activity);
        map.addAttribute("categoryList", formManager.getCategories(null, null, null, null));
        map.addAttribute("formList", formManager.getForms(null, null, null, null, null));

        return "workflow/admin/activityAddForm";
    }

    @RequestMapping("/admin/process/activity/form/add/submit")
    public String activityAddFormSubmit(@RequestParam("activityId") String activityId,
            @RequestParam("processId") String processId,
            @RequestParam("version") String version,
            @RequestParam(value = "id", required = false) String formId,
            @RequestParam(value = "type", required = false) String type,
            @RequestParam(value = "externalFormUrl", required = false) String externalFormUrl,
            @RequestParam(value = "externalFormIFrameStyle", required = false) String externalFormIFrameStyle) {
        //remove existing mapping
        activityFormDao.unassignAllFormFromActivity(processId, Integer.parseInt(version), activityId);

        if (type != null && type.equals("external") && externalFormUrl != null) {
            activityFormDao.assignExternalFormToActivity(externalFormUrl, externalFormIFrameStyle, processId, Integer.parseInt(version), activityId);
        } else {
            String[] ids = formId.split(",");
            if (ids.length > 1) {
                //for multi form support
            } else {
                activityFormDao.assignSingleFormToActivity(formId, processId, Integer.parseInt(version), activityId);
            }
        }
        return "workflow/admin/activityAddFormSuccess";
    }

    @RequestMapping(value = "/admin/process/activity/form/remove", method = RequestMethod.POST)
    public String activityRemoveForm(@RequestParam("activityId") String activityId, @RequestParam("processId") String processId, @RequestParam("version") String version) {
        activityFormDao.unassignAllFormFromActivity(processId, Integer.parseInt(version), activityId);
        return "workflow/admin/activityAddForm";
    }

    @RequestMapping("/admin/process/participant/user/add")
    public String participantAddUser(ModelMap map, @RequestParam("participantId") String participantId, @RequestParam("processId") String processId, @RequestParam("version") String version) {
        WorkflowProcess process = workflowFacade.getProcess(processId);
        WorkflowParticipant participant = workflowFacade.getParticipantMap(processId).get(participantId);

        if (participantId.equals("processStartWhiteList")) {
            participant = new WorkflowParticipant();
            participant.setId("processStartWhiteList");
            participant.setPackageLevel(false);
        }

        //get existing mapping
        Collection<ParticipantDirectory> existingUserList = null;
        if (!participant.isPackageLevel()) {
            existingUserList = participantDirectoryDao.getMappingByParticipantId(process.getPackageId(), processId, Integer.parseInt(version), participantId);
        } else {
            existingUserList = participantDirectoryDao.getMappingByParticipantId(process.getPackageId(), null, Integer.parseInt(version), participantId);
        }

        //get corresponding object from user mapping
        if (existingUserList.iterator().hasNext()) {
            ParticipantDirectory pd = existingUserList.iterator().next();
            map.addAttribute("participantDirectoryId", pd.getId());
            map.addAttribute("mappedObject", getParticipantMappingObject(pd, processId));
        }

        //get groups, users, departments etc etc
        Collection<Group> groupList = groupDao.getGroupList("", null, null, null, null);
        Collection<Organization> organizationList = organizationDao.getOrganizationList("", null, null, null, null);
        Collection<Department> departmentList = departmentDao.getDepartmentList("", null, null, null, null);
        Collection<Grade> gradeList = gradeDao.getGradeList("", null, null, null, null);
        Collection<WorkflowVariable> workflowVariableList = workflowFacade.getProcessVariableDefinitionList(processId);
        Collection<WorkflowParticipant> participantList = workflowFacade.getParticipantList(processId);
        Collection<WorkflowActivity> activityList = workflowFacade.getProcessActivityDefinitionList(processId);

        //add 'Run Process' activity to activityList
        WorkflowActivity runProcessActivity = new WorkflowActivity();
        runProcessActivity.setId("runProcess");
        runProcessActivity.setName("Run Process");
        runProcessActivity.setType("normal");
        activityList.add(runProcessActivity);

        //remove route
        Iterator iterator = activityList.iterator();
        while (iterator.hasNext()) {
            WorkflowActivity activity = (WorkflowActivity) iterator.next();
            if ((activity.getType().equals(WorkflowActivity.TYPE_ROUTE)) || (activity.getType().equals(WorkflowActivity.TYPE_TOOL))) {
                iterator.remove();
            }
        }

        map.addAttribute("process", process);
        map.addAttribute("participant", participant);

        map.addAttribute("activityList", activityList);
        map.addAttribute("groupList", groupList);
        map.addAttribute("organizationList", organizationList);
        map.addAttribute("departmentList", departmentList);
        map.addAttribute("gradeList", gradeList);
        map.addAttribute("workflowVariableList", workflowVariableList);

        map.addAttribute("participantList", participantList);

        if (participantId.equals("processStartWhiteList")) {
            return "workflow/admin/whiteListAddUser";
        } else {
            return "workflow/admin/participantAddUser";
        }
    }

    @RequestMapping("/admin/process/participant/user/add/submit")
    public String participantAddUserSubmit(ModelMap map,
            @RequestParam("packageId") String packageId,
            @RequestParam("processId") String processId,
            @RequestParam("version") String version,
            @RequestParam("participantId") String participantId,
            @RequestParam("participantType") String participantType,
            @RequestParam(value = "activity", required = false) String activity,
            @RequestParam(value = "group", required = false) String group,
            @RequestParam(value = "user", required = false) String user,
            @RequestParam(value = "organization", required = false) String organization,
            @RequestParam(value = "department", required = false) String department,
            @RequestParam(value = "grade", required = false) String grade,
            @RequestParam(value = "workflowVariable", required = false) String workflowVariable,
            @RequestParam(value = "workflowVariableType", required = false) String workflowVariableType) {
        WorkflowProcess process = workflowFacade.getProcess(processId);

        WorkflowParticipant participant = workflowFacade.getParticipantMap(processId).get(participantId);

        if (participantId.equals("processStartWhiteList")) {
            participant = new WorkflowParticipant();
            participant.setId("processStartWhiteList");
            participant.setPackageLevel(false);
        }

        String mappingId = "";

        if (participant.isPackageLevel()) {
            processId = null;
        }

        //get existing mapping
        Collection<ParticipantDirectory> existingUserList = null;
        if (!participant.isPackageLevel()) {
            existingUserList = participantDirectoryDao.getMappingByParticipantId(packageId, processId, Integer.parseInt(version), participantId);
        } else {
            existingUserList = participantDirectoryDao.getMappingByParticipantId(packageId, null, Integer.parseInt(version), participantId);
        }

        //get corresponding object from user mapping
        if (existingUserList.iterator().hasNext()) {
            ParticipantDirectory pd = existingUserList.iterator().next();
            if(participantType.equals("user") && pd.getType().equals("USER") && pd.getValue() != null & pd.getValue().length() > 0){
                user += "," + pd.getValue();
            }else if(participantType.equals("group") && pd.getType().equals("GROUP") && pd.getValue() != null &&  pd.getValue().length() > 0){
                group += "," + pd.getValue();
            }
        }

        //remove duplicate entry
        if(user != null && !user.equals("")){
            List<String> tempList = Arrays.asList(user.split(","));
            HashSet<String> tempHashSet = new HashSet<String>(tempList);
            String[] tempResult = new String[tempHashSet.size()];
            tempHashSet.toArray(tempResult);
            user = "";
            for (String s : tempResult) {
                user += s + ",";
            }
            user = user.substring(0, user.length() -1);
        }else if(group != null && !group.equals("")){
            List<String> tempList = Arrays.asList(group.split(","));
            HashSet<String> tempHashSet = new HashSet<String>(tempList);
            String[] tempResult = new String[tempHashSet.size()];
            tempHashSet.toArray(tempResult);
            group = "";
            for (String s : tempResult) {
                group += s + ",";
            }
            group = group.substring(0, group.length() -1);
        }

        //remove all existing mapping
        for (ParticipantDirectory temp : existingUserList) {
            participantDirectoryDao.removeMapping(temp.getId());
        }

        if (participantType.equals("group")) {
            String[] groupList = group.split(",");
            mappingId = participantDirectoryDao.setGroupAsParticipant(groupList, packageId, processId, Integer.parseInt(version), participantId);

        } else if (participantType.equals("user")) {
            String[] userList = user.split(",");
            mappingId = participantDirectoryDao.setUserAsParticipant(userList, packageId, processId, Integer.parseInt(version), participantId);

        } else if (participantType.equals("requester")) {
            if (activity == null || activity.trim().length() == 0) {
                mappingId = participantDirectoryDao.setRequesterAsParticipant(packageId, processId, Integer.parseInt(version), participantId);
            } else {
                mappingId = participantDirectoryDao.setActivityPerformerAsParticipant(activity, packageId, processId, Integer.parseInt(version), participantId);
            }
        } else if (participantType.equals("requesterHod")) {
            if (activity == null || activity.trim().length() == 0) {
                mappingId = participantDirectoryDao.setRequesterHodAsParticipant(packageId, processId, Integer.parseInt(version), participantId);
            } else {
                mappingId = participantDirectoryDao.setActivityPerformerHodAsParticipant(activity, packageId, processId, Integer.parseInt(version), participantId);
            }
        } else if (participantType.equals("requesterSubordinates")) {
            if (activity == null || activity.trim().length() == 0) {
                mappingId = participantDirectoryDao.setRequesterSubordinateAsParticipant(packageId, processId, Integer.parseInt(version), participantId);
            } else {
                mappingId = participantDirectoryDao.setActivityPerformerSubordinateAsParticipant(activity, packageId, processId, Integer.parseInt(version), participantId);
            }
        } else if (participantType.equals("requesterDepartment")) {
            if (activity == null || activity.trim().length() == 0) {
                mappingId = participantDirectoryDao.setRequesterDepartmentAsParticipant(packageId, processId, Integer.parseInt(version), participantId);
            } else {
                mappingId = participantDirectoryDao.setActivityPerformerDepartmentAsParticipant(activity, packageId, processId, Integer.parseInt(version), participantId);
            }
        } else if (participantType.equals("hod")) {
            mappingId = participantDirectoryDao.setDepartmentHodAsParticipant(department, packageId, processId, Integer.parseInt(version), participantId);

        } else if (participantType.equals("department")) {
            mappingId = participantDirectoryDao.setDepartmentAsParticipant(department, packageId, processId, Integer.parseInt(version), participantId);

        } else if (participantType.equals("departmentGrade")) {
            mappingId = participantDirectoryDao.setDepartmentGradeAsParticipant(department, grade, packageId, processId, Integer.parseInt(version), participantId);

        } else if (participantType.equals("workflowVariable")) {
            mappingId = participantDirectoryDao.setWorkflowVariableAsParticipant(workflowVariable, workflowVariableType, packageId, processId, Integer.parseInt(version), participantId);

        }

        return "workflow/admin/participantAddUserSuccess";
    }

    @RequestMapping("/admin/process/participant/user/plugin/add/submit")
    public void participantAddUserPluginSubmit(Writer writer,
            @RequestParam("packageId") String packageId,
            @RequestParam("processId") String processId,
            @RequestParam("version") String version,
            @RequestParam("participantId") String participantId,
            @RequestParam("plugin") String pluginName) throws IOException {
        WorkflowParticipant participant = workflowFacade.getParticipantMap(processId).get(participantId);

        String tempProcessId = processId;
        if (participant != null && participant.isPackageLevel()) {
            tempProcessId = null;
        }

        Collection<ParticipantDirectory> list = participantDirectoryDao.getMappingByParticipantId(packageId, tempProcessId, Integer.parseInt(version), participantId);
        //remove all existing mapping
        for (ParticipantDirectory temp : list) {
            participantDirectoryDao.removeMapping(temp.getId());
        }

        String participantDirectoryId = participantDirectoryDao.setPluginAsParticipant(pluginName, packageId, tempProcessId, Integer.parseInt(version), participantId);

        //go to plugin configuration
        String paramString = "participantId=" + participantId + "&packageId=" + packageId + "&processId=" + URLEncoder.encode(processId, "UTF-8") + "&version=" + version;
        writer.write(paramString);
    }

    @RequestMapping("/admin/process/participant/user/plugin/config")
    public String participantAddUserPluginConfig(ModelMap map,
            @RequestParam("packageId") String packageId,
            @RequestParam("processId") String processId,
            @RequestParam("version") String version,
            @RequestParam("participantId") String participantId) throws Exception {

        WorkflowParticipant participant = workflowFacade.getParticipantMap(processId).get(participantId);

        if (participant != null && participant.isPackageLevel()) {
            processId = null;
        }

        Collection<ParticipantDirectory> participantDirectoryList = participantDirectoryDao.getMappingByParticipantId(packageId, processId, Integer.parseInt(version), participantId);
        ParticipantDirectory participantDirectory = participantDirectoryList.iterator().next();

        Map propertyMap = new HashMap();
        if (participantDirectory.getPluginProperties() != null && participantDirectory.getPluginProperties().trim().length() > 0) {
            propertyMap = CsvUtil.getPluginPropertyMap(participantDirectory.getPluginProperties());
        }

        PluginDefaultProperties pluginDefaultProperties = pluginDefaultPropertiesDao.find(participantDirectory.getValue());
        Map defaultPropertyMap = new HashMap();
        if (pluginDefaultProperties != null) {
            String properties = pluginDefaultProperties.getPluginProperties();
            if (properties != null && properties.trim().length() > 0) {
                defaultPropertyMap = CsvUtil.getPluginPropertyMap(properties);
            }
        }

        Plugin plugin = pluginManager.getPlugin(participantDirectory.getValue());
        map.addAttribute("participantDirectoryId", participantDirectory.getId());
        map.addAttribute("propertyMap", propertyMap);
        map.addAttribute("defaultPropertyMap", defaultPropertyMap);
        map.addAttribute("plugin", plugin);
        return "workflow/admin/participantPluginConfig";
    }

    @RequestMapping(value = "/admin/process/participant/user/plugin/config/submit", method = RequestMethod.POST)
    public String participantAddUserPluginConfigSubmit(ModelMap map, @RequestParam("participantDirectoryId") String participantDirectoryId, HttpServletRequest request) {
        ParticipantDirectory participantDirectory = participantDirectoryDao.find(participantDirectoryId);

        //request params
        Map<String, String> propertyMap = new HashMap();
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //ignore the parameter "participantDirectoryId"
            if (!paramName.equals("participantDirectoryId")) {
                String[] paramValue = (String[]) request.getParameterValues(paramName);
                propertyMap.put(paramName, CsvUtil.getDeliminatedString(paramValue));
            }
        }

        StringWriter sw = new StringWriter();
        try {
            CSVWriter writer = new CSVWriter(sw);
            Iterator it = propertyMap.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<String, String> pairs = (Map.Entry) it.next();
                writer.writeNext(new String[]{pairs.getKey(), pairs.getValue()});
            }
            writer.close();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
        participantDirectory.setPluginProperties(sw.toString());
        participantDirectoryDao.saveOrUpdate(participantDirectory);

        return "workflow/admin/participantPluginConfigSuccess";
    }

    @RequestMapping(value = "/admin/process/participant/user/remove", method = RequestMethod.POST)
    public String participantRemoveUser(@RequestParam("participantId") String participantId, @RequestParam("packageId") String packageId, @RequestParam("processId") String processId, @RequestParam("version") String version) {
        WorkflowParticipant participant = workflowFacade.getParticipantMap(processId).get(participantId);

        if (participant != null && participant.isPackageLevel()) {
            processId = null;
        }

        Collection<ParticipantDirectory> participantMappingList = participantDirectoryDao.getMappingByParticipantId(packageId, processId, Integer.parseInt(version), participantId);
        for (ParticipantDirectory pd : participantMappingList) {
            participantDirectoryDao.removeMapping(pd.getId());
        }
        return "workflow/admin/activityAddForm";
    }

    @RequestMapping(value = "/admin/process/participant/user/removeSingle", method = RequestMethod.POST)
    public String participantRemoveUserSingle(@RequestParam("participantId") String participantId, @RequestParam("packageId") String packageId, @RequestParam("processId") String processId, @RequestParam("version") String version, @RequestParam("value") String value) {
        WorkflowParticipant participant = workflowFacade.getParticipantMap(processId).get(participantId);

        if (participant != null && participant.isPackageLevel()) {
            processId = null;
        }

        String existingValue = "";
        String participantType = "";
        Collection<ParticipantDirectory> participantMappingList = participantDirectoryDao.getMappingByParticipantId(packageId, processId, Integer.parseInt(version), participantId);

        //get corresponding object from user mapping
        if (participantMappingList.iterator().hasNext()) {
            ParticipantDirectory pd = participantMappingList.iterator().next();
            existingValue += pd.getValue() + ",";
            participantType = pd.getType();
        }

        //remove value
        existingValue = existingValue.replace(value + ",", "");

        //remove extra comma at the end if there's any
        if(existingValue.length() > 0 && existingValue.charAt(existingValue.length()-1) == ','){
            existingValue = existingValue.substring(0, existingValue.length()-1);
        }

        //remove all existing mapping
        for (ParticipantDirectory pd : participantMappingList) {
            participantDirectoryDao.removeMapping(pd.getId());
        }

        if (participantType.equals(ParticipantDirectoryDao.TYPE_GROUP)) {
            String[] groupList = existingValue.split(",");
            participantDirectoryDao.setGroupAsParticipant(groupList, packageId, processId, Integer.parseInt(version), participantId);
        } else if (participantType.equals(ParticipantDirectoryDao.TYPE_USER)) {
            String[] userList = existingValue.split(",");
            participantDirectoryDao.setUserAsParticipant(userList, packageId, processId, Integer.parseInt(version), participantId);
        }
        return "workflow/admin/activityAddForm";
    }

    @RequestMapping("/admin/process/xpdl/(*:processDefId)")
    public void getPackageXpdl(Writer writer, @RequestParam("processDefId") String processDefId) throws IOException {
        WorkflowProcess process = workflowFacade.getProcess(processDefId);
        String packageId = process.getPackageId();
        String packageVersion = process.getVersion();
        byte[] content = workflowFacade.getPackageContent(packageId, packageVersion);
        String xpdl = new String(content, "UTF8");
        writer.write(xpdl);
    }

    //return the corresponding object that is mapped to a participant (TODO: to be moved to somewhere else)
    protected Object getParticipantMappingObject(ParticipantDirectory pd, String processDefId) {
        if (pd.getType().equals(ParticipantDirectoryDao.TYPE_USER)) {
            String userId = pd.getValue();
            if (userId.contains(",")) {
                String[] ids = userId.split(",");
                List<User> userList = new ArrayList();
                for (String id : ids) {
                    userList.add(directoryManager.getUserById(id));
                }
                return userList;
            } else {
                return directoryManager.getUserById(userId);
            }

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_GROUP)) {
            String groupId = pd.getValue();
            if (groupId.contains(",")) {
                String[] ids = groupId.split(",");
                List<Group> groupList = new ArrayList();
                for (String id : ids) {
                    groupList.add(directoryManager.getGroupById(id));
                }
                return groupList;
            } else {
                return directoryManager.getGroupById(groupId);
            }

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER)) {

            String activity = getActivityNameForParticipantMapping(processDefId, pd.getValue());

            return "Performer(" + activity + ")";

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER_HOD)) {

            String activity = getActivityNameForParticipantMapping(processDefId, pd.getValue());

            return "Performer(" + activity + ")'s HOD";

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER_SUBORDINATE)) {

            String activity = getActivityNameForParticipantMapping(processDefId, pd.getValue());

            return "Performer(" + activity + ")'s Subordinates";

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER_DEPARTMENT)) {

            String activity = getActivityNameForParticipantMapping(processDefId, pd.getValue());

            return "Performer(" + activity + ")'s Department";

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_DEPARTMENT)) {
            String departmentId = pd.getValue();
            return directoryManager.getDepartmentById(departmentId);

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_HOD)) {
            String departmentId = pd.getValue();
            Department department = directoryManager.getDepartmentById(departmentId);
            if(department == null) return null;

            Employment hod = department.getHod();
            return (hod != null) ? hod.getUser() : null;

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_GRADE)) {
            String departmentId = pd.getValue();
            return directoryManager.getDepartmentById(departmentId);

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_GRADE)) {
            String gradeId = pd.getValue();
            return directoryManager.getGradeById(gradeId);

        } else if (pd.getType().contains(ParticipantDirectoryDao.TYPE_WORKFLOW_VARIABLE + ParticipantDirectoryDao.TYPE_DEPARTMENT_HOD)) {
            String variableName = pd.getValue();
            return "Workflow Variable : " + variableName + " (HOD)";

        } else if (pd.getType().contains(ParticipantDirectoryDao.TYPE_WORKFLOW_VARIABLE + ParticipantDirectoryDao.TYPE_USER)) {
            String variableName = pd.getValue();
            return "Workflow Variable : " + variableName + " (User)";

        } else if (pd.getType().contains(ParticipantDirectoryDao.TYPE_WORKFLOW_VARIABLE)) {
            String variableName = pd.getValue();
            return variableName;

        } else if (pd.getType().equals(ParticipantDirectoryDao.TYPE_PLUGIN)) {
            Plugin plugin = pluginManager.getPlugin(pd.getValue());
            return plugin;
        }
        return null;
    }

    protected String getActivityNameForParticipantMapping(String processDefId, String activityDefId) {
        String activity = "Previous Activity";

        if (activityDefId != null && activityDefId.trim().length() > 0) {
            if ("runProcess".equals(activityDefId)) {
                activity = "Run Process";
            } else {
                WorkflowActivity wa = workflowFacade.getProcessActivityDefinition(processDefId, activityDefId);
                if (wa != null) {
                    activity = wa.getName();
                }
            }
        }

        return activity;
    }

    @RequestMapping("/unauthorized")
    public String unauthorized(ModelMap map) {
        return "unauthorized";
    }

    @RequestMapping("/admin/package/export/(*:processDefId)")
    public void packageExport(HttpServletResponse response, @RequestParam("processDefId") String processDefId) throws IOException {
        try {
            String packageId = processDefId.split("#")[0];

            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            String timestamp = sdf.format(new Date());

            response.setContentType("application/zip");
            response.addHeader("Content-Disposition", "attachment; filename=" + PACKAGE_ZIP_PREFIX + packageId + "-" + timestamp + ".zip");
            ServletOutputStream stream = response.getOutputStream();

            importExportManager.exportPackageData(processDefId, stream);

            stream.close();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
    }

    @RequestMapping("/admin/process/configure/import")
    public String packageImport(ModelMap map) {
        return "workflow/admin/packageImport";
    }

    @RequestMapping("/admin/process/configure/import/confirm")
    public String packageImportConfirm(ModelMap map, @RequestParam("tempFileName") String tempFileName) throws IOException {
        String tempDir = System.getProperty("java.io.tmpdir");
        File tempFile = new File(tempDir, tempFileName);
        FileInputStream in = new FileInputStream(tempFile);

        byte[] bytes = new byte[(int) tempFile.length()];
        in.read(bytes);
        in.close();

        byte[] packageData = null;
        byte[] packageXpdl = null;
        Map<String, byte[]> mobileFormList = null;

        try {
            packageData = importExportManager.getPackageDataXmlFromZip(bytes);
            packageXpdl = importExportManager.getPackageXpdlFromZip(bytes);
            mobileFormList = importExportManager.getAllMobileFormFromZip(bytes);
        } catch (Exception e) {
            map.addAttribute("errorMessage", e.getMessage());
            return "workflow/admin/packageImport";
        }

        String packageId = importExportManager.importPackage(packageData, packageXpdl, mobileFormList);

        return "redirect:/web/admin/process/configure/list?packageId=" + packageId;
    }

    @RequestMapping(value = "/admin/process/configure/import/submit", method = RequestMethod.POST)
    public String packageImportSubmit(ModelMap map) throws IOException {
        MultipartFile packageZip = FileStore.getFile("packageZip");

        String tempDir = System.getProperty("java.io.tmpdir");
        String tempFileName = "packageZip-" + System.currentTimeMillis() + ".zip";
        FileOutputStream out = new FileOutputStream(new File(tempDir, tempFileName));
        out.write(packageZip.getBytes());
        out.close();

        byte[] packageData = null;
        byte[] packageXpdl = null;

        try {
            packageData = importExportManager.getPackageDataXmlFromZip(packageZip.getBytes());
            packageXpdl = importExportManager.getPackageXpdlFromZip(packageZip.getBytes());
        } catch (Exception e) {
            map.addAttribute("errorMessage", e.getMessage());
            return "workflow/admin/packageImport";
        }

        List<String> errorList = importExportManager.validateImportPackageData(packageData);
        if (!errorList.isEmpty()) {
            map.addAttribute("errorList", errorList);
            map.addAttribute("tempFileName", tempFileName);
            return "workflow/admin/packageImportError";
        }

        return "redirect:/web/admin/process/configure/import/confirm?tempFileName=" + tempFileName;

    }

}
