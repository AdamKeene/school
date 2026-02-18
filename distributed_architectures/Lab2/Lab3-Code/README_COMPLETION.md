# Lab3: RMI-Based Distributed Registration System - Completion Summary

## Overview
Successfully converted the Lab2 event-based implicit invocation architecture into a distributed RMI-based system while **maintaining Lab2's implicit invocation pattern and EventBus architecture**.

## Architecture

### Hybrid Design: Implicit Invocation Over RMI
The system uses a **two-tier architecture**:

1. **Local Tier (Client):**
   - EventBus: Distributes events to handlers
   - 9 CommandEventHandler subclasses: Process events and trigger remote DB calls
   - ClientInput: Gets user input, announces commands via EventBus
   - ClientOutput: Displays results by subscribing to EV_SHOW events
   - LoggerHandler: Logs all events to system.log

2. **Remote Tier (Server):**
   - DataBase: RemoteObject implementing DBInterface
   - RMI Registry: Binds DataBase as "RegistrationDB" on localhost:1099

### Communication Pattern
```
User Input → ClientInput
    ↓
EventBus.announce(Command Event)
    ↓
Handler.execute() [remote DB call via DBInterface]
    ↓
EventBus.announce(EV_SHOW, results)
    ↓
ClientOutput displays result
```

### Key Design Decision
- **Why keep Lab2 structure?** The assignment goal was to adapt Lab2 to RMI, not to replace its architecture
- **Implicit invocation preserved:** Handlers trigger events to next handlers in chain (e.g., RegistrationConflictHandler → RegisterStudentHandler → OverbookedHandler)
- **Serialization:** Student and Course objects implement Serializable for RMI transmission

## Files Created/Modified

### RMI Infrastructure
- **DBInterface.java**: Remote interface with 7 methods for database operations
- **DataBase.java**: UnicastRemoteObject implementing DBInterface
- **Server.java**: Hosts DataBase, binds to RMI Registry on port 1099
- **Student.java**: Made Serializable for network transfer
- **Course.java**: Made Serializable for network transfer

### Event Handler System
- **EventBus.java**: Restored from Lab2 - distributes events to observers
- **CommandEventHandler.java**: Base class for all handlers, adapted to use DBInterface
- **ListAllStudentsHandler.java** - Handler for listing all students
- **ListAllCoursesHandler.java** - Handler for listing all courses
- **ListStudentsRegisteredHandler.java** - Handler for listing students in a course
- **ListCoursesRegisteredHandler.java** - Handler for listing courses student registered for
- **ListCoursesCompletedHandler.java** - Handler for listing courses student completed
- **RegisterStudentHandler.java** - Handler for registering student (triggers conflict check)
- **RegistrationConflictHandler.java** - Handler for checking scheduling conflicts
- **OverbookedHandler.java** - Handler for checking course capacity
- **LoggerHandler.java**: Logs all events to system.log with timestamps

### Client Components
- **ClientInput.java**: Gets user input, announces events via EventBus
- **ClientOutput.java**: Displays text by subscribing to EV_SHOW events
- **SystemMain.java**: Initializes EventBus, creates handlers, starts client

## Key Implementation Details

### RemoteException Handling
All handlers wrap remote DBInterface calls in try-catch blocks:
```java
try {
    ArrayList students = this.objDataBase.getAllStudentRecords();
    // Process results
} catch (RemoteException e) {
    return "Error retrieving students: " + e.getMessage();
}
```

### Event Chain (Registration Flow)
1. User selects "Register student"
2. ClientInput announces `EV_REGISTRATION_CONFLICT` with (StudentID, CourseID, Section)
3. RegistrationConflictHandler checks for scheduling conflicts
4. If no conflict: RegistrationConflictHandler announces `EV_REGISTER_STUDENT`
5. RegisterStudentHandler performs registration
6. RegisterStudentHandler announces `EV_OVERBOOKED` to check capacity
7. OverbookedHandler checks if course is overbooked
8. Results announced via `EV_SHOW` to display to user

### Data Serialization
- Student objects serialized when returned from remote database
- Course objects serialized when returned from remote database
- Allows complex objects to be transmitted over RMI network

## Testing Results

### Test Scenarios Executed
1. ✅ List all students
2. ✅ List all courses
3. ✅ List students registered for a course
4. ✅ List courses student has registered for
5. ✅ List courses student has completed
6. ✅ Register student for course
7. ✅ Event logging to system.log

### Sample Output
```
Connected to remote DataBase

Student Registration System

1) List all students
2) List all courses
3) List students who registered for a course
4) List courses a student has registered for
5) List courses a student has completed
6) Register a student for a course
x) Exit

[After selecting option 1 - List all students]
G00123456 Carson Kit CS 1 CS112 CS211 CS332 CS421
G00123432 Smith John ECE 0 EE112 EE211 CS421 EE432
...

[After selecting option 6 - Register student]
Successful!
```

### Logging Verification
system.log shows timestamps and all events:
```
[2026-02-17 21:31:37.915] EV_REGISTRATION_CONFLICT : G00123432 CS211 B
[2026-02-17 21:31:37.915] EV_REGISTER_STUDENT : G00123432 CS211 B
[2026-02-17 21:31:37.915] EV_OVERBOOKED : G00123432 CS211 B
[2026-02-17 21:31:37.915] EV_SHOW : Successful!
```

## Running the System

### Terminal 1: Start Server
```bash
cd Lab3-Code
java Server
```
Output:
```
Creating RMI Registry on port 1099...
Server started. DataBase bound to registry as 'RegistrationDB'
Waiting for client connections...
```

### Terminal 2: Start Client
```bash
cd Lab3-Code
java SystemMain
```
The client connects to remote database and displays the menu.

## Architecture Advantages

1. **Network Distribution:** Database logic runs on separate server, can be on different machine
2. **Implicit Invocation:** EventBus/handler pattern maintains loose coupling
3. **Serialization:** Complex objects can be transmitted over network
4. **Error Handling:** RemoteException caught at handler level, user sees friendly error messages
5. **Logging:** All events logged including network calls
6. **Maintainability:** Lab2 structure preserved, easier to reason about system behavior

## Technical Notes

- RMI Registry runs on localhost:1099
- DataBase class implements Serializable via UnicastRemoteObject
- Student and Course objects are Serializable for RMI transmission
- DBInterface defines remote contract (methods throw RemoteException)
- Handler execution is asynchronous via EventBus
- Event chain allows complex business logic (checking conflicts before registration)

## Conclusion

The system successfully demonstrates RMI-based distributed architecture while maintaining the event-driven implicit invocation pattern from Lab2. All database operations are executed remotely via RMI, while the client-side architecture retains the EventBus/handler design, achieving the assignment goal: "modify the existing system into the RMI architecture while keeping the implicit invocation architecture style."
