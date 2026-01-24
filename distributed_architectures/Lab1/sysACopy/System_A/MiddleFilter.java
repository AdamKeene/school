import java.io.PrintWriter;
import java.util.List;

/******************************************************************************************************************
* File:MiddleFilter.java
* Project: Lab 1
* Copyright:
*   Copyright (c) 2020 University of California, Irvine
*   Copyright (c) 2003 Carnegie Mellon University
* Versions:
*   1.1 January 2020 - Revision for SWE 264P: Distributed Software Architecture, Winter 2020, UC Irvine.
*   1.0 November 2008 - Sample Pipe and Filter code (ajl).
*
* Description:
* This class serves as an example for how to use the FilterRemplate to create a standard filter. This particular
* example is a simple "pass-through" filter that reads data from the filter's input port and writes data out the
* filter's output port.
* Parameters: None
* Internal Methods: None
******************************************************************************************************************/

public class MiddleFilter extends FilterFramework
{
	private static final double JUMP_THRESHOLD = 100.0;
	private static final int ID_LENGTH = 4;
	private static final int MEASUREMENT_LENGTH = 8;
	private int frameCount = 0;
	private double prevAltitude = 0.0;
	private double thirdAltitude = 0.0;
	

	public void run()
    {
		int bytesread = 0;
		int byteswritten = 0;
		byte databyte = 0;
		int id = 0;
		long measurement = 0;
		int i;

		PrintWriter wildPointsWriter = null;
		try {
			wildPointsWriter = new PrintWriter("WildPoints.csv");
		} catch (Exception e) {
			System.out.println("Error opening WildPointsA.csv: " + e);
			wildPointsWriter.close();
			return;
		}

		System.out.print( "\n" + this.getName() + "::Middle Reading ");

		while (true)
		{
			try
			{
				// Read ID (4 bytes)
				byte[] idBytes = new byte[ID_LENGTH];
				id = 0;
				for (i = 0; i < ID_LENGTH; i++) {
					idBytes[i] = ReadFilterInputPort();
					id = id | (idBytes[i] & 0xFF);
					if (i != ID_LENGTH - 1) {
						id = id << 8;
					}
					bytesread++;
				}

				// Read Measurement (8 bytes)
				byte[] measurementBytes = new byte[MEASUREMENT_LENGTH];
				measurement = 0;
				for (i = 0; i < MEASUREMENT_LENGTH; i++) {
					measurementBytes[i] = ReadFilterInputPort();
					measurement = measurement | (measurementBytes[i] & 0xFF);
					if (i != MEASUREMENT_LENGTH - 1) {
						measurement = measurement << 8;
					}
					bytesread++;
				}

				// Process altitude if this is ID 2
				byte altitudeAltered = 0;
				if (id == 2) {
					double altitude = Double.longBitsToDouble(measurement);
					double originalAltitude = altitude;  // Save the original wild jump value
					frameCount++;

					// Detect altitude changes greater than JUMP_THRESHOLD
					double altitudeChange = Math.abs(altitude - prevAltitude);
					if (frameCount > 1 && altitudeChange > JUMP_THRESHOLD) {
						if (frameCount == 2) {
							altitude = prevAltitude;
						} else {
							altitude = (prevAltitude + thirdAltitude) / 2.0;
						}
						wildPointsWriter.println(String.format("%.5f", originalAltitude));
						altitudeAltered = 1;

						// Convert smoothed altitude back to bytes
						long smoothedMeasurement = Double.doubleToLongBits(altitude);
						for (i = 0; i < MEASUREMENT_LENGTH; i++) {
							measurementBytes[MEASUREMENT_LENGTH - 1 - i] = (byte)((smoothedMeasurement >>> (i * 8)) & 0xFF);
						}
					}
					
					thirdAltitude = prevAltitude;
					prevAltitude = altitude;
				}

				// Write ID
				for (i = 0; i < ID_LENGTH; i++) {
					WriteFilterOutputPort(idBytes[i]);
					byteswritten++;
				}

				// Write Measurement
				for (i = 0; i < MEASUREMENT_LENGTH; i++) {
					WriteFilterOutputPort(measurementBytes[i]);
					byteswritten++;
				}

				// Write the flag byte only for altitude (ID 2)
				if (id == 2) {
					WriteFilterOutputPort(altitudeAltered);
					byteswritten++;
				}
			}
			catch (EndOfStreamException e)
			{
				ClosePorts();
				wildPointsWriter.close();
				System.out.print( "\n" + this.getName() + "::Middle Exiting; bytes read: " + bytesread + " bytes written: " + byteswritten );
				break;
			}
		}
   }
}