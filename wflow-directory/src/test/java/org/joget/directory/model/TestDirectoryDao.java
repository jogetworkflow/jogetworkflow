package org.joget.directory.model;

import org.joget.directory.model.Group;
import org.joget.directory.model.Department;
import org.joget.directory.model.Grade;
import org.joget.directory.model.User;
import org.joget.directory.model.Employment;
import org.joget.directory.model.Role;
import org.joget.directory.model.Organization;
import org.joget.commons.util.LogUtil;
import java.util.Collection;
import java.util.Date;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.SessionHolder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.util.Assert;

import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.dao.employment.EmploymentDao;
import org.joget.directory.model.dao.grade.GradeDao;
import org.joget.directory.model.dao.group.GroupDao;
import org.joget.directory.model.dao.organization.OrganizationDao;
import org.joget.directory.model.dao.role.RoleDao;
import org.joget.directory.model.dao.user.UserDao;
import java.util.ArrayList;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:directoryApplicationContext.xml"})
public class TestDirectoryDao {

    @Autowired
    private SessionFactory sessionFactory;

    @Autowired
    private OrganizationDao organizationDao;

    @Autowired
    private DepartmentDao departmentDao;

    @Autowired
    private GradeDao gradeDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private EmploymentDao employmentDao;

    @Autowired
    private GroupDao groupDao;
    
    @Autowired
    private RoleDao roleDao;

    @Before
    public void setUp() throws Exception {
        Session s = sessionFactory.openSession();
        TransactionSynchronizationManager.bindResource(sessionFactory, new SessionHolder(s));
    }

    @After
    public void tearDown() throws Exception {
        SessionHolder holder = (SessionHolder) TransactionSynchronizationManager.getResource(sessionFactory);
        Session s = holder.getSession();
        s.flush();
        TransactionSynchronizationManager.unbindResource(sessionFactory);
        SessionFactoryUtils.closeSession(s);
    }

    //@Test
    public void testSuite() {
        testAddOrganizationParent();
    }

    /******************************************************************************************
     * Stage 1: Insert and accessibility control (update)
     * Insert parent organization
     */
    @Test
    public void testAddOrganizationParent() {
        LogUtil.info(getClass().getName(), "1");
        Organization organizationParent = new Organization();
        organizationParent.setId("Parent");
        organizationParent.setName("Parent");
        organizationParent.setDescription("Parent");

        organizationDao.addOrganization(organizationParent);

        Assert.notNull((Organization) organizationDao.getOrganizationById(organizationParent.getId()));
    }

    /**
     * Insert child organization
     */
    @Test
    public void testAddOrganizationChild() {
        LogUtil.info(getClass().getName(), "2");
        Organization organizationChild = new Organization();
        organizationChild.setId("Child");
        organizationChild.setName("Child");
        organizationChild.setDescription("Child");
        organizationDao.addOrganization(organizationChild);

        Assert.notNull((Organization) organizationDao.getOrganizationById(organizationChild.getId()));
    }

    /**
     * Assign parent organization to child organization
     */
    @Test
    public void testAssignParentToOrganization() {
        LogUtil.info(getClass().getName(), "3");
        Organization parent = organizationDao.getOrganizationByName("Parent");
        Organization child = organizationDao.getOrganizationByName("Child");
        organizationDao.assignParentToOrganization(child.getId(), parent.getId());

        Organization getParent = organizationDao.getOrganizationById(parent.getId());

        Assert.isTrue(((Organization) getParent.getChildrens().iterator().next()).getId().equals(child.getId()));
    }

    /**
     * Insert parent department
     */
    @Test
    public void testAddDepartmentParent() {
        LogUtil.info(getClass().getName(), "4");
        Department departmentParent = new Department();
        departmentParent.setId("Parent");
        departmentParent.setName("Parent");
        departmentParent.setDescription("Parent");

        departmentDao.addDepartment(departmentParent);

        Assert.notNull((Department) departmentDao.getDepartmentById(departmentParent.getId()));
    }

    /**
     * Insert child department
     */
    @Test
    public void testAddDepartmentChild() {
        LogUtil.info(getClass().getName(), "5");
        Department departmentChild = new Department();
        departmentChild.setId("Child");
        departmentChild.setName("Child");
        departmentChild.setDescription("Child");
        departmentDao.addDepartment(departmentChild);

        Assert.notNull((Department) departmentDao.getDepartmentById(departmentChild.getId()));
    }

    /**
     * Assign parent department to child department
     */
    @Test
    public void testAssignParentToDepartment() {
        LogUtil.info(getClass().getName(), "6");
        Department parent = departmentDao.getDepartmentByName("Parent");
        Department child = departmentDao.getDepartmentByName("Child");
        departmentDao.assignParentToDepartment(child.getId(), parent.getId());

        Department getParent = departmentDao.getDepartmentById(parent.getId());

        Assert.isTrue(((Department) getParent.getChildrens().iterator().next()).getId().equals(child.getId()));
    }

    /**
     * Assign department to organization
     */
    @Test
    public void testAssignDepartmentToOrganization() {
        LogUtil.info(getClass().getName(), "7");
        Department parent = departmentDao.getDepartmentByName("Parent");
        Organization organization = organizationDao.getOrganizationByName("Parent");
        departmentDao.addDepartmentToOrganization(parent.getId(), organization.getId());

        Assert.isTrue(parent.getChildrens().size() > 0);
    }

    @Test
    public void testRecursive() {
        Collection<Department> departmentList = departmentDao.getDepartmentByOrganization(organizationDao.getOrganizationById("Parent").getName(), null, null, null, null);

        List<Department> departments = new ArrayList<Department>();

        for (Department department : departmentList) {
            if (department.getParent() == null && !departments.contains(department)) {
                departments = subdepartmentByParent(departments, department);
            }
        }

        Assert.isTrue(true);
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

    /**
     * 
     */
    @Test
    public void testUpdateOrganization() {
        LogUtil.info(getClass().getName(), "8");
        Collection departmentList = departmentDao.getDepartmentByOrganization("Parent", null, null, null, null);

        Organization organization = organizationDao.getOrganizationByName("Parent");
        organization.setDescription("Updated Description");
        organizationDao.updateOrganization(organization);

        Organization newOrganization = organizationDao.getOrganizationByName("Parent");
        Collection<Department> newDepartmentList = departmentDao.getDepartmentByOrganization("Parent", null, null, null, null);
        LogUtil.info(getClass().getName(), "  -- description: " + newOrganization.getDescription());
        LogUtil.info(getClass().getName(), "  -- departments: ");
        for (Department d : newDepartmentList) {
            LogUtil.info(getClass().getName(), ", " + d.getName());
        }

        Assert.isTrue("Updated Description".equals(newOrganization.getDescription()) && departmentList.size() == newDepartmentList.size() && departmentList.size() > 0);

    }

    /**
     * Insert grade
     */
    @Test
    public void testAddGrade() {
        LogUtil.info(getClass().getName(), "9");
        Grade grade = new Grade();
        grade.setId("Grade");
        grade.setName("Grade");
        grade.setDescription("Grade");

        gradeDao.addGrade(grade);

        Assert.notNull((Grade) gradeDao.getGradeById(grade.getId()));
    }

    /**
     * Add grade to organization
     */
    @Test
    public void testAssignGradeToOrganization() {
        LogUtil.info(getClass().getName(), "10");
        Grade grade = gradeDao.getGradeByName("Grade");
        Organization organization = organizationDao.getOrganizationByName("Parent");

        gradeDao.addGradeToOrganization(grade.getId(), organization.getId());

        Assert.notNull(((Grade) organization.getGrades().iterator().next()).getId());
    }

    /**
     * Insert employment
     */
    @Test
    public void testAddEmployment() {
        LogUtil.info(getClass().getName(), "11");
        Employment employment = new Employment();
        employment.setStartDate(new Date());
        employment.setEndDate(new Date());
        employment.setEmployeeCode("12345");

        employmentDao.addEmployee(employment);

        Employment getEmployment = employmentDao.getEmployeeById(employment.getId());

        Assert.notNull(getEmployment);
    }

    /**
     * Update employee grade
     */
    @Test
    public void testUpdateEmployeeGrade() {
        LogUtil.info(getClass().getName(), "12");
        Employment employment = employmentDao.getEmployeeByCode("12345");
        Grade grade = gradeDao.getGradeByName("Grade");
        employmentDao.updateEmployeeGrade(employment.getId(), grade.getId());

        Assert.isTrue(grade.getEmployments().size() > 0);
    }

    /**
     * Assign employment to department
     */
    @Test
    public void testAssignEmploymentToDepartment() {
        LogUtil.info(getClass().getName(), "13");
        Employment employment = employmentDao.getEmployeeByCode("12345");
        Department department = departmentDao.getDepartmentByName("Parent");
        employmentDao.assignEmployeeToDepartment(employment.getId(), department.getId());

        Assert.isTrue(department.getEmployments().size() > 0);
    }

    /**
     * Set employee as manager
     */
    @Test
    public void testSetEmployeeAsManager() {
        LogUtil.info(getClass().getName(), "14");
        Employment employment = employmentDao.getEmployeeByCode("12345");
        employmentDao.assignEmployeeAsManager(employment.getId());
        Employment getEmployment = employmentDao.getEmployeeById(employment.getId());

        Assert.isTrue(getEmployment.getRole().equals("Manager"));
    }

    /**
     * Insert active user
     */
    @Test
    public void testAddActiveUser() {
        LogUtil.info(getClass().getName(), "15");
        User user = new User();
        user.setUsername("ActiveUsername");
        user.setId(user.getUsername());
        user.setPassword("password");
        user.setFirstName("First");
        user.setLastName("Last");
        user.setActive(new Integer(1));
        user.setEmail("test@domain");

        userDao.addUser(user);

        User getUser = userDao.getUserById(user.getId());

        Assert.notNull(getUser);
    }

    /**
     * Insert inactive user
     */
    @Test
    public void testAddInActiveUser() {
        LogUtil.info(getClass().getName(), "16");
        User user = new User();
        user.setUsername("InactiveUsername");
        user.setId(user.getUsername());
        user.setPassword("password");
        user.setFirstName("First");
        user.setLastName("Last");
        user.setActive(new Integer(0));
        user.setEmail("test@domain");

        userDao.addUser(user);

        User getUser = userDao.getUserById(user.getId());

        Assert.notNull(getUser);
    }

    /**
     * Set user as employment
     */
    @Test
    public void testSetUserAsEmployee() {
        LogUtil.info(getClass().getName(), "17");
        User user = userDao.getUserByUsername("ActiveUsername");
        Employment employment = employmentDao.getEmployeeByCode("12345");

        userDao.setUserAsEmployee(user.getId(), employment.getId());

        Assert.isTrue(user.getEmployments().size() > 0);
    }

    /**
     * Insert group
     */
    @Test
    public void testAddGroup() {
        LogUtil.info(getClass().getName(), "18");
        Group group = new Group();
        group.setId("Group");
        group.setName("Group");
        group.setDescription("Group");

        groupDao.addGroup(group);

        Group getGroup = groupDao.getGroupById(group.getId());

        Assert.notNull(getGroup);
    }

    /**
     * Insert role
     */
    @Test
    public void testAddRole() {
        LogUtil.info(getClass().getName(), "19");
        Role role = new Role();
        role.setName("Role");
        role.setDescription("Role");

        roleDao.addRole(role);

        Role getRole = roleDao.getRoleById(role.getId());

        Assert.notNull(getRole);
    }

    /**
     * Assign user to group
     */
    @Test
    public void testAssignUserToGroup() {
        LogUtil.info(getClass().getName(), "20");
        User user = userDao.getUserByUsername("ActiveUsername");
        Group group = groupDao.getGroupByName("Group");
        userDao.assignUserToGroup(user.getId(), group.getId());

        Assert.isTrue(user.getGroups().size() > 0);
    }

    /**
     * Assign user to role
     ***************************************************************************/
    @Test
    public void testAssignUserToRole() {
        LogUtil.info(getClass().getName(), "21");
        User user = userDao.getUserByUsername("ActiveUsername");
        Role role = roleDao.getRoleByName("Role");
        userDao.assignUserToRole(user.getId(), role.getId());

        Assert.isTrue(user.getRoles().size() > 0);
    }

    /******************************************************************************************
     * Stage 2: Get records
     * Get user list
     */
    @Test
    public void testGetUserListByName() {
        LogUtil.info(getClass().getName(), "22");
        Collection users = userDao.getUserList("First", null, null, null, null);

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get user by id
     */
    @Test
    public void testGetUserById() {
        LogUtil.info(getClass().getName(), "23");
        Collection users = userDao.getUserList("First", null, null, null, null);

        User user = userDao.getUserById(((User) users.iterator().next()).getId());

        Assert.notNull(user);
    }

    /**
     * Get user by user name
     */
    @Test
    public void testGetUserByUsername() {
        LogUtil.info(getClass().getName(), "24");
        User user = userDao.getUserByUsername("ActiveUsername");

        Assert.notNull(user);
    }

    /**
     * Get user by name
     */
    @Test
    public void testGetUserByName() {
        LogUtil.info(getClass().getName(), "25");
        Collection users = userDao.getUserByName("First");

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get user by first name
     */
    @Test
    public void testGetUserByFirstName() {
        LogUtil.info(getClass().getName(), "26");
        Collection users = userDao.getUserByFirstName("First");

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get user by last name
     */
    @Test
    public void testGetUserByLastName() {
        LogUtil.info(getClass().getName(), "27");
        Collection users = userDao.getUserByLastName("Last");

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get user by role
     */
    @Test
    public void testGetUserByRole() {
        LogUtil.info(getClass().getName(), "28");
        Collection users = userDao.getUserByRole("Role", null, null, null, null);

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get user by group
     */
    @Test
    public void testGetUserByGroup() {
        LogUtil.info(getClass().getName(), "29");
        Collection users = userDao.getUserByGroup("Group", null, null, null, null);

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get active user
     */
    @Test
    public void testGetActiveUser() {
        LogUtil.info(getClass().getName(), "30");
        Collection users = userDao.getActiveUser("First", null, null, null, null);

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get inactive user
     */
    @Test
    public void testGetInActiveUser() {
        LogUtil.info(getClass().getName(), "31");
        Collection users = userDao.getInactiveUser("First", null, null, null, null);

        Assert.isTrue(users.size() > 0);
    }

    /**
     * Get group list
     */
    @Test
    public void testGetGroupList() {
        LogUtil.info(getClass().getName(), "32");
        Collection groups = groupDao.getGroupList("Group", null, null, null, null);

        Assert.isTrue(groups.size() > 0);
    }

    /**
     * Get group by id
     */
    @Test
    public void testGetGroupById() {
        LogUtil.info(getClass().getName(), "33");
        Collection groups = groupDao.getGroupList("Group", null, null, null, null);

        Group group = groupDao.getGroupById(((Group) groups.iterator().next()).getId());

        Assert.notNull(group);
    }

    /**
     * Get group by name
     */
    @Test
    public void testGetGroupByName() {
        LogUtil.info(getClass().getName(), "34");
        Group group = groupDao.getGroupByName("Group");

        Assert.notNull(group);
    }

    /**
     * Get role list
     */
    @Test
    public void testGetRoleList() {
        LogUtil.info(getClass().getName(), "35");
        Collection roles = roleDao.getRoleList("Role", null, null, null, null);

        Assert.isTrue(roles.size() > 0);
    }

    /**
     * Get role by id
     */
    @Test
    public void testGetRoleById() {
        LogUtil.info(getClass().getName(), "36");
        Collection roles = roleDao.getRoleList("Role", null, null, null, null);

        Role role = roleDao.getRoleById(((Role) roles.iterator().next()).getId());

        Assert.notNull(role);
    }

    /**
     * Get role by name
     */
    @Test
    public void testGetRoleByName() {
        LogUtil.info(getClass().getName(), "37");
        Role role = roleDao.getRoleByName("Role");

        Assert.notNull(role);
    }

    /**
     * Get employee list
     */
    @Test
    public void testGetEmployeeList() {
        LogUtil.info(getClass().getName(), "38");
        Collection employments = employmentDao.getEmployeeList("First", null, null, null, null);

        Assert.isTrue(employments.size() > 0);
    }

    /**
     * Get employee by id
     */
    @Test
    public void testGetEmployeeById() {
        LogUtil.info(getClass().getName(), "39");
        Collection employments = employmentDao.getEmployeeList("First", null, null, null, null);

        Employment employment = employmentDao.getEmployeeById(((Employment) employments.iterator().next()).getId());

        Assert.notNull(employment);
    }

    /**
     * Get employee by code
     */
    @Test
    public void testGetEmployeeByCode() {
        LogUtil.info(getClass().getName(), "40");
        Employment employment = employmentDao.getEmployeeByCode("12345");

        Assert.notNull(employment);
    }

    /**
     * Get employee by grade
     */
    @Test
    public void testGetEmployeeByGrade() {
        LogUtil.info(getClass().getName(), "41");
        Collection employments = employmentDao.getEmployeeByGrade("Grade", null, null, null, null);

        Assert.isTrue(employments.size() > 0);
    }

    /**
     * Get employee by department
     */
    @Test
    public void testGetEmployeeByDepartment() {
        LogUtil.info(getClass().getName(), "42");
        Collection employments = employmentDao.getEmployeeByDepartment("Parent", null, null, null, null);

        Assert.isTrue(employments.size() > 0);
    }

    /**
     * Get employee by organization
     */
    @Test
    public void testGetEmployeeByOrganization() {
        LogUtil.info(getClass().getName(), "43");
        Collection employments = employmentDao.getEmployeeByOrganization("Parent", null, null, null, null);

        Assert.isTrue(employments.size() > 0);
    }

    /**
     * Get manager list
     */
    @Test
    public void testGetManagerList() {
        LogUtil.info(getClass().getName(), "44");
        Collection employments = employmentDao.getManagerList("First", null, null, null, null);

        Assert.isTrue(employments.size() > 0);
    }

    /**
     * Get manager by department
     */
    @Test
    public void testGetManagerByDepartment() {
        LogUtil.info(getClass().getName(), "45");
        Collection employments = employmentDao.getManagerByDepartment("Parent", null, null, null, null);

        Assert.isTrue(employments.size() > 0);
    }

    /**
     * Get manager by department
     */
    @Test
    public void testGetManagerByOrganization() {
        LogUtil.info(getClass().getName(), "46");
        Collection employments = employmentDao.getManagerByOrganization("Parent", null, null, null, null);

        Assert.isTrue(employments.size() > 0);
    }

    /**
     * Get department list
     */
    @Test
    public void testGetDepartmentList() {
        LogUtil.info(getClass().getName(), "47");
        Collection departments = departmentDao.getDepartmentList("Parent", null, null, null, null);

        Assert.isTrue(departments.size() > 0);
    }

    /**
     * Get department by id
     */
    @Test
    public void testGetDepartmentById() {
        LogUtil.info(getClass().getName(), "48");
        Collection departments = departmentDao.getDepartmentList("Parent", null, null, null, null);

        Department department = departmentDao.getDepartmentById(((Department) departments.iterator().next()).getId());

        Assert.notNull(department);
    }

    /**
     * Get department by name
     */
    @Test
    public void testGetDepartmentByName() {
        LogUtil.info(getClass().getName(), "49");
        Department department = departmentDao.getDepartmentByName("Parent");

        Assert.notNull(department);
    }

    /**
     * Get department by organization
     */
    @Test
    public void testGetDepartmentByOrganization() {
        LogUtil.info(getClass().getName(), "50");
        Collection departments = departmentDao.getDepartmentByOrganization("Parent", null, null, null, null);

        Assert.isTrue(departments.size() > 0);
    }

    /**
     * Get department by parent
     */
    @Test
    public void testGetDepartmentByParent() {
        LogUtil.info(getClass().getName(), "51");
        Department parent = departmentDao.getDepartmentByName("Parent");

        Collection departments = departmentDao.getDepartmentByParent(parent.getId(), null, null, null, null);
        Department child = (Department) departments.iterator().next();

        Assert.isTrue(child.getName().equals("Child"));
    }

    /**
     * Get grade list
     */
    @Test
    public void testGetGradeList() {
        LogUtil.info(getClass().getName(), "52");
        Collection grades = gradeDao.getGradeList("Grade", null, null, null, null);

        Assert.isTrue(grades.size() > 0);
    }

    /**
     * Get grade by id
     */
    @Test
    public void testGetGradeById() {
        LogUtil.info(getClass().getName(), "53");
        Collection grades = gradeDao.getGradeList("Grade", null, null, null, null);

        Grade grade = gradeDao.getGradeById(((Grade) grades.iterator().next()).getId());

        Assert.notNull(grade);
    }

    /**
     * Get grade by name
     */
    @Test
    public void testGetGradeByName() {
        LogUtil.info(getClass().getName(), "54");
        Grade grade = gradeDao.getGradeByName("Grade");

        Assert.notNull(grade);
    }

    /**
     * Get grade by organization
     */
    @Test
    public void testGetGradeByOrganization() {
        LogUtil.info(getClass().getName(), "55");
        Collection grades = gradeDao.getGradeByOrganization("Parent", null, null, null, null);

        Assert.isTrue(grades.size() > 0);
    }

    /**
     * Get organization list
     */
    @Test
    public void testGetOrganizationList() {
        LogUtil.info(getClass().getName(), "56");
        Collection organizations = organizationDao.getOrganizationList("Parent", null, null, null, null);

        Assert.isTrue(organizations.size() > 0);
    }

    /**
     * Get organization by id
     */
    @Test
    public void testGetOrganizationById() {
        LogUtil.info(getClass().getName(), "57");
        Collection organizations = organizationDao.getOrganizationList("Parent", null, null, null, null);

        Organization organization = organizationDao.getOrganizationById(((Organization) organizations.iterator().next()).getId());

        Assert.notNull(organization);
    }

    /**
     * Get organization by name
     */
    @Test
    public void testGetOrganizationByName() {
        LogUtil.info(getClass().getName(), "58");
        Organization organization = organizationDao.getOrganizationByName("Parent");

        Assert.notNull(organization);
    }

    /**
     * Get organization by parent
     **********************************************************************/
    @Test
    public void testGetOrganizationByParent() {
        LogUtil.info(getClass().getName(), "59");
        Organization parent = organizationDao.getOrganizationByName("Parent");

        Collection organizations = organizationDao.getOrganizationByParent(parent.getId(), null, null, null, null);

        Assert.isTrue(organizations.size() > 0);
    }

    /**
     * Get organization list by user
     */
    @Test
    public void testGetOrganizationByUser() {
        LogUtil.info(getClass().getName(), "60");
        Collection organizations = organizationDao.getOrganizationListByUser("First", null, null, null, null);

        Assert.isTrue(organizations.size() > 0);
    }

    /***********************************************************************
     * Stage 3: delete records
     * Remove user from group
     */
    @Test
    public void testRemoveUserFromGroup() {
        LogUtil.info(getClass().getName(), "61");
        User user = userDao.getUserByUsername("ActiveUsername");
        Group group = groupDao.getGroupByName("Group");
        userDao.removeUserFromGroup(user.getId(), group.getId());

        User getUser = userDao.getUserByUsername("ActiveUsername");
        Assert.isTrue(getUser.getGroups().size() == 0);
    }

    /**
     * Remove user from role
     */
    @Test
    public void testRemoveUserFromRole() {
        LogUtil.info(getClass().getName(), "62");
        User user = userDao.getUserByUsername("ActiveUsername");
        Role role = roleDao.getRoleByName("Role");
        userDao.removeUserFromRole(user.getId(), role.getId());

        User getUser = userDao.getUserByUsername("ActiveUsername");
        Assert.isTrue(getUser.getRoles().size() == 0);
    }

    /**
     * Remove user as employee
     */
    @Test
    public void testRemoveUserAsEmployee() {
        LogUtil.info(getClass().getName(), "63");
        User user = userDao.getUserByUsername("ActiveUsername");
        Employment employment = employmentDao.getEmployeeByCode("12345");
        userDao.removeUserAsEmployee(user.getId(), employment.getId());

        User getUser = userDao.getUserByUsername("ActiveUsername");
        Assert.isTrue(getUser.getEmployments().size() == 0);
    }

    /**
     * Remove user
     */
    @Test
    public void testRemoveUser() {
        LogUtil.info(getClass().getName(), "64");

        userDao.deleteUser(userDao.getUserByUsername("ActiveUsername"));
        userDao.deleteUser(userDao.getInactiveUserByUsername("InactiveUsername"));

        Assert.isTrue(true);
    }

    /**
     * Remove role
     */
    @Test
    public void testRemoveRole() {
        LogUtil.info(getClass().getName(), "65");
        roleDao.deleteRole(roleDao.getRoleByName("Role"));

        Assert.isTrue(true);
    }

    /**
     * Remove group
     */
    @Test
    public void testRemoveGroup() {
        LogUtil.info(getClass().getName(), "66");
        groupDao.deleteGroup(groupDao.getGroupByName("Group"));

        Assert.isTrue(true);
    }

    /**
     * Remove employee from department
     */
    @Test
    public void testRemoveEmployeeFromDepartment() {
        LogUtil.info(getClass().getName(), "67");
        Employment employment = employmentDao.getEmployeeByCode("12345");
        Department department = departmentDao.getDepartmentByName("Parent");
        employmentDao.removeEmployeeFromDepartment(employment.getId(), department.getId());

        Department getDepartment = departmentDao.getDepartmentByName("Parent");

        Assert.isTrue(getDepartment.getEmployments().size() == 0);
    }

    /**
     * Remove employee as manager
     */
    @Test
    public void testRemoveEmployeeAsManager() {
        LogUtil.info(getClass().getName(), "68");
        Employment employment = employmentDao.getEmployeeByCode("12345");
        employmentDao.removeEmployeeAsManager(employment.getId());
        Employment getEmployment = employmentDao.getEmployeeByCode("12345");

        Assert.isTrue(getEmployment.getRole() == null);
    }

    /**
     * Remove employee
     */
    @Test
    public void testRemoveEmployee() {
        LogUtil.info(getClass().getName(), "69");
        Employment employment = employmentDao.getEmployeeByCode("12345");
        employmentDao.removeEmployee(employment);

        Assert.isTrue(true);
    }

    /**
     * Remove grade from organization
     */
    @Test
    public void testRemoveGradeFromOrganization() {
        LogUtil.info(getClass().getName(), "70");
        Grade grade = gradeDao.getGradeByName("Grade");
        Organization organization = organizationDao.getOrganizationByName("Parent");
        gradeDao.removeGradeFromOrganization(grade.getId(), organization.getId());

        Organization getOrganization = organizationDao.getOrganizationByName("Parent");

        Assert.isTrue(getOrganization.getGrades().size() == 0);
    }

    /**
     * Remove grade
     */
    @Test
    public void testRemoveGrade() {
        LogUtil.info(getClass().getName(), "71");
        gradeDao.deleteGrade(gradeDao.getGradeByName("Grade"));

        Assert.isTrue(true);
    }

    /**
     * Remove department from organization
     */
    @Test
    public void testRemoveDepartmentFromOrganization() {
        LogUtil.info(getClass().getName(), "72");
        Department parent = departmentDao.getDepartmentByName("Parent");
        Organization organization = organizationDao.getOrganizationByName("Parent");
        departmentDao.removeDepartmentFromOrganization(parent.getId(), organization.getId());

        Organization getOrganization = organizationDao.getOrganizationByName("Parent");

        Assert.isTrue(getOrganization.getDepartments().size() == 0);
    }

    /**
     * Remove parent from department
     */
    @Test
    public void testRemoveParentFromDepartment() {
        LogUtil.info(getClass().getName(), "73");
        Department parent = departmentDao.getDepartmentByName("Parent");
        Department child = departmentDao.getDepartmentByName("Child");
        departmentDao.removeParentFromDepartment(child.getId(), parent.getId());

        Department getDepartment = departmentDao.getDepartmentByName("Parent");

        Assert.isTrue(getDepartment.getChildrens().size() == 0);
    }

    /**
     * Remove department
     */
    @Test
    public void testRemoveDepartment() {
        LogUtil.info(getClass().getName(), "74");
        Department parent = departmentDao.getDepartmentByName("Parent");
        Department child = departmentDao.getDepartmentByName("Child");
        departmentDao.deleteDepartment(parent.getId());
        departmentDao.deleteDepartment(child.getId());

        Assert.isTrue(true);
    }

    /**
     * Remove parent from organization
     */
    @Test
    public void testRemoveParentFromOrganization() {
        LogUtil.info(getClass().getName(), "75");
        Organization parent = organizationDao.getOrganizationByName("Parent");
        Organization child = organizationDao.getOrganizationByName("Child");
        organizationDao.removeParentFromOrganization(parent.getId(), child.getId());

        Organization getParent = organizationDao.getOrganizationByName("Parent");
        Assert.isTrue(getParent.getChildrens().size() == 0);
    }

    /**
     * Remove organization
     */
    @Test
    public void testRemoveOrganization() {
        LogUtil.info(getClass().getName(), "76");
        Organization parent = organizationDao.getOrganizationByName("Parent");
        Organization child = organizationDao.getOrganizationByName("Child");
        organizationDao.deleteOrganization(parent.getId());
        organizationDao.deleteOrganization(child.getId());

        Assert.isTrue(true);
    }
}
