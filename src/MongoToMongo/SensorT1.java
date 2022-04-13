package MongoToMongo;

public class SensorT1 {
    public static void main(String[] args) {
        try {
            while (true) {
                MongoCloudToMongoLocal.getSensorData("T1");
            }
        } catch (Exception e) {
            System.out.println("Problemas a tratar registos no sensor T1!");
        }
    }
}
