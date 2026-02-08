import java.util.ArrayList;
import java.util.StringTokenizer;


public class RegistrationConflictHandler extends CommandEventHandler {
    public RegistrationConflictHandler(DataBase objDataBase, int iCommandEvCode, int iOutputEvCode) {
        super(objDataBase, iCommandEvCode, iOutputEvCode);
    }

    @Override
    protected String execute(String param) {
        // Get the student and course records.
        StringTokenizer objTokenizer = new StringTokenizer(param);
        String sSID     = objTokenizer.nextToken();
        String sCID     = objTokenizer.nextToken();
        String sSection = objTokenizer.nextToken();
        
        Student objStudent = this.objDataBase.getStudentRecord(sSID);
        Course objCourse = this.objDataBase.getCourseRecord(sCID, sSection);       

        // Check if the given course conflicts with any of t);
        ArrayList vCourse = objStudent.getRegisteredCourses();
        for (int i=0; i<vCourse.size(); i++) {
            if (((Course) vCourse.get(i)).conflicts(objCourse)) {
                return "Registration conflicts";
            }
        }
        EventBus.announce(EventBus.EV_REGISTER_STUDENT, param);
        return "";
    }
}