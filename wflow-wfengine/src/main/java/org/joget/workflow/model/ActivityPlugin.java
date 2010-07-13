package org.joget.workflow.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "plugin-mapping")
public class ActivityPlugin {

    @Element
    private String id;
    @Element
    private String processId;
    @Element
    private Integer version;
    @Element
    private String activityId;
    @Element
    private String pluginName;
    @Element(required = false)
    private String pluginProperties;

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPluginName() {
        return pluginName;
    }

    public void setPluginName(String pluginName) {
        this.pluginName = pluginName;
    }

    public String getPluginProperties() {
        return pluginProperties;
    }

    public void setPluginProperties(String pluginProperties) {
        this.pluginProperties = pluginProperties;
    }

    public String getProcessId() {
        return processId;
    }

    public void setProcessId(String processId) {
        this.processId = processId;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }
}
