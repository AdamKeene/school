# Changes

Three changes were made to the system: A logging component LoggerHandler was added to write logs to system.log, the component OverbookedHandler was added to detect when a student registers to a fully booked course (does not block registration), and the course conflict checking component of the RegisterStudentHandler component was separated into the new component RegistrationConflictHandler.

## Logger

The LoggerHandler simply subscribes to all events in the event bus and writes the result to the log file along with the time.

## Overbooked Handler

The OverbookedHandler is initialized with its own event type in SystemMain and the event bus in the same way as the rest of the components. The event is sent by the registration handler after a new student is registered, and after receiving the event the overbooked handler compares the number of students registered to the course, printing an alert to the console if there is a conflict. This component could alternatively listen for the registration handler event and check for one less than the limit, but assuming the overbooked handler retrieves the registered students faster than the registration handler updates it could potentially be prone to issues, even though in theory it should work. Waiting until the registration event is complete is a simpler and more reliable approach.

## Conflict Handler

The conflict handler also gets its own event type, and the client input component now sends that event when the user requests to register for a class instead of the registration event. If there is no conflict it sends the registration event directly from the conflict handler class. It would be possible to have the registration handler send the data and wait for a response before registering, but this approach would be both more complex and in my opinion less in the spirit of the implicit invocation architecture. Since the registration and conflict handlers are dependent on each other, it makes more sense to have a chain of events in sequence.

## Running the System

After unzipping the file and navigatin to the Lab2-Code directory, the project can be run using the following 2 commands:

```java
javac *.java

java SystemMain Students.txt Courses.txt
```