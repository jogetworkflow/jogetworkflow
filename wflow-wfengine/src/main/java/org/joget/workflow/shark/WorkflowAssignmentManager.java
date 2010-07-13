package org.joget.workflow.shark;

import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.service.AuditTrailManager;
import org.joget.workflow.model.service.WorkflowManager;
import org.joget.workflow.util.WorkflowUtil;
import java.util.List;
import java.util.Set;

import org.enhydra.shark.api.client.wfmc.wapi.WMSessionHandle;
import org.enhydra.shark.api.internal.assignment.PerformerData;
import org.enhydra.shark.assignment.HistoryRelatedAssignmentManager;
import org.joget.form.model.FormMetaData;
import org.joget.form.model.service.FormManager;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowProcessLink;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.springframework.context.ApplicationContext;

public class WorkflowAssignmentManager extends HistoryRelatedAssignmentManager {

    private WorkflowManager workflowManager;
    private FormManager formManager;
    private ActivityFormDao activityFormDao;

    @Override
    public List<String> getDefaultAssignments(WMSessionHandle shandle, String instanceId,
            String actId, String processRequesterId,
            PerformerData xpdlParticipant, List xpdlResponsibleParticipants)
            throws Exception {
        
        //initialization
        ApplicationContext appContext = WorkflowUtil.getApplicationContext();
        workflowManager = (WorkflowManager) appContext.getBean("workflowManager");
        formManager = (FormManager) appContext.getBean("formManager");
        activityFormDao = (ActivityFormDao) appContext.getBean("activityFormDao");

        String procDefId = workflowManager.getProcessDefIdByInstanceId(instanceId);
        WorkflowProcess process = workflowManager.getProcess(procDefId);
        WorkflowActivity activity = workflowManager.getActivityById(actId);
        String currentUsername = (String) shandle.getVendorData();

        if(currentUsername.equals(WorkflowUserManager.ROLE_ANONYMOUS)) {
            currentUsername = processRequesterId;
        }

        String[] temp = procDefId.split("#");
        String version = temp[1];
        List<String> resultList = WorkflowUtil.getAssignmentUsers(process.getPackageId(), procDefId, instanceId, version, actId, currentUsername, xpdlParticipant.participantIdOrExpression);

        if (resultList == null || resultList.size() == 0) {
            resultList = super.getDefaultAssignments(shandle, procDefId, actId, currentUsername, xpdlParticipant, xpdlResponsibleParticipants);
        }
        LogUtil.info(getClass().getName(), "[processId=" + instanceId + ", processDefId=" + procDefId + ", participantId=" + xpdlParticipant.participantIdOrExpression + ", next user=" + resultList + "]");

        //write to audit trail
        AuditTrailManager auditTrailManager = (AuditTrailManager) appContext.getBean("auditTrailManager");
        auditTrailManager.addAuditTrail(this.getClass().getName(), "getDefaultAssignments", actId);

        //create new form metadata row
        String tableName = WorkflowUtil.getActivityFormTableName(procDefId, Integer.parseInt(version), activity.getActivityDefId());
        if(tableName != null){
            WorkflowProcessLink wfProcessLink = workflowManager.getWorkflowProcessLink(instanceId);

            if (wfProcessLink != null) {
                instanceId = wfProcessLink.getOriginProcessId();
            }
            FormMetaData formMetaData = formManager.loadDynamicFormMetaDataByActivityId(tableName, actId);

            if(formMetaData != null){
                formMetaData.setParticipantId(xpdlParticipant.participantIdOrExpression);
                String pendingUsers = "";
                if (resultList != null && resultList.size() > 0) {
                    pendingUsers = ",";

                    for(String username : resultList){
                        pendingUsers += username + ",";
                    }
                }

                formMetaData.setPendingUsers(pendingUsers);
                formManager.updateDynamicFormMetaData(tableName, formMetaData);
            }else{
                formManager.createDynamicFormMetaData(tableName, instanceId, actId, activity.getActivityDefId(), xpdlParticipant.participantIdOrExpression, resultList);
            }
        }

        return resultList;
    }

    @Override
    protected Set findResources(WMSessionHandle shandle, PerformerData p) throws Exception {
        return super.findResources(shandle, p);
    }
}
