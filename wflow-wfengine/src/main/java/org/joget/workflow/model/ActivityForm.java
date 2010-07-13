package org.joget.workflow.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "form-mapping")
public class ActivityForm {

    @Element
    private String id;
    @Element
    private String processId;
    @Element
    private Integer version;
    @Element
    private String activityId;
    @Element(required = false)
    private String formId;
    @Element(required = false)
    private String formUrl;
    @Element(required = false)
    private String formIFrameStyle;
    @Element(name = "formType")
    private String type;

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getFormId() {
        return formId;
    }

    public void setFormId(String formId) {
        this.formId = formId;
    }

    public String getFormUrl() {
        return formUrl;
    }

    public void setFormUrl(String formUrl) {
        this.formUrl = formUrl;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getProcessId() {
        return processId;
    }

    public void setProcessId(String processId) {
        this.processId = processId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }

    public String getFormIFrameStyle() {
        return formIFrameStyle;
    }

    public void setFormIFrameStyle(String formIFrameStyle) {
        this.formIFrameStyle = formIFrameStyle;
    }
}
