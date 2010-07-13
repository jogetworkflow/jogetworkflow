package org.joget.workflow.model.dao;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.ActivityPlugin;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public class ActivityPluginDao extends AbstractSpringDao {

    public static final String ENTITY_NAME = "ActivityPlugin";

    public Long count(String condition, Object[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public Collection<ActivityPlugin> getActivityPluginByPackageId(String packageId){
        String condition = "WHERE processId LIKE ?";
        String[] params = {packageId+"%"};
        return find(condition, params, null, null, 0, 1000);
    }

    public Collection<ActivityPlugin> getActivityPluginByPackageId(String packageId, Integer version){
        String condition = "WHERE processId LIKE ? AND version=?";
        Object[] params = {packageId+"%", version};
        return find(condition, params, null, null, 0, 1000);
    }

    public Collection<ActivityPlugin> getActivityPluginByProcessDefIdAndPluginName(String processDefId, String pluginName){
        String condition = "WHERE processId = ? AND pluginName=?";
        Object[] params = {processDefId, pluginName};
        return find(condition, params, null, null, 0, 1000);
    }

    public void delete(ActivityPlugin obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public ActivityPlugin find(String id) {
        return (ActivityPlugin) super.find(ENTITY_NAME, id);
    }

    public Collection<ActivityPlugin> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public List<ActivityPlugin> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public Serializable save(ActivityPlugin obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(ActivityPlugin obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public ActivityPlugin getPlugin(String processId, Integer version, String activityId) {
        String condition = "WHERE processId = ? AND activityId = ? AND version = ?";
        Object[] params = {processId, activityId, version};
        
        Collection<ActivityPlugin> pluginList = find(condition, params, null, null, null, null);

        if(pluginList != null && pluginList.size() > 0){
            return pluginList.iterator().next();
        }else{
            return null;
        }
    }

    public String setPluginToActivity(String pluginName, String processId, Integer version, String activityId) {
        ActivityPlugin activityPlugin = new ActivityPlugin();
        activityPlugin.setProcessId(processId);
        activityPlugin.setVersion(version);
        activityPlugin.setActivityId(activityId);
        activityPlugin.setPluginName(pluginName);

        save(activityPlugin);

        return activityPlugin.getId();
    }

    public void removePluginFromActivity(String processId, Integer version, String activityId) {
        ActivityPlugin activityPlugin = getPlugin(processId, version, activityId);
        if(activityPlugin != null){
            delete(activityPlugin);
        }
    }

    public void setPluginProperties(String id, String properties){
        ActivityPlugin activityPlugin = find(id);
        activityPlugin.setPluginProperties(properties);

        saveOrUpdate(activityPlugin);
    }

    public void removePluginProperties(String id){
        ActivityPlugin activityPlugin = find(id);
        activityPlugin.setPluginProperties(null);

        saveOrUpdate(activityPlugin);
    }
}
