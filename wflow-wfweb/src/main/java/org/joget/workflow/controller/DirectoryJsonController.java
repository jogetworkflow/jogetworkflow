package org.joget.workflow.controller;

import java.io.IOException;
import java.io.Writer;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.stereotype.Controller;
import org.joget.directory.model.dao.organization.OrganizationDao;
import org.joget.directory.model.Organization;
import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.Department;
import org.joget.directory.model.dao.grade.GradeDao;
import org.joget.directory.model.Grade;
import org.joget.directory.model.dao.employment.EmploymentDao;
import org.joget.directory.model.Employment;
import org.joget.directory.model.Group;
import org.joget.directory.model.User;
import org.joget.directory.model.dao.group.GroupDao;
import org.joget.directory.model.dao.user.UserDao;
import java.util.ArrayList;
import java.util.List;
import org.joget.workflow.model.WorkflowFacade;
import org.springframework.security.Authentication;
import org.springframework.security.AuthenticationException;
import org.springframework.security.AuthenticationManager;
import org.springframework.security.context.SecurityContextHolder;
import org.springframework.security.providers.UsernamePasswordAuthenticationToken;

@Controller
public class DirectoryJsonController {

    @Autowired
    OrganizationDao organizationDao;

    @Autowired
    DepartmentDao departmentDao;

    @Autowired
    GradeDao gradeDao;

    @Autowired
    EmploymentDao employmentDao;

    @Autowired
    GroupDao groupDao;

    @Autowired
    UserDao userDao;

    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    WorkflowFacade workflowFacade;

    /**
     * Manage org chart
     */
    @RequestMapping("/json/directory/admin/organization/list")
    public void listOrganization(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Organization> organizations = null;

        if (name == null || name.equals("")) {
            organizations = organizationDao.getOrganizationList("", sort, desc, start, rows);
        } else {
            organizations = organizationDao.getOrganizationList(name, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (Organization organization : organizations) {
            Map data = new HashMap();
            data.put("id", organization.getId());
            data.put("name", organization.getName());
            data.put("description", organization.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", organizationDao.getTotalOrganizations());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/organization/department/list")
    public void departmentListByOrganization(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "organizationId", required = false) String organizationId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {
        Collection<Department> departments = null;

        if (organizationId != null && organizationId.trim().length() != 0) {
            Organization organization = organizationDao.getOrganizationById(organizationId);
            departments = departmentDao.getDepartmentByOrganization(organization.getName(), sort, desc, start, rows);
        }
        
        JSONObject jsonObject = new JSONObject();
        for (Department department : departments) {
            Map data = new HashMap();
            data.put("id", department.getId());
            data.put("name", department.getName());
            data.put("description", department.getDescription());
            if (department.getParent() != null){
                data.put("parentDepartment", department.getParent().getName());
            }
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", departmentDao.getTotalDepartmentsByOrganizationId(organizationId));

        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/organization/grade/list")
    public void gradeListByOrganization(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "organizationId") String organizationId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Organization organization = organizationDao.getOrganizationById(organizationId);
        Collection<Grade> grades = gradeDao.getGradeByOrganization(organization.getName(), sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (Grade grade : grades) {
            Map data = new HashMap();
            data.put("id", grade.getId());
            data.put("name", grade.getName());
            data.put("description", grade.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", gradeDao.getTotalGradesByOrganizationId(organizationId));
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/organization/subdepartment/list")
    public void subdepartmentList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "departmentId") String departmentId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Department> subdepartments = departmentDao.getDepartmentByParent(departmentId, sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (Department department : subdepartments) {
            Map data = new HashMap();
            data.put("id", department.getId());
            data.put("name", department.getName());
            data.put("description", department.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", departmentDao.getTotalSubDepartmentsByParentId(departmentId));
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/organization/employee/list")
    public void employeeList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "departmentId") String departmentId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Department department = departmentDao.getDepartmentById(departmentId);
        Collection<Employment> employments = employmentDao.getEmployeeByDepartment(department.getName(), sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (Employment employment : employments) {
            Map data = new HashMap();
            data.put("id", employment.getId());
            data.put("firstName", (employment.getUser() != null ? employment.getUser().getFirstName() : null));
            data.put("lastName", (employment.getUser() != null ? employment.getUser().getLastName() : null));
            data.put("startDate", employment.getStartDate());
            data.put("endDate", employment.getEndDate());

            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", employmentDao.getTotalEmploymentsByDepartmentId(departmentId));
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/organization/employee/assign/list")
    public void assignEmployee(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("departmentId") String departmentId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Employment> employments = employmentDao.getAssignEmployeeList(departmentId, sort, desc, start, rows);

        JSONObject jsonObject = new JSONObject();
        for (Employment employment : employments) {
            Map data = new HashMap();
            data.put("id", employment.getId());
            data.put("firstName", (employment.getUser() != null ? employment.getUser().getFirstName() : null));
            data.put("lastName", (employment.getUser() != null ? employment.getUser().getLastName() : null));
            data.put("startDate", employment.getStartDate());
            data.put("endDate", employment.getEndDate());

            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", employments.size());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/organization/employee/unassign/list")
    public void unassignEmployee(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("departmentId") String departmentId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Employment> employments = employmentDao.getUnassignEmployeeList(departmentId, sort, desc, start, rows);

        JSONObject jsonObject = new JSONObject();
        for (Employment employment : employments) {
            Map data = new HashMap();
            data.put("id", employment.getId());
            data.put("firstName", (employment.getUser() != null ? employment.getUser().getFirstName() : null));
            data.put("lastName", (employment.getUser() != null ? employment.getUser().getLastName() : null));
            data.put("startDate", employment.getStartDate());
            data.put("endDate", employment.getEndDate());

            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", employments.size());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    /**
     * Manage users and groups
     */
    @RequestMapping("/json/directory/admin/group/list")
    public void groupList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Group> groupList = null;

        if (name == null || name.equals("")) {
            groupList = groupDao.getGroupList("", sort, desc, start, rows);
        } else {
            groupList = groupDao.getGroupList(name, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (Group group : groupList) {
            Map data = new HashMap();
            data.put("id", group.getId());
            data.put("name", group.getName());
            data.put("description", group.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", groupDao.getTotalGroups());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/user/group/list")
    public void groupListByUserId(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("userId") String userId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Group> groupList = groupDao.getGroupByUserId(userId, sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (Group group : groupList) {
            Map data = new HashMap();
            data.put("id", group.getId());
            data.put("name", group.getName());
            data.put("description", group.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", groupDao.getTotalGroupsByUserId(userId));
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/group/user/list")
    public void userListByGroupId(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("groupId") String groupId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<User> userList = userDao.getUserByGroupId(groupId, sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (User user : userList) {
            Map data = new HashMap();
            data.put("id", user.getId());
            data.put("firstName", user.getFirstName());
            data.put("lastName", user.getLastName());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", userDao.getTotalUsersByGroupId(groupId));
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/user/list")
    public void userList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "username", required = false) String username, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<User> userList = null;

        if (username == null || username.equals("")) {
            userList = userDao.getUserList("", sort, desc, start, rows);
        } else {
            userList = userDao.getUserList(username, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (User user : userList) {
            Map data = new HashMap();
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("firstName", user.getFirstName());
            data.put("lastName", user.getLastName());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", userDao.getTotalUsers());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/group/assign/list")
    public void assignGroup(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("userId") String userId, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Group> groups = null;

        if (name == null || name.equals("")) {
            groups = groupDao.getAssignGroups("", userId, sort, desc, start, rows);
        } else {
            groups = groupDao.getAssignGroups(name, userId, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (Group group : groups) {
            Map data = new HashMap();
            data.put("id", group.getId());
            data.put("name", group.getName());
            data.put("description", group.getDescription());

            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", groupDao.getTotalGroups());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/group/unassign/list")
    public void unassignGroup(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("userId") String userId, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Group> groups = null;

        if (name == null || name.equals("")) {
            groups = groupDao.getUnAssignGroups("", userId, sort, desc, start, rows);
        } else {
            groups = groupDao.getUnAssignGroups(name, userId, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (Group group : groups) {
            Map data = new HashMap();
            data.put("id", group.getId());
            data.put("name", group.getName());
            data.put("description", group.getDescription());

            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", groupDao.getTotalGroups());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/user/assign/list")
    public void assignUser(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("groupId") String groupId, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<User> users = null; 

        if (name == null || name.equals("")) {
            users = userDao.getAssignUsers("", groupId, sort, desc, start, rows);
        } else {
            users = userDao.getAssignUsers(name, groupId, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (User user : users) {
            Map data = new HashMap();
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("firstName", user.getFirstName());
            data.put("lastName", user.getLastName());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", userDao.getTotalUsers());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/user/unassign/list")
    public void unassignUser(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam("groupId") String groupId, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<User> users = null;

        if (name == null || name.equals("")) {
            users = userDao.getUnAssignUsers("", groupId, sort, desc, start, rows);
        } else {
            users = userDao.getUnAssignUsers(name, groupId, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (User user : users) {
            Map data = new HashMap();
            data.put("id", user.getId());
            data.put("username", user.getUsername());
            data.put("firstName", user.getFirstName());
            data.put("lastName", user.getLastName());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", userDao.getTotalUsers());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/admin/user/update/organizationgrade")
    public void updateOrganizationGrade(Writer writer, @RequestParam("orgId") String orgId) throws JSONException {
        Collection<Department> departments = departmentDao.getRecursiveDepartmentByOrganizationId(orgId);
        Organization organization = organizationDao.getOrganizationById(orgId);
        Collection<Grade> gradeList = gradeDao.getGradeByOrganization(organization.getName(), null, null, null, null);

        JSONObject jsonObject = new JSONObject();

        if (departments.size() > 0) {
            for (Department department : departments) {

                Department recursiveDept = department;
                String recursive = "";
                while (recursiveDept.getParent() != null) {
                    recursive += "--";
                    recursiveDept = recursiveDept.getParent();
                }

                Map data = new HashMap();
                data.put("id", department.getId());
                data.put("name", department.getName());
                data.put("parent", department.getParent());
                data.put("recursive", recursive);
                jsonObject.accumulate("departments", data);
            }
        } else {
            jsonObject.accumulate("departments", null);
        }

        if (gradeList.size() > 0) {
            for (Grade grade : gradeList) {
                Map data = new HashMap();
                data.put("id", grade.getId());
                data.put("name", grade.getName());
                jsonObject.accumulate("grades", data);
            }
        } else {
            jsonObject.accumulate("grades", null);
        }

        jsonObject.write(writer);
    }

    @RequestMapping("/json/directory/user/sso")
    public void singleSignOn(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "username", required = true) String username, @RequestParam(value = "password") String password) throws JSONException, IOException, ServletException {

        try {
            Authentication request = new UsernamePasswordAuthenticationToken(username, password);
            Authentication result = authenticationManager.authenticate(request);
            SecurityContextHolder.getContext().setAuthentication(result);
        } catch (AuthenticationException e) {

        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.accumulate("username", workflowFacade.getWorkflowUserManager().getCurrentUsername());

        writeJson(writer, jsonObject, callback);
    }

    protected static void writeJson(Writer writer, JSONObject jsonObject, String callback) throws IOException, JSONException {
        if (callback != null && callback.trim().length() > 0) {
            writer.write(callback + "(");
        }
        jsonObject.write(writer);
        if (callback != null && callback.trim().length() > 0) {
            writer.write(")");
        }
    }
}
