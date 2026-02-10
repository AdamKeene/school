import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Observable;
import java.util.Observer;

@SuppressWarnings("deprecation")
public class LoggerHandler extends CommandEventHandler {

    private static PrintWriter logFile;

    /**
     * Construct logging handler.
     *
     * @param objDataBase reference to the database object
     * @param iCommandEvCode command event code to receive the commands to process
     * @param iOutputEvCode output event code to send the command processing result
     */
    public LoggerHandler(DataBase objDataBase, int iCommandEvCode, int iOutputEvCode) {
        super(objDataBase, iCommandEvCode, iOutputEvCode);

        // initialize log file
        try {
            logFile = new PrintWriter(new FileWriter("system.log", true), true);
        } catch (IOException e) {
            System.err.println("Failed to open log file: " + e.getMessage());
        }
        subscribeToAllEvents();
    }

    private static String getCurrentTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        return LocalDateTime.now().format(formatter);
    }

    // listen for all events
    private void subscribeToAllEvents() {
        EventBus.subscribeTo(EventBus.EV_LIST_ALL_STUDENTS, new EventLogger("EV_LIST_ALL_STUDENTS"));
        EventBus.subscribeTo(EventBus.EV_LIST_ALL_COURSES, new EventLogger("EV_LIST_ALL_COURSES"));
        EventBus.subscribeTo(EventBus.EV_LIST_STUDENTS_REGISTERED, new EventLogger("EV_LIST_STUDENTS_REGISTERED"));
        EventBus.subscribeTo(EventBus.EV_LIST_COURSES_REGISTERED, new EventLogger("EV_LIST_COURSES_REGISTERED"));
        EventBus.subscribeTo(EventBus.EV_LIST_COURSES_COMPLETED, new EventLogger("EV_LIST_COURSES_COMPLETED"));
        EventBus.subscribeTo(EventBus.EV_REGISTER_STUDENT, new EventLogger("EV_REGISTER_STUDENT"));
        EventBus.subscribeTo(EventBus.EV_SHOW, new EventLogger("EV_SHOW"));
        EventBus.subscribeTo(EventBus.EV_OVERBOOKED, new EventLogger("EV_OVERBOOKED"));
        EventBus.subscribeTo(EventBus.EV_REGISTRATION_CONFLICT, new EventLogger("EV_REGISTRATION_CONFLICT"));
    }

    @Override
    protected String execute(String param) {
        String logMessage = "[" + getCurrentTime() + "] EV_LOGGER : " + param;
        if (logFile != null) {
            logFile.println(logMessage);
            logFile.flush();
        } else {
            System.err.println(logMessage);
        }
        return "";
    }

    // logger
    private static class EventLogger implements Observer {
        private final String name;

        // initialize logger
        EventLogger(String name) {
            this.name = name;
        }
        
        // write to log file
        @Override
        public void update(Observable o, Object arg) {
            String logMessage = "[" + getCurrentTime() + "] " + name + " : " + arg;
            if (logFile != null) {
                logFile.println(logMessage);
                logFile.flush();
            }
        }
    }
}