/*  This class implements the After Hyper Polarization characteristic
 * described by Smith and Goldberg in 1986
 * NOTE: this channel encompasses both the synaptic input and the
 * AHP potassium current
 * NOTE: the values gk and gs are not independent of area, the ones
 * presented here are for a node diameter of 2.2e-6m, and a node length of 2e-6m
 */

import java.util.Arrays;
import static java.lang.Math.*;

public class G_AHPChannel_CVStar1483 extends Channel implements GlobalConstants {

	public double nernstNa;		//nernst potential of sodium
	public double nernstK;		//nernst potential of potassium
	public double[] shotNoiseMemory;	//holds the current state of the synaptic input
	public int noiseDelay;		//holds the amount of timeIters to wait before recomputing shot noise (0.1mS)
	public int currNoiseDelay;	//running sum to implement the delay
	//need to get gs in terms of unit area, also may need to modify it to work with this model
	public double gs = 0.7; //0.64 for nodeLen = 1um			//gs = strength of synaptic noise (roughly based off of "A" from smith/goldberg paper)
	//need to get gk0 in terns of unit area also
	public double gk0 = 1500;			//constant term for hyperpolarizing potassium current
	public double gk = 1500;	//1700 for nodeLen = 1um		//holds the current value of gk
	public double prev_gk = 0;		//stored value of a previous value of gk
	public double tk = 0.005;			//hyperpolarizing current time constant in seconds (from smith/goldberg paper)
	public int timeLastAP;		//time of the last action potential (number of iterations)
	public double gk_wait = 3e-4;		//amount of time (in seconds) after an AP before the gk current is turned back on
	public double Vt = -0.025;			//the minimum potential required to register an action potential
	public int numIters = 0;		//running sum of the amount of iterations
	public double shotNoiseInit = 75;	//what to initialize the shot noise memory too

	//for testing
	public double test;
	
	public G_AHPChannel_CVStar1483(double diameter, double length,
														double timeIncrement) {
		super(diameter, length, timeIncrement);
		//initialize the shotNoiseMemory to be 0.5mS long
		int arrayLength = (int) (0.0005/0.0001);
		shotNoiseMemory = new double[arrayLength];
		Arrays.fill(shotNoiseMemory, shotNoiseInit);	//don't start at all zeros
		//set the noiseDelay factor 
		noiseDelay = (int) (0.0001/((double)timeIncrement));
		currNoiseDelay = 1; 	//indicate to calculate noise right away
		timeLastAP = -1;		//-1 flags that we have not had an AP yet (synaptic noise should cause one soon)
		//calculate and store the nernst potentials
		nernstNa = ((R*T)/F)*log(Conc_NaO/Conc_NaI);
		nernstK = ((R*T)/F)*log(Conc_KO/Conc_KI);
	}

	//Vm = true voltage, not the deviation from rest (in Volts)
	public double current(double Vm) {
		numIters = numIters + 1;	//keep track of how many times this method has been called
		double area = PI*nodeDiameter*nodeLength;	//total area of the node
		//update the synaptic noise
		currNoiseDelay = currNoiseDelay - 1;
		if (currNoiseDelay == 0)	{	//time to recompute synaptic noise
			currNoiseDelay = noiseDelay;	//reset
			//generate a random variable of uniform distribution between 0 and 1
			double rand = Math.random();
			int randPD = findPoisson(rand);
			double gsAmount = randPD*gs;
			//push the shotNoiseMemory array
			for (int i = (shotNoiseMemory.length-1); i > 0 ; i--)	{
				shotNoiseMemory[i] = shotNoiseMemory[i-1];
			}
			shotNoiseMemory[0] = 0;
			//update the shotNoiseMemory
			for (int i = 0; i < shotNoiseMemory.length; i++)	{
				shotNoiseMemory[i] = shotNoiseMemory[i]+gsAmount;
			}
		}
		//update the hyperpolarizing potassium current
		//see if we are within our self imposed "refractory" period
		if (timeLastAP != -1 && ((numIters - timeLastAP)*deltaT) < gk_wait)	{
			test = 0;//test = (numIters - timeLastAP)*deltaT;
		}
		//check to see if there was an action potential, if so store its time
		else if (Vm > Vt)	{
			timeLastAP = numIters;		//store the current iteration number
			prev_gk = gk;
			gk = 0;
			test = 1;
		}
		else	{	//gk needs to be recomputed in this case
			double timePassed;
			if (timeLastAP == -1)
				timePassed = numIters*deltaT;
			else
				timePassed = abs(((numIters-timeLastAP)*deltaT)-gk_wait);
			gk = (gk0+prev_gk)*(pow(E, (-1*timePassed/tk)));
			test = 0;
		}
		
		double result;
		//AHP potassium current
		result = gk*area*(Vm-nernstK);
		//the only part of the shotNoiseMemory that influence the current is the last value
		result = result + shotNoiseMemory[shotNoiseMemory.length-1]*area*(Vm-nernstNa);
		return result;
	}

	//setState method to set a specific initial condition
	public void setState(double[] args) throws Exception {
		boolean errFlag = false;
		try	{
			double temp = args[0];
			if (temp != deltaT)	{	//deltaT must be the same as the initial condition
				errFlag = true;
				throw new Exception("temp");
			}
			nernstNa = args[1];
			nernstK = args[2];
			for (int i = 0; i < shotNoiseMemory.length; i++)	{
				shotNoiseMemory[i] = args[3+i];		//if the shotNoiseMemory array is of different size, probably get an exception
			}
			int sNS = shotNoiseMemory.length + 2;
			noiseDelay = (int) args[sNS+1];
			currNoiseDelay = (int) args[sNS+2];
			gk0 = args[sNS+3];
			gk = args[sNS+4];
			prev_gk = args[sNS+5];
			timeLastAP = (int) args[sNS+6];
			if (timeLastAP == -1)
				numIters = (int) args[sNS+7];
			else	{
				int tempDelay = (int) args[sNS+7];
				if (tempDelay == 1)
					tempDelay = 2;		//avoid the flag condition of -1
				numIters = 0;
				timeLastAP = -1*tempDelay;
			}
		}
		catch (Exception e)	{
			if (!errFlag)
				throw new Exception("Illegal array passed to method setState of a Channel object.");
			else
				throw new Exception("The euler time increment is inconsistent with an attempted initial condition assignment.");
		}
	}

	//this method is used to get the current state
	//note that this is timeStep sensitive, must use the same deltaT
	public double[] getState()	{
		int sNS = shotNoiseMemory.length;
		double[] output = new double[sNS+10];
		output[0] = deltaT;		//use this to check if deltaT is the same
		//save the nerst potentials
		output[1] = nernstNa;
		output[2] = nernstK;
		//save the shot noise memory
		for (int i = 0; i < shotNoiseMemory.length; i++)	{
			output[3+i] = shotNoiseMemory[i];
		}
		sNS = 2 + sNS;
		//save delay information for shot noise
		output[sNS+1] = noiseDelay;
		output[sNS+2] = currNoiseDelay;
		//store AHP channel info
		output[sNS+3] = gk0;
		output[sNS+4] = gk;
		output[sNS+5] = prev_gk;
		//AHP timing info
		output[sNS+6] = timeLastAP;
		if (timeLastAP == -1)
			output[sNS+7] = numIters;
		else
			output[sNS+7] = numIters-timeLastAP;
		return output;
	}

	//this method returns the size of the state array
	public int stateArrayLength()	{
		return (shotNoiseMemory.length+10);
	}
	
	//this process returns a random integer based off of the poisson distribution
	//that is used for this class (implemented below)
	public int findPoisson(double r)	{
		int result;
		result = Arrays.binarySearch(PoissonDistribution.pD_lam750_dTpt1ms, r);
		if (result < 0)	{	//key not explicitly found, so return the next largest value
			result = -1*(result + 1);
		}
		return result;
	}

}
