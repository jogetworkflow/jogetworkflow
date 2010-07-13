package org.joget.directory.model.dao.employmentreportto;

import org.joget.directory.model.EmploymentReportTo;

public interface EmploymentReportToDao {

    void addEmploymentReportTo(EmploymentReportTo employmentReportTo);

    void updateEmploymentReportTo(EmploymentReportTo employmentReportTo);

    void removeEmploymentReportTo(EmploymentReportTo employmentReportTo);

    boolean isEmploymentIdExist(String employmentId);

    EmploymentReportTo getEmploymentReportToByEmploymentId(String employmentId);
}
