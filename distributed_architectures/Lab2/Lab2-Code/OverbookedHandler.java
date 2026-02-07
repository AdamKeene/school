public class OverbookedHandler extends CommandEventHandler {
    int limit = 3;

    public OverbookedHandler(DataBase db, int iCommandEvCode, int iOutputEvCode) {
        super(db, iCommandEvCode, iOutputEvCode);
    }

    @Override
    protected String execute(String param) {
        EventBus.subscribeTo(EventBus.EV_SHOW, this);

        if (param == null) return "";
        String[] parts = param.split("\\s+");
        if (parts.length < 3) return "";
        String sCID = parts[1];
        String sSection = parts[2];

        Course c = this.objDataBase.getCourseRecord(sCID, sSection);
        if (c != null) {
            int count = c.getRegisteredStudents().size();
            if (count > limit - 1) { // -1 to account for student being added
                System.out.println("Course " + sCID + " section " + sSection + " is overbooked: " + count + " students");
            }
        }
        return "";
    }
}