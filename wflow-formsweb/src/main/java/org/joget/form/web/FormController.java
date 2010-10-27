package org.joget.form.web;

import org.joget.form.model.Form;
import org.joget.form.util.FormUtil;
import java.io.IOException;
import java.io.Writer;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateObjectRetrievalFailureException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import java.io.BufferedWriter;
import org.joget.commons.util.CsvUtil;
import org.joget.form.model.FormVariable;
import org.joget.form.util.FileUtil;
import org.joget.plugin.base.FormVariablePlugin;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.util.Collection;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import org.joget.commons.util.StringUtil;
import org.joget.form.model.FormFacade;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.WorkflowProcessResult;
import org.joget.workflow.util.PluginUtil;
import org.joget.workflow.util.WorkflowUtil;

@Controller
public class FormController {

    @Autowired
    private FormFacade formFacade;

    @RequestMapping(value = "/formbuilder/admin/json/save", method = RequestMethod.POST)
    public void save(Writer writer, @RequestParam(value = "id") String id, @RequestParam("data") String data, @RequestParam("html") String html) throws IOException, JSONException {
        Form form = formFacade.getFormById(id);

        form.setData(data);
        form.setModified(new Date());
        formFacade.saveForm(form);

        //write html to file
        BufferedWriter out = null;
        try {
            new File(formFacade.getFormPath()).mkdirs();
            FileWriter fstream = new FileWriter(formFacade.getFormPath() + id + FormFacade.FILE_EXTENSION);

            out = new BufferedWriter(fstream);
            out.write(html);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            if (out != null) {
                out.close();
            }
        }

        writer.write("{success:true}");
    }

    @RequestMapping("/formbuilder/admin/edit/(*:id)")
    public String edit(ModelMap map, @RequestParam("id") String id) {
        Form form = null;

        if (id == null) {
            return "formbuilder/invalidId";
        }

        try {
            form = formFacade.getFormById(id);
        } catch (HibernateObjectRetrievalFailureException e) {
            return "formbuilder/invalidId";
        }

        map.addAttribute("id", id);
        map.addAttribute("name", form.getName());
        return "formbuilder/index";
    }

    @RequestMapping("/formbuilder/list")
    public String formList(ModelMap map) {
        map.addAttribute("categoryList", formFacade.getCategories(null, null, null, null));
        return "formbuilder/formList";
    }

    @RequestMapping("/formbuilder/variable/list")
    public String variableList() {
        return "formbuilder/variableList";
    }

    @RequestMapping("/formbuilder/variable/json/list")
    public void getFormVariableList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        Collection<FormVariable> formVariableList = formFacade.getFormVariableList(sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (FormVariable formVariable : formVariableList) {
            Map data = new HashMap();
            data.put("id", formVariable.getId());
            data.put("name", formVariable.getName());
            data.put("pluginName", formVariable.getPluginName());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", formFacade.getTotalFormVariables());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/formbuilder/variable/getName/(*:id)")
    public void getFormVariableName(Writer writer, @RequestParam("id") String id) throws IOException, JSONException {
        FormVariable formVariable = formFacade.getFormVariable(id);

        JSONObject jsonObject = new JSONObject();
        jsonObject.accumulate("data", (formVariable == null) ? "" : formVariable.getName());
        jsonObject.write(writer);
    }

    @RequestMapping("/formbuilder/json/getFormData/(*:id)")
    public void getFormData(Writer writer, @RequestParam("id") String id,
            @RequestParam(value = "activityId", required = false) String activityInstanceId) throws IOException {
        Form form = formFacade.getFormById(id);

        String formData = form.getData();

        if (formData == null) {
            formData = "";
        }else{
            WorkflowAssignment ass = formFacade.getAssignment(activityInstanceId);

            if(ass == null){
                ass = formFacade.getMockAssignment(activityInstanceId);
            }

            formData = WorkflowUtil.processVariable(formData, form.getTableName(), ass, StringUtil.TYPE_JSON);
        }

        writer.write(formData);
    }

    @RequestMapping("/formbuilder/json/getSubForm/(*:id)")
    public void getSubForm(Writer writer, @RequestParam("id") String id, @RequestParam(value = "activityId", required = false) String activityInstanceId) throws IOException, JSONException {
        Form form = formFacade.getFormById(id);

        String formData = "{}";

        if (form != null && form.getData() != null) {
            formData = form.getData();

            WorkflowAssignment ass = formFacade.getAssignment(activityInstanceId);

            if(ass == null){
                ass = formFacade.getMockAssignment(activityInstanceId);
            }

            formData = WorkflowUtil.processVariable(formData, form.getTableName(), ass, StringUtil.TYPE_JSON);
        }

        writer.write(formData);
    }

    @RequestMapping("/formbuilder/view/(*:id)")
    public String view(ModelMap map, @RequestParam("id") String id) {
        if (id == null) {
            return "formbuilder/invalidId";
        }

        Form form = null;
        try {
            form = formFacade.getFormById(id);
        } catch (HibernateObjectRetrievalFailureException e) {
            return "formbuilder/invalidId";
        }
        if (form == null) {
            return "formbuilder/invalidId";
        }

        map.addAttribute("form", form);
        map.addAttribute("id", form.getId());
        map.addAttribute("name", form.getName());
        map.addAttribute("numOfSubForm", FormUtil.getNumberOfSubForm(form.getData()));

        return "formbuilder/view";
    }

    @RequestMapping("/formbuilder/submit")
    public void submit(Writer writer, HttpServletRequest request, @RequestParam(value="processDefId", required=false) String processDefId, @RequestParam(value="processId", required=false) String processInstanceId, @RequestParam("activityId") String activityInstanceId, @RequestParam(required=false, value="parentProcessId") String parentProcessId) throws IOException {
        if(processDefId != null && processDefId.trim().length() > 0){
            //runProcess form submission
            WorkflowProcessResult result = formFacade.processStartWithForm(request, request.getParameter("id"), processDefId, parentProcessId);
            boolean continueNextAssignment = formFacade.isActivityContinueNextAssignment(processDefId, "runProcess");
            WorkflowProcess processStarted = result.getProcess();
            String processId = (processStarted != null) ? processStarted.getInstanceId() : null;
            String activityId = null;
            Collection<WorkflowActivity> activities = result.getActivities();
            if (continueNextAssignment && activities != null && activities.size() > 0) {
                activityId = ((WorkflowActivity)activities.iterator().next()).getId();
            }
            
            if (processId != null && activityId != null && continueNextAssignment) {
                writer.write("{activityId:\"" + activityId + "\", processId:\"" + processId + "\"}");
            }else{
                writer.write("{success:true}");
            }
        }else if(processInstanceId != null && processInstanceId.trim().length() > 0){
            //normal form submission
            formFacade.saveFormSubmittedData(request, request.getParameter("id"), processInstanceId, activityInstanceId);
            writer.write("{success:true}");
        }
    }

    @RequestMapping("/formbuilder/file/get")
    public void getFile(HttpServletResponse response, @RequestParam("fileName") String fileName, @RequestParam("processId") String processInstanceId) throws IOException {
        ServletOutputStream stream = response.getOutputStream();
        File file = FileUtil.getFile( new String(fileName.getBytes("ISO-8859-1"),"UTF-8") , processInstanceId);
        DataInputStream in = new DataInputStream(new FileInputStream(file));
        byte[] bbuf = new byte[65536];

        try {
            response.addHeader("Content-Disposition", "attachment; filename=" + fileName);
            int length = 0;
            while ((in != null) && ((length = in.read(bbuf)) != -1)) {
                stream.write(bbuf, 0, length);
            }
        } finally {
            in.close();
            stream.flush();
            stream.close();
        }
    }

    @RequestMapping("/formbuilder/json/getData")
    public void getData(Writer writer, @RequestParam("id") String id, @RequestParam("processId") String processInstanceId, @RequestParam("activityId") String activityInstanceId) throws IOException, JSONException {
        Map data = formFacade.getFormSubmittedData(id, processInstanceId, activityInstanceId);

        JSONObject jsonObject = new JSONObject();
        jsonObject.accumulate("data", data);
        jsonObject.write(writer);
    }

    @RequestMapping("/formbuilder/getFormVariable")
    public void getFormVariable(Writer writer, @RequestParam("formVariableId") String formVariableId) throws IOException, JSONException {
        FormVariable formVariable = formFacade.getFormVariable(formVariableId);
        if(formVariable != null){
            String properties = formVariable.getPluginProperties();
            Map propertyMap = CsvUtil.getPluginPropertyMap(properties);

            FormVariablePlugin plugin = formFacade.getFormVariablePlugin(formVariable.getPluginName());

            propertyMap.put("pluginManager", formFacade.getPluginManager());
            Map result = plugin.getVariableOptions(PluginUtil.getDefaultProperties(formVariable.getPluginName(), propertyMap));

            JSONObject jsonObject = new JSONObject();
            jsonObject.accumulate("data", result);
            jsonObject.write(writer);
        }else{
            writer.write("{\"data\" : {}}");
        }
    }

    @RequestMapping("/formbuilder/message")
    public String formbuilderMessage(ModelMap map, HttpServletRequest request) {
        return "formbuilder/formbuilderLang";
    }
}
