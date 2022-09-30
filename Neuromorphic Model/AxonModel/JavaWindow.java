/*this class encapsulates the code required to generate a gui window so that
 * a java program can communicate to the user (useful when the java program
 * has been called from matlab), to update the window throw an event of type StatusChangeEvent
 * use forceRepaint to manually redraw the window
 * PLEASE REMEMBER TO CALL KILL (memory resources need to be freed)
 */


import java.awt.*;
import java.awt.event.*;
import java.util.ArrayList;
import javax.swing.BoxLayout;



public class JavaWindow extends Frame implements StatusChangeEventListener, ActionListener {
	
	private static final long serialVersionUID = -2150542707172874339L;
	//window display variables
	public int sizeX, sizeY;
	public String winTitle;
	public boolean isVisible;
	//variables used for output
	public boolean displayText;
	public boolean displayProgress;
	public boolean memFlag;
	public String text;
	public double progress;
	//button control from user
	public Button killJavaButton;				
	//now for register listeners (usually the code that created this object)
	public ArrayList listeners;
	//a canvas used for painting
	public MyCanvas canvas;
	
	public JavaWindow(String title, boolean visible)	{
		listeners = new ArrayList();
		//initialize display variables
		sizeX = 405;
		sizeY = 205;
		winTitle = title;
		isVisible = visible;
		setResizable(false);		//don't allow a resize
		//now setup the window
		this.setSize(new Dimension(sizeX, sizeY));
		this.setTitle(winTitle);
		//now initialize event listeners
		addKeyListener(new MyKeyAdapter(this));
		addMouseListener(new MyMouseAdapter(this));
		addWindowListener(new MyWindowAdapter(this));
		//now deal with the window output, show nothing yet
		displayText = false;
		displayProgress = false;
		memFlag = false;
		text = "";
		progress = 0;
		//set up user button
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
		canvas = new MyCanvas(this);
		add(canvas);
		killJavaButton = new Button("Kill Java");
		killJavaButton.setPreferredSize(new Dimension(100,50));        
		add(killJavaButton);
		killJavaButton.addActionListener(this);
		//force the system to repaint the window
		this.setVisible(isVisible);
		repaint();
	}
/*	//this constructor is for matlab testing
	public JavaWindow()	{
		//do nothing
	}
*/
	//use this method if you want to communicate from the window to your java program
	@SuppressWarnings("unchecked")
	public void addKillJavaEventListener(KillJavaEventListener el)	{
		listeners.add(el);
	}
	
	//this is the paint routine which the system calls to update the window
	public void paint(Graphics g)	{
		canvas.paint(g);
	}
	
	//use this to manually update the window
	public void forceRepaint()	{
		canvas.repaint();
		killJavaButton.repaint();
	}
	
	//free up system resources, call this when you are done
	public void kill()	{
		dispose();
	}
	
	//event handlers
	public void handleStatusChangeEvent(StatusChangeEvent e)	{
		text = e.progressText;
		progress = e.progressPercentage;
		memFlag = e.showMemory;
	}
	public void actionPerformed(ActionEvent ae) {	//kill button was pressed
		String str = ae.getActionCommand();
		if (str.equals("Kill Java"))	{
			//close and free up memory 
			dispose();
			//dispatch a KillJavaEvent to all registered listeners
			if (listeners != null) {
				for (int j = 0; j < listeners.size(); j++)	{
					KillJavaEventListener el = (KillJavaEventListener) listeners.get(j);
					if (el != null)	{
						KillJavaEvent kje = new KillJavaEvent(this);
						el.handleKillJavaEvent(kje);
					}
				}
			}
		}
	}

	protected void finalize()	{
		dispose();		//free up system memory
	}

/*
	//the follwoing routine is used for matlab testing
	public void matlab()	{
		int dimX = 400;
		int dimY = 200;
		text = "My test text.";
		progress = 0.25;
		String title = "My Matlab/Java Window";
		boolean visible = true;
		//initialize display variables
		sizeX = dimX;
		sizeY = dimY;
		winTitle = title;
		isVisible = visible;
		//now setup the window
		this.setSize(new Dimension(sizeX, sizeY));
		this.setTitle(winTitle);
		this.setVisible(isVisible);
		//now initialize event listeners
		addKeyListener(new MyKeyAdapter(this));
		addMouseListener(new MyMouseAdapter(this));
		addWindowListener(new MyWindowAdapter(this));
		//now deal with the window output, show nothing yet
		displayText = true;
		displayProgress = true;
		memFlag = true;
		//set up user button
		setLayout(new BoxLayout(this, BoxLayout.Y_AXIS));
		//fill up the layout
		canvas = new MyCanvas(this);
		add(canvas);
		killJavaButton = new Button("Kill Java");
		killJavaButton.setPreferredSize(new Dimension(100,50));
        
		add(killJavaButton);
		killJavaButton.addActionListener(this);
		this.setVisible(isVisible);
		
		//force the system to repaint the window
		repaint();
		text = "Some text to try out.";
	}
*/
}


