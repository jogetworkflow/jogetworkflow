package org.joget.workflow.model;

import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.dao.ActivityFormDao;
import java.util.Collection;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.orm.hibernate3.SessionFactoryUtils;
import org.springframework.orm.hibernate3.SessionHolder;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:wfengineApplicationContext.xml"})
public class TestWorkflowActivityFormDao {

    @Autowired
    private ActivityFormDao activityFormDao;
    
    @Autowired
    @Qualifier("workflow")
    private SessionFactory sessionFactory;

    @Before
    public void setUp() throws Exception {
        Session s = sessionFactory.openSession();
        TransactionSynchronizationManager.bindResource(sessionFactory, new SessionHolder(s));
    }

    @After
    public void tearDown() throws Exception {
        SessionHolder holder = (SessionHolder) TransactionSynchronizationManager.getResource(sessionFactory);
        Session s = holder.getSession();
        s.flush();
        TransactionSynchronizationManager.unbindResource(sessionFactory);
        SessionFactoryUtils.closeSession(s);
    }

    @Test
    public void testAssign() {
        LogUtil.info(getClass().getName(), "TWAFM:testAssign()");

        activityFormDao.assignMultiFormToActivity("form_1", "package#1#process_1", 1, "activity_1", 1);
        activityFormDao.assignMultiFormToActivity("form_2", "package#1#process_1", 1, "activity_1", 2);
        activityFormDao.assignMultiFormToActivity("form_3", "package#1#process_1", 1, "activity_1", 3);

        Assert.notNull(activityFormDao);
    }

    //@Test
    public void testGet() {
        LogUtil.info(getClass().getName(), "TWAFM:testGet()");

        Collection<ActivityForm> results = activityFormDao.getFormByActivity("package#1#process_1", 4, "activity_1");

        for (ActivityForm temp : results) {
            LogUtil.info(getClass().getName(), temp.getId());
        }

        Assert.notEmpty(results);
    }
    
    //@Test
    public void testUnassign() {
        LogUtil.info(getClass().getName(), "TWAFM:testUnassign()");

        activityFormDao.unassignFormFromActivity("form_1", "process_1", 1, "activity_1");
        Collection results = activityFormDao.getFormByFormId("form_1", "process_1", 1, "activity_1");

        Assert.isTrue(results.size() == 0);
    }

    //@Test
    public void testLastSequence() {
        LogUtil.info(getClass().getName(), "TWAFM:testLastSequence()");

        ActivityForm form1 = activityFormDao.getMultiFormBySequence("process_1", 1, "activity_1", 1);
        ActivityForm form2 = activityFormDao.getMultiFormBySequence("process_1", 1, "activity_1", 2);
        ActivityForm form3 = activityFormDao.getMultiFormBySequence("process_1", 1, "activity_1", 3);

        Assert.isTrue(!activityFormDao.isLastMultiForm(form1.getId()));
        Assert.isTrue(!activityFormDao.isLastMultiForm(form2.getId()));
        Assert.isTrue(activityFormDao.isLastMultiForm(form3.getId()));
    }

    //@Test
    public void testGetBySequence() {
        LogUtil.info(getClass().getName(), "TWAFM:testGetBySequence()");

        Assert.notNull(activityFormDao.getMultiFormBySequence("process_1", 1, "activity_1", 1));
        Assert.notNull(activityFormDao.getMultiFormBySequence("process_1", 1, "activity_1", 2));
        Assert.notNull(activityFormDao.getMultiFormBySequence("process_1", 1, "activity_1", 3));
    }

    @Test
    public void testUnassignAll() {
        LogUtil.info(getClass().getName(), "TWAFM:testUnassignAll()");

        //activityFormDao.unassignAllFormFromActivity("process_1", 1, "activity_1");
        Collection<ActivityForm> results = activityFormDao.getFormByActivity("package#1#process_1", 1, "activity_1");

        for (ActivityForm temp : results) {
            activityFormDao.delete(temp);
        }

        results = activityFormDao.getFormByActivity("package#1#process_1", 1, "activity_1");
        LogUtil.info(getClass().getName(), results.size() + "");
        Assert.isTrue(results.size() == 0);
    }
}
