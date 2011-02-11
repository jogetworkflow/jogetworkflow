package org.joget.workflow.shark;

import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.ActivityPlugin;
import org.joget.workflow.model.dao.ActivityPluginDao;
import org.enhydra.shark.StandardToolActivityHandler;
import org.enhydra.shark.api.client.wfmc.wapi.WMSessionHandle;
import org.enhydra.shark.api.internal.toolagent.ToolAgentGeneralException;
import org.enhydra.shark.api.internal.working.WfActivityInternal;
import org.springframework.context.ApplicationContext;
import org.joget.plugin.base.ApplicationPlugin;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowVariable;
import org.joget.workflow.model.service.AuditTrailManager;
import org.joget.workflow.util.WorkflowUtil;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.joget.workflow.util.PluginUtil;

public class WorkflowToolActivityHandler extends StandardToolActivityHandler {

    private PluginManager pluginManager;
    private ActivityPluginDao activityPluginDao;

    public WorkflowToolActivityHandler(){
        super();
    }

    @Override
    public void executeActivity(WMSessionHandle shandle, WfActivityInternal act) throws Exception, ToolAgentGeneralException {

        ApplicationContext appContext = WorkflowUtil.getApplicationContext();
        AuditTrailManager auditTrailManager = (AuditTrailManager) appContext.getBean("auditTrailManager");

        try{
            pluginManager     = (PluginManager) appContext.getBean("pluginManager");
            activityPluginDao = (ActivityPluginDao) appContext.getBean("activityPluginDao");

            String processId = act.container(shandle).manager(shandle).name(shandle);
            String activityId = act.activity_definition_id(shandle);
            String version = act.container(shandle).manager(shandle).version(shandle);

            //get and execute plugin (if any)
            ActivityPlugin activityPlugin = activityPluginDao.getPlugin(processId, Integer.parseInt(version), activityId);

            if(activityPlugin != null){
                String properties = activityPlugin.getPluginProperties();

                Map propertyMap = CsvUtil.getPluginPropertyMap(properties);

                //insert pre-defined data into property map
                WorkflowAssignment workflowAssignment = new WorkflowAssignment();
                workflowAssignment.setProcessId(act.process_id(shandle));
                workflowAssignment.setProcessDefId(processId);
                workflowAssignment.setProcessName(act.container(shandle).name(shandle));
                workflowAssignment.setProcessVersion(version);
                workflowAssignment.setProcessRequesterId((String) shandle.getVendorData());
                workflowAssignment.setDescription(act.description(shandle));
                workflowAssignment.setActivityDefId(activityId);
                workflowAssignment.setActivityId(act.key(shandle));
                workflowAssignment.setActivityName(act.name(shandle));
                workflowAssignment.setAssigneeId(act.getPerformerId(shandle));

                List<WorkflowVariable> processVariableList = new ArrayList();
                Map variableMap = act.process_context(shandle);
                Iterator it = variableMap.entrySet().iterator();
                while (it.hasNext()) {
                    Map.Entry<String, String> pairs = (Map.Entry) it.next();
                    WorkflowVariable var = new WorkflowVariable();
                    var.setId(pairs.getKey());
                    var.setVal(pairs.getValue());
                    processVariableList.add(var);
                }
                workflowAssignment.setProcessVariableList(processVariableList);

                propertyMap.put("workflowAssignment", workflowAssignment);
                propertyMap.put("pluginManager", pluginManager);

                // add HttpServletRequest into the property map
                try {
                    HttpServletRequest request = WorkflowUtil.getHttpServletRequest();
                    if (request != null) {
                        propertyMap.put("request", request);
                    }
                } catch (NoClassDefFoundError e) {
                    // ignore if class is not found
                }

                LogUtil.info(getClass().getName(), "Executing tool [pluginName=" + activityPlugin.getPluginName() + ", processId=" + processId + ", version= " + version + ", activityId=" + activityId + "]");
                auditTrailManager.addAuditTrail(this.getClass().getName(), "executeActivity", "Executing tool [pluginName=" + activityPlugin.getPluginName() + ", processId=" + processId + ", version= " + version + ", activityId=" + activityId + "]");

                ApplicationPlugin plugin = (ApplicationPlugin) pluginManager.getPlugin(activityPlugin.getPluginName());
                if (plugin != null) {
                    plugin.execute(PluginUtil.getDefaultProperties(activityPlugin.getPluginName(), propertyMap));
                }else {
                    LogUtil.warn(getClass().getName(), "Plugin not available for [pluginName=" + activityPlugin.getPluginName() + ", processId=" + processId + ", version= " + version + ", activityId=" + activityId + "]");
                }
            }else {
                LogUtil.warn(getClass().getName(), "Plugin not mapped for [processId=" + processId + ", version= " + version + ", activityId=" + activityId + "]");
            }

        }catch(Throwable ex){
            auditTrailManager.addAuditTrail(this.getClass().getName(), "executeActivity", "Could not execute tool [processId=" + act.container(shandle).manager(shandle).name(shandle) + ", version=" + act.container(shandle).manager(shandle).version(shandle) + ", activityId=" + act.activity_definition_id(shandle) + "]");

            LogUtil.error(getClass().getName(), ex, "Could not execute tool [processId=" + act.container(shandle).manager(shandle).name(shandle) + ", version=" + act.container(shandle).manager(shandle).version(shandle) + ", activityId=" + act.activity_definition_id(shandle) + "]");
        }
    }
}
