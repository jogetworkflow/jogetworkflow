package org.joget.plugin.etl;

import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.WorkflowAssignment;
import java.util.HashMap;
import java.util.Map;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:pluginBaseApplicationContext.xml", "classpath:formApplicationContext.xml"})
public class TestFormDataEtlPlugin {

    @Autowired
    PluginManager pluginManager;
    
    private String pluginFile = "target/wflow-plugin-formDataEtl-2.0-SNAPSHOT.jar";
    private String pluginName = "org.joget.plugin.etl.FormDataEtlPlugin";

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

        WorkflowAssignment wa = new WorkflowAssignment();
        wa.setActivityName("Some Name");
        wa.setProcessId("1_test_test_isr");
        wa.setProcessVersion("1.0");

        props.put("formDataTable", "test_isr_new_req");
        props.put("query", "INSERT INTO aaa VALUES ('#formData.c_text_1#', '#assignment.processVersion#', '#assignment.activityName#', '#assignment.processId#')");
        props.put("wfAssignment", wa);

        pluginManager.testPlugin(getPlugin(), getPluginLocation(), props, true);
    }
}
