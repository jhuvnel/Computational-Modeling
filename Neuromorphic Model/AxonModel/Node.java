/*this class is an abtract class that defines an axon node (either passive or active), any 
 * code that uses nodes should define all object variables as type Node, not the specific
 * type of class that inherits Node
 * This class will be used by abstract class node, and uses abstract class Channel
 * Nodes will take the ion current values from channel, and balance kirkoff's current law
 * within the node in order to solve for the membran potential
 */

public abstract class Node implements GlobalConstants {
	
	//be careful with these variables, I left them public for easy access
	//only look, don't change explicitly
	public double nodeDiameter;		//size of node diameter
	public double nodeLength;		//length of node
	public double deltaT;			//time step increment of the simulation
	
	//this constructor requires the diameter, length, and inital extracellular voltage
	//along with the time step of the simulation
	public Node(double diam, double len, double t_increment){
		//initialize variables
		nodeDiameter = diam;			//in meters
		nodeLength = len;				//in meters
		deltaT = t_increment;			//in seconds
	}
	
	//this class computes and returns a new V  (V = Vm-Vrest) for the calling node
	//Ve is the current extracellular potential, V is the previous value 
	//Ve_L, Ve_R, V_L, V_R correspond to the left and right neighbors
	//distL and distR are the linear distances from the neighbors 
	//diamL and diamR are the node diameter of the neighbors
	//all units in volts, seconds, and meters always
	//if one param isn't used (like for a boundary condition), SET IT TO 1, NOT TO 0,
	//otherwise you will DIVIDE BY 0
	public abstract double compute(double Ve, double Ve_L, double Ve_R, double V, 
									double V_L, double V_R, double distL, double distR, 
										double diamL, double diamR);
	
	//same as above, but allows intracellular injection of current I (amperes)
	public abstract double compute(double Ve, double Ve_L, double Ve_R, double V, 
			double V_L, double V_R, double distL, double distR, 
				double diamL, double diamR, double I);

	//returns false if the node is passive, returns true if its an active node
	public abstract boolean isActive();

	//this method is used to set the Node to some specific initial condition
	public abstract void setState(double[] args) throws Exception;
	
	//this method is used to get the current state of the Node
	public abstract double[] getState();
	
	//this method returns the size of the state array
	public abstract int stateArrayLength();

}
