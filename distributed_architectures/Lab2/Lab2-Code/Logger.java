import java.util.Observable;
import java.util.Observer;

public class Logger implements Observer { 

    @Override
    public void update(Observable o, Object o1) {
        throw new UnsupportedOperationException("Not supported yet.");
    }
// Implement Observer
    @SuppressWarnings("deprecation")
    private class LoggerObserver {
        private int eventCode;
        private String eventName;
        
        public LoggerObserver(int eventCode, String eventName) {
            this.eventCode = eventCode;
            this.eventName = eventName;
        }
        
        public void update(Observable o, Object arg) {
            // Now we know which event this is!
            System.out.println("Event '" + eventName + "' (code: " + eventCode + 
                             ") fired with data: " + arg);
        }
    }
    
    public void initialize() {
        EventBus.subscribeTo(EventBus.EV_LIST_ALL_STUDENTS, this);
        EventBus.subscribeTo(EventBus.EV_LIST_ALL_COURSES, this);
        EventBus.subscribeTo(EventBus.EV_LIST_STUDENTS_REGISTERED, this);
        EventBus.subscribeTo(EventBus.EV_LIST_COURSES_REGISTERED, this);
        EventBus.subscribeTo(EventBus.EV_LIST_COURSES_COMPLETED, this);
        EventBus.subscribeTo(EventBus.EV_REGISTER_STUDENT, this);
    }

}