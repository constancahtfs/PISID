package Databases;

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
            data = db.getCollection("medicoes2022").find(and(eq("Sensor", sensor), gt("Data", lastTimestamp)));
        }
        else {


           /* lastTimestamp = String.valueOf(new Timestamp(System.currentTimeMillis()));
            String[] timestampArr1 = lastTimestamp.split(" ");
            lastTimestamp = timestampArr1[0] + "T" + timestampArr1[1] + "Z";
            Instant aa = Instant.parse(lastTimestamp);*/

            Timestamp timestamp = new Timestamp(System.currentTimeMillis());
            Calendar cal = Calendar.getInstance();
            cal.setTimeInMillis(timestamp.getTime());
            cal.add(Calendar.MINUTE, -2);
            timestamp = new Timestamp(cal.getTime().getTime());
            lastTimestamp = String.valueOf(timestamp);
            String[] timestampArr1 = lastTimestamp.split(" ");
            lastTimestamp = timestampArr1[0] + "T" + timestampArr1[1] + "Z";


            data = db.getCollection("medicoes2022").find(and(eq("Sensor", sensor), gt("Data", lastTimestamp)));
            //.sort(Sorts.descending("Data"));
            System.out.println("Não tem ultimo timestamp");

            /*
            Document lastDoc = data.first();
            String[] Data = lastDoc.toString().split("=");
            String[] Time = Data[4].split(",");
            String timestamp = Time[0];
            */

        }

        String timestamp = new Timestamp(System.currentTimeMillis()).toString();
        String[] timestampArr = timestamp.split(" ");
        timestamp = timestampArr[0] + "T" + timestampArr[1] + "Z";

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
            //System.out.println("Timestamp atualizado!");
        } catch (Exception e) {
            System.out.println("Something went wrong with the timestamp file!");
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

    private static String formatTimeStamp(String timestamp){
        Instant instant = Instant.parse(timestamp);
        DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                .withZone(ZoneId.systemDefault());
        return DATE_TIME_FORMATTER.format(instant);
    }


    public MongoDatabase getDatabase()  {
        return db;
    }

}
