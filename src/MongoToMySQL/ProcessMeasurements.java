package MongoToMySQL;

import Models.Measurement;

import java.util.ArrayList;
import java.util.List;

public class ProcessMeasurements {
    private List<Measurement> measurements;
    private double difference;


    public ProcessMeasurements(List<Measurement> measurements, double difference){
        this.measurements = measurements;
        this.difference = difference;
    }

    public ArrayList<Measurement> removeOutliers(){

        ArrayList<Measurement> list1 = new ArrayList<Measurement>();
        ArrayList<Measurement> list2 = new ArrayList<Measurement>();

        double lastValue = measurements.get(0).getValueDouble();

        for(int i = 1; i < measurements.size(); i++) {

            double newValue = measurements.get(i).getValueDouble();

            if(areSimilar(lastValue, newValue)){
                lastValue = measurements.get(i).getValueDouble();
                list1.add(measurements.get(i));
            }
            else{
                list2.add(measurements.get(i));
            }

        }

        if (list1.size() >= list2.size())
            return list1;
        else
            return list2;

    }

    private boolean areSimilar(double value1, double value2){
        return ((Math.abs(value1 - value2) <= difference));
    }

    /*public void removeOutliers(){

        //System.out.println("Tamanho da lista de medições: " + measurements.size());

        // Iterar a lista e perceber se o valor anterior e posterior sao muito

        ArrayList<Measurement> measurements_to_remove = new ArrayList<Measurement>();

        for(int i = 0; i < measurements.size(); i++){

            Measurement first_measurement = measurements.get(i);

            if ((i + 1 ) < measurements.size() && (i + 2) < measurements.size()) {
                Measurement second_measurement = measurements.get(i + 1);
                Measurement third_measurement = measurements.get(i + 2);

                double first_value = first_measurement.getValueDouble();
                double second_value = second_measurement.getValueDouble();
                double third_value = third_measurement.getValueDouble();

                // 200, 10, 10
                if (!areSimilar(first_value, second_value) && areSimilar(second_value, third_value))
                    measurements_to_remove.add(first_measurement); // remove first


                    // 10, 10, 200
                else if (areSimilar(first_value, second_value) && !areSimilar(second_value, third_value))
                    measurements_to_remove.add(third_measurement); // remove third


                    // 10, 200, 10
                else if (!areSimilar(first_value, second_value) && !areSimilar(second_value, third_value)) {

                    if (areSimilar(first_value, third_value))
                        measurements_to_remove.add(second_measurement); // remove second
                }
            }
            else if((i + 1 ) < measurements.size() && (i + 2) >= measurements.size()){
                Measurement second_measurement = measurements.get(i + 1);
                double first_value = first_measurement.getValueDouble();
                double second_value = second_measurement.getValueDouble();

                if (!areSimilar(first_value, second_value))
                    measurements_to_remove.add(second_measurement); // remove second
            }
        }

        for(Measurement measurement : measurements_to_remove)
            measurements.remove(measurement);

        //System.out.println("Tamanho da lista de medições após remoção de outliers: " + measurements.size());
    }*/




}
