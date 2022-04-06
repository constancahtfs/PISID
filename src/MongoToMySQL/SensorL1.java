package MongoToMySQL;

public class SensorL1 extends Sensor{

    public static void main(String[] args){
        new SensorL1().migrateData();
    }

    @Override
    public String getSensorName() {
        return "L1";
    }
}

