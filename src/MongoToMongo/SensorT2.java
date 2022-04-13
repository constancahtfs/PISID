package MongoToMongo;

public class SensorT2 {
    public static void main(String[] args) {
        try {
            while (true) {
                MongoCloudToMongoLocal.getSensorData("T2");
            }
        } catch (Exception e) {
            System.out.println("Problemas a tratar registos no sensor T2!");
        }
    }
}
