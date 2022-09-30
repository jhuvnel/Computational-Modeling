/*  This class implements the basic sodium channel outlined by Frijns 1994 and
 * Darren Whiten, its very much like the Hodgkin Huxley sodium channel but
 * modified for mammalian mylinated axons
 */

import static java.lang.Math.PI;
import static java.lang.Math.exp;
import static java.lang.Math.pow;

public class F_SodiumChannel extends Channel implements GlobalConstants {

	//constants, static so I can see them at any time
	public final static double Pna = 51.5e-6;		//sodium permiability, a constant (m/s)
	//rate constants for activation factor m
	public final static double Aa_m = 0.49;			//(ms^-1)these contants are used for alpha method
	public final static double Ba_m = 25.41;		//(mV)
	public final static double Ca_m = 6.06;			//(mV)
	public final static double Q10a_m = 2.2;		
	public final static double tempA_m = pow(Q10a_m, (0.1*(T-T0)));		//temperature dependence
	public final static double Ab_m = 1.04;			//(ms^-1)these constants are used for beta method
	public final static double Bb_m = 21;			//(mV)
	public final static double Cb_m = 9.41;			//(mV)
	public final static double Q10b_m = 2.2;	
	public final static double tempB_m =  pow(Q10b_m, (0.1*(T-T0)));	//temperature dependence
	//rate constants for inactivation factor h
	public final static double Aa_h = 0.09;			//(mS^-1)these contants are used for alpha method
	public final static double Ba_h = -27.74;		//mV
	public final static double Ca_h = 9.06;			//mV
	public final static double Q10a_h = 2.9;
	public final static double tempA_h = pow(Q10a_h, (0.1*(T-T0)));		//temperature dependence
	public final static double Ab_h = 3.7;			//(mS^-1)these constants are used for beta method
	public final static double Bb_h = 56;			//(mV)
	public final static double Cb_h = 12.5;			//(mV)
	public final static double Q10b_h = 2.9;
	public final static double tempB_h =  pow(Q10b_h, (0.1*(T-T0)));	//temperature dependence

	//class member variables
	public double m_old;					//previous/initial value of sodium activation factor
	public double h_old;					//previous/initial value of sodium inactivation factor

	public F_SodiumChannel(double diameter, double length, double timeIncrement) {
		super(diameter, length, timeIncrement);
			m_old = 0.0077;					//from Darren Whiten
			h_old = 0.76;	//Darren had this one switched with n_old	
	}

	public double current(double Vm) {
		double area = PI*nodeDiameter*nodeLength;	//total area of the node
		double new_m = m(Vm);			//get new gating variables
		double new_h = h(Vm);
		//put in a small correction due to the denominator in the following equation
		if (Vm == 0)	{
			Vm = .00001;		//so we don't get an undefined
		}
		double result = Pna*new_h*pow(new_m,3)*(Vm*F*F/(R*T));
		result = result*(Conc_NaO - Conc_NaI*exp(Vm*F/(R*T)));
		result = result/(1-exp(Vm*F/(R*T)));		//current per unit area
		result = result*area;					//total current contribution of sodium
		m_old = new_m;					//update gating variables for next iteration
		h_old = new_h;
		return result;
	}
	
	//setState method to set a specific initial condition
	public void setState(double[] args) throws Exception {
		try	{
			m_old = args[0];		//attempt to access the parameters
			h_old = args[1];
		}
		catch (Exception e)	{
			throw new Exception("Illegal array passed to method setState of a Channel object.");
		}
	}

	//this method is used to get the current state
	public double[] getState()	{
		double[] output = new double[2];
		output[0] = m_old;
		output[1] = h_old;
		return output;
	}

	//this method returns the size of the state array
	public int stateArrayLength()	{
		return 2;
	}
	
	//this is the sodium activating factor that describes the gating dynamics
	//this uses Euler's Method
	public double m(double Vm)	{
		double dm = alpha_m(Vm) - (alpha_m(Vm) + beta_m(Vm))*m_old;	//time derivative of m
		double result = m_old + dm*(deltaT*1000);	//convert to mS
		return result;
	}

	//this is the sodium inactivating factor that describes the gating dynamics
	//this uses Euler's Method
	public double h(double Vm)	{
		double dh = alpha_h(Vm) - (alpha_h(Vm) + beta_h(Vm))*h_old;	//time derivative of h
		double result = h_old + dh*(deltaT*1000);	//convert to mS
		return result;
	}

	//these methods implement the voltage dependent forward rate constant for this channel
	//I use static so I can call it anytime I want to without an object variable (good for testing)
	public static double alpha_m(double Vm)	{
		double Vi = (Vm - Vrest)*1000;				//to make code easier to read
		double result = Aa_m*(Vi-Ba_m);
		result = result/(1-exp((Ba_m-Vi)/Ca_m));
		return result*tempA_m;				//temp correction factor
	}

	public static double alpha_h(double Vm)	{
		double Vi = (Vm - Vrest)*1000;				//to make code easier to read
		double result = Aa_h*(Ba_h-Vi);
		result = result/(1-exp((Vi-Ba_h)/Ca_h));
		return result*tempA_h;				//temp correction
	}
	
	//these methods implement the voltage dependent reverse rate constant for this channel
	//I use static so I can call it anytime I want to without an object variable (good for testing)
	public static double beta_m(double Vm)	{
		double Vi = (Vm - Vrest)*1000;
		double result = Ab_m*(Bb_m - Vi);
		result = result/(1-exp((Vi-Bb_m)/Cb_m));
		return result*tempB_m;
	}

	public static double beta_h(double Vm)	{
		double Vi = (Vm - Vrest)*1000;
		double result = Ab_h/(1+exp((Bb_h-Vi)/Cb_h));
		return result*tempB_h;
	}
}
