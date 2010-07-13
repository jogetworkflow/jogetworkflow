package org.joget.workflow.controller;

import au.com.bytecode.opencsv.CSVWriter;
import org.joget.commons.util.FileStore;
import org.joget.directory.model.service.DirectoryManagerPlugin;
import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.AuditTrailPlugin;
import org.joget.plugin.base.FormVariablePlugin;
import org.joget.plugin.base.ParticipantPlugin;
import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import javax.servlet.http.HttpServletRequest;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.PluginDefaultProperties;
import org.joget.workflow.model.dao.PluginDefaultPropertiesDao;
import org.joget.workflow.model.AuditTrailPluginConfiguration;
import org.joget.workflow.model.dao.AuditTrailPluginDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class PluginWebController {

    @Autowired
    private PluginManager pluginManager;

    @Autowired
    private AuditTrailPluginDao auditTrailPluginDao;

    @Autowired
    private PluginDefaultPropertiesDao pluginDefaultPropertiesDao;

    @RequestMapping("/settings/plugin/refresh")
    public void refresh(Writer writer) {
        pluginManager.refresh();
    }

    @RequestMapping("/settings/plugin/list")
    public String pluginList(ModelMap map, @RequestParam(value = "pluginType", required = false) String pluginType) {
        String[] pluginTypeList = new String[]{"Form Variable", "Application", "Participant", "Audit Trail", "Directory Manager"};

        Collection<Plugin> pluginList = pluginManager.list();
        TreeMap<String, Plugin> sortedPluginList = new TreeMap<String, Plugin>();

        if (pluginType != null && pluginType.trim().length() > 0) {
            Iterator i = pluginList.iterator();

            while (i.hasNext()) {
                Plugin plugin = (Plugin) i.next();
                if (pluginType.equals("Form Variable")) {

                    if (!(plugin instanceof FormVariablePlugin)) {
                        i.remove();
                    }
                } else if (pluginType.equals("Application")) {

                    if (!(plugin instanceof ApplicationPlugin)) {
                        i.remove();
                    }
                } else if (pluginType.equals("Participant")) {

                    if (!(plugin instanceof ParticipantPlugin)) {
                        i.remove();
                    }
                } else if (pluginType.equals("Audit Trail")) {

                    if (!(plugin instanceof AuditTrailPlugin)) {
                        i.remove();
                    }
                } else if (pluginType.equals("Directory Manager")) {

                    if (!(plugin instanceof DirectoryManagerPlugin)) {
                        i.remove();
                    }
                }
            }
        }

        Iterator i = pluginList.iterator();
        while (i.hasNext()) {
            Plugin plugin = (Plugin) i.next();
            sortedPluginList.put(plugin.getName(), plugin);
        }

        map.addAttribute("pluginTypeList", pluginTypeList);
        map.addAttribute("sortedPluginList", sortedPluginList);
        return "plugin/pluginList";
    }

    @RequestMapping("/settings/plugin/upload")
    public String pluginUpload() {
        return "plugin/pluginUpload";
    }

    @RequestMapping(value = "/settings/plugin/upload/submit", method = RequestMethod.POST)
    public String pluginUploadSubmit(ModelMap map) throws IOException {
        MultipartFile pluginFile = FileStore.getFile("pluginFile");

        try {
            pluginManager.upload(pluginFile.getOriginalFilename(), pluginFile.getInputStream());
        } catch (Exception e) {
            if (e.getCause().getMessage() != null && e.getCause().getMessage().contains("Invalid jar file")) {
                map.addAttribute("errorMessage", "Invalid jar file");
            } else {
                map.addAttribute("errorMessage", "Error uploading plugin");
            }
            return "plugin/pluginUpload";
        }

        return "plugin/pluginUploadSuccess";
    }

    @RequestMapping(value = "/settings/plugin/uninstall", method = RequestMethod.POST)
    public String pluginUninstall(ModelMap map, @RequestParam("selectedPlugins") String[] selectedPlugins) {
        for (String pluginClassName : selectedPlugins) {
            pluginManager.uninstall(pluginClassName);
        }
        return "redirect:/web/settings/plugin/list";
    }

    @RequestMapping(value = "/settings/plugin/configure")
    public String pluginConfigure(ModelMap map, @RequestParam("pluginName") String pluginName) throws IOException {
        AuditTrailPluginConfiguration auditTrailPluginConfiguration = auditTrailPluginDao.find(pluginName);
        Plugin plugin = pluginManager.getPlugin(pluginName);

        Map propertyMap = new HashMap();
        if (auditTrailPluginConfiguration != null) {
            String properties = auditTrailPluginConfiguration.getPluginProperties();
            if (properties != null && properties.trim().length() > 0) {
                propertyMap = CsvUtil.getPluginPropertyMap(properties);
            }
        }

        map.addAttribute("plugin", plugin);
        map.addAttribute("propertyMap", propertyMap);
        map.addAttribute("pluginName", pluginName);

        return "plugin/pluginConfig";
    }

    @RequestMapping("/settings/plugin/configure/submit")
    public String pluginConfigureSubmit(ModelMap map, @RequestParam("pluginName") String pluginName, HttpServletRequest request) {
        //remove existing properties
        auditTrailPluginDao.removePluginProperties(pluginName);

        //request params
        Map<String, String> propertyMap = new HashMap();
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //ignore the parameter "activityPluginId"
            if (!paramName.equals("pluginName")) {
                String[] paramValue = (String[]) request.getParameterValues(paramName);
                propertyMap.put(paramName, CsvUtil.getDeliminatedString(paramValue));
            }
        }

        StringWriter sw = new StringWriter();
        try {
            CSVWriter writer = new CSVWriter(sw);
            Iterator it = propertyMap.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<String, String> pairs = (Map.Entry) it.next();
                writer.writeNext(new String[]{pairs.getKey(), pairs.getValue()});
            }
            writer.close();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
        auditTrailPluginDao.setPluginProperties(pluginName, sw.toString());

        return "plugin/pluginConfigSuccess";
    }

    @RequestMapping(value = "/settings/plugin/default")
    public String pluginDefaultProperties(ModelMap map, @RequestParam("pluginName") String pluginName) throws IOException {
        PluginDefaultProperties pluginDefaultProperties = pluginDefaultPropertiesDao.find(pluginName);
        Plugin plugin = pluginManager.getPlugin(pluginName);

        Map propertyMap = new HashMap();
        if (pluginDefaultProperties != null) {
            String properties = pluginDefaultProperties.getPluginProperties();
            if (properties != null && properties.trim().length() > 0) {
                propertyMap = CsvUtil.getPluginPropertyMap(properties);
            }
        }

        map.addAttribute("plugin", plugin);
        map.addAttribute("propertyMap", propertyMap);
        map.addAttribute("pluginName", pluginName);

        return "plugin/pluginDefaultProperties";
    }

    @RequestMapping("/settings/plugin/default/submit")
    public String pluginDefaultPropertiesSubmit(ModelMap map, @RequestParam("pluginName") String pluginName, HttpServletRequest request) {
        //remove existing properties
        pluginDefaultPropertiesDao.removePluginDefaultProperties(pluginName);

        //request params
        Map<String, String> propertyMap = new HashMap();
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //ignore the parameter "activityPluginId"
            if (!paramName.equals("pluginName")) {
                String[] paramValue = (String[]) request.getParameterValues(paramName);
                propertyMap.put(paramName, CsvUtil.getDeliminatedString(paramValue));
            }
        }

        StringWriter sw = new StringWriter();
        try {
            CSVWriter writer = new CSVWriter(sw);
            Iterator it = propertyMap.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<String, String> pairs = (Map.Entry) it.next();
                writer.writeNext(new String[]{pairs.getKey(), pairs.getValue()});
            }
            writer.close();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
        pluginDefaultPropertiesDao.setPluginDefaultProperties(pluginName, sw.toString());

        return "plugin/pluginConfigSuccess";
    }
}
