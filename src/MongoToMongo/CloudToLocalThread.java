package MongoToMongo;
import MongoToMongo.MongoCloudToMongoLocal;

public class CloudToLocalThread extends Thread {

    private String sensorID;
    private MongoCloudToMongoLocal runnable = new MongoCloudToMongoLocal(sensorID);

    public CloudToLocalThread(String sensorID) {
        this.sensorID = sensorID;
    }

    @Override
    public void run() {
        try {
            System.out.println("Estou dentro do Try!");
            while(true) {
                System.out.println("Estou dentro do while()!");
                runnable.getSensorData(sensorID);
            }
        } catch(Exception e) {
            System.out.println("Problema na thread do sensor " + sensorID);
        }
    }

    public static void main(String[] args) {
        CloudToLocalThread threadH1 = new CloudToLocalThread("H1");
        threadH1.start();
    }
}
