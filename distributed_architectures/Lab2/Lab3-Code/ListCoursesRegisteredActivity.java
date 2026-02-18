import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class ListCoursesRegisteredActivity implements IActivity {
    private DBInterface db;

    public ListCoursesRegisteredActivity(DBInterface db) {
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
            ArrayList vCourse = objStudent.getRegisteredCourses();
            System.out.println("\n");
            for (int i = 0; i < vCourse.size(); i++) {
                System.out.println((i == 0 ? "" : "\n") + ((Course) vCourse.get(i)).toString());
            }
            System.out.println();
        } catch (RemoteException e) {
            System.err.println("Error retrieving student information: " + e.getMessage());
        }
    }
}
