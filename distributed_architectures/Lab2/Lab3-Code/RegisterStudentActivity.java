import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.StringTokenizer;

public class RegisterStudentActivity implements IActivity {
    private DBInterface db;

    public RegisterStudentActivity(DBInterface db) {
        this.db = db;
    }

    @Override
    public void execute(String activity) throws RemoteException {
        try {
            StringTokenizer objTokenizer = new StringTokenizer(activity);
            String sSID = objTokenizer.nextToken();
            String sCID = objTokenizer.nextToken();
            String sSection = objTokenizer.nextToken();

            Student objStudent = this.db.getStudentRecord(sSID);
            Course objCourse = this.db.getCourseRecord(sCID, sSection);
            
            if (objStudent == null) {
                System.out.println("\nInvalid student ID\n");
                return;
            }
            if (objCourse == null) {
                System.out.println("\nInvalid course ID or course section\n");
                return;
            }

            // Check for course time conflicts
            ArrayList vCourse = objStudent.getRegisteredCourses();
            for (int i = 0; i < vCourse.size(); i++) {
                if (((Course) vCourse.get(i)).conflicts(objCourse)) {
                    System.out.println("\nRegistration conflicts\n");
                    return;
                }
            }

            // Proceed with registration
            this.db.makeARegistration(sSID, sCID, sSection);
            
            // Check if course is overbooked
            int count = objCourse.getRegisteredStudents().size();
            if (count > 3) {
                System.out.println("\nSuccessful! Warning: Course " + sCID + " section " + sSection + " is overbooked: " + count + " students\n");
            } else {
                System.out.println("\nSuccessful!\n");
            }
        } catch (RemoteException e) {
            System.err.println("Error registering student: " + e.getMessage());
        }
    }
}
