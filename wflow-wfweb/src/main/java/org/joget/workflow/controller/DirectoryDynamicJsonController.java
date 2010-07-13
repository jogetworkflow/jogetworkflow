package org.joget.workflow.controller;

import org.joget.directory.model.Department;
import org.joget.directory.model.Group;
import org.joget.directory.model.User;
import org.joget.directory.model.service.DirectoryManager;
import java.io.IOException;
import java.io.Writer;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class DirectoryDynamicJsonController {

    @Autowired
    @Qualifier("main")
    private DirectoryManager directoryManager;

    @RequestMapping("/json/directory/dynamic/admin/group/list")
    public void groupList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Group> groupList = null;
        if (name == null || name.equals("")) {
            groupList = directoryManager.getGroupList("", sort, desc, start, rows);
        } else {
            groupList = directoryManager.getGroupList(name, sort, desc, start, rows);
        }

        JSONObject jsonObject = new JSONObject();
        for (Group group : groupList) {
            Map data = new HashMap();
            data.put("id", group.getId());
            data.put("name", group.getName());
            data.put("description", group.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", directoryManager.getTotalGroups());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/dynamic/admin/user/list")
    public void userList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "name", required = false) String name, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<User> userList = null;
        if (name == null || name.equals("")) {
            userList = directoryManager.getUserList("", sort, desc, start, rows);
        } else {
            userList = directoryManager.getUserList(name, sort, desc, start, rows);
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

        jsonObject.accumulate("total", directoryManager.getTotalUsers());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping("/json/directory/dynamic/admin/department/list")
    public void departmentList(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "organizationId", required = false) String organizationId, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws JSONException, IOException {

        Collection<Department> departmentList = directoryManager.getDepartmentListByOrganization(organizationId, sort, desc, start, rows);

        JSONObject jsonObject = new JSONObject();
        for (Department department : departmentList) {
            Map data = new HashMap();
            data.put("id", department.getId());
            data.put("name", department.getName());
            data.put("description", department.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", directoryManager.getTotalDepartments(organizationId));
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }
}
