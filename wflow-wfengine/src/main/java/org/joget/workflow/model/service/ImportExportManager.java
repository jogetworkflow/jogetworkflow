package org.joget.workflow.model.service;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import org.joget.commons.util.UuidGenerator;
import org.joget.directory.model.Department;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.form.model.Category;
import org.joget.form.model.Form;
import org.joget.form.model.FormVariable;
import org.joget.form.model.dao.CategoryDao;
import org.joget.form.model.dao.FormDao;
import org.joget.form.model.dao.FormVariableDao;
import org.joget.form.util.FormUtil;
import org.joget.plugin.base.PluginManager;
import org.joget.workflow.model.ActivityForm;
import org.joget.workflow.model.ActivityPlugin;
import org.joget.workflow.model.ActivitySetup;
import org.joget.workflow.model.UserviewProcess;
import org.joget.workflow.model.UserviewSetup;
import org.joget.workflow.model.ExportedPackage;
import org.joget.workflow.model.ExportedProcess;
import org.joget.workflow.model.ParticipantDirectory;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.dao.ActivityFormDao;
import org.joget.workflow.model.dao.ActivityPluginDao;
import org.joget.workflow.model.dao.ActivitySetupDao;
import org.joget.workflow.model.dao.ParticipantDirectoryDao;
import org.simpleframework.xml.Serializer;
import org.simpleframework.xml.core.Persister;

public class ImportExportManager {

    private ActivityFormDao activityFormDao;
    private ActivityPluginDao activityPluginDao;
    private ParticipantDirectoryDao participantDirectoryDao;
    private FormDao formDao;
    private CategoryDao categoryDao;
    private FormVariableDao formVariableDao;
    private DirectoryManager directoryManager;
    private WorkflowManager workflowManager;
    private PluginManager pluginManager;
    private UserviewSetupManager userviewSetupManager;
    private UserviewProcessManager userviewProcessManager;
    private SetupManager setupManager;
    private ActivitySetupDao activitySetupDao;

    //a map to keep track which form has been updated to newer version during importing, key=old id, value=new id
    private HashMap<String, String> updatedForm = new HashMap<String, String>();

    public List<String> validateImportPackageData(byte[] processData) {
        List<String> errorList = new ArrayList<String>();

        try {
            Serializer serializer = new Persister();
            ExportedPackage exportedPackage = serializer.read(ExportedPackage.class, new ByteArrayInputStream(processData), "UTF-8");
            Collection<ExportedProcess> processList = exportedPackage.getProcessList();

            for (ExportedProcess process : processList) {
                Collection<ParticipantDirectory> participantDirectoryList = process.getParticipantDirectoryList();
                Collection<ActivityPlugin> activityPluginList = process.getActivityPluginList();

                for (ActivityPlugin activityPlugin : activityPluginList) {
                    String pluginName = activityPlugin.getPluginName();
                    if (pluginName.trim().length() > 0 && pluginManager.getPlugin(pluginName) == null) {
                        String errorMessage = String.format("missing Plugin (name: %s)", pluginName);
                        if (!errorList.contains(errorMessage)) {
                            errorList.add(errorMessage);
                        }
                    }
                }

                for (ParticipantDirectory participantDirectory : participantDirectoryList) {
                    String mappingType = participantDirectory.getType();
                    String value = participantDirectory.getValue();

                    if (mappingType.equals(ParticipantDirectoryDao.TYPE_USER)) {
                        List<String> userList = new ArrayList();
                        if (value.contains(",")) {
                            String[] ids = value.split(",");
                            for (String id : ids) {
                                userList.add(id);
                            }
                        } else {
                            userList.add(value);
                        }

                        for (String id : userList) {
                            if (directoryManager.getUserById(id) == null) {
                                String errorMessage = String.format("missing User (id: %s)", id);
                                if (!errorList.contains(errorMessage)) {
                                    errorList.add(errorMessage);
                                }
                            }
                        }

                    } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_GROUP)) {
                        List<String> groupList = new ArrayList();
                        if (value.contains(",")) {
                            String[] ids = value.split(",");
                            for (String id : ids) {
                                groupList.add(id);
                            }
                        } else {
                            groupList.add(value);
                        }

                        for (String id : groupList) {
                            if (directoryManager.getGroupById(id) == null) {
                                String errorMessage = String.format("missing Group (id: %s)", id);
                                if (!errorList.contains(errorMessage)) {
                                    errorList.add(errorMessage);
                                }
                            }
                        }

                    } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_DEPARTMENT)) {
                        if (directoryManager.getDepartmentById(value) == null) {
                            String errorMessage = String.format("missing Department (id: %s)", value);
                            if (!errorList.contains(errorMessage)) {
                                errorList.add(errorMessage);
                            }
                        }

                    } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_HOD)) {
                        Department department = directoryManager.getDepartmentById(value);
                        if (department == null) {
                            String errorMessage = String.format("missing Department (id: %s)", value);
                            if (!errorList.contains(errorMessage)) {
                                errorList.add(errorMessage);
                            }
                        } else {
                            if (department.getHod() == null) {
                                String errorMessage = String.format("missing Department HOD (id: %s)", value);
                                if (!errorList.contains(errorMessage)) {
                                    errorList.add(errorMessage);
                                }
                            } else {
                                if (department.getHod().getUser() == null) {
                                    String errorMessage = String.format("missing Department HOD (id: %s)", value);
                                    if (!errorList.contains(errorMessage)) {
                                        errorList.add(errorMessage);
                                    }
                                }
                            }
                        }

                    } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_GRADE)) {
                    } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_GRADE)) {
                        if (directoryManager.getGradeById(value) == null) {
                            String errorMessage = String.format("missing Grade (id: %s)", value);
                            if (!errorList.contains(errorMessage)) {
                                errorList.add(errorMessage);
                            }
                        }

                    } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_PLUGIN)) {
                        if (pluginManager.getPlugin(value) == null) {
                            String errorMessage = String.format("missing Plugin (name: %s)", value);
                            if (!errorList.contains(errorMessage)) {
                                errorList.add(errorMessage);
                            }
                        }
                    }
                }
            }

            Collections.sort(errorList);
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }

        return errorList;
    }

    private int getPackageLatestVersion(String packageId){
        Collection<WorkflowProcess> processList = workflowManager.getProcessList(packageId);

        int latestVersion = 0;
        for (WorkflowProcess process : processList) {
            if (process.isLatest()) {
                latestVersion = Integer.parseInt(process.getVersion());
                break;
            }
        }

        return latestVersion;
    }

    public String importPackage(byte[] packageData, byte[] packageXpdl) {
        return importPackage(packageData, packageXpdl, null);
    }
    
    public String importPackage(byte[] packageData, byte[] packageXpdl, Map<String, byte[]> mobileFormList) {
        String packageId = "";

        try {
            packageId = workflowManager.processUploadWithoutUpdateMapping(null, packageXpdl);
        } catch (Exception ex) {
            if (ex.getMessage().contains("is already open")) {
                packageId = ex.getMessage().replace("java.lang.Exception: The package with id", "").replace("is already open", "").trim();
            }

            try {
                workflowManager.processUploadWithoutUpdateMapping(packageId, packageXpdl);
            } catch (Exception ex2) {
                LogUtil.error(getClass().getName(), ex2, "");
            }
        }

        importPackageData(packageId, packageData, mobileFormList, getPackageLatestVersion(packageId));

        return packageId;
    }

    private String saveForm(Form form, String versionSuffix, Map<String, byte[]> mobileFormList){
        String id = form.getId();

        String regex = "^(.+)(_ver_\\d+)$";
        String newId = "";
        if (Pattern.compile(regex).matcher(id).find()) {
            newId = id.replaceAll(regex, "$1" + versionSuffix);
        } else {
            newId = id + versionSuffix;
        }
        form.setId(newId);

        if (formDao.find(form.getId()) == null) {
            regex = "^(.+)(_ver_\\d+)$";
            if (Pattern.compile(regex).matcher(form.getName()).find()) {
                form.setName(form.getName().replaceAll(regex, "$1" + versionSuffix));
            }
            if (form.getCategoryId().trim().length() > 0 && categoryDao.find(form.getCategoryId()) == null) {
                form.setCategoryId(null);
            }
            formDao.save(form);
        }

        //import mobile form
        if(mobileFormList != null){
            byte[] mobileFormRaw = mobileFormList.get(id + ".html");
            if(mobileFormRaw != null && mobileFormRaw.length > 0){
                String mobileFormPath = SetupManager.getBaseDirectory();
                mobileFormPath += (!mobileFormPath.endsWith(File.separator)) ? File.separator : "forms" + File.separator;

                new File(mobileFormPath).mkdirs();

                FileOutputStream fos = null;
                try{
                    File tempFile = new File(mobileFormPath + newId + ".html");
                    if(!tempFile.exists()){
                        fos = new FileOutputStream(tempFile);
                        fos.write(mobileFormRaw);
                    }

                }catch(Exception ex){
                    LogUtil.error(getClass().getName(), ex, "");
                }finally{
                    if(fos != null){
                        try{
                            fos.close();
                        }catch(Exception ex){
                            LogUtil.error(getClass().getName(), ex, "");
                        }
                    }
                }
            }
        }

        return newId;
    }

    public void importPackageData(String packageId, byte[] processData, Map<String, byte[]> mobileFormList, int latestVersion) {

        try {
            Serializer serializer = new Persister();
            ExportedPackage exportedPackage = serializer.read(ExportedPackage.class, new ByteArrayInputStream(processData), "UTF-8");
            Collection<ExportedProcess> processList = exportedPackage.getProcessList();

            updatedForm = new HashMap<String, String>();
            String versionSuffix = "_ver_" + latestVersion;
            
            for (ExportedProcess process : processList) {
                if(!process.getId().split("#")[0].equals(packageId)){
                    continue;
                }

                Collection<Form> formList = process.getFormList();
                Collection<Category> categoryList = process.getCategoryList();
                Collection<FormVariable> formVariableList = process.getFormVariableList();
                Collection<ActivityForm> activityFormList = process.getActivityFormList();
                Collection<ParticipantDirectory> participantDirectoryList = process.getParticipantDirectoryList();
                Collection<ActivityPlugin> activityPluginList = process.getActivityPluginList();
                Collection<ActivitySetup> activitySetupList = process.getActivitySetupList();

                if(categoryList != null){
                    for (Category category : categoryList) {
                        if (getCategoryDao().find(category.getId()) == null) {
                            getCategoryDao().save(category);
                        }
                    }
                }

                Map<String, String>  formVariableChangedList = new HashMap<String, String>();
                if(formVariableList != null){
                    for (FormVariable formVariable : formVariableList) {
                        //append _packageId with version
                        String suffix = "_" + packageId + versionSuffix ;
                        String name = formVariable.getName();
                        if(name.contains("_" + packageId)){
                            name = name.substring(0, name.indexOf("_" + packageId)-1) + suffix;
                        }else{
                            name = name + suffix;
                        }
                        formVariable.setName(name);

                        //check to replace or create new
                        FormVariable tempFormVariable = getFormVariableDao().find(formVariable.getId());
                        if (tempFormVariable != null) {
                            if(!name.equals(tempFormVariable.getName())){
                                String oldId = formVariable.getId();
                                String newId = UuidGenerator.getInstance().getUuid();
                                formVariable.setId(newId);
                                formVariableChangedList.put(oldId, newId);
                            }
                        }

                        getFormVariableDao().saveOrUpdate(formVariable);
                    }
                }

                if(formList != null){
                    for (Form form : formList) {
                        String oldId = form.getId();
                        form = FormUtil.updateFormVariable(form, formVariableChangedList);
                        String newId = saveForm(form, versionSuffix, mobileFormList);
                        updatedForm.put(oldId, newId);
                    }
                    FormUtil.updateBatchSubformReferenceId(updatedForm);
                }

                if(activityFormList != null){
                    for (ActivityForm activityForm : activityFormList) {
                        if (activityFormDao.getFormByActivity(activityForm.getProcessId(), latestVersion, activityForm.getActivityId()).isEmpty()) {
                            if (activityForm.getType().equals(ActivityFormDao.ACTIVITY_FORM_TYPE_SINGLE)) {
                                String formId = activityForm.getFormId();
                                if (updatedForm.containsKey(formId)) {
                                    formId = updatedForm.get(formId);
                                    activityForm.setFormId(formId);
                                }

                                if (formId.trim().length() > 0 && formDao.find(formId) == null) {
                                    continue;
                                }
                            }
                            activityForm.setId(null);
                            activityForm.setProcessId(updateProcessVersion(activityForm.getProcessId(), latestVersion));
                            activityForm.setVersion(latestVersion);
                            activityFormDao.save(activityForm);
                        }
                    }
                }

                if(participantDirectoryList != null){
                    for (ParticipantDirectory participantDirectory : participantDirectoryList) {
                        if (participantDirectoryDao.getMappingByParticipantId(participantDirectory.getPackageId(), null, latestVersion, participantDirectory.getParticipantId()).isEmpty()) {
                            String mappingType = participantDirectory.getType();
                            String value = participantDirectory.getValue();

                            boolean containsError = false;

                            if (mappingType.equals(ParticipantDirectoryDao.TYPE_USER)) {
                                List<String> userList = new ArrayList();
                                if (value.contains(",")) {
                                    String[] ids = value.split(",");

                                    for (String id : ids) {
                                        userList.add(id);
                                    }
                                } else {
                                    userList.add(value);
                                }

                                for (String id : userList) {
                                    if (directoryManager.getUserById(id) == null) {
                                        containsError = true;
                                    }
                                }

                            } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_GROUP)) {
                                List<String> groupList = new ArrayList();
                                if (value.contains(",")) {
                                    String[] ids = value.split(",");
                                    for (String id : ids) {
                                        groupList.add(id);
                                    }
                                } else {
                                    groupList.add(value);
                                }

                                for (String id : groupList) {
                                    if (directoryManager.getGroupById(id) == null) {
                                        containsError = true;
                                    }
                                }

                            } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_DEPARTMENT)) {
                                if (directoryManager.getDepartmentById(value) == null) {
                                    containsError = true;
                                }

                            } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_HOD)) {
                                Department department = directoryManager.getDepartmentById(value);
                                if (department == null) {
                                    containsError = true;
                                } else {
                                    if (department.getHod() == null) {
                                        containsError = true;
                                    } else {
                                        if (department.getHod().getUser() == null) {
                                            containsError = true;
                                        }
                                    }
                                }

                            } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_DEPARTMENT_GRADE)) {
                            } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_GRADE)) {
                                if (directoryManager.getGradeById(value) == null) {
                                    containsError = true;
                                }

                            } else if (mappingType.equals(ParticipantDirectoryDao.TYPE_PLUGIN)) {
                                if (pluginManager.getPlugin(value) == null) {
                                    containsError = true;
                                }
                            }

                            if (!containsError) {
                                participantDirectory.setId(null);
                                participantDirectory.setProcessId(updateProcessVersion(participantDirectory.getProcessId(), latestVersion));
                                participantDirectory.setVersion(latestVersion);
                                participantDirectoryDao.save(participantDirectory);
                            }
                        }
                    }
                }

                if(activityPluginList != null){
                    for (ActivityPlugin activityPlugin : activityPluginList) {
                        if (activityPluginDao.getPlugin(activityPlugin.getProcessId(), latestVersion, activityPlugin.getActivityId()) == null) {
                            activityPlugin.setId(null);
                            activityPlugin.setProcessId(updateProcessVersion(activityPlugin.getProcessId(), latestVersion));
                            activityPlugin.setVersion(latestVersion);
                            activityPluginDao.save(activityPlugin);
                        }
                    }
                }
                
                if(activitySetupList != null){
                    for(ActivitySetup activitySetup : activitySetupList){
                        activitySetup.setId(null);
                        activitySetup.setProcessId(updateProcessVersion(activitySetup.getProcessId(), latestVersion));
                        activitySetupDao.save(activitySetup);
                    }
                }
            }

            //import form & category from userview (if exists)
            UserviewSetup userviewSetup = exportedPackage.getUserviewSetup();
            if (userviewSetup != null) {
                Set<UserviewProcess> userviewProcessList = userviewSetup.getProcesses();
                if (userviewProcessList != null && userviewProcessList.size() > 0) {
                    for (UserviewProcess userviewProcess : userviewProcessList) {
                        Collection<Category> categoryList = userviewProcess.getCategoryList();
                        Collection<Form> formList = userviewProcess.getFormList();
                        Collection<FormVariable> formVariableList = userviewProcess.getFormVariableList();

                        if (categoryList != null) {
                            for (Category category : categoryList) {
                                if (getCategoryDao().find(category.getId()) == null) {
                                    getCategoryDao().save(category);
                                }
                            }
                        }

                        if(formVariableList != null){
                            for (FormVariable formVariable : formVariableList) {
                                if (getFormVariableDao().find(formVariable.getId()) == null) {
                                    if(getFormVariableDao().isExistsByName(formVariable.getName())){
                                        //append _packageId
                                        formVariable.setName(formVariable.getName() + "_" + packageId);
                                        getFormVariableDao().save(formVariable);
                                    }else{
                                        //check if plugin exists
                                        if(pluginManager.getPlugin(formVariable.getPluginName()) != null){
                                            getFormVariableDao().save(formVariable);
                                        }
                                    }
                                }
                            }
                        }

                        if (formList != null && formList.size() > 0) {
                            for (Form form : formList) {
                                if (form != null && !updatedForm.containsKey(form.getId())) {
                                    String oldId = form.getId();
                                    String newId = saveForm(form, versionSuffix, mobileFormList);
                                    updatedForm.put(oldId, newId);
                                }
                            }
                        }
                    }
                    FormUtil.updateBatchSubformReferenceId(updatedForm);
                }
            }

        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
    }

    private List<FormVariable> getFormVariableList(String formData){
        List<FormVariable> formVariableList = new ArrayList();
        List<String> formVariableIdList = FormUtil.getFormVariables(formData);
        for(String formVariableId : formVariableIdList){
            FormVariable formVariable = formVariableDao.find(formVariableId);
            if(formVariable != null){
                formVariableList.add(formVariable);
            }
        }

        return formVariableList;
    }

    private ExportedProcess exportProcess(String processDefId) {
        ExportedProcess exportedProcess = new ExportedProcess();
        exportedProcess.setId(processDefId);

        String version = processDefId.split("#")[1];
        String packageId = processDefId.split("#")[0];

        Collection<ActivityForm> activityFormList = activityFormDao.getActivityFormByPackageId(processDefId);

        Collection<Category> categoryList = new ArrayList();
        Collection<Form> formList = new ArrayList();
        Collection<FormVariable> formVariableList = new ArrayList();

        for (ActivityForm activityForm : activityFormList) {
            if (activityForm.getFormId() != null && activityForm.getFormId().trim().length() > 0) {
                Form form = formDao.find(activityForm.getFormId());
                if (form != null) {
                    formList.add(form);

                    //look for form variable
                    formVariableList.addAll(getFormVariableList(form.getData()));

                    //look for subform
                    List<String> subformList = FormUtil.getSubForms(form.getData());
                    if (subformList != null && subformList.size() > 0) {
                        for (String subformId : subformList) {
                            Form subform = formDao.find(subformId);
                            if (subform != null) {
                                formList.add(subform);

                                //look for form variable
                                formVariableList.addAll(getFormVariableList(subform.getData()));

                                //get subform category
                                String categoryId = subform.getCategoryId();
                                if (categoryId != null && categoryId.trim().length() > 0) {
                                    Category category = categoryDao.find(categoryId);
                                    if (!categoryList.contains(category)) {
                                        categoryList.add(category);
                                    }
                                }
                            }
                        }
                    }

                    String categoryId = form.getCategoryId();
                    if (categoryId != null && categoryId.trim().length() > 0) {
                        Category category = categoryDao.find(categoryId);
                        if (!categoryList.contains(category)) {
                            categoryList.add(category);
                        }
                    }
                }
            }
        }

        Collection<ParticipantDirectory> participantDirectoryList = participantDirectoryDao.getParticipantDirectoryByPackageId(packageId, Integer.parseInt(version));
        Collection<ActivityPlugin> activityPluginList = activityPluginDao.getActivityPluginByPackageId(processDefId, Integer.parseInt(version));
        Collection<ActivitySetup> activitySetupList = activitySetupDao.getActivitySetupByProcessId(processDefId);

        exportedProcess.setCategoryList(categoryList);
        exportedProcess.setFormList(formList);
        exportedProcess.setFormVariableList(formVariableList);
        exportedProcess.setActivityFormList(activityFormList);
        exportedProcess.setParticipantDirectoryList(participantDirectoryList);
        exportedProcess.setActivityPluginList(activityPluginList);
        exportedProcess.setActivitySetupList(activitySetupList);

        return exportedProcess;
    }

    public void exportUserview(String userviewId, OutputStream outputStream) throws Exception{

        UserviewSetup userviewSetup = userviewSetupManager.getUserviewSetup(userviewId);
        Collection<UserviewProcess> userviewProcessList = userviewProcessManager.getUserviewProcessBySetupId(userviewId);

        //to keep track which mobile form (.html) has been exported
        List<String> exportedMobileForm = new ArrayList<String>();

        String mobileFormPath = SetupManager.getBaseDirectory();
        mobileFormPath += (!mobileFormPath.endsWith(File.separator)) ? File.separator : "forms" + File.separator;

        //get Form object (and subform) from activityFormId (if exists)
        for (UserviewProcess userviewProcess : userviewProcessList) {
            List<Form> formList = new ArrayList<Form>();
            List<Category> categoryList = new ArrayList<Category>();
            List<FormVariable> formVariableList = new ArrayList<FormVariable>();

            if (userviewProcess.getActivityFormId() != null && userviewProcess.getActivityFormId().trim().length() > 0) {
                Form form = formDao.find(userviewProcess.getActivityFormId());
                if (form != null) {
                    formList.add(form);
                    if (form.getCategoryId() != null && form.getCategoryId().trim().length() > 0) {
                        Category category = categoryDao.find(form.getCategoryId());
                        if (category != null) {
                            categoryList.add(category);
                        }
                    }
                    exportedMobileForm.add(form.getId());

                    //get form variable
                    formVariableList.addAll(getFormVariableList(form.getData()));

                    //get subform
                    List<String> subformList = FormUtil.getSubForms(form.getData());
                    if (subformList != null && subformList.size() > 0) {
                        for (String subformId : subformList) {
                            Form subform = formDao.find(subformId);
                            if (subform != null) {
                                formList.add(subform);

                                //get form variable
                                formVariableList.addAll(getFormVariableList(subform.getData()));

                                //get subform category
                                if (subform.getCategoryId() != null && subform.getCategoryId().trim().length() > 0) {
                                    Category category = categoryDao.find(subform.getCategoryId());
                                    if (category != null) {
                                        categoryList.add(category);
                                    }
                                }
                                exportedMobileForm.add(subformId);
                            }
                        }
                    }
                }
            }

            userviewProcess.setFormList(formList);
            userviewProcess.setCategoryList(categoryList);
            userviewProcess.setFormVariableList(formVariableList);
        }
        userviewSetup.setProcesses(new HashSet<UserviewProcess>(userviewProcessList));

        ZipOutputStream out = new ZipOutputStream(outputStream);
        ByteArrayOutputStream baos = null;
        try {
            baos = new ByteArrayOutputStream();

            ExportedPackage exportedPackage = new ExportedPackage();

            List<String> includedProcessList = new ArrayList<String>();
            Collection<ExportedProcess> exportedProcessList = new ArrayList<ExportedProcess>();
            for(UserviewProcess userviewProcess : userviewProcessList){
                String processDefId = userviewProcess.getProcessDefId();

                if(!includedProcessList.contains(processDefId)){
                    exportedProcessList.add(exportProcess(processDefId));

                    //export mobile forms
                    Collection<ActivityForm> activityFormList = activityFormDao.getActivityFormByPackageId(processDefId);
                    for (ActivityForm activityForm : activityFormList) {
                        String formId = activityForm.getFormId();
                        if (formId != null && formId.trim().length() > 0 && !exportedMobileForm.contains(formId)) {
                            exportedMobileForm.add(formId);
                        }
                    }
                }

                includedProcessList.add(processDefId);
            }

            //export all mobile forms in the list
            byte[] buf = new byte[1024];
            for(String formId : exportedMobileForm){
                File mobileForm = new File(mobileFormPath + formId + ".html");
                if(mobileForm.exists()){
                    FileInputStream in = new FileInputStream(mobileForm);
                    out.putNextEntry(new ZipEntry(formId + ".html"));
                    int len;
                    while ((len = in.read(buf)) > 0) {
                        out.write(buf, 0, len);
                    }
                    out.closeEntry();
                }
            }

            exportedPackage.setUserviewSetup(userviewSetup);
            exportedPackage.setProcessList(exportedProcessList);

            Serializer serializer = new Persister();
            serializer.write(exportedPackage, baos, "UTF-8");

            out.putNextEntry(new ZipEntry("packageData.xml"));
            out.write(baos.toByteArray());
            out.closeEntry();

        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        } finally {
            if(baos != null){
                try{
                    baos.close();
                }catch(Exception e){
                    LogUtil.error(getClass().getName(), e, "");
                }
            }
        }

        //export xpdl(s)
        List<String> includedProcessList = new ArrayList<String>();

        String processDefId = userviewSetup.getStartProcessDefId();
        processDefId = processDefId.replaceAll("%23", "#");
        String version = processDefId.split("#")[1];
        String packageId = processDefId.split("#")[0];

        out.putNextEntry(new ZipEntry(packageId + ".xpdl"));
        out.write(workflowManager.getPackageContent(packageId, version));
        out.closeEntry();

        includedProcessList.add(packageId);
        for(UserviewProcess userviewProcess : userviewProcessList){
            processDefId = userviewProcess.getProcessDefId();
            version = processDefId.split("#")[1];
            packageId = processDefId.split("#")[0];

            if(!includedProcessList.contains(packageId)){
                out.putNextEntry(new ZipEntry(packageId + ".xpdl"));
                out.write(workflowManager.getPackageContent(packageId, version));
                out.closeEntry();
                includedProcessList.add(packageId);
            }
        }

        out.close();
    }

    public void importUserview(byte[] packageData, Collection<byte[]> packageXpdlList, Map<String, byte[]> mobileFormList){
        Map<String, String> allUpdatedForm = new HashMap<String, String>();
        for(byte[] packageXpdl : packageXpdlList){
            importPackage(packageData, packageXpdl, mobileFormList);
            allUpdatedForm.putAll(updatedForm);
        }

        try {
            Serializer serializer = new Persister();
            ExportedPackage exportedPackage = serializer.read(ExportedPackage.class, new ByteArrayInputStream(packageData), "UTF-8");

            UserviewSetup userviewSetup = exportedPackage.getUserviewSetup();
            String processDefId = userviewSetup.getStartProcessDefId();
            processDefId = processDefId.replaceAll("%23", "#");
            String packageId = processDefId.split("#")[0];
            String processId = processDefId.split("#")[2];
            userviewSetup.setStartProcessDefId(packageId + "%23" + getPackageLatestVersion(packageId) + "%23" + processId);

            Set<UserviewProcess> userviewProcessList = userviewSetup.getProcesses();
            for(UserviewProcess userviewProcess : userviewProcessList){
                processDefId = userviewProcess.getProcessDefId();
                packageId = processDefId.split("#")[0];
                processId = processDefId.split("#")[2];
                userviewProcess.setProcessDefId(packageId + "#" + getPackageLatestVersion(packageId) + "#" + processId);

                //update activityFormId according to the updated form map
                String formId = allUpdatedForm.get(userviewProcess.getActivityFormId());
                userviewProcess.setActivityFormId(formId);
            }

            userviewProcessManager.removeUserviewProcessBySetupId(userviewSetup.getId());
            userviewSetup.setProcesses(null);
            userviewSetupManager.saveUserviewSetup(userviewSetup);
            for(UserviewProcess userviewProcess : userviewProcessList){
                userviewProcess.setId(null);
                userviewProcess.setDvSetup(userviewSetup);
                userviewProcessManager.saveUserviewProcess(userviewProcess);
            }

            
            //update start process plugin
            Collection<String> processDefIds = userviewProcessManager.getProcessDefIdListBySetupId(userviewSetup.getId());
            for(String tempProcessDefId : processDefIds){
                Collection<ActivityPlugin> pluginList = activityPluginDao.getActivityPluginByProcessDefIdAndPluginName(tempProcessDefId, "org.joget.plugin.startProcess.StartProcessPlugin");

                for(ActivityPlugin spp : pluginList){
                    String properties = spp.getPluginProperties();
                    String pProcessDefId = properties.substring(properties.indexOf("\"procDefId\",\"") + 13 , properties.length() - 2);
                    String pPackageId = pProcessDefId.split("#")[0];
                    String pProcessId = pProcessDefId.split("#")[2];

                    properties = properties.replaceAll(pProcessDefId , pPackageId + "#" + getPackageLatestVersion(pPackageId) + "#" + pProcessId);
                    spp.setPluginProperties(properties);
                    activityPluginDao.saveOrUpdate(spp);
                }
            }

        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }
    }

    public void exportPackageData(String processDefId, OutputStream outputStream) throws IOException{
        String packageId = processDefId.split("#")[0];
        String version = processDefId.split("#")[1];

        ZipOutputStream out = new ZipOutputStream(outputStream);
        ByteArrayOutputStream baos = null;
        try {
            baos = new ByteArrayOutputStream();

            Collection<WorkflowProcess> workflowProcessList = workflowManager.getProcessList(packageId);
            ExportedPackage exportedPackage = new ExportedPackage();

            Collection<ExportedProcess> exportedProcessList = new ArrayList<ExportedProcess>();
            for (WorkflowProcess process : workflowProcessList) {
                if (process.getVersion().equals(version)) {
                    ExportedProcess exportedProcess = exportProcess(process.getId());
                    exportedProcessList.add(exportedProcess);

                    //export mobile forms
                    Collection<String> includedFormList = new ArrayList<String>();
                    String mobileFormPath = SetupManager.getBaseDirectory();
                    mobileFormPath += (!mobileFormPath.endsWith(File.separator)) ? File.separator : "forms" + File.separator;
                    byte[] buf = new byte[1024];
                    for (Form form : exportedProcess.getFormList()) {
                        if (form.getId() != null && form.getId().trim().length() > 0) {
                            String fileName = form.getId() + ".html";
                            if(!includedFormList.contains(fileName)){
                                File mobileForm = new File(mobileFormPath + form.getId() + ".html");
                                if(mobileForm.exists()){
                                    FileInputStream in = new FileInputStream(mobileForm);
                                    out.putNextEntry(new ZipEntry(fileName));
                                    int len;
                                    while ((len = in.read(buf)) > 0) {
                                        out.write(buf, 0, len);
                                    }
                                    out.closeEntry();
                                }
                                
                                includedFormList.add(fileName);
                            }
                        }
                    }
                    
                }
            }

            exportedPackage.setProcessList(exportedProcessList);

            Serializer serializer = new Persister();
            serializer.write(exportedPackage, baos, "UTF-8");

            out.putNextEntry(new ZipEntry("packageData.xml"));
            out.write(baos.toByteArray());
            out.closeEntry();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }finally{
            if(baos != null){
                try{
                    baos.close();
                }catch(Exception e){
                    LogUtil.error(getClass().getName(), e, "");
                }
            }
        }

        byte[] xpdl = workflowManager.getPackageContent(packageId, version);
        out.putNextEntry(new ZipEntry("package.xpdl"));
        out.write(xpdl);
        out.closeEntry();

        out.close();
    }

    public byte[] exportPackageData(String packageId, String version) {
        byte[] packageDataXml = null;

        ByteArrayOutputStream baos = null;
        try {
            baos = new ByteArrayOutputStream();

            Collection<WorkflowProcess> workflowProcessList = workflowManager.getProcessList(packageId);
            ExportedPackage exportedPackage = new ExportedPackage();

            Collection<ExportedProcess> exportedProcessList = new ArrayList<ExportedProcess>();
            for (WorkflowProcess process : workflowProcessList) {
                if (process.getVersion().equals(version)) {
                    exportedProcessList.add(exportProcess(process.getId()));
                }
            }

            exportedPackage.setProcessList(exportedProcessList);

            Serializer serializer = new Persister();
            serializer.write(exportedPackage, baos, "UTF-8");

            packageDataXml = baos.toByteArray();
        } catch (Exception ex) {
            LogUtil.error(getClass().getName(), ex, "");
        }finally{
            if(baos != null){
                try{
                    baos.close();
                }catch(Exception e){
                    LogUtil.error(getClass().getName(), e, "");
                }
            }
        }

        return packageDataXml;
    }

    public String updateProcessVersion(String processId, int version) {
        if (processId != null) {
            String[] temp = processId.split("#");
            if (temp.length != 3) {
                return processId;
            }

            return temp[0] + "#" + version + "#" + temp[2];
        } else {
            return null;
        }
    }

    public byte[] getPackageDataXmlFromZip(byte[] zip) throws Exception {
        ZipInputStream in = new ZipInputStream(new ByteArrayInputStream(zip));
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ZipEntry entry = null;

        while ((entry = in.getNextEntry()) != null) {
            if (entry.getName().contains("packageData.xml")) {
                int length;
                byte[] temp = new byte[1024];

                while ((length = in.read(temp, 0, 1024)) != -1) {
                    out.write(temp, 0, length);
                }

                return out.toByteArray();
            }

            out.flush();
            out.close();
        }
        in.close();

        return null;
    }

    public Collection<byte[]> getAllPackageXpdlFromZip(byte[] zip) throws Exception {
        Collection<byte[]> packageXpdlList = new ArrayList<byte[]>();

        ZipInputStream in = new ZipInputStream(new ByteArrayInputStream(zip));
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ZipEntry entry = null;

        while ((entry = in.getNextEntry()) != null) {
            if (entry.getName().endsWith(".xpdl")) {
                int length;
                byte[] temp = new byte[1024];

                out = new ByteArrayOutputStream();
                while ((length = in.read(temp, 0, 1024)) != -1) {
                    out.write(temp, 0, length);
                }

                packageXpdlList.add(out.toByteArray());
            }

            out.flush();
            out.close();
        }
        in.close();

        return packageXpdlList;
    }

    public byte[] getPackageXpdlFromZip(byte[] zip) throws Exception {
        ZipInputStream in = new ZipInputStream(new ByteArrayInputStream(zip));
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ZipEntry entry = null;

        while ((entry = in.getNextEntry()) != null) {
            if (entry.getName().contains("package.xpdl")) {
                int length;
                byte[] temp = new byte[1024];

                while ((length = in.read(temp, 0, 1024)) != -1) {
                    out.write(temp, 0, length);
                }

                return out.toByteArray();
            }

            out.flush();
            out.close();
        }
        in.close();

        return null;
    }

    public Map<String, byte[]> getAllMobileFormFromZip(byte[] zip) throws Exception {
        Map<String, byte[]> mobileFormList = new HashMap<String, byte[]>();

        ZipInputStream in = new ZipInputStream(new ByteArrayInputStream(zip));
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ZipEntry entry = null;

        while ((entry = in.getNextEntry()) != null) {
            if (entry.getName().endsWith(".html")) {
                int length;
                byte[] temp = new byte[1024];

                out = new ByteArrayOutputStream();
                while ((length = in.read(temp, 0, 1024)) != -1) {
                    out.write(temp, 0, length);
                }

                mobileFormList.put(entry.getName(), out.toByteArray());
            }

            out.flush();
            out.close();
        }
        in.close();

        return mobileFormList;
    }

    public ActivityFormDao getActivityFormDao() {
        return activityFormDao;
    }

    public void setActivityFormDao(ActivityFormDao activityFormDao) {
        this.activityFormDao = activityFormDao;
    }

    public ActivityPluginDao getActivityPluginDao() {
        return activityPluginDao;
    }

    public void setActivityPluginDao(ActivityPluginDao activityPluginDao) {
        this.activityPluginDao = activityPluginDao;
    }

    public ParticipantDirectoryDao getParticipantDirectoryDao() {
        return participantDirectoryDao;
    }

    public void setParticipantDirectoryDao(ParticipantDirectoryDao participantDirectoryDao) {
        this.participantDirectoryDao = participantDirectoryDao;
    }

    public FormDao getFormDao() {
        return formDao;
    }

    public void setFormDao(FormDao formDao) {
        this.formDao = formDao;
    }

    public CategoryDao getCategoryDao() {
        return categoryDao;
    }

    public void setCategoryDao(CategoryDao categoryDao) {
        this.categoryDao = categoryDao;
    }

    public FormVariableDao getFormVariableDao() {
        return formVariableDao;
    }

    public void setFormVariableDao(FormVariableDao formVariableDao) {
        this.formVariableDao = formVariableDao;
    }

    public DirectoryManager getDirectoryManager() {
        return directoryManager;
    }

    public void setDirectoryManager(DirectoryManager directoryManager) {
        this.directoryManager = directoryManager;
    }

    public WorkflowManager getWorkflowManager() {
        return workflowManager;
    }

    public void setWorkflowManager(WorkflowManager workflowManager) {
        this.workflowManager = workflowManager;
    }

    public PluginManager getPluginManager() {
        return pluginManager;
    }

    public void setPluginManager(PluginManager pluginManager) {
        this.pluginManager = pluginManager;
    }

    public UserviewSetupManager getUserviewSetupManager() {
        return userviewSetupManager;
    }

    public void setUserviewSetupManager(UserviewSetupManager userviewSetupManager) {
        this.userviewSetupManager = userviewSetupManager;
    }

    public UserviewProcessManager getUserviewProcessManager() {
        return userviewProcessManager;
    }

    public void setUserviewProcessManager(UserviewProcessManager userviewProcessManager) {
        this.userviewProcessManager = userviewProcessManager;
    }

    public ActivitySetupDao getActivitySetupDao() {
        return activitySetupDao;
    }

    public void setActivitySetupDao(ActivitySetupDao activitySetupDao) {
        this.activitySetupDao = activitySetupDao;
    }

}
