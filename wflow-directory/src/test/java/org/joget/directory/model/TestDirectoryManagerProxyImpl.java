package org.joget.directory.model;

import org.joget.directory.model.User;
import org.joget.commons.util.LogUtil;
import org.joget.directory.model.service.DirectoryManager;
import java.util.Collection;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:directoryApplicationContext.xml"})
public class TestDirectoryManagerProxyImpl {

    @Autowired
    @Qualifier("main")
    private DirectoryManager directoryManagerProxy;

    @Test
    public void test() {
        Collection<User> userList = directoryManagerProxy.getUserList();
        for (User user : userList) {
            LogUtil.info(getClass().getName(), user.getUsername());
        }

        userList = directoryManagerProxy.getUserList();
        for (User user : userList) {
            LogUtil.info(getClass().getName(), user.getUsername());
        }

        //Assert.notEmpty(userList);
    }
}
