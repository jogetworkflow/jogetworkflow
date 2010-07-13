package org.joget.workflow.controller;

import org.joget.commons.spring.web.AbstractWebController;
import java.util.Collection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMethod;
import org.joget.directory.model.dao.organization.OrganizationDao;
import org.joget.directory.model.Organization;
import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.Department;
import org.joget.directory.model.dao.grade.GradeDao;
import org.joget.directory.model.Grade;
import org.joget.directory.model.dao.employment.EmploymentDao;
import org.joget.directory.model.Employment;
import org.joget.directory.model.Group;
import org.joget.directory.model.Role;
import org.joget.directory.model.User;
import org.joget.directory.model.dao.group.GroupDao;
import org.joget.directory.model.dao.role.RoleDao;
import org.joget.directory.model.dao.user.UserDao;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;
import org.joget.commons.util.TimeZoneUtil;
import org.joget.directory.model.EmploymentReportTo;
import org.joget.directory.model.dao.employmentreportto.EmploymentReportToDao;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.joget.workflow.model.WorkflowFacade;

@Controller
public class DirectoryWebController extends AbstractWebController {

    @Autowired
    private OrganizationDao organizationDao;

    @Autowired
    private DepartmentDao departmentDao;

    @Autowired
    private GradeDao gradeDao;

    @Autowired
    private EmploymentDao employmentDao;

    @Autowired
    private EmploymentReportToDao employmentReportToDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private RoleDao roleDao;

    @Autowired
    private GroupDao groupDao;
    
    @Autowired
    private Validator validator;

    @Autowired
    WorkflowFacade workflowFacade;

    @RequestMapping("/directory/admin/organization/list")
    public String listOrganization(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) {
        Collection<Organization> organizations = organizationDao.getOrganizationList(null, null, null, null, null);
        model.addAttribute(organizations);
        return "directory/organizationList";
    }

    @RequestMapping("/directory/admin/organization/new")
    public String newOrganization(ModelMap model) {
        model.addAttribute("organization", new Organization());
        return "directory/organizationNew";
    }

    @RequestMapping("/directory/admin/organization/edit")
    public String editOrganization(ModelMap model, @RequestParam(value = "organizationId") String organizationId) {
        Organization editOrganization = organizationDao.getOrganizationById(organizationId);
        model.addAttribute("organization", editOrganization);
        return "directory/organizationEdit";
    }

    @RequestMapping("/directory/admin/organization/view/(*:id)")
    public String viewOrganization(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "id", required = false) String id, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) {
        Organization organization = organizationDao.getOrganizationById(id);
        model.addAttribute("organization", organization);
        return "directory/organizationView";
    }

    @RequestMapping(value = "/directory/admin/organization/submit", method = RequestMethod.POST)
    public String submitOrganization(ModelMap model, @ModelAttribute("organization") Organization organization, BindingResult result) {
        validator.validate(organization, result);
        Collection<String> errors = new ArrayList<String>();

        Organization org = organizationDao.getOrganizationByName(organization.getName());
        if (org != null) {
            errors.add("usersAdmin.organization.name.already.exist");
        }

        if(errors.size() != 0){
            model.addAttribute("errors", errors);
        }

        if (result.hasErrors() || errors.size() != 0) {
            return "directory/organizationEdit";
        }

        Organization editOrganization = organizationDao.getOrganizationById(organization.getId());
        editOrganization.setName(organization.getName());
        editOrganization.setDescription(organization.getDescription());

        organizationDao.updateOrganization(editOrganization);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping(value = "/directory/admin/organization/save", method = RequestMethod.POST)
    public String saveOrganization(ModelMap model, @ModelAttribute("organization") Organization organization, BindingResult result) {
        validator.validate(organization, result);
        Collection<String> errors = new ArrayList<String>();

        Organization org = organizationDao.getOrganizationById(organization.getId());
        if (org != null) {
            errors.add("usersAdmin.organization.code.already.exist");
        }
        org = organizationDao.getOrganizationByName(organization.getName());
        if (org != null) {
            errors.add("usersAdmin.organization.name.already.exist");
        }
        
        if(errors.size() != 0){
            model.addAttribute("errors", errors);
        }

        if (result.hasErrors() || errors.size() != 0) {
            return "directory/organizationNew";
        }
        organizationDao.addOrganization(organization);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping(value = "/directory/admin/organization/remove", method = RequestMethod.POST)
    public String removeOrganization(@RequestParam(value = "organizationId") String organizationId) {
        organizationDao.deleteOrganization(organizationId);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping(value = "/directory/admin/organization/removeMutliple", method = RequestMethod.POST)
    public String removeMultipleOrganizations(@RequestParam(value = "organizationIds") String organizationIds) {
        StringTokenizer strToken = new StringTokenizer(organizationIds, ",");
        while (strToken.hasMoreTokens()) {
            String organizationId = (String) strToken.nextElement();
            organizationDao.deleteOrganization(organizationId);
        }       
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/department/new")
    public String newDepartment(ModelMap model, @RequestParam("organizationId") String organizationId) {
        model.addAttribute("department", new Department());
        model.addAttribute("organizationId", organizationId);
        return "directory/departmentNew";
    }

    @RequestMapping("/directory/admin/organization/department/save")
    public String saveDepartment(ModelMap model, @ModelAttribute("department") Department department, BindingResult result, @RequestParam("organizationId") String organizationId) {
        validator.validate(department, result);

        if (result.hasErrors()) {
            model.addAttribute("organizationId", organizationId);
            return "directory/departmentNew";
        }

        Department dept = departmentDao.getDepartmentById(department.getId());
        if (dept != null) {
            model.addAttribute("error", "usersAdmin.department.code.already.exist");
            model.addAttribute("organizationId", organizationId);
            return "directory/departmentNew";
        }


        departmentDao.addDepartment(department);
        departmentDao.addDepartmentToOrganization(department.getId(), organizationId);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/department/view/(*:id)")
    public String viewDepartment(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "id", required = false) String departmentId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) {
        Department department = departmentDao.getDepartmentById(departmentId);
        model.addAttribute("department", department);
        return "directory/departmentView";
    }

    @RequestMapping("/directory/admin/organization/department/edit")
    public String editDepartment(ModelMap model, @RequestParam("departmentId") String departmentId) {
        Department editDepartment = departmentDao.getDepartmentById(departmentId);
        model.addAttribute("department", editDepartment);
        return "directory/departmentEdit";
    }

    @RequestMapping(value = "/directory/admin/organization/department/submit", method = RequestMethod.POST)
    public String submitDepartment(ModelMap model, @ModelAttribute("department") Department department, BindingResult result) {
        validator.validate(department, result);

        if (result.hasErrors()) {
            return "directory/departmentEdit";
        }

        Department editDepartment = departmentDao.getDepartmentById(department.getId());
        editDepartment.setName(department.getName());
        editDepartment.setDescription(department.getDescription());

        departmentDao.updateDepartment(editDepartment);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping(value = "/directory/admin/organization/department/remove", method = RequestMethod.POST)
    public String removeDepartment(@RequestParam(value = "departmentId") String departmentId) {
        departmentDao.deleteDepartment(departmentId);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping(value = "/directory/admin/organization/department/removeMultiple")
    public String removeMultipleDepartments(@RequestParam(value = "departmentIds") String departmentIds) {
        StringTokenizer strToken = new StringTokenizer(departmentIds, ",");
        while (strToken.hasMoreTokens()) {
            String departmentId = (String) strToken.nextElement();
            departmentDao.deleteDepartment(departmentId);
        }
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/subdepartment/new")
    public String newSubDepartment(ModelMap model, @RequestParam("departmentId") String departmentId, @RequestParam("organizationId") String organizationId) {
        model.addAttribute("department", new Department());
        model.addAttribute("departmentId", departmentId);
        model.addAttribute("organizationId", organizationId);
        return "directory/subdepartmentNew";
    }

    @RequestMapping("/directory/admin/organization/subdepartment/view/(*:id)")
    public String viewSubDepartment(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "id", required = false) String subdepartmentId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) {
        Department subdepartment = departmentDao.getDepartmentById(subdepartmentId);
        Department parent = subdepartment;

        String parentId = parent.getId();

        while (parent.getParent() != null) {
            parent = parent.getParent();
            parentId = parent.getId();
        }

        model.addAttribute("subdepartment", subdepartment);
        model.addAttribute("parentId", parentId);
        return "directory/subdepartmentView";
    }

    @RequestMapping("/directory/admin/organization/subdepartment/save")
    public String saveSubDepartment(ModelMap model, @ModelAttribute("department") Department subdepartment, BindingResult result,
            @RequestParam("organizationId") String organizationId,
            @RequestParam("parentId") String parentId) {
        validator.validate(subdepartment, result);

        Organization org = subdepartment.getOrganization();
        if (result.hasErrors()) {
            model.addAttribute("departmentId", parentId);
            model.addAttribute("organizationId", organizationId);
            return "directory/subdepartmentNew";
        }

        Department dept = departmentDao.getDepartmentById(subdepartment.getId());
        if (dept != null) {
            model.addAttribute("error", "usersAdmin.department.code.already.exist");
            model.addAttribute("departmentId", parentId);
            model.addAttribute("organizationId", organizationId);
            return "directory/subdepartmentNew";
        }

        departmentDao.addDepartment(subdepartment);
        departmentDao.assignParentToDepartment(subdepartment.getId(), parentId);
        departmentDao.addDepartmentToOrganization(subdepartment.getId(), organizationId);

        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/subdepartment/edit")
    public String editSubDepartment(ModelMap model, @RequestParam("subdepartmentId") String subdepartmentId) {
        Department editSubDepartment = departmentDao.getDepartmentById(subdepartmentId);
        model.addAttribute("subdepartment", editSubDepartment);
        return "directory/subdepartmentEdit";
    }

    @RequestMapping("/directory/admin/organization/subdepartment/submit")
    public String submitSubDepartment(ModelMap model, @ModelAttribute("subdepartment") Department subdepartment, BindingResult result) {

        validator.validate(subdepartment, result);

        if (result.hasErrors()) {
            return "directory/subdepartmentEdit";
        }

        Department editSubDepartment = departmentDao.getDepartmentById(subdepartment.getId());
        editSubDepartment.setName(subdepartment.getName());
        editSubDepartment.setDescription(subdepartment.getDescription());

        departmentDao.updateDepartment(editSubDepartment);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/subdepartment/remove")
    public String removeSubDepartment(ModelMap model, @RequestParam(value = "subdepartmentId") String subdepartmentId) {
        departmentDao.deleteDepartment(subdepartmentId);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/employee/new")
    public String newEmployee(ModelMap model, @RequestParam("departmentId") String departmentId) {
        model.addAttribute("employment", new Employment());
        model.addAttribute("users", userDao.getActiveUser("", null, null, null, null));
        model.addAttribute("departmentId", departmentId);
        return "directory/employeeNew";
    }

    @RequestMapping("/directory/admin/organization/employee/save")
    public String saveEmployee(ModelMap model, @ModelAttribute("employment") Employment employment) {
        employmentDao.addEmployee(employment);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/employee/assign")
    public String assignEmployee(ModelMap model, @RequestParam("departmentId") String departmentId) {
        Collection<Employment> employments = employmentDao.getAssignEmployeeList(departmentId, null, null, null, null);
        model.addAttribute("employments", employments);
        model.addAttribute("departmentId", departmentId);
        return "directory/employeeAssign";
    }

    @RequestMapping("/directory/admin/organization/employee/unassign")
    public String unassignEmployee(ModelMap model, @RequestParam("departmentId") String departmentId) {
        Collection<Employment> employments = employmentDao.getUnassignEmployeeList(departmentId, null, null, null, null);
        model.addAttribute("employments", employments);
        model.addAttribute("departmentId", departmentId);
        return "directory/employeeUnassign";
    }

    @RequestMapping("/directory/admin/organization/employee/assign/submit")
    public String submitAssignEmployee(ModelMap model, @RequestParam("assignId") String assignId, @RequestParam("departmentId") String departmentId) {

        Collection<Employment> employments = employmentDao.getEmployeeList(null, null, null, null, null);
        String[] ids = assignId.split(",");

        for (int i = 0; i < ids.length; i++) {
            Employment employment = employmentDao.getEmployeeById(ids[i]);

            if (employment.getDepartment() == null) {
                employmentDao.assignEmployeeToDepartment(ids[i], departmentId);
            } else {

                Employment newEmployment = new Employment();
                newEmployment.setEmployeeCode(employment.getEmployeeCode());
                newEmployment.setStartDate(employment.getStartDate());
                newEmployment.setEndDate(employment.getEndDate());
                newEmployment.setGrade(employment.getGrade());
                newEmployment.setUserId(employment.getUser().getId());
                newEmployment.setRole(employment.getRole());
                employmentDao.addEmployee(newEmployment);
                employmentDao.assignEmployeeToDepartment(newEmployment.getId(), departmentId);

                for (Employment employee : employments) {
                    User us = employment.getUser();
                    Department dept = employment.getDepartment();

                    if (us != null && dept != null) {

                        if (employee.getUser().getId().equals(us.getId()) && !employee.getDepartment().getId().equals(departmentId)) {
                            employmentDao.removeEmployee(employee);
                        }
                    } else {
                        employmentDao.removeEmployee(employee);
                    }
                }
            }
        }

        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/employee/unassign/submit")
    public String submitUnassignEmployee(ModelMap model, @RequestParam("unassignId") String unassignId, @RequestParam("departmentId") String departmentId) {

        String[] ids = unassignId.split(",");

        for (int i = 0; i < ids.length; i++) {
            Employment employment = employmentDao.getEmployeeById(ids[i]);

            if (employment.getDepartmentId() != null) {
                employmentDao.removeEmployeeFromDepartment(ids[i], departmentId);
            }
        }

        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/employee/submit")
    public String submitEmployee(ModelMap model, @ModelAttribute("employment") Employment employment) {

        Employment editEmployment = employmentDao.getEmployeeById(employment.getId());
        editEmployment.setEmployeeCode(employment.getEmployeeCode());
        editEmployment.setStartDate(employment.getStartDate());
        editEmployment.setEndDate(employment.getEndDate());
        editEmployment.setGradeId(employment.getGradeId());

        employmentDao.updateEmployee(editEmployment);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/employee/view/(*:id)")
    public String viewEmployee(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "id", required = false) String employmentId) {
        Employment employment = employmentDao.getEmployeeById(employmentId);
        model.addAttribute("employment", employment);
        return "directory/employeeView";
    }

    @RequestMapping("/directory/admin/organization/employee/edit")
    public String editEmployee(ModelMap model, @RequestParam("employmentId") String employmentId) {
        Employment editEmployment = employmentDao.getEmployeeById(employmentId);
        model.addAttribute("employment", editEmployment);
        model.addAttribute("grades", gradeDao.getGradeList("", null, null, null, null));
        return "directory/employeeEdit";
    }

    @RequestMapping("/directory/admin/organization/employee/sethod")
    public String setEmployeeAsHod(ModelMap model, @RequestParam("employmentId") String employmentId) {
        Employment employment = employmentDao.getEmployeeById(employmentId);
        Department department = employment.getDepartment();
        department.setHod(employment);
        departmentDao.updateDepartment(department);
        return "directory/employeeView";
    }

    @RequestMapping("/directory/admin/organization/employee/removehod")
    public String removeEmployeeFromHod(ModelMap model, @RequestParam("employmentId") String employmentId) {

        Employment employment = employmentDao.getEmployeeById(employmentId);
        Department department = employment.getDepartment();
        department.setHod(null);
        departmentDao.updateDepartment(department);
        return "directory/employeeView";
    }

    @RequestMapping("/directory/admin/organization/grade/view/(*:id)")
    public String viewGrade(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "id", required = false) String gradeId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) {
        Grade grade = gradeDao.getGradeById(gradeId);
        model.addAttribute("grade", grade);
        return "directory/gradeView";
    }

    @RequestMapping("/directory/admin/organization/grade/new")
    public String newGrade(ModelMap model, @RequestParam("organizationId") String organizationId) {
        model.addAttribute("grade", new Grade());
        model.addAttribute("organizationId", organizationId);
        return "directory/gradeNew";
    }

    @RequestMapping("/directory/admin/organization/grade/save")
    public String saveGrade(ModelMap model, @ModelAttribute("grade") Grade grade, BindingResult result, @RequestParam("organizationId") String organizationId) {

        validator.validate(grade, result);

        Grade gra = gradeDao.getGradeById(grade.getId());
        if (gra != null) {
            model.addAttribute("error", "usersAdmin.grade.code.already.exist");
            return "directory/gradeNew";
        }

        if (result.hasErrors()) {
            model.addAttribute("organizationId", organizationId);
            return "directory/gradeNew";
        }

        gradeDao.addGrade(grade);
        gradeDao.addGradeToOrganization(grade.getId(), organizationId);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/grade/edit")
    public String editGrade(ModelMap model, @RequestParam("gradeId") String gradeId) {
        Grade grade = gradeDao.getGradeById(gradeId);
        model.addAttribute("grade", grade);
        model.addAttribute("organizations", organizationDao.getOrganizationList("", null, null, null, null));
        return "directory/gradeEdit";
    }

    @RequestMapping("/directory/admin/organization/grade/submit")
    public String submitGrade(ModelMap model, @ModelAttribute("grade") Grade grade, BindingResult result) {

        validator.validate(grade, result);

        if (result.hasErrors()) {
            return "directory/gradeEdit";
        }

        Grade editGrade = gradeDao.getGradeById(grade.getId());
        editGrade.setName(grade.getName());
        editGrade.setDescription(grade.getDescription());

        gradeDao.updateGrade(editGrade);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/grade/remove")
    public String removeGrade(ModelMap model, @RequestParam(value = "gradeId") String gradeId) {
        Grade grade = gradeDao.getGradeById(gradeId);
        Set<Employment> employments = grade.getEmployments();
        for (Employment employment : employments) {
            employmentDao.removeEmployee(employment);
        }
        gradeDao.deleteGrade(grade);

        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/organization/grade/removeMultiple")
    public String removeMultipleGrades(ModelMap model, @RequestParam(value = "gradeIds") String gradeIds) {
        StringTokenizer strToken = new StringTokenizer(gradeIds, ",");
        while (strToken.hasMoreTokens()) {
            String gradeId = (String) strToken.nextElement();
            Grade grade = gradeDao.getGradeById(gradeId);
            Set<Employment> employments = grade.getEmployments();
            for (Employment employment : employments) {
                employmentDao.removeEmployee(employment);
            }
            gradeDao.deleteGrade(grade);
        }      

        return "directory/saveOrEditSuccess";
    }
    /**
     * Manage users and groups
     */
    @RequestMapping("/directory/admin/user/list")
    public String listUser(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) {
        Collection<User> users = userDao.getUserList("", sort, desc, start, rows);
        model.addAttribute("users", users);
        return "directory/userList";
    }

    @RequestMapping("/directory/admin/user/new")
    public String createUser(ModelMap model) {
        model.addAttribute("user", new User());
        model.addAttribute("organizations", organizationDao.getOrganizationList("", null, null, null, null));
        model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));
        model.addAttribute("employments", employmentDao.getEmployeeList("", "u.firstName", Boolean.FALSE, null, null));
        model.addAttribute("timeZoneList", TimeZoneUtil.getList());
        return "directory/userNew";
    }

    @RequestMapping("/directory/admin/user/save")
    public String saveUser(ModelMap model, @ModelAttribute("user") User user, BindingResult result,
            @RequestParam("roles") String roles,
            @RequestParam("employmentCode") String employmentCode,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate,
            @RequestParam("employmentRole") String employmentRole,
            @RequestParam("gradeName") String gradeId,
            @RequestParam("organizationName") String organizationId,
            @RequestParam("departmentName") String departmentId,
            @RequestParam("setHod") String setHod,
            @RequestParam("employmentReportTo") String employmentReportToId) {

        validator.validate(user, result);

        String[] tempSelectedRoles = (String[]) roles.split(",");
        List selectedRoles = new ArrayList();
        for (int i = 0; i < tempSelectedRoles.length; i++) {
            selectedRoles.add(tempSelectedRoles[i]);
        }

        model.addAttribute("selectedRoles", selectedRoles);

        boolean isUsernameExist = (userDao.getUserByUsername(user.getUsername()) != null ? true : false);

        if (isUsernameExist) {
            Organization organization = organizationDao.getOrganizationById(organizationId);

            model.addAttribute("user", user);

            model.addAttribute("organizations", organizationDao.getOrganizationList("", null, null, null, null));
            model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));
            model.addAttribute("error", "usersAdmin.username.already.exist");

            if (organizationId != null && organizationId.trim().length() > 0 && organization != null) {
                model.addAttribute("organizationName", organizationId);
                model.addAttribute("grades", gradeDao.getGradeByOrganization(organization.getName(),
                        null, null, null, null));
                Collection<Department> departments = departmentDao.getRecursiveDepartmentByOrganizationId(organizationId);
                for (Department department : departments) {
                    Department recursiveDept = department;
                    String recursive = "";
                    while (recursiveDept.getParent() != null) {
                        recursive += "--";
                        recursiveDept = recursiveDept.getParent();
                    }
                    department.setTreeStructure(recursive);
                }

                model.addAttribute("setHod", setHod);
                model.addAttribute("departments", departments);

                if (gradeId != null && gradeId.trim().length() > 0) {
                    model.addAttribute("gradeName", gradeId);
                }

                if (departmentId != null && departmentId.trim().length() > 0) {
                    model.addAttribute("departmentName", departmentId);
                }
            }

            return "directory/userNew";
        }

        if (!user.getPassword().equals(user.getConfirmPassword())) {
            model.addAttribute("organizations", organizationDao.getOrganizationList("", null, null, null, null));
            model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));
            model.addAttribute("error", "usersAdmin.password.not.match");

            if (organizationId != null && !organizationId.equals("0")) {
                model.addAttribute("organizationName", organizationId);
            }

            if (organizationId != null && !organizationId.equals("0")) {
                model.addAttribute("grades", gradeDao.getGradeByOrganization(organizationDao.getOrganizationById(organizationId).getName(),
                        null, null, null, null));

                Collection<Department> departments = departmentDao.getRecursiveDepartmentByOrganizationId(organizationId);

                for (Department department : departments) {
                    Department recursiveDept = department;
                    String recursive = "";

                    while (recursiveDept.getParent() != null) {
                        recursive += "--";
                        recursiveDept = recursiveDept.getParent();
                    }
                    department.setTreeStructure(recursive);
                }

                model.addAttribute("departments", departments);

                if (gradeId != null && gradeId.trim().length() > 0) {
                    model.addAttribute("gradeName", gradeId);
                }

                if (departmentId != null && departmentId.trim().length() > 0) {
                    model.addAttribute("departmentName", departmentId);
                }
            }

            model.addAttribute("setHod", setHod);

            return "directory/userNew";
        }

        if (result.hasErrors()) {
            model.addAttribute("organizations", organizationDao.getOrganizationList("", null, null, null, null));
            model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));

            if (organizationId != null && !organizationId.equals("0")) {
                model.addAttribute("organizationName", organizationId);
            }

            Organization organization = organizationDao.getOrganizationById(organizationId);

            if (organizationId != null && !organizationId.equals("0") && organization != null) {
                model.addAttribute("grades", gradeDao.getGradeByOrganization(organization.getName(),
                        null, null, null, null));

                Collection<Department> departments = departmentDao.getRecursiveDepartmentByOrganizationId(organizationId);

                for (Department department : departments) {
                    Department recursiveDept = department;
                    String recursive = "";
                    while (recursiveDept.getParent() != null) {
                        recursive += "--";
                        recursiveDept = recursiveDept.getParent();
                    }
                    department.setTreeStructure(recursive);
                }

                model.addAttribute("departments", departments);

                if (gradeId != null && gradeId.trim().length() > 0) {
                    model.addAttribute("gradeName", gradeId);
                }

                if (departmentId != null && departmentId.trim().length() > 0) {
                    model.addAttribute("departmentName", departmentId);
                }
            }

            model.addAttribute("setHod", setHod);

            return "directory/userNew";
        }

        //set role(s)
        String[] roleIds = roles.split(",");
        Set<Role> assignedRoles = new HashSet<Role>();
        for (String roleId : roleIds) {
            Role role = roleDao.getRoleById(roleId);
            assignedRoles.add(role);
        }
        user.setRoles(assignedRoles);

        user.setId(user.getUsername());
        user.setActive(1);
        userDao.addUser(user);

        String[] startDates = null;
        String[] endDates = null;

        if (startDate != null && startDate.trim().length() > 0) {
            startDates = startDate.split("-");
        }
        
        if (endDate != null && endDate.trim().length() > 0) {
            endDates = endDate.split("-");
        }

        Calendar startCal = Calendar.getInstance();
        Calendar endCal = Calendar.getInstance();

        Employment employment = new Employment();

        if (employmentCode != null && employmentCode.trim().length() > 0) {
            employment.setEmployeeCode(employmentCode);
        }

        if (startDates != null) {
            startCal.set(Integer.parseInt(startDates[0]), Integer.parseInt(startDates[1]), Integer.parseInt(startDates[2]));
            employment.setStartDate(startCal.getTime());
        }

        if (endDates != null) {
            endCal.set(Integer.parseInt(endDates[0]), Integer.parseInt(endDates[1]), Integer.parseInt(endDates[2]));
            employment.setEndDate(endCal.getTime());
        }

        if (employmentRole != null && employmentRole.trim().length() > 0) {
            employment.setRole(employmentRole);
        }
        employmentDao.addEmployee(employment);

        if (organizationId != null && !organizationId.equals("0")) {
            if (gradeId != null && !gradeId.equals("0")) {
                employment.setGradeId(gradeId);
            }

            if (departmentId != null && !departmentId.equals("0")) {
                employment.setDepartmentId(departmentId);

                if (setHod.equals("1")) {
                    Department department = departmentDao.getDepartmentById(departmentId);
                    department.setHod(employment);
                    departmentDao.updateDepartment(department);
                } else {
                    Department department = departmentDao.getDepartmentById(departmentId);

                    Employment existingHod = department.getHod();
                    if (existingHod == employment) {
                        department.setHod(null);
                        departmentDao.updateDepartment(department);
                    }
                }
            }
        }

        if (employmentReportToId != null && !employmentReportToId.equals("0")) {
            if (employmentReportToDao.isEmploymentIdExist(employment.getId())) {
                EmploymentReportTo employmentReportTo = employmentReportToDao.getEmploymentReportToByEmploymentId(employment.getId());
                Employment reportTo = employmentDao.getEmployeeById(employmentReportToId);
                employmentReportTo.setReportTo(reportTo);
                employmentReportToDao.updateEmploymentReportTo(employmentReportTo);
            } else {
                EmploymentReportTo employmentReportTo = new EmploymentReportTo();
                Employment reportTo = employmentDao.getEmployeeById(employmentReportToId);
                Employment subordinate = employmentDao.getEmployeeById(employment.getId());
                employmentReportTo.setSubordinate(subordinate);
                employmentReportTo.setReportTo(reportTo);
                employmentReportToDao.addEmploymentReportTo(employmentReportTo);
            }
        }

        Set employments = new HashSet();
        employments.add(employment);
        user.setEmployments(employments);

        employmentDao.updateEmployee(employment);
        userDao.updateUser(user);

        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/user/view/(*:id)")
    public String viewUser(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "id", required = false) String userId) {
        User user = userDao.getUserById(userId);

        if (user.getTimeZone() == null || user.getTimeZone().trim().length() == 0) {
            user.setTimeZone(TimeZoneUtil.getServerTimeZone());
        }
        model.addAttribute("timeZone", TimeZoneUtil.getList().get(user.getTimeZone()));

        Collection<Employment> employments = user.getEmployments();
        if (employments != null && employments.size() > 0 && !employments.isEmpty()) {
            Employment employment = (Employment) employments.iterator().next();
            model.addAttribute("employment", employment);
        }

        model.addAttribute("user", user);

        if (employments != null && employments.size() > 0) {
            model.addAttribute("empSize", employments.size());
        } else {
            model.addAttribute("empSize", 0);
        }

        //get role(s)
        String roleString = "";
        Set<Role> roles = user.getRoles();
        if (roles != null && roles.size() != 0) {
            for (Role role : roles) {
                roleString += role.getName() + ", ";
            }

            //remove trailing comma
            roleString = roleString.substring(0, roleString.length() - 2);
        }

        model.addAttribute("roleString", roleString);

        if (employments != null && !employments.isEmpty() && employments.size() > 0) {
            Employment employment = (Employment) employments.iterator().next();
            if (employment.getEmploymentReportTo() != null) {
                model.addAttribute("employmentReportToSelected", employment.getEmploymentReportTo().getReportTo().getUser());
            }
        }

        return "directory/userView";
    }

    @RequestMapping("/directory/admin/user/remove")
    public String removeUser(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "userId") String userId) {
        User user = userDao.getUserById(userId);
        Set<Employment> employments = user.getEmployments();
        for (Employment employment : employments) {
            //remove this user from being reporting to anyone
            if (employment.getEmploymentReportTo() != null) {
                employmentReportToDao.removeEmploymentReportTo(employment.getEmploymentReportTo());
            }
            //remove any user(s) that are reporting to this user
            Set<EmploymentReportTo> reportingEmployments = employment.getSubordinates();
            for (EmploymentReportTo reportingEmployment : reportingEmployments) {
                employmentReportToDao.removeEmploymentReportTo(reportingEmployment);
            }
            employmentDao.removeEmployee(employment);
        }

        userDao.deleteUser(userDao.getUserById(userId));
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/user/removeMultiple")
    public String removeMultipleUsers(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "userIds") String userIds) {
        StringTokenizer strToken = new StringTokenizer(userIds, ",");
        while (strToken.hasMoreTokens()) {
            String userId = (String) strToken.nextElement();
            User user = userDao.getUserById(userId);
            Set<Employment> employments = user.getEmployments();
            for (Employment employment : employments) {
                //remove this user from being reporting to anyone
                if (employment.getEmploymentReportTo() != null) {
                    employmentReportToDao.removeEmploymentReportTo(employment.getEmploymentReportTo());
                }
                //remove any user(s) that are reporting to this user
                Set<EmploymentReportTo> reportingEmployments = employment.getSubordinates();
                for (EmploymentReportTo reportingEmployment : reportingEmployments) {
                    employmentReportToDao.removeEmploymentReportTo(reportingEmployment);
                }
                employmentDao.removeEmployee(employment);
            }
            userDao.deleteUser(userDao.getUserById(userId));
        }

        return "directory/saveOrEditSuccess";
    }
    
    @RequestMapping("/directory/admin/user/edit")
    public String editUser(ModelMap model, @RequestParam("userId") String userId) {
        User user = userDao.getUserById(userId);
        user.setConfirmPassword(user.getPassword());

        if (user.getTimeZone() == null || user.getTimeZone().trim().length() == 0) {
            user.setTimeZone(TimeZoneUtil.getServerTimeZone());
        }

        Collection<Employment> employments = user.getEmployments();
        if (employments != null && employments.isEmpty()) {
            Employment employment = new Employment();
            employmentDao.addEmployee(employment);
            userDao.setUserAsEmployee(userId, employment.getId());
            user = userDao.getUserById(userId);
        }

        if (employments != null && !employments.isEmpty()) {
            Employment employment = (Employment) employments.iterator().next();
            model.addAttribute("employment", employment);

            Grade gra = employment.getGrade();

            Organization org = null;
            if(gra != null && gra.getOrganization() != null){
                org = gra.getOrganization();
            }else if(employment.getDepartment() != null && employment.getDepartment().getOrganization() != null){
                org = employment.getDepartment().getOrganization();
            }

            if (org != null) {
                model.addAttribute("grades", gradeDao.getGradeByOrganization(org.getName(), null, null, null, null));
            }

            if (employment.getEmploymentReportTo() != null) {
                model.addAttribute("employmentReportToSelected", employment.getEmploymentReportTo().getReportTo().getId());
            }

            Collection<Department> departments;
            if (org != null) {
                departments = departmentDao.getRecursiveDepartmentByOrganizationId(org.getId());

                for (Department department : departments) {
                    Department recursiveDept = department;
                    String recursive = "";
                    while (recursiveDept.getParent() != null) {
                        recursive += "--";
                        recursiveDept = recursiveDept.getParent();
                    }
                    department.setTreeStructure(recursive);
                }

                model.addAttribute("departments", departments);

                if (employment.getHods() != null && !employment.getHods().isEmpty()) {
                    model.addAttribute("setHod", 1);
                }
            }
        }

        model.addAttribute("organizations", organizationDao.getOrganizationList("", null, null, null, null));
        model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));
        model.addAttribute("employments", employmentDao.getEmployeeList("", "u.firstName", Boolean.FALSE, null, null));
        model.addAttribute("timeZoneList", TimeZoneUtil.getList());

        model.addAttribute("user", user);
        return "directory/userEdit";
    }

    @RequestMapping("/directory/admin/user/submit")
    public String submitUser(ModelMap model, @ModelAttribute("user") User user, BindingResult result,
            @RequestParam("roles") String roles,
            @RequestParam("employmentCode") String employmentCode,
            @RequestParam("startDate") String startDate,
            @RequestParam("endDate") String endDate,
            @RequestParam("employmentRole") String employmentRole,
            @RequestParam("gradeName") String gradeId,
            @RequestParam("organizationName") String organizationId,
            @RequestParam("departmentName") String departmentId,
            @RequestParam("setHod") String setHod,
            @RequestParam("employmentReportTo") String employmentReportToId) {

        validator.validate(user, result);

        Organization organization = organizationDao.getOrganizationById(organizationId);

        User validateUser = userDao.getUserById(user.getId());

        boolean isUsernameExist = (userDao.getUserByUsername(user.getUsername()) != null ? true : false);
        if (isUsernameExist && !validateUser.getUsername().equals(user.getUsername())) {
            editUser(model, user.getId());
            model.addAttribute("user", userDao.getUserById(user.getId()));
            model.addAttribute("organizations", organizationDao.getOrganizationList("", null, null, null, null));
            model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));
            model.addAttribute("error", "usersAdmin.username.already.exist");

            if (organizationId != null && organizationId.trim().length() > 0 && organization != null) {
                model.addAttribute("organizationName", organizationId);
                model.addAttribute("grades", gradeDao.getGradeByOrganization(organization.getName(),
                        null, null, null, null));
                Collection<Department> departments = departmentDao.getRecursiveDepartmentByOrganizationId(organizationId);
                for (Department department : departments) {
                    Department recursiveDept = department;
                    String recursive = "";
                    while (recursiveDept.getParent() != null) {
                        recursive += "--";
                        recursiveDept = recursiveDept.getParent();
                    }
                    department.setTreeStructure(recursive);
                }
                model.addAttribute("setHod", setHod);
                model.addAttribute("departments", departments);
                if (gradeId != null && gradeId.trim().length() > 0) {
                    model.addAttribute("gradeName", gradeId);
                }
                if (departmentId != null && departmentId.trim().length() > 0) {
                    model.addAttribute("departmentName", departmentId);
                }
            }

            return "directory/userEdit";
        }

        if (!user.getPassword().equals(user.getConfirmPassword())) {
            editUser(model, user.getId());
            model.addAttribute("error", "usersAdmin.password.not.match");
            model.addAttribute("organizations", organizationDao.getOrganizationList(null, null, null, null, null));
            model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));

            if (organizationId != null && organizationId.trim().length() > 0) {
                model.addAttribute("organizationName", organizationId);
            }

            if (organizationId != null && organizationId.trim().length() > 0) {
                model.addAttribute("grades", gradeDao.getGradeByOrganization(organization.getName(),
                        null, null, null, null));

                Collection<Department> departments = departmentDao.getRecursiveDepartmentByOrganizationId(organizationId);

                for (Department department : departments) {
                    Department recursiveDept = department;
                    String recursive = "";
                    while (recursiveDept.getParent() != null) {
                        recursive += "--";
                        recursiveDept = recursiveDept.getParent();
                    }
                    department.setTreeStructure(recursive);
                }

                model.addAttribute("setHod", setHod);
                model.addAttribute("departments", departments);
                if (gradeId != null && gradeId.trim().length() > 0) {
                    model.addAttribute("gradeName", gradeId);
                }
                if (departmentId != null && departmentId.trim().length() > 0) {
                    model.addAttribute("departmentName", departmentId);
                }
            }

            return "directory/userEdit";
        }

        if (result.hasErrors()) {
            editUser(model, user.getId());
            model.addAttribute("organizations", organizationDao.getOrganizationList(null, null, null, null, null));
            model.addAttribute("roleList", roleDao.getRoleList("", null, null, null, null));

            if (organizationId != null && organizationId.trim().length() > 0) {
                model.addAttribute("organizationName", organizationId);
            }

            if (organizationId != null && organizationId.trim().length() > 0) {
                model.addAttribute("grades", gradeDao.getGradeByOrganization(organization.getName(),
                        null, null, null, null));

                Collection<Department> departments = departmentDao.getRecursiveDepartmentByOrganizationId(organizationId);

                for (Department department : departments) {
                    Department recursiveDept = department;
                    String recursive = "";
                    while (recursiveDept.getParent() != null) {
                        recursive += "--";
                        recursiveDept = recursiveDept.getParent();
                    }
                    department.setTreeStructure(recursive);
                }

                model.addAttribute("setHod", setHod);
                model.addAttribute("departments", departments);
                if (gradeId != null && gradeId.trim().length() > 0) {
                    model.addAttribute("gradeName", gradeId);
                }
                if (departmentId != null && departmentId.trim().length() > 0) {
                    model.addAttribute("departmentName", departmentId);
                }
            }

            return "directory/userEdit";
        }

        User editUser = userDao.getUserById(user.getId());

        editUser.setFirstName(user.getFirstName());
        editUser.setLastName(user.getLastName());
        editUser.setPassword(user.getPassword());
        editUser.setEmail(user.getEmail());
        editUser.setActive(user.getActive());
        editUser.setTimeZone(user.getTimeZone());

        //set role(s)
        String[] roleIds = roles.split(",");
        Set<Role> assignedRoles = new HashSet<Role>();
        for (String roleId : roleIds) {
            Role role = roleDao.getRoleById(roleId);
            assignedRoles.add(role);
        }
        editUser.setRoles(assignedRoles);

        String[] startDates = null;
        String[] endDates = null;
        Set<Employment> employments = editUser.getEmployments();

        if (startDate != null && startDate.trim().length() > 0) {
            startDates = startDate.split("-");
        }
        if (endDate != null && endDate.trim().length() > 0) {
            endDates = endDate.split("-");
        }

        Calendar startCal = Calendar.getInstance();
        Calendar endCal = Calendar.getInstance();


        //Add employment if condition fulfilled
        if (employments.size() == 0) {
            if (employmentCode.trim().length() > 0 || startDate.trim().length() > 0 || endDate.trim().length() > 0 || employmentRole.trim().length() > 0) {
                if (employmentCode.trim().length() > 0 && startDate.trim().length() > 0) {
                    Employment employment = new Employment();

                    employment.setEmployeeCode(employmentCode);

                    startCal.set(Integer.parseInt(startDates[0]), Integer.parseInt(startDates[1]), Integer.parseInt(startDates[2]));
                    employment.setStartDate(startCal.getTime());

                    if (endDates != null) {
                        endCal.set(Integer.parseInt(endDates[0]), Integer.parseInt(endDates[1]), Integer.parseInt(endDates[2]));
                        employment.setEndDate(endCal.getTime());
                    }

                    if (employmentRole != null && employmentRole.trim().length() > 0) {
                        employment.setRole(employmentRole);
                    }

                    employmentDao.addEmployee(employment);

                    if (organizationId != null && !organizationId.equals("0")) {
                        if (gradeId != null && !gradeId.equals("0")) {
                            employment.setGradeId(gradeId);
                        }

                        if (departmentId != null && !departmentId.equals("0")) {
                            employment.setDepartmentId(departmentId);

                            if (setHod.equals("1")) {
                                Department department = departmentDao.getDepartmentById(departmentId);
                                department.setHod(employment);
                                departmentDao.updateDepartment(department);
                            } else {
                                Department department = departmentDao.getDepartmentById(departmentId);
                                department.setHod(null);
                                departmentDao.updateDepartment(department);
                            }
                        }
                    }
                    employments.add(employment);
                } else {
                    //send error msg
                    model.addAttribute("", "");


                }
            }
        }

        //note: there will be only one employment at any time
        for (Employment employment : employments) {
            if (employmentCode != null && employmentCode.trim().length() > 0) {
                employment.setEmployeeCode(employmentCode);
            }

            if (startDates != null) {
                startCal.set(Integer.parseInt(startDates[0]), Integer.parseInt(startDates[1]), Integer.parseInt(startDates[2]));
                employment.setStartDate(startCal.getTime());
            }

            if (endDates != null) {
                endCal.set(Integer.parseInt(endDates[0]), Integer.parseInt(endDates[1]), Integer.parseInt(endDates[2]));
                employment.setEndDate(endCal.getTime());
            }

            if (employmentRole != null && employmentRole.trim().length() > 0) {
                employment.setRole(employmentRole);
            }

            //remove the user from its current department if the user belongs to one.
            //remove the user from being Hod in the current employment if the user is one.
            if(employment.getDepartmentId() != null){
                Department tempDepartment = departmentDao.getDepartmentById(employment.getDepartmentId());
                Employment tempEmploymentHod = tempDepartment.getHod();
                if (tempEmploymentHod == employment) {
                    tempDepartment.setHod(null);
                    departmentDao.updateDepartment(tempDepartment);
                }
                //remove the user from its current organization and department
                employment.setGradeId(null);
                employment.setDepartmentId(null);
            }
            
            if (organizationId != null && !organizationId.equals("0")) {
                if (gradeId != null && !gradeId.equals("0")) {
                    employment.setGradeId(gradeId);
                }

                if (departmentId != null && !departmentId.equals("0")) {
                    employment.setDepartmentId(departmentId);

                    if (setHod.equals("1")) {
                        Department department = departmentDao.getDepartmentById(departmentId);
                        department.setHod(employment);
                        departmentDao.updateDepartment(department);
                    } else {
                        Department department = departmentDao.getDepartmentById(departmentId);

                        Employment existingHod = department.getHod();
                        if (existingHod == employment) {
                            department.setHod(null);
                            departmentDao.updateDepartment(department);
                        }
                    }
                }
            }
            employmentDao.updateEmployee(employment);

            if (employmentReportToId != null && !employmentReportToId.equals("0")) {
                if (employmentReportToDao.isEmploymentIdExist(employment.getId())) {
                    EmploymentReportTo employmentReportTo = employmentReportToDao.getEmploymentReportToByEmploymentId(employment.getId());
                    Employment reportTo = employmentDao.getEmployeeById(employmentReportToId);
                    employmentReportTo.setReportTo(reportTo);
                    employmentReportToDao.updateEmploymentReportTo(employmentReportTo);
                } else {
                    EmploymentReportTo employmentReportTo = new EmploymentReportTo();
                    Employment reportTo = employmentDao.getEmployeeById(employmentReportToId);
                    Employment subordinate = employmentDao.getEmployeeById(employment.getId());
                    employmentReportTo.setSubordinate(subordinate);
                    employmentReportTo.setReportTo(reportTo);
                    employmentReportToDao.addEmploymentReportTo(employmentReportTo);
                }
            } else {
                EmploymentReportTo employmentReportTo = employmentReportToDao.getEmploymentReportToByEmploymentId(employment.getId());
                if (employmentReportTo != null) {
                    employmentReportToDao.removeEmploymentReportTo(employmentReportTo);
                }
            }
        }

        userDao.updateUser(editUser);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/group/assign")
    public String assignUser(ModelMap model, @RequestParam("userId") String userId) {
        model.addAttribute("userId", userId);
        return "directory/userAssign";
    }

    @RequestMapping("/directory/admin/group/assign/submit")
    public String submitAssignUser(ModelMap model, @RequestParam("assignId") String assignId, @RequestParam("userId") String userId) {

        String[] ids = assignId.split(",");
        for (int i = 0; i < ids.length; i++) {
            userDao.assignUserToGroup(userId, ids[i]);
        }
        return "directory/userAssign";
    }

    @RequestMapping("/directory/admin/group/unassign")
    public String unassignUser(ModelMap model, @RequestParam("userId") String userId) {
        model.addAttribute("userId", userId);
        return "directory/userUnassign";
    }

    @RequestMapping("/directory/admin/group/unassign/submit")
    public String submitUnassignUser(ModelMap model, @RequestParam("assignId") String assignId, @RequestParam("userId") String userId) {

        String[] ids = assignId.split(",");
        for (int i = 0; i < ids.length; i++) {
            userDao.removeUserFromGroup(userId, ids[i]);
        }
        return "directory/userUnassign";
    }

    @RequestMapping("/directory/admin/user/assign")
    public String assignGroup(ModelMap model, @RequestParam("groupId") String groupId) {
        model.addAttribute("groupId", groupId);
        return "directory/groupAssign";
    }

    @RequestMapping("/directory/admin/user/assign/submit")
    public String submitAssignGroup(ModelMap model, @RequestParam("assignId") String assignId, @RequestParam("groupId") String groupId) {

        String[] ids = assignId.split(",");
        for (int i = 0; i < ids.length; i++) {
            userDao.assignUserToGroup(ids[i], groupId);
        }
        return "directory/groupAssign";
    }

    @RequestMapping("/directory/admin/user/unassign")
    public String unassignGroup(ModelMap model, @RequestParam("groupId") String groupId) {
        model.addAttribute("groupId", groupId);
        return "directory/groupUnassign";
    }

    @RequestMapping("/directory/admin/user/unassign/submit")
    public String submitUnassignGroup(ModelMap model, @RequestParam("assignId") String assignId, @RequestParam("groupId") String groupId) {

        String[] ids = assignId.split(",");
        for (int i = 0; i < ids.length; i++) {
            userDao.removeUserFromGroup(ids[i], groupId);
        }
        return "directory/groupUnassign";
    }

    @RequestMapping("/directory/admin/group/list")
    public String listGroup(ModelMap model) {
        Collection<Group> groups = groupDao.getGroupList("", null, null, null, null);
        model.addAttribute("groups", groups);
        return "directory/groupList";
    }

    @RequestMapping("/directory/admin/group/new")
    public String newGroup(ModelMap model) {
        model.addAttribute("group", new Group());
        return "directory/groupNew";
    }

    @RequestMapping("/directory/admin/group/view/(*:id)")
    public String viewGroup(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "id", required = false) String groupId) {
        Group group = groupDao.getGroupById(groupId);
        model.addAttribute("group", group);
        return "directory/groupView";
    }

    @RequestMapping("/directory/admin/group/edit")
    public String editGroup(ModelMap model, @RequestParam("groupId") String groupId) {
        Group group = groupDao.getGroupById(groupId);
        model.addAttribute("group", group);
        return "directory/groupEdit";
    }

    @RequestMapping("/directory/admin/group/submit")
    public String submitGroup(ModelMap model, @ModelAttribute("group") Group group, BindingResult result) {
        validator.validate(group, result);

        if (result.hasErrors()) {
            return "directory/groupEdit";
        }

        Group editGroup = groupDao.getGroupById(group.getId());
        editGroup.setName(group.getName());
        editGroup.setDescription(group.getDescription());

        groupDao.updateGroup(editGroup);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/group/remove")
    public String removeGroup(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "groupId") String groupId) {
        groupDao.deleteGroup(groupDao.getGroupById(groupId));
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/group/removeMultiple")
    public String removeMultipleGroups(ModelMap model, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "groupIds") String groupIds) {
        StringTokenizer strToken = new StringTokenizer(groupIds, ",");
        while (strToken.hasMoreTokens()) {
            String groupId = (String) strToken.nextElement();
            groupDao.deleteGroup(groupDao.getGroupById(groupId));
        }
       
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/admin/group/save")
    public String saveGroup(ModelMap model, @ModelAttribute("group") Group group, BindingResult result) {
        validator.validate(group, result);

        if (groupDao.getGroupById(group.getId()) != null) {
            model.addAttribute("error", "usersAdmin.group.id.already.exist");
            return "directory/groupNew";
        }

        if (result.hasErrors()) {
            return "directory/groupNew";
        }

        groupDao.addGroup(group);
        return "directory/saveOrEditSuccess";
    }

    @RequestMapping("/directory/client/user/profile/edit")
    public String editUserProfile(ModelMap model) {
        User user = userDao.getUserByUsername(workflowFacade.getWorkflowUserManager().getCurrentUsername());

        user.setConfirmPassword(user.getPassword());
        model.addAttribute("user", user);
        model.addAttribute("timeZoneList", TimeZoneUtil.getList());

        return "directory/userProfileEdit";
    }

    @RequestMapping(value = "/directory/client/user/profile/submit", method = RequestMethod.POST)
    public String submitUserProfile(ModelMap model, @ModelAttribute("user") User user, BindingResult result) {

        if(!workflowFacade.getWorkflowUserManager().getCurrentUsername().equals(user.getUsername())){
            model.addAttribute("error", "usersAdmin.no.permission");
            model.addAttribute("timeZoneList", TimeZoneUtil.getList());

            return "directory/userProfileEdit";
        }

        validator.validate(user, result);

        User validateUser = userDao.getUserById(user.getId());

        boolean isUsernameExist = (userDao.getUserByUsername(user.getUsername()) != null ? true : false);
        if (isUsernameExist && !validateUser.getUsername().equals(user.getUsername())) {
            model.addAttribute("user", user);
            model.addAttribute("error", "usersAdmin.no.permission");
            model.addAttribute("timeZoneList", TimeZoneUtil.getList());

            return "directory/userProfileEdit";
        }

        if (!user.getPassword().equals(user.getConfirmPassword())) {
            model.addAttribute("user", user);
            model.addAttribute("error", "usersAdmin.password.not.match");
            model.addAttribute("timeZoneList", TimeZoneUtil.getList());

            return "directory/userProfileEdit";
        }

        if (result.hasErrors()) {
            model.addAttribute("user", user);
            model.addAttribute("timeZoneList", TimeZoneUtil.getList());

            return "directory/userProfileEdit";
        }

        User editUser = userDao.getUserById(user.getId());

        editUser.setFirstName(user.getFirstName());
        editUser.setLastName(user.getLastName());
        editUser.setPassword(user.getPassword());
        editUser.setEmail(user.getEmail());
        editUser.setTimeZone(user.getTimeZone());

        userDao.updateUser(editUser);

        return "directory/saveOrEditSuccess";
    }
}
