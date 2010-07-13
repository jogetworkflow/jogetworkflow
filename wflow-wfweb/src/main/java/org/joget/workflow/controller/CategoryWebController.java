package org.joget.workflow.controller;

import org.joget.form.model.Category;
import org.joget.form.model.service.FormManager;
import java.io.IOException;
import java.io.Writer;
import java.util.Collection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.validation.Validator;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CategoryWebController {

    @Autowired
    private FormManager formManager;
    
    @Autowired
    private Validator validator;

    @RequestMapping("/admin/form/category/list")
    public String categoryList(ModelMap map) {
        Collection<Category> categoryList = formManager.getCategories(null, null, null, null);
        map.addAttribute(categoryList);

        return "category/categoryList";
    }

    @RequestMapping("/admin/form/category/view/(*:categoryId)")
    public String categoryView(ModelMap map, @RequestParam("categoryId") String categoryId) throws IOException {
        Category category = formManager.getCategoryById(categoryId);
        map.addAttribute("category", category);
        return "category/categoryView";
    }

    @RequestMapping("/admin/form/category/edit/(*:categoryId)")
    public String categoryEdit(ModelMap map, @RequestParam("categoryId") String categoryId) throws IOException {
        Category category = formManager.getCategoryById(categoryId);
        map.addAttribute("category", category);
        return "category/categoryEdit";
    }

    @RequestMapping("/admin/form/category/create")
    public String categoryCreate(ModelMap map) {
        map.addAttribute("category", new Category());
        return "category/categoryCreate";
    }

    @RequestMapping(value = "/admin/form/category/create/submit", method = RequestMethod.POST)
    public String categoryCreateSubmit(ModelMap map, @ModelAttribute("category") Category category, BindingResult result) {
        validator.validate(category, result);

        if (result.hasErrors()) {
            return "category/categoryCreate";
        }

        formManager.saveCategory(category);
        return "category/categoryEditSuccess";
    }

    @RequestMapping(value = "/admin/form/category/delete", method = RequestMethod.POST)
    public String categoryDelete(@RequestParam("categoryId") String categoryId) throws IOException {
        formManager.deleteCategory(categoryId);
        return "category/categoryList";
    }

    @RequestMapping(value = "/admin/form/category/save", method = RequestMethod.POST)
    public String categorySave(Writer writer, @ModelAttribute("category") Category category) throws IOException {
        Category oldCategory = formManager.getCategoryById(category.getId());
        oldCategory.setName(category.getName());
        oldCategory.setDescription(category.getDescription());
        formManager.saveCategory(oldCategory);
        return "category/categoryEditSuccess";
    }
}
