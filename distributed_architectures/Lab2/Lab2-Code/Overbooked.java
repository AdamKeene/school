import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Observable;
import java.util.Observer;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

@SuppressWarnings("deprecation")
public class Overbooked {
    private final ConcurrentMap<String, Integer> counts = new ConcurrentHashMap<>();

    /**
     * No-arg constructor: attach a listener that keeps its own counts of
     * registrations per course+section by observing the EV_REGISTER_STUDENT
     * events. This does not rely on accessing the in-memory DataBase from
     * SystemMain and therefore works without modifying SystemMain.
     */
    public Overbooked() {
        EventBus.subscribeTo(EventBus.EV_REGISTER_STUDENT, new Observer() {
            @Override
            public void update(Observable o, Object arg) {
                if (arg == null) return;
                String[] parts = arg.toString().split("\\s+");
                if (parts.length < 3) return;
                String sCID = parts[1];
                String sSection = parts[2];
                String key = sCID + "-" + sSection;
                int newCount = counts.merge(key, 1, Integer::sum);
                System.out.println("Course " + sCID + " section " + sSection + " has " + newCount + " students");
            }
        });
    }
    /**
     * Construct a listener that subscribes to registration events using the
     * given shared database instance. This avoids re-initializing the
     * EventBus when the system is started via SystemMain.
     */
    public Overbooked(final DataBase db) {
        // Listen to registrations
        EventBus.subscribeTo(EventBus.EV_REGISTER_STUDENT, new Observer() {
            @Override
            public void update(Observable o, Object arg) {
                System.out.println("balls");
                String[] parts = arg.toString().split("\\s+");
                if (parts.length < 3) return;
                String sCID = parts[1];
                String sSection = parts[2];

                Course c = db.getCourseRecord(sCID, sSection);
                if (c != null) {
                    int count = c.getRegisteredStudents().size();
                    System.out.println("Course " + sCID + " section " + sSection + " has " + count + " students");
                }
            }
        });
    }

    public static void main(String[] args) throws FileNotFoundException, IOException {
        // Standalone mode: initialize bus and database then attach listener
        EventBus.initialize();
        DataBase db = new DataBase("bin/Students.txt", "bin/Courses.txt");
        new Overbooked(db);
    }
}