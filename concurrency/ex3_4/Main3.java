import java.util.concurrent.*;

public class Main3 {

   private static void nap(int millisecs) {
        try {
            Thread.sleep(millisecs);
        } catch (InterruptedException e) {
            System.err.println(e.getMessage());
        }
    }

    private static void addProc(HighLevelDisplay d, Semaphore sem) {
        int flightNum = 001;
        
        while (true) {
            String flightInfo = String.format("Flight AC%03d", flightNum);
            try {
                sem.acquire();
                d.addRow(flightInfo);
                sem.release();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            nap(100);
            flightNum++;

            if (flightNum > 999) {
                flightNum = 001;
            }
        }
   }

    private static void deleteProc(HighLevelDisplay d, Semaphore sem) {
        while (true) {
            try {
                sem.acquire();
                d.deleteRow(0);
                sem.release();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            nap(2000);
        }
    }

    public static void main(String [] args) {
	final HighLevelDisplay d = new JDisplay2();
	final Semaphore sem = new Semaphore(1, true);

	new Thread () {
	    public void run() {
		addProc(d, sem);
	    }
	}.start();


	new Thread () {
	    public void run() {
		deleteProc(d, sem);
	    }
	}.start();

    }
}