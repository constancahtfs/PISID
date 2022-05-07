package MongoToMongo;

public class SensorH2 {
    public static void main(String[] args) {
        try {
            while (true) {
                MongoCloudToMongoLocal.migrateData("H2");
            }
        } catch (Exception e) {
            System.out.println("Problemas a tratar registos no sensor H2!");
        }
    }
}
