package org.joget.plugin.directory;

import org.joget.directory.model.dao.organization.OrganizationDao;
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
public class TestDepartmentVariablePlugin {

    @Autowired
    PluginManager pluginManager;

    @Autowired
    OrganizationDao organizationDao;
    
    private String pluginFile = "target/wflow-plugin-departmentVariable-2.0-SNAPSHOT.jar";
    private String pluginName = "org.joget.plugin.directory.DepartmentVariablePlugin";

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
        props.put("organizationDao", organizationDao);
        props.put("pluginManager", pluginManager);
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
