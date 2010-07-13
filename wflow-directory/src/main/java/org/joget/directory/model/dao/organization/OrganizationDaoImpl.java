package org.joget.directory.model.dao.organization;

import java.util.Collection;
import java.util.List;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.Department;
import org.joget.directory.model.Grade;
import org.joget.directory.model.Organization;
import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.dao.grade.GradeDao;
import java.util.Set;

public class OrganizationDaoImpl extends AbstractSpringDao implements OrganizationDao {

    private GradeDao gradeDao;
    private DepartmentDao departmentDao;

    public void addOrganization(Organization organization) {
        save("Organization", organization);
    }

    public void updateOrganization(Organization organization) {
        merge("Organization", organization);
    }

    public Collection<Organization> getOrganizationList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }

        return find("Organization", "where e.name like ? or e.description like ?",
                new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Collection<Organization> getOrganizationListByUser(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }

        return find("Organization", "where e.id IN " +
                "(select grade.organization.id from Organization e join e.grades grade join grade.employments em join em.user u where u.firstName like ? or u.lastName like ?) " +
                "or e.id IN " +
                "(select department.organization.id from Organization e join e.departments department join department.employments em join em.user u where u.firstName like ? or u.lastName like ?)",
                new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%", "%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Long getTotalOrganizations() {
        return count("Organization", "", null);
    }

    public Organization getOrganizationById(String organizationId) {
        return (Organization) find("Organization", organizationId);
    }

    public Organization getOrganizationByName(String organizationName) {
        Organization organization = new Organization();
        organization.setName(organizationName);
        List organizations = findByExample("Organization", organization);

        if (organizations.size() > 0) {
            return (Organization) organizations.get(0);
        }

        return null;
    }

    public Collection<Organization> getOrganizationByParent(String parentId, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Organization", "where e.parentId = ?", new Object[]{parentId}, sort, desc, start, rows);
    }

    public void assignParentToOrganization(String organizationId, String parentId) {
        Organization parent = this.getOrganizationById(parentId);
        Organization organization = this.getOrganizationById(organizationId);

        parent.getChildrens().add(organization);
        saveOrUpdate("Organization", organization);
    }

    public void removeParentFromOrganization(String parentId, String organizationId) {
        Organization parent = this.getOrganizationById(parentId);
        Organization organization = this.getOrganizationById(organizationId);

        parent.getChildrens().remove(organization);
        saveOrUpdate("Organization", organization);
    }

    public void deleteOrganization(String organizationId) {
        Organization organization = getOrganizationById(organizationId);
        Set<Department> departments = organization.getDepartments();
        Set<Grade> grades = organization.getGrades();

        for (Department department : departments) {
            getDepartmentDao().deleteDepartment(department.getId());
        }

        for (Grade grade : grades) {
            gradeDao.deleteGrade(grade);
        }
        
        delete("Organization", organization);
    }

    public GradeDao getGradeDao() {
        return gradeDao;
    }

    public void setGradeDao(GradeDao gradeDao) {
        this.gradeDao = gradeDao;
    }

    public DepartmentDao getDepartmentDao() {
        return departmentDao;
    }

    public void setDepartmentDao(DepartmentDao departmentDao) {
        this.departmentDao = departmentDao;
    }
}
