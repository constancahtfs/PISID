package MongoToMySQL;

import Models.Sensor;

public class SensorT2 extends Sensor {

    public static void main(String[] args) throws InterruptedException {
        MongoLocalToMySQLLocal.migrateData(new SensorT2());
    }

    @Override
    public String getSensorName() {
        return "T2";
    }
}
