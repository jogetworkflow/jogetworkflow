package org.joget.form.model;

import java.util.Date;

public class FormMetaData {

    private String id;
    private String dynamicFormId;
    private String activityId;
    private String activityDefId;
    private String participantId;
    private String username;
    private String pendingUsers;
    private Date created;
    private Integer latest;

    private Form dynamicForm;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getActivityDefId() {
        return activityDefId;
    }

    public void setActivityDefId(String activityDefId) {
        this.activityDefId = activityDefId;
    }

    public String getParticipantId() {
        return participantId;
    }

    public void setParticipantId(String participantId) {
        this.participantId = participantId;
    }

    public Date getCreated() {
        return created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getDynamicFormId() {
        return dynamicFormId;
    }

    public void setDynamicFormId(String dynamicFormId) {
        this.dynamicFormId = dynamicFormId;
    }

    public Integer getLatest() {
        return latest;
    }

    public void setLatest(Integer latest) {
        this.latest = latest;
    }

    public String getPendingUsers() {
        return pendingUsers;
    }

    public void setPendingUsers(String pendingUsers) {
        this.pendingUsers = pendingUsers;
    }

    public Form getDynamicForm() {
        return dynamicForm;
    }

    public void setDynamicForm(Form dynamicForm) {
        this.dynamicForm = dynamicForm;
    }
}
