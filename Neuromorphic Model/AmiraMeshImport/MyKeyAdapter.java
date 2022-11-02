//implement an interface with the keyboard
//some code from Herbert Schildt's book: "The complete reference: Java 2"

import java.awt.event.*;


public class MyKeyAdapter extends KeyAdapter {
	
	public JavaWindow window;
	
	public MyKeyAdapter(JavaWindow myWindow)	{
		this.window = myWindow;
	}
	
	public void keyTyped(KeyEvent ke)	{
		//use ke.getKeyChar() to ge the value of the event
	}
}
