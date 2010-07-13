package org.joget.workflow.controller;

import au.com.bytecode.opencsv.CSVWriter;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.form.model.Form;
import org.joget.form.model.FormVariable;
import org.joget.form.model.dao.FormVariableDao;
import org.joget.form.model.service.FormManager;
import org.joget.plugin.base.FormVariablePlugin;
import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.dao.ActivityFormDao;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.StringTokenizer;
import javax.servlet.http.HttpServletRequest;
import org.joget.workflow.model.PluginDefaultProperties;
import org.joget.workflow.model.dao.PluginDefaultPropertiesDao;
import org.joget.workflow.util.PluginUtil;
import org.springframework.validation.Validator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class FormWebController {

    @Autowired
    private FormManager formManager;

    @Autowired
    private ActivityFormDao activityFormDao;

    @Autowired
    private FormVariableDao formVariableDao;

    @Autowired
    private PluginManager pluginManager;
    
    @Autowired
    private Validator validator;

    @Autowired
    private PluginDefaultPropertiesDao pluginDefaultPropertiesDao;

    @RequestMapping("/admin/form/general/list")
    public String formList(ModelMap map) {
        map.addAttribute("categoryList", formManager.getCategories("name", Boolean.FALSE, null, null));
        return "form/formList";
    }

    @RequestMapping("/admin/form/general/view/(*:formId)")
    public String formView(ModelMap map, @RequestParam("formId") String formId) throws IOException {
        Form form = formManager.getFormById(formId);
        
        //TODO: set url for formsweb to view

        map.addAttribute("form", form);
        return "form/formView";
    }

    @RequestMapping("/admin/form/general/edit/(*:formId)")
    public String formEdit(ModelMap map, @RequestParam("formId") String formId) throws IOException {
        Form form = formManager.getFormById(formId);
        map.addAttribute("form", form);
        map.addAttribute("categories", formManager.getCategories("name", Boolean.FALSE, null, null));
        return "form/formEdit";
    }

    @RequestMapping("/admin/form/general/create")
    public String formCreate(ModelMap map) {
        map.addAttribute("form", new Form());
        map.addAttribute("categories", formManager.getCategories("name", Boolean.FALSE, null, null));
        map.addAttribute("categoryList", formManager.getCategories(null, null, null, null));
        return "form/formCreate";
    }

    @RequestMapping(value = "/admin/form/general/create/submit", method = RequestMethod.POST)
    public String formCreateSubmit(ModelMap map, @ModelAttribute("form") Form form, BindingResult result, @RequestParam(value = "processId", required = false) String processId, @RequestParam(value = "version", required = false) String version, @RequestParam(value = "activityId", required = false) String activityId, @RequestParam(value = "redirect", required = false) String redirect, @RequestParam(value = "copyFormId", required = false) String copyFormId) {
        validator.validate(form, result);

        if (result.hasErrors()) {
            return "form/formCreate";
        }

        if(copyFormId != null && copyFormId.trim().length() != 0){
            Form f = formManager.getFormById(copyFormId);

            if(f != null){
                form.setData(f.getData());
            }
        }

        form.setCreated(new Date());
        form.setModified(new Date());
        formManager.saveForm(form);
        map.addAttribute("form", form);

        //if from activity form mapping
        if (activityId != null && activityId.trim().length() != 0) {
            activityFormDao.unassignAllFormFromActivity(processId, Integer.parseInt(version), activityId);
            activityFormDao.assignSingleFormToActivity(form.getId(), processId, Integer.parseInt(version), activityId);
        }

        map.addAttribute("redirect", redirect);

        return "form/formCreateSuccess";
    }

    @RequestMapping(value = "/admin/form/general/delete", method = RequestMethod.POST)
    public String formDelete(@RequestParam("formId") String formId) throws IOException {
        formManager.deleteForm(formId);
        activityFormDao.unassignFormFromAllActivity(formId);
        return "form/formList";
    }

    @RequestMapping(value = "/admin/form/general/deleteMultiple", method = RequestMethod.POST)
    public String formDeleteMultiple(@RequestParam("ids") String ids) throws IOException {
        StringTokenizer strToken = new StringTokenizer(ids, ",");

        while (strToken.hasMoreTokens()) {
            String formId = (String) strToken.nextElement();
            formManager.deleteForm(formId);
            activityFormDao.unassignFormFromAllActivity(formId);
        }

        return "form/formList";
    }

    @RequestMapping(value = "/admin/form/general/save", method = RequestMethod.POST)
    public String formSave(Writer writer, @ModelAttribute("form") Form form) throws IOException {
        Form oldForm = formManager.getFormById(form.getId());
        oldForm.setName(form.getName());
        oldForm.setTableName(form.getTableName());
        oldForm.setCategoryId(form.getCategoryId());
        formManager.saveForm(oldForm);
        return "form/formEditSuccess";
    }

    @RequestMapping("/settings/form/variable/list")
    public String formVariableList(ModelMap map) {
        return "form/variableList";
    }

    @RequestMapping("/settings/form/variable/view/(*:formVariableId)")
    public String formVariableView(ModelMap map, @RequestParam("formVariableId") String formVariableId) throws IOException {
        FormVariable formVariable = formVariableDao.find(formVariableId);

        //generate preview
        String properties = formVariable.getPluginProperties();
        Map propertyMap = CsvUtil.getPluginPropertyMap(properties);
        propertyMap.put("pluginManager", pluginManager);
        FormVariablePlugin plugin = (FormVariablePlugin) pluginManager.getPlugin(formVariable.getPluginName());
        Map result = plugin.getVariableOptions(PluginUtil.getDefaultProperties(formVariable.getPluginName(), propertyMap));
        //end preview

        map.addAttribute("resultPreview", result);
        map.addAttribute("formVariable", formVariable);
        return "form/variableView";
    }

    @RequestMapping(value = "/settings/form/variable/delete", method = RequestMethod.POST)
    public String formVariableDelete(@RequestParam("formVariableId") String formVariableId) throws IOException {
        FormVariable formVariable = formVariableDao.find(formVariableId);
        formVariableDao.delete(formVariable);
        return "form/variableList";
    }

    @RequestMapping("/settings/form/variable/create")
    public String formVariableCreate(ModelMap map) {
        map.addAttribute("formVariable", new FormVariable());
        return "form/variableCreate";
    }

    @RequestMapping("/settings/form/variable/edit/(*:id)")
    public String formVariableEdit(ModelMap map, @RequestParam("id") String id) {
        FormVariable formVariable = formVariableDao.find(id);
        map.addAttribute("formVariable", formVariable);
        return "form/variableEdit";
    }

    @RequestMapping(value = "/settings/form/variable/create/submit", method = RequestMethod.POST)
    public String formVariableCreateSubmit(ModelMap map, @ModelAttribute("formVariable") FormVariable formVariable, BindingResult result) {
        validator.validate(formVariable, result);

        if (result.hasErrors()) {
            return "form/variableCreate";
        }

        String formVariableId = (String) formVariableDao.save(formVariable);

        map.addAttribute("formVariableId", formVariableId);
        return "form/variableCreateSuccess";
    }

    @RequestMapping(value = "/settings/form/variable/edit/submit", method = RequestMethod.POST)
    public String formVariableEditSubmit(ModelMap map, @ModelAttribute("formVariable") FormVariable formVariable, BindingResult result) {
        FormVariable existingFormVariable = formVariableDao.find(formVariable.getId());
        formVariable.setPluginName(existingFormVariable.getPluginName());
        formVariable.setPluginProperties(existingFormVariable.getPluginProperties());

        validator.validate(formVariable, result);

        if (result.hasErrors()) {
            return "form/variableEdit";
        }

        formVariableDao.saveOrUpdate(formVariable);

        return "form/variableEditSuccess";
    }

    @RequestMapping("/settings/form/variable/configure")
    public String formVariableConfigure(ModelMap map, @RequestParam("id") String formVariableId) throws IOException {
        FormVariable formVariable = formVariableDao.find(formVariableId);

        Map propertyMap = new HashMap();
        if (formVariable.getPluginProperties() != null && formVariable.getPluginProperties().trim().length() > 0) {
            propertyMap = CsvUtil.getPluginPropertyMap(formVariable.getPluginProperties());
        }

        PluginDefaultProperties pluginDefaultProperties = pluginDefaultPropertiesDao.find(formVariable.getPluginName());
        Map defaultPropertyMap = new HashMap();
        if (pluginDefaultProperties != null) {
            String properties = pluginDefaultProperties.getPluginProperties();
            if (properties != null && properties.trim().length() > 0) {
                defaultPropertyMap = CsvUtil.getPluginPropertyMap(properties);
            }
        }

        Plugin plugin = pluginManager.getPlugin(formVariable.getPluginName());
        map.addAttribute("plugin", plugin);
        map.addAttribute("propertyMap", propertyMap);
        map.addAttribute("defaultPropertyMap", defaultPropertyMap);
        map.addAttribute("formVariableId", formVariableId);
        return "form/variableConfig";
    }

    @RequestMapping("/settings/form/variable/configure/submit")
    public String formVariableConfigureSubmit(ModelMap map, @RequestParam("formVariableId") String formVariableId, HttpServletRequest request) {
        //remove existing properties
        formVariableDao.removePluginProperties(formVariableId);

        //request params
        Map<String, String> propertyMap = new HashMap();
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //ignore the parameter "formVariableId"
            if (!paramName.equals("formVariableId")) {
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
        formVariableDao.setPluginProperties(formVariableId, sw.toString());

        return "form/variableConfigSuccess";
    }
}
