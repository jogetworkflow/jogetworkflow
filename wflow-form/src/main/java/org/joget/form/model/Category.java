package org.joget.form.model;

import java.util.Set;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;
import org.springmodules.validation.bean.conf.loader.annotation.handler.NotBlank;
import org.springmodules.validation.bean.conf.loader.annotation.handler.RegExp;

@Root(name = "form-category")
public class Category {

    @NotBlank
    @RegExp(value="^[0-9a-zA-Z_-]+$")
    @Element
    private String id;
    @NotBlank
    @Element
    private String name;
    @Element(required = false)
    private String description;
    private Set forms;

    public Set getForms() {
        return forms;
    }

    public void setForms(Set forms) {
        this.forms = forms;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public boolean equals(Object object) {
        Category category = (Category) object;

        if (id.equals(category.getId())) {
            return true;
        } else {
            return false;
        }
    }
}
