package org.joget.workflow.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "participant-mapping")
public class ParticipantDirectory {

    @Element
    private String id;
    @Element(required = false)
    private String packageId;
    @Element(required = false)
    private String processId;
    @Element(required = false)
    private Integer version;
    @Element(required = false)
    private String participantId;
    @Element(required = false)
    private String type;
    @Element(required = false)
    private String value;
    @Element(required = false)
    private String pluginProperties;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getParticipantId() {
        return participantId;
    }

    public void setParticipantId(String participantId) {
        this.participantId = participantId;
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

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public Integer getVersion() {
        return version;
    }

    public void setVersion(Integer version) {
        this.version = version;
    }

    public String getPackageId() {
        return packageId;
    }

    public void setPackageId(String packageId) {
        this.packageId = packageId;
    }

    public String getPluginProperties() {
        return pluginProperties;
    }

    public void setPluginProperties(String pluginProperties) {
        this.pluginProperties = pluginProperties;
    }

}
