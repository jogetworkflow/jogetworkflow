package org.joget.workflow.model.service;

import java.util.Collection;
import java.util.List;
import org.joget.directory.model.Group;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.workflow.model.UserviewProcess;
import org.joget.workflow.model.dao.UserviewProcessDao;

public class UserviewProcessManager {

    private UserviewProcessDao userviewProcessDao;
    private DirectoryManager directoryManager;

    public UserviewProcess getUserviewProcess(String id) {
        UserviewProcess userview = getUserviewProcessDao().find(id);
        return userview;
    }

    public Collection<UserviewProcess> getUserviewProcessBySetupId(String userviewSetupId) {
        Collection<UserviewProcess> userview = getUserviewProcessDao().getUserviewProcessBySetupId(userviewSetupId);
        return userview;
    }

    public Collection<UserviewProcess> getUserviewSetupByProcessDefId(String processDefinitionId, String setupName, String sort, Boolean desc, Integer start, Integer rows) {
        if ("dateCreated".equals(sort)) {
            sort = "createdTime";
        } else if ("dateCompleted".equals(sort)) {
            sort = "finishTime";
        } else if ("processId".equals(sort)) {
            sort = "processInstanceId";
        }

        Collection<UserviewProcess> userview = getUserviewProcessDao().getUserviewSetupByProcessDefId(processDefinitionId, setupName, sort, desc, start, rows);
        return userview;
    }

    public int getUserviewSetupByProcessDefIdSize(String processDefinitionId, String setupName) {
        int size = getUserviewProcessDao().getUserviewSetupByProcessDefIdSize(processDefinitionId, setupName);
        return size;
    }

    public void saveUserviewProcess(UserviewProcess userviewProcess){
        userviewProcessDao.saveOrUpdate(userviewProcess);
    }

    public void removeUserviewProcessBySetupId(String userviewSetupId){
        Collection<UserviewProcess> userviewProcessList = getUserviewProcessBySetupId(userviewSetupId);
        for(UserviewProcess userviewProcess : userviewProcessList){
            getUserviewProcessDao().delete(userviewProcess);
        }
    }

    public List<String> getProcessDefIdListBySetupId(String setupId){
        return getUserviewProcessDao().getProcessDefIdListBySetupId(setupId);
    }

    public UserviewProcessDao getUserviewProcessDao() {
        return userviewProcessDao;
    }

    public void setUserviewProcessDao(UserviewProcessDao userviewProcessDao) {
        this.userviewProcessDao = userviewProcessDao;
    }
    
    public boolean isUserAllowToView(UserviewProcess userviewProcess, String username){
        if(userviewProcess.getMappingType() != null){
            if(userviewProcess.getMappingType().equals(UserviewProcessDao.MAPPING_TYPE_ALL)){
                return true;

            }else if(userviewProcess.getMappingType().equals(UserviewProcessDao.MAPPING_TYPE_USER)){
                String[] users = userviewProcess.getMappingValue().split(UserviewProcessDao.MAPPING_SEPARATOR);

                for (String user : users) {
                    if(user.equals(username)){
                        return true;
                    }
                }

                return false;

            }else{
                String val = userviewProcess.getMappingValue();
                if(val != null && val.trim().length() > 0){
                    String[] groups = val.split(UserviewProcessDao.MAPPING_SEPARATOR);

                    for (String groupId : groups) {
                        Group group = directoryManager.getGroupById(groupId);
                        if(group != null && directoryManager.isUserInGroup(username, group.getName())){
                            return true;
                        }
                    }

                    return false;
                }else{
                    return true;
                }
            }
        }else{
            return true;
        }
        
    }

    public DirectoryManager getDirectoryManager() {
        return directoryManager;
    }

    public void setDirectoryManager(DirectoryManager directoryManager) {
        this.directoryManager = directoryManager;
    }
}
