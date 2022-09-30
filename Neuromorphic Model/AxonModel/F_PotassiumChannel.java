/*  This class implements the basic potassium channel outlined by Frijns 1994 and
 * Darren Whiten, its very much like the Hodgkin Huxley potassium channel but
 * modified for mammalian mylinated axons
 */
import static java.lang.Math.PI;
import static java.lang.Math.exp;
import static java.lang.Math.pow;

public class F_PotassiumChannel extends Channel implements GlobalConstants {
	
	//constants, static so I can see them at any time
	public final static double Pk = 2.04e-6;		//(m/s)potassium permiability, a constant
	public final static double Aa = 0.02;			//(ms^-1)these contants are used for alpha method
	public final static double Ba = 35;				//mV
	public final static double Ca = 10;				//mV
	public final static double Q10a = 3.0;
	public final static double tempA = pow(Q10a, (0.1*(T-T0)));		//temperature dependence
	public final static double Ab = 0.05;			//(ms^-1)these constants are used for beta method
	public final static double Bb = 10;				//mV
	public final static double Cb = 10;				//mV
	public final static double Q10b = 3;
	public final static double tempB =  pow(Q10b, (0.1*(T-T0)));	//temperature dependence
	
	//class member variables
	public double n_old;					//previous/initial value of potassium activating factor
	

	public F_PotassiumChannel(double diameter, double length, double timeIncrement) {
		super(diameter, length, timeIncrement);	//call the inherited constructor to set the nodeDiameter and nodeLength variables
		n_old = 0.0267;				//initialization according to RH
	}

	//this returns the total current out of the node due to the potassium channel
	public double current(double Vm) {
		double area = PI*nodeDiameter*nodeLength;
		double new_n = n(Vm);
		//put in a small correction due to the denominator in the following equation
		if (Vm == 0)	{
			Vm = .00001;		//so we don't get an undefined
		}
		double result = Pk*pow(new_n,2)*((Vm*F*F)/(R*T));
		result = result*(Conc_KO - Conc_KI*exp(Vm*F/(R*T)));
		result = result/(1-exp(Vm*F/(R*T)));			//current per unit area
		result = result*area;							//total channel current
		n_old = new_n;				//update n for next iteration
		return result;
	}

	//setState method to set a specific initial condition
	public void setState(double[] args) throws Exception {
		try	{
			n_old = args[0];
		}
		catch (Exception e)	{
			throw new Exception("Illegal array passed to method setState of a Channel object.");
		}
	}

	//this method is used to get the current state
	public double[] getState()	{
		double[] output = new double[1];
		output[0] = n_old;
		return output;
	}
	
	//this method returns the size of the state array
	public int stateArrayLength()	{
		return 1;
	}
	
	//this is the potassium activating factor that describes the gating dynamics
	//this uses Euler's Method
	private double n(double Vm)	{
		double dn = alpha(Vm) - (alpha(Vm)+ beta(Vm))*n_old;	//time derivative of n
		double result = n_old + dn*(deltaT*1000);		//convert to mS
		return result;
	}
	
	//this method implements the voltage dependent forward rate constant for this channel
	//I use static so I can call it anytime I want to without an object variable (good for testing)
	public static double alpha(double Vm)	{
		double Vi = (Vm - Vrest)*1000;				//to make code easier to read
		double result = Aa*(Vi-Ba);
		result = result/(1-exp((Ba-Vi)/Ca));
		return result*tempA;
	}
	
	//this method implements the voltage dependent reverse rate constant for this channel
	//I use static so I can call it anytime I want to without an object variable (good for testing)
	public static double beta(double Vm)	{
		double Vi = (Vm - Vrest)*1000;
		double result = Ab*(Bb-Vi);
		result = result/(1-exp((Vi-Bb)/Cb));
		return result*tempB;
	}

}
