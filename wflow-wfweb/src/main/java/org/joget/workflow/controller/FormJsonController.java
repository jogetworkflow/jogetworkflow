package org.joget.workflow.controller;

import org.joget.form.model.Category;
import org.joget.form.model.Form;
import org.joget.form.model.FormVariable;
import org.joget.form.model.dao.DynamicFormDao;
import org.joget.form.model.dao.FormVariableDao;
import org.joget.form.model.service.FormManager;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.joget.commons.util.PagedList;
import org.joget.form.util.FormUtil;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowFacade;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class FormJsonController {

    @Autowired
    private FormManager formManager;

    @Autowired
    private FormVariableDao formVariableDao;
    
    @Autowired
    private DynamicFormDao dynamicFormDao;

    @Autowired
    private ActivityFormDao activityFormDao;

    @Autowired
    private WorkflowFacade workflowFacade;

    @RequestMapping("/json/form/list")
    public void list(Writer writer, @RequestParam(value = "categoryId", required = false) String categoryId, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        List<Form> formList = formManager.getForms(categoryId, sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (Form form : formList) {
            Map data = new HashMap();

            String formId = form.getId();
            String version = "1";

            Pattern pattern = Pattern.compile("^.+_ver_(\\d+)$");
            Matcher matcher = pattern.matcher(formId);
            while (matcher.find()) {
                version = matcher.group(1);
            }


            data.put("id", formId);
            data.put("version", version);
            data.put("name", form.getName());
            data.put("tableName", form.getTableName());
            data.put("created", form.getCreated());
            data.put("modified", form.getModified());

            String categoryName = "";
            if (form.getCategoryId() != null) {
                Category category = formManager.getCategoryById(form.getCategoryId());
                categoryName = category.getName();
            }

            data.put("categoryName", categoryName);
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", formManager.getTotalForms(categoryId));
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/form/variable/list")
    public void variableList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        Collection<FormVariable> formVariableList = formVariableDao.find("", null, sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (FormVariable formVariable : formVariableList) {
            Map data = new HashMap();
            data.put("id", formVariable.getId());
            data.put("name", formVariable.getName());
            data.put("pluginName", formVariable.getPluginName());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", formVariableDao.getTotalFormVariables());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/form/data/list/(*:formId)")
    public void formDataList(Writer writer, @RequestParam("formId") String formId, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        Form form = formManager.getFormById(formId);

        Collection<Form> dynamicFormList = dynamicFormDao.getAllDynamicFormByFormId(formId, form.getTableName(), true);
        int size = 0;
        JSONObject jsonObject = new JSONObject();
        for (Form dynamicForm : dynamicFormList) {
            if (!dynamicForm.getValueOfCustomField("draft").equals("1")) {
                Map data = new HashMap();
                data.put("id", dynamicForm.getId());
                data.put("processId", dynamicForm.getValueOfCustomField("processId"));
                data.put("version", dynamicForm.getValueOfCustomField("version"));
                data.put("username", dynamicForm.getValueOfCustomField("username"));
                data.put("created", dynamicForm.getValueOfCustomField("created"));
                data.put("modified", dynamicForm.getValueOfCustomField("modified"));
                jsonObject.accumulate("data", data);
                size++;
            }
        }

        jsonObject.accumulate("total", size);
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/form/getAllTableName")
    public void getAllTableName(Writer writer, @RequestParam(value = "callback", required = false) String callback) throws IOException , JSONException {
        List<String> tableNameList = formManager.getAllTableName();
        JSONObject jsonObject = new JSONObject();
        jsonObject.accumulate("tableName", tableNameList);
        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/form/process/list/(*:formId)")
    public void formProcessList(Writer writer, @RequestParam("formId") String formId, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        Collection<ActivityForm> activityFormList = activityFormDao.getFormByFormId(formId, null, null, null);

        Integer total = activityFormList.size();
        PagedList<ActivityForm> pagedList = new PagedList<ActivityForm>(new ArrayList<ActivityForm>(activityFormList), sort, desc, start, rows, total);

        JSONObject jsonObject = new JSONObject();
        for(ActivityForm activityForm : pagedList){
            Map data = new HashMap();
            WorkflowActivity activity = workflowFacade.getActivityById(activityForm.getProcessId(), activityForm.getActivityId());
            WorkflowProcess process = workflowFacade.getProcess(activityForm.getProcessId());
            
            if(activity != null && process != null){
                data.put("packageName", process.getPackageName());
                data.put("version", process.getVersion());
                data.put("processDefId", process.getId());
                data.put("processName", process.getName());
                data.put("activityName", activity.getName());
                jsonObject.accumulate("data", data);
            }
        }

        jsonObject.accumulate("total", total);
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/form/parents/(*:formId)")
    public void formParents(Writer writer, @RequestParam("formId") String formId, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        Collection<Form> formList = FormUtil.getParents(formId);

        Integer total = formList.size();
        PagedList<Form> pagedList = new PagedList<Form>(new ArrayList<Form>(formList), sort, desc, start, rows, total);

        JSONObject jsonObject = new JSONObject();
        for (Form form : pagedList) {
            Map data = new HashMap();

            String parentFormId = form.getId();
            String version = "1";

            Pattern pattern = Pattern.compile("^.+_ver_(\\d+)$");
            Matcher matcher = pattern.matcher(parentFormId);
            while (matcher.find()) {
                version = matcher.group(1);
            }


            data.put("id", parentFormId);
            data.put("version", version);
            data.put("name", form.getName());
            data.put("tableName", form.getTableName());
            data.put("created", form.getCreated());
            data.put("modified", form.getModified());

            String categoryName = "";
            if (form.getCategoryId() != null) {
                Category category = formManager.getCategoryById(form.getCategoryId());
                categoryName = category.getName();
            }

            data.put("categoryName", categoryName);
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", total);
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }
}
