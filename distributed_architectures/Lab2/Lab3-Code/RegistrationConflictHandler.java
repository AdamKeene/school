/**
 * @(#)RegistrationConflictHandler.java
 *
 * Copyright: Copyright (c) 2003,2004 Carnegie Mellon University
 *
 */

import java.rmi.RemoteException;
import java.util.StringTokenizer;

/**
 * "Registration conflict" event handler.
 * Handles event triggered when a registration conflicts with another course already registered.
 */
public class RegistrationConflictHandler extends CommandEventHandler {

    /**
     * Construct "Registration conflict" event handler.
     *
     * @param objDataBase reference to the remote database object
     * @param iCommandEvCode command event code to receive the events to process
     * @param iOutputEvCode output event code to send the event processing result
     */
    public RegistrationConflictHandler(DBInterface objDataBase, int iCommandEvCode, int iOutputEvCode) {
        super(objDataBase, iCommandEvCode, iOutputEvCode);
    }

    /**
     * Process "Registration conflict" event.
     *
     * @param param a string parameter for the event
     * @return a string result of the event processing
     */
    protected String execute(String param) {
        try {
            // Get the student and course records.
            StringTokenizer objTokenizer = new StringTokenizer(param);
            String sSID     = objTokenizer.nextToken();
            String sCID     = objTokenizer.nextToken();
            String sSection = objTokenizer.nextToken();
            
            Student objStudent = this.objDataBase.getStudentRecord(sSID);
            Course objCourse = this.objDataBase.getCourseRecord(sCID, sSection);       

            // Check if the given course conflicts with any of the student's registered courses
            java.util.ArrayList vCourse = objStudent.getRegisteredCourses();
            for (int i=0; i<vCourse.size(); i++) {
                if (((Course) vCourse.get(i)).conflicts(objCourse)) {
                    return "Registration conflicts";
                }
            }
            // No conflict, proceed to register
            EventBus.announce(EventBus.EV_REGISTER_STUDENT, param);
            return "";
        } catch (RemoteException e) {
            return "Error checking for registration conflict: " + e.getMessage();
        }
    }
}
