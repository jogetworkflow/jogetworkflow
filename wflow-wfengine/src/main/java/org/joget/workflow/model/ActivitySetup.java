package org.joget.workflow.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "activity-setup")
public class ActivitySetup {
    @Element
    private String id;
    @Element
    private String processId;
    @Element
    private String activityId;
    @Element(required = false)
    private int continueNextAssignment;

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public int getContinueNextAssignment() {
        return continueNextAssignment;
    }

    public void setContinueNextAssignment(int continueNextAssignment) {
        this.continueNextAssignment = continueNextAssignment;
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
}
