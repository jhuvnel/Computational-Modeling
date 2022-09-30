/*this class is an abstract class that defines specific ion channels (used by abstract class
 * node), when defining a channel object, it should be of type Channel, not the specific class
 * name of whatever channel class that inherits Channel
 */

public abstract class Channel implements GlobalConstants {
	
	protected double nodeDiameter;			//diameter of the calling node
	protected double nodeLength;				//node length of the calling node
	protected double deltaT;					//time step for simulation
	
	//basic constructor, requires the length and diameter of the calling Node (meters)
	//also requires the time step of the simulation (seconds)
	public Channel(double diameter, double length, double timeIncrement)
	{
		//initialize private member variables
		nodeDiameter = diameter;
		nodeLength = length;	
		deltaT = timeIncrement;
	}
	
	//this method returns the total current contribution for this given channel
	//its abstract because it must be overridden
	//Vm is the current transmembrane voltage of the node (Volts)
	public abstract double current(double Vm);
	
	//this method is used to set the values of the channels to some specific initial condition
	public abstract void setState(double[] args) throws Exception;
	
	//this method is used to get the current state
	public abstract double[] getState();
	
	//this method returns the size of the state array
	public abstract int stateArrayLength();
	
}
