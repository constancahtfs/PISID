package MongoToMongo;


import Databases.MongoLocal;
import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import Databases.MongoCloud;
import java.io.File;
import java.io.FileWriter;
import java.nio.file.Paths;
import java.sql.Timestamp;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Scanner;

public class MongoCloudToMongoLocal {

    /*
    Isto são com dados reais.

    private static final MongoCloud cloud = new MongoCloud();
    private static final MongoCollection<Document> collectionCloud = cloud.getMedicoesData();
    */

    //Estufa Cloud de teste
    private static final MongoClient mongoClient = new MongoClient("localhost",27017);
    private static final MongoDatabase dbCloud = mongoClient.getDatabase("estufa_cloud_server_test");
    private static final MongoCollection<Document> collectionCloud = dbCloud.getCollection("medicoes");

    private static final MongoLocal local = new MongoLocal();
    private static final MongoDatabase dbLocal = local.getDatabase();

    private static String sensorToPullFrom;

    public MongoCloudToMongoLocal(String sensorToPullFrom){
        this.sensorToPullFrom = sensorToPullFrom;
    }

    /*
    A funcionar, ainda por adicionar mecanismo de verificação de timestamp.
    Não pára por duplicados (try/catch).
    Vai buscar da DB Cloud e adiciona na DB Local.
    Nota: Só funciona se as coleções tiverem o mesmo nome na DB Local, i.e., para o sensor H1,
    deve ter "sensorH1" na DB Local, etc.
     */
    public static void getSensorData(String sensorID) {
        int countAdded = 0;
        System.out.println();
        FindIterable<Document> collectionSensor;
        collectionSensor = collectionCloud.find();
        MongoCursor<Document> cursor = collectionSensor.iterator();
        String timestamp = ""; //Para fazer update sobre o timestamp no ficheiro.
        //for(int i = 0; cursor.hasNext() && i < 30000; i++) {
        while(cursor.hasNext()) {
            Document doc = cursor.next();
            String[] Data = doc.toString().split("=");
            String[] Time = Data[4].split(",");
            timestamp = Time[0];
            try {
                if(doc.containsValue(sensorID) && verifyTimestamp(timestamp, sensorID)) {
                    dbLocal.getCollection("sensor"+sensorID).insertOne(doc);
                    countAdded++;
                    //System.out.println("Foi inserido um registo.");
                }
            } catch(Exception e) {
                System.out.println("Não foi inserido, chave duplicada.");
            }
        }
        createTimestampFile(timestamp,sensorID);
        if(countAdded != 0)
            System.out.println("No sensor " + sensorID + " foram adicionados " + countAdded + " registos.");
        countAdded = 0;
    }

    /*
    Cria e/ou faz o update do ficheiro específico de cada sensor que mantém atualizado o último momento
    de registo na base de dados do mesmo.
     */
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

    /*
    Verifica e valida, ou não, o timestamp do ficheiro criado anteriormente para o respetivo sensor.
    Usado na função getSensorData().

    NOTA: CRIAR FICHEIRO NO CATCH
     */
    public static boolean verifyTimestamp(String timestamp, String sensorID) {

        String lastTimestamp = "";
        String userDirectory = Paths.get("").toAbsolutePath().toString();
        File lastTimestampTxt = null;
        Scanner scanner = null;

        try {
            lastTimestampTxt = new File(userDirectory + "\\src\\MongoToMongo\\last_timestamp" + sensorID + ".txt");
            scanner = new Scanner(lastTimestampTxt);
        } catch (Exception e){
            createTimestampFile(timestamp, sensorID);
            System.out.println("Não existe ficheiro; a criar.");
        }

        try {

            lastTimestampTxt = new File(userDirectory + "\\src\\MongoToMongo\\last_timestamp" + sensorID + ".txt");
            scanner = new Scanner(lastTimestampTxt);


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

        //migrateData();
        //getSensorData("H1");
    }

}
