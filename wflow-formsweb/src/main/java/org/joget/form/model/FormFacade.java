package org.joget.form.model;

import au.com.bytecode.opencsv.CSVReader;
import au.com.bytecode.opencsv.CSVWriter;
import java.io.File;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.collections.SequencedHashMap;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.FileStore;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import org.joget.commons.util.UuidGenerator;
import org.joget.form.model.dao.FormVariableDao;
import org.joget.form.model.service.FormManager;
import org.joget.form.util.FileUtil;
import org.joget.form.util.FormUtil;
import org.joget.plugin.base.FormVariablePlugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.WorkflowProcessLink;
import org.joget.workflow.model.WorkflowProcessResult;
import org.joget.workflow.model.WorkflowVariable;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.service.WorkflowManager;
import org.joget.workflow.util.WorkflowUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;

public class FormFacade {

    @Autowired
    private WorkflowManager workflowManager;

    @Autowired
    private FormManager formManager;

    @Autowired
    private ActivityFormDao activityFormDao;

    @Autowired
    private FormVariableDao formVariableDao;

    @Autowired
    private PluginManager pluginManager;

    public static final String FILE_EXTENSION = ".html";

    public FormManager getFormManager() {
        return formManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    public WorkflowManager getWorkflowManager() {
        return workflowManager;
    }

    public void setWorkflowManager(WorkflowManager workflowManager) {
        this.workflowManager = workflowManager;
    }

    public ActivityFormDao getActivityFormDao() {
        return activityFormDao;
    }

    public void setActivityFormDao(ActivityFormDao activityFormDao) {
        this.activityFormDao = activityFormDao;
    }

    public FormVariableDao getFormVariableDao() {
        return formVariableDao;
    }

    public void setFormVariableDao(FormVariableDao formVariableDao) {
        this.formVariableDao = formVariableDao;
    }

    public PluginManager getPluginManager() {
        return pluginManager;
    }

    public void setPluginManager(PluginManager pluginManager) {
        this.pluginManager = pluginManager;
    }

    public WorkflowProcessResult processStartWithForm(HttpServletRequest request, String formId, String processDefId, String parentProcessId){
        WorkflowProcessResult result = new WorkflowProcessResult();
        Form form = formManager.getFormById(formId);
        
        if(form != null){
            String processId = workflowManager.processCreateWithoutStart(processDefId);
            saveFormSubmittedData(request, formId, processId, "runProcess");
            formManager.mergeDraftToLive(form.getTableName(), processId, "runProcess");
            result = processStart(processDefId, processId, parentProcessId);
        }
        return result;
    }

    public void saveFormSubmittedData(HttpServletRequest request, String formId, String processInstanceId, String activityInstanceId) {
        WorkflowProcessLink wfProcessLink = workflowManager.getWorkflowProcessLink(processInstanceId);

        if (wfProcessLink != null) {
            processInstanceId = wfProcessLink.getOriginProcessId();
        }

        //get form id
        Form form = formManager.getFormById(formId);

        //get uploaded file(s) (if any)
        Iterator<String> fileNames = FileStore.getFileNames();

        while (fileNames.hasNext()) {
            MultipartFile file = FileStore.getFile(fileNames.next());

            if (file.getSize() > 0) {
                FileUtil.storeFile(file, processInstanceId);
                form.setValueOfCustomField("c_" + file.getName(), file.getOriginalFilename());
            }
        }
        FileStore.clear();

        //request params
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //ignore the parameter "id"
            if (!paramName.equals("id")) {
                String prefix = "";
                if (!paramName.equals("processId") && !paramName.equals("activityId") && !paramName.equals("version") && !paramName.equals("username") && !paramName.equals("processDefId") && !paramName.equals("activityDefId")) {
                    prefix = FormUtil.FIELD_PREFIX;
                }

                String[] paramValue = (String[]) request.getParameterValues(paramName);

                //check if it's grid
                String value = "";
                if (request.getParameter(paramName + "_col") != null) {
                    value = getDeliminatedStringForGrid(paramValue, Integer.parseInt(request.getParameter(paramName + "_col")));
                } else {
                    String deliminator = FormUtil.getCheckboxDeliminator(form.getData(), paramName);
                    if (deliminator.length() == 0) {
                        deliminator = "|";
                    }
                    value = CsvUtil.getDeliminatedString(paramValue, deliminator, true);
                }

                if(paramName.equals("processDefId")){
                    paramName = "processId";
                    value = processInstanceId;
                }
                if(paramName.equals("activityDefId")){
                    paramName = "activityId";
                    value = activityInstanceId;
                }
                if(paramName.equals("processId")){
                    value = processInstanceId;
                }

                if(!paramName.equals("parentProcessId")){
                    form.setValueOfCustomField(prefix + paramName, value);
                    LogUtil.debug(getClass().getName(), paramName + ":" + value);
                }
            }
        }
        form.setValueOfCustomField("formId", formId);
        form.setValueOfCustomField("draft", "1");
        form.setValueOfCustomField("modified", new Date());

        form.setId(UuidGenerator.getInstance().getUuid());

        try {
            Form savedFormData = formManager.loadDraftDynamicForm(form.getTableName(), processInstanceId, activityInstanceId);
            if (savedFormData != null) {
                form.setId(savedFormData.getId());
            } else {
                form.setValueOfCustomField("created", new Date());
            }
        } catch (Exception ex) {
        }

        formManager.saveOrUpdateDynamicForm(form);
    }

    public Map getFormSubmittedData(String formId, String processInstanceId, String activityInstanceId) {
        Map data = new SequencedHashMap();

        try {
            WorkflowProcessLink wfProcessLink = workflowManager.getWorkflowProcessLink(processInstanceId);

            if(wfProcessLink != null){
                processInstanceId = wfProcessLink.getOriginProcessId();
            }

            Form form = formManager.getFormById(formId);
            Form liveForm = formManager.loadDynamicFormByProcessId(form.getTableName(), processInstanceId);
            Form draftForm = formManager.loadDraftDynamicForm(form.getTableName(), processInstanceId, activityInstanceId);
            Form finalForm = null;

            if (liveForm == null && draftForm != null) {
                finalForm = draftForm;
            } else if (liveForm != null && draftForm == null) {
                finalForm = liveForm;
            } else if (liveForm != null && draftForm != null) {
                //merge
                Map draftData = draftForm.getCustomProperties();
                Iterator draftIte = draftData.entrySet().iterator();
                while (draftIte.hasNext()) {
                    Map.Entry pairs = (Map.Entry) draftIte.next();
                    if (pairs.getValue() instanceof String) {
                        String value = pairs.getValue().toString();
                        if (value != null && value.length() > 0) {
                            liveForm.setValueOfCustomField(pairs.getKey().toString(), pairs.getValue());
                        }
                    }

                }
                finalForm = liveForm;
            }

            //get workflow variable (even if there's no final form)
            Collection<WorkflowVariable> variableList = workflowManager.getActivityVariableList(activityInstanceId);
            for (WorkflowVariable variable : variableList) {
                if (variable.getVal() != null) {
                    data.put("var_" + variable.getId(), (String) variable.getVal());
                }
            }

            if (finalForm != null) {
                Map<String, String> customProperties = finalForm.getCustomProperties();

                Iterator it = customProperties.entrySet().iterator();
                while (it.hasNext()) {
                    Map.Entry pairs = (Map.Entry) it.next();
                    if (pairs.getValue() != null) {
                        CSVReader reader = new CSVReader(new StringReader(pairs.getValue().toString()));
                        List entries = reader.readAll();
                        if (entries.size() == 1) {
                            String[] array = (String[]) entries.get(0);
                            if (array.length == 1) {
                                //for normal input fields
                                data.put(pairs.getKey(), array[0]);
                            } else {
                                //for single row grid data
                                Map temp = new HashMap();
                                String rowString = "";
                                //format into : "xxx"|"yyy"|"zzz"
                                for (String column : array) {
                                    column = "\"" + column + "\"";
                                    rowString += column + "|";
                                }
                                //remove trailing deliminator
                                rowString = rowString.substring(0, rowString.length() - 1);
                                temp.put(0, rowString);
                                data.put(pairs.getKey(), temp);
                            }

                        } else if (entries.size() > 1) {
                            //for multiple row grid data
                            Map temp = new HashMap();
                            for (int i = 0; i < entries.size(); i++) {
                                String[] row = (String[]) entries.get(i);
                                String rowString = "";
                                //format into : "xxx"|"yyy"|"zzz"
                                for (String column : row) {
                                    column = "\"" + column + "\"";
                                    rowString += column + "|";
                                }
                                //remove trailing deliminator
                                rowString = rowString.substring(0, rowString.length() - 1);
                                temp.put(i, rowString);
                            }
                            data.put(pairs.getKey(), temp);
                        }
                    }
                }
            }
        } catch (Exception e) {
            LogUtil.error(getClass().getName(), e, "");
        }

        return data;
    }

    public String getDeliminatedStringForGrid(String[] array, int numOfCol) {
        StringWriter sw = new StringWriter();

        try {
            CSVWriter writer = new CSVWriter(sw);

            int i = 0;
            List<String> row = new ArrayList();
            while (i < array.length) {
                row.add(array[i]);
                i++;
                if (i % numOfCol == 0) {
                    writer.writeNext(row.toArray(new String[numOfCol]));
                    row.clear();
                }
            }
            writer.close();
        } catch (Exception e) {
            LogUtil.error(getClass().getName(), e, "");
        }

        return sw.toString();
    }

    public String getFormPath() {
        String path = SetupManager.getBaseDirectory();
        if (!path.endsWith(File.separator)) {
            path += File.separator;
        }
        path += "forms" + File.separator;

        return path;
    }

    public WorkflowAssignment getAssignment(String activityInstanceId){
        return workflowManager.getAssignment(activityInstanceId);
    }

    public WorkflowAssignment getMockAssignment(String activityInstanceId){
        return workflowManager.getMockAssignment(activityInstanceId);
    }

    public WorkflowProcess getProcess(String processDefId){
        return workflowManager.getProcess(processDefId);
    }

    public WorkflowProcessResult processStart(String processDefId){
        return workflowManager.processStart(processDefId);
    }

    public WorkflowProcessResult processStart(String processDefId, String processInstanceId, String parentProcessId){
        Map<String, String> variables = WorkflowUtil.getWorkflowVariableValueFromFormData(processDefId, processInstanceId, "runProcess");

        return workflowManager.processStart(processDefId, processInstanceId, variables, null, parentProcessId, false);
    }

    public Form getFormById(String id){
        return formManager.getFormById(id);
    }

    public Collection<ActivityForm> getFormByActivity(String processId, int version, String activityId){
        return activityFormDao.getFormByActivity(processId, version, activityId);
    }

    public void mergeDraftToLive(String tableName, String processId, String activityId){
        WorkflowProcessLink wfProcessLink = workflowManager.getWorkflowProcessLink(processId);

        if(wfProcessLink != null){
            processId = wfProcessLink.getOriginProcessId();
        }
        formManager.mergeDraftToLive(tableName, processId, activityId);
    }

    public void saveForm(Form form){
        formManager.saveForm(form);
    }

    public Collection<Category> getCategories(String sort, Boolean desc, Integer start, Integer rows){
        return formManager.getCategories(sort, desc, start, rows);
    }

    public Collection<FormVariable> getFormVariableList(String sort, Boolean desc, Integer start, Integer rows){
        return formVariableDao.find("", null, sort, desc, start, rows);
    }

    public Integer getTotalFormVariables(){
        return formVariableDao.getTotalFormVariables();
    }

    public FormVariable getFormVariable(String id){
        return formVariableDao.find(id);
    }

    public FormVariablePlugin getFormVariablePlugin(String pluginName){
        return (FormVariablePlugin) pluginManager.getPlugin(pluginName);
    }

    public boolean isActivityContinueNextAssignment(String processDefId, String activityDefId){
        return workflowManager.isActivityContinueNextAssignment(processDefId, activityDefId);
    }
}