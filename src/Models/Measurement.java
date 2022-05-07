package Models;

import Errors.ERROR_SOURCE;
import Errors.ErrorHandling;
import org.bson.Document;

import java.util.HashMap;
import java.util.Map;

public class Measurement {

    private String id;
    private String zoneId;
    private String sensorId;
    private String sensorType;
    private String timestamp;
    private String value;

     public Measurement(Document doc, String sensorId, String sensorType) throws Exception {

         try {
             String id = doc.get("_id").toString();
             String zoneId = String.valueOf(((String) doc.get("Zona")).toCharArray()[1]);
             String timestamp = (String) doc.get("Data");
             double value = Double.parseDouble((String) doc.get("Medicao"));

             if (value >= 1000.0)
                 value = 999.99;

             timestamp = timestamp.replace("T", " ");
             timestamp = timestamp.replace("Z", "");

             this.zoneId = zoneId;
             this.sensorId = sensorId;
             this.sensorType = sensorType;
             this.timestamp = timestamp;
             this.value = String.valueOf(value);
             this.id = id;
         }
         catch(Exception ex){
             ErrorHandling.formatError(ERROR_SOURCE.MEASUREMENT_OBJECT, doc.toJson(), ex);
         }

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

    public String toJSON(){
        return ("id: " + getId() + " value: " + getValue() + " sensorId: " + getSensorId() + " sensorType: " + getSensorType() + " timestamp: " + getTimestamp());
    }

}
