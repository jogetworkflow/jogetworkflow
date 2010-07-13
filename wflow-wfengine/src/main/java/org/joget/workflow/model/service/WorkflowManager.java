package org.joget.workflow.model.service;

import org.joget.form.model.dao.FormDao;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.WorkflowApplication;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowParticipant;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.WorkflowVariable;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.dao.ActivityPluginDao;
import org.joget.workflow.model.dao.ParticipantDirectoryDao;
import java.util.Collection;
import java.util.Date;
import java.util.List;
import java.util.Map;
import org.joget.workflow.model.ParticipantDirectory;
import org.joget.workflow.model.WorkflowPackage;
import org.joget.workflow.model.WorkflowProcessLink;
import org.joget.workflow.model.WorkflowProcessResult;
import org.joget.workflow.model.WorkflowReport;

public interface WorkflowManager {
    public static String LATEST = "latest";

    void activityVariable(String activityInstanceId, String variableId, Object variableValue);

    void processVariable(String processInstanceId, String variableId, Object variableValue);

    String getProcessVariable(String processInstanceId, String variableId);

    void assignmentAccept(String activityId);

    void assignmentComplete(String activityId);

    void activityAbort(String processId, String activityDefId);

    boolean activityStart(String processId, String activityDefId, boolean abortRunningActivities);

    void assignmentVariable(String activityId, String variableName, String variableValue);

    void assignmentWithdraw(String activityId);

    void assignmentReassign(String processDefId, String processId, String activityId, String username);

    void assignmentForceComplete(String processDefId, String processId, String activityId, String username);

    WorkflowActivity getActivityById(String activityId);

    ActivityFormDao getActivityFormDao();

    Collection<WorkflowActivity> getActivityList(String processId, Integer start, Integer rows, String sort, Boolean desc);

    ActivityPluginDao getActivityPluginDao();

    int getActivitySize(String processId);

    Collection<WorkflowVariable> getActivityVariableList(String activityId);

    Collection<WorkflowVariable> getProcessVariableList(String processId);

    Boolean isAssignmentExist(String activityId);

    WorkflowAssignment getAssignment(String activityId);

    WorkflowAssignment getMockAssignment(String activityId);

    WorkflowAssignment getAssignmentByProcess(String processId);

    Collection<WorkflowAssignment> getAssignmentList(Boolean accepted, String processDefId, String sort, Boolean desc, Integer start, Integer rows);

    Collection<WorkflowAssignment> getAssignmentList(String packageId, String processDefId, String processId, String sort, Boolean desc, Integer start, Integer rows);

    Collection<WorkflowAssignment> getAssignmentListFilterByProccessDefIds(String[] processDefIds, String sort, Boolean desc, Integer start, Integer rows);

    int getAssignmentSize(Boolean accepted, String processDefId);

    int getAssignmentSize(String packageId, String processDefId, String processId);

    int getAssignmentListFilterByProccessDefIdsSize(String[] processDefIds);

    Map getActivityInstanceByProcessIdAndStatus(String processId, Boolean accepted);

    Collection<WorkflowVariable> getAssignmentVariableList(String activityId);

    String getUserByProcessIdAndActivityDefId(String processDefId, String processId, String activityDefId);

    FormDao getFormDao();

    Boolean isPackageIdExist(String packageId);

    Collection<WorkflowPackage> getPackageList();

    String getCurrentPackageVersion(String packageId);

    byte[] getPackageContent(String packageId, String version);

    ParticipantDirectoryDao getParticipantDirectoryDao();

    Map<String, WorkflowParticipant> getParticipantMap(String processDefId);

    WorkflowProcess getProcess(String processDefId);

    WorkflowActivity getProcessActivityDefinition(String processDefId, String activityDefId);

    Collection<WorkflowActivity> getProcessActivityDefinitionList(String processDefId);

    Collection<WorkflowApplication> getProcessApplicationDefinitionList(String processDefId);

    String getProcessDefIdByInstanceId(String instanceId);

    Collection<WorkflowProcess> getProcessList(String packageId);

    Collection<WorkflowParticipant> getProcessParticipantDefinitionList(String processDefId);

//    Collection<String> getProcessRunningActivityIdList();

    Collection<WorkflowVariable> getProcessVariableDefinitionList(String processDefId);

    WorkflowProcess getRunningProcessById(String processId);

    Collection<WorkflowProcess> getRunningProcessList(String packageId, String processId, String processName, String version, String sort, Boolean desc, Integer start, Integer rows);

    Collection<WorkflowProcess> getCompletedProcessList(String packageId, String processId, String processName, String version, String sort, Boolean desc, Integer start, Integer rows);

    int getRunningProcessSize(String packageId, String processId, String processName, String version);

    int getCompletedProcessSize(String packageId, String processId, String processName, String version);

    WorkflowUserManager getWorkflowUserManager();

    void processDeleteAndUnloadVersion(String packageId, String version);

    void processDeleteAndUnload(String packageId);

    String processCreateWithoutStart(String processDefId);

    WorkflowProcessResult processStart(String processDefId);

    WorkflowProcessResult processStart(String processDefId, Map<String, String> variables);

    WorkflowProcessResult processStart(String processDefId, Map<String, String> variables, String startProcUsername);

    WorkflowProcessResult processStart(String processDefId, String processId, Map<String, String> variables, String startProcUsername, String parentProcessId, boolean startManually);

    WorkflowProcessResult processStartWithInstanceId(String processDefId, String processId, Map<String, String> variables);

    WorkflowProcessResult processStartWithLinking(String processDefId, Map<String, String> variables, String startProcUsername, String parentProcessId);

    WorkflowProcessResult processCopyFromInstanceId(String currentProcessId, String newProcessDefId, boolean abortCurrentProcess);

    Collection<ParticipantDirectory> getNextParticipantInATool(String activityId);

    boolean processAbort(String processId);

    String processUploadWithoutUpdateMapping(String packageId, byte[] processDefinitionData) throws Exception;

    String processUpload(String packageId, byte[] processDefinitionData) throws Exception;

    void reevaluateAssignmentsForActivity(String activityInstanceId);

    void reevaluateAssignmentsForProcess(String procInstanceId);

    void reevaluateAssignmentsForProcesses(String[] procInstanceId);

    void reevaluateAssignmentsForUser(String username);

    void removeProcessInstance(String procInstanceId);

    void internalRemoveProcessOnComplete(String procInstanceId);

    double getServiceLevelMonitorForRunningActivity(String activityInstanceId);

    double getServiceLevelMonitorForRunningProcess(String processInstanceId);

    void setActivityFormDao(ActivityFormDao activityFormDao);

    void setActivityPluginDao(ActivityPluginDao activityPluginDao);

    void setFormDao(FormDao formDao);

    void setParticipantDirectoryDao(ParticipantDirectoryDao participantDirectoryDao);

    void setPath(String path);

    void setWorkflowUserManager(WorkflowUserManager userManager);

    WorkflowActivity getRunningActivityInfo(String activityInstanceId);

    Date getDueDateForRunningActivity(String activityInstanceId);

    Date getDueDateForRunningProcess(String processInstanceId);

    WorkflowProcess getRunningProcessInfo(String processInstanceId);

    List<String> getAssignmentResourceIds(String processId, String processInstanceId, String activityInstanceId);

    void internalCheckDeadlines(int instancesPerTransaction, int failuresToIgnore);

    void internalUpdateDeadlineChecker();

    Collection<WorkflowReport> getWorkflowSLA(String processDefinitionId);

    Collection<WorkflowProcess> getWorkflowSLAProcessDefinitions();

    Collection<WorkflowActivity> getAssignmentHistory(String packageId, String processId, String processName, String activityName, String sort, Boolean desc, Integer start, Integer rows);

    int getAssignmentHistorySize(String packageId, String processId, String processName, String activityName);

    Collection<WorkflowActivity> getRunningActivityList(String processId, String sort, Boolean desc, Integer start, Integer rows);

    int getRunningActivitySize(String processId);

    WorkflowProcessLink getWorkflowProcessLink(String processId);

    void internalAddWorkflowProcessLink(WorkflowProcessLink wfProcessLink);

    void internalDeleteWorkflowProcessLink(WorkflowProcessLink wfProcessLink);

    boolean isActivityContinueNextAssignment(String processDefId, String activityDefId);

    Boolean isUserInWhiteList(String processDefId);

    String getConvertedLatestProcessDefId(String processDefId);
}
