package Databases;

import Models.Measurement;

import java.sql.*;

public class MySQLLocal {

    private Connection conn;
    private static final String DB_USER = System.getenv("DB_USER_JAVA");
    private static final String DB_PASS = System.getenv("DB_PASS_JAVA");
    private static final String DB_NAME = "estufa";

    public MySQLLocal() {
        conn = null;
        try {
            conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost/" + DB_NAME +
                            "?noAccessToProcedureBodies=true" + // Does not need "SELECT" permission with this
                            "&user=" + DB_USER +
                            "&password=" + DB_PASS);
        }
        catch (Exception ex){
            System.out.println("Unable to connect to database. Did you create the environment variables?");
        }
    }

    public void executeInsertMedicao(Measurement measurement) {

        if(conn == null)
            return;

        try {

            CallableStatement cStmt = conn.prepareCall("{call InsertMedicao.sql(?, ?, ?, ?, ?)}"); // Stored Procedure

            // Parameters
            cStmt.setString(1, measurement.getZoneId());
            cStmt.setString(2, measurement.getSensorId());
            cStmt.setString(3, measurement.getSensorType());
            cStmt.setString(4, measurement.getTimestamp());
            cStmt.setString(5, measurement.getValue());

            cStmt.execute();
        }
        catch (Exception ex){
            System.out.println("Could not call stored procedure InsertMedicao");
        }
    }

}
