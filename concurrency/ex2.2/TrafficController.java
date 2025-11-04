public class TrafficController {

    private int carsOnBridge = 0;
    private boolean leftTraffic = false;
    private boolean rightTraffic = false;

    public synchronized void enterLeft() {
        while (rightTraffic) {
            try {
                wait();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        leftTraffic = true;
        carsOnBridge++;
    }

    public synchronized void enterRight() {
        while (leftTraffic) {
            try {
                wait();
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        rightTraffic = true;
        carsOnBridge++;
    }

    public synchronized void leaveLeft() {
        carsOnBridge--;
        if (carsOnBridge == 0) {
            rightTraffic = false;
            notifyAll();
        }
    }

    public synchronized void leaveRight() {
        carsOnBridge--;
        if (carsOnBridge == 0) {
            leftTraffic = false;
            notifyAll();
        }
    }
}