package Databases;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.result.DeleteResult;
import org.bson.Document;

public class MongoLocal {

    private static final String HOST = "localhost";
    private static final int PORT = 27017;
    private MongoDatabase db;

    public MongoLocal(){
        MongoClient mongoClient = new MongoClient(MongoLocal.HOST, MongoLocal.PORT);
        db = mongoClient.getDatabase("estufa");
    }

    public MongoCollection<Document> getSensorData(String collectionName){
        MongoCollection<Document> collection = db.getCollection(collectionName);
        return collection;
    }

    public void deleteSensorDocument(String collectionName, Document doc){
        MongoCollection<Document> collection = db.getCollection(collectionName);
        DeleteResult deleteResult = collection.deleteMany(doc);
    }

    public MongoDatabase getDatabase() {
        return db;
    }

}
