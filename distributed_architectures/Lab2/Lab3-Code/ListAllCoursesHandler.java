/**
 * @(#)ListAllCoursesHandler.java
 *
 * Copyright: Copyright (c) 2003,2004 Carnegie Mellon University
 *
 */

import java.rmi.RemoteException;
import java.util.ArrayList;

/**
 * "List all courses" command event handler.
 */
public class ListAllCoursesHandler extends CommandEventHandler {

    /**
     * Construct "List all courses" command event handler.
     *
     * @param objDataBase reference to the remote database object
     * @param iCommandEvCode command event code to receive the commands to process
     * @param iOutputEvCode output event code to send the command processing result
     */
    public ListAllCoursesHandler(DBInterface objDataBase, int iCommandEvCode, int iOutputEvCode) {
        super(objDataBase, iCommandEvCode, iOutputEvCode);
    }

    /**
     * Process "List all courses" command event.
     *
     * @param param a string parameter for command
     * @return a string result of command processing
     */
    protected String execute(String param) {
        try {
            // Get all course records from remote database.
            ArrayList vCourse = this.objDataBase.getAllCourseRecords();

            // Construct a list of course information and return it.
            String sReturn = "";
            for (int i=0; i<vCourse.size(); i++) {
                sReturn += (i == 0 ? "" : "\n") + ((Course) vCourse.get(i)).toString();
            }
            return sReturn;
        } catch (RemoteException e) {
            return "Error retrieving course records: " + e.getMessage();
        }
    }
}
