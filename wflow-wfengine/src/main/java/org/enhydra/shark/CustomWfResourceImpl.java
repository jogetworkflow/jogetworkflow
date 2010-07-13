package org.enhydra.shark;

import org.enhydra.shark.api.client.wfmc.wapi.WMSessionHandle;
import org.enhydra.shark.api.client.wfmodel.WfResource;

public class CustomWfResourceImpl {
    public static void createResource(WMSessionHandle shandle, String resourceKey) throws Exception {
        WfResourceImpl res = new WfResourceImpl(shandle, resourceKey);
    }
}
