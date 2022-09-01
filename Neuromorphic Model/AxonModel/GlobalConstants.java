/*this class defines variables used in many expressions, using an interface like this
 * is equivalent to defining global constants in C++
 */
public interface GlobalConstants {
	
	double R = 8.314;			//gas constant (J/K*mol)
	double F = 96485;			//faraday's constant (Coluomb/mol)
	double Conc_NaO = 142.0;	//outside Sodium concentration (mol/m^3)
	double Conc_NaI = 10.0;		//inside Sodium concentration (mol/m^3)
	double Conc_KO = 4.2;		//outside Potassium concentration (mol/m^3)
	double Conc_KI = 141.0;		//inside Potassium concentration (mol/m^3)
	double T = 310.15;			//absolute temperature (K)
	double T0 = 293.15;			//corrected absolute temperature (K)
	double Vrest = -.0846;		//resting voltage of membrane potential (by GHK) (Volts)
	
}
