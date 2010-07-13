package org.joget.workflow.util;

import java.util.HashMap;
import java.util.Map;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.PluginDefaultProperties;
import org.joget.workflow.model.dao.PluginDefaultPropertiesDao;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class PluginUtil implements ApplicationContextAware {
    static ApplicationContext appContext;

    public static ApplicationContext getApplicationContext() {
        return appContext;
    }

    public void setApplicationContext(ApplicationContext context) throws BeansException {
        appContext =  context;
    }

    public static Map getDefaultProperties(String pluginName, Map propertyMap){
        try{
            PluginDefaultPropertiesDao pluginDefaultPropertiesDao = (PluginDefaultPropertiesDao) appContext.getBean("pluginDefaultPropertiesDao");

            PluginDefaultProperties pluginDefaultProperties = pluginDefaultPropertiesDao.find(pluginName);

            Map defaultPropertyMap = new HashMap();
            if (pluginDefaultProperties != null) {
                String properties = pluginDefaultProperties.getPluginProperties();
                if (properties != null && properties.trim().length() > 0) {
                    defaultPropertyMap = CsvUtil.getPluginPropertyMap(properties);
                }
            }

            Map tempPropertyMap = new HashMap(propertyMap);                                                                                                                          
            for(Object s: defaultPropertyMap.keySet()){
                String key = (String) s;
                String defaultValue = defaultPropertyMap.get(key).toString().trim();
                String value = "";
                
                if(propertyMap.get(key) != null){
                    value = propertyMap.get(key).toString().trim();
                }

                if(value.equals("") && !defaultValue.equals("")){
                    tempPropertyMap.put(key, defaultValue);
                }
            }

            return tempPropertyMap;
        }catch(Exception e){
            LogUtil.error(PluginUtil.class.getName(), e, "Error @ getDefaultProperties");
        }

        return propertyMap;
    }
}
