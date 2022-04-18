package Models;

public abstract class Sensor {

    public abstract String getSensorName();

    public String getSensorId(){ //Identificador do sensor, i.e., L1 retorna '1'
        String sensor = getSensorName();
        char[] sensorSplit = sensor.toCharArray();
        return String.valueOf(sensorSplit[1]);
    }
    public String getSensorType(){ //Identificador do tipo de sensor, i.e., L1 retorna 'L'
        String sensor = getSensorName();
        char[] sensorSplit = sensor.toCharArray();
        return String.valueOf(sensorSplit[0]);
    }

}