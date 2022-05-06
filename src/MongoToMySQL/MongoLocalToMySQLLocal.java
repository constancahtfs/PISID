package MongoToMySQL;

import Databases.MongoLocal;
import Databases.MySQLLocal;
import Models.Measurement;
import Models.Sensor;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
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

        if(mongodb == null)
            System.out.println("MongoDB is null");

        if(mysql == null)
            System.out.println("MySQL is null");

        if(mongodb == null || mysql == null){
            System.out.println("Terminating");
            return;
        }

        while(true) {

            MongoCollection<Document> documents = mongodb.getSensorData(collectioName);

            //System.out.println("Number of documents in collection " + collectioName + ": " + documents.count());

            List<Measurement> measurements = new ArrayList<Measurement>();
            FindIterable<Document> fi = null;


            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(timestamp.getTime());
            cal.add(Calendar.HOUR, -1);
            timestamp = new Timestamp(cal.getTime().getTime());
            String lastTimestamp = String.valueOf(timestamp);
            String[] timestampArr1 = lastTimestamp.split(" ");
            lastTimestamp = timestampArr1[0] + "T" + timestampArr1[1] + "Z";

            fi = documents.find(gt("Data", lastTimestamp));




            int processed = 0;
            int skipped = 0;

            MongoCursor<Document> cursor = fi.iterator();

            try {
                while (cursor.hasNext()) {

                    Document doc = cursor.next();
                    processed++;

                    try {
                        mongodb.deleteSensorDocument(collectioName, doc); // WARNING: DEPOIS VER ISTO

                        Measurement measurement = new Measurement(doc, sensorId, sensorType);

                        if (firstTimeRunning)
                            measurements.add(measurement);
                        else
                            mysql.executeInsertMedicao(measurement);



                    } catch (Exception ex) {
                        //System.out.println("Could not insert: " + doc.toJson());
                        //System.out.println(ex.getMessage());
                        skipped++;
                    }


                }
            } finally {
                cursor.close();
            }

            ProcessMeasurements aha = new ProcessMeasurements(measurements, 1.0);
            aha.removeOutliers();

            if(processed == 0) continue;

            if(firstTimeRunning){
                try {
                    mysql.executeInsertMedicoes(measurements);
                    firstTimeRunning = false;
                }
                catch(Exception ex) {
                    //System.out.println("╰（‵□′）╯ " + ex.getMessage());
                }
            }

            if(processed != 0 && skipped != 0)
                System.out.println("Inseriu " + processed + " registos");
        }
    }
}