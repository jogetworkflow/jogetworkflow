package org.joget.form.model.dao;

import org.joget.form.model.Form;
import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.joget.form.model.FormMetaData;
import org.springframework.orm.hibernate3.HibernateCallback;

public class DynamicFormDao extends DynamicFormDaoSupport {

    public static int STATUS_RUNNING_AND_COMPLETED = 0;
    public static int STATUS_RUNNING = 1;

    public static int VIEW_PERMISSION_PERSONAL = 0;
    public static int VIEW_PERMISSION_ASSIGNED = 1;
    public static int VIEW_PERMISSION_ALL = 2;

    public Serializable save(Form form) {
        String tableName = form.getTableName();
        return getHibernateTemplate(tableName, form).save(FORM_ID_PREFIX + tableName, form);
    }

    public void saveOrUpdateMetaData(FormMetaData formMetaData, String tableName) {
        getHibernateTemplate(tableName).saveOrUpdate(FORM_METADATA_ID_PREFIX + tableName, formMetaData);
    }

    public void saveOrUpdate(Form form) {
        String tableName = form.getTableName();
        getHibernateTemplate(tableName, form).saveOrUpdate(FORM_ID_PREFIX + tableName, form);
    }

    public List<Form> loadAllDynamicForm(final String tableName) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT e FROM " + FORM_ID_PREFIX + tableName + " e ";
                        Query q = session.createQuery(query);
                        return q.list();
                    }
                });

        return result;
    }

    public Form load(String tableName, String id) {
        return (Form) getHibernateTemplate(tableName).load(FORM_ID_PREFIX + tableName, id);
    }

    public List<Form> getAllDynamicFormByFormId(final String formId, final String tableName, final boolean includeDraft) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String condition = "WHERE e.customProperties.formId = ? ";
                        if (!includeDraft) {
                            condition += "AND e.customProperties.draft <> 1";
                        }

                        String query = "SELECT e FROM " + FORM_ID_PREFIX + tableName + " e " + condition;
                        Query q = session.createQuery(query);
                        q.setParameter(0, formId);
                        return q.list();
                    }
                });

        return result;
    }

    public Form loadDynamicFormByProcessId(final String tableName, final String processId) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT e FROM " + FORM_ID_PREFIX + tableName + " e WHERE e.customProperties.processId = ? AND e.customProperties.draft <> ?";
                        Query q = session.createQuery(query);
                        q.setParameter(0, processId);
                        q.setParameter(1, "1");
                        return q.list();
                    }
                });

        if (result.size() > 0) {
            return (Form) result.get(0);
        } else {
            return null;
        }
    }

    public FormMetaData loadDynamicFormMetaDataByActivityId(final String tableName, final String activityId) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT e FROM " + FORM_METADATA_ID_PREFIX + tableName + " e WHERE e.activityId = ?";
                        Query q = session.createQuery(query);
                        q.setParameter(0, activityId);
                        return q.list();
                    }
                });

        if (result.size() > 0) {
            return (FormMetaData) result.get(0);
        } else {
            return null;
        }
    }

    public FormMetaData loadDynamicFormMetaData(final String tableName, final String id) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT e FROM " + FORM_METADATA_ID_PREFIX + tableName + " e WHERE e.id = ?";
                        Query q = session.createQuery(query);
                        q.setParameter(0, id);
                        return q.list();
                    }
                });

        if (result.size() > 0) {
            return (FormMetaData) result.get(0);
        } else {
            return null;
        }
    }

    public Form loadDraft(final String tableName, final String processId, final String activityId) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT e FROM " + FORM_ID_PREFIX + tableName + " e WHERE e.customProperties.processId = ? AND e.customProperties.activityId = ? AND e.customProperties.draft = ?";
                        Query q = session.createQuery(query);
                        q.setParameter(0, processId);
                        q.setParameter(1, activityId);
                        q.setParameter(2, "1");
                        return q.list();
                    }
                });

        if (result.size() > 0) {
            return (Form) result.get(0);
        } else {
            return null;
        }
    }

    public void delete(String tableName, Form form) {
        getHibernateTemplate(tableName).delete(FORM_ID_PREFIX + tableName, form);
    }

    public int getMaxValue(final String columnName, final String tableName) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT max(e.customProperties." + columnName + ") FROM " + FORM_ID_PREFIX + tableName + " e";
                        Query q = session.createQuery(query);
                        return q.list();
                    }
                });

        if (result != null && result.size() > 0) {
            return (result.get(0) == null) ? 0 : (Integer) result.get(0);
        } else {
            return 0;
        }
    }

    public String getActivityIdByDefId(final String tableName, final String dynamicFormId, final String activityDefId){
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT activityId FROM " + FORM_METADATA_ID_PREFIX + tableName + " e WHERE e.dynamicFormId = ? AND e.activityDefId = ? order by e.latest desc";
                        Query q = session.createQuery(query);
                        q.setParameter(0, dynamicFormId);
                        q.setParameter(1, activityDefId);
                        return q.list();
                    }
                });

        if (result != null && result.size() > 0) {
            return (result.get(0) == null) ? null : (String) result.get(0);
        } else {
            return null;
        }
    }

    public List<FormMetaData> loadDynamicFormDataByActivityDefId(final String tableName, final String activityDefId, final String filter, final Collection<String> filterTypes, final int status, final int permType, final String currentUsername, final String sort, final Boolean desc, final Integer start, final Integer rows) {
        List result = (List) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT e FROM " + FORM_METADATA_ID_PREFIX + tableName + " e ";

                        query += "WHERE e.dynamicFormId IS NOT NULL AND e.activityDefId = :activityDefId ";

                        if (status == STATUS_RUNNING) {
                            query += "AND e.latest=:status ";
                        }

                        if (permType == VIEW_PERMISSION_PERSONAL) {
                           query += "AND (e.pendingUsers LIKE :pendingUsers OR e.username=:currentUsername) ";
                        }else  if (permType == VIEW_PERMISSION_ASSIGNED) {
                           query += "AND e.pendingUsers LIKE :pendingUsers ";
                        }

                        if(filter != null && filter.trim().length() > 0 && filterTypes != null && filterTypes.size() > 0){
                            query += "AND ";
                            if(filterTypes.size() > 1){
                                query += "(";
                            }
                            for (Iterator<String> i = filterTypes.iterator(); i.hasNext();){
                                query += "e." + i.next() + " LIKE :filter ";

                                if(i.hasNext()){
                                    query += "OR ";
                                }
                            }
                            if(filterTypes.size() > 1){
                                query += ") ";
                            }
                        }

                        if (sort != null && !sort.equals("")) {
                            query += "ORDER BY e." + sort;

                            if (desc) {
                                query += " DESC";
                            }
                        }

                        Query q = session.createQuery(query);
                        q.setString("activityDefId", activityDefId);

                        if (status == STATUS_RUNNING) {
                            q.setInteger("status", status);
                        }

                        if (permType == VIEW_PERMISSION_PERSONAL) {
                            q.setString("currentUsername", currentUsername);
                            q.setString("pendingUsers", "%," + currentUsername + ",%");
                        }else  if (permType == VIEW_PERMISSION_ASSIGNED) {
                            q.setString("pendingUsers", "%," + currentUsername + ",%");
                        }

                        if(filter != null && filter.trim().length() > 0 && filterTypes != null && filterTypes.size() > 0){
                            q.setString("filter", "%" + filter + "%");
                        }
                        
                        int s = (start == null) ? 0 : start;
                        q.setFirstResult(s);

                        if (rows != null && rows > 0) {
                            q.setMaxResults(rows);
                        }

                        return q.list();
                    }
                });

        return result;
    }

    public Long loadDynamicFormDataByActivityDefIdSize(final String tableName, final String activityDefId, final String filter, final Collection<String> filterTypes, final int status, final int permType, final String currentUsername){
        Long count = (Long) this.getHibernateTemplate(tableName).execute(
                new HibernateCallback() {

                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT COUNT(*) FROM " + FORM_METADATA_ID_PREFIX + tableName + " e ";

                        query += "WHERE e.dynamicFormId IS NOT NULL AND e.activityDefId = :activityDefId ";

                        if (status == STATUS_RUNNING) {
                            query += "AND e.latest=:status ";
                        }

                        if (permType == VIEW_PERMISSION_PERSONAL) {
                            query += "AND (e.pendingUsers LIKE :pendingUsers OR e.username=:currentUsername) ";
                        } else if (permType == VIEW_PERMISSION_ASSIGNED) {
                            query += "AND e.pendingUsers LIKE :pendingUsers ";
                        }

                        if(filter != null && filter.trim().length() > 0 && filterTypes != null && filterTypes.size() > 0){
                            query += "AND ";
                            if(filterTypes.size() > 1){
                                query += "(";
                            }
                            for (Iterator<String> i = filterTypes.iterator(); i.hasNext();){
                                query += "e." + i.next() + " LIKE :filter ";

                                if(i.hasNext()){
                                    query += "OR ";
                                }
                            }
                            if(filterTypes.size() > 1){
                                query += ")";
                            }
                        }

                        Query q = session.createQuery(query);
                        q.setString("activityDefId", activityDefId);

                        if (status == STATUS_RUNNING) {
                            q.setInteger("status", status);
                        }

                        if (permType == VIEW_PERMISSION_PERSONAL) {
                            q.setString("currentUsername", currentUsername);
                            q.setString("pendingUsers", "%," + currentUsername + ",%");
                        } else if (permType == VIEW_PERMISSION_ASSIGNED) {
                            q.setString("pendingUsers", "%," + currentUsername + ",%");
                        }

                        if(filter != null && filter.trim().length() > 0 && filterTypes != null && filterTypes.size() > 0){
                            q.setString("filter", "%" + filter + "%");
                        }
                        
                        return ((Long) q.iterate().next()).longValue();
                    }
                });

        return count;
    }
}
