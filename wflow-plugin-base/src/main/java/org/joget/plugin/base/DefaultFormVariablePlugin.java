package org.joget.plugin.base;

import java.util.Map;

public abstract class DefaultFormVariablePlugin extends DefaultPlugin implements FormVariablePlugin {

    public final Object execute(Map props) {
        return getVariableOptions(props);
    }
}
