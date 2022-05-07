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

                        // Delete from MongoDB Local
                        mongodb.deleteSensorDocument(collectioName, doc);

                        // Validate measurement
                        Measurement measurement = new Measurement(doc, sensorId, sensorType);

                        if (firstTimeRunning)
                            measurements.add(measurement);
                        else
                            mysql.executeInsertMedicao(measurement);


                    } catch (Exception ignored) {

                    }
                }
            } finally {
                cursor.close();
            }

            // Remove outliers
            if(measurements.size() != 0){
                ProcessMeasurements pm = new ProcessMeasurements(measurements, 1.0);
                measurements = pm.removeOutliers();

                // Insert a bunch of measurements
                if(firstTimeRunning){
                    try{
                        mysql.executeInsertMedicoes(measurements);
                        firstTimeRunning = false;
                    }
                    catch (Exception ignored){

                    }

                }

            }



        }
    }
}