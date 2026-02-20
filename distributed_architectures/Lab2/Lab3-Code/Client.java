import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * RMI client that provides a console UI and invokes activities against the remote DB.
 */
public class Client {

    private final IActivity listStudents;
    private final IActivity listCourses;
    private final IActivity listStudentsRegistered;
    private final IActivity listCoursesRegistered;
    private final IActivity listCoursesCompleted;
    private final IActivity registerStudent;
    private final PrintWriter logFile;

    public Client(
        IActivity listStudents,
        IActivity listCourses,
        IActivity listStudentsRegistered,
        IActivity listCoursesRegistered,
        IActivity listCoursesCompleted,
        IActivity registerStudent) {
        this.listStudents = listStudents;
        this.listCourses = listCourses;
        this.listStudentsRegistered = listStudentsRegistered;
        this.listCoursesRegistered = listCoursesRegistered;
        this.listCoursesCompleted = listCoursesCompleted;
        this.registerStudent = registerStudent;
        this.logFile = initLogger();
    }

    public static void main(String[] args) {
        try {
            Registry registry = LocateRegistry.getRegistry("localhost", 1100);
            IActivity listStudents = (IActivity) registry.lookup("ListStudents");
            IActivity listCourses = (IActivity) registry.lookup("ListCourses");
            IActivity listStudentsRegistered = (IActivity) registry.lookup("ListStudentsRegistered");
            IActivity listCoursesRegistered = (IActivity) registry.lookup("ListCoursesRegistered");
            IActivity listCoursesCompleted = (IActivity) registry.lookup("ListCoursesCompleted");
            IActivity registerStudent = (IActivity) registry.lookup("RegisterStudent");
            System.out.println("Connected to remote activities\n");
            new Client(
                listStudents,
                listCourses,
                listStudentsRegistered,
                listCoursesRegistered,
                listCoursesCompleted,
                registerStudent).run();
        } catch (RemoteException e) {
            System.err.println("Error: Could not reach RMI registry. Make sure the server is running.");
            e.printStackTrace();
            System.exit(1);
        } catch (NotBoundException e) {
            System.err.println("Error: Could not find remote DataBase. Make sure the server is running.");
            e.printStackTrace();
            System.exit(1);
        }
    }

    public void run() {
        try {
            BufferedReader objReader = new BufferedReader(new InputStreamReader(System.in));

            while (true) {
                System.out.println("\nStudent Registration System\n");
                System.out.println("1) List all students");
                System.out.println("2) List all courses");
                System.out.println("3) List students who registered for a course");
                System.out.println("4) List courses a student has registered for");
                System.out.println("5) List courses a student has completed");
                System.out.println("6) Register a student for a course");
                System.out.println("x) Exit");
                System.out.print("\nEnter your choice and press return >> ");
                String sChoice = objReader.readLine().trim();

                if (sChoice.equals("1")) {
                    System.out.println("\n");
                    printAndLog(this.listStudents.execute(""));
                    continue;
                }

                if (sChoice.equals("2")) {
                    System.out.println("\n");
                    printAndLog(this.listCourses.execute(""));
                    continue;
                }

                if (sChoice.equals("3")) {
                    System.out.print("\nEnter course ID and press return >> ");
                    String sCID = objReader.readLine().trim();
                    System.out.print("\nEnter course section and press return >> ");
                    String sSection = objReader.readLine().trim();

                    System.out.println("\n");
                    printAndLog(this.listStudentsRegistered.execute(sCID + " " + sSection));
                    continue;
                }

                if (sChoice.equals("4")) {
                    System.out.print("\nEnter student ID and press return >> ");
                    String sSID = objReader.readLine().trim();

                    System.out.println("\n");
                    printAndLog(this.listCoursesRegistered.execute(sSID));
                    continue;
                }

                if (sChoice.equals("5")) {
                    System.out.print("\nEnter student ID and press return >> ");
                    String sSID = objReader.readLine().trim();

                    System.out.println("\n");
                    printAndLog(this.listCoursesCompleted.execute(sSID));
                    continue;
                }

                if (sChoice.equals("6")) {
                    System.out.print("\nEnter student ID and press return >> ");
                    String sSID = objReader.readLine().trim();
                    System.out.print("\nEnter course ID and press return >> ");
                    String sCID = objReader.readLine().trim();
                    System.out.print("\nEnter course section and press return >> ");
                    String sSection = objReader.readLine().trim();

                    System.out.println("\n");
                    printAndLog(this.registerStudent.execute(sSID + " " + sCID + " " + sSection));
                    continue;
                }

                if (sChoice.equalsIgnoreCase("X")) {
                    break;
                }
            }

            objReader.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            System.exit(1);
        }
    }

    private PrintWriter initLogger() {
        try {
            return new PrintWriter(new FileWriter("client.log", true), true);
        } catch (Exception e) {
            System.err.println("Failed to open client log: " + e.getMessage());
            return null;
        }
    }

    private void printAndLog(String message) {
        if (message == null || message.isEmpty()) {
            return;
        }
        System.out.println(message);
        if (this.logFile != null) {
            this.logFile.println("[" + getCurrentTime() + "] " + message.replace("\n", " | "));
            this.logFile.flush();
        }
    }

    private String getCurrentTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        return LocalDateTime.now().format(formatter);
    }
}
