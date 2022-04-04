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

public class SensorL1 {

    public static void main(String[] args) throws SQLException {
        Mongo mongodb = new Mongo();
        MongoDatabase estufaDb = mongodb.getEstufaDatabase();
        MySQL mysql = new MySQL();

        MongoCollection<Document> documents = mongodb.getSensorData(estufaDb,"sensorL1");

        System.out.println("Number of documents in collection \"sensorL1\": "+ documents.count());

        FindIterable<Document> fi = documents.find();
        MongoCursor<Document> cursor = fi.iterator();
        try {
            while(cursor.hasNext()) {

                Document doc = cursor.next();

                try {
                    Measurement measurement = new Measurement(doc,"1", "L");
                    mysql.executeInsertMedicao(measurement);
                    mongodb.deleteSensorDocument(estufaDb,"sensorL1", doc);
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

        System.out.println("Number of documents in collection after process \"sensorL1\": "+ remainingDocs.count());
    }
}
