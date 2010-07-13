package org.joget.plugin.referenceid;

import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import java.util.HashMap;
import java.util.Map;
import org.joget.workflow.model.WorkflowAssignment;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:pluginBaseApplicationContext.xml", "classpath:formApplicationContext.xml", "classpath:wfengineApplicationContext.xml"})
public class TestReferenceIdPlugin {

    @Autowired
    PluginManager pluginManager;
    
    private String pluginFile = "target/wflow-plugin-referenceId-2.0-SNAPSHOT.jar";
    private String pluginName = "org.joget.plugin.referenceid.ReferenceIdPlugin";

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
        Map props = new HashMap();
        props.put("pluginManager", pluginManager);

        props.put("formDataTable", "approve");
        props.put("prefix", "PREFIX-");
        props.put("noOfDigit", "6");
        props.put("variableId", "status");

        WorkflowAssignment as = new WorkflowAssignment();
        as.setProcessId("123");

        props.put("workflowAssignment", as);

        //pluginManager.testPlugin(getPlugin(), getPluginLocation(), props, true);

        ReferenceIdPlugin rip = new ReferenceIdPlugin();
        rip.execute(props);
    }
}
