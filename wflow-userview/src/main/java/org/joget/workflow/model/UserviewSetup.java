package org.joget.workflow.model;

import java.util.Date;
import java.util.Set;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;

public class UserviewSetup {

    @Element
    private String id;
    @Element
    private String setupName;
    @Element(required = false)
    private String startProcessDefId;
    @Element(required = false)
    private String startProcessLabel;
    @Element(required = false)
    private Integer runProcessDirectly;
    @Element(required = false)
    private String inboxLabel;
    @Element(required = false)
    private String categories;
    @Element(required = false)
    private String header;
    @Element(required = false)
    private String footer;
    @Element(required = false)
    private String menu;
    @Element(required = false)
    private String css;
    @Element(required = false)
    private String cssLink;
    @Element
    private String createdBy;
    @Element(required = false)
    private String modifiedBy;
    @Element
    private Date createdOn;
    @Element(required = false)
    private Date modifiedOn;
    @Element
    private Integer active;
    @ElementList(name = "userview-processes")
    private Set<UserviewProcess> processes;
    
    public Set<UserviewProcess> getProcesses() {
        return processes;
    }

    public void setProcesses(Set<UserviewProcess> processes) {
        this.processes = processes;
    }
    
    public Integer getActive() {
        return active;
    }

    public void setActive(Integer active) {
        this.active = active;
    }

    public String getCategories() {
        return categories;
    }

    public void setCategories(String categories) {
        this.categories = categories;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public Date getCreatedOn() {
        return createdOn;
    }

    public void setCreatedOn(Date createdOn) {
        this.createdOn = createdOn;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(String modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    public Date getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(Date modifiedOn) {
        this.modifiedOn = modifiedOn;
    }

    public String getSetupName() {
        return setupName;
    }

    public void setSetupName(String setupName) {
        this.setupName = setupName;
    }


    public String getStartProcessLabel() {
        return startProcessLabel;
    }

    public void setStartProcessLabel(String startProcessLabel) {
        this.startProcessLabel = startProcessLabel;
    }

    public String getStartProcessDefId() {
        return startProcessDefId;
    }

    public void setStartProcessDefId(String startProcessDefId) {
        this.startProcessDefId = startProcessDefId;
    }

    public String getInboxLabel() {
        return inboxLabel;
    }

    public void setInboxLabel(String inboxLabel) {
        this.inboxLabel = inboxLabel;
    }

    public String getCss() {
        return css;
    }

    public void setCss(String css) {
        this.css = css;
    }

    public String getCssLink() {
        return cssLink;
    }

    public void setCssLink(String cssLink) {
        this.cssLink = cssLink;
    }

    public String getFooter() {
        return footer;
    }

    public void setFooter(String footer) {
        this.footer = footer;
    }

    public String getHeader() {
        return header;
    }

    public void setHeader(String header) {
        this.header = header;
    }

    public String getMenu() {
        return menu;
    }

    public void setMenu(String menu) {
        this.menu = menu;
    }

    public Integer getRunProcessDirectly() {
        return runProcessDirectly;
    }

    public void setRunProcessDirectly(Integer runProcessDirectly) {
        this.runProcessDirectly = runProcessDirectly;
    }
}
