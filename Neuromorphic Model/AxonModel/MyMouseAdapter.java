//implements an interface with the mouse
//some code from Herbert Schildt's book: "The complete reference: Java 2"

import java.awt.event.*;

public class MyMouseAdapter extends MouseAdapter{
	
	JavaWindow window;
	
	public MyMouseAdapter(JavaWindow myWindow)	{
		this.window = myWindow;
	}
	
	//if the mouse button was pressed, this method will be triggered
	public void mousePressed(MouseEvent me)	{
		//use me.getX() and me.getY() for the coords
	}
	
}
