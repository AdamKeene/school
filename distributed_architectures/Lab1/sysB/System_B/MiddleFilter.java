import java.io.PrintWriter;

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
    private PrintWriter wildJumpWriter;
	private static final double JUMP_THRESHOLD = 100.0;
	private static final int ALTITUDE_START = 33;
	private static final int ALTITUDE_LENGTH = 8;
	private static final int TOTAL_LENGTH = 59;
	private int frameCount = 0;

	public void run()
    {
		byte[] buffer = new byte[TOTAL_LENGTH];
		int bytesread = 0;					// Number of bytes read from the input file.
		int byteswritten = 0;				// Number of bytes written to the stream.
		byte databyte = 0;					// The byte of data read from the file

        try {
            wildJumpWriter = new PrintWriter(new java.io.FileWriter("WildPoints.csv", true));
            wildJumpWriter.flush();
        } catch (java.io.IOException e) {
            System.out.println("Error opening WildPoints.csv: " + e.getMessage());
        }

		// Next we write a message to the terminal to let the world know we are alive...
		System.out.print( "\n" + this.getName() + "::Middle Reading ");

		boolean replaced = false;
		double currentAltitude = Double.NaN;
		double prevAltitude = Double.NaN;
		double thirdAltitude = Double.NaN;

		while (true)
		{
			// Here we read a byte and write a byte
			try
			{
				for (int i = 0; i < TOTAL_LENGTH; i++) {
					buffer[i] = ReadFilterInputPort();
				}
				bytesread += TOTAL_LENGTH;
				currentAltitude = Double.parseDouble(new String(buffer, ALTITUDE_START, ALTITUDE_LENGTH));
				if (frameCount == 0) {
					prevAltitude = currentAltitude;
				} else {
					double diff = Math.abs(currentAltitude - thirdAltitude);
					if (diff > JUMP_THRESHOLD) {
						wildJumpWriter.write(new String(buffer));
						wildJumpWriter.println();
						wildJumpWriter.flush();
						if (frameCount == 1) {
							currentAltitude = prevAltitude;
						} else {
							currentAltitude = (prevAltitude + thirdAltitude) / 2.0;
						}
						replaced = true;
					}
					thirdAltitude = prevAltitude;
				}
				prevAltitude = currentAltitude;
				frameCount++;
				if (replaced) {
					String altitudeStr = String.format("%8.5f", currentAltitude);
					byte[] altitudeBytes = altitudeStr.getBytes();
					System.arraycopy(altitudeBytes, 0, buffer, ALTITUDE_START, ALTITUDE_LENGTH);
					replaced = false;
				}
				WriteFilterOutputPort(databyte);
			}
			catch (EndOfStreamException e)
			{
				ClosePorts();
				System.out.print( "\n" + this.getName() + "::Middle Exiting; bytes read: " + bytesread + " bytes written: " + byteswritten );
				break;
			}
		}
   }
}