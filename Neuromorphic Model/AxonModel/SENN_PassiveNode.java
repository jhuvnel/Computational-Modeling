import static java.lang.Math.PI;
import static java.lang.Math.pow;

/*this class implements a passive node which just has leakage  and a membrane capacitance,
 * exactly the way Darren Whiten did it in his PhD dissertation, if one wants to model the
 * myelin as a perfect conductor then only use SENN_Active with large spacing
 */
public class SENN_PassiveNode extends Node implements GlobalConstants {

	//member variables
	//note Cm_u and Gl_u are extremly important, must be small or AP won't propogate
	private double Cm_u = 0.0000125;//(F/m^2)unit area leak membrane capacitance
	private double Gl_u = 0.125;	//(1/ohm*m^2)unit area leak conductance
	private double Ra_u = 0.7;	//(ohm*m)unit axoplasmic resistivity
	public double Cm;			//(F)total membrande conductance
	public double Gl;			//(1/ohm)total leak conductance
	private double Vl = Vrest;	//(Volts)leakage voltage

	public SENN_PassiveNode(double diam, double len, double t_increment) {
		super(diam, len, t_increment);
		Cm = Cm_u*PI*nodeDiameter*nodeLength;		//calc membrane capacitance
		Gl = Gl_u*PI*nodeDiameter*nodeLength;		//leakage conductance
	}

	//compute the new V, look to Node.java for documentation
	public double compute(double Ve, double Ve_L, double Ve_R, double V,
							double V_L, double V_R, double distL, double distR, double diamL, 
							double diamR) {
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		//begin by finding the ionic current
		double I_ion = 0;			//no ion current
		//now find the leakage current
		double I_leak = Gl*(V+Vrest-Vl);
		//find induced currents
		double I_ind = Ga_L*(V + Ve - V_L - Ve_L) + Ga_R*(V + Ve - V_R - Ve_R);
		//now find the voltage derivative
		double dV = (-1/Cm)*(I_ion + I_leak + I_ind);
		return (V + dV*deltaT);		//Euler's method (deltaT in seconds)
	}
	
	//same as above, but allows intracellular injection of current I (amperes)
	public double compute(double Ve, double Ve_L, double Ve_R, double V, 
			double V_L, double V_R, double distL, double distR, 
				double diamL, double diamR, double I)	{
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		//begin by finding the ionic current
		double I_ion = 0;			//no ion current
		//now find the leakage current
		double I_leak = Gl*(V+Vrest-Vl);
		//find induced currents
		double I_ind = Ga_L*(V + Ve - V_L - Ve_L) + Ga_R*(V + Ve - V_R - Ve_R);
		//now find the voltage derivative
		double dV = (-1/Cm)*(I_ion + I_leak + I_ind - I);
		return (V + dV*deltaT);		//Euler's method (deltaT in seconds)
	}
	
	public boolean isActive()	{
		return false;
	}

	//no state to return, nothing is remembered in this node
	public double[] getState() {
		double[] temp = {0};		//place holder
		return temp;
	}

	//do nothing
	public void setState(double[] args) throws Exception {

	}

	//this method returns the size of the state array
	public int stateArrayLength()	{
		return 1;
	}

}
