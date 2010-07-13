package org.joget.plugin.beanshell;

import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:pluginBaseApplicationContext.xml", "classpath:directoryApplicationContext.xml"})
public class TestBeanShellPlugin {

    @Autowired
    PluginManager pluginManager;
    
    private String pluginFile = "target/wflow-plugin-beanshell-2.0-SNAPSHOT.jar";
    private String pluginName = "org.joget.plugin.beanshell.BeanShellPlugin";

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
        System.out.println(" PLUGIN: " + plugin);
        Map props = new HashMap();
        props.put("pluginManager", pluginManager);

        String script = ""
                + "import org.joget.directory.model.dao.organization.*;"
                + "import java.util.*;"
                + "OrganizationDao dao = pluginManager.getBean(\"organizationDao\");"
                + "Collection orgList = dao.getOrganizationList(null, \"name\", false, 0, 100);"
                + "for (Object org: orgList) {"
                + "  System.out.println(org);"
                + "}"
                + "Map map = new org.apache.commons.collections.SequencedHashMap();"
                + "map.put(\"2\",\"2\");"
                + "map.put(\"1\",\"1\");"
                + "map.put(\"3\",\"3\");"
                + "System.out.println(map);"
                + "org.apache.commons.mail.MultiPartEmail email = new org.apache.commons.mail.MultiPartEmail();"
                + "System.out.println(email);"
                ;
        props.put("script", script);
        pluginManager.testPlugin(getPlugin(), getPluginLocation(), props, true);
    }

    @Test
    public void testList() {
        System.out.println(" ===testList=== ");
        Collection<Plugin> list = pluginManager.list();
        for (Plugin p : list) {
            System.out.println(" plugin: " + p.getName() + "; " + p.getClass().getName());
        }
        //Assert.isTrue(list.size() > 0);
    }
}
