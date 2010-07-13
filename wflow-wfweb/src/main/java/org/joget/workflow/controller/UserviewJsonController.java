package org.joget.workflow.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringTokenizer;
import org.joget.commons.util.PagedList;
import org.joget.commons.util.StringUtil;
import org.joget.commons.util.TimeZoneUtil;
import org.joget.directory.model.User;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.form.model.Form;
import org.joget.form.model.FormMetaData;
import org.joget.form.model.service.FormManager;
import org.joget.form.util.FormUtil;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.UserviewProcess;
import org.joget.workflow.model.UserviewSetup;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowFacade;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.service.UserviewProcessManager;
import org.joget.workflow.model.service.UserviewSetupManager;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class UserviewJsonController {

    @Autowired
    private UserviewSetupManager userviewSetupManager;

    @Autowired
    private UserviewProcessManager userviewProcessManager;

    @Autowired
    @Qualifier("main")
    private DirectoryManager directoryManager;
    
    @Autowired
    private WorkflowUserManager workflowUserManager;

    @Autowired
    private WorkflowFacade workflowFacade;

    @Autowired
    private ActivityFormDao activityFormDao;

    @Autowired
    private FormManager formManager;

    @RequestMapping("/json/userview/getColumnList/(*:processDefId)/(*:activityDefId)")
    public void getColumnListByActivityDefId(Writer writer, @RequestParam("processDefId") String processDefId, @RequestParam("activityDefId") String activityDefId) throws IOException, JSONException {
        JSONObject jsonObject = new JSONObject();

        Set<String> columnList = new HashSet<String>();

        Collection<ActivityForm> activityFormList = activityFormDao.getFormByActivity(processDefId, Integer.parseInt(processDefId.split("#")[1]), activityDefId);
        if(!activityFormList.isEmpty()){
            String formId = "";

            for(ActivityForm form : activityFormList){
                if(form.getFormId() != null && form.getFormId().trim().length() > 0){
                    formId = form.getFormId();
                    break;
                }
            }

            if(formId.trim().length() > 0){
                String tableName = formManager.getFormById(formId).getTableName();
                Collection<Form> formList = formManager.getFormByTableName(tableName);

                for(Form form : formList){
                    columnList.addAll(FormUtil.getFormFields(form.getData()));
                }
                columnList.add("username");
                columnList.add("created");
                columnList.add("modified");
                columnList.add("refName");

                List<String> columns = new ArrayList(columnList);
                Collections.sort(columns, new StringUtil().new IgnoreCaseComparator());

                jsonObject.accumulate("data", columns);
                jsonObject.accumulate("tableName", tableName);
            }
        }

        writeJson(writer, jsonObject, null);
    }

    @RequestMapping("/json/userview/getActivityListWithFormMapping/(*:processDefId)")
    public void getActivityListWithFormMappingByProcessDefId(Writer writer, @RequestParam("processDefId") String processDefId) throws IOException, JSONException {
        JSONObject jsonObject = new JSONObject();

        Collection<WorkflowActivity> activityList = workflowFacade.getProcessActivityDefinitionList(processDefId);

        //add "runProcess" as a WorkflowActivity to activity list
        WorkflowActivity runProcess = new WorkflowActivity();
        runProcess.setId("runProcess");
        runProcess.setName("Run Process");
        runProcess.setProcessVersion(processDefId.split("#")[1]);
        activityList.add(runProcess);
        
        for(WorkflowActivity activity : activityList){

            Collection<ActivityForm> formList = activityFormDao.getFormByActivity(processDefId, Integer.parseInt(activity.getProcessVersion()), activity.getId());
            if(!formList.isEmpty()){

                boolean addToJson = false;
                Map data = new HashMap();

                for(ActivityForm form : formList){
                    if(form.getFormId() != null && form.getFormId().trim().length() > 0){
                        data.put("formId", form.getFormId());
                        addToJson = true;
                        break;
                    }
                }

                if(addToJson){
                    data.put("id", activity.getId());
                    data.put("name", activity.getName());

                    jsonObject.accumulate("data", data);
                }
            }
        }

        writeJson(writer, jsonObject, null);
    }

    @RequestMapping("/json/userview/list")
    public void userviewList(Writer writer, @RequestParam(value = "callback", required = false) String callback,
            @RequestParam(value = "setupName", required = false) String setupName,
            @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc,
            @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows)
            throws IOException, JSONException {

        JSONObject jsonObject = new JSONObject();

        Collection<UserviewSetup> userviewSetup = userviewSetupManager.getAllUserviewSetups(setupName, sort, desc, start, rows);
        Integer total = new Integer(userviewSetupManager.getAllUserviewSetupsSize(setupName));

        for (UserviewSetup view : userviewSetup) {
            Map data = new HashMap();
            data.put("id", view.getId());
            data.put("setupName", view.getSetupName());
            data.put("createdBy", view.getCreatedBy());
            data.put("dateCreated", view.getCreatedOn());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", total);
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        writeJson(writer, jsonObject, null);
    }

    @RequestMapping("/json/userviewProcessBySetup/(*:userviewSetupId)")
    public void getUserviewProcessBySetupId(Writer writer, @RequestParam("userviewSetupId") String userviewSetupId) throws IOException, JSONException {
        JSONObject jsonObject = new JSONObject();

        Collection<UserviewProcess> userviewProcessCol = userviewProcessManager.getUserviewProcessBySetupId(userviewSetupId);

        for(UserviewProcess userviewProcess: userviewProcessCol){
            Map data = new HashMap();
            data.put("id", userviewProcess.getId());
            data.put("processDefId", userviewProcess.getProcessDefId());
            data.put("activtyDefId", userviewProcess.getActivityDefId());
            //data.put("userviewFormUrl",userviewProcess.getUserviewFormUrl());
            jsonObject.accumulate("data", data);
        }

        writeJson(writer, jsonObject, null);
    }

    @RequestMapping("/json/userview/edit/view/(*:userviewSetupId)")
    public void userviewEditView(Writer writer, @RequestParam("userviewSetupId") String userviewSetupId) throws JSONException, IOException {
        UserviewSetup userviewSetup = userviewSetupManager.getUserviewSetup(userviewSetupId);

        JSONObject jsonObject = new JSONObject();

        Map<String, String> setup = new HashMap<String, String>();
        setup.put("id", userviewSetup.getId());
        setup.put("name", userviewSetup.getSetupName());
        setup.put("inboxLabel", userviewSetup.getInboxLabel());
        jsonObject.accumulate("userview", setup);

        Map<String, String> processStart = new HashMap<String, String>();
        processStart.put("processDefId", userviewSetup.getStartProcessDefId());
        processStart.put("label", userviewSetup.getStartProcessLabel());
        processStart.put("runProcessDirectly", (userviewSetup.getRunProcessDirectly() != null)?userviewSetup.getRunProcessDirectly().toString():"0");
        jsonObject.accumulate("processStart", processStart);

        Map<String, String> layout = new HashMap<String, String>();
        layout.put("customHeader", userviewSetup.getHeader());
        layout.put("customFooter", userviewSetup.getFooter());
        layout.put("customMenu", userviewSetup.getMenu());
        layout.put("customCss", userviewSetup.getCss());
        layout.put("customCssLink", userviewSetup.getCssLink());
        jsonObject.accumulate("layout", layout);

        if(userviewSetup.getCategories() != null && userviewSetup.getCategories().trim().length() > 0){
            String category[] = userviewSetup.getCategories().split(",");
            for(String c: category){
                String temp[] = c.split(":");
                Map<String, String> cat = new HashMap<String, String>();
                cat.put("categoryId", temp[0]);
                cat.put("categoryLabel", temp[1]);
                jsonObject.accumulate("category", cat);
            }
        }

        Collection<UserviewProcess> userviewProcessList = userviewProcessManager.getUserviewProcessBySetupId(userviewSetupId);

        for(UserviewProcess userviewProcess : userviewProcessList){
            Map<String, Object> process = new HashMap<String, Object>();
            process.put("id", userviewProcess.getId());
            process.put("processDefId", userviewProcess.getProcessDefId());
            process.put("processName", workflowFacade.getProcess(userviewProcess.getProcessDefId()).getName());

            Map<String, String> activityList = new HashMap<String, String>();
            activityList.put("activityDefId", userviewProcess.getActivityDefId());
            if("runProcess".equals(userviewProcess.getActivityDefId())){
                activityList.put("activityName", "Run Process");
            }else{
                activityList.put("activityName", workflowFacade.getProcessActivityDefinition(userviewProcess.getProcessDefId(), userviewProcess.getActivityDefId()).getName());
            }
            activityList.put("activityLabel", userviewProcess.getActivityLabel());
            activityList.put("category", userviewProcess.getCategoryId());
            activityList.put("sequence", (userviewProcess.getSequence() == null) ? "0" : userviewProcess.getSequence().toString());
            activityList.put("tableName", userviewProcess.getTableName());
            activityList.put("tableColumn", userviewProcess.getTableColumn());
            activityList.put("tableHeader", userviewProcess.getHeader());
            activityList.put("tableFooter", userviewProcess.getFooter());
            activityList.put("filter", userviewProcess.getFilter());
            activityList.put("sort", userviewProcess.getSort());
            activityList.put("viewType", userviewProcess.getViewType().toString());
            activityList.put("permType", userviewProcess.getPermType().toString());
            activityList.put("buttonCancelLabel", (userviewProcess.getButtonCancelLabel() == null) ? "" : userviewProcess.getButtonCancelLabel().toString());
            activityList.put("buttonCompleteLabel", (userviewProcess.getButtonCompleteLabel() == null) ? "" : userviewProcess.getButtonCompleteLabel().toString());
            activityList.put("buttonSaveLabel", (userviewProcess.getButtonSaveLabel() == null) ? "" : userviewProcess.getButtonSaveLabel().toString());
            activityList.put("buttonWithdrawLabel", (userviewProcess.getButtonWithdrawLabel() == null) ? "" : userviewProcess.getButtonWithdrawLabel().toString());
            activityList.put("buttonSaveShow", (userviewProcess.getButtonSaveShow() == null) ? "1" : userviewProcess.getButtonSaveShow().toString());
            activityList.put("buttonWithdrawShow", (userviewProcess.getButtonWithdrawShow() == null) ? "1" : userviewProcess.getButtonWithdrawShow().toString());
            activityList.put("activityFormId", userviewProcess.getActivityFormId());
            if(userviewProcess.getActivityFormId() != null && userviewProcess.getActivityFormId().trim().length() > 0){
                Form activityForm = workflowFacade.getFormById(userviewProcess.getActivityFormId());
                if (activityForm != null) {
                    activityList.put("activityFormName", activityForm.getName());
                }
            }
            activityList.put("activityFormUrl", userviewProcess.getActivityFormUrl());
            activityList.put("permission", userviewProcess.getMappingValue());

            if(userviewProcess.getMappingValue() != null && userviewProcess.getMappingValue().trim().length() > 0){
                String names = "";
                for(String id: userviewProcess.getMappingValue().split(",")){
                    if(workflowFacade.getGroupById(id) != null){
                        names += workflowFacade.getGroupById(id).getName() + ",";
                    }
                }
                if(names.length() > 0){
                    names = names.substring(0, names.length()-1);
                    activityList.put("permissionGroupName", names);
                }
            }

            process.put("activity", activityList);
            jsonObject.accumulate("processList", process);
        }

        writeJson(writer, jsonObject, null);
    }

    @RequestMapping("/json/userview/view/(*:id)")
    public void userview(Writer writer, @RequestParam(value = "callback", required = false) String callback,
            @RequestParam("id") String id,
            @RequestParam(value = "filter", required = false) String filter, @RequestParam(value = "filterType", required = false) String filterType,
            @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc,
            @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        JSONObject jsonObject = new JSONObject();

        Collection<FormMetaData> tableData = null;
        UserviewProcess userviewProcess = userviewProcessManager.getUserviewProcess(id);

        Collection<String> filterTypes = new ArrayList<String>();

        if((filter != null && filter.trim().length() > 0) && (filterType == null || filterType.trim().length() == 0)){
            StringTokenizer tempFilterTokenizer = new StringTokenizer(userviewProcess.getFilter(), ",");
            while (tempFilterTokenizer.hasMoreTokens()) {
                String fieldName = ((String) tempFilterTokenizer.nextElement()).trim();
                if(fieldName.endsWith("(System)")){
                    filterTypes.add("dynamicForm.customProperties."+ fieldName.replace("(System)", ""));
                }else{
                    filterTypes.add("dynamicForm.customProperties.c_"+ fieldName);
                }
            }
        }else if((filter != null && filter.trim().length() > 0) && (filterType != null || filterType.trim().length() > 0)){
            if (filterType.endsWith("(System)")) {
                filterTypes.add("dynamicForm.customProperties."+filterType.replace("(System)", ""));
            } else {
                filterTypes.add("dynamicForm.customProperties.c_"+filterType);
            }
        }

        String currentUsername = workflowUserManager.getCurrentUsername();
        
        tableData = workflowFacade.loadUserviewActivityTableData(userviewProcess, filter, filterTypes, currentUsername, sort, desc, start, rows);
        Integer total = workflowFacade.loadUserviewActivityTableDataSize(userviewProcess, filter, filterTypes, currentUsername).intValue();
        
        for (FormMetaData data : tableData) {
            Map tempData = new HashMap();
            tempData.put("formMetaData.id", data.getId());
            tempData.put("dynamicForm.id", data.getDynamicFormId());

            String activityId = data.getActivityId();
            if(data.getLatest() == 1){
                tempData.put("activityId", (workflowFacade.isAssignmentExist(activityId)? activityId : null));
            }else{
                tempData.put("activityId", null);
            }

            StringTokenizer tempColumnTokenizer = new StringTokenizer(userviewProcess.getTableColumn(), ",");

            while (tempColumnTokenizer.hasMoreTokens()) {
                String key = ((String) tempColumnTokenizer.nextElement()).split(":")[0].trim();

                if(key.endsWith("(System)")){
                    key = key.replace("(System)", "");
                }else{
                    key = "c_" + key;
                }

                String sKey = "dynamicForm.customProperties." + key;
                Object value = data.getDynamicForm().getCustomProperties().get(key);
                String svalue = "";
                if(value != null){
                    svalue = value.toString();
                }
                tempData.put(sKey, svalue);
            }
            jsonObject.accumulate("data", tempData);
        }

        jsonObject.accumulate("total", total);
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        writeJson(writer, jsonObject, null);
    }

    @RequestMapping("/json/userview/inbox/(*:id)")
    public void userviewInbox(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("id") String id, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {
        UserviewSetup userviewSetup = userviewSetupManager.getUserviewSetup(id);
        List<String> processDefIds = userviewProcessManager.getProcessDefIdListBySetupId(userviewSetup.getId());
        
        PagedList<WorkflowAssignment> assignmentList = workflowFacade.getAssignmentPendingAndAcceptedListByProcess((String[])processDefIds.toArray(new String[0]), sort, desc, start, rows);
        Integer total = assignmentList.getTotal();
        JSONObject jsonObject = new JSONObject();

        User user = directoryManager.getUserByUsername(workflowUserManager.getCurrentUsername());
        String gmt = "";
        if (user != null) {
            gmt = user.getTimeZone();
        }

        for (WorkflowAssignment assignment : assignmentList) {
            Map data = new HashMap();
            data.put("processId", assignment.getProcessId());
            data.put("processRequesterId", assignment.getProcessRequesterId());
            data.put("activityId", assignment.getActivityId());
            data.put("processName", assignment.getProcessName());
            data.put("activityName", assignment.getActivityName());
            data.put("processVersion", assignment.getProcessVersion());
            data.put("dateCreated", TimeZoneUtil.convertToTimeZone(assignment.getDateCreated(), gmt, null));
            data.put("acceptedStatus", assignment.isAccepted());

            Date dueDate = workflowFacade.getDueDateForRunningActivity(assignment.getActivityId());
            data.put("due", (dueDate != null ? dueDate : "-"));

            double serviceLevelMonitor = workflowFacade.getServiceLevelMonitorForRunningActivity(assignment.getActivityId());

            if (serviceLevelMonitor > 0) {
                if (serviceLevelMonitor < 25) {
                    data.put("serviceLevelMonitor", "<span class=\"dot_green\">&nbsp;</span>");
                } else if (serviceLevelMonitor >= 25 && serviceLevelMonitor < 50) {
                    data.put("serviceLevelMonitor", "<span class=\"dot_green_yellow\">&nbsp;</span>");
                } else if (serviceLevelMonitor >= 50 && serviceLevelMonitor < 75) {
                    data.put("serviceLevelMonitor", "<span class=\"dot_yellow\">&nbsp;</span>");
                } else if (serviceLevelMonitor >= 75 && serviceLevelMonitor < 100) {
                    data.put("serviceLevelMonitor", "<span class=\"dot_yellow_red\">&nbsp;</span>");
                } else {
                    data.put("serviceLevelMonitor", "<span class=\"dot_red\">&nbsp;</span>");
                }
            } else {
                data.put("serviceLevelMonitor", "-");
            }

            data.put("id", assignment.getActivityId());
            data.put("label", assignment.getActivityName());
            data.put("description", assignment.getDescription());

            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", total);
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        writeJson(writer, jsonObject, callback);
    }

    protected static void writeJson(Writer writer, JSONObject jsonObject, String callback) throws IOException, JSONException {
        if (callback != null && callback.trim().length() > 0) {
            writer.write(callback + "(");
        }
        jsonObject.write(writer);
        if (callback != null && callback.trim().length() > 0) {
            writer.write(")");
        }
    }

    @RequestMapping("/json/userview/checkExist/(*:id)")
    public void isUserviewExist(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("id") String id) throws JSONException, IOException {
        JSONObject jsonObject = new JSONObject();
        UserviewSetup userviewSetup = userviewSetupManager.getUserviewSetup(id);
        if(userviewSetup == null){
            jsonObject.accumulate("exist", "false");
        }else{
            jsonObject.accumulate("exist", "true");
        }
        writeJson(writer, jsonObject, callback);
    }

}
