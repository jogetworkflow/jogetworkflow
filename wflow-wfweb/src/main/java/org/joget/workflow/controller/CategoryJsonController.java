package org.joget.workflow.controller;

import org.joget.form.model.Category;
import org.joget.form.model.service.FormManager;
import java.io.IOException;
import java.io.Writer;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CategoryJsonController {

    @Autowired
    private FormManager formManager;

    @RequestMapping("/json/form/category/list")
    public void list(Writer writer, @RequestParam(value = "callback", required = false) String callback, @RequestParam(value = "sort", required = false) String sort, @RequestParam(value = "desc", required = false) Boolean desc, @RequestParam(value = "start", required = false) Integer start, @RequestParam(value = "rows", required = false) Integer rows) throws IOException, JSONException {
        List<Category> categoryList = formManager.getCategories(sort, desc, start, rows);
        JSONObject jsonObject = new JSONObject();
        for (Category category : categoryList) {
            Map data = new HashMap();
            data.put("id", category.getId());
            data.put("name", category.getName());
            data.put("description", category.getDescription());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", formManager.getTotalCategories());
        jsonObject.accumulate("start", start);
        jsonObject.accumulate("sort", sort);
        jsonObject.accumulate("desc", desc);

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }

    @RequestMapping(value = "/json/form/category/create/submit", method = RequestMethod.POST)
    public void jsonSubmitCreateCategory(Writer writer, @RequestParam(value = "callback", required = false) String callback,
            @RequestParam(value = "categoryId", required = true) String categoryId,
            @RequestParam(value = "categoryName", required = true) String categoryName,
            @RequestParam(value = "categoryDescription", required = false) String categoryDescription) throws JSONException, IOException {

        JSONObject jsonObject = new JSONObject();

        if (formManager.getCategoryById(categoryId) != null) {
            jsonObject.accumulate("categoryIdExist", true);
        } else {
            jsonObject.accumulate("categoryIdExist", false);
        }

        Category category = new Category();
        category.setId(categoryId);
        category.setName(categoryName);
        category.setDescription(categoryDescription);
        formManager.saveCategory(category);

        jsonObject.accumulate("status", "success");

        if (callback != null && callback.trim().length() != 0) {
            writer.write(callback + "(" + jsonObject + ");");
        } else {
            jsonObject.write(writer);
        }
    }
}
