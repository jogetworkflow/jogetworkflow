package org.joget.directory.model.dao.grade;

import java.util.Collection;

import org.joget.directory.model.Grade;

public interface GradeDao {

    void addGrade(Grade grade);

    void updateGrade(Grade grade);

    Collection<Grade> getGradeList(String nameFilter, String sort,
            Boolean desc, Integer start, Integer rows);

    Long getTotalGradesByOrganizationId(String organizationId);

    Grade getGradeById(String gradeId);

    Grade getGradeByName(String gradeName);

    Collection<Grade> getGradeByOrganization(String organizationName,
            String sort, Boolean desc, Integer start, Integer rows);

    void deleteGrade(Grade grade);

    void addGradeToOrganization(String gradeId, String organizationId);

    void removeGradeFromOrganization(String gradeId, String organizationId);
}
