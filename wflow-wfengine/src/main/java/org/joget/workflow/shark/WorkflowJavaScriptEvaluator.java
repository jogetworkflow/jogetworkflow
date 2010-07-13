package org.joget.workflow.shark;

import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.enhydra.shark.api.RootException;
import org.enhydra.shark.api.client.wfmc.wapi.WMSessionHandle;
import org.enhydra.shark.api.common.SharkConstants;
import org.enhydra.shark.api.internal.scripting.Evaluator;
import org.enhydra.shark.api.internal.working.CallbackUtilities;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.plugin.base.AuditTrailPlugin;
import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.AuditTrail;
import org.joget.workflow.model.AuditTrailPluginConfiguration;
import org.joget.workflow.model.WorkflowDeadline;
import org.joget.workflow.model.dao.AuditTrailPluginDao;
import org.joget.workflow.util.WorkflowUtil;
import org.mozilla.javascript.Scriptable;
import org.springframework.context.ApplicationContext;

/**
 * Implementation of the Evaluator interface which evaluates the condition body as a java
 * script expression.
 */
public class WorkflowJavaScriptEvaluator implements Evaluator {

    private static final String LOG_CHANNEL = "Scripting";
    private CallbackUtilities cus;

    public void configure(CallbackUtilities cus) throws Exception {
        this.cus = cus;
    }

    /**
     * Evaluate the condition using java script as the expression language. This method
     * returns true if the condition is satisfied.
     *
     * @param condition The condition
     * @param context The context
     * @return True if the condition is true
     */
    public boolean evaluateCondition(WMSessionHandle shandle,
            String procId,
            String actId,
            String condition,
            Map context) throws Exception {
        if (condition == null || condition.trim().length() == 0) {
            return true;
        }

        java.lang.Object eval = evaluateExpression(shandle,
                procId,
                actId,
                condition,
                context,
                java.lang.Boolean.class);
        try {
            return ((Boolean) eval).booleanValue();
        } catch (Exception ex) {
            cus.error(shandle, LOG_CHANNEL, "JavaScriptEvaluator -> The result of condition "
                    + condition + " cannot be converted to boolean");
            cus.error(shandle, "JavaScriptEvaluator -> The result of condition "
                    + condition + " cannot be converted to boolean");
            throw ex;
        }

    }

    /**
     * Evaluates the given expression.
     *
     * @param expr The expression String
     * @param context The workflow context
     * @param resultClass Returned object should be the instance of this Java class
     * @return The result of expression evaluation.
     */
    public java.lang.Object evaluateExpression(WMSessionHandle shandle,
            String procId,
            String actId,
            String expr,
            Map context,
            Class resultClass) throws Exception {

        if (context.containsKey(SharkConstants.PROCESS_STARTED_TIME)
                && context.containsKey(SharkConstants.ACTIVITY_ACCEPTED_TIME)
                && context.containsKey(SharkConstants.ACTIVITY_ACTIVATED_TIME)) {
            AuditTrail auditTrail = new AuditTrail();
            auditTrail.setUsername(WorkflowUtil.getCurrentUsername());
            auditTrail.setClazz("WorkflowJavaScriptEvaluator");
            auditTrail.setMethod("evaluateDeadline");
            auditTrail.setMessage(actId);
            auditTrail.setTimestamp(new Date());

            ApplicationContext appContext = WorkflowUtil.getApplicationContext();
            PluginManager pluginManager = (PluginManager) appContext.getBean("pluginManager");
            AuditTrailPluginDao auditTrailPluginDao = (AuditTrailPluginDao) appContext.getBean("auditTrailPluginDao");
            Collection<Plugin> pluginList = pluginManager.list();

            for(Plugin plugin : pluginList){
                if(plugin instanceof AuditTrailPlugin){
                    AuditTrailPlugin p = (AuditTrailPlugin) plugin;
                    try {
                        Map properties = new HashMap();

                        AuditTrailPluginConfiguration config = auditTrailPluginDao.find(plugin.getClass().getName());
                        if(config != null){
                            Map temp = CsvUtil.getPluginPropertyMap(config.getPluginProperties());
                            properties.putAll(temp);
                        }

                        properties.put("auditTrail", auditTrail);
                        properties.put("pluginManager", pluginManager);
                        properties.put("processStartedTime", context.get(SharkConstants.PROCESS_STARTED_TIME));
                        properties.put("activityAcceptedTime", context.get(SharkConstants.ACTIVITY_ACCEPTED_TIME));
                        properties.put("activityActivatedTime", context.get(SharkConstants.ACTIVITY_ACTIVATED_TIME));

                        WorkflowDeadline workflowDeadline = new WorkflowDeadline();
                        workflowDeadline.setDeadlineExpression(expr);
                        properties.put("workflowDeadline", workflowDeadline);

                        Object result = p.execute(properties);
                        if(result != null && result instanceof WorkflowDeadline){
                            WorkflowDeadline newDeadline = (WorkflowDeadline) result;
                            expr = newDeadline.getDeadlineExpression();
                        }
                    }
                    catch(Exception e) {
                        LogUtil.error(getClass().getName(), e, "Error executing plugin " + p.getClass().getName());
                    }
                }
            }
        }

        org.mozilla.javascript.Context cx = org.mozilla.javascript.Context.enter();
        Scriptable scope = cx.initStandardObjects(null);

        java.lang.Object eval;
        try {
            prepareContext(scope, context, procId, actId);
            // System.err.println("Evaluating javascript expression:" + expr);
            if (resultClass != null) {
                eval = org.mozilla.javascript.Context.toType(cx.evaluateString(scope,
                        expr,
                        "",
                        1,
                        null),
                        resultClass);
            } else {
                eval = cx.evaluateString(scope, expr, "", 1, null);
            }

            cus.debug(shandle, LOG_CHANNEL, "JavaScriptEvaluator -> Javascript expression "
                    + expr + " is evaluated to " + eval);
            // System.err.println("Evaluated to -- " + eval);
            return eval;

        } catch (Throwable ex) {
            cus.error(shandle, LOG_CHANNEL, "JavaScriptEvaluator -> The result of expression "
                    + expr + " can't be evaluated - error message="
                    + ex.getMessage());
            cus.error(shandle, "JavaScriptEvaluator -> The result of expression "
                    + expr + " can't be evaluated - error message=" + ex.getMessage());
            if (ex instanceof Exception) {
                throw (Exception) ex;
            }
            throw new RootException("Result cannot be evaluated", ex);
        } finally {
            org.mozilla.javascript.Context.exit();
        }
    }

    private void prepareContext(Scriptable scope, Map context, String procId, String actId)
            throws Exception {
        Iterator iter = context.entrySet().iterator();
        while (iter.hasNext()) {
            Map.Entry me = (Map.Entry) iter.next();
            String key = me.getKey().toString();
            java.lang.Object value = me.getValue();
            // System.err.println("Value for key "+key+" is "+value+", class is
            // "+value.getClass().getName());
            scope.put(key, scope, value);
        }
        if (procId != null) {
            scope.put(SharkConstants.PROC_KEY, scope, procId);
        }
        if (actId != null) {
            scope.put(SharkConstants.ACT_KEY, scope, actId);
        }
    }
}
