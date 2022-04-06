package Models;

public abstract class Sensor {

    public abstract String getSensorName();

    public String getSensorId(){
        String sensor = getSensorName();
        char[] sensorSplit = sensor.toCharArray();
        return String.valueOf(sensorSplit[1]);
    }
    public String getSensorType(){
        String sensor = getSensorName();
        char[] sensorSplit = sensor.toCharArray();
        return String.valueOf(sensorSplit[0]);
    }

}