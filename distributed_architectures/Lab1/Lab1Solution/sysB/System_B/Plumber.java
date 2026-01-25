/******************************************************************************************************************
* File:Plumber.java
* Project: Lab 1
*
* Description:
* This class connects the source, middle, and sink filters together to form the complete data processing pipeline.
******************************************************************************************************************/

public class Plumber
{
   public static void main( String argv[])
   {
		// Here we instantiate three filters.
		SourceFilter Filter1 = new SourceFilter();
		MiddleFilter Filter2 = new MiddleFilter();
		SinkFilter Filter3 = new SinkFilter();

		/****************************************************************************
		* Here we connect the filters starting with the sink filter (Filter 3) which
		* we connect to Filter2 the middle filter. Then we connect Filter2 to the
		* source filter (Filter1).
		****************************************************************************/

		Filter3.Connect(Filter2); // This esstially says, "connect Filter3 input port to Filter2 output port
		Filter2.Connect(Filter1); // This esstially says, "connect Filter2 input port to Filter1 output port

		// Here we start the filters up.
		Filter1.start();
		Filter2.start();
		Filter3.start();
   }
}