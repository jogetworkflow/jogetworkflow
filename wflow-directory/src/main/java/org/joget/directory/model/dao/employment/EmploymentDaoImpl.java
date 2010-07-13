package org.joget.directory.model.dao.employment;

import java.util.Collection;
import java.util.List;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.Department;
import org.joget.directory.model.Employment;
import org.joget.directory.model.Grade;
import org.joget.directory.model.User;
import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.dao.grade.GradeDao;
import org.joget.directory.model.dao.user.UserDao;

public class EmploymentDaoImpl extends AbstractSpringDao implements EmploymentDao {

    private UserDao userDao;
    private DepartmentDao departmentDao;
    private GradeDao gradeDao;

    public void addEmployee(Employment employment) {
        saveOrUpdate("Employment", employment);
    }

    public void updateEmployee(Employment employment) {
        saveOrUpdate("Employment", employment);
    }

    public Collection<Employment> getEmployeeList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }
        return find("Employment", "join e.user u where u.firstName like ? or u.lastName like ?", new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Long getTotalEmployments() {
        return count("Employment", "", null);
    }

    public Long getTotalEmploymentsByDepartmentId(String departmentId) {
        return count("Employment", "e join e.department d where d.id=?", new Object[]{departmentId});
    }

    public Employment getEmployeeById(String employeeId) {
        return (Employment) find("Employment", employeeId);
    }

    public Collection<Employment> getEmployeeByUserId(String userId) {
        return find("Employment", "join e.user u where u.id=?", new Object[]{userId}, null, null, null, null);
    }

    public Employment getEmployeeByCode(String employeeCode) {
        Employment employment = new Employment();
        employment.setEmployeeCode(employeeCode);
        List employmentList = findByExample("Employment", employment);
        if (employmentList.size() > 0) {
            return (Employment) employmentList.get(0);
        }
        return null;
    }

    public Collection<Employment> getEmployeeByGrade(String gradeName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Employment", "join e.grade g where g.name = ?", new Object[]{gradeName}, sort, desc, start, rows);
    }

    public Collection<Employment> getEmployeeByDepartment(String departmentName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Employment", "join e.department d where d.name = ?", new Object[]{departmentName}, sort, desc, start, rows);
    }

    public Collection<Employment> getAssignEmployeeList(String departmentId, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Employment", "group by e.userId having (e.department.id not in (select d.id from Department d where d.id=?) or e.department is null)" +
                " AND (e.user.id not in (select em.user.id from Employment em where em.department.id in " +
                "(select d.id from Department d where d.id=?)))", new Object[]{departmentId, departmentId}, sort, desc, start, rows);
    }

    public Collection<Employment> getUnassignEmployeeList(String departmentId, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Employment", "where e.department.id in (select d.id from Department d where d.id=?)", new Object[]{departmentId}, sort, desc, start, rows);
    }

    public Collection<Employment> getEmployeeByOrganization(String organizationName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Employment", "join e.grade g join g.organization o where o.name = ?",
                new Object[]{organizationName}, sort, desc, start, rows);
    }

    public Collection<Employment> getManagerList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }
        return find("Employment", "join e.user u where e.role=? and (u.firstName like ? or u.lastName like ?)", new Object[]{Employment.MANAGER, "%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Collection<Employment> getManagerByDepartment(String departmentName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Employment", "join e.department d where e.role=? and d.name=?", new Object[]{Employment.MANAGER, departmentName}, sort, desc, start, rows);
    }

    public Collection<Employment> getManagerByOrganization(String organizationName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Employment", "join e.department d join d.organization o where e.role=? and o.name=?", new Object[]{Employment.MANAGER, organizationName}, sort, desc, start, rows);
    }

    public void setUserAsEmployee(String employmentId, String userId) {
        User user = getUserDao().getUserById(userId);
        Employment employment = getEmployeeById(employmentId);

        user.getEmployments().add(employment);
        saveOrUpdate("Employment", employment);
    }

    public void assignEmployeeToDepartment(String employmentId, String departmentId) {
        Employment employment = getEmployeeById(employmentId);
        Department department = getDepartmentDao().getDepartmentById(departmentId);
        department.getEmployments().add(employment);
        saveOrUpdate("Employment", employment);
    }

    public void assignEmployeeAsManager(String employmentId) {
        Employment employment = getEmployeeById(employmentId);
        employment.setRole(Employment.MANAGER);
        saveOrUpdate("Employment", employment);
    }

    public void updateEmployeeGrade(String employmentId, String gradeId) {
        Employment employment = getEmployeeById(employmentId);
        Grade grade = getGradeDao().getGradeById(gradeId);

        grade.getEmployments().add(employment);
        saveOrUpdate("Employment", employment);
    }

    public void removeEmployeeFromDepartment(String employmentId, String departmentId) {
        Employment employment = getEmployeeById(employmentId);
        Department department = getDepartmentDao().getDepartmentById(departmentId);
        department.getEmployments().remove(employment);
        saveOrUpdate("Employment", employment);
    }

    public void removeEmployeeAsManager(String employmentId) {
        Employment employment = getEmployeeById(employmentId);
        employment.setRole(null);
        saveOrUpdate("Employment", employment);
    }

    public void removeEmployee(Employment employment) {
        delete("Employment", employment);
    }

    public UserDao getUserDao() {
        return userDao;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    public DepartmentDao getDepartmentDao() {
        return departmentDao;
    }

    public void setDepartmentDao(DepartmentDao departmentDao) {
        this.departmentDao = departmentDao;
    }

    public GradeDao getGradeDao() {
        return gradeDao;
    }

    public void setGradeDao(GradeDao gradeDao) {
        this.gradeDao = gradeDao;
    }
}
