package Databases;

import Errors.ERROR_SOURCE;
import Errors.ErrorHandling;
import Models.Measurement;
import Models.Sensor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MySQLLocal {

    private Connection conn;
    private static final String DB_USER = "software@java.pt"; //System.getenv("DB_USER_JAVA");
    private static final String DB_PASS = "software1234"; //System.getenv("DB_PASS_JAVA");
    private static final String DB_NAME = "estufa";

    public MySQLLocal() {
        conn = null;
        try {
            conn = DriverManager.getConnection(
                    //"jdbc:mysql://192.168.191.128:3306/" + DB_NAME +
                    "jdbc:mysql://localhost/" + DB_NAME +
                            "?noAccessToProcedureBodies=true" + // Does not need "SELECT" permission with this
                            "&user=" + DB_USER +
                            "&password=" + DB_PASS);
        }
        catch (Exception ex){
            System.out.println("Unable to connect to database MySQL Local.");
        }
    }

    public Connection getConn(){
        return conn;
    }


    public void executeInsertMedicoes(List<Measurement> measurements) throws Exception {

        try{

            String sql_query = "INSERT INTO medicao(IDMedicao, IDZona, IDSensor, TipoSensor, Valor, Datetime) VALUES ";
            ArrayList<String> values = new ArrayList<>();

            for(Measurement m : measurements){
                if(Double.parseDouble(m.getValue()) != 999.99){
                    values.add("(\'" + m.getId() + "\'," + m.getZoneId() + "," + m.getSensorId() + ",\'" + m.getSensorType() + "\'," + m.getValue() + ",\'" + m.getTimestamp() + "\')");
                }
            }

            String finalValues = String.join(",", values);

            sql_query = sql_query + finalValues + " ON DUPLICATE KEY UPDATE IDMedicao = IDMedicao;";

            CallableStatement cStmt = conn.prepareCall(sql_query);

            cStmt.execute();

            System.out.println("Inserted multiple values");

        }
        catch(Exception ex){
            ErrorHandling.formatError(ERROR_SOURCE.MYSQL_LOCAL, "Could not execute InsertMedicoes", ex);
        }

    }

    public boolean executeInsertMedicao(Measurement measurement) throws Exception {

        try{

            CallableStatement cStmt = conn.prepareCall("{call InserirMedicao(?, ?, ?, ?, ?, ?)}"); // Stored Procedure

            // Parameters
            cStmt.setString(1, measurement.getZoneId());
            cStmt.setString(2, measurement.getSensorId());
            cStmt.setString(3, measurement.getSensorType());
            cStmt.setString(4, measurement.getTimestamp());
            cStmt.setString(5, measurement.getValue());
            cStmt.setString(6, measurement.getId());


            cStmt.execute();

            System.out.println("Inserted one value");
            return true;

        }
        catch(Exception ex){
            ErrorHandling.formatError(ERROR_SOURCE.MYSQL_LOCAL, "Could not execute InsertMedicao for " + measurement.toJSON(), ex);
            return false;
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

        PreparedStatement stmt = conn.prepareStatement("select LIMITEINFERIOR, LIMITESUPERIOR from SENSOR where IDSENSOR=? and TIPOSENSOR=?");
        stmt.setString(1, sensor.getSensorId());
        stmt.setString(2, sensor.getSensorType());
        return stmt.executeQuery();
    }

    public void updateZona(String zona, String temp, String hum, String luz) throws Exception {
        if(conn == null)
            throw new Exception();

        PreparedStatement stmt = conn.prepareStatement("update ZONA set TEMPERATURA=?, HUMIDADE=?, LUZ=? where IDZONA=?");
        stmt.setString(1, temp);
        stmt.setString(2, hum);
        stmt.setString(3, luz);
        stmt.setString(4, zona);
        stmt.executeUpdate();
        System.out.println("Zona " + zona + " atualizada!");
    }

    public void updateSensor(String id, String tipo, String inf, String sup) throws Exception {
        if(conn == null)
            throw new Exception();

        PreparedStatement stmt = conn.prepareStatement("update SENSOR set LIMITEINFERIOR=?, LIMITESUPERIOR=? where IDSENSOR=? and TIPOSENSOR=?");
        stmt.setString(1, inf);
        stmt.setString(2, sup);
        stmt.setString(3, id);
        stmt.setString(4, tipo);
        stmt.executeUpdate();
        System.out.println("Sensor " + tipo + id + " atualizado!");
    }
}
