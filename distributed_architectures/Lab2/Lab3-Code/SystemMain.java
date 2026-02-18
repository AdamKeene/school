

/**
 * @(#)SystemMain.java
 *
 * Copyright: Copyright (c) 2003,2004 Carnegie Mellon University
 *
 */

import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * Class to hold system main method. Connects to remote DataBase and starts the system with
 * event-based implicit invocation architecture.
 */
class SystemMain {

	/**
	 * Connects to the remote DataBase server and starts the client with event-based handlers.
	 *
	 * @param args array of input parameters (not used for client)
	 */
	public static void main(String args[]) {
		try {
			// Initialize event bus.
			EventBus.initialize();

			// Look up the remote DataBase from the RMI Registry
			Registry registry = LocateRegistry.getRegistry("localhost", 1099);
			DBInterface db = (DBInterface) registry.lookup("RegistrationDB");
			System.out.println("Connected to remote DataBase\n");

			// Create event handlers with the remote database reference
			ListAllStudentsHandler objCommandEventHandler1 =
				new ListAllStudentsHandler(
					db,
					EventBus.EV_LIST_ALL_STUDENTS,
					EventBus.EV_SHOW);
			ListAllCoursesHandler objCommandEventHandler2 =
				new ListAllCoursesHandler(
					db,
					EventBus.EV_LIST_ALL_COURSES,
					EventBus.EV_SHOW);
			ListStudentsRegisteredHandler objCommandEventHandler3 =
				new ListStudentsRegisteredHandler(
					db,
					EventBus.EV_LIST_STUDENTS_REGISTERED,
					EventBus.EV_SHOW);
			ListCoursesRegisteredHandler objCommandEventHandler4 =
				new ListCoursesRegisteredHandler(
					db,
					EventBus.EV_LIST_COURSES_REGISTERED,
					EventBus.EV_SHOW);
			ListCoursesCompletedHandler objCommandEventHandler5 =
				new ListCoursesCompletedHandler(
					db,
					EventBus.EV_LIST_COURSES_COMPLETED,
					EventBus.EV_SHOW);
			RegisterStudentHandler objCommandEventHandler6 =
				new RegisterStudentHandler(
					db,
					EventBus.EV_REGISTER_STUDENT,
					EventBus.EV_SHOW);
			LoggerHandler objCommandEventHandler7 =
				new LoggerHandler(
					db,
					EventBus.EV_LOGGER,
					EventBus.EV_SHOW);
			OverbookedHandler objCommandEventHandler8 =
				new OverbookedHandler(
					db,
					EventBus.EV_OVERBOOKED,
					EventBus.EV_SHOW);
			RegistrationConflictHandler objCommandEventHandler9 =
				new RegistrationConflictHandler(
					db,
					EventBus.EV_REGISTRATION_CONFLICT,
					EventBus.EV_SHOW);

			// Create client interface components
			ClientInput objClientInput = new ClientInput();
			ClientOutput objClientOutput = new ClientOutput();

			// Start the system.
			objClientInput.start();
		} catch (RemoteException e) {
			System.err.println("Error: Could not reach RMI registry. Make sure the server is running.");
			e.printStackTrace();
			System.exit(1);
		} catch (NotBoundException e) {
			System.err.println("Error: Could not find remote DataBase. Make sure the server is running.");
			e.printStackTrace();
			System.exit(1);
		}
	}
}
