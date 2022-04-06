package MongoToMySQL;

public class SensorT1 extends Sensor{

    public static void main(String[] args){
        new SensorT1().migrateData();
    }

    @Override
    public String getSensorName() {
        return "T1";
    }
}
