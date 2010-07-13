package org.joget.plugin.base;

import org.joget.commons.util.LogUtil;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collection;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:pluginBaseApplicationContext.xml"})
public class TestPluginManager {

    @Autowired
    PluginManager pluginManager;

    private String samplePluginFile = "../wflow-plugins/wflow-plugin-sample/target/wflow-plugin-sample-2.0-SNAPSHOT.jar";
    private String samplePlugin = "org.joget.plugin.sample.SamplePlugin";

    public String getSamplePluginFile() {
        return samplePluginFile;
    }

    public String getSamplePlugin() {
        return samplePlugin;
    }

    @Test
    public void testPluginManager() {
        Assert.notNull(pluginManager);
    }

    //@Test
    public void testInstall() {

        InputStream in = null;
        try {
            LogUtil.info(getClass().getName(), " ===testInstall=== ");
            File file = new File(getSamplePluginFile());
            if (file.exists()) {
                in = new FileInputStream(file);
                pluginManager.upload(file.getName(), in);
            }
        } catch (Exception ex) {
            Logger.getLogger(PluginManager.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                if (in != null) {
                    in.close();
                }
            } catch (IOException ex) {
                Logger.getLogger(PluginManager.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Test
    public void testList() {
        LogUtil.info(getClass().getName(), " ===testList=== ");
        Collection<Plugin> list = pluginManager.list();
        for (Plugin p : list) {
            LogUtil.info(getClass().getName(), " plugin: " + p.getName() + "; " + p.getClass().getName());
        }
        //Assert.isTrue(list.size() > 0);
    }

    //@Test
    public void testExecute() {
        LogUtil.info(getClass().getName(), " ===testExecute=== ");

        Object result = pluginManager.execute(getSamplePlugin(), null);
        //Assert.isTrue(result != null);
    }

    //@Test
    public void testUninstall() {
        LogUtil.info(getClass().getName(), " ===testUninstall=== ");
        pluginManager.uninstall(getSamplePlugin());
    }

    @Test
    public void testPluginTest() {
        LogUtil.info(getClass().getName(), " ===testPluginTest=== ");
        pluginManager.testPlugin(getSamplePlugin(), getSamplePluginFile(), null, true);
    }
}
