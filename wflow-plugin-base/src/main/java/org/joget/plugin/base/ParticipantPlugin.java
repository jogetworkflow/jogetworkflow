package org.joget.plugin.base;

import java.util.Collection;
import java.util.Map;

public interface ParticipantPlugin {

    Collection<String> getActivityAssignments(Map props);
}
