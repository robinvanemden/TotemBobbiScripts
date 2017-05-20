/*
 * Code 2017 by Robin van Emden
 * For use with the Totem Bobbi
 * http://pavlov.tech/
 * http://www.totemopenhealth.com/
 */

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Scanner;

public class BobbiPeakDetector {

    private static final String FILE_PATH = "data/8-sdataHR_sample.csv";
    private static final int SAMPLE_FREQUENCY = 500;

    public static void main(String[] args) throws IOException {

        // initialize our BobbiPeakDetector class
        BobbiPeakDetector bobbiReader = new BobbiPeakDetector();

        // read csv file with ecg heart rate values
        ArrayList<Integer> heartRateList = bobbiReader.readBobbi(FILE_PATH);

        // get a list of peaks
        ArrayList<Integer> peakList = bobbiReader.getPeaks(heartRateList, 0.993d);

        // print them to the command line
        System.out.println(peakList);

        // lets calculate the heart rate based on our list of peaks and the sample frequency
        int rr_dist_total = peakList.get(peakList.size()-1) - peakList.get(0);
        float rr_dist_avg = rr_dist_total/(peakList.size()-1);
        float rr_ms_avg = rr_dist_avg * 1000/SAMPLE_FREQUENCY;
        float beats_per_second = 1000/rr_ms_avg;
        float beats_per_minute = beats_per_second * 60;
        DecimalFormat twoDForm = new DecimalFormat("#.##");
        System.out.println("Bpm = " + twoDForm.format(beats_per_minute));
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

    public ArrayList<Integer> getPeaks(ArrayList<Integer> input, double threshold) {
        double max = 0;
        double peakThreshold;
        ArrayList<Integer> peaks = new ArrayList<Integer>();
        System.out.println("Start getting the peaks");
        for (int i = 0; i < input.size(); i++) {
            if (input.get(i) > max) {
                max = input.get(i);
            }
        }
        System.out.println("Max = " + max);
        peakThreshold = max * threshold;
        for (int i = 0; i < input.size(); i++) {
            if (input.get(i) > peakThreshold) {
                int j = i;

                if (input.get(i) < input.get(i + 1)) {
                    while (input.get(j) < input.get(j + 1) && j > 0) {
                        j--;
                    }
                    if (!peaks.contains(j)) {
                        peaks.add(j);
                    }
                } else {
                    while (input.get(j) > input.get(j + 1)) {
                        j++;
                    }
                    while (input.get(j) < input.get(j + 1)) {
                        j++;
                    }
                    if (!peaks.contains(j)) {
                        peaks.add(j);
                    }
                }
            }
        }
        return peaks;
    }
}