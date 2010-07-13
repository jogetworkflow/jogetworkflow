package org.joget.workflow.model.dao;

import java.io.Serializable;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.AuditTrailPluginConfiguration;

public class AuditTrailPluginDao extends AbstractSpringDao {

    public static final String ENTITY_NAME = "AuditTrailPluginConfiguration";

    public void delete(AuditTrailPluginConfiguration obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public AuditTrailPluginConfiguration find(String pluginName) {
        return (AuditTrailPluginConfiguration) super.find(ENTITY_NAME, pluginName);
    }

    public Serializable save(AuditTrailPluginConfiguration obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(AuditTrailPluginConfiguration obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public void setPluginProperties(String pluginName, String properties){
        AuditTrailPluginConfiguration auditTrailPlugin = find(pluginName);
        if(auditTrailPlugin == null){
            auditTrailPlugin = new AuditTrailPluginConfiguration();
            auditTrailPlugin.setPluginName(pluginName);
        }
        auditTrailPlugin.setPluginProperties(properties);

        saveOrUpdate(auditTrailPlugin);
    }

    public void removePluginProperties(String pluginName){
        AuditTrailPluginConfiguration auditTrailPlugin = find(pluginName);
        if(auditTrailPlugin != null){
            auditTrailPlugin.setPluginProperties(null);
            saveOrUpdate(auditTrailPlugin);
        }
    }

}
