package org.joget.plugin.referenceid;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Date;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginProperty;
import java.util.Map;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.UuidGenerator;
import org.joget.form.model.Form;
import org.joget.form.model.service.FormManager;
import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.service.WorkflowManager;

public class ReferenceIdPlugin extends DefaultPlugin implements ApplicationPlugin {

    public String getName() {
        return "Reference ID Plugin";
    }

    public String getDescription() {
        return "Generates reference ID using user-defined format, and sets the value into workflow variable";
    }

    public String getVersion() {
        return "1.0.1";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[]{
            new PluginProperty("formDataTable", "Form Data Table", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("prefix", "Reference Id Prefix", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("noOfDigit", "Number of Digit", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("variableId", "Workflow Variable Id", PluginProperty.TYPE_TEXTFIELD, null, null)
        };
        return properties;
    }

    public Object execute(Map properties) {
        PluginManager pluginManager = (PluginManager) properties.get("pluginManager");
        WorkflowAssignment wfAssignment = (WorkflowAssignment) properties.get("workflowAssignment");
        WorkflowManager wm = (WorkflowManager) pluginManager.getBean("workflowManager");

        String formDataTable = (String) properties.get("formDataTable");
        String prefix = (String) properties.get("prefix");
        String strNoOfDigit = (String) properties.get("noOfDigit");
        String variableId = (String) properties.get("variableId");

        String refCountColumn = "refCount";
        String refNameColumn = "refName";

        try {
            FormManager formManager = (FormManager) pluginManager.getBean("formManager");
            Form form = formManager.loadDynamicFormByProcessId(formDataTable, wfAssignment.getProcessId());
            int referenceCount = formManager.getMaxValue(refCountColumn, formDataTable) + 1;
            String referenceCountStr = String.valueOf(referenceCount);
            int countLength = referenceCountStr.length();

            if (strNoOfDigit != null && !strNoOfDigit.equals("")) {
                int noOfDigit = Integer.parseInt(strNoOfDigit);

                if (noOfDigit > 0 && noOfDigit >= countLength) {

                    String pattern = "";
                    for (int i = 0; i < noOfDigit; i++) {
                        pattern += "0";
                    }

                    DecimalFormat myFormatter = new DecimalFormat(pattern);
                    referenceCountStr = myFormatter.format(referenceCount);
                    String referenceName = prefix + referenceCountStr;

                    if (form != null) {
                        form.setTableName(formDataTable);
                        form.setValueOfCustomField(refCountColumn, referenceCount);
                        form.setValueOfCustomField(refNameColumn, referenceName);
                        formManager.saveOrUpdateDynamicForm(form);
                    } else {
                        form = new Form();
                        form.setId(UuidGenerator.getInstance().getUuid());
                        Map customProperties = new HashMap();
                        customProperties.put("processId", wfAssignment.getProcessId());
                        customProperties.put("activityId", wfAssignment.getActivityId());
                        customProperties.put("version", wfAssignment.getProcessVersion());
                        customProperties.put("created", new Date());
                        customProperties.put("draft", "0");
                        form.setCustomProperties(customProperties);
                        form.setTableName(formDataTable);
                        form.setValueOfCustomField(refCountColumn, referenceCount);
                        form.setValueOfCustomField(refNameColumn, referenceName);
                        formManager.saveOrUpdateDynamicForm(form);
                    }

                    if (variableId != null && !variableId.equals("")) {
                        wm.activityVariable(wfAssignment.getActivityId(), variableId, referenceName);
                    }
                } else {
                    return false;
                }
            } else {
                return false;
            }

            return true;

        } catch (Exception e) {
            LogUtil.error(getClass().getName(), e, "");
            return false;
        }
    }
}
