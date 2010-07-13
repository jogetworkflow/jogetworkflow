package org.joget.workflow.controller;

import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.AuditTrailPlugin;
import org.joget.plugin.base.FormVariablePlugin;
import org.joget.plugin.base.ParticipantPlugin;
import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import java.io.Writer;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PluginJsonController {

    @Autowired
    private PluginManager pluginManager;

    @RequestMapping("/json/workflow/plugin/list")
    public void pluginList(Writer writer, @RequestParam(value = "pluginType", required = false) String pluginType) throws JSONException {
        Collection<Plugin> pluginList = pluginManager.list();
        JSONObject jsonObject = new JSONObject();
        int size = 0;

        for (Plugin plugin : pluginList) {
            if (pluginType != null && pluginType.trim().length() > 0) {
                boolean add = false;

                if (pluginType.equals("Form Variable")) {

                    if (plugin instanceof FormVariablePlugin) {
                        add = true;
                    }
                } else if (pluginType.equals("Application")) {

                    if (plugin instanceof ApplicationPlugin) {
                        add = true;
                    }
                } else if (pluginType.equals("Participant")) {

                    if (plugin instanceof ParticipantPlugin) {
                        add = true;
                    }
                } else if (pluginType.equals("Audit Trail")) {
                    
                    if (plugin instanceof AuditTrailPlugin) {
                        add = true;
                    }
                }

                if (add) {
                    Map data = new HashMap();
                    data.put("id", plugin.getClass().getName());
                    data.put("name", plugin.getName());
                    data.put("description", plugin.getDescription());
                    data.put("version", plugin.getVersion());

                    jsonObject.accumulate("data", data);
                    size++;
                }
            } else {
                Map data = new HashMap();
                data.put("id", plugin.getClass().getName());
                data.put("name", plugin.getName());
                data.put("version", plugin.getVersion());

                jsonObject.accumulate("data", data);
                size++;
            }
        }

        jsonObject.accumulate("total", size);
        jsonObject.write(writer);
    }
}
