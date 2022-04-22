package Databases;

import Models.Sensor;

import java.sql.*;

public class MySQLCloud {

    private Connection conn;
    private static final String DB_IP = "194.210.86.10";
    private static final String DB_USER = "aluno";
    private static final String DB_PASS = "aluno";
    private static final String DB_NAME = "sid2022";

    public MySQLCloud() {
        conn = null;
        try {
            conn = DriverManager.getConnection(
                    "jdbc:mysql://" + DB_IP + "/" + DB_NAME +
                            "?noAccessToProcedureBodies=true" + // Does not need "SELECT" permission with this
                            "&user=" + DB_USER +
                            "&password=" + DB_PASS);
        }
        catch (Exception ex){
            System.out.println("Unable to connect to database.");
        }
    }

    public ResultSet getValoresZona(String zona) throws Exception {
        if(conn == null)
            throw new Exception();

        PreparedStatement stmt = conn.prepareStatement("select TEMPERATURA, HUMIDADE, LUZ from ZONA where IDZONA=?");
        stmt.setString(1, zona);
        return stmt.executeQuery();
    }

    public ResultSet getValoresSensor(Sensor sensor) throws Exception {
        if(conn == null)
            throw new Exception();

        PreparedStatement stmt = conn.prepareStatement("select LIMITEINFERIOR, LIMITESUPERIOR from SENSOR where IDSENSOR=? and TIPO=?");
        stmt.setString(1, sensor.getSensorId());
        stmt.setString(2, sensor.getSensorType());
        return stmt.executeQuery();
    }
}
