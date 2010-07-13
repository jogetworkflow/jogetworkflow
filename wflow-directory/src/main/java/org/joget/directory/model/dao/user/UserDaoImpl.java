package org.joget.directory.model.dao.user;

import java.util.Collection;
import java.util.List;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.Employment;
import org.joget.directory.model.Group;
import org.joget.directory.model.Role;
import org.joget.directory.model.User;
import org.joget.directory.model.dao.employment.EmploymentDao;
import org.joget.directory.model.dao.group.GroupDao;
import org.joget.directory.model.dao.role.RoleDao;

public class UserDaoImpl extends AbstractSpringDao implements UserDao {

    private GroupDao groupDao;
    private EmploymentDao employmentDao;
    private RoleDao roleDao;

    public void addUser(User user) {
        save("User", user);
    }

    public void updateUser(User user) {
        merge("User", user);
    }

    public Collection<User> getUserList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }

        return find("User", "WHERE e.firstName like ? or e.lastName like ? or e.username like ?", new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public User getUserById(String userId) {
        return (User) find("User", userId);
    }

    public User getUserByEmploymentId(String employmentId) {
        Collection<User> results = find("User", "JOIN e.employments m WHERE m.id = ?", new String[]{employmentId}, null, null, null, null);
        return (results.size() > 0) ? results.iterator().next() : null;
    }

    public User getUserByUsername(String username) {
        User user = new User();
        user.setUsername(username);
        user.setActive(1);
        List userList = findByExample("User", user);

        if (userList.size() > 0) {
            return (User) userList.get(0);
        }

        return null;
    }

    public User getInactiveUserByUsername(String username) {
        User user = new User();
        user.setUsername(username);
        user.setActive(0);
        List userList = findByExample("User", user);

        if (userList.size() > 0) {
            return (User) userList.get(0);
        }

        return null;
    }

    public Collection<User> getUserByName(String name) {
        return find("User", "WHERE e.firstName = ? or e.lastName = ?", new Object[]{name, name}, null, null, null, null);
    }

    public List getUserByFirstName(String firstName) {
        User user = new User();
        user.setFirstName(firstName);
        return findByExample("User", user);
    }

    public List getUserByLastName(String lastName) {
        User user = new User();
        user.setLastName(lastName);
        return findByExample("User", user);
    }

    public Collection<User> getUserByRole(String roleName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("User", "join e.roles r where r.name = ?", new Object[]{roleName}, sort, desc, start, rows);
    }

    public Collection<User> getUserByGroup(String groupName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("User", "join e.groups g where g.name = ?", new Object[]{groupName}, sort, desc, start, rows);
    }

    public Collection<User> getActiveUser(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }

        return find("User", "WHERE (e.firstName like ? or e.lastName like ?) and e.active=1", new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Collection<User> getInactiveUser(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }
        
        return find("User", "WHERE (e.firstName like ? or e.lastName like ?) and e.active=0", new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Collection<User> getAssignUsers(String nameFilter, String groupId, String sort, Boolean desc, Integer start, Integer rows) {
        nameFilter = "%" + nameFilter + "%";
        return find("User", "where e.id not in (select u.id from User u join u.groups g where g.id = ?) and (e.username like ? or e.firstName like ? or e.lastName like ?)", new Object[]{groupId, nameFilter, nameFilter, nameFilter}, sort, desc, start, rows);
    }

    public Collection<User> getUnAssignUsers(String nameFilter, String groupId, String sort, Boolean desc, Integer start, Integer rows) {
        nameFilter = "%" + nameFilter + "%";
        return find("User", "join e.groups g where g.id = ?  and (e.username like ? or e.firstName like ? or e.lastName like ?)", new Object[]{groupId, nameFilter, nameFilter, nameFilter}, sort, desc, start, rows);
    }

    public Collection<User> getUserByGroupId(String groupId, String sort, Boolean desc, Integer start, Integer rows) {
        return find("User", "join e.groups g where g.id=?", new Object[]{groupId}, sort, desc, start, rows);
    }

    public void setUserAsEmployee(String userId, String employeeId) {
        User user = getUserById(userId);
        Employment employment = getEmploymentDao().getEmployeeById(employeeId);
        user.getEmployments().add(employment);
        saveOrUpdate("User", user);
    }

    public void assignUserToGroup(String userId, String groupId) {
        User user = this.getUserById(userId);
        Group group = getGroupDao().getGroupById(groupId);

        user.getGroups().add(group);
        saveOrUpdate("User", user);
    }

    public void assignUserToRole(String userId, String roleId) {
        User user = this.getUserById(userId);
        Role role = getRoleDao().getRoleById(roleId);

        user.getRoles().add(role);
        saveOrUpdate("User", user);
    }

    public void removeUserAsEmployee(String userId, String employeeId) {
        User user = getUserById(userId);
        Employment employment = getEmploymentDao().getEmployeeById(employeeId);
        user.getEmployments().remove(employment);
        saveOrUpdate("User", user);
    }

    public void removeUserFromGroup(String userId, String groupId) {
        User user = this.getUserById(userId);
        Group group = getGroupDao().getGroupById(groupId);

        user.getGroups().remove(group);
        saveOrUpdate("User", user);
    }

    public void removeUserFromRole(String userId, String roleId) {
        User user = this.getUserById(userId);
        Role role = getRoleDao().getRoleById(roleId);

        user.getRoles().remove(role);
        saveOrUpdate("User", user);
    }

    public void deleteUser(User user) {
        delete("User", user);
    }

    public GroupDao getGroupDao() {
        return groupDao;
    }

    public void setGroupDao(GroupDao groupDao) {
        this.groupDao = groupDao;
    }

    public EmploymentDao getEmploymentDao() {
        return employmentDao;
    }

    public void setEmploymentDao(EmploymentDao employmentDao) {
        this.employmentDao = employmentDao;
    }

    public RoleDao getRoleDao() {
        return roleDao;
    }

    public void setRoleDao(RoleDao roleDao) {
        this.roleDao = roleDao;
    }

    public Long getTotalUsers() {
        return count("User", "", null);
    }

    public Long getTotalUsersByGroupId(String groupId) {
        return count("User", "e join e.groups g where g.id=?", new Object[]{groupId});
    }
}
