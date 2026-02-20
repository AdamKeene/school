
import java.rmi.Remote;
import java.rmi.RemoteException;

public interface IActivity extends Remote {
    String execute(String activity) throws RemoteException;
}