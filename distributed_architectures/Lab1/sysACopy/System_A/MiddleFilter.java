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
	private PrintWriter wildJumpWriter;
	private static final double JUMP_THRESHOLD = 100.0;
	private static final int ALTITUDE_START = 33;
	private static final int ALTITUDE_LENGTH = 8;
	private static final int TOTAL_LENGTH = 59;
	private int frameCount = 0;

	public void run()
    {
		byte[] buffer = new byte[59];
		int bytesread = 0;					// Number of bytes read from the input file.
		int byteswritten = 0;				// Number of bytes written to the stream.
		byte databyte = 0;					// The byte of data read from the file

		// Next we write a message to the terminal to let the world know we are alive...
		System.out.print( "\n" + this.getName() + "::Middle Reading ");

		while (true)
		{
			// Here we read a byte and write a byte
			try
			{
				for (int i = 0; i < TOTAL_LENGTH; i++) {
					buffer[i] = ReadFilterInputPort();
				}
				for (byte b : buffer) {
					System.out.print((b & 0xFF) + " ");
				}
				System.out.println();
				databyte = ReadFilterInputPort();
				bytesread++;
				WriteFilterOutputPort(databyte);
				byteswritten++;
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