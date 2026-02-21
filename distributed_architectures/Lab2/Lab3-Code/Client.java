
/**
 * @(#)ClientInput.java
 *
 * Copyright: Copyright (c) 2003 Carnegie Mellon University
 *
 *
 */


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

// RMI client that provides a console UI and invokes activities against the remote DB
public class Client {

    private final IActivity listStudents;
    private final IActivity listCourses;
    private final IActivity listStudentsRegistered;
    private final IActivity listCoursesRegistered;
    private final IActivity listCoursesCompleted;
    private final IActivity registerStudent;
    private final PrintWriter logFile;

    // Initialize the client with remote activity references
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
            // Look up remote activities from the activity registry
            Registry registry = LocateRegistry.getRegistry("localhost", 1100);
            IActivity listStudents = (IActivity) registry.lookup("ListStudents");
            IActivity listCourses = (IActivity) registry.lookup("ListCourses");
            IActivity listStudentsRegistered = (IActivity) registry.lookup("ListStudentsRegistered");
            IActivity listCoursesRegistered = (IActivity) registry.lookup("ListCoursesRegistered");
            IActivity listCoursesCompleted = (IActivity) registry.lookup("ListCoursesCompleted");
            IActivity registerStudent = (IActivity) registry.lookup("RegisterStudent");
            System.out.println("Connected to remote activities\n");
            // Start the interactive command loop
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

    /**
     * Thread body of client input components. It continuously gets user input and announces command
     * events.  It announces show events to request the display of usage prompts.
     */
    public void run() {
        try {
            // Create a buffered reader using system input stream.
            BufferedReader objReader = new BufferedReader(new InputStreamReader(System.in));

            while (true) {
                // Show available commands and get a choice.
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

                // Execute command 1: List all students.
                if (sChoice.equals("1")) {
                    // Announce the command event #1.
                    System.out.println("\n");
                    printAndLog(this.listStudents.execute(""));
                    continue;
                }

                // Execute command 2: List all courses.
                if (sChoice.equals("2")) {
                    // Announce the command event #2.
                    System.out.println("\n");
                    printAndLog(this.listCourses.execute(""));
                    continue;
                }

                // Execute command 3: List students registered for a course.
                if (sChoice.equals("3")) {
                    // Get course ID and course section from user.
                    System.out.print("\nEnter course ID and press return >> ");
                    String sCID = objReader.readLine().trim();
                    System.out.print("\nEnter course section and press return >> ");
                    String sSection = objReader.readLine().trim();

                    // Announce the command event #3 with course ID and course section.
                    System.out.println("\n");
                    printAndLog(this.listStudentsRegistered.execute(sCID + " " + sSection));
                    continue;
                }

                // Execute command 4: List courses a student has registered for.
                if (sChoice.equals("4")) {
                    // Get student ID from user.
                    System.out.print("\nEnter student ID and press return >> ");
                    String sSID = objReader.readLine().trim();

                    // Announce the command event #4 with student ID.
                    System.out.println("\n");
                    printAndLog(this.listCoursesRegistered.execute(sSID));
                    continue;
                }

                // Execute command 5: List courses a student has completed.
                if (sChoice.equals("5")) {
                    // Get student ID from user.
                    System.out.print("\nEnter student ID and press return >> ");
                    String sSID = objReader.readLine().trim();

                    // Announce the command event #5 with student ID.
                    System.out.println("\n");
                    printAndLog(this.listCoursesCompleted.execute(sSID));
                    continue;
                }

                // Execute command 6: Register a student for a course.
                if (sChoice.equals("6")) {
                    // Get student ID, course ID, and course section from user.
                    System.out.print("\nEnter student ID and press return >> ");
                    String sSID = objReader.readLine().trim();
                    System.out.print("\nEnter course ID and press return >> ");
                    String sCID = objReader.readLine().trim();
                    System.out.print("\nEnter course section and press return >> ");
                    String sSection = objReader.readLine().trim();

                    // begin conflict check and student registration chain with student ID, course ID, and course section.
                    System.out.println("\n");
                    printAndLog(this.registerStudent.execute(sSID + " " + sCID + " " + sSection));
                    continue;
                }

                // Terminate this client.
                if (sChoice.equalsIgnoreCase("X")) {
                    break;
                }
            }

            // Clean up the resources.
            objReader.close();
        } catch (Exception e) {
            // Dump the exception information for debugging.
            e.printStackTrace();
            System.out.println(e.getMessage());
            System.exit(1);
        }
    }

    // Initialize client-side log file
    private PrintWriter initLogger() {
        try {
            return new PrintWriter(new FileWriter("client.log", true), true);
        } catch (Exception e) {
            System.err.println("Failed to open client log: " + e.getMessage());
            return null;
        }
    }

    // Print to console and append to client.log with timestamp.
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

    // Timestamp helper for client-side logging.
    private String getCurrentTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        return LocalDateTime.now().format(formatter);
    }
}
