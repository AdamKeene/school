/******************************************************************************************************************
* File:MiddleFilter.java
* Project: Lab 1
*
* Description:
* This class reas from the input port, detects and smooths wild jumps in altitude data, and writes to the output port.
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
		int id = 0;
		long measurement = 0;
		int i;

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

					// Detect wild jumps and smooth data when necessary
					double altitudeChange = Math.abs(altitude - prevAltitude);
					if (frameCount > 1 && altitudeChange > JUMP_THRESHOLD) {
						if (frameCount == 2) {
							altitude = prevAltitude;
						} else {
							altitude = (prevAltitude + thirdAltitude) / 2.0;
						}
						altitudeAltered = 1;

						// Send wild point data through pipe with ID=5
						int wildId = 5;
						long wildMeasurement = Double.doubleToLongBits(originalAltitude);
						byte[] wildIdBytes = new byte[ID_LENGTH];
						for (i = 0; i < ID_LENGTH; i++) {
							wildIdBytes[ID_LENGTH - 1 - i] = (byte)((wildId >>> (i * 8)) & 0xFF);
						}
						for (i = 0; i < ID_LENGTH; i++) {
							WriteFilterOutputPort(wildIdBytes[i]);
							byteswritten++;
						}
						byte[] wildMeasurementBytes = new byte[MEASUREMENT_LENGTH];
						for (i = 0; i < MEASUREMENT_LENGTH; i++) {
							wildMeasurementBytes[MEASUREMENT_LENGTH - 1 - i] = (byte)((wildMeasurement >>> (i * 8)) & 0xFF);
						}
						for (i = 0; i < MEASUREMENT_LENGTH; i++) {
							WriteFilterOutputPort(wildMeasurementBytes[i]);
							byteswritten++;
						}

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

			// Close points and writer
			catch (EndOfStreamException e)
			{
				ClosePorts();
				System.out.print( "\n" + this.getName() + "::Middle Exiting; bytes read: " + bytesread + " bytes written: " + byteswritten );
				break;
			}
		}
   }
}