package MongoToMySQL;

import Models.Sensor;

public class SensorL1 extends Sensor {

    public static void main(String[] args) throws InterruptedException {
        MongoLocalToMySQLLocal.migrateData(new SensorL1());;
    }

    @Override
    public String getSensorName() {
        return "L1";
    }
}

