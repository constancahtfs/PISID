package MongoToMySQL;

import Databases.MongoLocal;
import Databases.MySQLLocal;
import Models.Measurement;
import Models.Sensor;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import org.bson.Document;

public class MongoLocalToMySQLLocal {

    public static void migrateData(Sensor sensor) {

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

        MongoCollection<Document> documents = mongodb.getSensorData(collectioName);

        System.out.println("Number of documents in collection " + collectioName + ": "+ documents.count());

        MongoCollection<Document> documents2 = mongodb.getSensorData(collectioName);

        System.out.println("Number of documents in collection " + collectioName + ": "+ documents2.count());

        FindIterable<Document> fi = documents.find();
        MongoCursor<Document> cursor = fi.iterator();
        try {
            while(cursor.hasNext()) {

                Document doc = cursor.next();

                try {
                    Measurement measurement = new Measurement(doc,sensorId, sensorType);
                    mysql.executeInsertMedicao(measurement);
                    mongodb.deleteSensorDocument(collectioName, doc);
                }
                catch(Exception ex){
                    System.out.println("Could not insert: " + doc.toJson());
                    System.out.println(ex.getMessage());
                }

            }
        } finally {
            cursor.close();
        }

        MongoCollection<Document> remainingDocs = mongodb.getSensorData(collectioName);

        System.out.println("Number of documents in collection after process " + collectioName + ": "+ remainingDocs.count());
    }
}
