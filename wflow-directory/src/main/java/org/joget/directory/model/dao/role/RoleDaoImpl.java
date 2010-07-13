package org.joget.directory.model.dao.role;

import java.util.Collection;
import java.util.List;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.Role;
import org.joget.directory.model.dao.user.UserDao;

public class RoleDaoImpl extends AbstractSpringDao implements RoleDao {

    private UserDao userDao;

    public void addRole(Role role) {
        save("Role", role);
    }

    public Collection<Role> getRoleList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }

        return find("Role", "where e.name like ? or e.description like ?",
                new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Role getRoleById(String roleId) {
        return (Role) find("Role", roleId);
    }

    public Role getRoleByName(String roleName) {
        Role role = new Role();
        role.setName(roleName);
        List roles = findByExample("Role", role);

        if (roles.size() > 0) {
            return (Role) roles.get(0);
        }
        
        return null;
    }

    public void deleteRole(Role role) {
        delete("Role", role);
    }

    public Collection<Role> getUserRoles(String username) {
        Collection<Role> roleList = find("Role", " INNER JOIN e.users u WHERE u.username=?", new Object[]{username}, null, null, null, null);
        return roleList;
    }

    public UserDao getUserDao() {
        return userDao;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }
}
