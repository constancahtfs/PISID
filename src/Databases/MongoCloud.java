package Databases;

import Utils.Dates;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Sorts;
import org.bson.Document;

import java.io.File;
import java.io.FileWriter;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Calendar;
import java.util.Date;
import java.util.Scanner;

import static com.mongodb.client.model.Filters.*;
import static com.mongodb.client.model.Sorts.descending;

public class MongoCloud {

    private static final String CONNECTION_STRING = "mongodb://aluno:aluno@194.210.86.10/?authSource=admin&authMechanism=SCRAM-SHA-1";
    private MongoDatabase db;

    public MongoCloud(){
        MongoClientURI uri = new MongoClientURI(CONNECTION_STRING);
        MongoClient mongoClient = new MongoClient(uri);
        db = mongoClient.getDatabase("sid2022");
    }

    public FindIterable<Document> getMedicoesData(String sensor){

        String lastTimestamp = getLastRetrievedTimestamp(sensor);
        FindIterable<Document> data = null;

        if(lastTimestamp != null){
            data = db.getCollection("medicoes2022").find(and(eq("Sensor", sensor))).sort(descending("Data")).limit(10);
        }
        else {

            System.out.println("Does not have timestamp file");

            lastTimestamp = Dates.getOneHourPastTimestamp();
            data = db.getCollection("medicoes2022").find(and(eq("Sensor", sensor))).sort(descending("Data")).limit(3600);


        }

        String timestamp = Dates.getNowTimestamp();
        createTimestampFile(timestamp, sensor);

        return data;
    }


    public static void createTimestampFile(String timestamp, String sensorID){
        String userDirectory = Paths.get("").toAbsolutePath().toString();
        try{

            File timestampTXT = new File(userDirectory + "\\src\\MongoToMongo\\last_timestamp" + sensorID + ".txt");
            FileWriter fr = new FileWriter(timestampTXT,false);
            fr.write(timestamp);
            fr.close();

        } catch (Exception e) {
            System.out.println("Could not create the timestamp file.");
        }
    }

    private static String getLastRetrievedTimestamp(String sensor){
        String lastTimestamp = null;
        String userDirectory = Paths.get("").toAbsolutePath().toString();
        File lastTimestampTxt = null;
        Scanner scanner = null;

        try {
            lastTimestampTxt = new File(userDirectory + "\\src\\MongoToMongo\\last_timestamp" + sensor + ".txt");
            scanner = new Scanner(lastTimestampTxt);
        } catch (Exception e){
            return null;
        }

        try {
            String content = "";

            while(scanner.hasNextLine()){
                content = scanner.nextLine();
            }

            if(content == "")
                return null;


            return content;


        } catch (Exception e){
            System.out.println("Erro");
            return null;
        }

    }

}
