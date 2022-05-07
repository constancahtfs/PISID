package Errors;

import Utils.Dates;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.nio.file.Paths;

public class ErrorHandling {


    public static void formatError(ERROR_SOURCE errorSource, String message, Exception exception) {

        String userDirectory = Paths.get("").toAbsolutePath().toString();

        try{

            String file_name = getFileName(errorSource);

            File log = new File(userDirectory + "\\src\\Errors\\" + file_name);
            PrintWriter myWriter = new PrintWriter(new FileWriter(log, true));

            String nowTimestamp = Dates.getNowTimestamp();

            myWriter.write(errorSource + " " + nowTimestamp + " " + message + " " + exception.getMessage() + "\n");
            myWriter.close();

        } catch (Exception e) {
            System.out.println("Could not write measurement format error log.");
        }
    }

    private static String getFileName(ERROR_SOURCE errorSource){
        return switch(errorSource){
            case MEASUREMENT_OBJECT -> "mapping_errors.txt";
            case MYSQL_LOCAL -> "mysql_local_errors.txt";
            case MONGO_LOCAL -> "mongo_local_errors.txt.txt";
        };
    }

}
