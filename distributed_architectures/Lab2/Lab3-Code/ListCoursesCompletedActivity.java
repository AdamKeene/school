import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class ListCoursesCompletedActivity implements IActivity {
    private DBInterface db;

    public ListCoursesCompletedActivity(DBInterface db) {
        this.db = db;
    }

    @Override
    public void execute(String activity) throws RemoteException {
        try {
            StringTokenizer objTokenizer = new StringTokenizer(activity);
            String sSID = objTokenizer.nextToken();

            Student objStudent = this.db.getStudentRecord(sSID);
            if (objStudent == null) {
                System.out.println("\nInvalid student ID\n");
                return;
            }
            ArrayList vCourseID = objStudent.getCompletedCourses();
            System.out.println("\n");
            for (int i = 0; i < vCourseID.size(); i++) {
                String sCID = (String) vCourseID.get(i);
                String sName = this.db.getCourseName(sCID);
                System.out.println((i == 0 ? "" : "\n") + sCID + " " + (sName == null ? "Unknown" : sName));
            }
            System.out.println();
        } catch (RemoteException e) {
            System.err.println("Error retrieving course information: " + e.getMessage());
        }
    }
}
