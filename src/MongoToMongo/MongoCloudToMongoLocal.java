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

    public static void migrateData() {
        // Ir constantemente buscar dados ao mongo da cloud (Usar a classe MongoCloud)
        // Pensar numa forma de ir buscar dados não repetidos (guardar ultimo timestamp 'buscado'
        // num ficheiro por exemplo - eu adicionei o ficheiro a esta pasta)

        getSensorData("H1");
        getSensorData("H2");
        getSensorData("T1");
        getSensorData("T2");
        getSensorData("L1");
        getSensorData("L2");

    }

    /*
    A funcionar, ainda por adicionar mecanismo de verificação de timestamp.
    Não pára por duplicados (try/catch).
    Vai buscar da DB Cloud e adiciona na DB Local.
    Nota: Só funciona se as coleções tiverem o mesmo nome na DB Local, i.e., para o sensor H1,
    deve ter "sensorH1" na DB Local, etc.
     */
    public static void getSensorData(String sensor) {
        FindIterable<Document> collectionSensor;
        collectionSensor = collectionCloud.find();
        MongoCursor<Document> cursor = collectionSensor.iterator();
        for(int i = 0; cursor.hasNext() && i < 2000; i++) {
            Document doc = cursor.next();
            String Data[] = doc.toString().split("=");
            String ObjectID[] = Data[1].split(",");
            //if(doc.containsValue(sensor) && !dbLocal.getCollection("sensor"+sensor).equals(ObjectID[0])) {
            try {
                if(doc.containsValue(sensor)) {
                    dbLocal.getCollection("sensor"+sensor).insertOne(doc);
                    System.out.println("Foi inserido um registo.");
                }
            } catch(Exception e) {
                System.out.println("Não foi inserido, chave duplicada.");
            }
        }
    }


    public static void main(String[] args){
        migrateData();
    }

}
