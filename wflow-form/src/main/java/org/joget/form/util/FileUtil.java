package org.joget.form.util;

import org.joget.commons.util.LogUtil;
import org.joget.commons.util.SetupManager;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.multipart.MultipartFile;

public class FileUtil implements ApplicationContextAware {
    static ApplicationContext appContext;

    public static ApplicationContext getApplicationContext() {
        return appContext;
    }

    public static void storeFile(MultipartFile file, String procInstanceId){
        try{
            String path = getUploadPath(procInstanceId);

            //create directories if not exist
            new File(path).mkdirs();

            File uploadFile = new File(path + file.getOriginalFilename());
            FileOutputStream out = new FileOutputStream(uploadFile);
            out.write(file.getBytes());
            out.close();
        }catch(Exception ex){
            LogUtil.error(FileUtil.class.getName(), ex, "");
        }
    }

    
    public static File getFile(String fileName, String procInstanceId) throws IOException {
        String path = getUploadPath(procInstanceId);
        return new File(path + fileName);
    }
    
    public static String getUploadPath(String procInstanceId){
        String formUploadPath = SetupManager.getBaseDirectory();

        SetupManager setupManager = (SetupManager) appContext.getBean("setupManager");
        String dataFileBasePath = setupManager.getSettingValue("dataFileBasePath");
        if(dataFileBasePath != null && dataFileBasePath.length() > 0){
            formUploadPath =  dataFileBasePath;
        }
        
        return formUploadPath + File.separator + "formuploads" + File.separator + procInstanceId + File.separator;
    }

    public void setApplicationContext(ApplicationContext appContext) throws BeansException {
        this.appContext = appContext;
    }
}
