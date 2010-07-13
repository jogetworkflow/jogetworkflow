package org.joget.form.util;

import java.sql.Types;
import org.hibernate.dialect.MySQLDialect;

public class MySqlDialect extends MySQLDialect{
    public MySqlDialect(){
        super();
        super.registerColumnType( Types.LONGVARCHAR, 65535, "text" );
        super.registerHibernateType( Types.LONGVARCHAR, 65535, "text" );
    }
}
