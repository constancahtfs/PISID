package MongoToMySQL;

import Databases.Mongo;
import Databases.MySQL;
import Models.Measurement;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.sql.SQLException;

abstract class Sensor {

    public abstract String getSensorName();

    private String getSensorId(){
        String sensor = getSensorName();
        char[] sensorSplit = sensor.toCharArray();
        return String.valueOf(sensorSplit[1]);
    }
    private String getSensorType(){
        String sensor = getSensorName();
        char[] sensorSplit = sensor.toCharArray();
        return String.valueOf(sensorSplit[0]);
    }

    public void migrateData() {

        String sensorId = getSensorId();
        String sensorType =  getSensorType();
        String name = "sensor" + getSensorName();

        Mongo mongodb = new Mongo();
        MySQL mysql = new MySQL();

        if(mongodb == null)
            System.out.println("MongoDB is null");

        if(mysql == null)
            System.out.println("MySQL is null");

        if(mongodb == null || mysql == null){
            System.out.println("Terminating");
            return;
        }

        MongoDatabase estufaDb = mongodb.getEstufaDatabase();

        MongoCollection<Document> documents = mongodb.getSensorData(estufaDb,name);

        System.out.println("Number of documents in collection " + name + ": "+ documents.count());

        FindIterable<Document> fi = documents.find();
        MongoCursor<Document> cursor = fi.iterator();
        try {
            while(cursor.hasNext()) {

                Document doc = cursor.next();

                try {
                    Measurement measurement = new Measurement(doc,sensorId, sensorType);
                    mysql.executeInsertMedicao(measurement);
                    mongodb.deleteSensorDocument(estufaDb,name, doc);
                }
                catch(Exception ex){
                    System.out.println("Could not insert: " + doc.toJson());
                    System.out.println(ex.getMessage());
                }

            }
        } finally {
            cursor.close();
        }

        MongoCollection<Document> remainingDocs = mongodb.getSensorData(estufaDb,"sensorL1");

        System.out.println("Number of documents in collection after process " + name + ": "+ remainingDocs.count());
    }
}