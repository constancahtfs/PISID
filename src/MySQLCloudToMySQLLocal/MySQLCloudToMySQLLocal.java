package MySQLCloudToMySQLLocal;

import Databases.MySQLCloud;
import Databases.MySQLLocal;
import Models.Sensor;
import MongoToMySQL.*;
import java.sql.ResultSet;
import java.util.ArrayList;


public class MySQLCloudToMySQLLocal {

    private static MySQLLocal local;
    private static MySQLCloud cloud;

    public static void makeConnections(){
        local = new MySQLLocal();
        cloud = new MySQLCloud();
    }

    public static boolean compareZona(int zona) throws Exception {
        boolean flag = false;
        ResultSet zonaLocal = local.getValoresZona(Integer.toString(zona));
        ResultSet zonaCloud = cloud.getValoresZona(Integer.toString(zona));
        String[] tipos = {"TEMPERATURA", "HUMIDADE", "LUZ"};
        float[] valores = new float[3];

        zonaLocal.next();
        zonaCloud.next();
        for(int i = 0; i < 3; i++){
            if(zonaLocal.getFloat(tipos[i]) != zonaCloud.getFloat(tipos[i])) {
                flag = true;
            }
            valores[i] = zonaCloud.getFloat(tipos[i]);
        }
        if(flag){
            local.updateZona(Integer.toString(zona), Float.toString(valores[0]), Float.toString(valores[1]), Float.toString(valores[2]));
        }
        return flag;
    }

    public static boolean compareSensor(Sensor sensor) throws Exception {
        boolean flag = false;
        ResultSet sensorLocal = local.getValoresSensor(sensor);
        ResultSet sensorCloud = cloud.getValoresSensor(sensor);
        String[] limites = {"LIMITEINFERIOR", "LIMITESUPERIOR"};
        float[] valores = new float[2];

        sensorLocal.next();
        sensorCloud.next();
        for(int i = 0; i < 2; i++){
            if(sensorLocal.getFloat(limites[i]) != sensorCloud.getFloat(limites[i])) {
                flag = true;
            }
            valores[i] = sensorCloud.getFloat(limites[i]);
        }
        if(flag){
            local.updateSensor(sensor.getSensorId(), sensor.getSensorType(), Float.toString(valores[0]), Float.toString(valores[1]));
        }
        return flag;
    }

    public static void migrateParameters() throws Exception {

        int migratedZona = 0;
        int migratedSensor = 0;

        makeConnections();

        if (local == null)
            System.out.println("MySQLLocal is null");

        if (cloud == null)
            System.out.println("MySQLCloud is null");

        if (local == null || cloud == null) {
            System.out.println("Terminating");
            return;
        }

        for(int i = 1; i < 3; i++){
            if(compareZona(i)){
                migratedZona++;
            }
        }

        if(migratedZona != 0){
            System.out.println("Valores das Zonas atualizados com sucesso!");
        }else{
            System.out.println("Valores das Zonas sem alterações!");
        }

        ArrayList<Sensor> sensores = new ArrayList<>();
        sensores.add(new SensorH1());
        sensores.add(new SensorH2());
        sensores.add(new SensorL1());
        sensores.add(new SensorL2());
        sensores.add(new SensorT1());
        sensores.add(new SensorT2());

        for(int i = 0; i < 6; i++){
            if(compareSensor(sensores.get(i))){
                migratedSensor++;
            }
        }

        if(migratedSensor != 0){
            System.out.println("Valores dos Sensores atualizados com sucesso!");
        }else{
            System.out.println("Valores dos Sensores sem alterações!");
        }
    }

    public static void main(String[] args) throws Exception {
        migrateParameters();
    }

}
