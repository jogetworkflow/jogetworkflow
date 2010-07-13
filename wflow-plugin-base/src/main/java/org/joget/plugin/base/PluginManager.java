package org.joget.plugin.base;

import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;
import java.util.Properties;
import java.util.jar.JarFile;
import org.apache.felix.framework.Felix;
import org.apache.felix.framework.util.StringMap;
import org.osgi.framework.Bundle;
import org.osgi.framework.BundleContext;
import org.osgi.framework.ServiceReference;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class PluginManager implements ApplicationContextAware {

    private Felix felix = null;
    private String baseDirectory = SetupManager.getBaseSharedDirectory() + File.separator + "plugins";
    private ApplicationContext applicationContext;

    public PluginManager() {
        init();
    }

    public PluginManager(String baseDirectory) {
        if (baseDirectory != null) {
            this.baseDirectory = baseDirectory;
        }
        init();
    }

    /**
     * Retrieves plugin base directory from system setup
     */
    public String getBaseDirectory() {
        try {
            SetupManager setupManager = (SetupManager) applicationContext.getBean("setupManager");
            String dataFileBasePath = setupManager.getSettingValue("dataFileBasePath");
            if (dataFileBasePath != null && dataFileBasePath.length() > 0) {
                return dataFileBasePath + File.separator + "plugins";
            } else {
                return baseDirectory;
            }
        } catch (Exception ex) {
            return baseDirectory;
        }
    }

    /**
     * Initializes the plugin manager
     */
    protected void init() {
        Properties config = new Properties();
        try {
            config.load(getClass().getClassLoader().getResourceAsStream("config.properties"));
        } catch (IOException ex) {
            LogUtil.error(PluginManager.class.getName(), ex, "");
        }

        // Create a case-insensitive configuration property map.
        Map configMap = new StringMap(false);
        configMap.putAll(config);
        // Configure the Felix instance to be embedded.

        // Explicitly specify the directory to use for caching bundles.
        String targetCache = "target/felix-cache/";
        String tempDir = System.getProperty("java.io.tmpdir");
        File targetDir = new File(tempDir, targetCache);
        File targetCacheDir = new File(targetDir, "cache");
        // locate empty cache directory to use
        boolean proceed = false;
        int count = 0;
        while(!proceed) {
            // check for existing cache
            String dirName = "cache" + count;
            targetCacheDir = new File(targetDir, dirName);
            File[] bundles = targetCacheDir.listFiles();
            proceed = bundles == null || bundles.length <= 1;
            count++;
        }
        // set configuration
        configMap.put("org.osgi.framework.storage", targetCacheDir.getAbsolutePath());
        configMap.put("felix.log.level", "0");
        configMap.put("org.osgi.framework.storage.clean", "onFirstInit");

        try {
            if (felix == null) {
                felix = new Felix(configMap);
                felix.start();
            }
            //refresh();
            LogUtil.info(PluginManager.class.getName(), "PluginManager initialized");
        } catch (Exception ex) {
            LogUtil.error(PluginManager.class.getName(), ex, "Could not create framework");
        }

    }

    /**
     * Find and install plugins from the baseDirectory
     */
    public void refresh() {
        uninstallAll(false);
        installBundles();
    }

    protected void installBundles() {

        Collection<URL> urlList = new ArrayList<URL>();
        File baseDirFile = new File(getBaseDirectory());
        recurseDirectory(urlList, baseDirFile);

        Collection<Bundle> bundleList = new ArrayList<Bundle>();
        for (URL url : urlList) {
            // install the JAR file as a bundle
            String location = url.toExternalForm();
            Bundle bundle = installBundle(location);
            if (bundle != null) {
                bundleList.add(bundle);
            }

        }

        for (Bundle bundle : bundleList) {
            startBundle(bundle);
        }


    }

    protected void recurseDirectory(Collection<URL> urlList, File baseDirFile) {
        File[] files = baseDirFile.listFiles();
        if (files != null) {
            for (File file : files) {
                //LogUtil.info(getClass().getName(), " -" + file.getName());
                if (file.isFile() && file.getName().toLowerCase().endsWith(".jar")) {
                    try {
                        urlList.add(file.toURI().toURL());
                        LogUtil.debug(PluginManager.class.getName(), " found jar " + file.toURI().toURL());
                    } catch (MalformedURLException ex) {
                        LogUtil.error(PluginManager.class.getName(), ex, "");
                    }
                } else if (file.isDirectory()) {
                    recurseDirectory(urlList, file);
                }
            }
        }
    }

    protected Bundle installBundle(String location) {
        try {
            BundleContext context = felix.getBundleContext();
            Bundle newBundle = context.installBundle(location);
            if (newBundle.getSymbolicName() == null) {
                newBundle.uninstall();
                newBundle = null;
            } else {
                newBundle.update();
            }
            return newBundle;
        } catch (Exception be) {
            LogUtil.error(PluginManager.class.getName(), be, "Failed bundle installation from " + location + ": " + be.toString());
            return null;
        }
    }

    protected boolean startBundle(Bundle bundle) {
        try {
            //bundle.update();
            bundle.start();
            LogUtil.info(PluginManager.class.getName(), "Bundle " + bundle.getSymbolicName() + " started");
        } catch (Exception be) {
            LogUtil.error(PluginManager.class.getName(), be, "Failed bundle start for " + bundle + ": " + be.toString());
            return true;
        }
        return false;
    }

    /**
     * List registered plugins
     * @return
     */
    public Collection<Plugin> list() {
        Collection<Plugin> list = new ArrayList<Plugin>();
        BundleContext context = felix.getBundleContext();
        Bundle[] bundles = context.getBundles();
        for (Bundle b : bundles) {
            ServiceReference[] refs = b.getRegisteredServices();
            if (refs != null) {
                for (ServiceReference sr : refs) {
                    LogUtil.debug(PluginManager.class.getName(), " bundle service: " + sr);
                    Object obj = context.getService(sr);
                    if (obj instanceof Plugin) {
                        list.add((Plugin) obj);
                    }
                    context.ungetService(sr);
                }
            }
        }
        return list;
    }

    /**
     * Disable plugin
     * @param name
     */
    public boolean disable(String name) {
        boolean result = false;
        BundleContext context = felix.getBundleContext();
        ServiceReference sr = context.getServiceReference(name);
        if (sr != null) {
            try {
                sr.getBundle().stop();
                context.ungetService(sr);
                result = true;
            } catch (Exception ex) {
                LogUtil.error(PluginManager.class.getName(), ex, "");
            }
        }
        return result;
    }

    /**
     * Install a new plugin
     * @return
     */
    public boolean upload(String filename, InputStream in) {
        String location = null;
        File outputFile = null;
        try {
            // check filename
            if (filename == null || filename.trim().length() == 0) {
                throw new PluginException("Invalid plugin name");
            }
            if (!filename.endsWith(".jar")) {
                filename += ".jar";
            }

            // write file
            FileOutputStream out = null;
            try {
                outputFile = new File(getBaseDirectory(), filename);
                File outputDir = outputFile.getParentFile();
                if (!outputDir.exists()) {
                    outputDir.mkdirs();
                }
                out = new FileOutputStream(outputFile);
                BufferedInputStream bin = new BufferedInputStream(in);
                int len = 0;
                byte[] buffer = new byte[4096];
                while ((len = bin.read(buffer)) > 0) {
                    out.write(buffer, 0, len);
                }
                out.flush();
                location = outputFile.toURI().toURL().toExternalForm();
            } finally {
                try {
                    if (out != null) {
                        out.close();
                    }
                    if (in != null) {
                        in.close();
                    }
                } catch (IOException ex) {
                    LogUtil.error(PluginManager.class.getName(), ex, "");
                }
            }

            // validate jar file
            boolean isValid = false;
            try {
                JarFile jarFile = new JarFile(outputFile);
                isValid = true;
            } catch (IOException ex) {
                //delete invalid file
                try {
                    outputFile.delete();
                } catch (Exception e) {
                    LogUtil.error(PluginManager.class.getName(), ex, "");
                }

                LogUtil.error(PluginManager.class.getName(), ex, "");
                throw new PluginException("Invalid jar file");
            } catch (Exception ex) {
                LogUtil.error(PluginManager.class.getName(), ex, "");
                throw new PluginException("Invalid jar file");
            }

            // install
            if (location != null && isValid) {
                Bundle newBundle = installBundle(location);
                if (newBundle != null) {
                    startBundle(newBundle);
                }
            }

            return true;
        } catch (Exception ex) {
            LogUtil.error(PluginManager.class.getName(), ex, "");
            throw new PluginException("Unable to write plugin file", ex);
        }
    }

    /**
     * Uninstall/remove all plugin, without deleting the plugin file
     * @param name
     * @return
     */
    public void uninstallAll(boolean deleteFiles) {
        Collection<Plugin> pluginList = this.list();
        for (Plugin plugin : pluginList) {
            uninstall(plugin.getClass().getName(), deleteFiles);
        }
    }

    /**
     * Uninstall/remove a plugin, and delete the plugin file
     * @param name
     * @return
     */
    public boolean uninstall(String name) {
        return uninstall(name, true);
    }

    /**
     * Uninstall/remove a plugin
     * @param name
     * @return
     */
    public boolean uninstall(String name, boolean deleteFile) {
        boolean result = false;
        BundleContext context = felix.getBundleContext();
        ServiceReference sr = context.getServiceReference(name);
        if (sr != null) {
            try {
                Bundle bundle = sr.getBundle();
                bundle.stop();
                bundle.uninstall();
                String location = bundle.getLocation();
                context.ungetService(sr);

                // delete location
                if (deleteFile) {
                    File file = new File(new URI(location));
                    boolean deleted = file.delete();
                }
                result = true;
            } catch (Exception ex) {
                LogUtil.error(PluginManager.class.getName(), ex, "");
            }
        }
        return result;
    }

    public Plugin getPlugin(String name) {
        Plugin plugin = null;
        try {
            BundleContext context = felix.getBundleContext();

            ServiceReference sr = context.getServiceReference(name);
            if (sr != null) {
                Object obj = context.getService(sr);
                //Class clazz = sr.getBundle().loadClass(name);
                //Object obj = clazz.newInstance();
                boolean isPlugin = obj instanceof Plugin;
                LogUtil.debug(PluginManager.class.getName(), " plugin obj " + obj + " class: " + obj.getClass().getName() + " " + isPlugin);
                LogUtil.debug(PluginManager.class.getName(), " plugin classloader: " + obj.getClass().getClassLoader());
                LogUtil.debug(PluginManager.class.getName(), " current classloader: " + Plugin.class.getClassLoader());
                if (isPlugin) {
                    plugin = (Plugin) obj;
                }
                context.ungetService(sr);
            }
        } catch (Exception ex) {
            LogUtil.error(PluginManager.class.getName(), ex, "");
            throw new PluginException("Plugin " + name + " could not be retrieved", ex);
        }
        return plugin;
    }

    /**
     * Execute a plugin
     * @param name The fully qualified class name of the plugin
     * @param properties
     * @return
     */
    public Object execute(String name, Map properties) {
        Object result = null;
        Plugin plugin = getPlugin(name);
        if (plugin != null) {
            result = plugin.execute(properties);
            LogUtil.info(PluginManager.class.getName(), " Executed plugin " + plugin + ": " + result);
        } else {
            LogUtil.info(PluginManager.class.getName(), " Plugin " + name + " not found");
        }
        return result;
    }

    /**
     * Stop the plugin manager
     */
    public void shutdown() {
        if (felix != null) {
            try {
                uninstallAll(false);
                felix.stop();
            } catch (Exception ex) {
                LogUtil.error(PluginManager.class.getName(), ex, "Could not stop Felix");
            }
            felix = null;
        }
    }

    @Override
    public void finalize() {
        shutdown();
    }

    public void testPlugin(String name, String location, Map properties, boolean override) {
        LogUtil.info(PluginManager.class.getName(), "====testPlugin====");
        // check for existing plugin
        Plugin plugin = getPlugin(name);
        boolean existing = (plugin != null);
        boolean install = (location != null && location.trim().length() > 0);

        // install plugin
        if (install && (!existing || override)) {
            InputStream in = null;
            try {
                LogUtil.info(PluginManager.class.getName(), " ===install=== ");
                File file = new File(location);
                if (file.exists()) {
                    in = new FileInputStream(file);
                    upload(file.getName(), in);
                }
            } catch (Exception ex) {
                LogUtil.error(PluginManager.class.getName(), ex, "");
            } finally {
                try {
                    if (in != null) {
                        in.close();
                    }
                } catch (IOException ex) {
                    LogUtil.error(PluginManager.class.getName(), ex, "");
                }
            }
        }

        // execute plugin
        LogUtil.info(PluginManager.class.getName(), " ===execute=== ");
        Object result = execute(name, properties);
        LogUtil.info(PluginManager.class.getName(), "  result: " + result);

        // uninstall plugin
        if (install && (!existing || override)) {
            LogUtil.info(PluginManager.class.getName(), " ===uninstall=== ");
            uninstall(name);
        }
        LogUtil.info(PluginManager.class.getName(), "====testPlugin end====");

    }

    public static void main(String[] args) {
//        String pluginDirectory = "target/wflow-bundles";
        PluginManager pm = new PluginManager();

        FileInputStream in = null;
        try {
            LogUtil.info(PluginManager.class.getName(), " ===Plugin List=== ");
            for (Plugin p : pm.list()) {
                LogUtil.info(PluginManager.class.getName(), " plugin: " + p.getName() + "; " + p.getClass().getName());
            }
            String samplePluginFile = "../wflow-plugins/wflow-plugin-sample/target/wflow-plugin-sample-2.0-SNAPSHOT.jar";
            String samplePlugin = "org.joget.plugin.sample.SamplePlugin";

            try {
                LogUtil.info(PluginManager.class.getName(), " ===Install SamplePlugin=== ");
                File file = new File(samplePluginFile);
                in = new FileInputStream(file);
                pm.upload(file.getName(), in);
            } catch (Exception ex) {
                LogUtil.error(PluginManager.class.getName(), ex, "");
            } finally {
                try {
                    if (in != null) {
                        in.close();
                    }
                } catch (IOException ex) {
                    LogUtil.error(PluginManager.class.getName(), ex, "");
                }
            }

            LogUtil.info(PluginManager.class.getName(), " ===Plugin List after install=== ");
            for (Plugin p : pm.list()) {
                LogUtil.info(PluginManager.class.getName(), " plugin: " + p.getName() + "; " + p.getClass().getName());
            }

            LogUtil.info(PluginManager.class.getName(), " ===Execute SamplePlugin=== ");
            pm.execute(samplePlugin, null);

            LogUtil.info(PluginManager.class.getName(), " ===Uninstall SamplePlugin=== ");
            pm.uninstall(samplePlugin);
            LogUtil.info(PluginManager.class.getName(), " ===New Plugin List after removal=== ");
            for (Plugin p : pm.list()) {
                LogUtil.info(PluginManager.class.getName(), " plugin: " + p.getName() + "; " + p.getClass().getName());
            }
            pm.refresh();
            LogUtil.info(PluginManager.class.getName(), " ===New Plugin List after refresh=== ");
            for (Plugin p : pm.list()) {
                LogUtil.info(PluginManager.class.getName(), " plugin: " + p.getName() + "; " + p.getClass().getName());
            }

            pm.testPlugin(samplePlugin, samplePluginFile, null, true);
        } finally {
            pm.shutdown();
        }
    }

    public Object getBean(String beanName) {
        Object bean = null;
        if (applicationContext != null) {
            bean = applicationContext.getBean(beanName);
        }
        return bean;
    }

    public void setApplicationContext(ApplicationContext appContext) throws BeansException {
        this.applicationContext = appContext;
        refresh();
    }
}
