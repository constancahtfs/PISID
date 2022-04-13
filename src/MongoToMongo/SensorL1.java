package MongoToMongo;

public class SensorL1 {
    public static void main(String[] args) {
        try {
            while (true) {
                MongoCloudToMongoLocal.getSensorData("L1");
            }
        } catch (Exception e) {
            System.out.println("Problemas a tratar registos no sensor L1!");
        }
    }
}
