package MongoToMySQL;

public class SensorH2 extends Sensor{

    public static void main(String[] args){
        new SensorH2().migrateData();
    }

    @Override
    public String getSensorName() {
        return "H2";
    }
}
