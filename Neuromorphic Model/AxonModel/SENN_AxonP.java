
/*this class implements a basic SENN axon (based off of Frijns 1994 and Darren Whiten),
 * the myelin is modelled as a passive node
 */
import java.io.PrintWriter;

public class SENN_AxonP extends Axon implements GlobalConstants {

	//need to rewrite them here for matlab use
	public SENN_AxonP(double[][] traj, double timeIncrement, int numTimeSteps) throws Exception	{
		super(traj, timeIncrement, numTimeSteps);
	}
	public SENN_AxonP(double[] step, double[] nodeDiam, double[] nodeLength_A, double[] nodeLength_P,
			int numNodes, double timeIncrement, int numTimeSteps, PrintWriter errLog)	throws Exception	{
		super(step, nodeDiam, nodeLength_A, nodeLength_P, numNodes, timeIncrement, numTimeSteps, errLog);
	}
	public SENN_AxonP()	{
		super();
	}

	//populate the axon with nodes which are passive and active
	public void populate(int numNodes, double nodeLength_A,
							double nodeLength_P, double nodeDiam) throws Exception {
		if (simulateFlag)		//can't populate after you start simulating
			throw new Exception("Error: Attempt to populate axon after simulation begun.");
		//initialize member arrays
		position = new double[numNodes][4];
		V = new double[numNodes][maxTimeSteps];
		V_endNodes = new double[numEndNodes][2];
		nodes = new Node[numNodes];
		//initialize local variables
		double[] currLocation = {0,0,0,0};	//how far down the axon we currently are while populating, also the xyz coords
		double deltaD = nodeLength_A/2 + nodeLength_P/2;	//the usual distance between nodes
		Node n;			//will be used during the loops as a temporary place holder
		//loop through all the nodes
		for (int i = 0; i < numNodes; i++)	{
			//take care of the boundaries
			if (i == 0)	{
				//first node will be an active node, get its location
				currLocation = nextLocation(currLocation[3], nodeLength_A/2);
				if (currLocation == null)	//we filled up the trajectory trace!
					throw new Exception("Trajectory end reached.  Need longer trajectory to fill with given number of nodes.");
				//create the node
				n = new SENN_ActiveNode(nodeDiam, nodeLength_A, deltaT, errLog);
				nodes[0] = n;	//add into master list
				//now set the other member parameters which were inherited from Axon
				position[0] = currLocation.clone();		//store its location
				//initialize V
				V[0][0] = 0;			//initial condition V = 0 volts (V = Vm-Vrest)
			}
			else if (i == numNodes-1)	{	//final node
				//first, find where it should be
				currLocation = nextLocation(currLocation[3], deltaD);
				if (currLocation == null)	//we filled up the trajectory trace!
					throw new Exception("Trajectory end reached.  Need longer trajectory to fill with given number of nodes.");
				//find out if it should be a passive or active node
				if ((numNodes-1)%2 == 0)	{	//even number means active node
					n = new SENN_ActiveNode(nodeDiam, nodeLength_A, deltaT, errLog);
					//now implement the endNodes
					for (int e = 0; e < numEndNodes; e++)	{
						//find out if it should be a passive or active node
						if (e%2 == 0)	{	//even number means passive node
							Node eT = new SENN_PassiveNode(nodeDiam, nodeLength_P, deltaT, errLog);
							endNodes[e] = eT;
						}
						else	{
							Node eT = new SENN_ActiveNode(nodeDiam, nodeLength_A, deltaT, errLog);
							endNodes[e] = eT;
						}
					}
				}
				else	{
					n = new SENN_PassiveNode(nodeDiam, nodeLength_P, deltaT, errLog);
					//now implement the endNodes
					for (int e = 0; e < numEndNodes; e++)	{
						//find out if it should be a passive or active node
						if (e%2 == 0)	{	//even number means passive node
							Node eT = new SENN_ActiveNode(nodeDiam, nodeLength_A, deltaT, errLog);
							endNodes[e] = eT;
						}
						else	{
							Node eT = new SENN_PassiveNode(nodeDiam, nodeLength_P, deltaT, errLog);
							endNodes[e] = eT;
						}
					}
				}
				nodes[numNodes-1] = n;	//add into master list
				//now set the other member parameters which were inherited from Axon
				position[numNodes-1] = currLocation.clone();		//store its location
				//initialize V
				V[numNodes-1][0] = 0;			//initial condition V = 0 volts (V = Vm-Vrest)
			}
			else	{		//node that is in the middle
				//first, find where it should be
				currLocation = nextLocation(currLocation[3], deltaD);
				if (currLocation == null)	//we filled up the trajectory trace!
					throw new Exception("Trajectory end reached.  Need longer trajectory to fill with given number of nodes.");
				//find out if it should be a passive or active node
				if (i%2 == 0)	{	//even number means active node
					n = new SENN_ActiveNode(nodeDiam, nodeLength_A, deltaT, errLog);
				}
				else	{
					n = new SENN_PassiveNode(nodeDiam, nodeLength_P, deltaT, errLog);
				}
				nodes[i] = n;	//add into master list
				//now set the other member parameters which were inherited from Axon
				position[i] = currLocation.clone();		//store its location
				//initialize V
				V[i][0] = 0;			//initial condition V = 0 volts (V = Vm-Vrest)
			}
		}
		//initialize end node voltage array
		for (int e = 0; e < numEndNodes; e++)	{
			V_endNodes[e][0] = 0;
			V_endNodes[e][1] = 0;
		}
		//allow compute from here on out
		populateFlag = true;
	}
	
	//this function takes the place of populate to initialize the node list
	//when the node positions have already been found
	public void initNodeList(double[] nodeDiam, double[] nodeLength_A, double[] nodeLength_P)	{
		Node n;			//will be used during the loops as a temporary place holder
		int numNodes = nodes.length;
		int incrementorA = 1;
		int incrementorP = 1;
		int incrementorD = 1;
		int iteratorA = 0;
		int iteratorP = 0;
		int iteratorD = -1;
		//loop through all the nodes
		for (int i = 0; i < nodes.length; i++)	{
			iteratorD = iteratorD + incrementorD;
			if (iteratorA != (nodeLength_A.length-1))	{
				if (nodeLength_A[iteratorA+1] == -1)
					incrementorA = 0;			//fill condition
			}
			if (iteratorP != (nodeLength_P.length-1))	{
				if (nodeLength_P[iteratorP+1] == -1)
					incrementorP = 0;			//fill condition
			}
			if (iteratorD != (nodeDiam.length-1))	{
				if (nodeDiam[iteratorD+1] == -1)
					incrementorD = 0;			//fill condition
			}
			//take care of the boundaries
			if (i == 0)	{
				//create the node
				n = new SENN_ActiveNode(nodeDiam[0], nodeLength_A[0], deltaT, errLog);
				iteratorA = iteratorA + incrementorA;
				nodes[0] = n;	//add into master list
				//initialize V
				V[0][0] = 0;			//initial condition V = 0 volts (V = Vm-Vrest)
			}
			else if (i == numNodes-1)	{	//final node
				//find out if it should be a passive or active node
				if ((numNodes-1)%2 == 0)	{	//even number means active node
					n = new SENN_ActiveNode(nodeDiam[iteratorD], nodeLength_A[iteratorA], deltaT, errLog);
					//now implement the endNodes
					for (int e = 0; e < numEndNodes; e++)	{
						//find out if it should be a passive or active node
						if (e%2 == 0)	{	//even number means passive node
							Node eT = new SENN_PassiveNode(nodeDiam[iteratorD], nodeLength_P[iteratorP], deltaT, errLog);
							endNodes[e] = eT;
						}
						else	{
							Node eT = new SENN_ActiveNode(nodeDiam[iteratorD], nodeLength_A[iteratorA], deltaT, errLog);
							endNodes[e] = eT;
						}
					}
					iteratorA = iteratorA + incrementorA;
				}
				else	{
					n = new SENN_PassiveNode(nodeDiam[iteratorD], nodeLength_P[iteratorP], deltaT, errLog);
					//now implement the endNodes
					for (int e = 0; e < numEndNodes; e++)	{
						//find out if it should be a passive or active node
						if (e%2 == 0)	{	//even number means passive node
							Node eT = new SENN_ActiveNode(nodeDiam[iteratorD], nodeLength_A[iteratorP], deltaT, errLog);
							endNodes[e] = eT;
						}
						else	{
							Node eT = new SENN_PassiveNode(nodeDiam[iteratorD], nodeLength_P[iteratorA], deltaT, errLog);
							endNodes[e] = eT;
						}
					}
					iteratorP = iteratorP + incrementorP;
				}
				nodes[numNodes-1] = n;	//add into master list
				//initialize V
				V[numNodes-1][0] = 0;			//initial condition V = 0 volts (V = Vm-Vrest)
			}
			else	{		//node that is in the middle
				//find out if it should be a passive or active node
				if (i%2 == 0)	{	//even number means active node
					n = new SENN_ActiveNode(nodeDiam[iteratorD], nodeLength_A[iteratorA], deltaT, errLog);
					iteratorA = iteratorA + incrementorA;
				}
				else	{
					n = new SENN_PassiveNode(nodeDiam[iteratorD], nodeLength_P[iteratorP], deltaT, errLog);
					iteratorP = iteratorP + incrementorP;
				}
				nodes[i] = n;	//add into master list
				//initialize V
				V[i][0] = 0;			//initial condition V = 0 volts (V = Vm-Vrest)
			}
		}
		//initialize end node voltage array
		for (int e = 0; e < numEndNodes; e++)	{
			V_endNodes[e][0] = 0;
			V_endNodes[e][1] = 0;
		}	
	}
	
	//No initial condition stuff implemented at this time
	public double[] accessStateArray(double index)	{
		return null;		//will result in an Exception
	}

}
