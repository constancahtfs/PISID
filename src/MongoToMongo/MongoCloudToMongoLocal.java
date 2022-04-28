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

    /*
    Isto são com dados reais.
    */
    private static final MongoCloud cloud = new MongoCloud();
    //private static final MongoCollection<Document> collectionCloud = cloud.getMedicoesData();


    //Estufa Cloud de teste
    /*
    private static final MongoClient mongoClient = new MongoClient("localhost",27017);
    private static final MongoDatabase dbCloud = mongoClient.getDatabase("estufa_cloud_server_test");
    private static final MongoCollection<Document> collectionCloud = dbCloud.getCollection("medicoes");
     */
    //End

    private static final MongoLocal local = new MongoLocal();
    private static final MongoDatabase dbLocal = local.getDatabase();

    private static String sensorToPullFrom;

    public MongoCloudToMongoLocal(String sensorToPullFrom){
        this.sensorToPullFrom = sensorToPullFrom;
    }

    /*
    A funcionar, ainda por adicionar mecanismo de verificação de timestamp.
    Não pára por duplicados (try/catch).
    Vai buscar da DB Cloud e adiciona na DB Local.
    Nota: Só funciona se as coleções tiverem o mesmo nome na DB Local, i.e., para o sensor H1,
    deve ter "sensorH1" na DB Local, etc.
     */
    public static void getSensorData(String sensorID) {
        int countAdded = 0;
        int countOfDoubleID = 0;

        FindIterable<Document> collectionSensor = cloud.getMedicoesData(sensorID);
        MongoCursor<Document> cursor = collectionSensor.iterator();

        while(cursor.hasNext()) {
            Document doc = cursor.next();

            try {

                dbLocal.getCollection("sensor"+sensorID).insertOne(doc);
                countAdded++;

            } catch(Exception e) {

                countOfDoubleID++;
                if(countOfDoubleID == 3) {
                    countOfDoubleID = 0;
                    System.out.println("Não foi inserido, chave duplicada.");
                }
            }
        }

        if(countAdded != 0)
            System.out.println("No sensor " + sensorID + " foram adicionados " + countAdded + " registos.");

    }


    public static void main(String[] args) {

        //migrateData();
        //getSensorData("H1");
    }

}
