package org.joget.workflow.model;

import java.util.Collection;
import java.util.Date;
import org.joget.form.model.Category;
import org.joget.form.model.Form;
import org.joget.form.model.FormVariable;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "userview-process", strict = false)
public class UserviewProcess {

    @Element
    private String id;
    private String userviewSetupId;
    @Element
    private String processDefId;
    @Element(required = false)
    private String categoryId;
    @Element(required = false)
    private Integer sequence;
    @Element
    private String activityDefId;
    @Element(required = false)
    private String activityLabel;
    @Element(required = false)
    private String buttonSaveLabel;
    @Element(required = false)
    private String buttonCancelLabel;
    @Element(required = false)
    private String buttonWithdrawLabel;
    @Element(required = false)
    private String buttonCompleteLabel;
    @Element(required = false)
    private Integer buttonSaveShow;
    @Element(required = false)
    private Integer buttonWithdrawShow;
    @Element(required = false)
    private String activityFormId;

    //only used in exporting
    @ElementList(required = false)
    private Collection<Category> categoryList;
    @ElementList(required = false)
    private Collection<Form> formList;
    @ElementList(required = false)
    private Collection<FormVariable> formVariableList;

    @Element(required = false)
    private String activityFormUrl;
    @Element
    private String tableName;
    @Element
    private String tableColumn;
    @Element(required = false)
    private String tableColumnLabel;
    @Element(required = false)
    private String filter;
    @Element(required = false)
    private String sort;
    @Element
    private Integer viewType;
    @Element
    private Integer permType;
    @Element(required = false)
    private String mappingValue;
    @Element(required = false)
    private String mappingType;
    @Element(required = false)
    private String header;
    @Element(required = false)
    private String footer;
    @Element(required = false)
    private Integer showAllTask;
    @Element(required = false)
    private Integer showAssignee;
    @Element
    private String createdBy;
    @Element(required = false)
    private String modifiedBy;
    @Element
    private Date createdOn;
    @Element(required = false)
    private Date modifiedOn;
    private UserviewSetup dvSetup;

    public UserviewSetup getDvSetup() {
        return dvSetup;
    }

    public void setDvSetup(UserviewSetup dvSetup) {
        this.dvSetup = dvSetup;
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

    public Collection<FormVariable> getFormVariableList() {
        return formVariableList;
    }

    public void setFormVariableList(Collection<FormVariable> formVariableList) {
        this.formVariableList = formVariableList;
    }

    public String getActivityDefId() {
        return activityDefId;
    }

    public void setActivityDefId(String activityDefId) {
        this.activityDefId = activityDefId;
    }

    public String getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(String categoryId) {
        this.categoryId = categoryId;
    }

    public Integer getSequence() {
        return sequence;
    }

    public void setSequence(Integer sequence) {
        this.sequence = sequence;
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

    public String getUserviewSetupId() {
        return userviewSetupId;
    }

    public void setUserviewSetupId(String userviewSetupId) {
        this.userviewSetupId = userviewSetupId;
    }

    public String getFilter() {
        return filter;
    }

    public void setFilter(String filter) {
        this.filter = filter;
    }

    public String getSort() {
        return sort;
    }

    public void setSort(String sort) {
        this.sort = sort;
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

    public String getProcessDefId() {
        return processDefId;
    }

    public void setProcessDefId(String processDefId) {
        this.processDefId = processDefId;
    }

    public Integer getShowAllTask() {
        return showAllTask;
    }

    public void setShowAllTask(Integer showAllTask) {
        this.showAllTask = showAllTask;
    }

    public Integer getShowAssignee() {
        return showAssignee;
    }

    public void setShowAssignee(Integer showAssignee) {
        this.showAssignee = showAssignee;
    }

    public String getTableColumn() {
        return tableColumn;
    }

    public void setTableColumn(String tableColumn) {
        this.tableColumn = tableColumn;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getActivityLabel() {
        return activityLabel;
    }

    public void setActivityLabel(String activityLabel) {
        this.activityLabel = activityLabel;
    }

    public String getTableColumnLabel() {
        return tableColumnLabel;
    }

    public void setTableColumnLabel(String tableColumnLabel) {
        this.tableColumnLabel = tableColumnLabel;
    }

    public Integer getPermType() {
        return permType;
    }

    public void setPermType(Integer permType) {
        this.permType = permType;
    }

    public Integer getViewType() {
        return viewType;
    }

    public void setViewType(Integer viewType) {
        this.viewType = viewType;
    }

    public String getActivityFormId() {
        return activityFormId;
    }

    public void setActivityFormId(String activityFormId) {
        this.activityFormId = activityFormId;
    }

    public String getActivityFormUrl() {
        return activityFormUrl;
    }

    public void setActivityFormUrl(String activityFormUrl) {
        this.activityFormUrl = activityFormUrl;
    }

    public String getMappingValue() {
        return mappingValue;
    }

    public void setMappingValue(String mappingValue) {
        this.mappingValue = mappingValue;
    }

    public String getMappingType() {
        return mappingType;
    }

    public void setMappingType(String mappingType) {
        this.mappingType = mappingType;
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

    public String getButtonSaveLabel() {
        return buttonSaveLabel;
    }

    public void setButtonSaveLabel(String buttonSaveLabel) {
        this.buttonSaveLabel = buttonSaveLabel;
    }

    public String getButtonCancelLabel() {
        return buttonCancelLabel;
    }

    public void setButtonCancelLabel(String buttonCancelLabel) {
        this.buttonCancelLabel = buttonCancelLabel;
    }

    public String getButtonWithdrawLabel() {
        return buttonWithdrawLabel;
    }

    public void setButtonWithdrawLabel(String buttonWithdrawLabel) {
        this.buttonWithdrawLabel = buttonWithdrawLabel;
    }

    public String getButtonCompleteLabel() {
        return buttonCompleteLabel;
    }

    public void setButtonCompleteLabel(String buttonCompleteLabel) {
        this.buttonCompleteLabel = buttonCompleteLabel;
    }

    public Integer getButtonSaveShow() {
        return buttonSaveShow;
    }

    public void setButtonSaveShow(Integer buttonSaveShow) {
        this.buttonSaveShow = buttonSaveShow;
    }

    public Integer getButtonWithdrawShow() {
        return buttonWithdrawShow;
    }

    public void setButtonWithdrawShow(Integer buttonWithdrawShow) {
        this.buttonWithdrawShow = buttonWithdrawShow;
    }
}
