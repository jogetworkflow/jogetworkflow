package org.joget.workflow.model.service;

import org.joget.commons.util.LogUtil;
import org.joget.plugin.base.AuditTrailPlugin;
import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.AuditTrail;
import org.joget.workflow.model.dao.AuditTrailDao;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.joget.commons.util.CsvUtil;
import org.joget.workflow.model.AuditTrailPluginConfiguration;
import org.joget.workflow.model.dao.AuditTrailPluginDao;

public class AuditTrailManager {

    private WorkflowUserManager workflowUserManager;
    private PluginManager pluginManager;
    private AuditTrailDao auditTrailDao;
    private AuditTrailPluginDao auditTrailPluginDao;
    
    public void addAuditTrail(String clazz, String method, String message){
        AuditTrail auditTrail = new AuditTrail();
        auditTrail.setUsername(getWorkflowUserManager().getCurrentUsername());
        auditTrail.setClazz(clazz);
        auditTrail.setMethod(method);
        auditTrail.setMessage(message);
        auditTrail.setTimestamp(new Date());

        getAuditTrailDao().addAuditTrail(auditTrail);
        executePlugin(auditTrail);
    }
    
    public void executePlugin(AuditTrail auditTrail){
        Collection<Plugin> pluginList = getPluginManager().list();
        for(Plugin plugin : pluginList){
            if(plugin instanceof AuditTrailPlugin){
                AuditTrailPlugin p = (AuditTrailPlugin) plugin;
                try {
                    Map properties = new HashMap();

                    AuditTrailPluginConfiguration config = getAuditTrailPluginDao().find(plugin.getClass().getName());
                    if(config != null){
                        Map temp = CsvUtil.getPluginPropertyMap(config.getPluginProperties());
                        properties.putAll(temp);
                    }
                    
                    properties.put("auditTrail", auditTrail);
                    properties.put("pluginManager", getPluginManager());

                    p.execute(properties);
                }
                catch(Exception e) {
                    LogUtil.error(getClass().getName(), e, "Error executing plugin " + p.getClass().getName());
                }
            }
        }
    }

    public WorkflowUserManager getWorkflowUserManager() {
        return workflowUserManager;
    }

    public void setWorkflowUserManager(WorkflowUserManager workflowUserManager) {
        this.workflowUserManager = workflowUserManager;
    }

    public AuditTrailDao getAuditTrailDao() {
        return auditTrailDao;
    }

    public void setAuditTrailDao(AuditTrailDao auditTrailDao) {
        this.auditTrailDao = auditTrailDao;
    }

    public PluginManager getPluginManager() {
        return pluginManager;
    }

    public void setPluginManager(PluginManager pluginManager) {
        this.pluginManager = pluginManager;
    }

    public AuditTrailPluginDao getAuditTrailPluginDao() {
        return auditTrailPluginDao;
    }

    public void setAuditTrailPluginDao(AuditTrailPluginDao auditTrailPluginDao) {
        this.auditTrailPluginDao = auditTrailPluginDao;
    }
}
