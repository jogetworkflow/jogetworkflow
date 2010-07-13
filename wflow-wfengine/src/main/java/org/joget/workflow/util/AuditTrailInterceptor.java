package org.joget.workflow.util;

import org.joget.commons.spring.model.Auditable;
import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.service.AuditTrailManager;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;

public class AuditTrailInterceptor implements MethodInterceptor {

    private AuditTrailManager auditTrailManager;

    public Object invoke(MethodInvocation methodInvocation) throws Throwable {
        if(methodInvocation.getMethod().getName().startsWith("get") ||
           methodInvocation.getMethod().getName().startsWith("is") ||
           methodInvocation.getMethod().getName().startsWith("internal")){
                return methodInvocation.proceed();
        }
        
        try{
            return methodInvocation.proceed();
        }finally{
            LogUtil.debug(getClass().getName(), "INTERCEPTED: " + methodInvocation.getMethod().getName());
            
            Object[] args = methodInvocation.getArguments();
            Class[] param = methodInvocation.getMethod().getParameterTypes();

            boolean isAuditableObjExist = false;

            String message = "";
            int i=0;
            for(Class clazz : param){
                if(args[i] instanceof Auditable){
                    Auditable obj = (Auditable) args[i];
                    message += clazz.getName() + "@" + obj.getAuditTrailId() + ";";
                    isAuditableObjExist = true;
                }

                i++;
            }

            if(!isAuditableObjExist){
                //get first argument (usually is ID)
                message = (String) args[0];
            }

            //remove trailing ';'
            if(isAuditableObjExist && message.length() > 0){
                message = message.substring(0, message.length()-1);
            }

            getAuditTrailManager().addAuditTrail(methodInvocation.getThis().getClass().getName(), methodInvocation.getMethod().getName(), message);
        }
    }

    public AuditTrailManager getAuditTrailManager() {
        return auditTrailManager;
    }

    public void setAuditTrailManager(AuditTrailManager auditTrailManager) {
        this.auditTrailManager = auditTrailManager;
    }
}