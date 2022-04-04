package Databases;

import Models.Measurement;

import java.sql.*;

public class MySQL {

    private Connection conn;
    private static final String DB_USER = System.getenv("DB_USER_JAVA");
    private static final String DB_PASS = System.getenv("DB_PASS_JAVA");
    private static final String DB_NAME = "estufa";

    public MySQL() throws SQLException {
        conn = DriverManager.getConnection(
                "jdbc:mysql://localhost/" + DB_NAME +
                        "?noAccessToProcedureBodies=true" + // Does not need "SELECT" permission with this
                        "&user=" +              DB_USER +
                        "&password=" +          DB_PASS);
    }

    public void executeInsertMedicao(Measurement measurement) throws SQLException {

        CallableStatement cStmt = conn.prepareCall("{call InsertMedicao.sql(?, ?, ?, ?, ?)}"); // Stored Procedure

        // Parameters
        cStmt.setString(1, measurement.getZoneId());
        cStmt.setString(2, measurement.getSensorId());
        cStmt.setString(3, measurement.getSensorType());
        cStmt.setString(4, measurement.getTimestamp());
        cStmt.setString(5, measurement.getValue());

        cStmt.execute();
    }

}
