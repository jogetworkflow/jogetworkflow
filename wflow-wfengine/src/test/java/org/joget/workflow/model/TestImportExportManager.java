package org.joget.workflow.model;

import java.io.File;
import java.io.FileInputStream;
import java.util.Collection;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.form.model.dao.CategoryDao;
import org.joget.form.model.dao.FormDao;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.dao.ActivityPluginDao;
import org.joget.workflow.model.dao.ParticipantDirectoryDao;
import org.joget.workflow.model.service.ImportExportManager;
import org.joget.workflow.model.service.WorkflowManager;
import org.springframework.util.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:wfengineApplicationContext.xml", "classpath:formApplicationContext.xml"})
public class TestImportExportManager {

    @Autowired
    ImportExportManager importExportManager;

    @Autowired
    WorkflowManager workflowManager;

    @Autowired
    ActivityFormDao activityFormDao;

    @Autowired
    FormDao formDao;
    
    @Autowired
    CategoryDao categoryDao;

    @Autowired
    ParticipantDirectoryDao participantDirectoryDao;

    @Autowired
    ActivityPluginDao activityPluginDao;

    @Autowired
    @Qualifier("main")
    DirectoryManager directoryManager;

    @Autowired
    PluginManager pluginManager;

    private static final String TEST_PACKAGE_ZIP = "/testImportExport-20100201145611.zip";
    private static final String TEST_XPDL = "/testImportExport.xpdl";

    private static final String PACKAGE_ID = "testImportExport";
    private static final String PARTICIPANT_ID = "participant1";
    private static final String ACTIVITY_ID = "activity1";
    private static final String TOOL_ID = "tool";

    private String USER_ID = "admin";
    private String PLUGIN_NAME = "org.joget.plugin.beanshell.BeanShellPlugin";

    private String version = "";
    private String processDefId = "";
    private String formId = PACKAGE_ID;

    private boolean skipParticipantDirectoryCheck = false;
    private boolean skipActivityPluginCheck = false;

    @Test
    public void testSuite() throws Exception{
        try{
            initTestData();

            testImport();
            testForm();
            testCategory();
            testActivityForm();

            if(!skipActivityPluginCheck){
                testActivityPlugin();
            }
            
            if(!skipParticipantDirectoryCheck){
                testParticipantDirectory();
            }
            
            deleteTestData();
        }catch(Exception ex){
            Assert.isTrue(false, ex.getMessage());
        }
        
    }

    public void initTestData() throws Exception{
        if(directoryManager.getUserById(USER_ID) == null){
            skipParticipantDirectoryCheck = true;
        }

        if(pluginManager.getPlugin(PLUGIN_NAME) == null){
            skipActivityPluginCheck = true;
        }
    }

    public void testImport() throws Exception{
        File packageZip = new File(getClass().getResource(TEST_PACKAGE_ZIP).toURI());
        FileInputStream in = new FileInputStream(packageZip);

        byte[] bytes = new byte[(int) packageZip.length()];
        in.read(bytes);
        in.close();

        byte[] packageData = null;
        byte[] packageXpdl = null;

        try {
            packageData = importExportManager.getPackageDataXmlFromZip(bytes);
            packageXpdl = importExportManager.getPackageXpdlFromZip(bytes);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        String packageId = importExportManager.importPackage(packageData, packageXpdl);

        version = workflowManager.getCurrentPackageVersion(PACKAGE_ID);
        processDefId = PACKAGE_ID + "#" + version + "#" + PACKAGE_ID;

        Assert.isTrue(packageId.equals(PACKAGE_ID), "package importing failed");
    }

    public void testForm(){
        if(Integer.parseInt(version) != 1){
            formId += "_ver_" + version;
        }
        Assert.notNull(formDao.find(formId), "Form not found");
    }

    public void testCategory(){
        Assert.notNull( categoryDao.find(PACKAGE_ID), "Category not found");
    }

    public void testActivityForm(){
        Assert.notEmpty(activityFormDao.getActivityFormByPackageId(PACKAGE_ID, Integer.parseInt(version)), "Form mapping is empty");
    }

    public void testActivityPlugin(){
        Assert.notEmpty(activityPluginDao.getActivityPluginByPackageId(PACKAGE_ID, Integer.parseInt(version)), "Plugin mapping is empty");
    }

    public void testParticipantDirectory(){
        Assert.notEmpty(participantDirectoryDao.getParticipantDirectoryByPackageId(PACKAGE_ID, Integer.parseInt(version)), "Participant mapping is empty");
    }

    public void deleteTestData(){
        Collection<ActivityForm> activityFormList = activityFormDao.getActivityFormByPackageId(PACKAGE_ID, Integer.parseInt(version));
        for(ActivityForm activityForm : activityFormList){
            activityFormDao.delete(activityForm);
        }
        formDao.delete(formId);
        categoryDao.delete(PACKAGE_ID);
        
        Collection<ActivityPlugin> activityPluginList = activityPluginDao.getActivityPluginByPackageId(PACKAGE_ID, Integer.parseInt(version));
        for(ActivityPlugin activityPlugin : activityPluginList){
            activityPluginDao.delete(activityPlugin);
        }
        
        Collection<ParticipantDirectory> participantDirectoryList = participantDirectoryDao.getParticipantDirectoryByPackageId(PACKAGE_ID, Integer.parseInt(version));
        for(ParticipantDirectory participantDirectory : participantDirectoryList){
            participantDirectoryDao.delete(participantDirectory);
        }

        workflowManager.processDeleteAndUnloadVersion(PACKAGE_ID, version);
        Assert.isTrue(workflowManager.getCurrentPackageVersion(PACKAGE_ID) == null || !workflowManager.getCurrentPackageVersion(PACKAGE_ID).equals(version), "cannot delete package");
    }

}
