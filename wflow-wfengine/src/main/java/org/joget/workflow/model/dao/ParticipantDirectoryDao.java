package org.joget.workflow.model.dao;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.workflow.model.ParticipantDirectory;
import java.io.Serializable;
import java.util.Collection;
import java.util.List;

public class ParticipantDirectoryDao extends AbstractSpringDao {
    public static final String SEPARATOR                  = ",";
    public static final String DELIMINATOR                = "|";
    public static final String TYPE_USER                  = "USER";
    public static final String TYPE_GROUP                 = "GROUP";
    public static final String TYPE_REQUESTER             = "REQUESTER";
    public static final String TYPE_REQUESTER_HOD         = "REQUESTER_HOD";
    public static final String TYPE_REQUESTER_SUBORDINATE = "REQUESTER_SUBORDINATE";
    public static final String TYPE_REQUESTER_DEPARTMENT  = "REQUESTER_DEPARTMENT";
    public static final String TYPE_DEPARTMENT            = "DEPARTMENT";
    public static final String TYPE_DEPARTMENT_HOD        = "DEPARTMENT_HOD";
    public static final String TYPE_DEPARTMENT_GRADE      = "DEPARTMENT_GRADE";
    public static final String TYPE_GRADE                 = "GRADE";
    public static final String TYPE_WORKFLOW_VARIABLE     = "VAR_";
    public static final String TYPE_PLUGIN                = "PLUGIN";
    
    public static final String ENTITY_NAME = "ParticipantDirectory";

    public Collection<ParticipantDirectory> getParticipantDirectoryByPackageId(String packageId){
        String condition = "WHERE packageId = ?";
        String[] params = {packageId};
        return super.find(ENTITY_NAME, condition, params, null, null, 0, 1000);
    }

    public Collection<ParticipantDirectory> getParticipantDirectoryByPackageId(String packageId, Integer version){
        String condition = "WHERE packageId=? AND version=?";
        Object[] params = {packageId, version};
        return super.find(ENTITY_NAME, condition, params, null, null, 0, 1000);
    }

    public Long count(String condition, Object[] params) {
        return super.count(ENTITY_NAME, condition, params);
    }

    public void delete(ParticipantDirectory obj) {
        super.delete(ENTITY_NAME, obj);
    }

    public ParticipantDirectory find(String id) {
        return (ParticipantDirectory) super.find(ENTITY_NAME, id);
    }

    public Collection<ParticipantDirectory> find(String condition, Object[] params, String sort, Boolean desc, Integer start, Integer rows) {
        return super.find(ENTITY_NAME, condition, params, sort, desc, start, rows);
    }

    public List<ParticipantDirectory> findAll() {
        return super.findAll(ENTITY_NAME);
    }

    public List<ParticipantDirectory> findByExample(ParticipantDirectory ParticipantDirectory) {
        return super.findByExample(ENTITY_NAME, ParticipantDirectory);
    }

    public Serializable save(ParticipantDirectory obj) {
        return super.save(ENTITY_NAME, obj);
    }

    public void saveOrUpdate(ParticipantDirectory obj) {
        super.saveOrUpdate(ENTITY_NAME, obj);
    }
    
    public Collection<ParticipantDirectory> getMappingByParticipantId(String packageId, String processId, Integer version, String participantId) {
        Collection<ParticipantDirectory> result = null;

        ParticipantDirectory example = new ParticipantDirectory();
        example.setPackageId(packageId);
        
        if(processId != null){
            example.setProcessId(processId);
        }
        
        example.setVersion(version);
        example.setParticipantId(participantId);

        result = findByExample(example);

        if(result != null && result.size() != 0){
            return result;
        }else{
            example.setProcessId(null);
            return findByExample(example);
        }
    }

    public String setAsParticipant(String type, String value, String packageId, String processId, Integer version, String participantId){
        ParticipantDirectory participantDirectory = new ParticipantDirectory();
        participantDirectory.setPackageId(packageId);
        participantDirectory.setProcessId(processId);
        participantDirectory.setVersion(version);
        participantDirectory.setParticipantId(participantId);
        participantDirectory.setType(type);
        participantDirectory.setValue(value);
        return (String) save(participantDirectory);
    }
    
    public String setUserAsParticipant(String[] users, String packageId, String processId, Integer version, String participantId) {
        String usersString = "";
        for (String user : users) {
            usersString += user + SEPARATOR;
        }
        //remove last SEPARATOR from usersString
        usersString = usersString.substring(0, usersString.length() - 1);

        return setAsParticipant(TYPE_USER, usersString, packageId, processId, version, participantId);
    }

    public String setGroupAsParticipant(String[] groups, String packageId, String processId, Integer version, String participantId) {
        String groupsString = "";
        for (String group : groups) {
            groupsString += group + SEPARATOR;
        }
        //remove last SEPARATOR from usersString
        groupsString = groupsString.substring(0, groupsString.length() - 1);

        return setAsParticipant(TYPE_GROUP, groupsString, packageId, processId, version, participantId);
    }

    public String setRequesterAsParticipant(String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER, null, packageId, processId, version, participantId);
    }

    public String setRequesterHodAsParticipant(String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER_HOD, null, packageId, processId, version, participantId);
    }
    
    public String setRequesterSubordinateAsParticipant(String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER_SUBORDINATE, null, packageId, processId, version, participantId);
    }
    
    public String setRequesterDepartmentAsParticipant(String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER_DEPARTMENT, null, packageId, processId, version, participantId);
    }

    public String setActivityPerformerAsParticipant(String activity, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER, activity, packageId, processId, version, participantId);
    }

    public String setActivityPerformerHodAsParticipant(String activity, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER_HOD, activity, packageId, processId, version, participantId);
    }

    public String setActivityPerformerSubordinateAsParticipant(String activity, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER_SUBORDINATE, activity, packageId, processId, version, participantId);
    }

    public String setActivityPerformerDepartmentAsParticipant(String activity, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_REQUESTER_DEPARTMENT, activity, packageId, processId, version, participantId);
    }
    
    public String setDepartmentAsParticipant(String department, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_DEPARTMENT, department, packageId, processId, version, participantId);
    }
    
    public String setDepartmentHodAsParticipant(String departmentHod, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_DEPARTMENT_HOD, departmentHod, packageId, processId, version, participantId);
    }
    
    public String setDepartmentGradeAsParticipant(String department, String grade, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_DEPARTMENT_GRADE, department + DELIMINATOR + grade, packageId, processId, version, participantId);
    }

    public String setWorkflowVariableAsParticipant(String workflowVariable, String workflowVariableType, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_WORKFLOW_VARIABLE + workflowVariableType.toUpperCase(), workflowVariable, packageId, processId, version, participantId);
    }
    
    public String setPluginAsParticipant(String plugin, String packageId, String processId, Integer version, String participantId) {
        return setAsParticipant(TYPE_PLUGIN, plugin, packageId, processId, version, participantId);
    }
    
    public Collection<ParticipantDirectory> getMappings(String packageId, String processId, Integer version, String participantId){
        if(processId != null){
            return super.find(ENTITY_NAME, "WHERE e.packageId = ? AND e.processId = ? AND e.version = ? AND e.participantId = ?", new Object[]{packageId, processId, version, participantId}, null, null, null, null);
        }else{
            return super.find(ENTITY_NAME, "WHERE e.packageId = ? AND e.version = ? AND e.participantId = ?", new Object[]{packageId, version, participantId}, null, null, null, null);
        }
    }
    
    public void removeMapping(String id){
        super.delete(ENTITY_NAME, find(id));
    }
}
