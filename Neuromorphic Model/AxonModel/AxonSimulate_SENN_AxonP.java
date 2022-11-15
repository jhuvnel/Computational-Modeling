/*this class implements AxonSimulate for the Axon class SENN_AxonP
 * 
 */
import java.io.PrintWriter;

public class AxonSimulate_SENN_AxonP extends AxonSimulate {

	public AxonSimulate_SENN_AxonP() {
		super();
	}

	//this function intializes the axons array
	public void initAxonArray(int numIterations, int[] numNodes) throws Exception {
		axons = new Axon[Ve.length];
		for (int i = 0; i < axons.length; i++)	{
			//intialize each axon object
			axons[i] = new SENN_AxonP(step, nodeDiam[i], nodeLength_A, nodeLength_P, numNodes[i], timeIncrement, numIterations, null);
		}
	}
	public Axon initOneAxon(int numIterations, int numNodes, double[] nodeDiameter, PrintWriter errLog)	throws Exception {
		Axon r = new SENN_AxonP(step, nodeDiameter, nodeLength_A, nodeLength_P, numNodes, timeIncrement, numIterations, errLog);
		return r;
	}
}
