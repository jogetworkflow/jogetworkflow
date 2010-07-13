package org.joget.plugin.notification;

import org.joget.commons.util.LogUtil;
import org.joget.directory.model.User;
import org.joget.directory.model.service.DirectoryManager;
import org.joget.plugin.base.AuditTrailPlugin;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginManager;
import org.joget.plugin.base.PluginProperty;
import org.joget.workflow.model.AuditTrail;
import org.joget.workflow.model.WorkflowActivity;
import org.joget.workflow.model.service.WorkflowManager;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.MultiPartEmail;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.joget.workflow.util.WorkflowUtil;

public class UserNotificationPlugin extends DefaultPlugin implements AuditTrailPlugin {

    public String getName() {
        return "User Notification Plugin";
    }

    public String getDescription() {
        return "Sends email notification to all participants, for every new task created";
    }

    public String getVersion() {
        return "1.0.5";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[]{
            new PluginProperty("base", "Base Url", PluginProperty.TYPE_TEXTFIELD, null, "http://localhost:8080/wflow-wfweb"),
            new PluginProperty("host", "SMTP Host", PluginProperty.TYPE_TEXTFIELD, null, ""),
            new PluginProperty("port", "SMTP Port", PluginProperty.TYPE_TEXTFIELD, null, "25"),
            new PluginProperty("needAuthentication", "Does the SMTP need authentication?", PluginProperty.TYPE_CHECKBOX, new String[]{"yes"}, null),
            new PluginProperty("username", "SMTP Username", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("password", "SMTP Password", PluginProperty.TYPE_PASSWORD, null, null),
            new PluginProperty("from", "From", PluginProperty.TYPE_TEXTFIELD, null, "email@domain"),
            new PluginProperty("cc", "CC", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("subject", "Subject", PluginProperty.TYPE_TEXTFIELD, null, "New Task: #assignment.activityName#"),
            new PluginProperty("emailMessage", "Email Message", PluginProperty.TYPE_TEXTAREA, null, "A new task has been created by the process #assignment.processName#")
        };
        return properties;
    }

    public Object execute(Map properties) {
        Object result = null;
        try {
            final AuditTrail auditTrail = (AuditTrail) properties.get("auditTrail");
            final PluginManager pluginManager = (PluginManager) properties.get("pluginManager");
            final WorkflowManager workflowManager = (WorkflowManager) pluginManager.getBean("workflowManager");
            final WorkflowUserManager workflowUserManager = (WorkflowUserManager) pluginManager.getBean("workflowUserManager");
            final DirectoryManager directoryManager = (DirectoryManager) pluginManager.getBean("directoryManager");

            final String base = (String) properties.get("base");
            final String smtpHost = (String) properties.get("host");
            final String smtpPort = (String) properties.get("port");
            final String needAuthentication = (String) properties.get("needAuthentication");
            final String smtpUsername = (String) properties.get("username");
            final String smtpPassword = (String) properties.get("password");

            final String from = (String) properties.get("from");
            final String cc = (String) properties.get("cc");

            final String subject = (String) properties.get("subject");
            final String emailMessage = (String) properties.get("emailMessage");

            if (smtpHost == null || smtpHost.trim().length() == 0) {
                return null;
            }

            if (auditTrail != null && (auditTrail.getMethod().equals("getDefaultAssignments") || auditTrail.getMethod().equals("assignmentReassign") || auditTrail.getMethod().equals("assignmentForceComplete"))) {
                new Thread(new Runnable() {

                    public void run() {
                        try {
                            String activityInstanceId = auditTrail.getMessage();
                            WorkflowActivity wfActivity = workflowManager.getActivityById(activityInstanceId);
                            List<String> userList = new ArrayList<String>();

                            int maxAttempt = 5;
                            int numOfAttempt = 0;
                            while (userList.isEmpty() && numOfAttempt < maxAttempt) {
                                //LogUtil.info(getClass().getName(), "Attempting to get resource ids....");
                                userList = workflowManager.getAssignmentResourceIds(wfActivity.getProcessDefId(), wfActivity.getProcessId(), activityInstanceId);
                                Thread.sleep(2000);
                                numOfAttempt++;
                            }

                            LogUtil.info(getClass().getName(), "Users to notify: " + userList);
                            for (String username : userList) {
                                workflowUserManager.setCurrentThreadUser(username);
                                WorkflowAssignment wfAssignment = workflowManager.getAssignment(activityInstanceId);

                                final User user = directoryManager.getUserByUsername(username);
                                if (user.getEmail() != null && user.getEmail().trim().length() > 0) {
                                    // create the email message
                                    final MultiPartEmail email = new MultiPartEmail();
                                    email.setHostName(smtpHost);
                                    if (smtpPort != null && smtpPort.length() != 0) {
                                        email.setSmtpPort(Integer.parseInt(smtpPort));
                                    }
                                    if (needAuthentication != null && needAuthentication.length() != 0 && needAuthentication.equals("yes")) {
                                        email.setAuthentication(smtpUsername, smtpPassword);
                                    }
                                    if (cc != null && cc.length() != 0) {
                                        Collection<String> ccs = convertStringToInternetRecipientsList(cc);
                                        for (String address : ccs) {
                                            email.addCc(address);
                                        }
                                    }

                                    email.addTo(user.getEmail());
                                    email.setFrom(from);

                                    if (subject != null && subject.length() != 0) {
                                        email.setSubject(WorkflowUtil.processVariable(subject, null, wfAssignment));
                                    }
                                    if (emailMessage != null && emailMessage.length() != 0) {
                                        String urlMapping = "";

                                        if (base.endsWith("/")) {
                                            urlMapping = "web/client/assignment/login/view/";
                                        } else {
                                            urlMapping = "/web/client/assignment/login/view/";
                                        }

                                        email.setMsg(WorkflowUtil.processVariable(emailMessage + "\n\n\n" + base + urlMapping + activityInstanceId, null, wfAssignment));
                                    }

                                    try {
                                        LogUtil.info(getClass().getName(), "Sending email from=" + email.getFromAddress().toString() + " to=" + user.getEmail() + ", subject=Workflow - Pending Task Notification");
                                        email.send();
                                        LogUtil.info(getClass().getName(), "Sending email completed for subject=" + email.getSubject());
                                    } catch (EmailException ex) {
                                        LogUtil.error(getClass().getName(), ex, "Error sending email");
                                    }
                                }
                            }
                        } catch (Exception ex) {
                            LogUtil.error(getClass().getName(), ex, "Error executing plugin");
                        }

                    }
                }).start();
            }
            return result;
        } catch (Exception e) {
            LogUtil.error(getClass().getName(), e, "Error executing plugin");
            return null;
        }
    }

    private Collection<String> convertStringToInternetRecipientsList(String s) throws AddressException {
        InternetAddress[] addresses;
        InternetAddress address;
        Collection<String> recipients = new ArrayList<String>();
        Set emailSet = new HashSet(); // to detect duplicate emails
        String addrStr;

        if (!("".equals(s) || s == null)) {
            addresses = InternetAddress.parse(s);
            for (int i = 0; i < addresses.length; i++) {
                address = addresses[i];
                addrStr = address.getAddress();

                if (addrStr == null || addrStr.trim().length() == 0) {
                    // ignore
                    continue;
                }
                // allow invalid RFC email addresses. Uncomment to check - but not recommended
                // address.validate();
                if (!emailSet.contains(addrStr)) {
                    emailSet.add(addrStr);
                    recipients.add(addrStr);
                }
            }
        }

        return recipients;
    }
}
