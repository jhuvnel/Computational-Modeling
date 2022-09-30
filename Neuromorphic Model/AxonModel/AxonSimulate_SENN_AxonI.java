/*this class implements AxonSimulate for the Axon class SENN_AxonI
 * 
 */


public class AxonSimulate_SENN_AxonI extends AxonSimulate {

	public AxonSimulate_SENN_AxonI() {
		super();
	}

	//this function intializes the axons array
	public void initAxonArray(int numIterations, int[] numNodes) throws Exception {
		axons = new Axon[Ve.length];
		for (int i = 0; i < axons.length; i++)	{
			//intialize each axon object
			axons[i] = new SENN_AxonI(step, nodeDiam[i], nodeLength_A, nodeLength_P, numNodes[i], timeIncrement, numIterations);
		}
	}
	public Axon initOneAxon(int numIterations, int numNodes, double[] nodeDiameter)	throws Exception {
		Axon r = new SENN_AxonI(step, nodeDiameter, nodeLength_A, nodeLength_P, numNodes, timeIncrement, numIterations);
		return r;
	}
}
