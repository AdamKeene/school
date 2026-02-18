import java.rmi.RemoteException;
import java.util.ArrayList;

public class ListStudentsActivity implements IActivity {
    private DBInterface db;

    public ListStudentsActivity(DBInterface db) {
        this.db = db;
    }

    @Override
    public void execute(String activity) throws RemoteException {
        try {
            ArrayList vStudent = this.db.getAllStudentRecords();
            System.out.println("\n");
            for (int i = 0; i < vStudent.size(); i++) {
                System.out.println((i == 0 ? "" : "\n") + ((Student) vStudent.get(i)).toString());
            }
            System.out.println();
        } catch (RemoteException e) {
            System.err.println("Error retrieving student records: " + e.getMessage());
        }
    }
}
