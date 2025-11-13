package ex2_1;

import java.util.concurrent.*;

public class Main3 {

   private static void nap(int millisecs) {
        try {
            Thread.sleep(millisecs);
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        }
    }

    private static void addProc(HighLevelDisplay d) {
        int flightNum = 001;
        
        while (true) {
            String flightInfo = String.format("Flight AC%03d", flightNum);
            d.addRow(flightInfo);
            nap(100);
            flightNum++;

            if (flightNum > 999) {
                flightNum = 001;
            }
        }
   }

    private static void deleteProc(HighLevelDisplay d) {
        while (true) {
            d.deleteRow(0);
            nap(2000);
        }
    }

    public static void main(String [] args) {
	final HighLevelDisplay d = new JDisplay2();

	new Thread () {
	    public void run() {
		addProc(d);
	    }
	}.start();


	new Thread () {
	    public void run() {
		deleteProc(d);
	    }
	}.start();

    }
}