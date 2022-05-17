package MongoToMySQL;

import Databases.MongoLocal;
import Databases.MySQLLocal;
import Models.Measurement;
import Models.Sensor;
import Utils.Dates;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;
import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.gt;

public class MongoLocalToMySQLLocal {
    private static double lastMeasurement;

    public static boolean isNotOutlier(Measurement m, double difference){
        double value = m.getValueDouble();

        return (Math.abs(value - lastMeasurement) <= difference);
    }

    public static void migrateData(Sensor sensor) {

        boolean firstTimeRunning = true;

        String sensorId = sensor.getSensorId();
        String sensorType =  sensor.getSensorType();
        String collectioName = "sensor" + sensor.getSensorName();

        MongoLocal mongodb = new MongoLocal();
        MySQLLocal mysql = new MySQLLocal();

        boolean terminating = false;

        if(mongodb == null || mongodb.getDatabase() == null)
            terminating = true;

        if(mysql == null || mysql.getConn() == null)
            terminating = true;

        if(terminating) {
            System.out.println("Terminating");
            return;
        }

        while(true) {

            MongoCollection<Document> documents = mongodb.getSensorData(collectioName);
            List<Measurement> measurements = new ArrayList<Measurement>();
            FindIterable<Document> fi = null;


            String lastTimestamp = Dates.getOneHourPastTimestamp();
            fi = documents.find(gt("Data", lastTimestamp));


            MongoCursor<Document> cursor = fi.iterator();

            try {
                while (cursor.hasNext()) {

                    Document doc = cursor.next();

                    try {

                        // Validate measurement
                        Measurement measurement = new Measurement(doc, sensorId, sensorType);

                        if (firstTimeRunning){
                            measurements.add(measurement);
                            // Delete from MongoDB Local
                            mongodb.deleteSensorDocument(collectioName, doc);
                        }else if(isNotOutlier(measurement, 1.5)){
                            mysql.executeInsertMedicao(measurement);
                            // Delete from MongoDB Local
                            mongodb.deleteSensorDocument(collectioName, doc);
                            lastMeasurement = measurement.getValueDouble();
                        }

                    } catch (Exception ignored) {

                    }
                }
            } finally {
                cursor.close();
            }

            // Remove outliers
            if(measurements.size() != 0){
                ProcessMeasurements pm = new ProcessMeasurements(measurements, 1.5);
                measurements = pm.removeOutliers();

                // Insert a bunch of measurements
                if(firstTimeRunning){
                    try{
                        mysql.executeInsertMedicoes(measurements);
                        lastMeasurement = measurements.get(measurements.size() - 1).getValueDouble();
                        firstTimeRunning = false;
                        measurements.clear();
                    }
                    catch (Exception ignored){

                    }

                }

            }



        }
    }
}