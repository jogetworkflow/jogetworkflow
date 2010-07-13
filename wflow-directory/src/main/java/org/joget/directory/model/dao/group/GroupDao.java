package org.joget.directory.model.dao.group;

import java.util.Collection;

import org.joget.directory.model.Group;

public interface GroupDao {

    void addGroup(Group group);

    void updateGroup(Group group);

    Collection<Group> getGroupList(String nameFilter, String sort,
            Boolean desc, Integer start, Integer rows);

    Collection<Group> getAssignGroups(String nameFilter, String userId, String sort,
            Boolean desc, Integer start, Integer rows);

    Collection<Group> getUnAssignGroups(String nameFilter, String userId, String sort,
            Boolean desc, Integer start, Integer rows);

    Group getGroupById(String groupId);

    Group getGroupByName(String groupName);

    Collection<Group> getGroupByUserId(String userId, String sort,
            Boolean desc, Integer start, Integer rows);

    Collection<Group> getGroupByUsername(String userId);

    void deleteGroup(Group group);

    Long getTotalGroups();

    Long getTotalGroupsByUserId(String userId);
}
