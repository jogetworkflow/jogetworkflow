package org.joget.workflow.controller;

import org.junit.Test;
import org.junit.Assert;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:WEB-INF/applicationContext.xml", "classpath:WEB-INF/dispatcher-servlet.xml"})
public class TestWorkflowJsonController {

    @Autowired
    WorkflowJsonController jsonController;

    @Test
    public void testAutowired() {
        Assert.assertNotNull(jsonController);
    }
}
