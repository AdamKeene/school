## Changes

The only class which required changing from the example to suit the new system was the sink filter, as the data processing logic remains the same until the data is recorded. Instead of recording only the temperature, the system also records time, velocity, altitude, and pressure.

## Functionality

System A implements a pipe-and-filter architecture to process flight data. The system incorporates three filters: SourceFilter which reads raw flight data, MiddleFilter which reads altitude changes, smooths large jumps, and logs altered data in WildPoints.csv, and SinkFilter which records the data in OutputA.csv with asterisk tags on altered altitude data. The data processing pipeline is orchestrated by the Plumber class, which starts the filters and connects them to each other. These filters get their real time data processing functionality from the FilterFramework class, which enables the Plumber to connect to, send data to, and read data from them.

## Usage

In order to run the system, the Plumber class must be run from the System_B directory. Input data must be named "FlightData.dat". 