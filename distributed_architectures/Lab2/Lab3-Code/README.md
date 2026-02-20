# Lab3

## Changes:

Lab 3 was changed to use an RMI architecture. The command handlers are now hosted on the server as IActivity services on port 1100, and the database managed by Database.java is now a remote database on port 1099. The ClientInput and ClientOutput classes were consolidated into one Client class responsible for invoking remote activities for the client machine. DBInterface was reworked to handle remote DB operations, and logging is now handled client-side in the Client class.

## How to Run

This project requires three terminals to run: the client, server, and database.

### Compile
```bash
javac *.java
```

### On the database server:
```bash
java Database
```

### On the server:
```bash
java Server
```

### On the client machine:
```bash
java Client
```
