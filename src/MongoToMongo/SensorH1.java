package MongoToMongo;

public class SensorH1 {
    public static void main(String[] args) {
        try {
            while (true) {
                MongoCloudToMongoLocal.getSensorData("H1");
            }
        } catch (Exception e) {
            System.out.println("Problemas a tratar registos no sensor H1!");
        }
    }
}
