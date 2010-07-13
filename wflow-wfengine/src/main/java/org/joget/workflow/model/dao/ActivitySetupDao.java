package org.joget.workflow.model.dao;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.ActivitySetup;

public class ActivitySetupDao extends AbstractSpringDao {
    public static final String ENTITY_NAME = "ActivitySetup";

    public ActivitySetup getActivitySetup(String processId, String activityId){
        String condition = "WHERE processId = ? AND activityId = ?";
        Object[] params = {processId, activityId};

        Collection<ActivitySetup> result = find(condition, params, null, null, 0, 1);
        if(result.size() == 1){
            return result.iterator().next();
        }
        return null;
    }

    public ActivitySetup getActivitySetup(String id){
        return find(id);
    }

    public Collection<ActivitySetup> getActivitySetupByProcessId(String processId) {
        String condition = "WHERE processId = ?";
        Object[] params = {processId};
        return find(ENTITY_NAME, condition, params, null, null, null, null);
    }

    public Serializable save(ActivitySetup obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(ActivitySetup obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public void delete(ActivitySetup obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public List<ActivitySetup> findByExample(ActivitySetup obj) {
        return (List<ActivitySetup>) super.findByExample(ENTITY_NAME, obj);
    }

    public Long count(String condition, Object[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public ActivitySetup find(String id) {
        return (ActivitySetup) super.find(ENTITY_NAME, id);
    }

    public Collection<ActivitySetup> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public List<ActivitySetup> findAll() {
        return super.findAll(ENTITY_NAME);
    }
}
