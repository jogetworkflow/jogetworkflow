package org.joget.plugin.notification;

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
@ContextConfiguration(locations = {"classpath:pluginBaseApplicationContext.xml", "classpath:wfengineApplicationContext.xml", "classpath:directoryApplicationContext.xml"})
public class TestUserNotificationPlugin {

    @Autowired
    PluginManager pluginManager;
    
    private String pluginFile = "target/wflow-plugin-userNotification-2.0-SNAPSHOT.jar";
    private String pluginName = "org.joget.plugin.notification.UserNotificationPlugin";

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

    @Test
    public void testPlugin() {
        Plugin plugin = pluginManager.getPlugin(getPlugin());
        Map props = new HashMap();
        props.put("pluginManager", pluginManager);
        pluginManager.testPlugin(getPlugin(), getPluginLocation(), props, true);
    }
}
