package org.joget.workflow.controller;

import au.com.bytecode.opencsv.CSVWriter;
import org.joget.commons.util.DynamicDataSourceManager;
import org.joget.commons.spring.model.Setting;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.directory.model.service.DirectoryManagerImpl;
import org.joget.directory.model.service.DirectoryManagerPlugin;
import org.joget.directory.model.service.DirectoryManagerProxyImpl;
import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.WorkflowFacade;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Arrays;
import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import org.joget.commons.util.HostManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SetupWebController {

    @Autowired
    private SetupManager setupManager;

    @Autowired
    private PluginManager pluginManager;

    @Autowired
    @Qualifier("main")
    private DirectoryManager directoryManager;

    @Autowired
    private WorkflowFacade workflowFacade;

    @RequestMapping("/settings/setup/list")
    public String setupList(ModelMap map) {
        Collection<Setting> settingList = setupManager.getSettingList("", null, null, null, null);

        Map<String, String> settingMap = new HashMap<String, String>();
        for (Setting setting : settingList) {
            settingMap.put(setting.getProperty(), setting.getValue());
        }

        Properties properties = DynamicDataSourceManager.getProperties();
        for (Object key : properties.keySet()) {
            settingMap.put(key.toString(), properties.getProperty(key.toString()));
        }

        //get directory manager plugin list
        Collection<Plugin> pluginList = pluginManager.list();
        Iterator i = pluginList.iterator();
        while (i.hasNext()) {
            Plugin plugin = (Plugin) i.next();
            if (!(plugin instanceof DirectoryManagerPlugin)) {
                i.remove();
            }
        }
        
        // get current directory manager class name
        String directoryManagerClassName = directoryManager.getClass().getName();
        if (directoryManager instanceof DirectoryManagerProxyImpl) {
            directoryManagerClassName = ((DirectoryManagerProxyImpl) directoryManager).getDirectoryManagerImpl().getClass().getName();
        }
        boolean directoryManagerConfigError = DirectoryManagerImpl.class.getName().equals(directoryManagerClassName);

        Locale[] localeList = Locale.getAvailableLocales();
        String[] localeStringList = new String[localeList.length];
        for (int x = 0; x < localeList.length; x++) {
            localeStringList[x] = localeList[x].toString();
        }
        Arrays.sort(localeStringList);

        map.addAttribute("localeList", localeStringList);
        map.addAttribute("settingMap", settingMap);
        map.addAttribute("profileList", DynamicDataSourceManager.getProfileList());
        map.addAttribute("currentProfile", DynamicDataSourceManager.getCurrentProfile());
        map.addAttribute("directoryManagerPluginList", pluginList);
        map.addAttribute("directoryManagerClassName", directoryManagerClassName);
        map.addAttribute("directoryManagerConfigError", directoryManagerConfigError);
        return "setup/setupList";
    }

    @RequestMapping(value = "/settings/setup/profile/change", method = RequestMethod.POST)
    public void profileChange(Writer writer, @RequestParam("profileName") String profileName) {
        if (!HostManager.isVirtualHostEnabled()) {
            DynamicDataSourceManager.changeProfile(profileName);
        }
    }

    @RequestMapping(value = "/settings/setup/profile/create", method = RequestMethod.POST)
    public void profileCreate(Writer writer, HttpServletRequest request, @RequestParam("profileName") String profileName) {
        if (!HostManager.isVirtualHostEnabled()) {
            DynamicDataSourceManager.createProfile(profileName);
            DynamicDataSourceManager.changeProfile(profileName);

            //request params
            Enumeration e = request.getParameterNames();
            while (e.hasMoreElements()) {
                String paramName = (String) e.nextElement();
                if (!paramName.equals("profileName")) {
                    String paramValue = request.getParameter(paramName);
                    DynamicDataSourceManager.writeProperty(paramName, paramValue);
                }
            }
        }
    }

    @RequestMapping(value = "/settings/setup/profile/delete", method = RequestMethod.POST)
    public void profileDelete(Writer writer, @RequestParam("profileName") String profileName) {
        if (!HostManager.isVirtualHostEnabled()) {
            DynamicDataSourceManager.deleteProfile(profileName);
        }
    }

    @RequestMapping(value = "/settings/setup/submit", method = RequestMethod.POST)
    public String setupSubmit(HttpServletRequest request, ModelMap map) {
        boolean deleteProcessOnCompletionIsNull = true;
        boolean enableNtlmIsNull = true;
        boolean rightToLeftIsNull = true;

        //request params
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();
            String paramValue = request.getParameter(paramName);

            if (paramName.equals("deleteProcessOnCompletion")) {
                deleteProcessOnCompletionIsNull = false;
                paramValue = "true";
            }

            if (paramName.equals("enableNtlm")) {
                enableNtlmIsNull = false;
                paramValue = "true";
            }

            if (paramName.equals("rightToLeft")) {
                rightToLeftIsNull = false;
                paramValue = "true";
            }

            Setting setting = setupManager.getSettingByProperty(paramName);
            if (setting == null) {
                setting = new Setting();
                setting.setProperty(paramName);
                setting.setValue(paramValue);
            } else {
                setting.setValue(paramValue);
            }
            setupManager.saveSetting(setting);
        }

        if (deleteProcessOnCompletionIsNull) {
            Setting setting = setupManager.getSettingByProperty("deleteProcessOnCompletion");
            if (setting == null) {
                setting = new Setting();
                setting.setProperty("deleteProcessOnCompletion");
            }
            setting.setValue("false");
            setupManager.saveSetting(setting);
        }

        if (enableNtlmIsNull) {
            Setting setting = setupManager.getSettingByProperty("enableNtlm");
            if (setting == null) {
                setting = new Setting();
                setting.setProperty("enableNtlm");
            }
            setting.setValue("false");
            setupManager.saveSetting(setting);
        }

        if (rightToLeftIsNull) {
            Setting setting = setupManager.getSettingByProperty("rightToLeft");
            if (setting == null) {
                setting = new Setting();
                setting.setProperty("rightToLeft");
            }
            setting.setValue("false");
            setupManager.saveSetting(setting);
        }

        pluginManager.refresh();
        workflowFacade.updateDeadlineChecker();

        return "redirect:/web/settings/setup/list";
    }

    @RequestMapping(value = "/settings/setup/datasource/submit", method = RequestMethod.POST)
    public String setupDatasourceSubmit(HttpServletRequest request, ModelMap map) {
        //request params
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();
            if (!paramName.equals("profileName")) {
                String paramValue = request.getParameter(paramName);
                DynamicDataSourceManager.writeProperty(paramName, paramValue);
            }
        }

        return "redirect:/web/settings/setup/list?tab=datasourceSetup";
    }

    @RequestMapping(value = "/settings/setup/directoryManagerImpl/remove", method = RequestMethod.POST)
    public void setupDirectoryManagerImplRemove(Writer writer, ModelMap map) {
        setupManager.deleteSetting("directoryManagerImpl");
        setupManager.deleteSetting("directoryManagerImplProperties");
    }

    @RequestMapping("/settings/setup/directoryManagerImpl/config")
    public String setupDirectoryManagerImplConfig(ModelMap map, @RequestParam("directoryManagerImpl") String directoryManagerImpl) throws IOException {
        Plugin plugin = pluginManager.getPlugin(directoryManagerImpl);

        Map propertyMap = new HashMap();
        String properties = setupManager.getSettingValue("directoryManagerImplProperties");
        if (properties != null && properties.trim().length() > 0) {
            propertyMap = CsvUtil.getPluginPropertyMap(properties);
        }

        map.addAttribute("plugin", plugin);
        map.addAttribute("propertyMap", propertyMap);
        map.addAttribute("directoryManagerImpl", directoryManagerImpl);
        return "setup/directoryManagerImplConfig";
    }

    @RequestMapping(value = "/settings/setup/directoryManagerImpl/config/submit", method = RequestMethod.POST)
    public String setupDirectoryManagerImplConfigSubmit(ModelMap map, @RequestParam("directoryManagerImpl") String directoryManagerImpl, HttpServletRequest request) {
        //request params
        Map<String, String> propertyMap = new HashMap();
        Enumeration e = request.getParameterNames();
        while (e.hasMoreElements()) {
            String paramName = (String) e.nextElement();

            //ignore the parameter "directoryManagerImpl"
            if (!paramName.equals("directoryManagerImpl")) {
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

        //save plugin
        Setting setting = setupManager.getSettingByProperty("directoryManagerImpl");
        if (setting == null) {
            setting = new Setting();
            setting.setProperty("directoryManagerImpl");
        }
        setting.setValue(directoryManagerImpl);
        setupManager.saveSetting(setting);

        //save plugin properties
        Setting propertySetting = setupManager.getSettingByProperty("directoryManagerImplProperties");
        if (propertySetting == null) {
            propertySetting = new Setting();
            propertySetting.setProperty("directoryManagerImplProperties");
        }
        propertySetting.setValue(sw.toString());
        setupManager.saveSetting(propertySetting);

        return "setup/directoryManagerImplConfigSuccess";
    }

    @RequestMapping("/settings/version")
    public String setupVersion(ModelMap map) {
        return "setup/setupVersion";
    }
}
