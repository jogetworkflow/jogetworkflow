package org.joget.workflow.model.dao;

import org.joget.workflow.model.*;
import org.joget.commons.spring.model.AbstractSpringDao;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public class ActivityApplicationDao extends AbstractSpringDao {

    public static final String ENTITY_NAME = "ActivityApplication";

    public Long count(String condition, ActivityApplication[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public void delete(ActivityApplication obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public ActivityApplication find(String id) {
        return (ActivityApplication) super.find(ENTITY_NAME, id);
    }

    public Collection<ActivityApplication> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public List<ActivityApplication> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public Serializable save(ActivityApplication obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(ActivityApplication obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public Collection<ActivityApplication> getApplication(String processId, Integer version, String activityId) {
        String condition = "WHERE processId = ? AND activityId = ?";
        Object[] params = {processId, activityId};

        if (version != null && version != 0) {
            condition += " AND version = ?";
            params = new Object[]{processId, activityId, version};
        }

        return find(condition, params, null, null, null, null);
    }

    public void removeApplicationFromActivity(String customClass, String processId, Integer version, String activityId) {
        Collection<ActivityApplication> applications = getApplication(processId, version, activityId);

        for (ActivityApplication temp : applications) {
            if (temp.getCustomClass().equals(customClass)) {
                delete(temp);
                break;
            }
        }
    }

    public void removeAllApplicationFromActivity(String processId, Integer version, String activityId) {
        Collection<ActivityApplication> applications = getApplication(processId, version, activityId);

        for (ActivityApplication temp : applications) {
            delete(temp);
        }
    }

    public void setApplicationToActivity(String customClass, String processId, Integer version, String activityId) {
        ActivityApplication activityApplication = new ActivityApplication();
        activityApplication.setProcessId(processId);
        activityApplication.setVersion(version);
        activityApplication.setActivityId(activityId);
        activityApplication.setCustomClass(customClass);

        save(activityApplication);
    }
}
