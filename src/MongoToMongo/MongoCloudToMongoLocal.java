package MongoToMongo;


import Databases.MongoLocal;
import Models.Measurement;
import com.mongodb.*;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import Databases.MongoCloud;
import org.bson.conversions.Bson;

import java.util.ArrayList;
import java.util.List;

public class MongoCloudToMongoLocal {

    private String timestamp = null;

    private static MongoCloud cloud = new MongoCloud();
    private static MongoCollection<Document> collectionCloud = cloud.getMedicoesData();
    private MongoDatabase dbCloud = cloud.getDatabase();

    private static MongoLocal local = new MongoLocal();
    private static MongoDatabase dbLocal = local.getDatabase();

    /*
    Por testar, não implementado o processo de verificar se já existe na DB Local.
    */
    public static void migrateData() {
        // Ir constantemente buscar dados ao mongo da cloud (Usar a classe MongoCloud)
        // Pensar numa forma de ir buscar dados não repetidos (guardar ultimo timestamp 'buscado'
        // num ficheiro por exemplo - eu adicionei o ficheiro a esta pasta)

        //dbLocal.getCollection("sensorH1").insertMany(getCollectionSensor("H1"));
        //System.out.println("kwodpjkdoewpkfewp");
        //dbLocal.getCollection("sensorH2").insertOne((Document) getCollectionSensor("H2"));
        //dbLocal.getCollection("sensorL1").insertOne((Document) getCollectionSensor("L1"));
        //dbLocal.getCollection("sensorL2").insertOne((Document) getCollectionSensor("L2"));
        //dbLocal.getCollection("sensorT1").insertOne((Document) getCollectionSensor("T1"));
        //dbLocal.getCollection("sensorT2").insertOne((Document) getCollectionSensor("T2"));

        getSensorData("H1");


    }

    /*
    Por testar, em princípio devia ir buscar à cloud, e pôr num documento, a coleção respetiva
    de cada um dos sensores.
     */
    public static List<Document> getCollectionSensor(String sensor) {
        List<Document> collection = new ArrayList<Document>();
        FindIterable<Document> collectionSensor;
        //Bson filter = Filters.text(sensor);
        collectionSensor = collectionCloud.find();
        MongoCursor<Document> cursor = collectionSensor.iterator();
        int i = 0;
        while(cursor.hasNext() && i < 2000) {



            Document doc = cursor.next();
            System.out.println(doc);

            if(doc.get("Sensor") == sensor) {
                collection.add(doc);

            }

            i++;


        }
        return collection;
    }

    public static void getSensorData(String sensor) {
        FindIterable<Document> collectionSensor;
        collectionSensor = collectionCloud.find();
        MongoCursor<Document> cursor = collectionSensor.iterator();
        for(int i = 0; cursor.hasNext() && i < 2000; i++) {
            Document doc = cursor.next();
            String Data[] = doc.toString().split("=");
            String ObjectID[] = Data[1].split(",");
            if(doc.containsValue(sensor) && !dbLocal.getCollection("sensor"+sensor).equals(ObjectID[0])) {
                dbLocal.getCollection("sensor"+sensor).insertOne(doc);
            }
        }
    }


    public static void main(String[] args){
        migrateData();
    }

}
