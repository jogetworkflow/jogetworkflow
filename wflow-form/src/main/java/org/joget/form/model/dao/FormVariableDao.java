package org.joget.form.model.dao;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.form.model.FormVariable;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;
import org.joget.commons.util.UuidGenerator;

public class FormVariableDao extends AbstractSpringDao {
    public static final String ENTITY_NAME = "FormVariable";

    public Long count(String condition, Object[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public void delete(FormVariable obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public FormVariable find(String id) {
        return (FormVariable) super.find(ENTITY_NAME, id);
    }

    public Collection<FormVariable> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public List<FormVariable> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public boolean isExistsByName(String formVariableName) {
        String condition = "WHERE name = ?";
        Object[] params = {formVariableName};

        return (count(condition, params) > 0) ? true : false;
    }

    public Serializable save(FormVariable obj) {
        if(obj.getId() == null){
            obj.setId(UuidGenerator.getInstance().getUuid());
        }
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(FormVariable obj) {
        if(obj.getId() == null){
            obj.setId(UuidGenerator.getInstance().getUuid());
        }
        super.saveOrUpdate(ENTITY_NAME, obj);
    }

    public int getTotalFormVariables(){
        return findAll().size();
    }

    public void setPluginProperties(String id, String properties){
        FormVariable formVariable = find(id);
        formVariable.setPluginProperties(properties);

        saveOrUpdate(formVariable);
    }

    public void removePluginProperties(String id){
        FormVariable formVariable = find(id);
        formVariable.setPluginProperties(null);

        saveOrUpdate(formVariable);
    }
}
