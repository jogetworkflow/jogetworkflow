package org.joget.form.model;

import java.io.File;
import java.util.Date;
import java.util.Map;
import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import org.joget.form.model.dao.DynamicFormDao;
import org.joget.form.model.service.FormManager;
import org.joget.workflow.model.WorkflowProcessLink;
import org.joget.workflow.model.service.WorkflowManager;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:formwebApplicationContext.xml"})
public class TestFormFacade {

    public TestFormFacade() {
    }
    @Autowired
    FormFacade formFacade;
    @Autowired
    FormManager formManager;
    @Autowired
    DynamicFormDao dynamicFormDao;
    @Autowired
    WorkflowManager workflowManager;

    private static String FORM_ID = "test_form_facade";
    private static String FORM_TABLE_NAME = "test_form_facade";
    private static String FORM_DATA = "{\"title\":\"_\",\"fieldsets\":[{\"id\":\"fieldset_0\",\"fieldsetMode\":\"normal\",\"label\":\"_\",\"widgets\":[{\"id\":\"row_0\",\"controls\":[{\"id\":\"text_0\",\"required\":false,\"label\":\"a\",\"description\":\"_\",\"name\":\"a\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_1\",\"controls\":[{\"id\":\"text_1\",\"required\":false,\"label\":\"b\",\"description\":\"_\",\"name\":\"b\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_2\",\"controls\":[{\"id\":\"text_2\",\"required\":false,\"label\":\"c\",\"description\":\"_\",\"name\":\"c\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"formVariableId\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"dateFormat\":\"\",\"deliminator\":\"\"}],\"type\":\"text\"}]}]}";
    private static String DYNAMIC_FORM_ID = "test_form_facade_dynamic_form_id";
    private static String PROCESS_1_ID = "test_form_facade_process_1_id";
    private static String PROCESS_2_ID = "test_form_facade_process_2_id";

    @Test
    public void suite() throws Exception{
        try {
            prepare();
            testWorkflowProcessLink();
        }catch(Exception ex){
            LogUtil.error(getClass().getName(), ex, ex.getMessage());
        }
        finally {
            clean();
        }
    }

    public void prepare(){
        LogUtil.info(getClass().getName(), ">>> prepare test enviroment");


        //create a form category
        Category category = new Category();
        category.setId(FORM_ID);
        category.setName(FORM_ID);
        category.setDescription(FORM_ID);
        formManager.saveCategory(category);

        //create a form
        Form form = new Form();
        form.setId(FORM_ID);
        form.setName(FORM_ID);
        form.setTableName(FORM_TABLE_NAME);
        form.setCategory(category);
        form.setData(FORM_DATA);
        formManager.saveForm(form);

        //create a dynamic form record
        Form dynamicForm = formManager.getFormById(FORM_ID);
        dynamicForm.setId(DYNAMIC_FORM_ID);
        dynamicForm.setValueOfCustomField("c_a", "a");
        dynamicForm.setValueOfCustomField("c_b", "b");
        dynamicForm.setValueOfCustomField("c_c", "c");
        dynamicForm.setValueOfCustomField("formId", FORM_ID);
        dynamicForm.setValueOfCustomField("processId", PROCESS_1_ID);
        dynamicForm.setValueOfCustomField("version", "1");
        dynamicForm.setValueOfCustomField("draft", "0");
        dynamicForm.setValueOfCustomField("created", new Date());
        formManager.saveOrUpdateDynamicForm(dynamicForm);

        LogUtil.info(getClass().getName(), ">>> create process link");
        WorkflowProcessLink link = new WorkflowProcessLink();
        link.setProcessId(PROCESS_2_ID);
        link.setParentProcessId(PROCESS_1_ID);
        link.setOriginProcessId(PROCESS_1_ID);
        workflowManager.internalAddWorkflowProcessLink(link);
    }

    public void testWorkflowProcessLink(){
        LogUtil.info(getClass().getName(), ">>> test store draft record for process 2");
        //test store draft record for process two
        MockHttpServletRequest request = new MockHttpServletRequest();
        request.setMethod("POST");
        request.addParameter("processId", PROCESS_2_ID);
        request.addParameter("version", "1");
        request.addParameter("activityId", PROCESS_2_ID+"_act1");
        request.addParameter("b", "b2");
        formFacade.saveFormSubmittedData(request, FORM_ID, PROCESS_2_ID, PROCESS_2_ID+"_act1");

        Form storedData = formManager.loadDraftDynamicForm(FORM_TABLE_NAME, PROCESS_1_ID, PROCESS_2_ID+"_act1");
        Assert.assertNotNull(storedData);

        LogUtil.info(getClass().getName(), ">>> test data loading");
        //test get record
        Map loadedMap = formFacade.getFormSubmittedData(FORM_ID, PROCESS_2_ID, PROCESS_2_ID+"_act1");
        Assert.assertTrue("a".equals(loadedMap.get("c_a")));
        Assert.assertTrue("b2".equals(loadedMap.get("c_b")));
        Assert.assertTrue("c".equals(loadedMap.get("c_c")));

        LogUtil.info(getClass().getName(), ">>> test data merging");
        //test merge record
        formFacade.mergeDraftToLive(FORM_TABLE_NAME, PROCESS_2_ID, PROCESS_2_ID+"_act1");
        Form mergedData = formManager.loadDynamicFormByProcessId(FORM_TABLE_NAME, PROCESS_1_ID);
        Assert.assertTrue("a".equals(mergedData.getCustomProperties().get("c_a")));
        Assert.assertTrue("b2".equals(mergedData.getCustomProperties().get("c_b")));
        Assert.assertTrue("c".equals(mergedData.getCustomProperties().get("c_c")));
    }

    public void clean(){
        LogUtil.info(getClass().getName(), ">>> clean test data");
        //delete dynamic form data -- TODO: Drop the dynamic test table
        Form form = formManager.loadDynamicFormByProcessId(FORM_TABLE_NAME, PROCESS_1_ID);
        dynamicFormDao.delete(FORM_TABLE_NAME, form);

        //remove form
        formManager.deleteForm(FORM_ID);

        //remove category
        formManager.deleteCategory(FORM_ID);

        //remove hibrenate mapping file
        String path = SetupManager.getBaseDirectory();
        if(!path.endsWith(File.separator)){
            path += File.separator;
        }
        path += "forms";
        File mappingFile = new File(path, "Form_" + FORM_TABLE_NAME + ".hbm.xml");
        File metadataMappingFile = new File(path, "FormMetaData_" + FORM_TABLE_NAME + ".hbm.xml");
        mappingFile.delete();
        metadataMappingFile.delete();

        //delete process link
        LogUtil.info(getClass().getName(), ">>> delete process link");
        WorkflowProcessLink link = workflowManager.getWorkflowProcessLink(PROCESS_2_ID);
        workflowManager.internalDeleteWorkflowProcessLink(link);
    }
}
