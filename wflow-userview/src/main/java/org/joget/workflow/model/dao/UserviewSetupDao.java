package org.joget.workflow.model.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.UserviewProcess;
import org.joget.workflow.model.UserviewSetup;

public class UserviewSetupDao extends AbstractSpringDao {

    public static final String ENTITY_NAME = "UserviewSetup";
     private UserviewProcessDao userviewProcessDao;

    public Long count(String condition, UserviewSetup[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public void delete(UserviewSetup obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public UserviewSetup find(String id) {
        return (UserviewSetup) super.find(ENTITY_NAME, id);
    }
    
    public Collection<UserviewSetup> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public Collection<UserviewSetup> getAllUserviewSetups(String setupName, String sort, Boolean desc, Integer start, Integer rows) {
        List<Object> params = new ArrayList<Object>();

        String hql = " where 1=1 ";

        if (setupName != null && setupName.trim().length() > 0) {
            hql += " and e.setupName like ?";
            params.add("%" + setupName + "%");
        }

        return find(ENTITY_NAME, hql, params.toArray(), sort, desc, start, rows);

    }

    public int getAllUserviewSetupsSize(String setupName) {
        List<Object> params = new ArrayList<Object>();

        String hql = "e where 1=1 ";

        if (setupName != null && setupName.trim().length() > 0) {
            hql += " and e.setupName like ?";
            params.add("%" + setupName + "%");
        }

        return count(ENTITY_NAME, hql, params.toArray()).intValue();

    }
    
    public Collection<UserviewSetup> getUserviewSetupByProcessDefId(String processDefinitionId, String setupName, String sort, Boolean desc, Integer start, Integer rows) {
        List<Object> params = new ArrayList<Object>();

        String hql = " where 1=1 ";

        if (processDefinitionId != null && processDefinitionId.trim().length() > 0) {
            hql += " and e.processDefinitionId=?";
            params.add(processDefinitionId);
        }

        if (setupName != null && setupName.trim().length() > 0) {
            hql += " and e.setupName like ?";
            params.add("%" + setupName + "%");
        }

        return find(ENTITY_NAME, hql, params.toArray(), sort, desc, start, rows);

    }

    public int getUserviewSetupByProcessDefIdSize(String processDefinitionId, String setupName) {
        List<Object> params = new ArrayList<Object>();

        String hql = "e where 1=1 ";

        if (processDefinitionId != null && processDefinitionId.trim().length() > 0) {
            hql += " and e.processDefinitionId=?";
            params.add(processDefinitionId);
        }

        if (setupName != null && setupName.trim().length() > 0) {
            hql += " and e.setupName like ?";
            params.add("%" + setupName + "%");
        }

        return count(ENTITY_NAME, hql, params.toArray()).intValue();

    }

    public List<UserviewSetup> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public List<UserviewSetup> findByExample(UserviewSetup userview) {
        return super.findByExample(ENTITY_NAME, userview);
    }

    public Serializable save(UserviewSetup obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(UserviewSetup obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public List<UserviewSetup> findAll(String sort, Boolean desc, Integer start, Integer rows) {
        return (List<UserviewSetup>) super.find(ENTITY_NAME, "", new Object[]{}, sort, desc, start, rows);
    }

    public void delete(String id) {
        UserviewSetup userview = find(id);
        Collection<UserviewProcess> dvProcess = userviewProcessDao.getUserviewProcessBySetupId(id);
        
        for (UserviewProcess child : dvProcess) {
            userviewProcessDao.delete(child);
        }

        super.delete(ENTITY_NAME, userview);
    }

    public UserviewProcessDao getUserviewProcessDao() {
        return userviewProcessDao;
    }
    
    public void setUserviewProcessDao(UserviewProcessDao userviewProcessDao) {
        this.userviewProcessDao = userviewProcessDao;
    }
}
