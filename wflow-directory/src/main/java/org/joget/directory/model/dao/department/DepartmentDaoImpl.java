package org.joget.directory.model.dao.department;

import java.util.Collection;
import java.util.List;
import java.util.Set;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.Department;
import org.joget.directory.model.Employment;
import org.joget.directory.model.Organization;
import org.joget.directory.model.dao.employment.EmploymentDao;
import org.joget.directory.model.dao.organization.OrganizationDao;
import java.util.ArrayList;

public class DepartmentDaoImpl extends AbstractSpringDao implements DepartmentDao {

    private OrganizationDao organizationDao;
    private EmploymentDao employmentDao;

    public void addDepartment(Department department) {
        save("Department", department);
    }

    public void updateDepartment(Department department) {
        merge("Department", department);
    }

    public Collection<Department> getDepartmentList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }

        return find("Department", "where e.name like ? or e.description like ?", new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Long getTotalParentDepartmentsByOrganizationId(String organizationId) {
        return count("Department", "e join e.organization o where e.parent is null and o.id=?", new Object[]{organizationId});
    }

    public Long getTotalDepartmentsByOrganizationId(String organizationId){
        return count("Department", "e join e.organization o where o.id = ?", new Object[]{organizationId});
    }

    public Long getTotalParentDepartments() {
        return count("Department", "", null);
    }

    public Long getTotalSubDepartmentsByParentId(String parentId) {
        return count("Department", "e where parentId = ?", new Object[]{parentId});
    }

    public Department getDepartmentById(String departmentId) {
        return (Department) find("Department", departmentId);
    }

    public Department getDepartmentByName(String departmentName) {
        Department department = new Department();
        department.setName(departmentName);
        List departments = findByExample("Department", department);
        
        if (departments.size() > 0) {
            return (Department) departments.get(0);
        }

        return null;
    }

    public Collection<Department> getDepartmentByOrganization(String organizationName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Department", "join e.organization o where o.name=?", new Object[]{organizationName}, sort, desc, start, rows);
    }

    public Collection<Department> getDepartmentByOrganizationId(String organizationId, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Department", "join e.organization o where o.id=?", new Object[]{organizationId}, sort, desc, start, rows);
    }

    public Collection<Department> getRecursiveDepartmentByOrganizationId(String organizationId) {
        Collection<Department> departmentList = getDepartmentByOrganization(
                organizationDao.getOrganizationById(organizationId).getName(), null, null, null, null);

        List<Department> departments = new ArrayList<Department>();

        for (Department department : departmentList) {
            if (department.getParent() == null && !departments.contains(department)) {
                departments = subdepartmentByParent(departments, department);
            }
        }

        return departments;
    }

    private List<Department> subdepartmentByParent(List<Department> departments, Department dept) {
        if (dept.getChildrens() == null) {
            return departments;
        } else {
            departments.add(dept);
            for (Department deptObj : dept.getChildrens()) {
                subdepartmentByParent(departments, deptObj);
            }
        }

        return departments;
    }

    public Collection<Department> getDepartmentByParent(String parentId, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Department", "where e.parent.id = ?", new Object[]{parentId}, sort, desc, start, rows);
    }

    public void assignParentToDepartment(String departmentId, String parentId) {
        Department department = getDepartmentById(departmentId);
        Department parent = getDepartmentById(parentId);
        parent.getChildrens().add(department);
        saveOrUpdate("Department", department);
    }

    public void addDepartmentToOrganization(String departmentId, String organizationId) {
        Department parent = getDepartmentById(departmentId);
        Set<Department> childrens = parent.getChildrens();
        Organization organization = organizationDao.getOrganizationById(organizationId);
        organization.getDepartments().add(parent);

        if (childrens != null) {
            for (Department child : childrens) {
                organization.getDepartments().add(child);
            }
        }

        saveOrUpdate("Department", parent);
    }

    public void removeParentFromDepartment(String departmentId, String parentId) {
        Department department = getDepartmentById(departmentId);
        Department parent = getDepartmentById(parentId);
        parent.getChildrens().remove(department);
        saveOrUpdate("Department", department);
    }

    public void removeDepartmentFromOrganization(String departmentId, String organizationId) {
        Department parent = getDepartmentById(departmentId);
        Set<Department> childrens = parent.getChildrens();
        Organization organization = organizationDao.getOrganizationById(organizationId);
        organization.getDepartments().remove(parent);

        for (Department child : childrens) {
            organization.getDepartments().remove(child);
        }

        saveOrUpdate("Department", parent);
    }

    public void deleteDepartment(String departmentId) {
        Department department = getDepartmentById(departmentId);
        Set<Department> childs = department.getChildrens();
        Set<Employment> employments = department.getEmployments();

        for (Department child : childs) {
            delete("Department", child);
        }

        for (Employment employment : employments) {
            getEmploymentDao().removeEmployee(employment);
        }
        
        delete("Department", department);
    }

    public OrganizationDao getOrganizationDao() {
        return organizationDao;
    }

    public void setOrganizationDao(OrganizationDao organizationDao) {
        this.organizationDao = organizationDao;
    }

    public EmploymentDao getEmploymentDao() {
        return employmentDao;
    }

    public void setEmploymentDao(EmploymentDao employmentDao) {
        this.employmentDao = employmentDao;
    }
}
