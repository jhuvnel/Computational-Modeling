//this implements a custom canvas for graphics output

import java.awt.*;

public class MyCanvas extends Canvas	{
	
	private static final long serialVersionUID = -3565683149700020083L;
	JavaWindow window;
	
	public MyCanvas(JavaWindow myWindow)	{
		super();
		window = myWindow;
	}
	//this is the paint routine which the system calls to update the window
	public void paint(Graphics g)	{
		g.clearRect(0, 0, window.sizeX, window.sizeY);
		g.setColor(Color.black);
		if (window.displayProgress)	{
			Color currentColor = g.getColor();
			g.setColor(Color.black);
			g.fillRect(50, 25, 300, 50);
			g.setColor(Color.blue);
			double currentProgress = 290.0*window.progress;
			g.fillRect(55, 30, (int) currentProgress, 40);
			g.setColor(Color.white);
			g.drawString("Progress...", 175, 55);
			g.setColor(currentColor);
		}
		if (window.displayText)	{
			g.drawString(window.text, 10, 100);
		}
		if (window.memFlag)	{
			long total = java.lang.Runtime.getRuntime().totalMemory();
			long max = java.lang.Runtime.getRuntime().maxMemory();
			double percentage = (double) (((double) total)/ ((double) max));
			percentage = percentage*100;
			int intPercent = (int) percentage;
			String memoryUsage = "Percentage of available JVM memory used: " + intPercent;
			g.drawString(memoryUsage, 10, 125);
		}
	}
	  public Dimension getMinimumSize() {
		  return new Dimension(400, 150);  
	  }

	  public Dimension getPreferredSize() {
		  return new Dimension(405, 155);  
	  }

	  public Dimension getMaximumSize() {
		  return new Dimension(405, 155);  
	  }
}
