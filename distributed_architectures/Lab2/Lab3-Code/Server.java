import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * RMI Server that hosts the remote DataBase and registers it in the RMI Registry.
 */
public class Server {
    public static void main(String[] args) {
        String studentFileName, courseFileName;
        
        // Check the number of parameters.
        if (args.length == 2) {
            studentFileName = args[0];
            courseFileName = args[1];
        } else {
            studentFileName = "Students.txt";
            courseFileName = "Courses.txt";
        }

        // Check if input files exist.
        if (!new File(studentFileName).exists()) {
            System.err.println("Could not find " + studentFileName);
            System.exit(1);
        }
        if (!new File(courseFileName).exists()) {
            System.err.println("Could not find " + courseFileName);
            System.exit(1);
        }

        try {
            // Create the DataBase instance
            DataBase db = new DataBase(studentFileName, courseFileName);
            
            // Get or create the RMI Registry on port 1099
            Registry registry;
            try {
                registry = LocateRegistry.getRegistry(1099);
                registry.list(); // Verify registry exists
            } catch (RemoteException e) {
                // Registry doesn't exist, create it
                System.out.println("Creating RMI Registry on port 1099...");
                registry = LocateRegistry.createRegistry(1099);
            }
            
            // Bind the DataBase to the registry under the name "RegistrationDB"
            registry.rebind("RegistrationDB", db);
            
            System.out.println("Server started. DataBase bound to registry as 'RegistrationDB'");
            System.out.println("Waiting for client connections...");
            
        } catch (FileNotFoundException e) {
            System.err.println("File not found: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        } catch (IOException e) {
            System.err.println("IOException: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
