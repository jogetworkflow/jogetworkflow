package org.joget.directory.model.dao.department;

import java.util.Collection;

import org.joget.directory.model.Department;

public interface DepartmentDao {

    void addDepartment(Department department);

    void updateDepartment(Department department);

    Collection<Department> getDepartmentList(String nameFilter,
            String sort, Boolean desc, Integer start, Integer rows);

    Long getTotalParentDepartmentsByOrganizationId(String organizationId);

    Long getTotalDepartmentsByOrganizationId(String organizationId);

    Long getTotalParentDepartments();

    Long getTotalSubDepartmentsByParentId(String parentId);

    Department getDepartmentById(String departmentId);

    Department getDepartmentByName(String departmentName);

    Collection<Department> getDepartmentByOrganization(
            String organizationName, String sort, Boolean desc, Integer start,
            Integer rows);

    Collection<Department> getDepartmentByOrganizationId(
            String organizationId, String sort, Boolean desc, Integer start,
            Integer rows);

    Collection<Department> getRecursiveDepartmentByOrganizationId(
            String organizationId);

    Collection<Department> getDepartmentByParent(
            String parentId, String sort, Boolean desc, Integer start,
            Integer rows);

    public void assignParentToDepartment(String departmentId,
            String parentId);

    void addDepartmentToOrganization(String departmentId,
            String organizationId);

    public void removeParentFromDepartment(String departmentId,
            String parentId);

    void removeDepartmentFromOrganization(String departmentId,
            String organizationId);

    void deleteDepartment(String departmentId);
}
