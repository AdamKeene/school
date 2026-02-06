import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Observable;
import java.util.Observer;

@SuppressWarnings("deprecation")
public class Logger {

    private static PrintWriter logFile;

    private static String getCurrentTime() {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
        return LocalDateTime.now().format(formatter);
    }

    private static class EventLogger implements Observer {
        private final String name;

        EventLogger(String name) {
            this.name = name;
        }

        // log events to log file
        @Override
        public void update(Observable o, Object arg) {
            String logMessage = "[" + getCurrentTime() + "] " + name + " : " + arg;
            if (logFile != null) {
                logFile.println(logMessage);
                logFile.flush();
            }
        }
    }

    public void initialize() {
        // initialize log file
        try {
            logFile = new PrintWriter(new FileWriter("system.log", true), true);
        } catch (IOException e) {
            System.err.println("Failed to open log file: " + e.getMessage());
        }
        
        // subscribe to events
        EventBus.subscribeTo(EventBus.EV_LIST_ALL_STUDENTS,
            new EventLogger("EV_LIST_ALL_STUDENTS"));
        EventBus.subscribeTo(EventBus.EV_LIST_ALL_COURSES,
            new EventLogger("EV_LIST_ALL_COURSES"));
        EventBus.subscribeTo(EventBus.EV_LIST_STUDENTS_REGISTERED,
            new EventLogger("EV_LIST_STUDENTS_REGISTERED"));
        EventBus.subscribeTo(EventBus.EV_LIST_COURSES_REGISTERED,
            new EventLogger("EV_LIST_COURSES_REGISTERED"));
        EventBus.subscribeTo(EventBus.EV_LIST_COURSES_COMPLETED,
            new EventLogger("EV_LIST_COURSES_COMPLETED"));
        EventBus.subscribeTo(EventBus.EV_REGISTER_STUDENT,
            new EventLogger("EV_REGISTER_STUDENT"));
        EventBus.subscribeTo(EventBus.EV_SHOW,
            new EventLogger("EV_SHOW"));
    }
}