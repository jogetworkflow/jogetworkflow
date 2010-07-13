package ${groupId};

import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginProperty;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Map;

public class MyPlugin extends DefaultPlugin {

    public String getName() {
        return "MyPlugin";
    }

    public String getDescription() {
        return "MyPluginDescription";
    }

    public String getVersion() {
        return "1.0.0";
    }

    public PluginProperty[] getPluginProperties() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public Object execute(Map properties) {
        Object result = null;
        try {
            return result;
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.WARNING, "Error executing plugin", e);
            return null;
        }
    }

}
