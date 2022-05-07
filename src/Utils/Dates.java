package Utils;

import java.sql.Timestamp;
import java.util.Calendar;

public class Dates {


    public static String getNowTimestamp(){
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        return formatTimestamp(timestamp);
    }


    public static String getTwoMinutesPastTimestamp(){
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());

        // Go back two minutes
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(timestamp.getTime());
        cal.add(Calendar.MINUTE, -2);

        timestamp = new Timestamp(cal.getTime().getTime());

        return formatTimestamp(timestamp);
    }

    public static String getOneHourPastTimestamp(){
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());

        // Go back two minutes
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(timestamp.getTime());
        cal.add(Calendar.HOUR, -1);

        timestamp = new Timestamp(cal.getTime().getTime());

        return formatTimestamp(timestamp);
    }

    private static String formatTimestamp(Timestamp timestamp){

        // Convert to string
        String timestampStr = String.valueOf(timestamp);

        // Split and format
        String[] timestampArr = timestampStr.split(" ");
        return (timestampArr[0] + "T" + timestampArr[1] + "Z");
    }
}
