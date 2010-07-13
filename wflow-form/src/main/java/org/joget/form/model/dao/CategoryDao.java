package org.joget.form.model.dao;

import org.joget.form.model.Category;
import org.joget.commons.spring.model.AbstractSpringDao;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public class CategoryDao extends AbstractSpringDao {

    public static final String ENTITY_NAME = "Category";

    public Long count(String condition, Category[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public void delete(Category obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public Category find(String id) {
        return (Category) super.find(ENTITY_NAME, id);
    }

    public Collection<Category> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public List<Category> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public List<Category> findByExample(Category Category) {
        return super.findByExample(ENTITY_NAME, Category);
    }

    public Serializable save(Category obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(Category obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }
    
    public List<Category> findAll(String sort, Boolean desc, Integer start, Integer rows){
        return (List<Category>) super.find(ENTITY_NAME, "", new Object[]{}, sort, desc, start, rows);
    }
    
    public void delete(String id) {
        Category category = find(id);
        super.delete(ENTITY_NAME, category);
    }
}
