package MongoToMySQL;

public class SensorH1 extends Sensor {

    public static void main(String[] args){
        new SensorH1().migrateData();
    }

    @Override
    public String getSensorName() {
        return "H1";
    }
}

