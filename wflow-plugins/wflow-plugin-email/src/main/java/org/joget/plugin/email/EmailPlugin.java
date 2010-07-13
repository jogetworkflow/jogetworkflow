package org.joget.plugin.email;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import org.joget.commons.util.LogUtil;
import org.joget.directory.model.User;
import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginException;
import org.joget.plugin.base.PluginManager;
import org.joget.plugin.base.PluginProperty;
import org.joget.workflow.model.WorkflowAssignment;
import org.joget.workflow.model.WorkflowProcess;
import org.joget.workflow.model.service.WorkflowManager;
import org.joget.workflow.util.WorkflowUtil;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.MultiPartEmail;
import org.joget.directory.model.service.DirectoryManager;

public class EmailPlugin extends DefaultPlugin implements ApplicationPlugin {

    private DirectoryManager directoryManager;

    public String getName() {
        return "Email Plugin";
    }

    public String getDescription() {
        return "Sends email message to targeted recipient(s)";
    }

    public String getVersion() {
        return "1.0.14";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[]{
            new PluginProperty("formDataTable", "Form Data Table", PluginProperty.TYPE_TEXTFIELD, null, ""),
            new PluginProperty("host", "SMTP Host", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("port", "SMTP Port", PluginProperty.TYPE_TEXTFIELD, null, "25"),
            new PluginProperty("needAuthentication", "Does the SMTP need authentication?", PluginProperty.TYPE_CHECKBOX, new String[]{"yes"}, null),
            new PluginProperty("username", "SMTP Username", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("password", "SMTP Password", PluginProperty.TYPE_PASSWORD, null, null),
            new PluginProperty("from", "From", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("toSpecific", "To (specific email address)", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("toParticipantId", "To (participant ID)", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("cc", "CC", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("subject", "Subject", PluginProperty.TYPE_TEXTFIELD, null, null),
            new PluginProperty("message", "Message", PluginProperty.TYPE_TEXTAREA, null, null)
        };
        return properties;
    }

    public Object execute(Map properties) {
        PluginManager pluginManager = (PluginManager) properties.get("pluginManager");
        directoryManager = (DirectoryManager) pluginManager.getBean("directoryManager");

        String formDataTable = (String) properties.get("formDataTable");
        String smtpHost = (String) properties.get("host");
        String smtpPort = (String) properties.get("port");
        String needAuthentication = (String) properties.get("needAuthentication");
        String smtpUsername = (String) properties.get("username");
        String smtpPassword = (String) properties.get("password");

        final String from = (String) properties.get("from");
        final String cc = (String) properties.get("cc");
        String toParticipantId = (String) properties.get("toParticipantId");
        String toSpecific = (String) properties.get("toSpecific");

        String emailSubject = (String) properties.get("subject");
        String emailMessage = (String) properties.get("message");

        WorkflowAssignment wfAssignment = (WorkflowAssignment) properties.get("workflowAssignment");
        emailSubject = WorkflowUtil.processVariable(emailSubject, formDataTable, wfAssignment);
        emailMessage = WorkflowUtil.processVariable(emailMessage, formDataTable, wfAssignment);

        try {
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
                String ccStr = WorkflowUtil.processVariable(cc, formDataTable, wfAssignment);
                Collection<String> ccs = convertStringToInternetRecipientsList(ccStr);
                for (String address : ccs) {
                    email.addCc(address);
                }
            }

            final String fromStr = WorkflowUtil.processVariable(from, formDataTable, wfAssignment);
            email.setFrom(fromStr);
            email.setSubject(emailSubject);
            email.setMsg(emailMessage);
            String emailToOutput = "";

            if (toParticipantId != null && toParticipantId.trim().length() != 0) {
                WorkflowManager workflowManager = (WorkflowManager) pluginManager.getBean("workflowManager");
                WorkflowProcess process = workflowManager.getProcess(wfAssignment.getProcessDefId());
                String pIds[] = toParticipantId.split(",");


                for(String pId: pIds){
                    List<String> userList = null;
                    userList = WorkflowUtil.getAssignmentUsers(process.getPackageId(), wfAssignment.getProcessDefId(), wfAssignment.getProcessId(), wfAssignment.getProcessVersion(), wfAssignment.getActivityId(), "", pId.trim());

                    if (userList != null && userList.size() > 0) {
                        for (String username : userList) {
                            User user = directoryManager.getUserByUsername(username);
                            String userEmail = user.getEmail();
                            if (userEmail != null && userEmail.trim().length() > 0) {
                                email.addTo(userEmail);
                                emailToOutput += userEmail + ", ";
                            }
                        }
                    }
                }
            } else if (toSpecific != null && toSpecific.trim().length() != 0) {
                String toSpecificStr = WorkflowUtil.processVariable(toSpecific, formDataTable, wfAssignment);
                Collection<String> tss = convertStringToInternetRecipientsList(toSpecificStr);
                for (String address : tss) {
                    email.addTo(address);
                    emailToOutput += address + ", ";
                }
            } else {
                throw new PluginException("no email specified");
            }

            final String to = emailToOutput;

            Thread emailThread = new Thread(new Runnable() {

                public void run() {
                    try {
                        LogUtil.info(getClass().getName(), "EmailPlugin: Sending email from=" + fromStr + ", to=" + to + "cc=" + cc + ", subject=" + email.getSubject());
                        email.send();
                        LogUtil.info(getClass().getName(), "EmailPlugin: Sending email completed for subject=" + email.getSubject());
                    } catch (EmailException ex) {
                        LogUtil.error(getClass().getName(), ex, "");
                    }
                }
            });
            emailThread.setDaemon(true);
            emailThread.start();

        } catch (Exception e) {
            LogUtil.error(getClass().getName(), e, "");
        }

        return null;
    }

    private Collection<String> convertStringToInternetRecipientsList(String s) throws AddressException {
        InternetAddress[] addresses;
        InternetAddress address;
        Collection<String> recipients = new ArrayList<String>();
        Set emailSet = new HashSet(); // to detect duplicate emails
        String addrStr;

        if (!("".equals(s) || s == null)) {
            s = s.replace(";", ","); // add support for MS-style semi-colon (;) as a delimiter
            addresses = InternetAddress.parse(s);
            for (int i = 0; i < addresses.length; i++) {
                address = addresses[i];
                addrStr = address.getAddress();

                if (addrStr == null || addrStr.trim().length() == 0) {
                    // ignore
                    continue;
                }

                //to support retrieve email by putting username
                if (!addrStr.contains("@")){
                    try{
                        User user = directoryManager.getUserByUsername(addrStr);
                        if(user != null){
                            String emailStr = user.getEmail();

                            if(emailStr != null && !emailStr.trim().equals("")){
                                addrStr = emailStr;
                            }
                        }
                    }catch(Exception e){
                        LogUtil.info(getClass().getName(), "User not found!");
                    }
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
