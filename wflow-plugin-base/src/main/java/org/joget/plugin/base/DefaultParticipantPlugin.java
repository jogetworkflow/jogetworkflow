package org.joget.plugin.base;

import java.util.Map;

public abstract class DefaultParticipantPlugin extends DefaultPlugin implements ParticipantPlugin {

    public final Object execute(Map props) {
        return getActivityAssignments(props);
    }
}
