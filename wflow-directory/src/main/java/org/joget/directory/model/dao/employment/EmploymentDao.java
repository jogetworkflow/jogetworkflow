package org.joget.directory.model.dao.employment;

import java.util.Collection;

import org.joget.directory.model.Employment;

public interface EmploymentDao {

    void addEmployee(Employment employment);

    void updateEmployee(Employment employment);

    Collection<Employment> getEmployeeList(String nameFilter,
            String sort, Boolean desc, Integer start, Integer rows);

    Long getTotalEmployments();

    Long getTotalEmploymentsByDepartmentId(String departmentId);

    Employment getEmployeeById(String employeeId);

    Collection<Employment> getEmployeeByUserId(String userId);

    Employment getEmployeeByCode(String employeeCode);

    Collection<Employment> getEmployeeByGrade(String gradeName,
            String sort, Boolean desc, Integer start, Integer rows);

    Collection<Employment> getEmployeeByDepartment(
            String departmentName, String sort, Boolean desc, Integer start,
            Integer rows);

    Collection<Employment> getAssignEmployeeList(String departmentId,
            String sort, Boolean desc, Integer start, Integer rows);

    Collection<Employment> getUnassignEmployeeList(String departmentId,
            String sort, Boolean desc, Integer start, Integer rows);

    Collection<Employment> getEmployeeByOrganization(
            String organizationName, String sort, Boolean desc, Integer start,
            Integer rows);

    Collection<Employment> getManagerList(String nameFilter,
            String sort, Boolean desc, Integer start, Integer rows);

    Collection<Employment> getManagerByDepartment(
            String departmentName, String sort, Boolean desc, Integer start,
            Integer rows);

    Collection<Employment> getManagerByOrganization(
            String organizationName, String sort, Boolean desc, Integer start,
            Integer rows);

    public void setUserAsEmployee(String employmentId, String userId);

    void assignEmployeeToDepartment(String employmentId, String departmentId);

    void assignEmployeeAsManager(String employmentId);

    void updateEmployeeGrade(String employmentId, String gradeId);

    void removeEmployeeFromDepartment(String employmentId, String departmentId);

    void removeEmployeeAsManager(String employmentId);

    void removeEmployee(Employment employment);
}
