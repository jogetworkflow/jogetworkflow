package org.joget.directory.model.service;

import org.joget.directory.model.Department;
import org.joget.directory.model.Employment;
import org.joget.directory.model.Grade;
import org.joget.directory.model.Group;
import org.joget.directory.model.Organization;
import org.joget.directory.model.Role;
import org.joget.directory.model.User;
import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.dao.employment.EmploymentDao;
import org.joget.directory.model.dao.grade.GradeDao;
import org.joget.directory.model.dao.group.GroupDao;
import org.joget.directory.model.dao.organization.OrganizationDao;
import org.joget.directory.model.dao.role.RoleDao;
import org.joget.directory.model.dao.user.UserDao;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import org.joget.directory.model.EmploymentReportTo;

public class DirectoryManagerImpl implements DirectoryManager {

    private UserDao userDao;
    private GroupDao groupDao;
    private OrganizationDao organizationDao;
    private DepartmentDao departmentDao;
    private EmploymentDao employmentDao;
    private GradeDao gradeDao;
    private RoleDao roleDao;

    public boolean authenticate(String username, String password) {
        User user = getUserByUsername(username);
        boolean validLogin = (user != null && user.getPassword() != null && user.getPassword().equals(password));

        if(!validLogin){
            validLogin = (user != null && user.getPassword() != null && user.getLoginHash().equalsIgnoreCase(password));
        }

        if (!validLogin) {
            return false;
        } else {
            return true;
        }
    }

    public User getUserById(String userId) {
        return getUserDao().getUserById(userId);
    }

    public User getUserByUsername(String username) {
        return getUserDao().getUserByUsername(username);
    }

    public Group getGroupById(String groupId) {
        return getGroupDao().getGroupById(groupId);
    }

    public Group getGroupByName(String groupName) {
        return getGroupDao().getGroupByName(groupName);
    }

    public Collection<User> getUserList() {
        return getUserDao().getUserList(null, null, null, null, null);
    }

    public Collection<Group> getGroupList() {
        return getGroupDao().getGroupList(null, null, null, null, null);
    }

    public Collection<Group> getGroupByUsername(String username) {
        return getGroupDao().getGroupByUsername(username);
    }

    public boolean isUserInGroup(String username, String groupName) {
        Collection<User> users = getUserDao().getUserByGroup(groupName, null, null, null, null);

        for (User user : users) {
            if (user.getUsername().equals(username)) {
                return true;
            }
        }
        
        return false;
    }

    public Collection<User> getUserByGroupName(String groupName) {
        return getUserDao().getUserByGroup(groupName, null, null, null, null);
    }

    public Collection<User> getUserByGroupId(String groupId) {
        Group group = getGroupDao().getGroupById(groupId);
        return getUserDao().getUserByGroup(group.getName(), null, null, null, null);
    }

    public Collection<Role> getUserRoles(String username) {
        return getRoleDao().getUserRoles(username);
    }

    public Collection<User> getUserByDepartmentId(String departmentId) {
        Department department = getDepartmentDao().getDepartmentById(departmentId);
        Collection<Employment> employments = getEmploymentDao().getEmployeeByDepartment(department.getName(), null, null, null, null);

        //to make sure no duplicate user
        Set<User> users = new HashSet();
        for (Employment employment : employments) {
            User user = getUserDao().getUserByEmploymentId(employment.getId());
            users.add(user);
        }

        return users;
    }

    public Collection<User> getUserByOrganizationId(String orgaizationId) {
        Organization organization = getOrganizationDao().getOrganizationById(orgaizationId);
        Collection<Employment> employments = getEmploymentDao().getEmployeeByOrganization(organization.getName(), null, null, null, null);

        //to make sure no duplicate user
        Set<User> users = new HashSet();
        for (Employment employment : employments) {
            User user = getUserDao().getUserByEmploymentId(employment.getId());
            users.add(user);
        }

        return users;
    }

    public Collection<User> getUserByGradeId(String gradeId) {
        Grade grade = getGradeDao().getGradeById(gradeId);
        Collection<Employment> employments = getEmploymentDao().getEmployeeByGrade(grade.getName(), null, null, null, null);

        //to make sure no duplicate user
        Set<User> users = new HashSet();
        for (Employment employment : employments) {
            User user = getUserDao().getUserByEmploymentId(employment.getId());
            users.add(user);
        }

        return users;
    }

    public UserDao getUserDao() {
        return userDao;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    public GroupDao getGroupDao() {
        return groupDao;
    }

    public void setGroupDao(GroupDao groupDao) {
        this.groupDao = groupDao;
    }

    public OrganizationDao getOrganizationDao() {
        return organizationDao;
    }

    public void setOrganizationDao(OrganizationDao organizationDao) {
        this.organizationDao = organizationDao;
    }

    public DepartmentDao getDepartmentDao() {
        return departmentDao;
    }

    public void setDepartmentDao(DepartmentDao departmentDao) {
        this.departmentDao = departmentDao;
    }

    public EmploymentDao getEmploymentDao() {
        return employmentDao;
    }

    public void setEmploymentDao(EmploymentDao employmentDao) {
        this.employmentDao = employmentDao;
    }

    public GradeDao getGradeDao() {
        return gradeDao;
    }

    public void setGradeDao(GradeDao gradeDao) {
        this.gradeDao = gradeDao;
    }

    public User getDepartmentHod(String departmentId) {
        User hod = null;
        Department department = departmentDao.getDepartmentById(departmentId);
        if (department != null) {
            Employment hodEmpl = department.getHod();
            if (hodEmpl != null) {
                hod = hodEmpl.getUser();
            }
        }
        return hod;
    }

    public User getReportTo(String employmentId) {
        Employment employment = employmentDao.getEmployeeById(employmentId);

        return employment.getEmploymentReportTo().getReportTo().getUser();
    }

    public Collection<User> getUserHod(String username) {
        Collection<User> userList = new ArrayList();

        User user = getUserByUsername(username);
        Collection<Employment> userEmploymentList = user.getEmployments();

        for (Employment employment : userEmploymentList) {
            if (employment.getEmploymentReportTo() != null) {
                userList.add(getReportTo(employment.getId()));
            } else {
                Department dept = employment.getDepartment();
                User hod = getDepartmentHod(dept.getId());
                while (dept != null && (hod == null || (hod.getUsername() != null && username.equals(hod.getUsername())))) {
                    // no HOD or user is HOD, so look for HOD of parent department
                    dept = dept.getParent();
                    if (dept != null) {
                        hod = getDepartmentHod(dept.getId());
                    }
                }
                if (hod != null) {
                    userList.add(hod);
                }
            }
        }

        return userList;
    }

    public Collection<User> getUserSubordinate(String username) {
        Collection<User> userList = new ArrayList();

        User user = getUserByUsername(username);
        Collection<Employment> userEmploymentList = user.getEmployments();

        for (Employment employment : userEmploymentList) {
            Set<EmploymentReportTo> subordinateList = employment.getSubordinates();

            for(EmploymentReportTo employmentSubordinate : subordinateList){
                userList.add(employmentSubordinate.getSubordinate().getUser());
            }
            
            if(employment.getDepartmentId() != null && employment.getDepartmentId().trim().length() > 0){
                User hod = this.getDepartmentHod(employment.getDepartmentId());
                if(hod.getUsername().equals(username)){
                    Collection<User> departmentUserList = this.getUserByDepartmentId(employment.getDepartmentId());
                    for(User departmentUser : departmentUserList){
                        if(!userList.contains(departmentUser) && !departmentUser.getUsername().equals(username)){
                            userList.add(departmentUser);
                        }
                    }
                }
            }
        }
        
        return userList;
    }

    public Collection<User> getUserDepartmentUser(String username) {
        Collection<User> userList = new ArrayList();

        User user = getUserByUsername(username);
        Collection<Employment> userEmploymentList = user.getEmployments();

        for (Employment employment : userEmploymentList) {
            userList.addAll(getUserByDepartmentId(employment.getDepartment().getId()));
        }

        return userList;
    }

    public Collection<User> getDepartmentUserByGradeId(String departmentId, String gradeId) {
        Collection<User> userList = new ArrayList();

        Department department = departmentDao.getDepartmentById(departmentId);
        Collection<Employment> employmentList = department.getEmployments();
        for (Employment employment : employmentList) {
            if (gradeId.equals(employment.getGrade().getId())) {
                userList.add(employment.getUser());
            }
        }

        return userList;
    }

    public Collection<Group> getGroupList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        return groupDao.getGroupList(nameFilter, sort, desc, start, rows);
    }

    public Collection<User> getUserList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        return userDao.getUserList(nameFilter, sort, desc, start, rows);
    }

    public Collection<Department> getDepartmentList() {
        return departmentDao.getDepartmentList("", null, null, null, null);
    }

    public Collection<Department> getDepartmentList(String sort, Boolean desc, Integer start, Integer rows) {
        return departmentDao.getDepartmentList("", sort, desc, start, rows);
    }

    public Collection<Department> getDepartmentListByOrganization(String organizationId, String sort, Boolean desc, Integer start, Integer rows) {
        Collection<Department> departmentList = new ArrayList<Department>();

        if (organizationId != null && organizationId.trim().length() != 0) {
            departmentList = departmentDao.getDepartmentByOrganizationId(organizationId, sort, desc, start, rows);
        } else {
            departmentList = departmentDao.getDepartmentList("", sort, desc, start, rows);
        }

        return departmentList;
    }

    public Collection<Grade> getGradeList() {
        return gradeDao.getGradeList("", null, null, null, null);
    }

    public Long getTotalGroups() {
        return groupDao.getTotalGroups();
    }

    public Long getTotalUsers() {
        return userDao.getTotalUsers();
    }

    public Long getTotalDepartments(String organizationId) {
        if (organizationId != null && organizationId.trim().length() > 0) {
            return departmentDao.getTotalParentDepartmentsByOrganizationId(organizationId);
        } else {
            return departmentDao.getTotalParentDepartments();
        }
    }

    public Department getDepartmentById(String departmentId) {
        return departmentDao.getDepartmentById(departmentId);
    }

    public Grade getGradeById(String gradeId) {
        return gradeDao.getGradeById(gradeId);
    }

    /**
     * @return the roleDao
     */
    public RoleDao getRoleDao() {
        return roleDao;
    }

    /**
     * @param roleDao the roleDao to set
     */
    public void setRoleDao(RoleDao roleDao) {
        this.roleDao = roleDao;
    }
}
