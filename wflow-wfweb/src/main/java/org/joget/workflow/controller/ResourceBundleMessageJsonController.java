package org.joget.workflow.controller;

import org.joget.commons.spring.model.ResourceBundleMessage;
import org.joget.commons.spring.model.ResourceBundleMessageDao;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ResourceBundleMessageJsonController {

    @Autowired
    private ResourceBundleMessageDao rbmDao;

    @RequestMapping("/json/workflow/resource/message/list")
    public void messageList(Writer writer,
            @RequestParam(value = "locale", required = false) String locale,
            @RequestParam(value = "callback", required = false) String callback,
            @RequestParam(value = "sort", required = false) String sort,
            @RequestParam(value = "desc", required = false) Boolean desc,
            @RequestParam(value = "start", required = false) Integer start,
            @RequestParam(value = "rows", required = false) Integer rows,
            @RequestParam(value = "key", required = false) String key,
            @RequestParam(value = "message", required = false) String message) throws IOException, JSONException {
        String condition = "";
        List<String> param = new ArrayList<String>();

        if (locale != null && locale.trim().length() != 0) {
            condition += "e.locale like ? ";
            param.add("%" + locale + "%");
        }

        if (key != null && key.trim().length() != 0) {
            condition += "e.key like ? ";
            param.add("%" + key + "%");
        }

        if (message != null && message.trim().length() != 0) {
            condition += "e.message like ? ";
            param.add("%" + message + "%");
        }

        if (condition.length() > 0) {
            condition = "WHERE " + condition;
        }
        
        List<ResourceBundleMessage> messageList = rbmDao.getMessages(condition, param.toArray(new String[param.size()]), sort, desc, start, rows);

        JSONObject jsonObject = new JSONObject();
        for (ResourceBundleMessage msg : messageList) {
            Map data = new HashMap();
            data.put("id", msg.getId());
            data.put("key", msg.getKey());
            data.put("locale", msg.getLocale());
            data.put("message", msg.getMessage());
            jsonObject.accumulate("data", data);
        }

        jsonObject.accumulate("total", rbmDao.count(" e " + condition, param.toArray(new String[param.size()])));
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
