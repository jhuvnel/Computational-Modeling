//this is a custom event interface for changes in status of a java program
//a user can create a JavaWindow within their java code, adding it as a listener
//they then communicate to the window by throwing events of this type

public interface StatusChangeEventListener {
	public void handleStatusChangeEvent(StatusChangeEvent e);
}