//implements an interface with the operating system
//some code from Herbert Schildt's book: "The complete reference: Java 2"

import java.awt.event.*;

public class MyWindowAdapter extends WindowAdapter {
	
	JavaWindow window;
	
	public MyWindowAdapter(JavaWindow myWindow)	{
		window = myWindow;
	}
	//if somebody hits the x
	public void windowClosing(WindowEvent we)	{
		window.setVisible(false);		//hid the window
		window.kill();		//free up memory
	}
}
