package org.joget.plugin.etl;

import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginProperty;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.util.WorkflowUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Map;
import java.util.Properties;
import javax.sql.DataSource;
import org.apache.commons.dbcp.BasicDataSourceFactory;

public class MySqlPlugin extends DefaultPlugin implements ApplicationPlugin {

    public static final String FORM_DATA = "form";
    public static final String WORKFLOW_ASSIGNMENT = "assignment";
    public static final String WORKFLOW_VARIABLE = "variable";
    
    public String getName() {
        return "MySQL Plugin";
    }

    public String getDescription() {
        return "Executes SQL INSERT and UPDATE statement on MySQL database via JDBC.";
    }

    public String getVersion() {
        return "1.0.3";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[]{
            new PluginProperty("formDataTable", "Form Data Table", PluginProperty.TYPE_TEXTFIELD, null, ""),
            new PluginProperty("host", "MySQL Host Address", PluginProperty.TYPE_TEXTFIELD, null, "localhost"),
            new PluginProperty("username", "Username", PluginProperty.TYPE_TEXTFIELD, null, "root"),
            new PluginProperty("password", "Password", PluginProperty.TYPE_PASSWORD, null, ""),
            new PluginProperty("port", "Port", PluginProperty.TYPE_TEXTFIELD, null, "3306"),
            new PluginProperty("database", "Database", PluginProperty.TYPE_TEXTFIELD, null, ""),
            new PluginProperty("extraParameters", "Extra Parameters (Optional)", PluginProperty.TYPE_TEXTFIELD, null, ""),
            new PluginProperty("query", "Query", PluginProperty.TYPE_TEXTAREA, null, null)
        };
        return properties;
    }
    
    public Object execute(Map properties) {
        Object result = null;
        try {
            String formDataTable = (String) properties.get("formDataTable");
            String host = (String) properties.get("host");
            String username = (String) properties.get("username");
            String password = (String) properties.get("password");
            String port = (String) properties.get("port");
            String database = (String) properties.get("database");
            String extraParameters = (String) properties.get("extraParameters");
            String query = (String) properties.get("query");
            String url = "jdbc:mysql://" + host + ":" + port + "/" + database;

            if( !extraParameters.equalsIgnoreCase("") ){
                if( extraParameters.substring(0, 1).equalsIgnoreCase("?") )
                    url += extraParameters;
                else
                    url += "?" + extraParameters;
            }

            WorkflowAssignment wfAssignment = (WorkflowAssignment) properties.get("workflowAssignment");

            Map<String, String> replace = new HashMap<String, String>();
            replace.put("\\\\", "\\\\");
            replace.put("'", "\\'");
            query = WorkflowUtil.processVariable(query, formDataTable, wfAssignment, "regex", replace);

            Properties props = new Properties();

            //hard code mysql driver class name
            props.put("driverClassName", "com.mysql.jdbc.Driver");
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
        PreparedStatement pstmt = null;
        try {
            con = ds.getConnection();
            pstmt = con.prepareStatement(sql);
            return pstmt.execute(sql);
        } finally {
            if (pstmt != null) {
                pstmt.close();
            }
            if (con != null) {
                con.close();
            }
        }
    }
}
