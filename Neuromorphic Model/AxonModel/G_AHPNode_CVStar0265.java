/*  This class implements the After Hyper Polarization characteristic
 * described by Smith and Goldberg in 1986
 * NOTE: this Node should only be placed at the hemiNode in an axon
 */

import static java.lang.Math.PI;
import static java.lang.Math.pow;

 class G_AHPNode_CVStar0265 extends Node {

	private double Cm_u = 0.02;	//(F/m^2)unit area leak membrane capacitance
	private double Gl_u = 728;	//(1/Ohm*m^2)unit area leak conductance
	private double Ra_u = 0.7;	//(ohm*m)unit axoplasmic resistivity
	public double Cm;			//(F) total membrande conductance
	public double Gl;			//(1/ohm) total leak conductance
	private double Vl = Vrest;	//(Volts) leakage voltage
	
	//some member variables
	public Channel channel_K;	//potassium channel
	public Channel	channel_Na;		//sodium channel
	public Channel channel_G;	//goldberg channel
	
	//for testing
	public double returnTest()	{
		double result;
		//result = ((G_SodiumChannel)channel_Na).h_old;
		result = ((G_AHPChannel_CVStar0265)channel_G).test;
		return result;
	}


	public G_AHPNode_CVStar0265(double diam, double len, double t_increment) {
		super(diam, len, t_increment);
		//initialize channels and variables
		channel_K = new F_PotassiumChannel(diam, len, t_increment);
		//implement a slightly modified sodium channel to allow for easier AP generation
		channel_Na = new G_SodiumChannel(diam, len, t_increment);
		channel_G = new G_AHPChannel_CVStar0265(diam, len, t_increment);
		Cm = Cm_u*PI*nodeDiameter*nodeLength;		//calc membrane capacitance
		Gl = Gl_u*PI*nodeDiameter*nodeLength;		//leakage conductance
		errLog.println("Created new node with Cm = "+Cm+", Gl = "+Gl);
	}

	public double compute(double Ve, double Ve_L, double Ve_R, double V,
			double V_L, double V_R, double distL, double distR, double diamL,
			double diamR) {
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		//begin by finding the ionic current
		double I_ion = channel_K.current(V + Vrest) + channel_Na.current(V + Vrest) + channel_G.current(V + Vrest);
		//now find the leakage current
		double I_leak = Gl*(V+Vrest-Vl);
		//find induced currents
		double I_ind = Ga_L*(V + Ve - V_L - Ve_L) + Ga_R*(V + Ve - V_R - Ve_R);
		//now find the voltage derivative
		double dV = (-1/Cm)*(I_ion + I_leak + I_ind);
		
		errLog.println("dV = "+dV+", Ve = "+Ve+", Ve_L = "+Ve_L+", Ve_R = "+Ve_R+ "distL = "+distL+", distR = "+distR+", diamL = "+diamL+", diamR = "+diamR);
		return (V + dV*deltaT);		//Euler's method, deltaT in seconds!
	}

	public double compute(double Ve, double Ve_L, double Ve_R, double V,
			double V_L, double V_R, double distL, double distR, double diamL,
			double diamR, double I) {
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		//begin by finding the ionic current
		double I_ion = channel_K.current(V + Vrest) + channel_Na.current(V + Vrest) + channel_G.current(V + Vrest);
		//now find the leakage current
		double I_leak = Gl*(V+Vrest-Vl);
		//find induced currents
		double I_ind = Ga_L*(V + Ve - V_L - Ve_L) + Ga_R*(V + Ve - V_R - Ve_R);
		//now find the voltage derivative
		double dV = (-1/Cm)*(I_ion + I_leak + I_ind - I);
		return (V + dV*deltaT);		//Euler's method, deltaT in seconds!
	}

	public boolean isActive() {
		return true;
	}

	public double[] getState() {
		double[] temp1, temp2, temp3;
		temp1 = channel_K.getState();			//get channel information
		temp2 = channel_Na.getState();
		temp3 = channel_G.getState();
		int size = temp1.length + temp2.length + temp3.length;
		double[] output = new double[size];
		for (int i = 0; i < temp1.length; i++)	{
			output[i] = temp1[i];
		}
		for (int i = 0; i < temp2.length; i++)	{
			output[i+temp1.length] = temp2[i];
		}
		for (int i = 0; i < temp3.length; i++)	{
			output[i+temp1.length+temp2.length] = temp3[i];
		}
		return output;
	}

	public void setState(double[] args) throws Exception {
		double[] temp1 = {args[0]};
		double[] temp2 = {args[1], args[2]};
		double[] temp3 = new double[args.length - 3];
		for (int i = 3; i < args.length; i++)	{
			temp3[i-3] = args[i];
		}
		channel_K.setState(temp1);				//set channel information
		channel_Na.setState(temp2);
		channel_G.setState(temp3);
	}

	//this method returns the size of the state array
	public int stateArrayLength()	{
		return (channel_K.stateArrayLength()+channel_Na.stateArrayLength()
											+channel_G.stateArrayLength());
	}

}
