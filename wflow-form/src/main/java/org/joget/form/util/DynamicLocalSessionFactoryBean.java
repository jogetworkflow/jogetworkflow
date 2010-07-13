package org.joget.form.util;

import org.joget.commons.util.LogUtil;
import org.joget.form.model.dao.DynamicFormDaoSupport;
import org.hibernate.cfg.Configuration;
import org.springframework.orm.hibernate3.LocalSessionFactoryBean;

public class DynamicLocalSessionFactoryBean extends LocalSessionFactoryBean {
    
    private DynamicFormDaoSupport dao; 
    
    @Override
    protected void postProcessMappings(Configuration config) {
        try {
            getDao().customizeConfiguration(config);
        }
        catch(Exception e) {
            LogUtil.error(getClass().getName(), e, "");
        }
    }

    public DynamicFormDaoSupport getDao() {
        return dao;
    }

    public void setDao(DynamicFormDaoSupport dao) {
        this.dao = dao;
    }
}
