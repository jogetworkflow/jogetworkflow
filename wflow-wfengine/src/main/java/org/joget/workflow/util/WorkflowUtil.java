package org.joget.workflow.util;

import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.directory.model.User;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.form.model.Form;
import org.joget.form.model.service.FormManager;
import org.joget.plugin.base.ParticipantPlugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.ParticipantDirectory;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowParticipant;
import org.joget.workflow.model.WorkflowVariable;
import org.joget.workflow.model.dao.ParticipantDirectoryDao;
import org.joget.commons.util.SetupManager;
import org.joget.workflow.model.service.AuditTrailManager;
import org.joget.workflow.model.service.WorkflowManager;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.joget.commons.util.StringUtil;
import org.joget.form.util.FormUtil;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowProcessLink;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class WorkflowUtil implements ApplicationContextAware {

    public static final String FORM_DATA = "form";
    public static final String WORKFLOW_ASSIGNMENT = "assignment";
    public static final String WORKFLOW_VARIABLE = "variable";
    public static final String WORKFLOW_USER = "user";
    public static final String WORKFLOW_USER_VARIABLE = "uservariable";
    public static final String DATE = "date";
    public static final String CURRENT_USERNAME = "currentUsername";
    public static final String PERFORMER = "performer";
    public static final String ROLE_ADMIN = WorkflowUserManager.ROLE_ADMIN;

    static ApplicationContext appContext;

    public static ApplicationContext getApplicationContext() {
        return appContext;
    }

    public static List<String> getAssignmentUsers(String packageId, String procDefId, String procId, String version, String actId, String requesterUsername, String participantId){
        List<String> resultList = null;

        try{
            ParticipantDirectoryDao participantDirectoryDao = (ParticipantDirectoryDao) appContext.getBean("participantDirectoryDao");
            DirectoryManager directoryManager = (DirectoryManager) appContext.getBean("directoryManager");
            WorkflowManager workflowManager = (WorkflowManager) appContext.getBean("workflowManager");
            PluginManager pluginManager = (PluginManager) appContext.getBean("pluginManager");

            //check if it's package level or process level
            WorkflowParticipant par = workflowManager.getParticipantMap(procDefId).get(participantId);

            if(participantId.equals("processStartWhiteList")){
                par = new WorkflowParticipant();
                par.setId("processStartWhiteList");
                par.setPackageLevel(false);
            }

            Collection<ParticipantDirectory> results = null;
            if(!par.isPackageLevel()){
                results = participantDirectoryDao.getMappingByParticipantId(packageId, procDefId, Integer.parseInt(version), participantId);
            }else{
                results = participantDirectoryDao.getMappingByParticipantId(packageId, null, Integer.parseInt(version), participantId);
            }

            if(results.size() == 0){
                return null;
            }

            ParticipantDirectory participant = results.iterator().next();

            if (participant.getType().equals(ParticipantDirectoryDao.TYPE_USER)) {
                resultList = new ArrayList<String>();
                String[] users = participant.getValue().split(ParticipantDirectoryDao.SEPARATOR);

                for (String userId : users) {
                    User user = directoryManager.getUserById(userId);
                    if(user != null && user.getActive() == User.ACTIVE) {
                        resultList.add(user.getUsername());
                    }
                }

            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_GROUP)) {
                resultList = new ArrayList<String>();
                String[] groups = participant.getValue().split(",");

                for (String groupId : groups) {
                    Collection<User> users = directoryManager.getUserByGroupId(groupId);
                    for(User user : users){
                        if(user != null && user.getActive() == User.ACTIVE) {
                            resultList.add(user.getUsername());
                        }
                    }
                }
            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER)) {

                if(participant.getValue() != null && participant.getValue().trim().length() > 0){
                    requesterUsername = workflowManager.getUserByProcessIdAndActivityDefId(procDefId, procId, participant.getValue());
                }

                resultList = new ArrayList<String>();

                if(requesterUsername != null && requesterUsername.trim().length() > 0) {
                    resultList.add(requesterUsername);
                }

            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER_HOD)) {

                if(participant.getValue() != null && participant.getValue().trim().length() > 0){
                    requesterUsername = workflowManager.getUserByProcessIdAndActivityDefId(procDefId, procId, participant.getValue());
                }

                resultList = new ArrayList<String>();

                Collection<User> users = directoryManager.getUserHod(requesterUsername);
                for(User user : users){
                    if(user != null && user.getActive() == User.ACTIVE) {
                        resultList.add(user.getUsername());
                    }
                }

            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER_SUBORDINATE)) {

                if(participant.getValue() != null && participant.getValue().trim().length() > 0){
                    requesterUsername = workflowManager.getUserByProcessIdAndActivityDefId(procDefId, procId, participant.getValue());
                }

                resultList = new ArrayList<String>();

                Collection<User> users = directoryManager.getUserSubordinate(requesterUsername);
                for(User user : users){
                    if(user != null && user.getActive() == User.ACTIVE) {
                        resultList.add(user.getUsername());
                    }
                }

            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_REQUESTER_DEPARTMENT)) {

                if(participant.getValue() != null && participant.getValue().trim().length() > 0){
                    requesterUsername = workflowManager.getUserByProcessIdAndActivityDefId(procDefId, procId, participant.getValue());
                }

                resultList = new ArrayList<String>();

                Collection<User> users = directoryManager.getUserDepartmentUser(requesterUsername);
                for(User user : users){
                    if(user != null && user.getActive() == User.ACTIVE) {
                        resultList.add(user.getUsername());
                    }
                }

            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_DEPARTMENT)) {
                resultList = new ArrayList<String>();
                String departmentId = participant.getValue();
                Collection<User> users = directoryManager.getUserByDepartmentId(departmentId);
                for (User user : users){
                    if(user != null && user.getActive() == User.ACTIVE) {
                        resultList.add(user.getUsername());
                    }
                }
            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_HOD)) {
                resultList = new ArrayList<String>();
                String departmentId = participant.getValue();
                User user = directoryManager.getDepartmentHod(departmentId);
                if(user != null && user.getActive() == User.ACTIVE) {
                    resultList.add(user.getUsername());
                }

            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_GRADE)) {
                resultList = new ArrayList<String>();
                String[] temp = participant.getValue().split(ParticipantDirectoryDao.DELIMINATOR);
                String departmentId = temp[0];
                String gradeId = temp[1];

                Collection<User> users = directoryManager.getDepartmentUserByGradeId(departmentId, gradeId);
                for (User user : users){
                    if(user != null && user.getActive() == User.ACTIVE) {
                        resultList.add(user.getUsername());
                    }
                }

            } else if (participant.getType().contains(ParticipantDirectoryDao.TYPE_WORKFLOW_VARIABLE)) {
                resultList = new ArrayList<String>();
                String variableName = participant.getValue();

                //if is workflow variable
                Collection<WorkflowVariable> varList = workflowManager.getActivityVariableList(actId);
                for (WorkflowVariable va : varList) {
                    if (va.getName() != null && va.getName().equals(variableName)) {
                        //assignees = (va.getVal() != null) ? va.getVal().toString() : null;
                        String variableValue = (String) va.getVal();

                        if(participant.getType().contains(ParticipantDirectoryDao.TYPE_GROUP)) {
                            Collection<User> users = directoryManager.getUserByGroupId(variableValue);
                            for(User user : users){
                               if(user != null && user.getActive() == User.ACTIVE) {
                                   resultList.add(user.getUsername());
                               }
                            }
                        }else if(participant.getType().contains(ParticipantDirectoryDao.TYPE_USER)) {
                            User user = directoryManager.getUserByUsername(variableValue);
                            if(user != null && user.getActive() == User.ACTIVE) {
                                resultList.add(user.getUsername());
                            }
                        }else if(participant.getType().contains(ParticipantDirectoryDao.TYPE_DEPARTMENT_HOD)) {
                            resultList = new ArrayList<String>();
                            User user = directoryManager.getDepartmentHod(variableValue);
                            if(user != null && user.getActive() == User.ACTIVE) {
                                resultList.add(user.getUsername());
                            }
                        }else if(participant.getType().contains(ParticipantDirectoryDao.TYPE_DEPARTMENT)) {
                            Collection<User> users = directoryManager.getUserByDepartmentId(variableValue);
                            for (User user : users){
                                if(user != null && user.getActive() == User.ACTIVE) {
                                    resultList.add(user.getUsername());
                                }
                            }
                        }
                        break;
                    }
                }

            } else if (participant.getType().equals(ParticipantDirectoryDao.TYPE_PLUGIN)) {
                resultList = new ArrayList<String>();
                String properties = participant.getPluginProperties();

                try{
                    Map propertyMap = CsvUtil.getPluginPropertyMap(properties);
                    propertyMap.put("pluginManager", pluginManager);

                    ParticipantPlugin plugin = (ParticipantPlugin) pluginManager.getPlugin(participant.getValue());

                    WorkflowActivity activity = workflowManager.getActivityById(actId);
                    propertyMap.put("workflowActivity", activity);

                    Collection<String> pluginResult = plugin.getActivityAssignments(PluginUtil.getDefaultProperties(participant.getValue(), propertyMap));
                    if(pluginResult != null && pluginResult.size() > 0){
                        resultList.addAll(pluginResult);
                    }
                }catch(Exception ex){
                    AuditTrailManager auditTrailManager = (AuditTrailManager) appContext.getBean("auditTrailManager");
                    auditTrailManager.addAuditTrail(WorkflowUtil.class.getName(), "getAssignmentUsers", "Error executing plugin [pluginName=" + participant.getValue() + ", participantId=" + participantId + ", processId=" + procId + ", version=" + version + ", activityId=" + actId + "]");
                    LogUtil.error(WorkflowUtil.class.getName(), ex, "Error executing plugin [pluginName=" + participant.getValue() + ", participantId=" + participantId + ", processDefId=" + procDefId + ", version=" + version + ", activityId=" + actId + "]");
                }
            }
        } catch(Exception ex) {
            LogUtil.error(WorkflowUtil.class.getName(), ex, "");
        } finally {
            // remove duplicates
            if (resultList != null) {
                HashSet<String> resultSet = new HashSet<String>(resultList);
                resultList = new ArrayList<String>(resultSet);
            }
            return resultList;
        }
    }

     public static boolean containsHashVariable(String content) {
         boolean result = (content != null && content.indexOf("#") >= 0);
         return result;
     }

     public static String processVariable(String content, String formDataTable, WorkflowAssignment wfAssignment){
         return processVariable(content, formDataTable, wfAssignment, null, null);
     }

     public static String processVariable(String content, String formDataTable, WorkflowAssignment wfAssignment, String escapeFormat){
         return processVariable(content, formDataTable, wfAssignment, escapeFormat, null);
     }

     public static String processVariable(String content, String formDataTable, WorkflowAssignment wfAssignment, String escapeFormat, Map<String, String> replaceMap){

         // check for hash # to avoid unnecessary processing
         if (!containsHashVariable(content)) {
             return content;
         }

        Map<String, String> variableData = new HashMap();
        Map<String, String> formData = new HashMap<String, String>();
        String processId = "";

        if (wfAssignment != null) {
            processId = wfAssignment.getProcessId();
            WorkflowManager workflowManager = (WorkflowManager) appContext.getBean("workflowManager");
            WorkflowProcessLink wfProcessLink = workflowManager.getWorkflowProcessLink(processId);

            if(wfProcessLink != null){
                processId = wfProcessLink.getOriginProcessId();
            }

            //get worklow variable name-value pair, and put them in map
            List<WorkflowVariable> workflowVariableList = wfAssignment.getProcessVariableList();

            if(workflowVariableList == null){
                workflowVariableList = new ArrayList(workflowManager.getProcessVariableList(wfAssignment.getProcessId()));
            }
            
            if(workflowVariableList != null && workflowVariableList.size() > 0){
                for(WorkflowVariable var : workflowVariableList){
                    if (var.getVal() != null) {
                        variableData.put(var.getId(), var.getVal().toString());
                    }
                }
            }

            //get form dao
            if(formDataTable != null && formDataTable.length() != 0){
                FormManager formManager = (FormManager) appContext.getBean("formManager");
                Form form = formManager.loadDynamicFormByProcessId(formDataTable, processId);
                if(form != null){
                    formData = form.getCustomProperties();
                }
            }
        }

        //parse content
        if (content != null) {
            Pattern pattern = Pattern.compile("\\#([^#^\"])*\\#");
            Matcher matcher = pattern.matcher(content);
            List<String> varList = new ArrayList<String>();
            while (matcher.find()) {
                varList.add(matcher.group());
            }

            try{
                for(String var : varList){
                    String tempVar = var.replaceAll("#", "");

                    if(tempVar.startsWith(FORM_DATA)){
                        tempVar = tempVar.replace(FORM_DATA + ".", "");

                        if(tempVar.contains(".")){
                            String tempTableName = tempVar.split("\\.")[0];
                            tempVar = tempVar.split("\\.")[1];

                            if(tempTableName != null && tempTableName.length() != 0){
                                FormManager formManager = (FormManager) appContext.getBean("formManager");
                                Form form = formManager.loadDynamicFormByProcessId(tempTableName, processId);
                                if(form != null){
                                    formData = form.getCustomProperties();
                                }
                            }
                        }

                        if(!tempVar.startsWith("c_")){
                            tempVar = "c_" + tempVar;
                        }

                        String formDataVarValue = formData.get(tempVar);
                        if (formDataVarValue != null) {
                            content = content.replaceAll(var, StringUtil.escapeString(formDataVarValue, escapeFormat, replaceMap));
                        } else {
                            content = content.replaceAll(var, "");
                        }

                    }else if(tempVar.startsWith(WORKFLOW_ASSIGNMENT) && wfAssignment != null){
                        tempVar = tempVar.replace(WORKFLOW_ASSIGNMENT + ".", "");

                        //convert first character to upper case
                        char firstChar = tempVar.charAt(0);
                        firstChar = Character.toUpperCase(firstChar);
                        tempVar = firstChar + tempVar.substring(1, tempVar.length());

                        Method method = WorkflowAssignment.class.getDeclaredMethod("get" + tempVar, new Class[]{});
                        String returnResult = (String) method.invoke(wfAssignment, new Object[]{});
                        if(returnResult == null){
                            returnResult = "";
                        }

                        content = content.replaceAll(var, StringUtil.escapeString(returnResult, escapeFormat, replaceMap));

                    }else if(tempVar.startsWith(WORKFLOW_VARIABLE) && wfAssignment != null){
                        tempVar = tempVar.replace(WORKFLOW_VARIABLE + ".", "");
                        String varVal = variableData.get(tempVar);
                        if(varVal != null){
                            content = content.replaceAll(var, StringUtil.escapeString(varVal, escapeFormat, replaceMap));
                        }

                    }else if(tempVar.startsWith(DATE)){
                        tempVar = tempVar.replace(DATE + ".", "");

                        try{
                            Calendar cal = Calendar.getInstance();

                            int field = -1;
                            if(tempVar.contains("YEAR")){
                                field = Calendar.YEAR;
                                tempVar = tempVar.replace("YEAR", "");
                            } else if(tempVar.contains("MONTH")){
                                field = Calendar.MONTH;
                                tempVar = tempVar.replace("MONTH", "");
                            } else if(tempVar.contains("DAY")){
                                field = Calendar.DATE;
                                tempVar = tempVar.replace("DAY", "");
                            }

                            if(field != -1){
                                String amount = tempVar.substring(0, tempVar.indexOf("."));
                                tempVar = tempVar.replace(amount + ".", "");

                                amount = amount.replace("+", "");

                                cal.add(field, Integer.parseInt(amount));
                            }

                            var = var.replace("+", "\\+");

                            content = content.replaceAll(var, StringUtil.escapeString(new SimpleDateFormat(tempVar).format(cal.getTime()), escapeFormat, replaceMap));
                        }catch(IllegalArgumentException iae){
                            content = content.replaceAll(var, StringUtil.escapeString(new Date().toString(), escapeFormat, replaceMap));
                        }catch(Exception ex){
                            LogUtil.error(WorkflowUtil.class.getName(), ex, "");
                            content = content.replaceAll(var, "");
                        }

                    }else if(tempVar.startsWith(CURRENT_USERNAME)){
                        WorkflowUserManager workflowUserManager = (WorkflowUserManager) appContext.getBean("workflowUserManager");

                        try{
                            content = content.replaceAll(var, StringUtil.escapeString(workflowUserManager.getCurrentUsername(), escapeFormat, replaceMap));
                        }catch(Exception ex){
                            LogUtil.error(WorkflowUtil.class.getName(), ex, "");
                        }

                    } else if (tempVar.startsWith(PERFORMER) && wfAssignment != null) {
                        tempVar = tempVar.replace(PERFORMER + ".", "");

                        try {
                            WorkflowManager workflowManager = (WorkflowManager) appContext.getBean("workflowManager");

                            String username = workflowManager.getUserByProcessIdAndActivityDefId(wfAssignment.getProcessDefId(), wfAssignment.getProcessId(), tempVar.substring(0, tempVar.indexOf(".")));

                            if (username != null && username.trim().length() > 0) {

                                String attribute = tempVar.substring(tempVar.indexOf(".")+1);
                                String returnResult = getUserAttribute(username, attribute);
                                if (returnResult != null) {
                                    content = content.replaceAll(var, StringUtil.escapeString(returnResult, escapeFormat, replaceMap));
                                }

                            } else {
                                content = content.replaceAll(var, "");
                            }
                        } catch (Exception ex) {
                            LogUtil.error(WorkflowUtil.class.getName(), ex, "");
                        }
                    } else if(tempVar.startsWith(WORKFLOW_USER_VARIABLE)){
                        tempVar = tempVar.replace(WORKFLOW_USER_VARIABLE + ".", "");
                        String variable = tempVar.substring(0, tempVar.indexOf("."));
                        String varVal = variableData.get(variable);
                        if(varVal != null) {
                            String attribute = tempVar.substring(tempVar.indexOf(".")+1);
                            String returnResult = getUserAttribute(varVal, attribute);
                            if(returnResult != null){
                                content = content.replaceAll(var, StringUtil.escapeString(returnResult, escapeFormat, replaceMap));
                            }
                        }
                    } else if(tempVar.startsWith(WORKFLOW_USER)){
                        tempVar = tempVar.replace(WORKFLOW_USER + ".", "");
                        String username = tempVar.substring(0, tempVar.indexOf("."));
                        String attribute = tempVar.substring(tempVar.indexOf(".")+1);
                        String returnResult = getUserAttribute(username, attribute);
                        if(returnResult != null) {
                            content = content.replaceAll(var, StringUtil.escapeString(returnResult, escapeFormat, replaceMap));
                        }
                    }

                }
            }catch(Exception ex){
                LogUtil.error(WorkflowUtil.class.getName(), ex, "");
            }
        }
        return content;
    }

    public static String getUserAttribute(String username, String attribute) {
        String attributeValue = null;

        try {
            DirectoryManager directoryManager = (DirectoryManager) appContext.getBean("directoryManager");
            User user = directoryManager.getUserByUsername(username);

            if(user != null){
                //convert first character to upper case
                char firstChar = attribute.charAt(0);
                firstChar = Character.toUpperCase(firstChar);
                attribute = firstChar + attribute.substring(1, attribute.length());

                Method method = User.class.getDeclaredMethod("get" + attribute, new Class[]{});
                String returnResult = (String) method.invoke(user, new Object[]{});
                if(returnResult == null || attribute.equals("Password")){
                    returnResult = "";
                }

                attributeValue = returnResult;
            }
        }
        catch(Exception e) {
            LogUtil.error(WorkflowUtil.class.getName(), e, "Error retrieving user attribute " + attribute);
        }
        return attributeValue;
    }

    public static String getActivityFormTableName(String processDefId, Integer version, String activityDefId) {
        ActivityFormDao activityFormDao = (ActivityFormDao) appContext.getBean("activityFormDao");
        WorkflowManager workflowManager = (WorkflowManager) appContext.getBean("workflowManager");
        FormManager formManager = (FormManager) appContext.getBean("formManager");

        String tableName = null;

        WorkflowActivity activity = null;
        Collection<WorkflowActivity> activityList = workflowManager.getProcessActivityDefinitionList(processDefId);

        for (WorkflowActivity act : activityList) {
            if (activityDefId.equals(act.getId())) {
                activity = act;
            }
        }

        if(activity != null){
            Collection<ActivityForm> activityFormList = activityFormDao.getFormByActivity(processDefId, version, activityDefId);
            if(!activityFormList.isEmpty()){
                String formId = "";

                for(ActivityForm form : activityFormList){
                    if(form.getFormId() != null && form.getFormId().trim().length() > 0){
                        formId = form.getFormId();
                        break;
                    }
                }

                if(formId.trim().length() > 0){
                    tableName = formManager.getFormById(formId).getTableName();
                }
            }
        }

        return tableName;
    }

    public static String getSystemSetupValue(String propertyName){
        SetupManager setupManager = (SetupManager) appContext.getBean("setupManager");
        return setupManager.getSettingValue(propertyName);
    }

    public static String getCurrentUsername() {
        WorkflowUserManager workflowUserManager = (WorkflowUserManager) appContext.getBean("workflowUserManager");
        String username = workflowUserManager.getCurrentUsername();
        return username;
    }

    public static String getCurrentUserFullName() {
       DirectoryManager directoryManager = (DirectoryManager) appContext.getBean("directoryManager");
       String username = getCurrentUsername();
       User user = directoryManager.getUserByUsername(username);
       if (user != null && user.getFirstName() != null && user.getFirstName().trim().length() > 0 ){
           return user.getFirstName() + " " + user.getLastName();
       }else{
           return username;
       }
    }

    public static boolean isCurrentUserInRole(String role) {
        WorkflowUserManager workflowUserManager = (WorkflowUserManager) appContext.getBean("workflowUserManager");
        boolean result = workflowUserManager.isCurrentUserInRole(role);
        return result;
    }

    public static boolean isCurrentUserAnonymous() {
        WorkflowUserManager workflowUserManager = (WorkflowUserManager) appContext.getBean("workflowUserManager");
        boolean result = workflowUserManager.isCurrentUserAnonymous();
        return result;
    }

    public void setApplicationContext(ApplicationContext context) throws BeansException {
        appContext =  context;
    }

    public static Map<String, String> getWorkflowVariableValueFromFormData(String processDefId, String processInstanceId, String activityDefId){
        ActivityFormDao activityFormDao = (ActivityFormDao) appContext.getBean("activityFormDao");
        FormManager formManager = (FormManager) appContext.getBean("formManager");

        Map<String, String> variables = new HashMap();

        Collection<ActivityForm> activityFormList = activityFormDao.getFormByActivity(processDefId, activityDefId);
        if (activityFormList != null && activityFormList.size() > 0) {
            ActivityForm activityForm = activityFormList.iterator().next();

            if (!activityForm.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_EXTERNAL)) {
                Form form = formManager.getFormById(activityForm.getFormId());
                Form formData = null;

                if (form != null) {
                    formData = formManager.loadDynamicFormByProcessId(form.getTableName(), processInstanceId);
                }

                if (formData != null) {
                    Map<String, String> formDataElement = formData.getCustomProperties();

                    Iterator it = formDataElement.entrySet().iterator();

                    while (it.hasNext()) {
                        Map.Entry<String, String> pairs = (Map.Entry<String, String>) it.next();
                        String variableName = FormUtil.getWorkflowVariableName(form.getData(), pairs.getKey());

                        if (variableName != null && variableName.trim().length() != 0) {
                            variables.put(variableName, pairs.getValue());
                        }
                    }
                }
            }
        }
        
        return variables;
    }
}
