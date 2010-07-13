package org.joget.workflow.security;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import org.joget.workflow.model.service.WorkflowUserManager;
import org.joget.workflow.util.WorkflowUtil;
import org.springframework.context.ApplicationContext;
import org.springframework.security.ui.ntlm.NtlmProcessingFilter;

public class WorkflowNtlmProcessingFilter extends NtlmProcessingFilter {

    protected void doFilterHttp(final HttpServletRequest request,
            final HttpServletResponse response, final FilterChain chain) throws IOException, ServletException {

        ApplicationContext appContext = WorkflowUtil.getApplicationContext();
        String currentUser = ((WorkflowUserManager) appContext.getBean("workflowUserManager")).getCurrentUsername();
        if (WorkflowUserManager.ROLE_ANONYMOUS.equals(currentUser)) {
            String enableNtlm = WorkflowUtil.getSystemSetupValue("enableNtlm");

            if (enableNtlm != null && enableNtlm.equals("true")) {
                String ntlmDefaultDomain = WorkflowUtil.getSystemSetupValue("ntlmDefaultDomain");
                String ntlmDomainController = WorkflowUtil.getSystemSetupValue("ntlmDomainController");
                String ntlmNetbiosWins = WorkflowUtil.getSystemSetupValue("ntlmNetbiosWins");
                if ((ntlmDomainController != null && ntlmDomainController.trim().length() > 0) || (ntlmNetbiosWins != null && ntlmNetbiosWins.trim().length() > 0)) {
                    if (ntlmDefaultDomain != null) {
                        setDefaultDomain(ntlmDefaultDomain);
                    }

                    if (ntlmDomainController != null) {
                        setDomainController(ntlmDomainController);
                    }

                    if (ntlmNetbiosWins != null) {
                        setNetbiosWINS(ntlmNetbiosWins);
                    }
                    
                    try {
                        super.doFilterHttp(request, response, chain);
                    } catch (IOException e) {
                        chain.doFilter(request, response);
                    }
                } else {
                    chain.doFilter(request, response);
                }
            } else {
                chain.doFilter(request, response);
            }
        } else {
            chain.doFilter(request, response);
        }

    }
}
