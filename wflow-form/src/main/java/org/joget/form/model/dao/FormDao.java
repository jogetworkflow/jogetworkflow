package org.joget.form.model.dao;

import org.joget.form.model.Form;
import org.joget.form.model.Category;
import org.joget.commons.spring.model.AbstractSpringDao;
import java.util.Collection;
import org.hibernate.Query;
import org.hibernate.Session;
import java.util.List;
import org.hibernate.HibernateException;
import org.springframework.orm.hibernate3.HibernateCallback;

public class FormDao extends AbstractSpringDao {

    public static final String ENTITY_NAME = "Form";

    public Long count(String condition, Object[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }
    
    public Collection<Form> getFormByCategory(String categoryName) {
        return super.find(ENTITY_NAME, "JOIN e.category c WHERE c.name = ?", new String[]{categoryName}, null, null, null, null);
    }

    public Collection<Form> getFormByName(String name) {
        Form form = new Form();
        form.setName(name);
        return (Collection<Form>) super.findByExample(ENTITY_NAME, form);
    }

    public Collection<Form> getFormByTableName(String tableName) {
        Form form = new Form();
        form.setTableName(tableName);
        return (Collection<Form>) super.findByExample(ENTITY_NAME, form);
    }

    public Collection<Form> getAllFormVersion(String formId, String sort, Boolean desc) {
        if(formId.contains("_ver_")){
            formId = formId.substring(0, formId.indexOf("_ver_"));
        }
        return super.find(ENTITY_NAME, "WHERE e.id = ? or e.id like ?", new String[]{formId, formId+"_ver_%"}, sort, desc, 0, -1);
    }
    
    public void delete(String id) {
        Form form = find(id);
        super.delete(ENTITY_NAME, form);
    }

    public Form find(String id) {
        return (Form) super.find(ENTITY_NAME, id);
    }

    public List<Form> findAll() {
        return super.findAll(ENTITY_NAME);
    }
    
    public List<Form> findAll(String categoryId, String sort, Boolean desc, Integer start, Integer rows){
        if(categoryId != null && categoryId.trim().length() != 0){
            return (List<Form>) super.find(ENTITY_NAME, "WHERE e.categoryId = ?", new String[]{categoryId}, sort, desc, start, rows);
        }else{
            return (List<Form>) super.find(ENTITY_NAME, "", new Object[]{}, sort, desc, start, rows);
        }
    }
    
    public void saveOrUpdate(Form form) {
        super.saveOrUpdate(ENTITY_NAME, form);
    }

    public void save(Form form) {
        super.save(ENTITY_NAME, form);
    }

    public void setFormToCategory(Form form, Category category) {
        category.getForms().add(form);
        saveOrUpdate(form);
    }

    public void removeFormFromCategory(Form form, Category category) {
        category.getForms().remove(form);
        saveOrUpdate(form);
    }

    public List<String> getAllTableName(){
        List result = (List) this.getHibernateTemplate().execute(
                new HibernateCallback() {
                    public Object doInHibernate(Session session) throws HibernateException {
                        String query = "SELECT distinct e.tableName FROM " + ENTITY_NAME + " e order by e.tableName";
                        Query q = session.createQuery(query);
                        return q.list();
                    }
                });

        return result;
    }
}
