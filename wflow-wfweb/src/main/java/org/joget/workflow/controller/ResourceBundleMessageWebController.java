package org.joget.workflow.controller;

import org.joget.commons.util.SetupManager;
import org.joget.commons.spring.model.ResourceBundleMessage;
import org.joget.commons.spring.model.ResourceBundleMessageDao;
import org.joget.commons.util.ResourceBundleUtil;
import org.joget.commons.util.FileStore;
import org.springframework.web.multipart.MultipartFile;
import java.util.Arrays;
import java.util.Locale;
import java.io.IOException;
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
public class ResourceBundleMessageWebController {

    @Autowired
    private ResourceBundleMessageDao rbmDao;

    @Autowired
    private ResourceBundleUtil resourceBundleUtil;

    @Autowired
    private Validator validator;

    @Autowired
    private SetupManager setupManager;

    @RequestMapping("/settings/resource/message/list")
    public String messageList(ModelMap map) {
        map.addAttribute("localeList", getSortedLocalList());
        return "message/messageList";
    }

    @RequestMapping("/settings/resource/message/view/(*:id)")
    public String messageView(ModelMap map, @RequestParam("id") String id) {
        ResourceBundleMessage message = rbmDao.getMessageById(id);

        map.addAttribute("message", message);
        return "message/messageView";
    }

    @RequestMapping("/settings/resource/message/create")
    public String messageCreate(ModelMap map) {
        map.addAttribute("message", new ResourceBundleMessage());
        map.addAttribute("localeList", getSortedLocalList());
        return "message/messageCreate";
    }

    @RequestMapping(value = "/settings/resource/message/create/submit", method = RequestMethod.POST)
    public String messageCreateSubmit(ModelMap map, @ModelAttribute("message") ResourceBundleMessage message, BindingResult result) {
        validator.validate(message, result);

        if (result.hasErrors()) {
            map.addAttribute("localeList", getSortedLocalList());
            return "message/messageCreate";
        }

        rbmDao.saveOrUpdate(message);
        return "message/messageCreateSuccess";
    }

    @RequestMapping("/settings/resource/message/edit/(*:id)")
    public String messageEdit(ModelMap map, @RequestParam("id") String id) {
        ResourceBundleMessage message = rbmDao.getMessageById(id);
        map.addAttribute("localeList", getSortedLocalList());
        map.addAttribute("message", message);
        return "message/messageEdit";
    }

    @RequestMapping(value = "/settings/resource/message/save", method = RequestMethod.POST)
    public String messageSave(@ModelAttribute("message") ResourceBundleMessage message) {
        ResourceBundleMessage oldMessage = rbmDao.getMessageById(message.getId());
        oldMessage.setKey(message.getKey());
        oldMessage.setLocale(message.getLocale());
        oldMessage.setMessage(message.getMessage());
        rbmDao.saveOrUpdate(oldMessage);
        return "message/messageEditSuccess";
    }

    @RequestMapping("/settings/resource/message/delete")
    public String messageDelete(ModelMap map, @RequestParam("id") String id) {
        ResourceBundleMessage message = rbmDao.getMessageById(id);
        rbmDao.delete(message);

        map.addAttribute("localeList", getSortedLocalList());
        return "message/messageList";
    }

    protected String[] getSortedLocalList() {
        Locale[] localeList = Locale.getAvailableLocales();
        String[] localeStringList = new String[localeList.length];
        for (int i = 0; i < localeList.length; i++) {
            localeStringList[i] = localeList[i].toString();
        }
        Arrays.sort(localeStringList);

        return localeStringList;
    }

    @RequestMapping("/settings/resource/message/import")
    public String packageImport(ModelMap map) {
        return "message/messageImport";
    }
    
    @RequestMapping(value = "/settings/resource/message/import/submit", method = RequestMethod.POST)
    public String POFileUpload(ModelMap map) throws Exception {

        String systemLocale = setupManager.getSettingByProperty("systemLocale").getValue();
        if(systemLocale == null || systemLocale.equalsIgnoreCase(""))
            systemLocale = "en_US";
        
        try{
            MultipartFile multiPartfile = FileStore.getFile("localeFile");
            resourceBundleUtil.POFileImport(multiPartfile,systemLocale);
        }catch(IOException e){
            
        }

        map.addAttribute("localeList", getSortedLocalList());
        return "message/messageList";
    }
}
