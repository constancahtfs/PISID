package MongoToMySQL;

public class SensorL2 extends Sensor{

    public static void main(String[] args){
        new SensorL2().migrateData();
    }

    @Override
    public String getSensorName() {
        return "L2";
    }
}

