package MongoToMySQL;

import Models.Sensor;

public class SensorL2 extends Sensor {

    public static void main(String[] args){
        MongoLocalToMySQLLocal.migrateData(new SensorL2());
    }

    @Override
    public String getSensorName() {
        return "L2";
    }
}

