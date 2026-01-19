## Changes

The only class which required changing from the example to suit the new system was the sink filter, as the data processing logic remains the same until the data is recorded. Instead of recording only the temperature, the system also records time, velocity, altitude, and pressure.

## Functionality

System A implements a pipe-and-filter architecture to process flight data. The system incorporates three filters: SourceFilter which reads raw flight data, MiddleFilter which is a simple pass-through filter which can be modified to process data, and SinkFilter which records the data in OutputA.csv. The data processing pipeline is orchestrated by the Plumber class, which starts the filters and connects them to each other. These filters get their real time data processing functionality from the FilterFramework class, which enables the Plumber to connect to, send data to, and read data from them.