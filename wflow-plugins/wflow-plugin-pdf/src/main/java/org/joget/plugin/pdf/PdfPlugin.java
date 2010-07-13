package org.joget.plugin.pdf;

import org.joget.plugin.base.ApplicationPlugin;
import org.joget.plugin.base.DefaultPlugin;
import org.joget.plugin.base.PluginProperty;
import org.joget.workflow.model.WorkflowAssignment;
import com.lowagie.text.Document;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Map;
import org.joget.commons.util.SetupManager;
import org.joget.workflow.util.WorkflowUtil;

public class PdfPlugin extends DefaultPlugin implements ApplicationPlugin {

    public String getName() {
        return "PDF Plugin";
    }
    
    public String getVersion() {
        return "1.0.2";
    }

    public String getDescription() {
        return "generates PDF";
    }

    public PluginProperty[] getPluginProperties() {
        PluginProperty[] properties = new PluginProperty[] {
            new PluginProperty("formDataTable", "Form Data Table", PluginProperty.TYPE_TEXTFIELD, null, ""),
            new PluginProperty("content", "Content", PluginProperty.TYPE_TEXTAREA, null, null),
            new PluginProperty("baseDirectory", "Base Directory", PluginProperty.TYPE_TEXTFIELD, null, SetupManager.getBaseDirectory() + File.separator + "pdfPlugin"),
            new PluginProperty("outputFilename", "Output Filename", PluginProperty.TYPE_TEXTFIELD, null, "#assignment.processId#")
        };
        return properties;
    }

    public Object execute(Map properties) {
        Object result = null;
        try {
            String formDataTable    = (String) properties.get("formDataTable");
            String content          = (String) properties.get("content");
            String baseDirectory    = (String) properties.get("baseDirectory");
            String outputFilename  = (String) properties.get("outputFilename");

            if (baseDirectory == null || baseDirectory.trim().length() == 0) {
                baseDirectory = SetupManager.getBaseDirectory() + File.separator + "pdfPlugin";
            }
            if (outputFilename == null || outputFilename.trim().length() == 0) {
                outputFilename = "#assignment.processId#";
            }

            // update variables
            WorkflowAssignment wfAssignment = (WorkflowAssignment) properties.get("workflowAssignment");
            content = WorkflowUtil.processVariable(content, formDataTable, wfAssignment);
            baseDirectory = WorkflowUtil.processVariable(baseDirectory, formDataTable, wfAssignment);
            outputFilename = WorkflowUtil.processVariable(outputFilename, formDataTable, wfAssignment);
            if (!outputFilename.endsWith(content)) {
                outputFilename += ".pdf";
            }

            //generate pdf
            Document document = new Document();
            File outFile = null;
            try {
                new File(baseDirectory).mkdirs();
                outFile = new File(baseDirectory, outputFilename);
                PdfWriter.getInstance(document, new FileOutputStream(outFile));
                document.open();
                document.add(new Paragraph(content));
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                document.close();
            }

            return result;
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.WARNING, "Error executing plugin", e);
            return null;
        }
    }


}
