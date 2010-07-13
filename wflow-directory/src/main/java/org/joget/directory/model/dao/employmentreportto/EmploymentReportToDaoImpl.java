package org.joget.directory.model.dao.employmentreportto;

import java.util.Collection;
import org.joget.commons.spring.model.AbstractSpringDao;
import org.joget.directory.model.EmploymentReportTo;

public class EmploymentReportToDaoImpl extends AbstractSpringDao implements EmploymentReportToDao {

    public void addEmploymentReportTo(EmploymentReportTo employmentReportTo) {
        save("EmploymentReportTo", employmentReportTo);
    }

    public void updateEmploymentReportTo(EmploymentReportTo employmentReportTo) {
        merge("EmploymentReportTo", employmentReportTo);
    }

    public void removeEmploymentReportTo(EmploymentReportTo employmentReportTo) {
        delete("EmploymentReportTo", employmentReportTo);
    }

    public boolean isEmploymentIdExist(String employmentId) {
        Collection employmentReportTos = find("EmploymentReportTo", "where e.subordinate.id=?", new Object[]{employmentId}, null, null, null, null);
        
        if (employmentReportTos != null && employmentReportTos.size() > 0 && !employmentReportTos.isEmpty()) {
            return true;
        } else {
            return false;
        }
    }

    public EmploymentReportTo getEmploymentReportToByEmploymentId(String employmentId) {
        Collection employmentReportTo = find("EmploymentReportTo", "where e.subordinate.id=?", new Object[]{employmentId}, null, null, null, null);
        
        if (employmentReportTo != null && employmentReportTo.size() > 0 && !employmentReportTo.isEmpty()) {
            return (EmploymentReportTo) employmentReportTo.iterator().next();
        } else {
            return null;
        }
    }
}
