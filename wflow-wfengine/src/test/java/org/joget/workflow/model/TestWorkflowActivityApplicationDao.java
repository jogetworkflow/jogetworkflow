package org.joget.workflow.model;

import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.dao.ActivityApplicationDao;
import java.util.Collection;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:wfengineApplicationContext.xml"})
public class TestWorkflowActivityApplicationDao {

    @Autowired
    private ActivityApplicationDao activityApplicationDao;

    @Test
    public void testSet() {
        LogUtil.info(getClass().getName(), "TWAAM:testSet()");
        activityApplicationDao.setApplicationToActivity("org.joget.workflow.Application", "process#1", 1, "activity#1");

        Collection<ActivityApplication> results = activityApplicationDao.getApplication("process#1", 1, "activity#1");
        Assert.isTrue(results.size() > 0);
    }

    @Test
    public void testGet() {
        LogUtil.info(getClass().getName(), "TWAAM:testGet()");
        Collection<ActivityApplication> results = activityApplicationDao.getApplication("process#1", 1, "activity#1");

        Assert.notEmpty(results);
    }

    @Test
    public void testRemove() {
        LogUtil.info(getClass().getName(), "TWAAM:testRemove()");
        activityApplicationDao.removeApplicationFromActivity("org.joget.workflow.Application", "process#1", 1, "activity#1");

        Collection<ActivityApplication> results = activityApplicationDao.getApplication("process#1", 1, "activity#1");
        Assert.isTrue(results.size() == 0);
    }
}
