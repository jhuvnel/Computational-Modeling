//this is an event that a user may use to communicate changes to a JavaWindow

import java.util.EventObject;

public class StatusChangeEvent extends EventObject {
	
	private static final long serialVersionUID = -894166284169381595L;
	//variables used to updat JavaWindow
	public String progressText;
	public double progressPercentage;
	public boolean showMemory;
	
	//default constructor
	public StatusChangeEvent(Object source)	{
		super(source);
		progressText = "";
		progressPercentage = 0;
	}
	//constructor for changing status
	public StatusChangeEvent(Object source, String text, double progressPercent, boolean memFlag)	{
		super(source);
		progressText = text;
		progressPercentage = progressPercent;
		showMemory = memFlag;
	}
}
