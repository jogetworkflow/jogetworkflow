package org.joget.workflow.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.joget.commons.util.FileStore;
import org.joget.commons.util.LogUtil;
import org.joget.form.model.Form;
import org.joget.form.model.FormMetaData;
import org.joget.form.model.dao.DynamicFormDao;
import org.joget.form.model.service.FormManager;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.UserviewProcess;
import org.joget.workflow.model.UserviewSetup;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowFacade;
import org.joget.workflow.model.WorkflowPackage;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.dao.UserviewProcessDao;
import org.joget.workflow.model.service.ImportExportManager;
import org.joget.workflow.model.service.UserviewProcessManager;
import org.joget.workflow.model.service.UserviewSetupManager;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.HtmlUtils;

@Controller
public class UserviewWebController {

    public static final String USERVIEW_ZIP_PREFIX = "userview-";

    @Autowired
    private WorkflowFacade workflowFacade;
    
    @Autowired
    private UserviewProcessManager userviewProcessManager;

    @Autowired
    private UserviewSetupManager userviewSetupManager;

    @Autowired
    private WorkflowUserManager workflowUserManager;

    @Autowired
    private FormManager formManager;

    @Autowired
    private ActivityFormDao activityFormDao;

    @Autowired
    private ImportExportManager importExportManager;
    
    @RequestMapping(value = "/admin/userview/list")
    public String userviewList(ModelMap map, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException {
        Collection<WorkflowProcess> processList = workflowFacade.getProcessList("name", false, 0, -1, null, true, false);
        map.addAttribute("processList", processList);

        return "userview/userviewList";
    }

    @RequestMapping(value = "/admin/userview/create")
    public String userviewCreate(ModelMap map) throws IOException {
        Collection<WorkflowProcess> processList = workflowFacade.getProcessList("name", false, 0, -1, null, true, false);
        map.addAttribute("processList", processList);

        return "userview/userviewCreate";
    }

    @RequestMapping(value = "/admin/userview/submit", method = RequestMethod.POST)
    public String userviewSaveSubmit(ModelMap map, HttpServletRequest request) throws IOException {
        Collection<String> errors = new ArrayList<String>();

        String name = request.getParameter("name");

        String userviewSetupId = request.getParameter("userviewSetupId");
        String id = request.getParameter("id");

        String inboxLabel = request.getParameter("inboxLabel");
        String startProcessLabel = request.getParameter("startProcessLabel");
        String startProcessDefId = request.getParameter("startProcessDefId");
        int runProcessDirectly = (request.getParameter("runProcessDirectly")!= null && "1".equals(request.getParameter("runProcessDirectly")))?1:0;
        String customHeader = request.getParameter("userviewHeader");
        String customFooter = request.getParameter("userviewFooter");
        String customMenu = request.getParameter("userviewMenu");
        String customCss = request.getParameter("userviewCss");
        String customCssLink = request.getParameter("userviewCssLink");
        String[] categoryId = request.getParameterValues("categoryId");
        String[] categoryLabel = request.getParameterValues("categoryLabel");
        String[] permission = request.getParameterValues("permission");
        String[] processList = request.getParameterValues("process");
        String[] activityList = request.getParameterValues("activity");
        String[] activityLabel = request.getParameterValues("activityLabel");
        String[] buttonSaveLabel = request.getParameterValues("buttonSaveLabel");
        String[] buttonWithdrawLabel = request.getParameterValues("buttonWithdrawLabel");
        String[] buttonCancelLabel = request.getParameterValues("buttonCancelLabel");
        String[] buttonCompleteLabel = request.getParameterValues("buttonCompleteLabel");
        String[] buttonSaveShow = request.getParameterValues("buttonSaveShow");
        String[] buttonWithdrawShow = request.getParameterValues("buttonWithdrawShow");
        String[] category = request.getParameterValues("category");
        String[] activityFormType = request.getParameterValues("activityFormType");
        String[] activityForm = request.getParameterValues("activityForm");
        String[] columnList = request.getParameterValues("columns");
        String[] filter = request.getParameterValues("filter");
        String[] sort = request.getParameterValues("sort");
        String[] tableHeader = request.getParameterValues("tableHeader");
        String[] tableFooter = request.getParameterValues("tableFooter");
        String[] tableNameList = request.getParameterValues("tableName");
        String[] viewType = request.getParameterValues("viewType");
        String[] permType = request.getParameterValues("permType");

        UserviewSetup userviewSetup = new UserviewSetup();

        if(userviewSetupId != null && userviewSetupId.trim().length() > 0){
            userviewSetup.setId(userviewSetupId);
            userviewProcessManager.removeUserviewProcessBySetupId(userviewSetupId);
        }else{
            userviewSetup.setId(id);
        }

        userviewSetup.setActive(1);
        userviewSetup.setSetupName(name);
        userviewSetup.setInboxLabel(inboxLabel);
        userviewSetup.setStartProcessDefId(startProcessDefId);
        userviewSetup.setStartProcessLabel(startProcessLabel);
        userviewSetup.setRunProcessDirectly(runProcessDirectly);
        userviewSetup.setHeader(customHeader);
        userviewSetup.setFooter(customFooter);
        userviewSetup.setMenu(customMenu);
        userviewSetup.setCss(customCss);
        userviewSetup.setCssLink(customCssLink);
        userviewSetup.setCreatedBy(workflowUserManager.getCurrentUsername());
        userviewSetup.setCreatedOn(new Date());
        String categories = "";
        if(categoryId != null){
            for(int i=0; i<categoryId.length; i++){
                if(categoryId[i].trim().length() > 0){
                    categories += categoryId[i] + ":" + categoryLabel[i].replaceAll(":", "&#58;").replaceAll(",", "&#44;") + ",";
                }
            }
        }
        userviewSetup.setCategories(categories);
        userviewSetupManager.saveUserviewSetup(userviewSetup);

        if(processList != null){
            for(int i=0; i<processList.length; i++){
                if(processList[i]!=null && !processList[i].equals("")){
                    UserviewProcess userviewProcess = new UserviewProcess();
                    userviewProcess.setCreatedBy(workflowUserManager.getCurrentUsername());
                    userviewProcess.setCreatedOn(new Date());
                    userviewProcess.setActivityDefId(activityList[i]);
                    userviewProcess.setActivityLabel(activityLabel[i]);
                    userviewProcess.setButtonCancelLabel(buttonCancelLabel[i]);
                    userviewProcess.setButtonCompleteLabel(buttonCompleteLabel[i]);
                    userviewProcess.setButtonSaveLabel(buttonSaveLabel[i]);
                    userviewProcess.setButtonWithdrawLabel(buttonWithdrawLabel[i]);
                    userviewProcess.setButtonSaveShow(Integer.parseInt(buttonSaveShow[i]));
                    userviewProcess.setButtonWithdrawShow(Integer.parseInt(buttonWithdrawShow[i]));
                    userviewProcess.setCategoryId(category[i]);
                    userviewProcess.setSequence(i);
                    userviewProcess.setProcessDefId(URLDecoder.decode(processList[i], "UTF-8"));
                    userviewProcess.setTableColumn(columnList[i].trim());
                    userviewProcess.setFilter(filter[i].trim());
                    userviewProcess.setSort(sort[i].trim());
                    userviewProcess.setTableName(tableNameList[i]);
                    userviewProcess.setHeader(tableHeader[i]);
                    userviewProcess.setFooter(tableFooter[i]);
                    userviewProcess.setViewType(Integer.parseInt(viewType[i]));
                    userviewProcess.setPermType(Integer.parseInt(permType[i]));
                    userviewProcess.setDvSetup(userviewSetup);
                    userviewProcess.setMappingType(UserviewProcessDao.MAPPING_TYPE_GROUP);
                    userviewProcess.setMappingValue(permission[i]);

                    if(activityFormType[i].equals("normal")){
                        userviewProcess.setActivityFormId(activityForm[i]);
                    }else if(activityFormType[i].equals("external")){
                        userviewProcess.setActivityFormUrl(activityForm[i]);
                    }

                    userviewProcessManager.saveUserviewProcess(userviewProcess);
                }
            }
        }

        if(userviewSetupId != null && userviewSetupId.trim().length() > 0){
            map.addAttribute("save", "true");
            return userviewEditView(map, userviewSetupId);
        }else{
            return "redirect:/web/admin/userview/list";
        }
    }

    @RequestMapping(value = "/admin/userview/create/permission")
    public String userviewCreatePermission(ModelMap map) throws IOException {
        return "userview/userviewCreatePermission";
    }

    @RequestMapping(value = "/admin/userview/create/updateProcessVersion")
    public String userviewCreateUpdateProcessVersion(ModelMap map, @RequestParam("processes") String processes) throws IOException {
        String[] processList = processes.split(",");

        Map<String, String> processVersionMap = new HashMap<String, String>();
        Map<String, String> processNameMap = new HashMap<String, String>();
        Map<String, Boolean> processVersionIsLatestMap = new HashMap<String, Boolean>();
        if(processList.length > 0){
            for(String processDefId : processList){
                String packageId = processDefId.split("#")[0];
                String version = processDefId.split("#")[1];
                String latestVersion = workflowFacade.getCurrentPackageVersion(packageId);

                WorkflowProcess process = workflowFacade.getProcess(processDefId);
                processNameMap.put(processDefId, process.getPackageName() + " : " + process.getName());

                if(version.equals(latestVersion)){
                    processVersionIsLatestMap.put(processDefId, true);
                }
                processVersionMap.put(processDefId, latestVersion);
            }
        }

        map.addAttribute("processVersionMap", processVersionMap);
        map.addAttribute("processNameMap", processNameMap);
        map.addAttribute("processVersionIsLatestMap", processVersionIsLatestMap);
        return "userview/userviewCreateUpdateProcessVersion";
    }

    @RequestMapping(value = "/admin/userview/create/updateFormVersion")
    public String userviewCreateUpdateFormVersion(ModelMap map, @RequestParam("formids") String formIds) throws IOException {
        String[] formIdList = formIds.split(",");

        Map<String, Map> formMap = new HashMap<String, Map>();
        Map<String, String> formNameMap = new HashMap<String, String>();
        Map<String, Boolean> formVersionIsLatestMap = new HashMap<String, Boolean>();
        if(formIdList.length > 0){
            for(String formId : formIdList){
                Map<String, String> versionMap = new LinkedHashMap<String, String>();
                Collection<Form> forms = workflowFacade.getAllFormVersion(formId, "id", true);
                String latestVersion = "";
                for(Form form : forms){
                    String id = form.getId();
                    String version = "1";
                    String name = form.getName();
                    if("".equals(latestVersion)){
                        latestVersion = id;
                    }
                    if(id.contains("_ver_")){
                        version = id.substring(id.indexOf("_ver_") + 5, id.length());
                    }
                    versionMap.put(id+","+name, version);

                    if(formId.equals(id)){
                        formNameMap.put(id, name);
                    }
                }
                formMap.put(formId, versionMap);
                if(latestVersion.equals(formId)){
                    formVersionIsLatestMap.put(formId, Boolean.TRUE);
                }
            }
        }

        map.addAttribute("formMap", formMap);
        map.addAttribute("formNameMap", formNameMap);
        map.addAttribute("formVersionIsLatestMap", formVersionIsLatestMap);
        return "userview/userviewCreateUpdateFormVersion";
    }

    @RequestMapping(value = "/admin/userview/create/selectActivity")
    public String userviewCreateSelectActivity(ModelMap map) throws IOException {
        map.addAttribute("categoryList", formManager.getCategories("name", Boolean.FALSE, null, null));

        Collection<WorkflowPackage> packageList = workflowFacade.getPackageList();
        map.addAttribute("packageList", packageList);

        return "userview/userviewCreateSelectActivity";
    }

    @RequestMapping("/admin/userview/edit/view/(*:userviewSetupId)")
    public String userviewEditView(ModelMap map, @RequestParam("userviewSetupId") String userviewSetupId) throws IOException {
        Collection<WorkflowProcess> processList = workflowFacade.getProcessList("name", false, 0, -1, null, true, false);
        map.addAttribute("processList", processList);
        map.addAttribute("userviewSetupId", userviewSetupId);
        
        return "userview/userviewCreate";
    }

    @RequestMapping("/admin/userview/removeMultiple")
    public String removeMultipleRunningProcessInstance(ModelMap model, @RequestParam("userviewIds") String userviewIds) {
        StringTokenizer strToken = new StringTokenizer(userviewIds, ",");
        while (strToken.hasMoreTokens()) {
            String userviewId = (String) strToken.nextElement();
            userviewSetupManager.removeUserview(userviewId);
        }
        return "workflow/runningProcessList";
    }
    
    @RequestMapping(value = "/userview/form/view/(*:userviewProcessId)/(*:formMetaDataId)")
    public String userviewEmbeddedFormView(ModelMap map, @RequestParam("userviewProcessId") String userviewProcessId, @RequestParam("formMetaDataId") String formMetaDataId) throws IOException {
        UserviewProcess userviewProcess = userviewProcessManager.getUserviewProcess(userviewProcessId);
        String activityId = "";
        String processId = "";

        FormMetaData formMetaData = formManager.loadDynamicFormMetaData(userviewProcess.getTableName(), formMetaDataId);
        if(formMetaData != null){
            activityId = formMetaData.getActivityId();
            WorkflowActivity activity = workflowFacade.getActivityById(activityId);
            if(activity != null){
                processId = activity.getProcessId();
            }
        }

        map.addAttribute("buttonCancelLabel", userviewProcess.getButtonCancelLabel());
        map.addAttribute("buttonCompleteLabel", userviewProcess.getButtonCompleteLabel());
        map.addAttribute("buttonSaveLabel", userviewProcess.getButtonSaveLabel());
        map.addAttribute("buttonWithdrawLabel", userviewProcess.getButtonWithdrawLabel());
        map.addAttribute("buttonSaveShow", (userviewProcess.getButtonSaveShow() != null && userviewProcess.getButtonSaveShow() == 0) ? "false" : "true");
        map.addAttribute("buttonWithdrawShow", (userviewProcess.getButtonSaveShow() != null && userviewProcess.getButtonWithdrawShow() == 0) ? "false" : "true");

        map.addAttribute("formId", userviewProcess.getActivityFormId());
        map.addAttribute("formUrl", userviewProcess.getActivityFormUrl());
        map.addAttribute("processId", processId);
        map.addAttribute("username", workflowUserManager.getCurrentUsername());
        map.addAttribute("activityId", activityId);

        if(workflowFacade.isAssignmentExist(activityId)){
            map.addAttribute("hasAssignment", "true");
        }else{
            map.addAttribute("hasAssignment", "false");
        }

        WorkflowActivity act = workflowFacade.getActivityById(activityId);
        if(act != null && act.getState().contains("closed")){
            map.addAttribute("completed", "true");
            Collection<ActivityForm> actFormList = workflowFacade.getFormByActivity(userviewProcess.getProcessDefId(), Integer.parseInt(userviewProcess.getProcessDefId().split("#")[1]), userviewProcess.getActivityDefId());

            if(actFormList.size() > 0){
                ActivityForm actForm = actFormList.iterator().next();
                if(actForm != null && actForm.getFormId().trim().length() > 0){
                    map.addAttribute("historyFormId", actForm.getFormId());
                }
            }
        }else{
            map.addAttribute("completed", "false");
        }

        return "userview/userviewEmbeddedFormView";
    }

    @RequestMapping(value = "/userview/(*:id)")
    public String userviewEmbedded(ModelMap map, @RequestParam("id") String id, @RequestParam(value="detail", required=false) String detail) throws IOException {

        Map<String, String> categories = new HashMap<String, String>();
        Map<String, Collection<HashMap>> categoryActivityMap = new LinkedHashMap<String, Collection<HashMap>>();

        UserviewSetup uvs = userviewSetupManager.getUserviewSetup(id);

        if(workflowFacade.isUserInWhiteList(uvs.getStartProcessDefId().replaceAll("%23", "#"))){
           map.addAttribute("showStartProcess", "true");
        }else{
            map.addAttribute("showStartProcess", "false");
        }

        // check that userview exists
        if (uvs == null) {
            return "error404.jsp";
        }

        if(uvs.getCategories() != null && uvs.getCategories().trim().length() != 0){
            String category[] =  uvs.getCategories().split(",");
            for(String c: category){
                String temp[] = c.split(":");
                categories.put(temp[0], temp[1]);
            }
        }
        
        String currentUsername = workflowUserManager.getCurrentUsername();
        Collection<UserviewProcess> userviewProcessList = userviewProcessManager.getUserviewProcessBySetupId(uvs.getId());

        for(UserviewProcess userviewProcess : userviewProcessList){
            if(userviewProcessManager.isUserAllowToView(userviewProcess, currentUsername)){

                WorkflowActivity wfActObj =  workflowFacade.getActivityById(userviewProcess.getProcessDefId(), userviewProcess.getActivityDefId());

                if(wfActObj == null && userviewProcess.getActivityDefId().equals("runProcess")){
                    wfActObj = new WorkflowActivity();
                    wfActObj.setId("runProcess");
                    wfActObj.setName("Run Process");
                }else if(wfActObj == null){
                    return "error404.jsp";
                }

                wfActObj.setLatestActivityCount(formManager.countActivityFromMetaData(userviewProcess.getTableName(), userviewProcess.getActivityDefId(), DynamicFormDao.STATUS_RUNNING, DynamicFormDao.VIEW_PERMISSION_PERSONAL, currentUsername));

                if (userviewProcess.getActivityLabel() != null && !userviewProcess.getActivityLabel().equals("")) {
                    wfActObj.setName(userviewProcess.getActivityLabel());
                }

                Collection<HashMap> activityList = new ArrayList<HashMap>();
                if(categoryActivityMap.containsKey(categories.get(userviewProcess.getCategoryId()))){
                    activityList = categoryActivityMap.get(categories.get(userviewProcess.getCategoryId()));
                }

                HashMap activity = new HashMap();
                activity.put("wfActivityObj", wfActObj);
                activity.put("userviewActivityObj", userviewProcess);
                activityList.add(activity);
                    
                categoryActivityMap.put(categories.get(userviewProcess.getCategoryId()), activityList);
            }
        }

        map.addAttribute("categoryActivityMap", categoryActivityMap);
        map.addAttribute("userviewId", id);
        map.addAttribute("userviewSetup", uvs);

        if(detail != null && detail.trim().length() > 0 && !"inbox".equals(detail)){
            Collection<String> columns = new ArrayList();

            UserviewProcess userviewProcess = userviewProcessManager.getUserviewProcess(detail);

            if(userviewProcess != null){
                StringTokenizer tempStringTokenizer = new StringTokenizer(userviewProcess.getTableColumn(), ",");
                Map<String, String> columnLabels = new HashMap<String, String>();

                Collection<String> sort = null;

                if(userviewProcess.getSort() != null && userviewProcess.getSort().trim().length() > 0){
                    sort = Arrays.asList(userviewProcess.getSort().replace(", ",",").split(","));
                }
                
                while (tempStringTokenizer.hasMoreTokens()) {
                    String columnNameLabel = (String) tempStringTokenizer.nextElement();
                    String [] colNameLbl = columnNameLabel.split(":");
                    String columnName = colNameLbl[0].trim();
                    String columnLabel = colNameLbl[0].trim();
                    if(colNameLbl.length > 1){
                         columnLabel = colNameLbl[1]!=null && !colNameLbl[1].trim().equals("")?colNameLbl[1].trim():colNameLbl[0].trim();
                         columnLabel = columnLabel.replaceAll("'", "\\\\'");
                    }
                    columnLabels.put(columnName, columnLabel);

                    String stringSort = "";

                    if(sort != null && sort.contains(columnName)){
                        stringSort = " | sortable: true";
                    }

                    if(columnName.endsWith("(System)")){
                        columns.add("{key: 'dynamicForm.customProperties." + columnName.replace("(System)", "") + "' | label: '" + columnLabel + "'" + stringSort + "}");
                    }else{
                        columns.add("{key: 'dynamicForm.customProperties.c_" + columnName + "' | label: '" + columnLabel + "'" + stringSort + "}");
                    }
                }

                Map<String, String> filterTypes = new LinkedHashMap<String, String>();
                if(userviewProcess.getFilter() != null && userviewProcess.getFilter().trim().length() > 0){
                    StringTokenizer tempFilterTokenizer = new StringTokenizer(userviewProcess.getFilter(), ",");
                    while (tempFilterTokenizer.hasMoreTokens()) {
                        String key = ((String) tempFilterTokenizer.nextElement()).trim();
                        filterTypes.put(key, columnLabels.get(key));
                    }
                }

                map.addAttribute("detail", detail);
                map.addAttribute("columns", columns);
                map.addAttribute("filterTypes", filterTypes);
                map.addAttribute("tableHeader", userviewProcess.getHeader());
                map.addAttribute("tableFooter", userviewProcess.getFooter());
            }
        }

        return "userview/userviewEmbedded";
    }

    @RequestMapping("/admin/userview/import")
    public String userviewImport(ModelMap map) {
        return "userview/userviewImport";
    }

    @RequestMapping(value = "/admin/userview/import/submit", method = RequestMethod.POST)
    public String userviewImportSubmit(ModelMap map) throws IOException {
        MultipartFile packageZip = FileStore.getFile("packageZip");

        String tempDir = System.getProperty("java.io.tmpdir");
        String tempFileName = "userview-packageZip-" + System.currentTimeMillis() + ".zip";
        FileOutputStream out = new FileOutputStream(new File(tempDir, tempFileName));
        out.write(packageZip.getBytes());
        out.close();

        byte[] packageData = null;
        try {
            packageData = importExportManager.getPackageDataXmlFromZip(packageZip.getBytes());
        } catch (Exception e) {
            map.addAttribute("errorMessage", e.getMessage());
            return "userview/userviewImport";
        }

        List<String> errorList = importExportManager.validateImportPackageData(packageData);
        if (!errorList.isEmpty()) {
            map.addAttribute("errorList", errorList);
            map.addAttribute("tempFileName", tempFileName);
            return "userview/userviewImportError";
        }

        return "redirect:/web/admin/userview/import/confirm?tempFileName=" + tempFileName;
    }

    @RequestMapping("/admin/userview/import/confirm")
    public String userviewImportConfirm(ModelMap map, @RequestParam("tempFileName") String tempFileName) throws IOException {
        String tempDir = System.getProperty("java.io.tmpdir");
        File tempFile = new File(tempDir, tempFileName);
        FileInputStream in = new FileInputStream(tempFile);

        byte[] bytes = new byte[(int) tempFile.length()];
        in.read(bytes);
        in.close();

        byte[] packageData = null;
        Collection<byte[]> packageXpdlList = null;
        Map<String, byte[]> mobileFormList = null;

        try {
            packageData = importExportManager.getPackageDataXmlFromZip(bytes);
            packageXpdlList = importExportManager.getAllPackageXpdlFromZip(bytes);
            mobileFormList = importExportManager.getAllMobileFormFromZip(bytes);
        } catch (Exception e) {
            map.addAttribute("errorMessage", e.getMessage());
            return "userview/userviewImport";
        }

        importExportManager.importUserview(packageData, packageXpdlList, mobileFormList);

        return "redirect:/web/admin/userview/list";
    }

    @RequestMapping("/admin/userview/export/(*:userviewId)")
    public void userviewExport(HttpServletResponse response, @RequestParam("userviewId") String userviewId) throws IOException {
        try {
            //byte[] userviewData = importExportManager.exportUserview(userviewId);

            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            String timestamp = sdf.format(new Date());

            response.setContentType("application/zip");
            response.addHeader("Content-Disposition", "attachment; filename=" + USERVIEW_ZIP_PREFIX + userviewId + "-" + timestamp + ".zip");
            ServletOutputStream stream = response.getOutputStream();

            importExportManager.exportUserview(userviewId, stream);
            
            stream.close();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
    }
}
