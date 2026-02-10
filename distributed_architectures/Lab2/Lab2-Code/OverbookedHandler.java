import java.util.StringTokenizer;

public class OverbookedHandler extends CommandEventHandler {
    int limit = 3;

    public OverbookedHandler(DataBase db, int iCommandEvCode, int iOutputEvCode) {
        super(db, iCommandEvCode, iOutputEvCode);
    }

    @Override
    protected String execute(String param) {
        // retrieve parameters and course record
        if (param == null) return "";
        StringTokenizer objTokenizer = new StringTokenizer(param);
        String sSID     = objTokenizer.nextToken();
        String sCID     = objTokenizer.nextToken();
        String sSection = objTokenizer.nextToken();
        Course c = this.objDataBase.getCourseRecord(sCID, sSection);

        // check if course is overbooked
        if (c != null) {
            int count = c.getRegisteredStudents().size();
            if (count > limit) {
                return "Course " + sCID + " section " + sSection + " is overbooked: " + count + " students";
            }
        }
        return "";
    }
}