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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

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
        String timestamp = ""; //Para fazer update sobre o timestamp no ficheiro.
        for(int i = 0; cursor.hasNext() && i < 10; i++) {
            Document doc = cursor.next();
            String Data[] = doc.toString().split("=");
            String ObjectID[] = Data[1].split(",");
            String Time[] = Data[4].split(",");
            timestamp = Time[0];
            try {
                if(doc.containsValue(sensor) && verifyTimestamp(timestamp)) {
                    dbLocal.getCollection("sensor"+sensor).insertOne(doc);
                    System.out.println("Foi inserido um registo.");
                }
            } catch(Exception e) {
                System.out.println("Não foi inserido, chave duplicada.");
            }
        }
        createTimestampFile(timestamp);
    }

    /*
    Cria e/ou faz o update do ficheiro que mantém atualizado o último momento
    de registo na base de dados.
     */
    public static void createTimestampFile(String timestamp){
        String userDirectory = Paths.get("").toAbsolutePath().toString();
        try{
            File timestampTXT = new File(userDirectory + "\\src\\MongoToMongo\\last_timestamp.txt");
            FileWriter fr = new FileWriter(timestampTXT,false);
            fr.write(timestamp);
            fr.close();
            System.out.println("Timestamp atualizado!");
        } catch (Exception e) {
            System.out.println("Something went wrong with the timestamp file!");
        }
    }

    /*
    Verifica e valida, ou não, o timestamp do ficheiro criado anteriormente.
    Usado na função getSensorData
     */
    public static boolean verifyTimestamp(String timestamp) {

        String lastTimestamp = "";
        String userDirectory = Paths.get("").toAbsolutePath().toString();

        try {

            File lastTimestampTxt = new File(userDirectory + "\\src\\MongoToMongo\\last_timestamp.txt");
            Scanner scanner = new Scanner(lastTimestampTxt);

            while(scanner.hasNextLine()){
                lastTimestamp = scanner.nextLine();
            }
            timestamp = formatTimeStamp(timestamp);
            lastTimestamp = formatTimeStamp(lastTimestamp);

            Timestamp ts1 = Timestamp.valueOf(timestamp);
            Timestamp ts2 = Timestamp.valueOf(lastTimestamp);

            int result = ts1.compareTo(ts2);

            if(result == 0) {
                //System.out.println("Tempos iguais, não inserido.");
                return false;
            }
            else if(result > 0) {
                //System.out.println("Registo recente, inserido.");
                return true;
            }
            else {
                //System.out.println("Registo antigo, não inserido.");
                return false;
            }

        } catch (Exception e) {
            System.out.println("Problema em verificar o timestamp!");
        }
        return false; //PERGUNTAR NÃO SABEMOS
    }

    //Copiado de Models/Measurements
    private static String formatTimeStamp(String timestamp){
        Instant instant = Instant.parse(timestamp);
        DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                .withZone(ZoneId.systemDefault());
        return DATE_TIME_FORMATTER.format(instant);
    }

    public static void main(String[] args) {
        migrateData();
    }

}
