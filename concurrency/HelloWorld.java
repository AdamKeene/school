import java.util.*;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class HelloWorld {
    static int sleepTime = 2000;

    // hashmap for threads and IDs
    private static Map<Integer, Thread> activeThreads = new HashMap<>();
    private static int nextThreadId = 1;
    private static Scanner scanner = new Scanner(System.in);
    
    public static void main(String[] args) {        
        System.out.println("Thread Management Program Started");
        
        while (true) {
            displayMenu();
            String input = scanner.nextLine().trim();
            
            // input options
            if (input.equals("a")) {
                createNewThread();
            } else if (input.startsWith("b")) {
                try {
                    int threadId = Integer.parseInt(input.substring(2).trim());
                    stopThread(threadId);
                } catch (NumberFormatException e) {
                    System.out.println("Invalid thread ID, thread not terminated");
                } catch (IndexOutOfBoundsException e) {
                    System.out.println("No thread ID, thread not terminated");
                }
            } else if (input.equals("c")) {
                stopAllThreads();
                break;
            } else {
                System.out.println("No Option " + input);
            }
        }
        
        scanner.close();
    }

    // thread behavior
    private static class MessageLoop implements Runnable {
        private int threadId;
        
        public MessageLoop(int threadId) {
            this.threadId = threadId;
        }
        
        public void run() {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm:ss");
            try {
                while (!Thread.currentThread().isInterrupted()) {
                    // pause for 2 seconds and print a message with the thread ID and current time
                    Thread.sleep(sleepTime);
                    String currentTime = LocalTime.now().format(formatter);
                    System.out.println("Hello World! I'm thread " + threadId + 
                                ". The time is " + currentTime);
                }
            } catch (InterruptedException e) {
                System.out.println("Goodbye World!");
            }
        }
    }
    
    private static void displayMenu() {
        System.out.println("Here are your options:\n");
        System.out.println("\ta - Create a new thread");
        System.out.println("\tb - Stop a given thread (e.g. \"b 2\" kills thread 2)");
        System.out.println("\tc - Stop all threads and exit this program.");
    }
    
    private static void createNewThread() {
        int threadId = nextThreadId++;
        Thread thread = new Thread(new MessageLoop(threadId));
        thread.setName("Thread-" + threadId);
        thread.setDaemon(true);
        activeThreads.put(threadId, thread);
        thread.start();
        System.out.println("Thread " + threadId + " created and started.");
    }
    
    private static void stopThread(int threadId) {
        Thread thread = activeThreads.get(threadId);
        if (thread != null) {
            thread.interrupt();
            activeThreads.remove(threadId);
            System.out.println("Thread " + threadId + " stopped.");
        } else {
            System.out.println("Thread " + threadId + " not found.");
        }
    }
    
    private static void stopAllThreads() {
        for (Thread thread : activeThreads.values()) {
            thread.interrupt();
        }
        activeThreads.clear();
        System.out.println("All threads stopped.");
    }
}
