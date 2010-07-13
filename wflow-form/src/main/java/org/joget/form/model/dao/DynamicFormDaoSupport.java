package org.joget.form.model.dao;

import org.joget.form.model.Form;
import org.joget.form.util.FormUtil;
import org.joget.form.util.XMLUtil;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import org.hibernate.HibernateException;
import org.hibernate.MappingException;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.mapping.Column;
import org.hibernate.mapping.Component;
import org.hibernate.mapping.PersistentClass;
import org.hibernate.mapping.Property;
import org.hibernate.mapping.SimpleValue;
import org.hibernate.type.Type;
import org.joget.commons.util.SetupManager;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public abstract class DynamicFormDaoSupport extends HibernateDaoSupport {

    public static final String FORM_ID_PREFIX = "Form_";
    public static final String FORM_METADATA_ID_PREFIX = "FormMetaData_";
    public static final String FORM_METADATA_DYNAMIC_FORM_COLUMN = "dynamicFormId";

    private FormDao dao;
    
    public FormDao getDao() {
        return dao;
    }

    public void setDao(FormDao dao) {
        this.dao = dao;
    }
    
    public SessionFactory loadCustomSessionFactory() { 
        // to be injected using lookup-method by Spring 
        return null;
    }
    
    Map<String, HibernateTemplate> templateMap = new HashMap<String, HibernateTemplate>();

    protected HibernateTemplate getHibernateTemplate(String formTableName) {
        String path = SetupManager.getBaseDirectory();
        if(!path.endsWith(File.separator)){
            path += File.separator;
        }
        
        path += "forms";

        //get existing mapping file
        String filename = "Form_" + formTableName + ".hbm.xml"; 
        File mappingFile = new File(path, filename);
        
        //if not exists, generate a new template
        if(!mappingFile.exists()){
            return generateHibernateTemplate(formTableName); 
        }
        
        //get existing mapping fields
        Configuration configuration = new Configuration().configure();
        configuration.addFile(mappingFile);
        PersistentClass pc = configuration.getClassMapping("Form_" + formTableName);
        Property custom = pc.getProperty("customProperties");
        Component customComponent = (Component) custom.getValue();
        Iterator i = customComponent.getPropertyIterator();
        
        List<String> newFormFields = getUniqueFormFields(formTableName);
        
        //check for difference
        boolean different = false;
        for(String field : newFormFields){
            boolean found = false;
            while(i.hasNext()){
                Property property = (Property) i.next();
                if(field.equalsIgnoreCase(property.getName())){
                    found = true;
                    break;
                }
            }
            
            if(!found){
                different = true;
                break;
            }
        }
        
        //if different, generate a new template
        if(!different){
            HibernateTemplate template = templateMap.get(formTableName);
            if (template == null) {
                template = generateHibernateTemplate(formTableName);
            }
            return template;
        }else{
            return generateHibernateTemplate(formTableName);
        }
    }

    protected HibernateTemplate generateHibernateTemplate(String formTableName) {
        
        try {
            // check for and remove existing
            HibernateTemplate template = templateMap.get(formTableName);
            if (template != null) {
                SessionFactory factory = template.getSessionFactory();
                factory.close();
                templateMap.remove(formTableName);
            }

            // load default class mapping
            setCurrentFormTableName(formTableName);
            
            HibernateTemplate ht = new HibernateTemplate(loadCustomSessionFactory());

            // set into maps
            templateMap.put(formTableName, ht);

            return ht;
        }
        catch(Exception e) {
            throw new RuntimeException("Error generating HibernateTemplate: " + e.toString(), e);
        }
    }

    ThreadLocal threadFormTableName = new ThreadLocal();
    
    public String getCurrentFormTableName() {
        String formTableName = (String)threadFormTableName.get();
        return formTableName;
    }
    
    public void setCurrentFormTableName(String formTableName) {
        threadFormTableName.set(formTableName);
    }
    
    public Configuration customizeConfiguration(Configuration config) throws DOMException, HibernateException, ParserConfigurationException, SAXException, IOException, MappingException, TransformerException {
        if(getDao() == null){
            return null;
        }
        
        Configuration configuration = new Configuration().configure();
        configuration.addClass(Form.class);
        PersistentClass pc = configuration.getClassMapping("Form");
        Property custom = pc.getProperty("customProperties");
        Component customComponent = (Component) custom.getValue();
        InputStream is = Form.class.getResourceAsStream("Form.hbm.xml");
        Document document = XMLUtil.loadDocument(is);

        // set entity name for form
        String formTableName = getCurrentFormTableName();
        pc.setEntityName(formTableName);

        // TODO: add custom fields here, to read from definition?
        List<String> formFields = getUniqueFormFields(formTableName);
        
        for(String field : formFields){
            SimpleValue simpleValue = new SimpleValue();
            simpleValue.addColumn(new Column(field));

            if(field.equals("created") || field.equals("modified")){
                simpleValue.setTypeName("timestamp");
            }else if(field.equals("refCount")){
                simpleValue.setTypeName("integer");
            }else{
                simpleValue.setTypeName("text");
            }
            
            Property property = new Property();
            property.setName(field);
            property.setValue(simpleValue);
            customComponent.addProperty(property);
        }
        
        // update entity-name
        NodeList classTags = document.getElementsByTagName("class");
        Node classNode = classTags.item(0);
        NamedNodeMap attributeMap = classNode.getAttributes();
        Node entityName = attributeMap.getNamedItem("entity-name");
        entityName.setNodeValue("Form_" + formTableName);
        attributeMap.setNamedItem(entityName);

        // update table name
        Node tableName = attributeMap.getNamedItem("table");
        tableName.setNodeValue("formdata_" + formTableName);
        attributeMap.setNamedItem(tableName);

        // remove existing dynamic components
        NodeList componentTags = document.getElementsByTagName("dynamic-component");
        Node node = componentTags.item(0);
        XMLUtil.removeChildren(node);
        
        // remove 'name', 'data', 'tableName', 'created', 'modified'
        componentTags = document.getElementsByTagName("property");
        for(int i=0; i<componentTags.getLength(); i++){
            Node propertyNode = componentTags.item(i);
            Node parentNode = propertyNode.getParentNode();
            parentNode.removeChild(propertyNode);
            i--;
        }
        
        // remove 'category'
        componentTags = document.getElementsByTagName("many-to-one");
        for(int i=0; i<componentTags.getLength(); i++){
            Node propertyNode = componentTags.item(i);
            Node parentNode = propertyNode.getParentNode();
            parentNode.removeChild(propertyNode);
            i--;
        }

        // add dynamic components
        Iterator propertyIterator = customComponent.getPropertyIterator();
        while (propertyIterator.hasNext()) {
            Property prop = (Property) propertyIterator.next();
            Element element = document.createElement("property");
            Type type = prop.getType();
            String propName = prop.getName();
            String propType = "";
            if (type.getReturnedClass().getName().equals("java.lang.String")) {
                if (propName.startsWith(FormUtil.FIELD_PREFIX)) {
                    propType = "text";
                } else {
                    propType = "string";
                }
            } else {
                propType = type.getReturnedClass().getName();
            }
            element.setAttribute("name", prop.getName());
            element.setAttribute("column", ((Column) prop.getColumnIterator().next()).getName());
            element.setAttribute("type", propType);
            element.setAttribute("not-null", String.valueOf(false));
            node.appendChild(element);
        }

        // save xml
        String newFilename = "Form_" + formTableName + ".hbm.xml";
        String path = SetupManager.getBaseDirectory();
        if(!path.endsWith(File.separator)){
            path += File.separator;
        }
        
        path += "forms";

        new File(path).mkdirs();

        File newFile = new File(path, newFilename);
        XMLUtil.saveDocument(document, newFile.getPath());
        config.addFile(newFile);

        File metaDataFile = new File(path, generateFormMetaDataConfiguration(formTableName));
        config.addFile(metaDataFile);

        return config;
    }

    public String generateFormMetaDataConfiguration(String formTableName) throws DOMException, HibernateException, ParserConfigurationException, SAXException, IOException, MappingException, TransformerException {
        InputStream is = Form.class.getResourceAsStream("FormMetaDataModal.hbm.xml");
        Document document = XMLUtil.loadDocument(is);

        // update entity-name
        NodeList classTags = document.getElementsByTagName("class");
        Node classNode = classTags.item(0);
        NamedNodeMap attributeMap = classNode.getAttributes();
        Node entityName = attributeMap.getNamedItem("entity-name");
        entityName.setNodeValue("FormMetaData_" + formTableName);
        attributeMap.setNamedItem(entityName);

        // update table name
        Node tableName = attributeMap.getNamedItem("table");
        tableName.setNodeValue("formdata_" + formTableName + "_metadata");
        attributeMap.setNamedItem(tableName);

        // update dynamic form entity-name
        classTags = document.getElementsByTagName("many-to-one");
        classNode = classTags.item(0);
        attributeMap = classNode.getAttributes();
        entityName = attributeMap.getNamedItem("entity-name");
        entityName.setNodeValue("Form_" + formTableName);
        attributeMap.setNamedItem(entityName);

        // save xml
        String newFilename = "FormMetaData_" + formTableName + ".hbm.xml";
        String path = SetupManager.getBaseDirectory();
        if(!path.endsWith(File.separator)){
            path += File.separator;
        }

        path += "forms";

        new File(path).mkdirs();

        File newFile = new File(path, newFilename);
        XMLUtil.saveDocument(document, newFile.getPath());

        return newFilename;
    }

    public List<String> getUniqueFormFields(String formTableName){
        //get all forms for the same table name
        Collection<Form> formList = getDao().getFormByTableName(formTableName);
        
        List<String> formFields = new ArrayList<String>();
        for(Form form : formList){
            formFields.addAll(FormUtil.getFormFields(form.getData()));
        }
        
        //get unique fields (case-insensitive)
        Set set = new HashSet(formFields);
        String[] unique = (String[]) (set.toArray(new String[set.size()]));
        formFields = new ArrayList<String>();
        for (String name : unique) {
            boolean found = false;
            for(String field : formFields){
                if(field.equalsIgnoreCase(name)){
                    found = true;
                    break;
                }
            }
            if(!found){
                formFields.add(name);
            }
        }

        
        //add additional fields
        formFields.add(0, "formId");
        formFields.add("processId");
        formFields.add("version");
        formFields.add("activityId");
        formFields.add("draft");
        formFields.add("modified");
        formFields.add("created");
        formFields.add("username");
        formFields.add("refCount");
        formFields.add("refName");
        return formFields;
    }
    
}
