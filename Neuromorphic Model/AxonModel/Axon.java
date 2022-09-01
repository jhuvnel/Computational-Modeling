/*This class defines the abstract class of an axon, which means that any program that uses an
 * axon should use this instead of a specific axon class that inherits Axon (for maximum
 * portability and flexibility), note that numEndNodes extra nodes will be automatically added
 * to the end of the axon (the user won't be able to access these, but they are needed
 * to prevent the rise in transmembrane potential due to an insulated end-boundary
 * condition)
 */

import static java.lang.Math.*;

import java.util.ArrayList;

public abstract class Axon implements GlobalConstants {
	
	//required class member variables, public for easy access and memory concerns, be CAREFULL!!, arrays and objects are passed by reference in java!!!!!!!!
	public Node[] nodes;			//all the nodes in this axon
	public Node[] endNodes;			//used for end boundary, should be the same type of nodes as those in the end of the Axon
	public double[][] V;					//time course of transmembrane voltage for all nodes
	public double[][] V_endNodes;			//small array holding information for endNodes
	public final static int numEndNodes = 10;//constant defining the amount of extra nodes, must be at least 2
	public double[][] position;				//array holding the x,y,z position of each node
	public double[][] trajectory;			//array holding points in space that define the axon's trajectory
	public boolean populateFlag;			//indicates whether or not the axon has been populated with nodes
	public boolean simulateFlag;			//indicates whether or not the simulation has begun
	public double deltaT;				//length of simulation increment
	public int maxTimeSteps;				//amount of time steps that can be held before a purge
											//note, this includes the starting initial condition!
	public int timeIter;					//the iterator that traverses V
	public double injectionCurrent;		//amount of current injected into the first node
	
	//this constructor defines an empty Axon with the given trajectory (may be a piece wise linear approx to a cubic spline)
	//there is no default constructor, otherwise we would have to repopulate the 
	//Axon with nodes very frequently, timeIncrement  = time step of simulation
	public Axon(double[][] traj, double timeIncrement, int numTimeSteps) throws Exception	{
		//initializations
		injectionCurrent = 0;
		deltaT = timeIncrement;
		maxTimeSteps = numTimeSteps;
		timeIter = 0;
		//V, position, and trajectory must be initialized in the populate method
		populateFlag = false;			//prevent method compute from being called prematurely
		simulateFlag = false;			//prevent appending/removing nodes after simulation began
		//now fill trajectory
		trajectory = traj;
		//now initialize the extra nodes
		endNodes = new Node[numEndNodes];
	}
	//use this constructor if the node positions were generated already, just supply
	//the constructor with the internode distances in the step array (a -1 will cause
	//the remaining nodes to have a distance of the previous element in step)
	//nodeDiam is an array specifying the node diameters, -1 is a fill condition here too
	//nodeLength_A and nodeLength_P are the node lengths of the active and passive nodes
	//use -1 here to also indicate a fill condition
	public Axon(double[] step, double[] nodeDiam, double[] nodeLength_A, double[] nodeLength_P,
					int numNodes, double timeIncrement, int numTimeSteps)	throws Exception	{
		//initializations
		injectionCurrent = 0;
		deltaT = timeIncrement;
		maxTimeSteps = numTimeSteps;
		timeIter = 0;
		populateFlag = true;		//allow simulation immediately
		simulateFlag = true;		//prevent a call to populate
		//now fill in the internode distance information
		int increment = 1;
		int iterator = -1;
		double currDist = 0;
		position = new double[numNodes][4];
		//initialize first element
		position[0][0] = -1; position[0][1] = -1; position[0][2] = -1;
		position[0][3] = 0;
		for (int i = 1; i < numNodes; i++)	{
			iterator = iterator + increment;
			//unused elements will hold a -1
			position[i][0] = -1; position[i][1] = -1; position[i][2] = -1;
			position[i][3] = currDist + step[iterator];
			currDist = currDist + step[iterator]; //update currDist
			if (iterator != (step.length-1))	{
				if (step[iterator+1] == -1)
					increment = 0;			//fill condition
			}
		}
		V = new double[numNodes][maxTimeSteps];
		V_endNodes = new double[numEndNodes][2];
		nodes = new Node[numNodes];
		endNodes = new Node[numEndNodes];
		//initialize the node list
		initNodeList(nodeDiam, nodeLength_A, nodeLength_P);
	}
	//default constructor should only be used for testing
	public Axon()	{
		//do nothing
	}
	
	//this method populates an axon with equidistant nodes, note numNodes = passive + active nodes!, even if passive nodes are perfect insulators
	//nodeLength_A = length of active nodes, nodeLength_P = length of passive nodes
	//mainly used for testing and simple tests
	//when overridden, make sure to implement the numEndNodes extra nodes in endNodes[]
	public abstract void populate(int numNodes, double nodeLength_A, double nodeLength_P, 
														double nodeDiam) throws Exception;
	
	//this function takes the place of populate to initialize the node list
	//when the node positions have already been found
	//make sure to implement the numEndNodes extra nodes in endNodes[]
	public abstract void initNodeList(double[] nodeDiam, double[] nodeLength_A, double[] nodeLength_P);

	//accesses a public static final variable of pre-calculated states for a given axon (important that its public static and final, memory!)
	//this method must be implemented if setInitialCondition() of class AxonSimulate is to be used
	//to be used in conjunction with setInitialCondition() (see below)
	//index is an array of doubles, generated for [0,1)
	public abstract double[] accessStateArray(double index);
	
	//used to set the axon to some initial state before simulation begins,
	//if its called on an axon partially through simulation it will reset to the first time step
	//the InitialCondition set must have information for an axon of equal size, or larger
	//if the initialCondition set is for a larger axon, the nodes for this axon will be filled
	//with the front end of those nodes we have initialCondition information for (even the endNodes too)
	//
	//The initialCondition set must be for an IDENTICAL AXON (barring axon length)
	//this means that deltaT, diameter, nodeLengthA and nodeLengthP must be the same, and so on
	public void setInitialCondition(double[] args) throws Exception	{
		try	{
			//restart from the beginning
			timeIter = 0;
			//pull in general axon properties
			int numNodes = (int) args[0];
			int numEndNodes = (int) args[1];
			if (deltaT != args[2])
				throw new Exception("Euler time increment does not match the initial condition set.");
			injectionCurrent = args[3];
			//update the V and V_endNodes matrices
			for (int i = 0; i < nodes.length; i++)	{
				V[i][timeIter] = args[i+4];
			}
			//remember that endNodes are treated as normal nodes in this situation
			for (int i = 0; i < endNodes.length; i++)	{
				V_endNodes[i][1] = args[i+4+nodes.length];
			}
			int iterator = numNodes+numEndNodes+3;	//current location within state array
			//set the state of each node
			for (int i = 0; i < nodes.length; i++){
				iterator = iterator + 1;
				double[] tempState = new double[nodes[i].stateArrayLength()];
				for (int j = 0; j < nodes[i].stateArrayLength(); j++)	{
					tempState[j] = args[j+iterator];
				}
				nodes[i].setState(tempState);
				iterator = iterator+nodes[i].stateArrayLength()-1;
			}
			//again, consider endNodes as normal nodes (that's why they must be of the same node type as the last ones of the Axon)
			for (int i = 0; i < endNodes.length; i++){
				iterator = iterator + 1;
				double[] tempState = new double[endNodes[i].stateArrayLength()];
				for (int j = 0; j < endNodes[i].stateArrayLength(); j++)	{
					tempState[j] = args[j+iterator];
				}
				endNodes[i].setState(tempState);
				iterator = iterator+endNodes[i].stateArrayLength()-1;
			}
		}
		catch (Exception e)	{
			String msg = e.getMessage();
			msg = "Error while setting initial condition of an axon: " + msg;
			throw new Exception(msg);
		}
	}
	
	//this function is used to get the current state of the axon, comes in handy
	//when paired with setInitialCondition()
	public double[] getState()	{
		//store axon properties
		ArrayList<Double> output = new ArrayList<Double>(0);
		output.add(new Double(nodes.length));
		output.add(new Double(endNodes.length));
		output.add(new Double(deltaT));
		output.add(new Double(injectionCurrent));
		//store current voltage arrays
		for (int i = 0; i < nodes.length; i++)	{
			output.add(new Double(V[i][timeIter]));
		}
		for (int i = 0; i < endNodes.length; i++)	{
			output.add(new Double(V_endNodes[i][1]));
		}
		//store each node's state
		for (int i = 0; i < nodes.length; i++)	{
			double[] state = nodes[i].getState();
			for (int j = 0; j < state.length; j++)	{
				output.add(new Double(state[j]));
			}
		}
		//store each endNode's state, treat them as if they were regular nodes
		for (int i = 0; i < endNodes.length; i++)	{
			double[] state = endNodes[i].getState();
			for (int j = 0; j < state.length; j++)	{
				output.add(new Double(state[j]));
			}
		}
		//convert the output array into a normal double array for matlab
		double[] result = new double[output.size()];
		for (int i = 0; i < output.size(); i++)	{
			result[i] = output.get(i).doubleValue();
		}
		return result;
	}
	
	//this method calculates the next layer of V for the next time step
	//Ve is an array that describes the current extracellular potential, Ve.size must equal numNodes
	//This method should be the same for any class inheriting Axon, however you may override it
	//The endNodes are assumed to have the same diameter of the last node, and have internode-distances equal
	//to that between the last two actual nodes (nodeLength_A and nodeLength_P also match the last active and pasive node)
	public void compute(double[] Ve) throws Exception	{
		//update timeIter to the next time step
		timeIter = timeIter+1;
		if (timeIter == maxTimeSteps)		//prevent an out of bounds problem
			throw new Exception("Error: Attempt to iterate past maxTimeSteps.  Remember, maxTimeSteps also includes the initial condition.");
		if (!populateFlag)
			throw new Exception("Error: Attempt to simulate without populating the Axon with Nodes.");
		//cycle through all nodes and place thier new voltage into V
		double newVoltage = 0;		//used as a temporary place holder below
		int numNodes = nodes.length;
		for (int i = 0; i < numNodes; i++)	{
			//handle starting boundary condition
			if (i==0)	{
				//find new voltage, boundary condition: V_L = V, Ve_L = Ve
				//set nonexistant node diameter and distance to 1 to prevent divide by 0
				newVoltage = nodes[0].compute(Ve[0], Ve[0], Ve[1], V[0][timeIter-1], V[0][timeIter-1], 
						V[1][timeIter-1], 1, position[1][3] - position[0][3], 1, nodes[1].nodeDiameter, injectionCurrent);
				V[0][timeIter] = newVoltage;		//save space with floats
			}
			else if (i == numNodes-1)	{	//last node
				//find the last internode distance
				double lastDistance = position[numNodes-1][3] - position[numNodes-2][3];
				//find new voltage for the last actual node
				newVoltage = nodes[numNodes-1].compute(Ve[numNodes-1], Ve[numNodes-2], 
						Ve[numNodes-1], V[numNodes-1][timeIter-1], V[numNodes-2][timeIter-1], V_endNodes[0][1], 
						lastDistance, lastDistance,	nodes[numNodes-2].nodeDiameter, nodes[numNodes - 1].nodeDiameter);
				//now update the endNodes, assuming the same extracellular potential as the last actual node
				//also assume the same interNode distance and diameter
				for (int e = 0; e < numEndNodes-1; e++)	{
					double prevVi;
					if (e == 0)
						prevVi = V[numNodes-1][timeIter-1];
					else
						prevVi = V_endNodes[e-1][1];
					V_endNodes[e][0] = endNodes[e].compute(Ve[numNodes-1], Ve[numNodes-1], Ve[numNodes-1],
															V_endNodes[e][1], prevVi, V_endNodes[e+1][1], lastDistance,
															lastDistance, nodes[numNodes-1].nodeDiameter, nodes[numNodes-1].nodeDiameter);
				}
				//now implement the insulated boundary condition
				V_endNodes[numEndNodes-1][0] = endNodes[numEndNodes-1].compute(Ve[numNodes-1], Ve[numNodes-1], Ve[numNodes-1],
															V_endNodes[numEndNodes-1][1], V_endNodes[numEndNodes-2][1], V_endNodes[numEndNodes-1][1],
															lastDistance, lastDistance, nodes[numNodes-1].nodeDiameter, nodes[numNodes-1].nodeDiameter);
				//upadate V_endNodes
				for (int e2 = 0; e2 < numEndNodes; e2++){
					V_endNodes[e2][1] = V_endNodes[e2][0];
				}
				V[numNodes-1][timeIter] = newVoltage;		//save space with floats
			}
			else	{	//normal intermediate node
				//find new voltage, use complex compute for maximum flexibility
				newVoltage = nodes[i].compute(Ve[i], Ve[i-1], Ve[i+1], 
						V[i][timeIter-1], V[i-1][timeIter-1], V[i+1][timeIter-1], 
						position[i][3] - position[i-1][3], position[i+1][3]-position[i][3], 
						nodes[i-1].nodeDiameter, nodes[i+1].nodeDiameter);
				V[i][timeIter] = newVoltage;		//save space with floats
			}
			//check to make sure there is no overload condition (if euler's method diverged)
			if (Double.isNaN(newVoltage) || Double.isInfinite(newVoltage))
				throw new Exception("Error: Euler's method diverged while simulating an axon.  Check input parameters.");
		}
		simulateFlag = true;		//don't allow any manipulation after simulation begun
	}
	
	//this function is for testing.  It injects the given 
	//amount of current at the first node (I is in Amperes)
	public void inject(double I)	{
		injectionCurrent = I;
	}
	
	//this method is used by other methods to traverse a trajectory while populating
	//location is how far down the axon the last node was placed and deltaD = distance to
	//the next node location, the function returns a dim=4 array which is 
	//[x, y, z, new current location], where xyz are the coords of the current node being placed
	protected double[] nextLocation(double location, double deltaD) throws Exception	{
		try	{
			//these variables are used for walking through the trajectory
			double currDist = 0;		//length we have traveled down the axon
			double[] currUVect = {0,0,0};	//current unit vector of direction
			double currMaxDist = 0;		//maximum distance we can travel on this segment
			int currTrajIndex = 0;		//the starting point of the current segment
			
			//loop until we get to the desired location
			while (currDist < location+deltaD)	{	//this loop may throw an array out of bounds error (if our trajectory is too short)
				//update the currentunit vector and its currMaxDist
				currUVect[0] = trajectory[currTrajIndex+1][0] - trajectory[currTrajIndex][0];	//get the difference vector
				currUVect[1] = trajectory[currTrajIndex+1][1] - trajectory[currTrajIndex][1];
				currUVect[2] = trajectory[currTrajIndex+1][2] - trajectory[currTrajIndex][2];
				currMaxDist = sqrt(pow(currUVect[0],2)+pow(currUVect[1],2)+pow(currUVect[2],2));	//get the size of the vector
				currUVect[0] = currUVect[0]/currMaxDist;	//normalize
				currUVect[1] = currUVect[1]/currMaxDist;	
				currUVect[2] = currUVect[2]/currMaxDist;	
				
				//now we have a unit vector and the maximum length we can travel on this line segment
				if ((location+deltaD) < (currDist+currMaxDist))	{	//it will be on this line segment
					double distLeft = (location+deltaD) - currDist;	//how much more do we need to go
					//update the now non-unit vector with this distance
					currUVect[0] = currUVect[0]*distLeft;
					currUVect[1] = currUVect[1]*distLeft;
					currUVect[2] = currUVect[2]*distLeft;
					//now add this vector to the previous trajectory node
					currUVect[0] = currUVect[0] + trajectory[currTrajIndex][0];
					currUVect[1] = currUVect[1] + trajectory[currTrajIndex][1];
					currUVect[2] = currUVect[2] + trajectory[currTrajIndex][2];
					//now return this new location along with the current distance
					double[] output = new double[4];
					output[0] = currUVect[0]; output[1] = currUVect[1]; output[2] = currUVect[2];
					output[3] = currDist + distLeft;
					return output;
				}
				else	{//we're not going to make it on this line segment, so go to the next line segment
					//update our current distance
					currDist = currDist + currMaxDist;
					//update this for the next loop iteration so we look at the next segment
					currTrajIndex = currTrajIndex + 1;				
				}
			}
		}
		catch (Exception e)	{		//out of bounds exception, meaning we ran out of trajectory
			return null;		//null will indicate the trajectory is full
		}
		//should never get to this point, otherwise something is really wrong
		throw new Exception("Error: method newLocation in Axon terminated incorrectly");
	}
	
	//this will probably return null until the class is populated
	public int getNumNodes()	{
		int r = nodes.length;
		return r;
	}
	
/*	//this function is used for testing in matlab, initialize Axon a first
	public static double[][] quickSimulate(Axon a, int numIter, double[] Ve, double[] waveForm) throws Exception	{
		double[][] result = new double[numIter+2][];
		boolean recordStateFlag = false;
		boolean recordStateFlag2 = false;
		result[numIter] = new double[numIter];
		result[numIter+1] = new double[1];	//ensure a ragged matrix
		int resultIter = 0;
		int stepper = 0;
		for (int i = 0; i < (numIter-1); i++)	{ //numIter-1 because the initial conditions take up one place in the V array
			//scale Ve to the waveform
			double[] temp = Ve.clone();		//must clone here or you'll loose Ve
			for (int k = 0; k < temp.length; k++)	{
				temp[k] = temp[k] * waveForm[i];
			}
			a.compute(temp);
			if (recordStateFlag && stepper == 3000)	{
				result[resultIter] = a.getState();
				stepper = 0;
				resultIter = resultIter+1;
			}
			stepper = stepper + 1;
			result[numIter][i] = ((G_AHPNode_CVStar5082) a.nodes[0]).returnTest();
			if (result[numIter][i] == 1)	{
				if (!recordStateFlag2)	{
					recordStateFlag2 = true;
					recordStateFlag = true;
					stepper = 2999;
				}
				else
					recordStateFlag = false;
			}
		}
		return result;
	}*/
	//this function is used for testing in matlab, initialize Axon a first
	public static double[] quickSimulate(Axon a, int numIter, double[] Ve, double[] waveForm) throws Exception	{
		double[] result = new double[numIter];
		for (int i = 0; i < (numIter-1); i++)	{ //numIter-1 because the initial conditions take up one place in the V array
			//scale Ve to the waveform
			double[] temp = Ve.clone();		//must clone here or you'll loose Ve
			for (int k = 0; k < temp.length; k++)	{
				temp[k] = temp[k] * waveForm[i];
			}
			a.compute(temp);
			result[i] = ((G_AHPNode_CVStar0265) a.nodes[0]).returnTest();
		}
		return result;
	}
}
