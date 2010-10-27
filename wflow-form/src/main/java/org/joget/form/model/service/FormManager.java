package org.joget.form.model.service;

import org.joget.form.model.Category;
import org.joget.form.model.Form;
import org.joget.form.model.dao.CategoryDao;
import org.joget.form.model.dao.DynamicFormDao;
import org.joget.form.model.dao.FormDao;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.joget.form.model.FormMetaData;

public class FormManager {

    private FormDao formDao;
    private CategoryDao categoryDao;
    private DynamicFormDao dynamicFormDao;

    public CategoryDao getCategoryDao() {
        return categoryDao;
    }

    public void setCategoryDao(CategoryDao categoryDao) {
        this.categoryDao = categoryDao;
    }

    public FormDao getFormDao() {
        return formDao;
    }

    public void setFormDao(FormDao formDao) {
        this.formDao = formDao;
    }

    public DynamicFormDao getDynamicFormDao() {
        return dynamicFormDao;
    }

    public void setDynamicFormDao(DynamicFormDao dynamicFormDao) {
        this.dynamicFormDao = dynamicFormDao;
    }

    public Form getFormById(String formId) {
        return getFormDao().find(formId);
    }

    public Collection<Form> getFormByTableName(String tableName) {
        return getFormDao().getFormByTableName(tableName);
    }

    public Collection<Form> getAllFormVersion(String formId, String sort, Boolean desc) {
        return getFormDao().getAllFormVersion(formId, sort, desc);
    }

    public List<Form> getForms(String categoryId, String sort, Boolean desc, Integer start, Integer rows) {
        return getFormDao().findAll(categoryId, sort, desc, start, rows);
    }

    public Long getTotalForms(String categoryId) {
        if (categoryId != null && categoryId.trim().length() != 0) {
            return getFormDao().count("WHERE categoryId = ?", new String[]{categoryId});
        } else {
            return getFormDao().count("", null);
        }
    }

    public void saveForm(Form form) {
        getFormDao().saveOrUpdate(form);
    }

    public void deleteForm(String formId) {
        getFormDao().delete(formId);
    }

    public Category getCategoryById(String id) {
        return getCategoryDao().find(id);
    }

    public List<Category> getCategories(String sort, Boolean desc, Integer start, Integer rows) {
        return getCategoryDao().findAll(sort, desc, start, rows);
    }

    public Long getTotalCategories() {
        return getCategoryDao().count("", null);
    }

    public void saveCategory(Category category) {
        getCategoryDao().saveOrUpdate(category);
    }

    public void deleteCategory(String categoryId) {
        getCategoryDao().delete(categoryId);
    }

    public void saveOrUpdateDynamicForm(Form form) {
        dynamicFormDao.saveOrUpdate(form);
    }

    public void createDynamicFormMetaData(String tableName, String processId, String activityId, String activityDefId, String participantId, List<String> pendingUserList) {
        FormMetaData formMetaData = new FormMetaData();

        if("runProcess".equals(activityId)){
            activityId += "_" + processId;
        }
        
        formMetaData.setActivityId(activityId);
        formMetaData.setActivityDefId(activityDefId);
        formMetaData.setParticipantId(participantId);
        formMetaData.setCreated(new Date());
        formMetaData.setLatest(1);

        Form form = loadDynamicFormByProcessId(tableName, processId);

        if (form != null) {
            formMetaData.setDynamicFormId(form.getId());
        }

        String pendingUsers = "";
        if (pendingUserList != null && pendingUserList.size() > 0) {
            pendingUsers = ",";

            for(String username : pendingUserList){
                pendingUsers += username + ",";
            }
        }

        formMetaData.setPendingUsers(pendingUsers);

        saveOrUpdateDynamicFormMetaData(formMetaData, tableName);
    }

    public void updateDynamicFormMetaData(String tableName, String processId, String activityId, String username) {

        if("runProcess".equals(activityId)){
            activityId += "_" + processId;
        }

        FormMetaData formMetaData = loadDynamicFormMetaDataByActivityId(tableName, activityId);

        if (formMetaData != null) {

            if(username != null && username.trim().length() > 0){
                formMetaData.setUsername(username);
                formMetaData.setLatest(0);
            }else{
                formMetaData.setLatest(1);
            }
            
            if(formMetaData.getDynamicFormId() == null){
                Form form = loadDynamicFormByProcessId(tableName, processId);
                if (form != null) {
                    formMetaData.setDynamicFormId(form.getId());
                }
            }

            saveOrUpdateDynamicFormMetaData(formMetaData, tableName);
        }

    }

    public void updateDynamicFormMetaData(String tableName, FormMetaData formMetaData) {
        saveOrUpdateDynamicFormMetaData(formMetaData, tableName);
    }

    public long countActivityFromMetaData(String tableName, String activityDefId, int status, int permType, String currentUsername) {
        return dynamicFormDao.loadDynamicFormDataByActivityDefIdSize(tableName, activityDefId, null, null, status, permType, currentUsername);
    }

    public void saveOrUpdateDynamicFormMetaData(FormMetaData formMetaData, String tableName) {
        dynamicFormDao.saveOrUpdateMetaData(formMetaData, tableName);
    }

    public FormMetaData loadDynamicFormMetaDataByActivityId(String tableName, String activityId) {
        return dynamicFormDao.loadDynamicFormMetaDataByActivityId(tableName, activityId);
    }

    public FormMetaData loadDynamicFormMetaData(String tableName, String id) {
        return dynamicFormDao.loadDynamicFormMetaData(tableName, id);
    }
    
    public List<Form> loadAllDynamicForm(String tableName) {
        return dynamicFormDao.loadAllDynamicForm(tableName);
    }

    public Form loadDynamicForm(String tableName, String dynamicFormId) {
        return dynamicFormDao.load(tableName, dynamicFormId);
    }

    public Form loadDynamicFormByProcessId(final String tableName, final String processId) {
        return dynamicFormDao.loadDynamicFormByProcessId(tableName, processId);
    }

    public Form loadDraftDynamicForm(final String tableName, final String processId, final String activityId) {
        return dynamicFormDao.loadDraft(tableName, processId, activityId);
    }

    public void deleteDraftDynamicForm(String tableName, Form draftDynamicForm) {
        dynamicFormDao.delete(tableName, draftDynamicForm);
    }

    public void mergeDraftToLive(String tableName, String processId, String activityId) {
        Form liveForm = loadDynamicFormByProcessId(tableName, processId);
        Form draftForm = loadDraftDynamicForm(tableName, processId, activityId);

        if(draftForm == null){
            return;
        }

        draftForm.setValueOfCustomField("modified", new Date());
        if (liveForm != null) {
            liveForm.setTableName(tableName);
            Date created = (Date) liveForm.getValueOfCustomField("created");

            //merge
            Map<String, String> draftData = draftForm.getCustomProperties();
            Iterator draftIte = draftData.entrySet().iterator();
            while (draftIte.hasNext()) {
                Map.Entry<String, String> pairs = (Map.Entry<String, String>) draftIte.next();
                if (pairs.getValue() != null) {
                    liveForm.setValueOfCustomField(pairs.getKey(), pairs.getValue());
                }
            }
            liveForm.setValueOfCustomField("draft", "0");
            liveForm.setValueOfCustomField("created", created);
            saveOrUpdateDynamicForm(liveForm);
            deleteDraftDynamicForm(tableName, draftForm);
        } else {
            //convert
            draftForm.setValueOfCustomField("draft", "0");
            draftForm.setTableName(tableName);
            saveOrUpdateDynamicForm(draftForm);
        }

        String username = (String) draftForm.getValueOfCustomField("username");
        if (username != null && username.trim().length() > 0) {
            updateDynamicFormMetaData(tableName, processId, activityId, username);
        }
    }

    public int getMaxValue(String columnName, String tableName) {
        return dynamicFormDao.getMaxValue(columnName, tableName);
    }

    public String getActivityIdByDefId(String tableName, String dynamicFormId, String activityDefId){
        return dynamicFormDao.getActivityIdByDefId(tableName, dynamicFormId, activityDefId);
    }

    public List<FormMetaData> loadDynamicFormDataByActivityDefId(String tableName, String activityDefId, String filter, Collection<String> filterTypes, int status, int permType, String currentUsername, String sort, Boolean desc, Integer start, Integer rows){
        return dynamicFormDao.loadDynamicFormDataByActivityDefId(tableName, activityDefId, filter, filterTypes, status, permType, currentUsername, sort, desc, start, rows);
    }

    public Long loadDynamicFormDataByActivityDefIdSize(String tableName, String activityDefId, String filter, Collection<String> filterTypes, int status, int permType, String currentUsername){
        return dynamicFormDao.loadDynamicFormDataByActivityDefIdSize(tableName, activityDefId, filter, filterTypes, status, permType, currentUsername);
    }

     public List<String> getAllTableName(){
         return formDao.getAllTableName();
     }
}
