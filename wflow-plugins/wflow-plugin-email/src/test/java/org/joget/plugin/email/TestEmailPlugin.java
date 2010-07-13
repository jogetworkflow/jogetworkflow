package org.joget.plugin.email;

import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import java.util.HashMap;
import java.util.Map;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:pluginBaseApplicationContext.xml"})
public class TestEmailPlugin {

    @Autowired
    PluginManager pluginManager;

    private String pluginFile = "target/wflow-plugin-email-2.0-SNAPSHOT.jar";
    private String pluginName = "org.joget.plugin.email.EmailPlugin";

    public String getPluginLocation() {
        return pluginFile;
    }

    public String getPlugin() {
        return pluginName;
    }

    @Test
    public void testPluginManager() {
        Assert.notNull(pluginManager);
    }

    //@Test
    public void testPlugin() {
        Plugin plugin = pluginManager.getPlugin(getPlugin());
//        Map props = new HashMap();
//        props.put("pluginManager", pluginManager);
//        props.put("from", "email@domain");
//        props.put("host", "host");
//        props.put("port", "25");
//        props.put("toSpecific", "email@domain");
//        props.put("cc", "email@domain");
//        props.put("subject", "TEST FROM EMAIL PLUGIN");
//        props.put("message", "TEST FROM EMAIL PLUGIN\nline 2 TEST FROM EMAIL PLUGIN");
//        pluginManager.testPlugin(getPlugin(), getPluginLocation(), props, true);
    }
}
