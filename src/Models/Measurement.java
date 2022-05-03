package Models;

import org.bson.Document;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

public class Measurement {

    private String id;
    private String zoneId;
    private String sensorId;
    private String sensorType;
    private String timestamp;
    private String value;

     public Measurement(Document doc, String sensorId, String sensorType) throws Exception {

         String id = doc.get("_id").toString();
         String zoneId = String.valueOf(((String) doc.get("Zona")).toCharArray()[1]);
         String timestamp = (String) doc.get("Data");
         double value = Double.parseDouble((String) doc.get("Medicao"));

         //value = Math.round(value);

         if (value >= 1000.0)
             value = 999.99;

         timestamp = timestamp.replace("T", " ");
         timestamp = timestamp.replace("Z", "");

         this.zoneId = zoneId;
         this.sensorId = sensorId;
         this.sensorType = sensorType;
         //this.timestamp = formatTimeStamp(timestamp);
         this.timestamp = timestamp;
         this.value = String.valueOf(value);
         this.id = id;

     }

    public String getValue() {
        return value;
    }

    public double getValueDouble() {
        return Double.parseDouble(value);
    }

    public String getSensorId() {
        return sensorId;
    }

    public String getSensorType() {
        return sensorType;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public String getZoneId() {
        return zoneId;
    }

    public String getId() {
        return id;
    }


    // ref: https://stackoverflow.com/questions/25229124/unsupportedtemporaltypeexception-when-formatting-instant-to-string
    private String formatTimeStamp(String timestamp){
         try{
             timestamp = timestamp.replace("T", " ");
             timestamp = timestamp.replace("Z", "");
             Instant instant = Instant.parse(timestamp);

             DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                     .withZone(ZoneId.systemDefault());
             return DATE_TIME_FORMATTER.format(instant);
         }
         catch(Exception ex){
             int oi = 1;
         }
       return null;
    }

}
