package MongoToMongo;


import Databases.MongoLocal;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import Databases.MongoCloud;
import java.io.File;
import java.io.FileWriter;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

public class MongoCloudToMongoLocal {

    private static final MongoCloud cloud = new MongoCloud();
    private static final MongoLocal local = new MongoLocal();


    public static void migrateData(String sensorID) {
        int countAdded = 0;
        int countOfDoubleID = 0;

        FindIterable<Document> collectionSensor = cloud.getMedicoesData(sensorID);
        MongoCursor<Document> cursor = collectionSensor.iterator();

        while(cursor.hasNext()) {
            Document doc = cursor.next();

            try {

                boolean success = local.insertSensorDocument("sensor"+sensorID, doc);

                if(success)
                    countAdded++;

            } catch(Exception e) {

                countOfDoubleID++;

                if(countOfDoubleID == 3) {
                    countOfDoubleID = 0;
                    //System.out.println("Não foi inserido, chave duplicada.");
                }
            }
        }

        int a = 0;
        //if(countAdded != 0)
            //System.out.println("No sensor " + sensorID + " foram adicionados " + countAdded + " registos.");

    }

}
