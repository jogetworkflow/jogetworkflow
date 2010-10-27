package org.joget.designer;

import org.enhydra.jawe.JaWE;
import org.jped.SettingsLoader;
import org.enhydra.jawe.JaWEManager;
import org.enhydra.jawe.base.controller.JaWEController;
import org.enhydra.jawe.base.editor.XPDLElementEditor;

public class Designer {

    public static String URLPATH = "";

    public static String USERNAME = "";
    public static String HASH = "";

    public static boolean DEPLOY = false;
    public static boolean UPDATE = false;

    public static void main(String[] args) throws Throwable {

        System.setProperty("Splash", "/org/enhydra/jawe/images/wfdesigner.jpg");

        // override settings
        SettingsLoader.overrideProperty("controllerSettings", "FrameSettings", "V; tree; main");
        SettingsLoader.overrideProperty("controllerSettings", "defaultToolbarToolbar", "*filetoolbar");

        SettingsLoader.overrideProperty("controllerSettings", "FileMenu", "NewPackage Open Close - Save SaveAs - Deploy Update - @RecentFiles - Exit");
        SettingsLoader.overrideProperty("controllerSettings", "Deploy", "Deploy");
        SettingsLoader.overrideProperty("controllerSettings", "Deploy.type", "action");
        SettingsLoader.overrideProperty("controllerSettings", "Deploy.class", "org.joget.designer.jped.Deploy");
        SettingsLoader.overrideProperty("controllerSettings", "Deploy.icon", "org/enhydra/jawe/images/deploy.gif");

        SettingsLoader.overrideProperty("controllerSettings", "Update", "Update");
        SettingsLoader.overrideProperty("controllerSettings", "Update.type", "action");
        SettingsLoader.overrideProperty("controllerSettings", "Update.class", "org.joget.designer.jped.Update");
        SettingsLoader.overrideProperty("controllerSettings", "Update.icon", "org/enhydra/jawe/images/update.gif");

        SettingsLoader.overrideProperty("SimpleNavigatorSettings", "BackgroundColor", "R=220,G=220,B=220");

        String[] argument = new String[2];
        int index = 0;
        for (int i = 0; i < args.length; i++) {
            if (args[i].startsWith("path:")) {
                URLPATH = args[i].substring(5, args[i].length());
            } else if (args[i].startsWith("deploy:")) {
                DEPLOY = true;
            } else if (args[i].startsWith("update:")) {
                UPDATE = true;
            } else if (args[i].startsWith("username:")) {
                USERNAME = args[i].substring(9, args[i].length());
            } else if (args[i].startsWith("hash:")) {
                HASH = args[i].substring(5, args[i].length());
            } else if (args[i].startsWith("locale:")) {
                argument[1] = args[i].substring(7, args[i].length());
            } else {
                argument[0] = args[i];
            }
        }

        // launch JaWE
        JaWE.main(argument);
        
        // Automatically create new package when launched without any existing package.
        if(!UPDATE){
            JaWEController jc = JaWEManager.getInstance().getJaWEController();
            if (jc.tryToClosePackage(jc.getMainPackageId(), false)) {
                //create new package
                jc.newPackage(jc.getJaWETypes().getDefaultType(Package.class));
                //pop up properties
                XPDLElementEditor ed = JaWEManager.getInstance().getXPDLElementEditor();
                ed.editXPDLElement(jc.getSelectionManager().getWorkingPKG());
            }
        }

    }
}
