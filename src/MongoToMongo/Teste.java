package MongoToMongo;

import com.mongodb.*;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class Teste {

    public static void main(String[] args){

        MongoClientURI uri = new MongoClientURI("mongodb://aluno:aluno@194.210.86.10/?authSource=admin&authMechanism=SCRAM-SHA-1");
        MongoClient mongoClient = new MongoClient(uri);
        MongoDatabase a = mongoClient.getDatabase("sid2022");
        MongoCollection<Document> collection = a.getCollection("medicoes");
        System.out.println(collection.find().first());

    }

}
