package MongoToMySQL;

import Databases.MongoCloud;
import Databases.MongoLocal;
import Databases.MySQLLocal;
import Models.Measurement;
import Models.Sensor;
import Utils.Dates;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

import java.io.File;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Sorts.descending;

public class MongoLocalToMySQLLocal {
    private static double lastMeasurement;

    public static boolean isNotOutlier(Measurement m, double difference){
        double value = m.getValueDouble();

        return (Math.abs(value - lastMeasurement) <= difference);
    }

    public static void migrateData(Sensor sensor) {



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

        boolean firstTimeRunning = true;

        /*
        String userDirectory = Paths.get("").toAbsolutePath().toString();
        File f = new File(userDirectory + "\\src\\MongoToMongo\\last_timestamp" + sensor.getSensorName() + ".txt");
        if(f.exists()) firstTimeRunning = true;
*/

        while(true) {

            MongoCollection<Document> documents = mongodb.getSensorData(collectioName);
            List<Measurement> measurements = new ArrayList<Measurement>();
            List<Document> docsDelete = new ArrayList<Document>();
            FindIterable<Document> fi = null;


            String lastTimestamp = Dates.getOneHourPastTimestamp();
            fi = documents.find().sort(descending("Data")).limit(3600);

            MongoCursor<Document> cursor = fi.iterator();

            try {
                while (cursor.hasNext()) {

                    Document doc = cursor.next();

                    try {

                        // Validate measurement
                        Measurement measurement = new Measurement(doc, sensorId, sensorType);
                        if(firstTimeRunning){
                            docsDelete.add(doc);
                        }

                        if (firstTimeRunning){
                            measurements.add(measurement);
                        }else if(isNotOutlier(measurement, 0.5)){
                            if(mysql.executeInsertMedicao(measurement)){
                                // Delete from MongoDB Local
                                lastMeasurement = measurement.getValueDouble();
                            }
                            mongodb.deleteSensorDocument(collectioName, doc);
                        }
                        else if (!isNotOutlier(measurement, 0.5)){

                            mongodb.deleteSensorDocument(collectioName, doc);
                            System.out.println("Apagou outlier  " + measurement.getValueDouble() + " com last " + lastMeasurement);

                            /*
                            if (lastMeasurement > measurement.getValueDouble()) {
                                lastMeasurement = measurement.getValueDouble();
                                System.out.println("LM atualizado para " + lastMeasurement);
                            }
                            *
                             */

                        }


                    } catch (Exception ignored) {

                    }
                }
            } finally {
                cursor.close();
            }

            // Remove outliers
            if(measurements.size() != 0){
                ProcessMeasurements pm = new ProcessMeasurements(measurements, 0.5);
                measurements = pm.removeOutliers();

                // Insert a bunch of measurements
                if(firstTimeRunning){
                    try{
                        mysql.executeInsertMedicoes(measurements);
                        lastMeasurement = measurements.get(0).getValueDouble();
                        for(int i = 0; i < docsDelete.size(); i++){
                            mongodb.deleteSensorDocument(collectioName, docsDelete.get(i));
                        }
                        firstTimeRunning = false;
                        measurements.clear();
                        docsDelete.clear();
                    }
                    catch (Exception ignored){

                    }

                }

            }
        }
    }
}