/*this class automates the simulation of class Axon in bulk, use this
 * as a super class to build upon
 * 
 */

import java.io.PrintWriter;
import java.io.FileOutputStream;

import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

public abstract class AxonSimulate implements GlobalConstants, KillJavaEventListener {

	public Axon[] axons;		//array of axons to simulate
	public double[] step;		//internode distances (-1 = fill condition for all)
	public double[][] nodeDiam;		//node diameters (array for each axon) 
	public double[] nodeLength_A;	//node lengths active and passive 
	public double[] nodeLength_P;
	public double timeIncrement;//time increment in seconds
	public int maxIter;			//maximum amount of iterations allowed
	public double[][] Ve;				//extracellular voltage of each node of each axon
	public int[][] AP;				//hold action potential information
	public JavaWindow	outputWindow;		//user interface
	public boolean flagError;
	public boolean flagInitialConditions = false;	//if an initial condition set has been specified (default = NO)
	public double[] initialCondition;		//holds random numbers [0,1] for indexing into the state array of a given axon
	
	public AxonSimulate()	{
		//create an output window
		outputWindow = new JavaWindow("AxonSimulate", false);
		//show information
		outputWindow.displayProgress = true;
		outputWindow.memFlag = true;
		outputWindow.displayText = true;
		flagError = false;
		//register with outputWindow
		outputWindow.addKillJavaEventListener(this);
	}
	//user interface stuff
	public void handleKillJavaEvent(KillJavaEvent e)	{
		flagError = true;
	}
	
	public void initialize(double[] interNodeDist, double[][] nodeDiameters, double[] nodeLengths_Act, 
									double[] nodeLengths_Pas, double timeInc, int numAxons)	{
		//initialize variables
		step = interNodeDist;
		nodeDiam = nodeDiameters;
		nodeLength_A = nodeLengths_Act;
		nodeLength_P = nodeLengths_Pas;
		timeIncrement = timeInc;
		Ve = new double[numAxons][]; 	//initialize with uploadVe.m
		flagError = false;		//reset this in case the previous iteration was stopped
		flagInitialConditions = false;		//return to default
	}
	
	//this sets the inital conditions for the axons to be simulated,
	//stateIndexes holds (for each axon) a double that will be used to look into stateArray (see class Axon)
	//use -1 as a fill condition
	//NOTE: Ve should be initialized before calling this function
	public void setInitialCondition(double[] stateIndexes)	{
		flagInitialConditions = true;
		int numAxons = Ve.length;
		initialCondition = new double[numAxons];
		int iterator = 0;
		int iteratorInc = 1;
		for (int i = 0; i < numAxons; i++)	{
			initialCondition[i] = stateIndexes[iterator];
			if (iterator != (stateIndexes.length-1))	{
				if (stateIndexes[iterator+1] == -1)
					iteratorInc = 0;
			}
			iterator = iterator+iteratorInc;
		}
	}
	
	//use these two methods to turn on or off the use of initial conditions
	public void turnOnInitialConditions()	{
		flagInitialConditions = true;
	}
	public void turnOffInitialConditions()	{
		flagInitialConditions = false;
	}
	
	//the axons array is generated on the fly so that memory is only used
	//when absolutely necessary, override this function for different types
	//of nerve fibers (e.g. passive nodes vs insulated nodes)
	//NOTE: may not use this due to memory concerns
	public abstract void initAxonArray(int numIterations, int[] numNodes) throws Exception;
	
	//override this one also, used for finding thresholds
	public abstract Axon initOneAxon(int numIterations, int numNodes, double[] nodeDiameter) throws Exception;
	
	//this function should be encapsulated by a matlab m-file
	//see uploadVe.m
	//its used to import from a matlab cell structure
	//Ve is the extracellular potential of all nodes of all axons
	//NOT USER FRIENDLY, make sure numAxons is consistent !!!
	public void uploadVe(double[] v, int index)	{
		//upload each one (Ve will be a ragged array), but don't exceed size
		int numAxons = Ve.length;
		if (index < numAxons)
			Ve[index] = v;
	}
	
	//this function runs the simulation for the duration of the waveform stimulus
	//it returns the deviation of the transmembrane voltage at all time steps
	//Note that it will return one extra element in the array (a lone -1), this is done
	//to force a ragged edge matrix, thereby causing matlab to interpret this as a cell structure
	//if action potential info is desired, set Vt to the threshold voltage, otherwise
	//set Vt to -1 to indicate no AP processing
	//check the public variable AP if action potential information is computed
	//Vt is in terms of deviation from the resting membrane potential
	//startInd == what number axon to start simulating from (use matlab convention)
	//stopInd == what number axon to stop simulating from (use matlab convention)
	//if startInd or stopInd is out of bounds, you will get an error
	public double[][][] compute(double[] waveform, double Vt, String fileLog,
									int startInd, int stopInd) throws Exception	{
		//get simulation information
		int numIterations = waveform.length + 1;  //add one because the initial condition is stored first
		int numAxons = Ve.length;
		int[] numNodes = new int[numAxons];
		for (int q = 0; q < numAxons; q++)	{
			numNodes[q] = Ve[q].length;
		}
		//try to allocate the memory block before simulating
		double[][][] result = new double[numAxons+1][][];
		//axons will be initiated one at a time to save memory
		if (Vt != -1)
			AP = new int[numAxons][2];
		//prepare output window
		outputWindow.progress = 0;
		outputWindow.text = "Initializing...";
		outputWindow.setVisible(true);
		//open up the error log
		PrintWriter errLog = new PrintWriter(new FileOutputStream(fileLog, true));
		//output current information
		errLog.println("Error log for method compute of Class AxonSimulate.");
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		errLog.println(dateFormat.format(date));
		errLog.println("Error log not yet implemented for method compute of Class AxonSimulate");
		//simulate each nerve, apply it to the result array, and then clear it from memory
		for (int i = (startInd-1); i < stopInd; i++)	{
			//take care of user exit
			if (flagError)	{
				//close error file
				errLog.println("User manually killed the java process.");
				errLog.println("End of session.");
				errLog.println("");errLog.println("");
				errLog.close();
				throw new Exception("User manually killed the java process.");
			}
			//update the output window
			outputWindow.progress = ((double)(i+1-startInd)/((double)(stopInd-startInd+1)));
			outputWindow.text = "Number of axons completed: " + (i+1-startInd);
			outputWindow.forceRepaint();
			//do a full simulation of one nerve at a time
			Axon a = initOneAxon(numIterations, numNodes[i], nodeDiam[i]);
			//now for the initial condition contingency
			if (flagInitialConditions)
				a.setInitialCondition(a.accessStateArray(initialCondition[i]));
			for (int j = 0; j < waveform.length; j++)	{
				//scale Ve to the waveform
				double[] temp = Ve[i].clone();		//must clone here or you'll loose Ve
				for (int k = 0; k < temp.length; k++)	{
					temp[k] = temp[k] * waveform[j];
				}
				a.compute(temp);
			}
			//store the axon's info
			result[i] = a.V;
			if (Vt != -1)
				AP[i] = findActionPotential(a.V, Vt);
		}
		//hide the window
		outputWindow.setVisible(false);
		//close error file
		errLog.println("End of session.");
		errLog.println("");errLog.println("");
		errLog.close();
		//create the ragged edged matrix
		double[][] raggedTemp = {{-1}};
		result[numAxons] = raggedTemp;		//force matlab to return a cell
		return result;
	}
	
	//this function returns an array which holds in its first element the node of action potential initiaition (its index)
	//and in the second element the time iteration index of initiation
	//it will only find fully conducted action potentials!, will return {-1, -1} if one not found
	//v is the simulated v array of an Axon, and Vt is the voltage threshold used to define an AP (Vt is in deviation from resting potential)
	//this function is not foolproof, can be improved upon!
	public static int[] findActionPotential(double[][] v, double Vt)	{
		int[] result = {-1,-1};
		int numNodes = v.length;
		int numTimeSteps = v[0].length;
		int lastNodeAP_tIndex = -1;			//holds the timeIter index of the first AP shown on the previous node
		int lastNodeAP_nIndex = -1;			//holds the node index of the last node in which an AP was found
		boolean flagFinished;				//tells the back track loop when to stop
		
		//cycle through each time step of the last node to see if an AP occured
		for (int i = 0; i < numTimeSteps; i++)	{
			//test for an AP
			if (Vt < v[numNodes-1][i])
				lastNodeAP_tIndex = i;
		}
		//test to see if an AP was found
		if (lastNodeAP_tIndex == -1)	{
			return result;			//nothing found, so return {-1,-1}
		}
		//AP found, so back track through the nodes
		lastNodeAP_nIndex = numNodes-1;		//initialize to last node
		flagFinished = false;
		while (!flagFinished && lastNodeAP_nIndex != 0)	{
			int currNode = lastNodeAP_nIndex -1;	//scan the previous node for an AP
			int lastIter = lastNodeAP_tIndex;		//stop scanning at the time in which an AP was found on the following node
			boolean foundAP = false;
			//scan backwards
			for (int p = lastIter; p > -1; p--)	{
				//test for an AP
				if (Vt < v[currNode][p])	{
					foundAP = true;
					lastNodeAP_nIndex = currNode;	//keep track of where it occured
					lastNodeAP_tIndex = p;
				}
			}
			//if no AP was found, then lastNodeAP_nIndex and tIndex are final
			if (!foundAP)
				flagFinished = true;
		}
		
		result[0] = lastNodeAP_nIndex;
		result[1] = lastNodeAP_tIndex;
		return result;
	}
	
	//this function finds the threshold of each axon to the stimulus waveform
	//Vt is the threshold voltage of an action potential (deviation from Vrest)
	//maxIter prevents an infinite loop
	//precision sets the percentage difference between a subthreshold scale and a suprathreshold scale required ...
	//before naming the suprathreshold scale the threshold value
	//returns an array of the scale value required to cause waveform to initiate an AP
	//any negative value in the returned array indicates we could not find a threshold within precision given maxIter
	//a zero in the returned array indicates we were never even able to generate an AP given maxIter
	//maxMultiplier = maximum multiplier of waveform considerable before giving up
	//fileLog = where to print errors that may occur
	//startInd == what number axon to start simulating from (use matlab convention)
	//stopInd == what number axon to stop simulating from (use matlab convention)
	//if startInd or stopInd is out of bounds, you will get an error
	public double[] findThreshold(double[] waveform, double Vt, int maxIter, 
							double precision, double maxMultiplier, String fileLog,
								int startInd, int stopInd) throws Exception	{
		//get simulation information
		int numIterations = waveform.length + 1;  //add one because the initial condition is stored first
		int numAxons = Ve.length;
		int[] numNodes = new int[numAxons];
		for (int q = 0; q < numAxons; q++)	{
			numNodes[q] = Ve[q].length;
		}
		double[] result = new double[numAxons];
		AP = new int[numAxons][2];		
		boolean flagFinished;
		//prepare output window
		outputWindow.progress = 0;
		outputWindow.text = "Initializing...";
		outputWindow.setVisible(true);
		//open up the error log
		PrintWriter errLog = new PrintWriter(new FileOutputStream(fileLog, true));
		//output current information
		errLog.println("Error log for method findThreshold of Class AxonSimulate.");
		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		Date date = new Date();
		errLog.println(dateFormat.format(date));
		//simulate each nerve
		for (int i = (startInd-1); i < (stopInd); i++)	{
			double aboveThreshScale = 0;		//scale value always above threshold
			double currScale = 1;				
			double prevScale = 0;				//scale value always below the threshold
			int currentNumIter = 0;				//to prevent iterations beyond maxIter
			flagFinished = false;
			//update the output window
			outputWindow.progress = ((double)(i+1-startInd)/((double)(stopInd-startInd+1)));
			outputWindow.text = "Number of axons completed: " + (i+1-startInd);
			outputWindow.forceRepaint();
			while (!flagFinished)	{
				//take care of user exit
				if (flagError)	{
					//close error file
					errLog.println("User manually killed the java process.");
					errLog.println("End of session.");
					errLog.println("");errLog.println("");
					errLog.close();
					throw new Exception("User manually killed the java process.");
				}
				//create the nerve
				Axon a = initOneAxon(numIterations, numNodes[i], nodeDiam[i]);
				//now for the initial condition contingency
				if (flagInitialConditions)
					a.setInitialCondition(a.accessStateArray(initialCondition[i]));
				boolean flagOverFlow = false;
				//sometimes Euler's method diverges, especially for difficult cases
				//like simulations of bipolar simulations (failure is usually below
				//2% of all nerves simulated, so I manage these as if they were in 
				//refractory (probably are) and assign them a value of zero), everything
				//is logged in the file name specified
				try	{
					//simulate the nerve
					for (int j = 0; j < waveform.length; j++)	{
						//scale Ve to the waveform and the current scale value
						double[] temp = Ve[i].clone();	//must clone here, or you'll loose Ve
						for (int k = 0; k < temp.length; k++)	{
							temp[k] = temp[k] * waveform[j]*currScale;
							//make sure we don't overflow
							if (Double.isNaN(temp[k]) || Double.isInfinite(temp[k]))	{
								//for the overflow condition, set result to 0 and break out of the loop
								result[i] = 0;
								flagFinished = true;	//break the while loop
								flagOverFlow = true;	//prevent a compute call on bad data
								j = waveform.length;	//break the compute loop
								break;					//break the waveform scaling for loop
							}
						}
						if (!flagOverFlow)
							a.compute(temp);
					}
					if (flagOverFlow)
						break;			//break out of the loop in an overflow situation
					//was an action potential generated?
					int[] apInfo = findActionPotential(a.V, Vt);
					if (apInfo[0] == -1)	{
						//no AP generated, so scale up currScale
						if (aboveThreshScale == 0)	{
							//no AP generate yet, scale up FAST
							prevScale = currScale; 
							currScale = currScale * 10;
						}
						else	{
							//scale half way up
							prevScale = currScale;
							currScale = currScale + ((aboveThreshScale-currScale)/2);
						}
					}
					else	{
						//an AP was generated, so first see if we are finished
						if (((currScale-prevScale)/currScale) < precision)	{
							flagFinished = true;		//found within precision
							AP[i] = apInfo.clone();		//record the spike initiator zone
							result[i] = currScale;
						}
						else	{	//need to keep iterating and resolve the scale
							aboveThreshScale = currScale;
							currScale = prevScale + ((currScale-prevScale)/2);
						}
					}
					//have we gone too far?
					currentNumIter = currentNumIter + 1;
					if (currentNumIter > maxIter)	{
						if (aboveThreshScale != 0)	{
							//we have generated ap, but could not get the precision
							//so return the negative of aboveThreshScale to show
							//that we have a value, just not precise enough
							result[i] = -aboveThreshScale;
						}
						else	{
							//never generated an AP, so return a 0 to indicate failure
							result[i] = 0;		//indicate we didn't find a threshold
						}
						flagFinished = true;
					}
					//now see if we have gone beyond maxMultiplier
					if (currScale > maxMultiplier)	{
						result[i] = 0;		//indicate failure
						flagFinished = true;
					}
				}
				catch (Exception e){
					errLog.println("Error while simulating axon: " + (i+1));
					errLog.println("Exception output below...");
					errLog.print(e);
					errLog.println("");
					errLog.println("defaulting to a result of 0 for axon " + (i+1));
					result[i] = 0;
					flagFinished = true;
				}
			}
		}
		//close the error log
		errLog.println("End of session.");
		errLog.println("");errLog.println("");
		errLog.close();
		//hide the window
		outputWindow.setVisible(false);
		return result;
	}
	
}
