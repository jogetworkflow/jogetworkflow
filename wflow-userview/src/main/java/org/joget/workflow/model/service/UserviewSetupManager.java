package org.joget.workflow.model.service;

import java.util.Collection;
import org.joget.workflow.model.UserviewSetup;
import org.joget.workflow.model.dao.UserviewSetupDao;

public class UserviewSetupManager {

    private UserviewSetupDao userviewSetupDao;

    public UserviewSetup getUserviewSetup(String id) {
        UserviewSetup userview = getUserviewSetupDao().find(id);

        return userview;
    }

    public Collection<UserviewSetup> getAllUserviewSetups(String setupName, String sort, Boolean desc, Integer start, Integer rows) {
        if ("dateCreated".equals(sort)) {
            sort = "createdTime";
        } else if ("dateCompleted".equals(sort)) {
            sort = "finishTime";
        } else if ("processId".equals(sort)) {
            sort = "processInstanceId";
        }

        Collection<UserviewSetup> userview = getUserviewSetupDao().getAllUserviewSetups(setupName, sort, desc, start, rows);
        return userview;
    }

    public int getAllUserviewSetupsSize(String setupName) {
        int size = getUserviewSetupDao().getAllUserviewSetupsSize(setupName);
        return size;
    }

    public Collection<UserviewSetup> getUserviewSetupByProcessDefId(String processDefinitionId, String setupName, String sort, Boolean desc, Integer start, Integer rows) {
        if ("dateCreated".equals(sort)) {
            sort = "createdTime";
        } else if ("dateCompleted".equals(sort)) {
            sort = "finishTime";
        } else if ("processId".equals(sort)) {
            sort = "processInstanceId";
        }

        Collection<UserviewSetup> userview = getUserviewSetupDao().getUserviewSetupByProcessDefId(processDefinitionId, setupName, sort, desc, start, rows);
        return userview;
    }
    
    public int getUserviewSetupByProcessDefIdSize(String processDefinitionId, String setupName) {
        int size = getUserviewSetupDao().getUserviewSetupByProcessDefIdSize(processDefinitionId, setupName);
        return size;
    }

    public void saveUserviewSetup(UserviewSetup userviewSetup){
        userviewSetupDao.saveOrUpdate(userviewSetup);
    }

    public void removeUserview(String userviewId){
        userviewSetupDao.delete(userviewId);
    }

    public UserviewSetupDao getUserviewSetupDao() {
        return userviewSetupDao;
    }

    public void setUserviewSetupDao(UserviewSetupDao userviewSetupDao) {
        this.userviewSetupDao = userviewSetupDao;
    }
}
