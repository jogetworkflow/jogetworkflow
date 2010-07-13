package org.joget.directory.model.dao.group;

import java.util.Collection;
import java.util.List;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.Group;

public class GroupDaoImpl extends AbstractSpringDao implements GroupDao {

    public void addGroup(Group group) {
        save("Group", group);
    }

    public void updateGroup(Group group) {
        merge("Group", group);
    }

    public Collection<Group> getGroupList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }
        
        return find("Group", "where e.name like ? or e.description like ?",
                new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Collection<Group> getAssignGroups(String nameFilter, String userId, String sort, Boolean desc, Integer start, Integer rows) {
        nameFilter = "%" + nameFilter + "%";
        return find("Group", "where e.id not in (select g.id from Group g join g.users u where u.id = ?) and (e.name like ? or e.description like ?)", new Object[]{userId, nameFilter, nameFilter}, sort, desc, start, rows);
    }

    public Collection<Group> getUnAssignGroups(String nameFilter, String userId, String sort, Boolean desc, Integer start, Integer rows) {
        nameFilter = "%" + nameFilter + "%";
        return find("Group", "join e.users u where u.id = ? and (e.name like ? or e.description like ?)", new Object[]{userId, nameFilter, nameFilter}, sort, desc, start, rows);
    }

    public Group getGroupById(String groupId) {
        return (Group) find("Group", groupId);
    }

    public Group getGroupByName(String groupName) {
        Group group = new Group();
        group.setName(groupName);
        List groups = findByExample("Group", group);

        if (groups.size() > 0) {
            return (Group) groups.get(0);
        }

        return null;
    }

    public Collection<Group> getGroupByUserId(String userId, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Group", "JOIN e.users u WHERE u.id = ?", new String[]{userId}, sort, desc, start, rows);
    }

    public Collection<Group> getGroupByUsername(String username) {
        return find("Group", "JOIN e.users u WHERE u.username = ?", new String[]{username}, null, null, null, null);
    }

    public void deleteGroup(Group group) {
        delete("Group", group);
    }

    public Long getTotalGroups() {
        return count("Group", "", null);
    }

    public Long getTotalGroupsByUserId(String userId) {
        return count("Group", "e join e.users u where u.id=?", new Object[]{userId});
    }
}
