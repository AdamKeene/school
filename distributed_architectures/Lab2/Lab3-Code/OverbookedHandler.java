/**
 * @(#)OverbookedHandler.java
 *
 * Copyright: Copyright (c) 2003,2004 Carnegie Mellon University
 *
 */

import java.rmi.RemoteException;
import java.util.StringTokenizer;

/**
 * "Overbooked course" event handler.
 * Handles event triggered when a course has more registered students than its capacity.
 */
public class OverbookedHandler extends CommandEventHandler {

    /**
     * Construct "Overbooked course" event handler.
     *
     * @param objDataBase reference to the remote database object
     * @param iCommandEvCode command event code to receive the events to process
     * @param iOutputEvCode output event code to send the event processing result
     */
    public OverbookedHandler(DBInterface objDataBase, int iCommandEvCode, int iOutputEvCode) {
        super(objDataBase, iCommandEvCode, iOutputEvCode);
    }

    /**
     * Process "Overbooked course" event.
     *
     * @param param a string parameter for the event
     * @return a string result of the event processing
     */
    protected String execute(String param) {
        try {
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
                if (count > 3) {
                    return "Course " + sCID + " section " + sSection + " is overbooked: " + count + " students";
                }
            }
            return "";
        } catch (RemoteException e) {
            return "Error checking course capacity: " + e.getMessage();
        }
    }
}
