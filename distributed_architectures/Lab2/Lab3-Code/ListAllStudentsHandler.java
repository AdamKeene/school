/**
 * @(#)ListAllStudentsHandler.java
 *
 * Copyright: Copyright (c) 2003,2004 Carnegie Mellon University
 *
 */

import java.rmi.RemoteException;
import java.util.ArrayList;

/**
 * "List all students" command event handler.
 */
public class ListAllStudentsHandler extends CommandEventHandler {

    /**
     * Construct "List all students" command event handler.
     *
     * @param objDataBase reference to the remote database object
     * @param iCommandEvCode command event code to receive the commands to process
     * @param iOutputEvCode output event code to send the command processing result
     */
    public ListAllStudentsHandler(DBInterface objDataBase, int iCommandEvCode, int iOutputEvCode) {
        super(objDataBase, iCommandEvCode, iOutputEvCode);
    }

    /**
     * Process "List all students" command event.
     *
     * @param param a string parameter for command
     * @return a string result of command processing
     */
    protected String execute(String param) {
        try {
            // Get all student records from remote database.
            ArrayList vStudent = this.objDataBase.getAllStudentRecords();

            // Construct a list of student information and return it.
            String sReturn = "";
            for (int i=0; i<vStudent.size(); i++) {
                sReturn += (i == 0 ? "" : "\n") + ((Student) vStudent.get(i)).toString();
            }
            return sReturn;
        } catch (RemoteException e) {
            return "Error retrieving student records: " + e.getMessage();
        }
    }
}
