import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class ListStudentsRegisteredActivity implements IActivity {
    private DBInterface db;

    public ListStudentsRegisteredActivity(DBInterface db) {
        this.db = db;
    }

    @Override
    public void execute(String activity) throws RemoteException {
        try {
            StringTokenizer objTokenizer = new StringTokenizer(activity);
            String sCID = objTokenizer.nextToken();
            String sSection = objTokenizer.nextToken();

            Course objCourse = this.db.getCourseRecord(sCID, sSection);
            if (objCourse == null) {
                System.out.println("\nInvalid course ID or course section\n");
                return;
            }
            ArrayList vStudent = objCourse.getRegisteredStudents();
            System.out.println("\n");
            for (int i = 0; i < vStudent.size(); i++) {
                System.out.println((i == 0 ? "" : "\n") + ((Student) vStudent.get(i)).toString());
            }
            System.out.println();
        } catch (RemoteException e) {
            System.err.println("Error retrieving course information: " + e.getMessage());
        }
    }
}
