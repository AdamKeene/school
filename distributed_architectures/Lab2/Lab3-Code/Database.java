/**
 * @(#)Database.java
 *
 * Copyright: Copyright (c) 2003 Carnegie Mellon University
 *
 */

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;

/**
 * A <code>Database</code> provides access to student and course data including reading the record
 * information and writing registration information. Note that current version of database doesn't
 * support writing student and course records to files. A shutdown means loss of all registration
 * information.
 */
@SuppressWarnings("unchecked")
public class Database extends UnicastRemoteObject implements DBInterface {

    /**
     * A list of <code>Student</code> objects containing student records.
     */
    protected ArrayList vStudent;

    /**
     * A list of <code>Course</code> objects containing course records.
     */
    protected ArrayList vCourse;

    /**
     * Construct a database that provides access to student and course data. Initial data are filled
     * with the records in the given student and course record files. At the time of creation, the
     * database does not contain any registration information.
     *
     * @param sStudentFileName the name of student record file
     * @param sCourseFileName the name of course record file
     */
    public Database(String sStudentFileName, String sCourseFileName)
           throws FileNotFoundException, IOException, RemoteException {
        // Open the given student and course files.
        BufferedReader objStudentFile = new BufferedReader(new FileReader(sStudentFileName));
        BufferedReader objCourseFile  = new BufferedReader(new FileReader(sCourseFileName));

        // Initialize student and course lists.
        this.vStudent = new ArrayList();
        this.vCourse  = new ArrayList();

        // Populate student and course lists.
        while (objStudentFile.ready()) {
            this.vStudent.add(new Student(objStudentFile.readLine()));
        }
        while (objCourseFile.ready()) {
            this.vCourse.add(new Course(objCourseFile.readLine()));
        }

        // Close the student and course files.
        objStudentFile.close();
        objCourseFile.close();
    }

    /**
     * Return all student records as a list.
     *
     * @return an <code>ArrayList</code> of <code>Student</code> objects containing student records
     */
    public ArrayList getAllStudentRecords() throws RemoteException {
        // Return the student list as it is.
        return this.vStudent;
    }

    /**
     * Return all course records as a list.
     *
     * @return an <code>ArrayList</code> of <code>Course</code> objects containing course records
     */
    public ArrayList getAllCourseRecords() throws RemoteException {
        // Return the course list as it is.
        return this.vCourse;
    }

    /**
     * Return a student record whose ID is equal to the given student ID.
     *
     * @param  sSID a student ID to lookup
     * @return a <code>Student</code> object whose ID is equal to <code>sSID</code>.
     *         <code>null</code> if not found
     * @see    #getStudentName(String)
     */
    public Student getStudentRecord(String sSID) throws RemoteException {
        // Lookup and return the matching student record if found.
        for (int i=0; i<this.vStudent.size(); i++) {
            Student objStudent = (Student) this.vStudent.get(i);
            if (objStudent.match(sSID)) {
                return objStudent;
            }
        }

        // Return null if not found.
        return null;
    }

    /**
     * Return the name of a student whose ID is equal to the given student ID.
     *
     * @param  sSID a student ID to lookup
     * @return a <code>String</code> representing student name. <code>null</code> if not found
     * @see    #getStudentRecord(String)
     */
    public String getStudentName(String sSID) throws RemoteException {
        // Lookup and return the matching student name if found.
        for (int i=0; i<this.vStudent.size(); i++) {
            Student objStudent = (Student) this.vStudent.get(i);
            if (objStudent.match(sSID)) {
                return objStudent.getName();
            }
        }

        // Return null if not found.
        return null;
    }

    /**
     * Return a course record whose ID is equal to the given course ID.
     *
     * @param  sCID a course ID to lookup
     * @param  sSection a course section to lookup
     * @return a <code>Course</code> object whose ID is equal to <code>sCID</code>.
     *         <code>null</code> if not found
     * @see    #getCourseName(String)
     */
    public Course getCourseRecord(String sCID, String sSection) throws RemoteException {
        // Lookup and return the matching course record if found.
        for (int i=0; i<this.vCourse.size(); i++) {
            Course objCourse = (Course) this.vCourse.get(i);
            if (objCourse.match(sCID, sSection)) {
                return objCourse;
            }
        }

        // Return null if not found.
        return null;
    }

    /**
     * Return the name of a course whose ID is equal to the given course ID.
     *
     * @param  sCID a course ID to lookup
     * @return a <code>String</code> representing course name. <code>null</code> if not found
     * @see    #getCourseRecord(String,String)
     */
    public String getCourseName(String sCID) throws RemoteException {
        // Lookup and return the matching course name if found.
        for (int i=0; i<this.vCourse.size(); i++) {
            Course objCourse = (Course) this.vCourse.get(i);
            if (objCourse.match(sCID)) {
                return objCourse.getName();
            }
        }

        // Return null if not found.
        return null;
    }

    /**
     * Make a registration. No conflict check is done before updating the database. Nothing happens
     * if there is no matching student record and/or course record.
     *
     * @param  sSID a student ID to register
     * @param  sCID a course ID to register
     * @param  sSection a course section to register
     */
    public void makeARegistration(String sSID, String sCID, String sSection) throws RemoteException {
        // Find the student record and the course record.
        Student objStudent = this.getStudentRecord(sSID);
        Course  objCourse  = this.getCourseRecord(sCID, sSection);

        // Make a registration.
        if (objStudent != null && objCourse != null) {
            objStudent.registerCourse(objCourse);
            objCourse.registerStudent(objStudent);
        }
    }

    /**
     * Entry point to create the database and bind it in a dedicated registry.
     */
    public static void main(String[] args) {
        System.setProperty("java.rmi.server.hostname", "127.0.0.1");
        String studentFileName;
        String courseFileName;

        if (args.length == 2) {
            studentFileName = args[0];
            courseFileName = args[1];
        } else {
            studentFileName = "Students.txt";
            courseFileName = "Courses.txt";
        }

        if (!new File(studentFileName).exists()) {
            System.err.println("Could not find " + studentFileName);
            System.exit(1);
        }
        if (!new File(courseFileName).exists()) {
            System.err.println("Could not find " + courseFileName);
            System.exit(1);
        }

        try {
            Database db = new Database(studentFileName, courseFileName);

            Registry registry;
            try {
                registry = LocateRegistry.getRegistry("127.0.0.1", 1099);
                registry.list();
            } catch (RemoteException e) {
                System.out.println("Creating Database Registry on port 1099...");
                registry = LocateRegistry.createRegistry(1099);
            }

            registry.rebind("RegistrationDB", db);
            System.out.println("Database started. Bound to registry as 'RegistrationDB'");
            System.out.println("Waiting for connections...");
        } catch (Exception e) {
            System.err.println("Database error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
