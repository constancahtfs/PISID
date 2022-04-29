package MongoToMySQL;

import Models.Sensor;

public class SensorT1 extends Sensor {

    public static void main(String[] args) throws InterruptedException {
        MongoLocalToMySQLLocal.migrateData(new SensorT1());
    }

    @Override
    public String getSensorName() {
        return "T1";
    }
}
