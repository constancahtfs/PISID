package MongoToMongo;

public class SensorL2 {
    public static void main(String[] args) {
        try {
            while (true) {
                MongoCloudToMongoLocal.getSensorData("L2");
            }
        } catch (Exception e) {
            System.out.println("Problemas a tratar registos no sensor L2!");
        }
    }
}
