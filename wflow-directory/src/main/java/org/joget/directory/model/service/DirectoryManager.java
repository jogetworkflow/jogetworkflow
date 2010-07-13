package org.joget.directory.model.service;

import org.joget.directory.model.Department;
import org.joget.directory.model.Grade;
import org.joget.directory.model.Group;
import org.joget.directory.model.Role;
import org.joget.directory.model.User;
import java.util.Collection;

public interface DirectoryManager {

    boolean authenticate(String username, String password);

    Group getGroupById(String groupId);

    Group getGroupByName(String groupName);

    Collection<Group> getGroupByUsername(String username);

    Collection<Group> getGroupList();

    Collection<Group> getGroupList(String nameFilter, String sort, Boolean desc, Integer start,
            Integer rows);

    Long getTotalGroups();

    Collection<User> getUserByDepartmentId(String departmentId);

    Collection<User> getUserByGradeId(String gradeId);

    Collection<User> getUserByGroupId(String groupId);

    Collection<User> getUserByGroupName(String groupName);

    User getUserById(String userId);

    Collection<User> getUserByOrganizationId(String orgaizationId);

    User getUserByUsername(String username);

    Collection<User> getUserList();

    Collection<User> getUserList(String nameFilter, String sort, Boolean desc, Integer start,
            Integer rows);

    Long getTotalUsers();

    boolean isUserInGroup(String username, String groupName);

    Collection<Role> getUserRoles(String username);

    User getDepartmentHod(String departmentId);

    Collection<User> getUserHod(String username);

    Collection<User> getUserSubordinate(String username);

    Collection<User> getUserDepartmentUser(String username);

    Collection<User> getDepartmentUserByGradeId(String departmentId,
            String gradeId);

    Department getDepartmentById(String departmentId);

    Collection<Department> getDepartmentList();

    Collection<Department> getDepartmentList(String sort, Boolean desc,
            Integer start, Integer rows);

    Collection<Department> getDepartmentListByOrganization(
            String organizationId, String sort, Boolean desc,
            Integer start, Integer rows);

    Long getTotalDepartments(String organizationId);

    Grade getGradeById(String gradeId);

    Collection<Grade> getGradeList();
}
