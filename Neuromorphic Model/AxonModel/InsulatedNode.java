import static java.lang.Math.PI;
import static java.lang.Math.pow;

import java.io.PrintWriter;

/*This class implements a perfectly insulated node, like for situations when
 * you want to model the myelin as a perfect insulator
 * Although this would be simple to implement in Axon, its provided as 
 * a wrapper for the code for convenience and code readibility within Axon sub-classes
 */
public class InsulatedNode extends Node implements GlobalConstants {

	private double Ra_u = 0.7;	//(ohm*m)unit axoplasmic resistivity

	//nothing to do in this constructor yet
	public InsulatedNode(double diam, double len, double t_increment, PrintWriter errorLog) {
		super(diam, len, t_increment, errorLog);
		//errLog.println("Created new InsulatedNode");
	}

	public double compute(double Ve, double Ve_L, double Ve_R, double V,
			double V_L, double V_R, double distL, double distR, 
			double diamL, double diamR) {
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		double result = (V_L*Ga_L + V_R*Ga_R)/(Ga_L+Ga_R);		//weighted average
		return result;
	}

	public double compute(double Ve, double Ve_L, double Ve_R, double V,
			double V_L, double V_R, double distL, double distR, 
			double diamL,double diamR, double I) {
		//left and right axon conductances
		double Ga_L = (PI/(Ra_u*distL))*pow((diamL/2),2);	//axon conductance left
		double Ga_R = (PI/(Ra_u*distR))*pow((diamR/2),2);	//axon conductance right
		double result = (V_L*Ga_L + V_R*Ga_R + I)/(Ga_L+Ga_R);		//weighted average
		return result;
	}

	public boolean isActive() {
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
