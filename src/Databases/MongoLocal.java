package Databases;

import Errors.ERROR_SOURCE;
import Errors.ErrorHandling;
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
        db = null;
        try {
            MongoClient mongoClient = new MongoClient(MongoLocal.HOST, MongoLocal.PORT);
            db = mongoClient.getDatabase("estufa");
        }
        catch(Exception ex){
            System.out.println("Unable to connect to database MongoDB Local.");
        }
    }

    public MongoCollection<Document> getSensorData(String collectionName){

        MongoCollection<Document> collection = db.getCollection(collectionName);
        return collection;
    }

    public void deleteSensorDocument(String collectionName, Document doc){

        try{
            MongoCollection<Document> collection = db.getCollection(collectionName);
            DeleteResult deleteResult = collection.deleteMany(doc);
        }
        catch(Exception ex){
            ErrorHandling.formatError(ERROR_SOURCE.MONGO_LOCAL, "Could not delete document " + doc.toJson(), ex);
        }
    }

    public boolean insertSensorDocument(String collectionName, Document doc){

        try{
            db.getCollection(collectionName).insertOne(doc);
            return true;
        }
        catch(Exception ex){
            ErrorHandling.formatError(ERROR_SOURCE.MONGO_LOCAL, "Could not insert document " + doc.toJson(), ex);
            return false;
        }
    }

    public MongoDatabase getDatabase() {
        return db;
    }

}
