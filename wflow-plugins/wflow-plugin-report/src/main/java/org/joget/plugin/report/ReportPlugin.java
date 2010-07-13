package org.joget.plugin.report;

import java.util.ArrayList;
import java.util.List;
import org.joget.plugin.base.AuditTrailPlugin;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginManager;
import org.joget.plugin.base.PluginProperty;
import org.joget.workflow.model.AuditTrail;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowPackage;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.service.WorkflowManager;
import org.joget.workflow.model.service.WorkflowReportManager;
import org.joget.workflow.model.WorkflowReport;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Map;
import org.joget.commons.util.LogUtil;

public class ReportPlugin extends DefaultPlugin implements AuditTrailPlugin {

    public String getName() {
        return "Report Plugin";
    }

    public String getDescription() {
        return "Saves process data into wf_report* tables for reporting purposes";
    }

    public String getVersion() {
        return "1.0.12";
    }

    public PluginProperty[] getPluginProperties() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Object execute(Map properties) {
        Object result = null;
        try {
            final AuditTrail auditTrail = (AuditTrail) properties.get("auditTrail");
            final PluginManager pluginManager = (PluginManager) properties.get("pluginManager");
            final WorkflowManager workflowManager = (WorkflowManager) pluginManager.getBean("workflowManager");
            final WorkflowReportManager workflowReportManager = (WorkflowReportManager) pluginManager.getBean("workflowReportManager");

            if (validation(auditTrail)) {
                new Thread(new Runnable() {

                    public void run() {
                        String activityInstanceId = auditTrail.getMessage();
                        WorkflowActivity wfTrackActivity = workflowManager.getRunningActivityInfo(activityInstanceId);
                        //get workflow activity
                        WorkflowActivity wfActivity = workflowManager.getActivityById(activityInstanceId);

                        String processInstanceId = wfActivity.getProcessId();
                        String processDefId = workflowManager.getProcessDefIdByInstanceId(processInstanceId);

                        //get workflow process
                        WorkflowProcess wfProcess = (processDefId != null ? workflowManager.getProcess(processDefId) : null);
                        if (wfProcess != null) {
                            List<String> userList = new ArrayList<String>();
                            try {
                                Thread.sleep(2000);
                                int maxAttempt = 5;
                                int numOfAttempt = 0;
                                while (userList.size() == 0 && numOfAttempt < maxAttempt) {
                                    LogUtil.debug(getClass().getName(), "Attempting to get resource ids....");
                                    userList = workflowManager.getAssignmentResourceIds(wfActivity.getProcessDefId(), wfActivity.getProcessId(), activityInstanceId);
                                    Thread.sleep(2000);
                                    numOfAttempt++;
                                }

                                LogUtil.debug(getClass().getName(), "Resource ids=" + userList);
                            } catch (Exception e) {
                                Logger.getLogger(getClass().getName()).log(Level.WARNING, "Error executing report plugin", e);
                            }

                            //get assignment users
                            String assignmentUsers = "";
                            for (String username : userList) {
                                assignmentUsers += username + ",";
                            }
                            if (assignmentUsers.endsWith(",")) {
                                assignmentUsers = assignmentUsers.substring(0, assignmentUsers.length() - 1);
                            }

                            //set workflow package
                            WorkflowPackage wfPackage = new WorkflowPackage();
                            wfPackage.setPackageId(wfProcess.getPackageId());
                            wfPackage.setPackageName(wfProcess.getPackageName());

                            WorkflowReport updateWorkflowReport = workflowReportManager.getWorkflowProcessByActivityInstanceId(activityInstanceId);

                            if (updateWorkflowReport != null) {
                                //update workflow activity
                                workflowReportManager.updateWorkflowActivity(wfActivity);
                                //update workflow process
                                workflowReportManager.updateWorkflowProcess(wfProcess);
                                //update workflow package
                                workflowReportManager.updateWorkflowPackage(wfPackage);

                                //set workflow report
                                updateWorkflowReport.setActivityInstanceId(wfActivity.getId());
                                updateWorkflowReport.setWfPackage(wfPackage);
                                updateWorkflowReport.setWfProcess(wfProcess);
                                updateWorkflowReport.setWfActivity(wfActivity);
                                updateWorkflowReport.setProcessInstanceId(processInstanceId);
                                updateWorkflowReport.setPriority(wfTrackActivity.getPriority());
                                updateWorkflowReport.setCreatedTime(wfTrackActivity.getCreatedTime());
                                updateWorkflowReport.setStartedTime(wfTrackActivity.getStartedTime());
                                updateWorkflowReport.setLimit(wfTrackActivity.getLimitInSeconds());
                                updateWorkflowReport.setDue(wfTrackActivity.getDue());
                                updateWorkflowReport.setDelay(wfTrackActivity.getDelayInSeconds());
                                updateWorkflowReport.setFinishTime(wfTrackActivity.getFinishTime());
                                updateWorkflowReport.setTimeConsumingFromDateCreated(wfTrackActivity.getTimeConsumingFromDateCreatedInSeconds());
                                updateWorkflowReport.setTimeConsumingFromDateStarted(wfTrackActivity.getTimeConsumingFromDateStartedInSeconds());
                                updateWorkflowReport.setPerformer(wfTrackActivity.getPerformer());
                                updateWorkflowReport.setNameOfAcceptedUser(wfTrackActivity.getNameOfAcceptedUser());
                                //updateWorkflowReport.setAssignmentUsers(assignmentUsers);
                                updateWorkflowReport.setStatus(wfTrackActivity.getStatus());
                                updateWorkflowReport.setState(wfActivity.getState());

                                //update workflow report
                                workflowReportManager.updateWorkflowReport(updateWorkflowReport);
                            } else {
                                //Add or update workflow activity
                                wfActivity.setPriority(wfTrackActivity.getPriority());
                                workflowReportManager.updateWorkflowActivity(wfActivity);

                                //Add or update workflow process
                                workflowReportManager.updateWorkflowProcess(wfProcess);

                                //Add or update workflow package
                                workflowReportManager.updateWorkflowPackage(wfPackage);

                                //Add workflow report
                                WorkflowReport workflowReport = new WorkflowReport();
                                workflowReport.setActivityInstanceId(wfActivity.getId());
                                workflowReport.setWfPackage(wfPackage);
                                workflowReport.setWfProcess(wfProcess);
                                workflowReport.setWfActivity(wfActivity);
                                workflowReport.setProcessInstanceId(processInstanceId);
                                workflowReport.setPriority(wfTrackActivity.getPriority());
                                workflowReport.setCreatedTime(wfTrackActivity.getCreatedTime());
                                workflowReport.setStartedTime(wfTrackActivity.getStartedTime());
                                workflowReport.setLimit(wfTrackActivity.getLimitInSeconds());
                                workflowReport.setDue(wfTrackActivity.getDue());
                                workflowReport.setDelay(wfTrackActivity.getDelayInSeconds());
                                workflowReport.setFinishTime(wfTrackActivity.getFinishTime());
                                workflowReport.setTimeConsumingFromDateCreated(wfTrackActivity.getTimeConsumingFromDateCreatedInSeconds());
                                workflowReport.setTimeConsumingFromDateStarted(wfTrackActivity.getTimeConsumingFromDateStartedInSeconds());
                                workflowReport.setPerformer(wfTrackActivity.getPerformer());
                                workflowReport.setNameOfAcceptedUser(wfTrackActivity.getNameOfAcceptedUser());
                                workflowReport.setAssignmentUsers(assignmentUsers);
                                workflowReport.setStatus(wfTrackActivity.getStatus());
                                workflowReport.setState(wfActivity.getState());
                                //add workflow report
                                workflowReportManager.addWorkflowReport(workflowReport);
                            }
                        }
                    }
                }).start();
            }
            return result;
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.WARNING, "Error executing report plugin", e);
            return null;
        }
    }

    public boolean validation(AuditTrail auditTrail){
        return auditTrail.getMethod().equals("getDefaultAssignments")
               || auditTrail.getMethod().equals("processAbort")
               || auditTrail.getMethod().equals("assignmentAccept")
               || auditTrail.getMethod().equals("assignmentComplete")
               || auditTrail.getMethod().equals("assignmentForceComplete");
    }
}
