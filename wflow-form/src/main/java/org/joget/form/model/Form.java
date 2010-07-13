package org.joget.form.model;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;
import org.springmodules.validation.bean.conf.loader.annotation.handler.NotBlank;

@Root
public class Form {

    private String formId;
    @NotBlank
    @Element
    private String id;
    @NotBlank
    @Element
    private String name;
    @Element
    private String data;
    @Element
    private String tableName;
    @Element
    private Date created;
    @Element
    private Date modified;
    private Map customProperties;
    @Element
    private String categoryId;
    private Category category;
    private int refCount;
    private String refName;

   
    public String getRefName() {
        return refName;
    }

    public void setRefName(String refName) {
        this.refName = refName;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Form() {
    }

    public Form(String formId) {
        setFormId(formId);
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getModified() {
        return modified;
    }

    public void setModified(Date modified) {
        this.modified = modified;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getFormId() {
        return formId;
    }

    public void setFormId(String formId) {
        this.formId = formId;
    }

    public Map getCustomProperties() {
        if (customProperties == null) {
            customProperties = new HashMap();
        }
        return customProperties;
    }

    public void setCustomProperties(Map customProperties) {
        this.customProperties = customProperties;
    }

    public Object getValueOfCustomField(String name) {
        return getCustomProperties().get(name);
    }

    public void setValueOfCustomField(String name, Object value) {
        getCustomProperties().put(name, value);
    }

    public int getRefCount() {
        return refCount;
    }

    public void setRefCount(int refCount) {
        this.refCount = refCount;
    }
}
