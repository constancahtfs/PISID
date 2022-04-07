package Databases;

import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class MongoCloud {

    private static final String CONNECTION_STRING = "mongodb://aluno:aluno@194.210.86.10/?authSource=admin&authMechanism=SCRAM-SHA-1";
    private MongoDatabase db;

    public MongoCloud(){
        MongoClientURI uri = new MongoClientURI(CONNECTION_STRING);
        MongoClient mongoClient = new MongoClient(uri);
        db = mongoClient.getDatabase("sid2022");
    }

    public MongoCollection<Document> getMedicoesData(){
        MongoCollection<Document> collection = db.getCollection("medicoes");
        return collection;
    }

    public MongoDatabase getDatabase()  {
        return db;
    }

}
