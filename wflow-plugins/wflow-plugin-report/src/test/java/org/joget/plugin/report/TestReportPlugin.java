package org.joget.plugin.report;

import org.joget.plugin.base.Plugin;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.AuditTrail;
import java.util.HashMap;
import java.util.Map;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:pluginBaseApplicationContext.xml", "classpath:wfengineApplicationContext.xml"})
public class TestReportPlugin {

    @Autowired
    PluginManager pluginManager;
    
    private String pluginFile = "target/wflow-plugin-report-2.0-SNAPSHOT.jar";
    private String pluginName = "org.joget.plugin.report.ReportPlugin";

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
        AuditTrail auditTrail = new AuditTrail();
        auditTrail.setMessage("test_report_plugin");
        auditTrail.setMethod("testPlugin");
        props.put("auditTrail", auditTrail);
        props.put("pluginManager", pluginManager);
        pluginManager.testPlugin(getPlugin(), getPluginLocation(), props, true);
    }
}
