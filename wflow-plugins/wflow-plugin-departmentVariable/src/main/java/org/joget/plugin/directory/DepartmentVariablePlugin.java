package org.joget.plugin.directory;

import org.joget.directory.model.Department;
import org.joget.directory.model.Organization;
import org.joget.directory.model.dao.department.DepartmentDao;
import org.joget.directory.model.dao.organization.OrganizationDao;
import org.joget.plugin.base.DefaultFormVariablePlugin;
import org.joget.plugin.base.PluginManager;
import org.joget.plugin.base.PluginProperty;
import java.util.Collection;
import java.util.Map;
import org.apache.commons.collections.map.ListOrderedMap;

public class DepartmentVariablePlugin extends DefaultFormVariablePlugin {

    public String getName() {
        return "DepartmentVariablePlugin";
    }

    public String getVersion() {
        return "1.0.0";
    }

    public String getDescription() {
        return "return a list of departments";
    }

    public PluginProperty[] getPluginProperties() {
        throw new UnsupportedOperationException("Not supported yet.");
    }

//    @Override
    public Map getVariableOptions(Map props) {
        Map result = new ListOrderedMap();
        PluginManager pluginManager = null;
        if (props != null) {
            pluginManager = (PluginManager) props.get("pluginManager");
        }
        OrganizationDao orgDao = (OrganizationDao) pluginManager.getBean("organizationDao");
        DepartmentDao deptDao = (DepartmentDao) pluginManager.getBean("departmentDao");
        Collection<Organization> orgList = orgDao.getOrganizationList(null, "name", false, 0, 100);
        for (Organization org : orgList) {
            Collection<Department> deptList = deptDao.getDepartmentByOrganization(org.getName(), "e.name", false, 0, 100);
            for (Department dept : deptList) {
                result.put(dept.getId(), "" + org.getName() + ": " + dept.getName());
            }
        }

        return result;
    }
}
