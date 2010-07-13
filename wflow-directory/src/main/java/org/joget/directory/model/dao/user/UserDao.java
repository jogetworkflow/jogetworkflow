package org.joget.directory.model.dao.user;

import java.util.Collection;
import java.util.List;

import org.joget.directory.model.User;

public interface UserDao {

    void addUser(User user);

    void setUserAsEmployee(String userId, String employeeId);

    void assignUserToGroup(String userId, String groupId);

    void assignUserToRole(String userId, String roleId);

    void deleteUser(User user);

    Collection<User> getActiveUser(String nameFilter, String sort,
            Boolean desc, Integer start, Integer rows);

    Collection<User> getInactiveUser(String nameFilter, String sort,
            Boolean desc, Integer start, Integer rows);

    User getUserByEmploymentId(String employmentId);

    List getUserByFirstName(String firstName);

    Collection<User> getUserByGroup(String groupName, String sort,
            Boolean desc, Integer start, Integer rows);

    User getUserById(String userId);

    List getUserByLastName(String lastName);

    Collection<User> getUserByName(String name);

    Collection<User> getUserByRole(String roleName, String sort,
            Boolean desc, Integer start, Integer rows);

    User getUserByUsername(String username);

    User getInactiveUserByUsername(String username);

    Collection<User> getUserList(String nameFilter, String sort,
            Boolean desc, Integer start, Integer rows);

    Collection<User> getAssignUsers(String nameFilter, String groupId, String sort,
            Boolean desc, Integer start, Integer rows);

    Collection<User> getUnAssignUsers(String nameFilter, String groupId, String sort,
            Boolean desc, Integer start, Integer rows);

    Collection<User> getUserByGroupId(String groupId, String sort,
            Boolean desc, Integer start, Integer rows);

    void removeUserAsEmployee(String userId, String employeeId);

    void removeUserFromGroup(String userId, String groupId);

    void removeUserFromRole(String userId, String roleId);

    void updateUser(User user);

    Long getTotalUsers();

    Long getTotalUsersByGroupId(String groupId);
}
