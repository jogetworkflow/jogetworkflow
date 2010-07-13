package org.joget.directory.model.dao.organization;

import java.util.Collection;
import org.joget.directory.model.Organization;

public interface OrganizationDao {

    void addOrganization(Organization organization);

    void updateOrganization(Organization organization);

    public void assignParentToOrganization(String organizationId,
            String parentId);

    void deleteOrganization(String organizationId);

    Organization getOrganizationById(String organizationId);

    Organization getOrganizationByName(String organizationName);

    Long getTotalOrganizations();

    Collection<Organization> getOrganizationByParent(String parentId,
            String sort, Boolean desc, Integer start, Integer rows);

    Collection<Organization> getOrganizationList(String nameFilter,
            String sort, Boolean desc, Integer start, Integer rows);

    Collection<Organization> getOrganizationListByUser(String nameFilter,
            String sort, Boolean desc, Integer start, Integer rows);

    void removeParentFromOrganization(String parentId, String organizationId);
}
