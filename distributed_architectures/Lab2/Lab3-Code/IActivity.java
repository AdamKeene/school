
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface IActivity extends Remote {
    void execute(String activity) throws RemoteException;
}