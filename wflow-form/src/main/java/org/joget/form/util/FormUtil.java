package org.joget.form.util;

import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import org.joget.form.model.Form;
import org.joget.form.model.dao.FormDao;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class FormUtil implements ApplicationContextAware {
    public static final String FIELD_PREFIX = "c_";

    static ApplicationContext appContext;

    public static ApplicationContext getApplicationContext() {
        return appContext;
    }

    public static List<String> getFormFields(String data) {
        List<String> formFields = new ArrayList();

        try{
            //search for "name":"anything_except_double_quote"
            Pattern pattern = Pattern.compile("\"name\":\"([^\"]*)\"");
            Matcher matcher = pattern.matcher(data);

            boolean found = false;
            List<String> names = new ArrayList<String>();
            while (matcher.find()) {
                names.add(matcher.group(1));
                found = true;
            }

            if (!found) {
                return formFields;
            }

            //search for name=\"anything_except_double_quote"\
            //for custom html form field
            pattern = Pattern.compile("name=\\\\\"([^\"]*)\\\\\"");
            matcher = pattern.matcher(data);

            while (matcher.find()) {
                names.add(matcher.group(1));
            }

            //get unique names
            Set set = new HashSet(names);
            String[] unique = (String[]) (set.toArray(new String[set.size()]));
            for (String name : unique) {
                formFields.add(FIELD_PREFIX + name);
            }
            return formFields;
        }catch(Exception ex){
            return formFields;
        }
    }
    
    public static String getWorkflowVariableName(String data, String fieldName){
        //search for "name":"anything_except_double_quote".....anything_except_curly_bracket....."variableName":"anything_except_double_quote"
        Pattern pattern = Pattern.compile("\"name\":\"([^\"]*)\"([^{]*)\"variableName\":\"([^\"]*)\"");
        Matcher matcher = pattern.matcher(data);

        while (matcher.find()) {
            //append column prefix "c_"
            if(fieldName.equals(FIELD_PREFIX + matcher.group(1))){
                return matcher.group(3);
            }
        }
        
        return null;
    }

    public static boolean isIgnoreVariableIfEmpty(String data, String fieldName){
        //search for "name":"anything_except_double_quote".....anything_except_curly_bracket....."ignoreVariableIfEmpty":"true"
        Pattern pattern = Pattern.compile("\"name\":\"([^\"]*)\"([^{]*)\"ignoreVariableIfEmpty\":\"true\"");
        Matcher matcher = pattern.matcher(data);

        while (matcher.find()) {
            //append column prefix "c_"
            if(fieldName.equals(FIELD_PREFIX + matcher.group(1))){
                return true;
            }
        }

        return false;
    }


    public static boolean isRequiredField(String data, String fieldName){
        //search for "required":true".....anything_except_curly_bracket.....name":"fieldName"
        Pattern pattern = Pattern.compile("\"required\":true([^{]*)\"name\":\"" + fieldName + "\"");
        Matcher matcher = pattern.matcher(data);

        while (matcher.find()) {
            return true;
        }

        return false;
    }

    public static String getFieldLabel(String data, String fieldName){
        //search for "required":true".....anything_except_curly_bracket.....name":"fieldName"
        Pattern pattern = Pattern.compile("\"label\":\"([^\"]*)\"[^{]*\"name\":\"" + fieldName + "\"");
        Matcher matcher = pattern.matcher(data);

        while (matcher.find()) {
            String label = matcher.group(1);

            if(label != null && label.trim().length() > 0){
                return label;
            }
        }

        return fieldName;
    }

    public static String getCheckboxDeliminator(String data, String checkboxName){
        //search for "name":"checkboxName".....anything_except_curly_bracket....."deliminator":"anything_except_double_quote"
        Pattern pattern = Pattern.compile("\"name\":\"" + checkboxName + "\"([^{]*)\"deliminator\":\"([^\"]*)\"");
        Matcher matcher = pattern.matcher(data);

        while (matcher.find()) {
            return matcher.group(2);
        }

        return "|";
    }

    public static List<String> getSubForms(String data){
        List<String> subformList = new ArrayList<String>();
        try{
            //search for "formId":"anything_except_double_quote"
            Pattern pattern = Pattern.compile("\"formId\":\"([^\"]*)\"");
            Matcher matcher = pattern.matcher(data);

            while (matcher.find()) {
                subformList.add(matcher.group(1));
            }

        }catch (Exception ex){
            return subformList;
        }

        return subformList;
    }

    public static List<String> getFormVariables(String data){
        List<String> formVariableList = new ArrayList<String>();
        try{
            //search for "formVariableId":"anything_except_double_quote"
            Pattern pattern = Pattern.compile("\"formVariableId\":\"([^\"]*)\"");
            Matcher matcher = pattern.matcher(data);

            while (matcher.find()) {
                String id = matcher.group(1);
                if(id.length() > 0){
                    formVariableList.add(id);
                }
            }

        }catch (Exception ex){
            return formVariableList;
        }

        return formVariableList;
    }

    public static int getNumberOfSubForm(String data){
        int counter = 0;
        try{
            //search for "type":"subform"
            Pattern pattern = Pattern.compile("\"type\":\"subform\"");
            Matcher matcher = pattern.matcher(data);

            while (matcher.find()) {
                counter++;
            }

//          Subform mode link not deduck from the counter to check form exist or not
//            //search for subform mode:link and deduct from the counter
//            //because subform with mode:link load immediately without delay
//            pattern = Pattern.compile("\"mode\":\"link\"");
//            matcher = pattern.matcher(data);
//
//            while (matcher.find()) {
//                counter--;
//            }

            return counter;
        }catch (Exception ex){
            return 0;
        }
    }

    /*
    public static void updateSubformReferenceId(String formId, String newFormId){
        if(formId != null && formId.length() > 0 && newFormId != null && newFormId.length() > 0){
            FormDao formDao = (FormDao) appContext.getBean("formDao");
            List<Form> formList = formDao.findAll();

            for(Form form : formList){
                String data = form.getData();
                if(data != null && data.length() > 0){
                    try{
                        Pattern pattern = Pattern.compile("\"formId\":\"" + formId + "\"");
                        Matcher matcher = pattern.matcher(data);

                        boolean found = false;
                        while (matcher.find()) {
                            data = matcher.replaceFirst("\"formId\":\"" + newFormId + "\"");
                            found = true;
                        }

                        if(found){
                            form.setData(data);
                            formDao.saveOrUpdate(form);
                        }
                    }catch (Exception ex){
                        LogUtil.error(FormUtil.class.getName(), ex, "");
                    }
                }
            }
        }
    }
    */

    public static String updateSingleSubformReferenceId(String formData, String oldSubformId, String newSubformId){
        if(formData != null && formData.length() > 0){
            try{
                Pattern pattern = Pattern.compile("\"formId\":\"" + oldSubformId + "\"");
                Matcher matcher = pattern.matcher(formData);

                while (matcher.find()){
                    formData = matcher.replaceFirst("\"formId\":\"" + newSubformId + "\"");
                }

            }catch (Exception ex){
                LogUtil.error(FormUtil.class.getName(), ex, "");
            }
        }
        return formData;
    }

    public static void updateBatchSubformReferenceId(HashMap<String, String> updatedFormMap){
        FormDao formDao = (FormDao) appContext.getBean("formDao");

        Set<String> keySet = updatedFormMap.keySet();
        for(String oldFormId : keySet){
            String newFormId = updatedFormMap.get(oldFormId);

            Set<String> keySet2 = updatedFormMap.keySet();
            for(String oldFormId2 : keySet2){
                String newFormId2 = updatedFormMap.get(oldFormId2);
                Form form = formDao.find(newFormId2);
                String formData = updateSingleSubformReferenceId(form.getData(), oldFormId, newFormId);
                if(formData != null && formData.length() > 0){
                    form.setData(formData);
                    formDao.saveOrUpdate(form);
                }
            }
        }
    }

    public static Collection<Form> getParents(String formId){
        Collection<Form> parentFormList = new ArrayList<Form>();

        FormDao formDao = (FormDao) appContext.getBean("formDao");
        List<Form> formList = formDao.findAll();

        Pattern pattern = Pattern.compile("\"formId\":\"" + formId + "\"");
        for(Form form : formList){
            String formData = form.getData();
            if(formData != null && formData.length() > 0){
                try{
                    Matcher matcher = pattern.matcher(formData);
                    while (matcher.find()){
                        parentFormList.add(form);
                        break;
                    }

                }catch (Exception ex){
                    LogUtil.error(FormUtil.class.getName(), ex, "");
                }
            }
        }

        return parentFormList;
    }

    public static String getSystemSetupValue(String propertyName){
        SetupManager setupManager = (SetupManager) appContext.getBean("setupManager");
        return setupManager.getSettingValue(propertyName);
    }

    public static Form updateFormVariable(Form form, Map changedList){
        if(form != null && form.getData() != null){
            List<String> formVariableList = getFormVariables(form.getData());

            if(formVariableList != null){
                String data = form.getData();
                for(String oldId: formVariableList){
                    if(changedList.containsKey(oldId)){
                        data.replaceAll(oldId, (String)changedList.get(oldId));
                    }
                }
                form.setData(data);
            }
        }

        return form;
    }

    public void setApplicationContext(ApplicationContext context) throws BeansException {
        appContext =  context;
    }
}
