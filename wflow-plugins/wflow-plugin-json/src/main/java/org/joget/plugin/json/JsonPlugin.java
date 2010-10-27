package org.joget.plugin.json;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginProperty;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.StringUtil;
import org.joget.form.model.Form;
import org.joget.form.model.service.FormManager;
import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.service.WorkflowManager;
import org.joget.workflow.util.WorkflowUtil;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.mozilla.javascript.Context;
import org.mozilla.javascript.Scriptable;

public class JsonPlugin extends DefaultPlugin implements ApplicationPlugin {

    public static final String TYPE_JAVASCRIPT = "JavaScript";
    public static final String TYPE_HTML = "HTML";

    public String getName() {
        return "JSON Plugin";
    }

    public String getDescription() {
        return "Reads a JSON feed URL, and inserts formatted data into form data table or workflow variable";
    }

    public String getVersion() {
        return "1.0.8";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[]{
            new PluginProperty("formDataTable", "Form Data Table", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("formDataTableColumn", "Form Data Table Column", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("workflowVariable", "Workflow Variable Name", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("jsonUrl", "Json Feed URL", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("formatterType", "Formatter Type", PluginProperty.TYPE_RADIO, new String[]{TYPE_JAVASCRIPT, TYPE_HTML}, null),
            new PluginProperty("formatter", "Formatter", PluginProperty.TYPE_TEXTAREA, null, null)
        };
        return properties;
    }

    public Object execute(Map properties) {
        PluginManager pluginManager = (PluginManager) properties.get("pluginManager");
        WorkflowAssignment wfAssignment = (WorkflowAssignment) properties.get("workflowAssignment");

        String formDataTable = (String) properties.get("formDataTable");
        String formDataTableColumn = (String) properties.get("formDataTableColumn");
        String jsonUrl = (String) properties.get("jsonUrl");
        String formatterType = (String) properties.get("formatterType");
        String formatter = (String) properties.get("formatter");
        String workflowVariable = (String) properties.get("workflowVariable");

        GetMethod get = null;
        try {
            HttpClient client = new HttpClient();

            jsonUrl = WorkflowUtil.processVariable(jsonUrl, formDataTable, wfAssignment);

            jsonUrl = StringUtil.encodeUrlParam(jsonUrl);

            get = new GetMethod(jsonUrl);
            client.executeMethod(get);
            InputStream in = get.getResponseBodyAsStream();
            String jsonResponse = streamToString(in);

            if (formatterType != null && !formatterType.trim().equals("")) {
                String formattedOutput = "";
                if (formatterType.equals(TYPE_JAVASCRIPT)) {
                    formattedOutput = processJavaScript(formatter, jsonResponse);
                } else {
                    formattedOutput = processHtml(formatter, jsonResponse);
                }

                FormManager formManager = (FormManager) pluginManager.getBean("formManager");
                Form form = formManager.loadDynamicFormByProcessId(formDataTable, wfAssignment.getProcessId());
                if (form != null) {
                    form.setTableName(formDataTable);
                    form.setValueOfCustomField(formDataTableColumn, formattedOutput);
                    formManager.saveOrUpdateDynamicForm(form);
                }

                if (workflowVariable != null && !workflowVariable.trim().equals("")) {
                    WorkflowManager workflowManager = (WorkflowManager) pluginManager.getBean("workflowManager");
                    workflowManager.activityVariable(wfAssignment.getActivityId(), workflowVariable, formattedOutput);
                }
            }
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        } finally {
            if (get != null) {
                get.releaseConnection();
            }
        }

        return null;
    }

    public String processJavaScript(String script, String json) {
        Context cx = Context.enter();
        try {
            String evalObj = "var obj = " + json + ";";

            Scriptable scope = cx.initStandardObjects();
            Object result = cx.evaluateString(scope, evalObj + script, "JsonPlugin", 1, null);
            return Context.toString(result);

        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        } finally {
            Context.exit();
        }

        return "";
    }

    public String processHtml(String target, String json) throws JSONException {
        Pattern pattern = Pattern.compile("\\#([^#])*\\#");
        Matcher matcher = pattern.matcher(target);
        List<String> varList = new ArrayList<String>();
        while (matcher.find()) {
            varList.add(matcher.group());
        }

        for (String var : varList) {
            try {
                String tempVar = var.replaceAll("#", "");

                if (tempVar.startsWith("obj")) {
                    tempVar = tempVar.replace("obj.", "");
                    String[] chain = tempVar.split("\\.");

                    JSONObject obj = new JSONObject(json);
                    int i = 0;
                    for (i = 0; i < chain.length - 1; i++) {
                        String tempChain = chain[i];
                        if (tempChain.indexOf("[") != -1 && tempChain.indexOf("]") != -1) {
                            int firstIndex = tempChain.indexOf("[");
                            int lastIndex = tempChain.indexOf("]");
                            Integer index = Integer.parseInt(tempChain.substring(firstIndex + 1, lastIndex));
                            tempChain = tempChain.substring(0, firstIndex);

                            JSONArray tempArray = obj.getJSONArray(tempChain);
                            obj = tempArray.getJSONObject(index);
                        } else {
                            obj = obj.getJSONObject(chain[i]);
                        }

                    }

                    target = target.replaceAll(StringUtil.escapeRegex(var), obj.getString(chain[i]));
                }
            } catch (Exception ex) {
                target = target.replaceAll(StringUtil.escapeRegex(var), "");
            }
        }

        return target;
    }

    public String streamToString(InputStream in) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(in));
        StringBuilder sb = new StringBuilder();

        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line + "\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                in.close();
            } catch (IOException e) {
                LogUtil.error(getClass().getName(), e, "");
            }
        }

        return sb.toString();
    }
}
