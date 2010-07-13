package org.joget.workflow.model;

import java.util.Collection;
import org.joget.form.model.Category;
import org.joget.form.model.Form;
import org.joget.form.model.FormVariable;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "process", strict = false)
public class ExportedProcess {

    @Element
    private String id;

    @ElementList(name = "form-categories")
    private Collection<Category> categoryList;

    @ElementList(name = "forms")
    private Collection<Form> formList;

    @ElementList(name = "form-mappings")
    private Collection<ActivityForm> activityFormList;

    @ElementList(name = "participant-mappings")
    private Collection<ParticipantDirectory> participantDirectoryList;

    @ElementList(name = "plugin-mappings")
    private Collection<ActivityPlugin> activityPluginList;

    @ElementList(name = "activity-setup", required = false)
    private Collection<ActivitySetup> activitySetupList;

    @ElementList(name = "form-variable", required = false)
    private Collection<FormVariable> formVariableList;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Collection<Category> getCategoryList() {
        return categoryList;
    }

    public void setCategoryList(Collection<Category> categoryList) {
        this.categoryList = categoryList;
    }

    public Collection<Form> getFormList() {
        return formList;
    }

    public void setFormList(Collection<Form> formList) {
        this.formList = formList;
    }

    public Collection<ActivityForm> getActivityFormList() {
        return activityFormList;
    }

    public void setActivityFormList(Collection<ActivityForm> activityFormList) {
        this.activityFormList = activityFormList;
    }

    public Collection<ParticipantDirectory> getParticipantDirectoryList() {
        return participantDirectoryList;
    }

    public void setParticipantDirectoryList(Collection<ParticipantDirectory> participantDirectoryList) {
        this.participantDirectoryList = participantDirectoryList;
    }

    public Collection<ActivityPlugin> getActivityPluginList() {
        return activityPluginList;
    }

    public void setActivityPluginList(Collection<ActivityPlugin> activityPluginList) {
        this.activityPluginList = activityPluginList;
    }

    public Collection<ActivitySetup> getActivitySetupList() {
        return activitySetupList;
    }

    public void setActivitySetupList(Collection<ActivitySetup> activitySetupList) {
        this.activitySetupList = activitySetupList;
    }

    public Collection<FormVariable> getFormVariableList() {
        return formVariableList;
    }

    public void setFormVariableList(Collection<FormVariable> formVariableList) {
        this.formVariableList = formVariableList;
    }
}
