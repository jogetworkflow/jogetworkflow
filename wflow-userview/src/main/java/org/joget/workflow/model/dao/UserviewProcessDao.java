package org.joget.workflow.model.dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.UserviewProcess;
import org.springframework.orm.hibernate3.HibernateCallback;

public class UserviewProcessDao extends AbstractSpringDao {

    public static final String MAPPING_SEPARATOR = ",";
    public static final String MAPPING_TYPE_USER = "USER";
    public static final String MAPPING_TYPE_GROUP = "GROUP";
    public static final String MAPPING_TYPE_ALL = "ALL";
    
    public static final String ENTITY_NAME = "UserviewProcess";

    public Long count(String condition, UserviewProcess[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public void delete(UserviewProcess obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public UserviewProcess find(String id) {
        return (UserviewProcess) super.find(ENTITY_NAME, id);
    }

    public Collection<UserviewProcess> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public Collection<UserviewProcess> getUserviewProcessBySetupId(String userviewSetupId) {
        return find(ENTITY_NAME, "join e.dvSetup d where d.id=? order by e.sequence asc", new Object[]{userviewSetupId}, null, null, null, null);
    }

    public Collection<UserviewProcess> getUserviewSetupByProcessDefId(String processDefinitionId, String setupName, String sort, Boolean desc, Integer start, Integer rows) {
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

    public List<String> getProcessDefIdListBySetupId(final String setupId) {
        List result = (List) super.findHibernateTemplate().execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT distinct e.processDefId FROM " + ENTITY_NAME + " e where userviewSetupId=?";

                        Query q = session.createQuery(query);
                        q.setParameter(0, setupId);
                        
                        return q.list();
                    }
                });

        return result;
    }

    public List<UserviewProcess> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public List<UserviewProcess> findByExample(UserviewProcess userview) {
        return super.findByExample(ENTITY_NAME, userview);
    }

    public Serializable save(UserviewProcess obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(UserviewProcess obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public List<UserviewProcess> findAll(String sort, Boolean desc, Integer start, Integer rows) {
        return (List<UserviewProcess>) super.find(ENTITY_NAME, "", new Object[]{}, sort, desc, start, rows);
    }

    public void delete(String id) {
        UserviewProcess userview = find(id);
        super.delete(ENTITY_NAME, userview);
    }
}
