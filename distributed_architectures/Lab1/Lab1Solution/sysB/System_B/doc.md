## Changes

Altitude changes are read by the middle filter and smoothed when necessary. Data is sent with a new flag tracking wether the data was altered or not, and if data is altered the sink filter adds an asterisk to the end of the altitude data. In addition, the middle filter sends data with an ID of 5 to the sink filter which records data to WildPoints.csv.

## Functionality

System A implements a pipe-and-filter architecture to process flight data. The system incorporates three filters: SourceFilter which reads raw flight data, MiddleFilter which reads altitude changes and smooths large jumps, and SinkFilter which records the smoothed points in WildPoints.csv and flight data in OutputA.csv with asterisk tags on altered altitude data. The data processing pipeline is orchestrated by the Plumber class, which starts the filters and connects them to each other. These filters get their real time data processing functionality from the FilterFramework class, which enables the Plumber to connect to, send data to, and read data from them.

## Usage

In order to run the program, the Plumber class must be run from the System_B directory and input data must be named "FlightData.dat". Start the system using the following commands:

```java
javac *.java
java Plumber
```
