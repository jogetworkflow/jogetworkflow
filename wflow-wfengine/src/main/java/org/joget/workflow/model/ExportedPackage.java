package org.joget.workflow.model;

import java.util.Collection;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "processes", strict = false)
public class ExportedPackage {

    @ElementList(inline = true)
    private Collection<ExportedProcess> processList;

    @Element(name = "userview-setup", required = false)
    private UserviewSetup userviewSetup;

    public Collection<ExportedProcess> getProcessList() {
        return processList;
    }

    public void setProcessList(Collection<ExportedProcess> processList) {
        this.processList = processList;
    }

    public UserviewSetup getUserviewSetup() {
        return userviewSetup;
    }

    public void setUserviewSetup(UserviewSetup userviewSetup) {
        this.userviewSetup = userviewSetup;
    }
}
