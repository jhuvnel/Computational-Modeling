//use this event to tell your java code that the user has hit the "kill java" button

import java.util.EventObject;

public class KillJavaEvent extends EventObject {
	
	private static final long serialVersionUID = -8589381901349227047L;

	//default constructor
	public KillJavaEvent(Object source)	{
		super(source);
	}
}