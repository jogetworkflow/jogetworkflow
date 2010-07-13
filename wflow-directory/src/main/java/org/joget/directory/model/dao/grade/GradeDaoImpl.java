package org.joget.directory.model.dao.grade;

import java.util.Collection;
import java.util.List;

import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.Grade;
import org.joget.directory.model.Organization;
import org.joget.directory.model.dao.organization.OrganizationDao;

public class GradeDaoImpl extends AbstractSpringDao implements GradeDao {

    private OrganizationDao organizationDao;

    public void addGrade(Grade grade) {
        save("Grade", grade);
    }

    public void updateGrade(Grade grade) {
        merge("Grade", grade);
    }

    public Collection<Grade> getGradeList(String nameFilter, String sort, Boolean desc, Integer start, Integer rows) {
        if (nameFilter == null) {
            nameFilter = "";
        }
        return find("Grade", "where e.name like ? or e.description like ?",
                new Object[]{"%" + nameFilter + "%", "%" + nameFilter + "%"}, sort, desc, start, rows);
    }

    public Long getTotalGradesByOrganizationId(String organizationId) {
        return count("Grade", "e join e.organization o where o.id=?", new Object[]{organizationId});
    }

    public Grade getGradeById(String gradeId) {
        return (Grade) find("Grade", gradeId);
    }

    public Grade getGradeByName(String gradeName) {
        Grade grade = new Grade();
        grade.setName(gradeName);
        List grades = findByExample("Grade", grade);
        if (grades.size() > 0) {
            return (Grade) grades.get(0);
        }
        return null;
    }

    public Collection<Grade> getGradeByOrganization(String organizationName, String sort, Boolean desc, Integer start, Integer rows) {
        return find("Grade", "join e.organization o where o.name=?", new Object[]{organizationName}, sort, desc, start, rows);
    }

    public void addGradeToOrganization(String gradeId, String organizationId) {
        Grade grade = getGradeById(gradeId);
        Organization organization = getOrganizationDao().getOrganizationById(organizationId);

        organization.getGrades().add(grade);
        saveOrUpdate("Organization", organization);
    }

    public void removeGradeFromOrganization(String gradeId, String organizationId) {
        Grade grade = getGradeById(gradeId);
        Organization organization = getOrganizationDao().getOrganizationById(organizationId);

        organization.getGrades().remove(grade);
        saveOrUpdate("Organization", organization);
    }

    public void deleteGrade(Grade grade) {
        delete("Grade", grade);
    }

    public OrganizationDao getOrganizationDao() {
        return organizationDao;
    }

    public void setOrganizationDao(OrganizationDao organizationDao) {
        this.organizationDao = organizationDao;
    }
}
