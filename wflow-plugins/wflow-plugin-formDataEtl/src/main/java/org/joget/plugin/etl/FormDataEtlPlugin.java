package org.joget.plugin.etl;

import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginProperty;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.util.WorkflowUtil;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Map;
import java.util.Properties;
import javax.sql.DataSource;
import org.apache.commons.dbcp.BasicDataSourceFactory;

public class FormDataEtlPlugin extends DefaultPlugin implements ApplicationPlugin {

    public static final String FORM_DATA = "form";
    public static final String WORKFLOW_ASSIGNMENT = "assignment";
    public static final String WORKFLOW_VARIABLE = "variable";

    public String getName() {
        return "Database Plugin";
    }

    public String getDescription() {
        return "Executes SQL INSERT and UPDATE statement on MySQL, Oracle or SQL Server database";
    }

    public String getVersion() {
        return "1.0.10";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[]{
            new PluginProperty("formDataTable", "Form Data Table", PluginProperty.TYPE_TEXTFIELD, null, ""),
            new PluginProperty("driverClassName", "Driver Class Name", PluginProperty.TYPE_TEXTFIELD, null, "com.mysql.jdbc.Driver"),
            new PluginProperty("url", "Target DB URL", PluginProperty.TYPE_TEXTFIELD, null, "jdbc:mysql://localhost/"),
            new PluginProperty("username", "Username", PluginProperty.TYPE_TEXTFIELD, null, "root"),
            new PluginProperty("password", "Password", PluginProperty.TYPE_PASSWORD, null, ""),
            new PluginProperty("query", "Query", PluginProperty.TYPE_TEXTAREA, null, null)
        };
        return properties;
    }

    public Object execute(Map properties) {
        Object result = null;
        try {
            String formDataTable = (String) properties.get("formDataTable");
            String driverClassName = (String) properties.get("driverClassName");
            String url = (String) properties.get("url");
            String username = (String) properties.get("username");
            String password = (String) properties.get("password");
            String query = (String) properties.get("query");

            WorkflowAssignment wfAssignment = (WorkflowAssignment) properties.get("workflowAssignment");

            Map<String, String> replace = new HashMap<String, String>();
            if(driverClassName.equalsIgnoreCase("com.mysql.jdbc.Driver")){
                replace.put("\\\\", "\\\\");
                replace.put("'", "\\'");
            }else{
                replace.put("'", "''");
            }

            query = WorkflowUtil.processVariable(query, formDataTable, wfAssignment, "regex", replace);

            Properties props = new Properties();

            props.put("driverClassName", driverClassName);
            props.put("url", url);
            props.put("username", username);
            props.put("password", password);
            DataSource ds = createDataSource(props);
            result = executeQuery(ds, query);

            return result;
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.WARNING, "Error executing plugin", e);
            return null;
        }
    }

    protected DataSource createDataSource(Properties props) throws Exception {
        DataSource ds = BasicDataSourceFactory.createDataSource(props);
        return ds;
    }

    protected boolean executeQuery(DataSource ds, String sql) throws SQLException {
        Connection con = null;
        Statement stmt = null;
        try {
            con = ds.getConnection();
            stmt = con.createStatement();
            boolean result = stmt.execute(sql);
            return result;
        } finally {
            if (stmt != null) {
                stmt.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }
}
