/*this class implements AxonSimulate for the Axon class G_AHPAxon_CVStar5082
 * 
 */
import java.io.PrintWriter;

public class AxonSimulate_G_AHPAxon_CVStar5082 extends AxonSimulate {

	public AxonSimulate_G_AHPAxon_CVStar5082() {
		super();
	}

	//this function intializes the axons array
	public void initAxonArray(int numIterations, int[] numNodes) throws Exception {
		axons = new Axon[Ve.length];
		for (int i = 0; i < axons.length; i++)	{
			//intialize each axon object
			axons[i] = new G_AHPAxon_CVStar5082(step, nodeDiam[i], nodeLength_A, nodeLength_P, numNodes[i], timeIncrement, numIterations, null);
		}
	}
	public Axon initOneAxon(int numIterations, int numNodes, double[] nodeDiameter, PrintWriter errLog)	throws Exception {
		Axon r = new G_AHPAxon_CVStar5082(step, nodeDiameter, nodeLength_A, nodeLength_P, numNodes, timeIncrement, numIterations, errLog);
		return r;
	}
}