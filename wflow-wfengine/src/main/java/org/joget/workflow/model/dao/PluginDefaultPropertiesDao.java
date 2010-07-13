package org.joget.workflow.model.dao;

import java.io.Serializable;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.PluginDefaultProperties;

public class PluginDefaultPropertiesDao extends AbstractSpringDao {
    public static final String ENTITY_NAME = "PluginDefaultProperties";

    public void delete(PluginDefaultProperties obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public PluginDefaultProperties find(String pluginName) {
        return (PluginDefaultProperties) super.find(ENTITY_NAME, pluginName);
    }

    public Serializable save(PluginDefaultProperties obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(PluginDefaultProperties obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public void setPluginDefaultProperties(String pluginName, String properties){
        PluginDefaultProperties plugin = find(pluginName);
        if(plugin == null){
            plugin = new PluginDefaultProperties();
            plugin.setPluginName(pluginName);
        }
        plugin.setPluginProperties(properties);

        saveOrUpdate(plugin);
    }

    public void removePluginDefaultProperties(String pluginName){
        PluginDefaultProperties plugin = find(pluginName);
        if(plugin != null){
            plugin.setPluginProperties(null);
            saveOrUpdate(plugin);
        }
    }
}
