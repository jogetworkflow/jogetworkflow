package org.joget.workflow.model.dao;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.ActivityForm;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public class ActivityFormDao extends AbstractSpringDao {

    public static final String ACTIVITY_FORM_TYPE_SINGLE   = "SINGLE";
    public static final String ACTIVITY_FORM_TYPE_MULTI    = "MULTI_";
    public static final String ACTIVITY_FORM_TYPE_EXTERNAL = "EXTERNAL";
    public static final String ENTITY_NAME = "ActivityForm";
    
    public Collection<ActivityForm> getFormByActivity(String processId, Integer version, String activityId) {
        String condition = "WHERE processId LIKE ? AND activityId = ? AND version = ?";
        Object[] params = {processId, activityId, version};
        return find(condition, params, null, null, null, null);
    }

    public Collection<ActivityForm> getFormByActivity(String processId, String activityId) {
        String condition = "WHERE processId = ? AND activityId = ?";
        Object[] params = {processId, activityId};
        return find(condition, params, null, null, null, null);
    }

    public Collection<ActivityForm> getActivityFormByPackageId(String packageId){
        String condition = "WHERE processId LIKE ?";
        String[] params = {packageId+"%"};
        return find(condition, params, null, null, 0, 1000);
    }

    public Collection<ActivityForm> getActivityFormByPackageId(String packageId, Integer version){
        String condition = "WHERE processId LIKE ? AND version=?";
        Object[] params = {packageId+"%", version};
        return find(condition, params, null, null, 0, 1000);
    }

    public List<ActivityForm> findByExample(ActivityForm obj) {
        return (List<ActivityForm>) super.findByExample(ENTITY_NAME, obj);
    }

    public Long count(String condition, Object[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public void delete(ActivityForm obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public ActivityForm find(String id) {
        return (ActivityForm) super.find(ENTITY_NAME, id);
    }

    public Collection<ActivityForm> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public List<ActivityForm> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public Serializable save(ActivityForm obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(ActivityForm obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }
    
    public Collection<ActivityForm> getFormByFormId(String formId, String processId, Integer version, String activityId) {
        ActivityForm example = new ActivityForm();
        example.setFormId(formId);
        example.setProcessId(processId);
        example.setVersion(version);
        example.setActivityId(activityId);
        
        return findByExample(example);
    }
    
    public void unassignFormFromActivity(String formId, String processId, Integer version, String activityId) {
        Collection<ActivityForm> forms = getFormByActivity(processId, version, activityId);

        for (ActivityForm temp : forms) {
            if (temp.getFormId().equals(formId)) {
                delete(temp);
                break;
            }
        }
    }

    public void unassignAllFormFromActivity(String processId, Integer version, String activityId) {
        Collection<ActivityForm> forms = getFormByActivity(processId, version, activityId);

        for (ActivityForm temp : forms) {
            delete(temp);
        }
    }

    public void unassignFormFromAllActivity(String formId) {
        Collection<ActivityForm> forms = find("WHERE formId = ?", new Object[]{formId}, null, false, 0, -1);

        for (ActivityForm temp : forms) {
            delete(temp);
        }
    }

    public void assignExternalFormToActivity(String externalFormUrl, String externalFormIFrameStyle, String processId, Integer version, String activityId) {
        ActivityForm activityForm = new ActivityForm();
        activityForm.setProcessId(processId);
        activityForm.setVersion(version);
        activityForm.setActivityId(activityId);
        activityForm.setFormUrl(externalFormUrl);
        activityForm.setFormIFrameStyle(externalFormIFrameStyle);
        activityForm.setType(ACTIVITY_FORM_TYPE_EXTERNAL);
        save(activityForm);
    }

    public void assignSingleFormToActivity(String formId, String processId, Integer version, String activityId) {
        ActivityForm activityForm = new ActivityForm();
        activityForm.setProcessId(processId);
        activityForm.setVersion(version);
        activityForm.setActivityId(activityId);
        activityForm.setFormId(formId);
        activityForm.setType(ACTIVITY_FORM_TYPE_SINGLE);
        save(activityForm);
    }

    public void assignMultiFormToActivity(String formId, String processId, Integer version, String activityId, Integer sequence) {
        ActivityForm activityForm = new ActivityForm();
        activityForm.setProcessId(processId);
        activityForm.setVersion(version);
        activityForm.setActivityId(activityId);
        activityForm.setFormId(formId);
        activityForm.setType(ACTIVITY_FORM_TYPE_MULTI + sequence);
        save(activityForm);
    }

    public ActivityForm getMultiFormBySequence(String processId, Integer version, String activityId, Integer sequence) {
        ActivityForm activityForm = new ActivityForm();
        activityForm.setProcessId(processId);
        activityForm.setVersion(version);
        activityForm.setActivityId(activityId);
        activityForm.setType(ACTIVITY_FORM_TYPE_MULTI + sequence);
        
        Collection<ActivityForm> result = findByExample(activityForm);
        if(result.size() == 1){
            return result.iterator().next();
        }
        return null;
    }

    public boolean isLastMultiForm(String activityFormId) {
        ActivityForm activityForm = find(activityFormId);

        if (isMultiForm(activityForm)) {
            int sequence = getFormSequence(activityForm);
            Collection<ActivityForm> allForms = getFormByActivity(activityForm.getProcessId(), activityForm.getVersion(), activityForm.getActivityId());

            for (ActivityForm temp : allForms) {
                int tempSequence = Integer.parseInt(temp.getType().replace(ACTIVITY_FORM_TYPE_MULTI, ""));
                if (tempSequence > sequence) {
                    return false;
                }
            }

            return true;
        } else {
            return false;
        }
    }
    
    public int getFormSequence(ActivityForm activityForm){
        int sequence = Integer.parseInt(activityForm.getType().replace(ACTIVITY_FORM_TYPE_MULTI, ""));
        return sequence;
    }
    
    public boolean isMultiForm(ActivityForm activityForm){
        return activityForm.getType().contains(ACTIVITY_FORM_TYPE_MULTI);
    }
}
