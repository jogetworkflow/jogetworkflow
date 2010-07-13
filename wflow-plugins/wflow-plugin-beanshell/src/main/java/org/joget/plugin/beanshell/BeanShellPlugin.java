package org.joget.plugin.beanshell;

import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.FormVariablePlugin;
import org.joget.plugin.base.ParticipantPlugin;
import org.joget.plugin.base.PluginProperty;
import bsh.Interpreter;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.collections.SequencedHashMap;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.util.WorkflowUtil;

public class BeanShellPlugin extends DefaultPlugin implements ApplicationPlugin, FormVariablePlugin, ParticipantPlugin {

    public String getName() {
        return "BeanShell Plugin";
    }

    public String getVersion() {
        return "1.0.2";
    }

    public String getDescription() {
        return "Executes standard Java syntax";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[]{
            new PluginProperty("script", "Script", PluginProperty.TYPE_TEXTAREA, null, null)
        };
        return properties;
    }

    public Object execute(Map properties) {
        String script = (String) properties.get("script");
        WorkflowAssignment wfAssignment = (WorkflowAssignment) properties.get("workflowAssignment");
        script = WorkflowUtil.processVariable(script, "", wfAssignment);

        return executeScript(script, properties);
    }

    public Map getVariableOptions(Map properties) {
        Map resultMap = null;
        String script = (String) properties.get("script");
        Object result = executeScript(script, properties);
        if (result instanceof Map) {
            resultMap = (Map) result;
        } else if (result instanceof Object[]) {
            resultMap = new SequencedHashMap();
            for (Object row : (Object[]) result) {
                String val = row.toString();
                resultMap.put(val, val);
            }
        } else {
            resultMap = new HashMap();
        }
        return resultMap;
    }

    protected Object executeScript(String script, Map properties) {
        Object result = null;
        try {
            Interpreter interpreter = new Interpreter();
            interpreter.setClassLoader(getClass().getClassLoader());
            for (Object key : properties.keySet()) {
                interpreter.set(key.toString(), properties.get(key));
            }
            Logger.getLogger(getClass().getName()).log(Level.FINE, "Executing script " + script);
            result = interpreter.eval(script);
            return result;
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.WARNING, "Error executing script", e);
            return null;
        }
    }

    public Collection<String> getActivityAssignments(Map properties) {
        String script = (String) properties.get("script");
        return (Collection<String>) executeScript(script, properties);
    }
}
