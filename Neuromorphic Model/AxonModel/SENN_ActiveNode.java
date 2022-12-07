/*this class implements the basic SENN node outlined in Frijns 1994,
 * this is also the one Darren Whiten uses
 */

import static java.lang.Math.pow;

import java.io.PrintWriter;

import static java.lang.Math.PI;

public class SENN_ActiveNode extends Node implements GlobalConstants {

	private double Cm_u = 0.02;	//(F/m^2)unit area leak membrane capacitance
	private double Gl_u = 728;	//(1/Ohm*m^2)unit area leak conductance
	private double Ra_u = 0.7;	//(ohm*m)unit axoplasmic resistivity
	public double Cm;			//(F) total membrande conductance
	public double Gl;			//(1/ohm) total leak conductance
	private double Vl = Vrest;	//(Volts) leakage voltage
	
	//some member variables
	private Channel channel_K;	//potassium channel
	private Channel	channel_Na;		//sodium channel

	//units in volts, seconds, meters
	public SENN_ActiveNode(double diam, double len, double t_increment, PrintWriter errorLog) {
		super(diam, len, t_increment, errorLog);
		//initialize channels and variables
		channel_K = new F_PotassiumChannel(diam, len, t_increment);
		channel_Na = new F_SodiumChannel(diam, len, t_increment);
		Cm = Cm_u*PI*nodeDiameter*nodeLength;		//calc membrane capacitance
		Gl = Gl_u*PI*nodeDiameter*nodeLength;		//leakage conductance
		//errLog.println(String.format("Created new SENN_ActiveNode with Cm = %.12f Gl = %.12f", Cm, Gl));
	}

	//note, currents due to membrane capacitance and leakage are computed here
	public double compute(double Ve, double Ve_L, double Ve_R, double V, 
							double V_L, double V_R, double distL, double distR, 
								double diamL, double diamR)	{
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		//begin by finding the ionic current
		double I_ion = channel_K.current(V + Vrest) + channel_Na.current(V + Vrest);
		//now find the leakage current
		double I_leak = Gl*(V+Vrest-Vl);
		//find induced currents
		double I_ind = Ga_L*(V + Ve - V_L - Ve_L) + Ga_R*(V + Ve - V_R - Ve_R);
		//now find the voltage derivative
		double dV = (-1/Cm)*(I_ion + I_leak + I_ind);
		return (V + dV*deltaT);		//Euler's method, deltaT in seconds!
	}
	
	//same as above, but allows intracellular injection of current I (amperes)
	public double compute(double Ve, double Ve_L, double Ve_R, double V, 
			double V_L, double V_R, double distL, double distR, 
				double diamL, double diamR, double I)	{
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		//begin by finding the ionic current
		double I_ion = channel_K.current(V + Vrest) + channel_Na.current(V + Vrest);
		//now find the leakage current
		double I_leak = Gl*(V+Vrest-Vl);
		//find induced currents
		double I_ind = Ga_L*(V + Ve - V_L - Ve_L) + Ga_R*(V + Ve - V_R - Ve_R);
		//now find the voltage derivative
		double dV = (-1/Cm)*(I_ion + I_leak + I_ind - I);
		return (V + dV*deltaT);		//Euler's method, deltaT in seconds!
	}


	public boolean isActive()	{
		return true;
	}

	public double[] getState() {
		double[] temp1, temp2;
		temp1 = channel_K.getState();			//get channel information
		temp2 = channel_Na.getState();
		double[] output = {temp1[0], temp2[0], temp2[1]};
		return output;
	}

	public void setState(double[] args) throws Exception {
		double[] temp = new double[2];
		channel_K.setState(args);				//set channel information
		temp[0] = args[1];	temp[1] = args[2];
		channel_Na.setState(temp);
	}

	//this method returns the size of the state array
	public int stateArrayLength()	{
		return 3;
	}

}
