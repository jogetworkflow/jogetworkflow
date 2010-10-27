package org.joget.form.web;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.servlet.http.HttpServletRequest;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.form.model.Form;
import org.joget.form.model.FormFacade;
import org.joget.form.util.FormUtil;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.util.WorkflowUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.HibernateObjectRetrievalFailureException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MobileFormController {

    @Autowired
    private FormFacade formFacade;

    @RequestMapping("/formbuilder/mobileView/(*:id)")
    public String mobileView(ModelMap map,
            HttpServletRequest request,
            @RequestParam("id") String id,
            @RequestParam(value = "processId", required = false) String processInstanceId,
            @RequestParam(value = "activityId", required = false) String activityInstanceId,
            @RequestParam(value = "processDefId", required = false) String processDefId,
            @RequestParam(value = "activityDefId", required = false) String activityDefId,
            @RequestParam(value = "version", required = false) String version,
            @RequestParam(value = "username", required = false) String username,
            @RequestParam(value = "preview", required = false) Boolean preview) throws IOException {
        if (id == null) {
            return "formbuilder/invalidId";
        }
        
        //fix for Android 2.1 browser: wrongly appended activityInstanceId
        if(activityInstanceId != null && activityInstanceId.trim().length() > 0){
            if(activityInstanceId.split(",").length > 1){
                activityInstanceId = activityInstanceId.split(",")[0];
            }
        }

        try {
            formFacade.getFormById(id);
        } catch (HibernateObjectRetrievalFailureException e) {
            return "formbuilder/invalidId";
        }

        Form form = formFacade.getFormById(id);

        //read html
        String html = "";
        BufferedReader in = null;
        try {
            FileReader rstream = new FileReader(formFacade.getFormPath() + id + FormFacade.FILE_EXTENSION);
            in = new BufferedReader(rstream);

            String str;
            while ((str = in.readLine()) != null) {
                html += str;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return "formbuilder/invalidId";
        } finally {
            if (in != null) {
                in.close();
            }
        }

        //data insertion
        if (html.trim().length() > 0 && ("runProcess".equals(activityDefId) || (activityInstanceId != null && activityInstanceId.trim().length() > 0))) {
            Pattern pattern = Pattern.compile("\\#([^#^\"])*\\#");
            Matcher matcher = pattern.matcher(html);
            List<String> varList = new ArrayList<String>();
            while (matcher.find()) {
                varList.add(matcher.group());
            }

            Map data = null;

            if( processInstanceId != null && processInstanceId.trim().length() > 0 && activityInstanceId != null && activityInstanceId.trim().length() > 0){
                data = formFacade.getFormSubmittedData(id, processInstanceId, activityInstanceId);
            }
            if("runProcess".equals(activityDefId)){
                data = new HashMap<String,String>();
                for (String var : varList) {
                    String tempVar = var.replaceAll("#", "");
                    String paramName = tempVar.split("\\.")[1];
                    String[] paramValue = (String[]) request.getParameterValues(paramName);

                    String value = "";
                    if(paramValue != null){
                        String deliminator = FormUtil.getCheckboxDeliminator(form.getData(), paramName);
                        if (deliminator.length() == 0) {
                            deliminator = "|";
                        }
                        value = CsvUtil.getDeliminatedString(paramValue, deliminator, true);
                    }

                    data.put("c_"+paramName, value);
                }
            }

            try {
                for (String var : varList) {
                    String tempVar = var.replaceAll("#", "");

                    if (tempVar.startsWith("input")) {
                        String fieldName = tempVar.replace("input.", "");

                        String workflowVariableId = "";
                        if (fieldName.contains(".")) {
                            workflowVariableId = fieldName.split("\\.")[1];
                            fieldName = fieldName.split("\\.")[0];
                        }

                        if (fieldName != null && fieldName.length() != 0) {
                            String value = (String) data.get("c_" + fieldName);

                            if(data.get("c_" + fieldName) == null){
                                value = (String) data.get(fieldName);
                            }

                            if (value != null && value.length() != 0) {
                                html = html.replaceAll(var, value);
                            } else {
                                if (workflowVariableId != null && workflowVariableId.length() != 0) {
                                    value = (String) data.get("var_" + workflowVariableId);
                                    if (value != null && value.length() != 0) {
                                        html = html.replaceAll(var, value);
                                    } else {
                                        html = html.replaceAll(var, "");
                                    }
                                } else {
                                    html = html.replaceAll(var, "");
                                }
                            }
                        } else {
                            html = html.replaceAll(var, "");
                        }

                    } else if (tempVar.startsWith("select") || tempVar.startsWith("radio")) {
                        String fieldValue = tempVar.split("\\.")[2];
                        String fieldName = tempVar.split("\\.")[1];

                        String value = (String) data.get("c_" + fieldName);
                        if (value != null && value.trim().length() > 0) {
                            if (value.equals(fieldValue)) {
                                html = html.replaceAll(var, (tempVar.startsWith("select")) ? "selected" : "checked");
                            } else {
                                html = html.replaceAll(var, "");
                            }
                        } else {
                            html = html.replaceAll(var, "");
                        }

                    } else if (tempVar.startsWith("checkbox")) {
                        String fieldValue = tempVar.split("\\.")[2];
                        String fieldName = tempVar.split("\\.")[1];

                        String value = (String) data.get("c_" + fieldName);

                        if (value != null && value.trim().length() > 0) {
                            String deliminator = FormUtil.getCheckboxDeliminator(form.getData(), fieldName);
                            if (deliminator.equals("|")) {
                                deliminator = "\\" + deliminator;
                            }
                            String[] values = value.split(deliminator);

                            List<String> valueList = Arrays.asList(values);
                            if (valueList.contains(fieldValue)) {
                                html = html.replaceAll(var, "checked");
                            } else {
                                html = html.replaceAll(var, "");
                            }
                        } else {
                            html = html.replaceAll(var, "");
                        }
                    }
                }
            } catch (Exception e) {
                LogUtil.error(getClass().getName(), e, "");
            }
        }

        WorkflowAssignment ass = formFacade.getAssignment(activityInstanceId);
        if(ass == null){
                ass = formFacade.getMockAssignment(activityInstanceId);
        }
        html = WorkflowUtil.processVariable(html, form.getTableName(), ass);

        map.addAttribute("html", html);
        map.addAttribute("id", form.getId());
        map.addAttribute("name", form.getName());
        map.addAttribute("processDefId", processDefId);
        map.addAttribute("activityDefId", activityDefId);
        map.addAttribute("processId", processInstanceId);
        map.addAttribute("activityId", activityInstanceId);
        map.addAttribute("version", version);
        map.addAttribute("username", username);

        return "formbuilder/mobileView";
    }

    @RequestMapping("/formbuilder/mobileSubmit")
    public String mobileSubmit(ModelMap map,
            HttpServletRequest request,
            @RequestParam("id") String id,
            @RequestParam("processId") String processInstanceId,
            @RequestParam("activityId") String activityInstanceId,
            @RequestParam("processDefId") String processDefId,
            @RequestParam("activityDefId") String activityDefId,
            @RequestParam("version") String version,
            @RequestParam("username") String username) throws IOException {
        //get form id
        Form form = formFacade.getFormById(id);

        //required field validation
        boolean containError = false;
        List<String> errorList = new ArrayList<String>();
        Enumeration e = request.getParameterNames();

        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //remove "counter2_" to check radio button and checkbox
            if(paramName.startsWith("counter2_")){
                String tempParamName = paramName.replace("counter2_", "");
                if(request.getParameter("counter_"+tempParamName) != null){
                    paramName = tempParamName;
                }
            }

            //check required field
            if (FormUtil.isRequiredField(form.getData(), paramName)) {
                String value = request.getParameter(paramName);
                if (value == null || value.length() == 0) {
                    containError = true;
                    errorList.add(FormUtil.getFieldLabel(form.getData(), paramName));
                }
            }
        }

        if (containError) {
            map.addAttribute("errorList", errorList);
            map.addAttribute("username", username);

            if("runProcess".equals(activityDefId)){
                map.addAttribute("version", version);
                Collection<ActivityForm> activityForm = formFacade.getFormByActivity(processDefId, Integer.parseInt(version), "runProcess");
                map.addAttribute("form", activityForm.iterator().next());
                return "workflow/mobileProcessStartWithForm";
            }else{
                WorkflowAssignment assignment = formFacade.getAssignment(activityInstanceId);
                if (assignment != null) {
                    map.addAttribute("assignment", assignment);
                    Collection<ActivityForm> activityForm = formFacade.getFormByActivity(assignment.getProcessDefId(), Integer.parseInt(assignment.getProcessVersion()), assignment.getActivityDefId());
                    map.addAttribute("form", activityForm);

                    formFacade.saveFormSubmittedData(request, id, assignment.getProcessId(), assignment.getActivityId());

                }else{
                    map.addAttribute("error", "nullAssignment");
                }
                return "workflow/mobileAssignmentView";
            }
        } else {
            if("runProcess".equals(activityDefId)){
                activityInstanceId = activityDefId;
                formFacade.processStartWithForm(request, id, processDefId, null);
                return "workflow/mobileProcessStarted";
            }else{
                formFacade.saveFormSubmittedData(request, id, processInstanceId, activityInstanceId);
                return "redirect:/web/client/mobile/assignment/complete/" + activityInstanceId;
            }
        }
    }
}