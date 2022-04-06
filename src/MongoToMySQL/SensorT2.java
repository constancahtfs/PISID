package MongoToMySQL;

public class SensorT2 extends Sensor{

    public static void main(String[] args){
        new SensorT2().migrateData();
    }

    @Override
    public String getSensorName() {
        return "T2";
    }
}
