package org.joget.directory.model.service;

import org.joget.commons.spring.model.Setting;
import org.joget.commons.util.CsvUtil;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import org.joget.directory.model.Department;
import org.joget.directory.model.Grade;
import org.joget.directory.model.Group;
import org.joget.directory.model.Role;
import org.joget.directory.model.User;
import org.joget.plugin.base.PluginManager;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class DirectoryManagerProxyImpl implements DirectoryManager {

    private SetupManager setupManager;
    private PluginManager pluginManager;
    private DirectoryManager defaultDirectoryManagerImpl;

    public DirectoryManager getDefaultDirectoryManagerImpl() {
        return defaultDirectoryManagerImpl;
    }

    public void setDefaultDirectoryManagerImpl(DirectoryManager defaultDirectoryManagerImpl) {
        this.defaultDirectoryManagerImpl = defaultDirectoryManagerImpl;
    }

    public DirectoryManager getDirectoryManagerImpl() {
        try {
            Setting setting = getSetupManager().getSettingByProperty("directoryManagerImpl");

            if (setting != null && setting.getValue() != null && setting.getValue().trim().length() > 0) {

                DirectoryManagerPlugin directoryManagerPlugin = (DirectoryManagerPlugin) getPluginManager().getPlugin(setting.getValue());

                if (directoryManagerPlugin != null) {

                    //get plugin properties (if any)
                    Map propertyMap = new HashMap();
                    Setting propertySetting = getSetupManager().getSettingByProperty("directoryManagerImplProperties");

                    if (propertySetting != null && propertySetting.getValue() != null && propertySetting.getValue().trim().length() > 0) {
                        String properties = propertySetting.getValue();
                        propertyMap = CsvUtil.getPluginPropertyMap(properties);
                    }

                    LogUtil.debug(getClass().getName(), "DirectoryManager Plugin Found: " + setting.getValue());
                    return directoryManagerPlugin.getDirectoryManagerImpl(propertyMap);
                }
            }
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
        
        return getDefaultDirectoryManagerImpl();
    }

    public boolean authenticate(String username, String password) {
        return getDirectoryManagerImpl().authenticate(username, password);
    }

    public Group getGroupById(String groupId) {
        return getDirectoryManagerImpl().getGroupById(groupId);
    }

    public Group getGroupByName(String groupName) {
        return getDirectoryManagerImpl().getGroupByName(groupName);
    }

    public Collection<Group> getGroupByUsername(String username) {
        return getDirectoryManagerImpl().getGroupByUsername(username);
    }

    public Collection<Group> getGroupList() {
        return getDirectoryManagerImpl().getGroupList();
    }

    public Collection<User> getUserByDepartmentId(String departmentId) {
        return getDirectoryManagerImpl().getUserByDepartmentId(departmentId);
    }

    public Collection<User> getUserByGradeId(String gradeId) {
        return getDirectoryManagerImpl().getUserByGradeId(gradeId);
    }

    public Collection<User> getUserByGroupId(String groupId) {
        return getDirectoryManagerImpl().getUserByGroupId(groupId);
    }

    public Collection<User> getUserByGroupName(String groupName) {
        return getDirectoryManagerImpl().getUserByGroupName(groupName);
    }

    public User getUserById(String userId) {
        return getDirectoryManagerImpl().getUserById(userId);
    }

    public Collection<User> getUserByOrganizationId(String orgaizationId) {
        return getDirectoryManagerImpl().getUserByOrganizationId(orgaizationId);
    }

    public User getUserByUsername(String username) {
        return getDirectoryManagerImpl().getUserByUsername(username);
    }

    public Collection<User> getUserList() {
        return getDirectoryManagerImpl().getUserList();
    }

    public boolean isUserInGroup(String username, String groupName) {
        return getDirectoryManagerImpl().isUserInGroup(username, groupName);
    }

    public Collection<Role> getUserRoles(String username) {
        return getDirectoryManagerImpl().getUserRoles(username);
    }

    public User getDepartmentHod(String departmentId) {
        return getDirectoryManagerImpl().getDepartmentHod(departmentId);
    }

    public Collection<User> getUserHod(String username) {
        return getDirectoryManagerImpl().getUserHod(username);
    }

    public Collection<User> getUserSubordinate(String username) {
        return getDirectoryManagerImpl().getUserSubordinate(username);
    }

    public Collection<User> getUserDepartmentUser(String username) {
        return getDirectoryManagerImpl().getUserDepartmentUser(username);
    }

    public Collection<User> getDepartmentUserByGradeId(String departmentId, String gradeId) {
        return getDirectoryManagerImpl().getDepartmentUserByGradeId(departmentId, gradeId);
    }

    public SetupManager getSetupManager() {
        return setupManager;
    }

    public void setSetupManager(SetupManager setupManager) {
        this.setupManager = setupManager;
    }

    public PluginManager getPluginManager() {
        return pluginManager;
    }

    public void setPluginManager(PluginManager pluginManager) {
        this.pluginManager = pluginManager;
    }

    public Collection<Group> getGroupList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        return getDirectoryManagerImpl().getGroupList(nameFilter, sort, desc, start, rows);
    }

    public Long getTotalGroups() {
        return getDirectoryManagerImpl().getTotalGroups();
    }

    public Collection<User> getUserList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        return getDirectoryManagerImpl().getUserList(nameFilter, sort, desc, start, rows);
    }

    public Long getTotalUsers() {
        return getDirectoryManagerImpl().getTotalUsers();
    }

    public Collection<Department> getDepartmentList() {
        return getDirectoryManagerImpl().getDepartmentList();
    }

    public Collection<Department> getDepartmentList(String sort, Boolean desc, Integer start, Integer rows) {
        return getDirectoryManagerImpl().getDepartmentList(sort, desc, start, rows);
    }

    public Collection<Department> getDepartmentListByOrganization(String organizationId, String sort, Boolean desc, Integer start, Integer rows) {
        return getDirectoryManagerImpl().getDepartmentListByOrganization(organizationId, sort, desc, start, rows);
    }

    public Long getTotalDepartments(String organizationId) {
        return getDirectoryManagerImpl().getTotalDepartments(organizationId);
    }

    public Collection<Grade> getGradeList() {
        return getDirectoryManagerImpl().getGradeList();
    }

    public Department getDepartmentById(String departmentId) {
        return getDirectoryManagerImpl().getDepartmentById(departmentId);
    }

    public Grade getGradeById(String gradeId) {
        return getDirectoryManagerImpl().getGradeById(gradeId);
    }
}
