/*
 * Code 2017 by Robin van Emden
 * For use with the Totem Bobbi
 * http://pavlov.tech/
 * http://www.totemopenhealth.com/
 */

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;

public class BobbiReader {

    private static final String FILE_PATH = "data/8-sdataHR_sample.csv";
    
    public static void main(String[] args) throws IOException {

        // initialize our bobbireader class
        BobbiReader bobbiReader = new BobbiReader();

        // read csv file with ecg heart rate values
        ArrayList<Integer> heartRateList = bobbiReader.readBobbi(FILE_PATH);

        // do some stuff :)
    }

    public ArrayList<Integer> readBobbi(String filename) throws IOException {
        ArrayList<Integer> heartRateList = new ArrayList<Integer>();
        File inFile = new File(filename);
        Scanner scanner = new Scanner(inFile);
        scanner.nextLine();                                        // skip header
        while (scanner.hasNext()) {
            String bobbiRow = scanner.nextLine();
            String[] bobbiRowValues = bobbiRow.split(";");
            heartRateList.add(Integer.parseInt(bobbiRowValues[1])); // get the heart rate - in this file, the second element
        }
        scanner.close();
        return heartRateList;
    }
}