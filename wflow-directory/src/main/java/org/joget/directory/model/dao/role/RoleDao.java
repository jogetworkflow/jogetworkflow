package org.joget.directory.model.dao.role;

import org.joget.directory.model.Role;
import java.util.Collection;

public interface RoleDao {

    void addRole(Role role);

    void deleteRole(Role role);

    Role getRoleById(String roleId);

    Role getRoleByName(String roleName);

    Collection<Role> getRoleList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows);

    Collection<Role> getUserRoles(String username);
}
