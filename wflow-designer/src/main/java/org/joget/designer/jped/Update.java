package org.joget.designer.jped;

import org.joget.designer.Designer;
import java.awt.event.ActionEvent;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.JOptionPane;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.multipart.FilePart;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.apache.commons.httpclient.methods.multipart.StringPart;
import org.enhydra.jawe.ActionBase;
import org.enhydra.jawe.JaWEComponent;
import org.enhydra.jawe.JaWEManager;
import org.enhydra.jawe.ResourceManager;
import org.enhydra.jawe.base.controller.JaWEController;
import org.enhydra.jawe.base.xpdlvalidator.ValidationError;
import org.enhydra.shark.xpdl.elements.Package;

public class Update extends ActionBase {

    private String myName;

    public Update(JaWEComponent jawecomponent) {
        super(jawecomponent);
    }

    public Update(JaWEComponent jawecomponent, String name) {
        super(jawecomponent, name);
        this.myName = name;
    }

    @Override
    public void enableDisableAction() {
        setEnabled(Designer.UPDATE);
    }

    public void actionPerformed(ActionEvent e) {
        JaWEController jc = (JaWEController) jawecomponent;

        int updateStatus = JOptionPane.showConfirmDialog(null, ResourceManager.getLanguageDependentString("UpdateConfirm"));

        if (updateStatus == JOptionPane.YES_OPTION) {

            if (checkValidity(jc)) {
                HttpClient httpClient = new HttpClient();

                String packageId = JaWEManager.getInstance().getJaWEController().getMainPackageId();
                String url = Designer.URLPATH + "/web/json/workflow/package/update?packageId=" + packageId + "&j_username=" + Designer.USERNAME + "&hash=" + Designer.HASH;;

                PostMethod post = new PostMethod(url);
                try {

                    File file = saveTempFile();

                    Part[] parts = {
                        new StringPart("param_name", "value"),
                        new FilePart("packageXpdlUpdate", file)
                    };

                    post.setRequestEntity(new MultipartRequestEntity(parts, post.getParams()));

                    httpClient.executeMethod(post);

                    String jsonString = post.getResponseBodyAsString();

//                    String[] jsonArray = jsonString.substring(1, jsonString.length() - 1).replaceAll("\"", "").split(":");
//
//                    if (jsonArray[0].equals("status")) {
//                        if (jsonArray[1].equals("error")) {
//                            JOptionPane.showMessageDialog(null, ResourceManager.getLanguageDependentString("UpdatePackageError"));
//                        } else {
//                            JOptionPane.showMessageDialog(null, ResourceManager.getLanguageDependentString("UpdateSuccessful"));
//                            System.exit(0);
//                        }
//                    }

                    Pattern pattern = Pattern.compile("\"([^\"]{2,})\":\"([^\"]{2,})\"");
                    Matcher matcher = pattern.matcher(jsonString);

                    while (matcher.find()) {
                        if(matcher.group(1).equals("status") && matcher.group(2).equals("complete")){
                             JOptionPane.showMessageDialog(null, ResourceManager.getLanguageDependentString("DeploySuccessful"));
                             System.exit(0);
                        }else if(matcher.group(1).equals("status") && matcher.group(2).equals("error")){
                           JOptionPane.showMessageDialog(null, ResourceManager.getLanguageDependentString("UpdatePackageError"));
                        }else if(matcher.group(1).equals("errorMsg")){
                            JOptionPane.showMessageDialog(null,  matcher.group(2));
                        }
                    }

                    file.delete();

                } catch (Exception ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(null, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
                }

            } else {
                JOptionPane.showMessageDialog(null, ResourceManager.getLanguageDependentString("UpdateInvalidXpdl"), "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    protected boolean checkValidity(JaWEController jc) {
        boolean checkValidity = true;

        List checkValidityList = jc.checkValidity(jc.getMainPackage(), true);

        for (int i = 0; i < checkValidityList.size(); i++) {
            Object obj = checkValidityList.get(i);
            if (obj instanceof String) {
                String error = (String) obj;
                if (!error.equals(ResourceManager.getLanguageDependentString("ERROR_NO_ERROR"))) {
                    checkValidity = false;
                }
            } else {
                ValidationError error = (ValidationError) obj;
                if (!"WARNING".equals(error.getType())) {
                    checkValidity = false;
                }
            }
        }

        return checkValidity;
    }

    public File saveTempFile() throws IOException {
        JaWEController jc = JaWEManager.getInstance().getJaWEController();

        Package pkg = jc.getMainPackage();

        File file = File.createTempFile("wfxpdl", null);

        jc.savePackage(pkg.getId(), file.getAbsolutePath());

        return file;
    }
}
