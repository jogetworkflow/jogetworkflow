package org.joget.workflow.shark;

import org.joget.commons.util.LogUtil;
import org.joget.workflow.model.service.WorkflowManager;
import org.joget.workflow.util.WorkflowUtil;
import java.util.ArrayList;
import java.util.List;
import org.enhydra.shark.client.utilities.LimitStruct;
import org.enhydra.shark.utilities.MiscUtilities;
import org.joget.commons.util.HostManager;

public class DeadlineChecker extends Thread {

    protected String profile;
    protected long delay;
    protected int instancesPerTransaction;
    protected int failuresToIgnore;
    protected boolean stopped = true;
    protected List limitStructs;
    protected boolean isInitialized = false;
    protected boolean deadlineReeval = false;

    public DeadlineChecker(String profile,
            List limitStructs,
            long delay,
            int instPerTrans,
            int failToIgnore,
            boolean startImmediatelly) {
        this.profile = profile;
        this.limitStructs = limitStructs;
        this.delay = delay;
        this.setDaemon(true);
        this.instancesPerTransaction = instPerTrans;
        this.failuresToIgnore = failToIgnore;

        if (startImmediatelly) {
            startChecker();
        }

        LogUtil.info(getClass().getName(), "Deadline checking time initialized to " + delay + " ms. Deadline times: " + limitStructs + ". Checking " + instancesPerTransaction + " instances per transaction, ignoring " + failuresToIgnore + " failures for profile " + profile);
    }

    public String getProfile() {
        return profile;
    }

    public void setProfile(String profile) {
        this.profile = profile;
    }

    public long getDelay() {
        return delay;
    }

    public void setDelay(long delay) {
        this.delay = delay;
    }

    public List getLimitStructs() {
        return this.limitStructs;
    }

    public void setLimitStructs(List ls) {
        this.limitStructs = ls;
    }

    public void setLimitStructsByString(String str) {
        List lcStrLst = new ArrayList();
        try {
            String[] lcStructs = MiscUtilities.tokenize(str, ",");
            if (lcStructs != null) {
                for (int i = 0; i < lcStructs.length; i++) {
                    String lcstruct = lcStructs[i];
                    try {
                        String[] hma = MiscUtilities.tokenize(lcstruct, ":");
                        String h = hma[0];
                        String m = hma[1];
                        String a = hma[2];
                        lcStrLst.add(new LimitStruct(Integer.parseInt(h),
                                Integer.parseInt(m),
                                Integer.parseInt(a)));
                    } catch (Exception ex) {
                    }
                }
            }
        } catch (Exception ex) {
            System.err.println("DeadlineChecker: Problem while setting limit structures through string!");
        }
        setLimitStructs(lcStrLst);
    }

    public int getInstancesPerTransaction() {
        return instancesPerTransaction;
    }

    public void setInstancesPerTransaction(int insPerTrans) {
        this.instancesPerTransaction = insPerTrans;
    }

    public int getFailuresToIgnore() {
        return failuresToIgnore;
    }

    public void setFailuresToIgnore(int failToIgnore) {
        this.failuresToIgnore = failToIgnore;
    }

    public void stopChecker() {
        stopped = true;
    }

    public void startChecker() {
        stopped = false;
        if (!isInitialized) {
            isInitialized = true;
            start();
        }
    }

    @Override
    public void run() {
        while (true) {
            try {
                sleep(delay);
                if (!stopped) {
                    runMe();
                }
            } catch (Exception ex) {
                LogUtil.error(getClass().getName(), ex, "");
            }
        }
    }

    protected void runMe() {
        try {
            LogUtil.debug(getClass().getName(), "Checking deadlines for profile " + profile);
            long start = System.currentTimeMillis();

            HostManager.setCurrentProfile(profile);
            WorkflowManager workflowManager = (WorkflowManager) WorkflowUtil.getApplicationContext().getBean("workflowManager");
            workflowManager.internalCheckDeadlines(instancesPerTransaction, failuresToIgnore);

            long end = System.currentTimeMillis();

            LogUtil.debug(getClass().getName(), "Deadline check lasted " + (end - start) + " ms for profile " + profile);
        } catch (Exception e) {
            LogUtil.error(getClass().getName(), e, "");
        }
    }

    public boolean isStopped(){
        return stopped;
    }
}
