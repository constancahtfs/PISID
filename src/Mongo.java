import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.result.DeleteResult;
import org.bson.Document;

public class Mongo {

    private static final String HOST = "localhost";
    private static final int PORT = 27017;

    public MongoDatabase getEstufaDatabase(){
        MongoClient mongoClient = new MongoClient(Mongo.HOST, Mongo.PORT);
        return mongoClient.getDatabase("estufa");
    }

    public MongoCollection<Document> getSensorData(MongoDatabase database, String sensor){
        MongoCollection<Document> collection = database.getCollection(sensor);
        return collection;
    }

    public void deleteSensorDocument(MongoDatabase database, String sensor, Document doc){
        MongoCollection<Document> collection = database.getCollection(sensor);
        DeleteResult deleteResult = collection.deleteMany(doc);
    }






}
