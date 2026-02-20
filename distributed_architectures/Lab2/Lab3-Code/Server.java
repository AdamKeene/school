import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 * RMI Server that hosts remote IActivity handlers in a dedicated registry.
 */
public class Server {
    public static void main(String[] args) {
        try {
            System.setProperty("java.rmi.server.hostname", "127.0.0.1");
            // Look up remote Database from the separate registry
            Registry dbRegistry = LocateRegistry.getRegistry("127.0.0.1", 1099);
            DBInterface db = (DBInterface) dbRegistry.lookup("RegistrationDB");

            // Create or get registry for activities on a different port
            Registry activityRegistry;
            try {
                activityRegistry = LocateRegistry.getRegistry("127.0.0.1", 1100);
                activityRegistry.list();
            } catch (RemoteException e) {
                System.out.println("Creating Activity Registry on port 1100...");
                activityRegistry = LocateRegistry.createRegistry(1100);
            }

            activityRegistry.rebind("ListStudents", new ListStudentsActivity(db));
            activityRegistry.rebind("ListCourses", new ListCoursesActivity(db));
            activityRegistry.rebind("ListStudentsRegistered", new ListStudentsRegisteredActivity(db));
            activityRegistry.rebind("ListCoursesRegistered", new ListCoursesRegisteredActivity(db));
            activityRegistry.rebind("ListCoursesCompleted", new ListCoursesCompletedActivity(db));
            activityRegistry.rebind("RegisterStudent", new RegisterStudentActivity(db));

            System.out.println("Server started. Activities bound to registry on port 1100");
            System.out.println("Waiting for client connections...");
        } catch (Exception e) {
            System.err.println("Server error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }

    private static class ListStudentsActivity extends UnicastRemoteObject implements IActivity {
        private final DBInterface db;

        ListStudentsActivity(DBInterface db) throws RemoteException {
            this.db = db;
        }

        @Override
        public String execute(String activity) throws RemoteException {
            ArrayList vStudent = this.db.getAllStudentRecords();
            StringBuilder sReturn = new StringBuilder();
            for (int i = 0; i < vStudent.size(); i++) {
                if (i > 0) {
                    sReturn.append("\n");
                }
                sReturn.append(((Student) vStudent.get(i)).toString());
            }
            return sReturn.toString();
        }
    }

    private static class ListCoursesActivity extends UnicastRemoteObject implements IActivity {
        private final DBInterface db;

        ListCoursesActivity(DBInterface db) throws RemoteException {
            this.db = db;
        }

        @Override
        public String execute(String activity) throws RemoteException {
            ArrayList vCourse = this.db.getAllCourseRecords();
            StringBuilder sReturn = new StringBuilder();
            for (int i = 0; i < vCourse.size(); i++) {
                if (i > 0) {
                    sReturn.append("\n");
                }
                sReturn.append(((Course) vCourse.get(i)).toString());
            }
            return sReturn.toString();
        }
    }

    private static class ListStudentsRegisteredActivity extends UnicastRemoteObject implements IActivity {
        private final DBInterface db;

        ListStudentsRegisteredActivity(DBInterface db) throws RemoteException {
            this.db = db;
        }

        @Override
        public String execute(String activity) throws RemoteException {
            StringTokenizer objTokenizer = new StringTokenizer(activity);
            String sCID = objTokenizer.nextToken();
            String sSection = objTokenizer.nextToken();

            Course objCourse = this.db.getCourseRecord(sCID, sSection);
            if (objCourse == null) {
                return "Invalid course ID or course section";
            }
            ArrayList vStudent = objCourse.getRegisteredStudents();
            StringBuilder sReturn = new StringBuilder();
            for (int i = 0; i < vStudent.size(); i++) {
                if (i > 0) {
                    sReturn.append("\n");
                }
                sReturn.append(((Student) vStudent.get(i)).toString());
            }
            return sReturn.toString();
        }
    }

    private static class ListCoursesRegisteredActivity extends UnicastRemoteObject implements IActivity {
        private final DBInterface db;

        ListCoursesRegisteredActivity(DBInterface db) throws RemoteException {
            this.db = db;
        }

        @Override
        public String execute(String activity) throws RemoteException {
            StringTokenizer objTokenizer = new StringTokenizer(activity);
            String sSID = objTokenizer.nextToken();

            Student objStudent = this.db.getStudentRecord(sSID);
            if (objStudent == null) {
                return "Invalid student ID";
            }
            ArrayList vCourse = objStudent.getRegisteredCourses();
            StringBuilder sReturn = new StringBuilder();
            for (int i = 0; i < vCourse.size(); i++) {
                if (i > 0) {
                    sReturn.append("\n");
                }
                sReturn.append(((Course) vCourse.get(i)).toString());
            }
            return sReturn.toString();
        }
    }

    private static class ListCoursesCompletedActivity extends UnicastRemoteObject implements IActivity {
        private final DBInterface db;

        ListCoursesCompletedActivity(DBInterface db) throws RemoteException {
            this.db = db;
        }

        @Override
        public String execute(String activity) throws RemoteException {
            StringTokenizer objTokenizer = new StringTokenizer(activity);
            String sSID = objTokenizer.nextToken();

            Student objStudent = this.db.getStudentRecord(sSID);
            if (objStudent == null) {
                return "Invalid student ID";
            }
            ArrayList vCourseID = objStudent.getCompletedCourses();
            StringBuilder sReturn = new StringBuilder();
            for (int i = 0; i < vCourseID.size(); i++) {
                String sCID = (String) vCourseID.get(i);
                String sName = this.db.getCourseName(sCID);
                if (i > 0) {
                    sReturn.append("\n");
                }
                sReturn.append(sCID).append(" ").append(sName == null ? "Unknown" : sName);
            }
            return sReturn.toString();
        }
    }

    private static class RegisterStudentActivity extends UnicastRemoteObject implements IActivity {
        private final DBInterface db;

        RegisterStudentActivity(DBInterface db) throws RemoteException {
            this.db = db;
        }

        @Override
        public String execute(String activity) throws RemoteException {
            StringTokenizer objTokenizer = new StringTokenizer(activity);
            String sSID = objTokenizer.nextToken();
            String sCID = objTokenizer.nextToken();
            String sSection = objTokenizer.nextToken();

            Student objStudent = this.db.getStudentRecord(sSID);
            Course objCourse = this.db.getCourseRecord(sCID, sSection);

            if (objStudent == null) {
                return "Invalid student ID";
            }
            if (objCourse == null) {
                return "Invalid course ID or course section";
            }

            ArrayList vCourse = objStudent.getRegisteredCourses();
            for (int i = 0; i < vCourse.size(); i++) {
                if (((Course) vCourse.get(i)).conflicts(objCourse)) {
                    return "Registration conflicts";
                }
            }

            this.db.makeARegistration(sSID, sCID, sSection);

            int count = objCourse.getRegisteredStudents().size();
            if (count > 3) {
                return "Successful! Warning: Course " + sCID + " section " + sSection
                    + " is overbooked: " + count + " students";
            }
            return "Successful!";
        }
    }
}
