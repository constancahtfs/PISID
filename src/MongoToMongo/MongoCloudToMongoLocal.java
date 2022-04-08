package MongoToMongo;


import Databases.MongoLocal;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import org.bson.Document;
import Databases.MongoCloud;
import org.bson.conversions.Bson;

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

        dbLocal.getCollection("sensorH1").insertOne((Document) getCollectionSensor("H1"));
        dbLocal.getCollection("sensorH2").insertOne((Document) getCollectionSensor("H2"));
        dbLocal.getCollection("sensorL1").insertOne((Document) getCollectionSensor("L1"));
        dbLocal.getCollection("sensorL2").insertOne((Document) getCollectionSensor("L2"));
        dbLocal.getCollection("sensorT1").insertOne((Document) getCollectionSensor("T1"));
        dbLocal.getCollection("sensorT2").insertOne((Document) getCollectionSensor("T2"));
    }

    /*
    Por testar, em princípio devia ir buscar à cloud, e pôr num documento, a coleção respetiva
    de cada um dos sensores.
     */
    public static MongoCollection<Document> getCollectionSensor(String sensor) {
        MongoCollection<Document> collectionSensor;
        Bson filter = Filters.text(sensor);
        collectionSensor = (MongoCollection<Document>) collectionCloud.find(filter);
        return collectionSensor;
    }


    public static void main(String[] args){
        migrateData();
    }

}
