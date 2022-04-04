package Models;

import org.bson.Document;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

public class Measurement {

    private String zoneId;
    private String sensorId;
    private String sensorType;
    private String timestamp;
    private String value;

     public Measurement(Document doc, String sensorId, String sensorType) throws Exception {

         String zoneId = String.valueOf(((String) doc.get("Zona")).toCharArray()[1]);
         String timestamp = (String) doc.get("Data");
         double value = (double) doc.get("Medicao");

         this.zoneId = zoneId;
         this.sensorId = sensorId;
         this.sensorType = sensorType;
         this.timestamp = formatTimeStamp(timestamp);
         this.value = String.valueOf(value);
     }

    public String getValue() {
        return value;
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

    // ref: https://stackoverflow.com/questions/25229124/unsupportedtemporaltypeexception-when-formatting-instant-to-string
    private String formatTimeStamp(String timestamp){
        Instant instant = Instant.parse(timestamp);
        DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")
                .withZone(ZoneId.systemDefault());
        return DATE_TIME_FORMATTER.format(instant);
    }

}
