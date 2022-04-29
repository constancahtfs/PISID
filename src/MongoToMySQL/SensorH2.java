package MongoToMySQL;

import Models.Sensor;

public class SensorH2 extends Sensor {

    public static void main(String[] args) throws InterruptedException {
        MongoLocalToMySQLLocal.migrateData(new SensorH2());
    }

    @Override
    public String getSensorName() {
        return "H2";
    }
}
