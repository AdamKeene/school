import java.rmi.RemoteException;
import java.util.ArrayList;

public class ListCoursesActivity implements IActivity {
    private DBInterface db;

    public ListCoursesActivity(DBInterface db) {
        this.db = db;
    }

    @Override
    public void execute(String activity) throws RemoteException {
        try {
            ArrayList vCourse = this.db.getAllCourseRecords();
            System.out.println("\n");
            for (int i = 0; i < vCourse.size(); i++) {
                System.out.println((i == 0 ? "" : "\n") + ((Course) vCourse.get(i)).toString());
            }
            System.out.println();
        } catch (RemoteException e) {
            System.err.println("Error retrieving course records: " + e.getMessage());
        }
    }
}
