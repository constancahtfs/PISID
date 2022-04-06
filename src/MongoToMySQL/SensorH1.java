package MongoToMySQL;

import Models.Sensor;

public class SensorH1 extends Sensor {

    public static void main(String[] args){
        MongoLocalToMySQLLocal.migrateData(new SensorH1());
    }

    @Override
    public String getSensorName() {
        return "H1";
    }
}

