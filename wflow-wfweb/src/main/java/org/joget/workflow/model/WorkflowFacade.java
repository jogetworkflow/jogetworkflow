package org.joget.workflow.model;

import org.joget.workflow.model.service.WorkflowManager;
import org.joget.commons.util.PagedList;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.dao.ActivityPluginDao;
import org.joget.workflow.model.dao.ParticipantDirectoryDao;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.joget.workflow.util.WorkflowUtil;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.joget.directory.model.Group;
import org.joget.directory.model.User;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.form.model.Form;
import org.joget.form.model.FormMetaData;
import org.joget.form.model.service.FormManager;
import org.joget.workflow.model.dao.ActivitySetupDao;
import org.joget.workflow.model.service.UserviewProcessManager;
import org.springframework.beans.factory.annotation.Autowired;

public class WorkflowFacade {

    private WorkflowManager workflowManager;

    @Autowired
    private ActivityPluginDao activityPluginDao;

    @Autowired
    private ActivityFormDao activityFormDao;

    @Autowired
    private ParticipantDirectoryDao participantDirectoryDao;

    @Autowired
    private WorkflowUserManager workflowUserManager;

    @Autowired
    private DirectoryManager directoryManager;

    @Autowired
    private FormManager formManager;

    @Autowired
    private UserviewProcessManager userviewProcessManager;

    @Autowired
    private ActivitySetupDao activitySetupDao;

    public ActivitySetupDao getActivitySetupDao() {
        return activitySetupDao;
    }

    public void setActivitySetupDao(ActivitySetupDao activitySetupDao) {
        this.activitySetupDao = activitySetupDao;
    }

    public DirectoryManager getDirectoryManager() {
        return directoryManager;
    }

    public void setDirectoryManager(DirectoryManager directoryManager) {
        this.directoryManager = directoryManager;
    }

    public FormManager getFormManager() {
        return formManager;
    }

    public void setFormManager(FormManager formManager) {
        this.formManager = formManager;
    }

    public WorkflowManager getWorkflowManager() {
        return workflowManager;
    }

    public void setWorkflowManager(WorkflowManager workflowManager) {
        this.workflowManager = workflowManager;
    }

    public WorkflowUserManager getWorkflowUserManager() {
        return workflowUserManager;
    }

    public void setWorkflowUserManager(WorkflowUserManager workflowUserManager) {
        this.workflowUserManager = workflowUserManager;
    }

    public ActivityPluginDao getActivityPluginDao() {
        return activityPluginDao;
    }

    public void setActivityPluginDao(ActivityPluginDao activityPluginDao) {
        this.activityPluginDao = activityPluginDao;
    }

    public ActivityFormDao getActivityFormDao() {
        return activityFormDao;
    }

    public void setActivityFormDao(ActivityFormDao activityFormDao) {
        this.activityFormDao = activityFormDao;
    }

    public ParticipantDirectoryDao getParticipantDirectoryDao() {
        return participantDirectoryDao;
    }

    public void setParticipantDirectoryDao(ParticipantDirectoryDao participantDirectoryDao) {
        this.participantDirectoryDao = participantDirectoryDao;
    }

    public UserviewProcessManager getUserviewProcessManager() {
        return userviewProcessManager;
    }

    public void setUserviewProcessManager(UserviewProcessManager userviewProcessManager) {
        this.userviewProcessManager = userviewProcessManager;
    }

    public Boolean isPackageIdExist(String packageId) {
        return workflowManager.isPackageIdExist(packageId);
    }

    public Collection<WorkflowPackage> getPackageList() {
        Collection<WorkflowPackage> packageList = workflowManager.getPackageList();
        return packageList;
    }

    public PagedList<WorkflowProcess> getProcessList(String sort, Boolean desc, Integer start, Integer rows, String packageId, Boolean all, Boolean checkWhiteList) {
        List<WorkflowProcess> processList = (List<WorkflowProcess>) workflowManager.getProcessList("");
        // filter by packageId and versions
        boolean filterByPackage = packageId != null && packageId.trim().length() > 0;
        boolean latestVersion = all == null || !all;


        if (filterByPackage || latestVersion || (checkWhiteList != null && checkWhiteList)) {
            for (Iterator<WorkflowProcess> i = processList.iterator(); i.hasNext();) {
                WorkflowProcess proc = i.next();
                if (latestVersion && !proc.isLatest()) {
                    i.remove();
                } else if (filterByPackage && !packageId.equals(proc.getPackageId())) {
                    i.remove();
                } else {
                    if (checkWhiteList != null && checkWhiteList) {
                        if (!isUserInWhiteList(proc.getId())) {
                            i.remove();
                        }
                    }
                }
            }
        }

        // set total
        Integer total = new Integer(processList.size());

        // perform sorting and paging
        PagedList<WorkflowProcess> pagedList = new PagedList<WorkflowProcess>(true, processList, sort, desc, start, rows, total);

        return pagedList;
    }

    public int getRunningProcessSize(String packageId, String processId, String processName, String version) {
        return workflowManager.getRunningProcessSize(packageId, processId, processName, version);
    }

    public int getCompletedProcessSize(String packageId, String processId, String processName, String version) {
        return workflowManager.getCompletedProcessSize(packageId, processId, processName, version);
    }

    public Collection<WorkflowProcess> getRunningProcessList(String packageId, String processId, String processName, String version, String sort, Boolean desc, Integer start, Integer rows) {
        return workflowManager.getRunningProcessList(packageId, processId, processName, version, sort, desc, start, rows);
    }

    public Collection<WorkflowProcess> getCompletedProcessList(String packageId, String processId, String processName, String version, String sort, Boolean desc, Integer start, Integer rows) {
        return workflowManager.getCompletedProcessList(packageId, processId, processName, version, sort, desc, start, rows);
    }

    public WorkflowProcess getRunningProcessById(String processId) {
        return workflowManager.getRunningProcessById(processId);
    }

    public Collection<WorkflowActivity> getProcessActivityDefinitionList(String processDefId) {
        return workflowManager.getProcessActivityDefinitionList(processDefId);
    }

    public Collection<WorkflowVariable> getProcessVariableDefinitionList(String processId) {
        return workflowManager.getProcessVariableDefinitionList(processId);
    }

    public WorkflowActivity getActivityById(String activityId) {
        return workflowManager.getActivityById(activityId);
    }

    public WorkflowActivity getActivityById(String processDefId, String activityId) {
        Collection<WorkflowActivity> activityList = getProcessActivityDefinitionList(processDefId);

        for (WorkflowActivity activity : activityList) {
            if (activityId.equals(activity.getId())) {
                return activity;
            }
        }

        return null;
    }

    public int getActivitySize(String processId) {
        return workflowManager.getActivitySize(processId);
    }

    public List<WorkflowActivity> getActivityList(String sort, Boolean desc, Integer start, Integer rows, String processId) {
        return (List<WorkflowActivity>) workflowManager.getActivityList(processId, start, rows, sort, desc);
    }

    public Collection<WorkflowVariable> getActivityVariableList(String activityId) {
        return workflowManager.getActivityVariableList(activityId);
    }

    public Collection<WorkflowVariable> getProcessVariableList(String processId) {
        return workflowManager.getProcessVariableList(processId);
    }

    public WorkflowProcess getProcess(String processId) {
        WorkflowProcess process = workflowManager.getProcess(processId);
        return process;
    }

    public void activityVariable(String activityInstanceId, String variableId, String variableValue) {
        workflowManager.activityVariable(activityInstanceId, variableId, variableValue);
    }

    public void activityAbort(String processId, String activityDefId) {
        workflowManager.activityAbort(processId, activityDefId);
    }

    public boolean activityStart(String processInstanceId, String activityDefId, boolean abortRunningActivities) {
        return workflowManager.activityStart(processInstanceId, activityDefId, abortRunningActivities);
    }

    public void processVariable(String processInstanceId, String variableId, Object variableValue) {
        workflowManager.processVariable(processInstanceId, variableId, variableValue);
    }

    public String getProcessVariable(String processInstanceId, String variableId) {
        return workflowManager.getProcessVariable(processInstanceId, variableId);
    }

    public void reevaluateAssignmentsForActivity(String activityInstanceId) {
        workflowManager.reevaluateAssignmentsForActivity(activityInstanceId);
    }

    public void removeProcessInstance(String processInstanceId) {
        workflowManager.removeProcessInstance(processInstanceId);
    }

    public void processDeleteAndUnloadVersion(String packageId, String version) {

        Integer versionInt = Integer.parseInt(version);

        workflowManager.processDeleteAndUnloadVersion(packageId, version);

        //find and remove all activity forms by package id
        Collection<ActivityForm> activityForms = getActivityFormDao().getActivityFormByPackageId(packageId, versionInt);
        for (ActivityForm activityForm : activityForms) {
            getActivityFormDao().delete(activityForm);
        }

        //find and remove all activity plugins by package id
        Collection<ActivityPlugin> activityPlugins = getActivityPluginDao().getActivityPluginByPackageId(packageId, versionInt);
        for (ActivityPlugin activityPlugin : activityPlugins) {
            getActivityPluginDao().delete(activityPlugin);
        }

        //find and remove all participant directory by package id
        Collection<ParticipantDirectory> participantDirectories = getParticipantDirectoryDao().getParticipantDirectoryByPackageId(packageId, versionInt);
        for (ParticipantDirectory participantDirectory : participantDirectories) {
            getParticipantDirectoryDao().delete(participantDirectory);
        }

    }

    public void processDeleteAndUnload(String packageId) {
        workflowManager.processDeleteAndUnload(packageId);

        //find and remove all activity forms by package id
        Collection<ActivityForm> activityForms = getActivityFormDao().getActivityFormByPackageId(packageId);
        for (ActivityForm activityForm : activityForms) {
            getActivityFormDao().delete(activityForm);
        }

        //find and remove all activity plugins by package id
        Collection<ActivityPlugin> activityPlugins = getActivityPluginDao().getActivityPluginByPackageId(packageId);
        for (ActivityPlugin activityPlugin : activityPlugins) {
            getActivityPluginDao().delete(activityPlugin);
        }

        //find and remove all participant directory by package id
        Collection<ParticipantDirectory> participantDirectories = getParticipantDirectoryDao().getParticipantDirectoryByPackageId(packageId);
        for (ParticipantDirectory participantDirectory : participantDirectories) {
            getParticipantDirectoryDao().delete(participantDirectory);
        }

    }

    public void reevaluateAssignmentsForProcess(String processInstanceId) {
        workflowManager.reevaluateAssignmentsForProcess(processInstanceId);
    }

    public void reevaluateAssignmentsForUser(String username) {
        workflowManager.reevaluateAssignmentsForUser(username);
    }

    public double getServiceLevelMonitorForRunningActivity(String activityInstanceId) {
        return workflowManager.getServiceLevelMonitorForRunningActivity(activityInstanceId);
    }

    public WorkflowActivity getRunningActivityInfo(String activityInstanceId) {
        return workflowManager.getRunningActivityInfo(activityInstanceId);
    }

    public Date getDueDateForRunningActivity(String activityInstanceId) {
        return workflowManager.getDueDateForRunningActivity(activityInstanceId);
    }

    public Date getDueDateForRunningProcess(String processInstanceId) {
        return workflowManager.getDueDateForRunningProcess(processInstanceId);
    }

    public double getServiceLevelMonitorForRunningProcess(String processInstanceId) {
        return workflowManager.getServiceLevelMonitorForRunningProcess(processInstanceId);
    }

    public WorkflowProcess getRunningProcessInfo(String processInstanceId) {
        return workflowManager.getRunningProcessInfo(processInstanceId);
    }

    public WorkflowProcessResult processStart(String processDefId) {
        return processStart(processDefId, null);
    }

    public WorkflowProcessResult processStart(String processDefId, Map<String, String> variables) {
        WorkflowProcessResult result = workflowManager.processStart(processDefId, variables);
        return result;
    }

    public boolean processAbort(String processId) {
        return workflowManager.processAbort(processId);
    }

    public String processUpload(String packageId, byte[] data) throws Exception {
        return workflowManager.processUpload(packageId, data);
    }

    public String createProcessInstance(String processId){
        return workflowManager.processCreateWithoutStart(processId);
    }

    public WorkflowProcessResult processStartWithInstanceId(String processDefId, String processId, Map<String, String> variables){
        return workflowManager.processStartWithInstanceId(processDefId, processId, variables);
    }

    public WorkflowProcessResult processStartWithLinking(String processDefId, String parentProcessId, Map<String, String> variables){
        return workflowManager.processStartWithLinking(processDefId, variables, null, parentProcessId);
    }

    public WorkflowProcessResult processCopyFromInstanceId(String currentProcessId, String newProcessDefId, boolean abortCurrentProcess) {
        return workflowManager.processCopyFromInstanceId(currentProcessId, newProcessDefId, abortCurrentProcess);
    }

    public Boolean isAssignmentExist(String activityId) {
        return workflowManager.isAssignmentExist(activityId);
    }

    public WorkflowAssignment getAssignment(String activityId) {
        WorkflowAssignment assignment = workflowManager.getAssignment(activityId);
        return assignment;
    }

    public WorkflowAssignment getAssignmentByProcess(String processId) {
        WorkflowAssignment assignment = workflowManager.getAssignmentByProcess(processId);
        return assignment;
    }

    public PagedList<WorkflowAssignment> getAssignmentPendingAndAcceptedList(String packageId, String processDefId, String processId, String sort, Boolean desc, Integer start, Integer rows) {
        List<WorkflowAssignment> assignmentList = (List<WorkflowAssignment>) workflowManager.getAssignmentList(packageId, processDefId, processId, sort, desc, start, rows);

        // set total
        Integer total = new Integer(workflowManager.getAssignmentSize(packageId, processDefId, processId));

        // perform sorting and paging
        PagedList<WorkflowAssignment> pagedList = new PagedList<WorkflowAssignment>(assignmentList, sort, desc, start, rows, total);

        return pagedList;
    }

    public PagedList<WorkflowAssignment> getAssignmentPendingAndAcceptedListByProcess(String[] processDefIds, String sort, Boolean desc, Integer start, Integer rows) {
        List<WorkflowAssignment> assignmentList = (List<WorkflowAssignment>) workflowManager.getAssignmentListFilterByProccessDefIds(processDefIds, sort, desc, start, rows);

        // set total
        Integer total = new Integer(workflowManager.getAssignmentListFilterByProccessDefIdsSize(processDefIds));

        // perform sorting and paging
        PagedList<WorkflowAssignment> pagedList = new PagedList<WorkflowAssignment>(assignmentList, sort, desc, start, rows, total);

        return pagedList;
    }

    public PagedList<WorkflowAssignment> getAssignmentPendingList(String processDefId, String sort, Boolean desc, Integer start, Integer rows) {
        List<WorkflowAssignment> assignmentList = (List<WorkflowAssignment>) workflowManager.getAssignmentList(Boolean.FALSE, processDefId, sort, desc, start, rows);

        // set total
        Integer total = new Integer(workflowManager.getAssignmentSize(Boolean.FALSE, processDefId));

        // perform sorting and paging
        PagedList<WorkflowAssignment> pagedList = new PagedList<WorkflowAssignment>(assignmentList, sort, desc, start, rows, total);

        return pagedList;
    }

    public PagedList<WorkflowAssignment> getAssignmentAcceptedList(String processDefId, String sort, Boolean desc, Integer start, Integer rows) {
        List<WorkflowAssignment> assignmentList = (List<WorkflowAssignment>) workflowManager.getAssignmentList(Boolean.TRUE, processDefId, sort, desc, start, rows);

        // set total
        Integer total = new Integer(workflowManager.getAssignmentSize(Boolean.TRUE, processDefId));

        // perform sorting and paging
        PagedList<WorkflowAssignment> pagedList = new PagedList<WorkflowAssignment>(assignmentList, sort, desc, start, rows, total);

        return pagedList;
    }

    public int getAssignmentSize(String packageId, String processDefId, String processId) {
        int size = workflowManager.getAssignmentSize(packageId, processDefId, processId);
        return size;
    }

    public int getAssignmentPendingSize(String processDefId) {
        int size = workflowManager.getAssignmentSize(Boolean.FALSE, processDefId);
        return size;
    }

    public int getAssignmentAcceptedSize(String processDefId) {
        int size = workflowManager.getAssignmentSize(Boolean.TRUE, processDefId);
        return size;
    }

    public void assignmentAccept(String activityId) {
        workflowManager.assignmentAccept(activityId);
    }

    public void assignmentWithdraw(String activityId) {
        workflowManager.assignmentWithdraw(activityId);
    }

    public void assignmentVariable(String activityId, String variableName, String variableValue) {
        workflowManager.assignmentVariable(activityId, variableName, variableValue);
    }

    public void assignmentComplete(String activityId) {
        workflowManager.assignmentComplete(activityId);
    }

    public void assignmentReassign(String processDefId, String processId, String activityId, String username, String replaceUser) {
        workflowManager.assignmentReassign(processDefId, processId, activityId, username, replaceUser);
    }

    public void assignmentForceComplete(String processDefId, String processId, String activityId, String username) {
        workflowManager.assignmentForceComplete(processDefId, processId, activityId, username);
    }

    public Collection<WorkflowVariable> getAssignmentVariableList(String activityId) {
        Collection<WorkflowVariable> variableList = workflowManager.getAssignmentVariableList(activityId);
        return variableList;
    }

    public Map<String, WorkflowParticipant> getParticipantMap(String processId) {
        return workflowManager.getParticipantMap(processId);
    }

    public Collection<WorkflowParticipant> getParticipantList(String processId) {
        return workflowManager.getProcessParticipantDefinitionList(processId);
    }

    public byte[] getPackageContent(String packageId, String version) {
        return workflowManager.getPackageContent(packageId, version);
    }

    public List<String> getAssignmentResourceIds(String processId, String processInstanceId, String activityInstanceId) {
        return workflowManager.getAssignmentResourceIds(processId, processInstanceId, activityInstanceId);
    }

    public void updateDeadlineChecker() {
        workflowManager.internalUpdateDeadlineChecker();
    }

    public boolean isUserInWhiteList(String processDefId) {
        return workflowManager.isUserInWhiteList(processDefId);
    }

    public Collection<WorkflowReport> getWorkflowSLA(String processDefinitionId) {
        return workflowManager.getWorkflowSLA(processDefinitionId);
    }

    public Collection<WorkflowProcess> getWorkflowSLAProcessDefinitions() {
        return workflowManager.getWorkflowSLAProcessDefinitions();
    }

    public List<WorkflowActivity> getAssignmentHistory(String packageId, String processId, String processName, String activityName, String sort, Boolean desc, Integer start, Integer rows) {
        List<WorkflowActivity> assignmentHistoryList = (List<WorkflowActivity>) workflowManager.getAssignmentHistory(packageId, processId, processName, activityName, sort, desc, start, rows);

        return assignmentHistoryList;
    }

    public int getAssignmentHistorySize(String packageId, String processId, String processName, String activityName) {
        int size = workflowManager.getAssignmentHistorySize(packageId, processId, processName, activityName);
        return size;
    }

    public List<WorkflowActivity> getRunningActivityList(String processId, String sort, Boolean desc, Integer start, Integer rows) {
        List<WorkflowActivity> activityList = (List<WorkflowActivity>) workflowManager.getRunningActivityList(processId, sort, desc, start, rows);

        return activityList;
    }

    public int getRunningActivitySize(String processId) {
        int size = workflowManager.getRunningActivitySize(processId);
        return size;
    }

    public WorkflowActivity getProcessActivityDefinition(String processDefId, String activityDefId) {
        return workflowManager.getProcessActivityDefinition(processDefId, activityDefId);
    }

    public String getUserByProcessIdAndActivityDefId(String processDefId, String processId, String activityDefId) {
        return workflowManager.getUserByProcessIdAndActivityDefId(processDefId, processId, activityDefId);
    }

    public Collection<ActivityForm> getFormByActivity(String processId, Integer version, String activityId){
        return activityFormDao.getFormByActivity(processId, version, activityId);
    }

    public String getCurrentUsername(){
        return workflowUserManager.getCurrentUsername();
    }

    public User getUserByUsername(String username){
        return directoryManager.getUserByUsername(username);
    }

    public Form getFormById(String id){
        return formManager.getFormById(id);
    }

    public Collection<ActivityForm> getFormByActivity(String processId, int version, String activityId){
        return activityFormDao.getFormByActivity(processId, version, activityId);
    }

    public void mergeDraftToLive(String tableName, String processId, String activityId){
        WorkflowProcessLink wfProcessLink = workflowManager.getWorkflowProcessLink(processId);

        if(wfProcessLink != null){
            processId = wfProcessLink.getOriginProcessId();
        }
        formManager.mergeDraftToLive(tableName, processId, activityId);
    }

    public Form loadDraftDynamicForm(String tableName, String processId, String activityId){
        WorkflowProcessLink wfProcessLink = workflowManager.getWorkflowProcessLink(processId);

        if(wfProcessLink != null){
            processId = wfProcessLink.getOriginProcessId();
        }
        return formManager.loadDraftDynamicForm(tableName, processId, activityId);
    }

    public Collection<FormMetaData> loadUserviewActivityTableData(UserviewProcess userviewProcess, String filter, Collection<String> filterTypes, String currentUsername, String sort, Boolean desc, Integer start, Integer rows){
        return formManager.loadDynamicFormDataByActivityDefId(userviewProcess.getTableName(), userviewProcess.getActivityDefId(), filter, filterTypes, userviewProcess.getViewType(), userviewProcess.getPermType(), currentUsername, sort, desc, start, rows);
    }

    public Long loadUserviewActivityTableDataSize(UserviewProcess userviewProcess, String filter, Collection<String> filterTypes, String currentUsername){
        return formManager.loadDynamicFormDataByActivityDefIdSize(userviewProcess.getTableName(), userviewProcess.getActivityDefId(), filter, filterTypes, userviewProcess.getViewType(), userviewProcess.getPermType(), currentUsername);
    }

    public String getCurrentPackageVersion(String packageId){
        return workflowManager.getCurrentPackageVersion(packageId);
    }

    public WorkflowProcessLink getWorkflowProcessLink(String processInstId){
        return workflowManager.getWorkflowProcessLink(processInstId);
    }

    public String getProcessDefIdByInstanceId(String processInstId){
        return workflowManager.getProcessDefIdByInstanceId(processInstId);
    }

    public String getConvertedLatestProcessDefId(String processDefId){
        return workflowManager.getConvertedLatestProcessDefId(processDefId);
    }

    public Collection<Form> getAllFormVersion(String formId, String sort, Boolean desc) {
        return formManager.getAllFormVersion(formId, sort, desc);
    }

    public Group getGroupById(String groupId){
        return directoryManager.getGroupById(groupId);
    }

    public String getDesignerwebBaseUrl(HttpServletRequest request){
        String designerwebBaseUrl = "http://" + request.getServerName() + ":" + request.getServerPort();
        if(WorkflowUtil.getSystemSetupValue("designerwebBaseUrl") != null && WorkflowUtil.getSystemSetupValue("designerwebBaseUrl").length() > 0)
            designerwebBaseUrl = WorkflowUtil.getSystemSetupValue("designerwebBaseUrl");
        if(designerwebBaseUrl.endsWith("/"))
            designerwebBaseUrl = designerwebBaseUrl.substring(0, designerwebBaseUrl.length()-1);

        return designerwebBaseUrl;
    }

    public void setActivityContinueNextAssignment(String processId, String activityId, boolean flag){
        ActivitySetup setup = activitySetupDao.getActivitySetup(processId, activityId);

        if(setup != null){
            setup.setContinueNextAssignment(flag?1:0);
            activitySetupDao.saveOrUpdate(setup);
        }else{
            setup = new ActivitySetup();
            setup.setProcessId(processId);
            setup.setActivityId(activityId);
            setup.setContinueNextAssignment(flag?1:0);
            activitySetupDao.save(setup);
        }
    }

    public boolean isActivityContinueNextAssignment(String processDefId, String activityDefId){
        return workflowManager.isActivityContinueNextAssignment(processDefId, activityDefId);
    }

    public ActivitySetup getActivitySetup(String processId, String activityId){
        return activitySetupDao.getActivitySetup(processId, activityId);
    }
}
