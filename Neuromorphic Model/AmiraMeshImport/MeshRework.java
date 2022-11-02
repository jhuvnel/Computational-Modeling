/*this class contains utilities to rework and existing mesh, mainly creating new 
 * mesh that are of only nerve (to calculate nerve fiber trajectory)
 */

import java.util.ArrayList;

public class MeshRework implements KillJavaEventListener {
	
	public int[][] tMatrix;	//data matrices
	public int[][] dMatrix;
	public int[][] bndTriMatrix;
	public double[][] vMatrix;
	public int[][] bndIDMatrix;
	public int[] bndType;
	public boolean flagError;
	
//note, this is not a user friendly mesh, if you're going to use it, 
//assign all matrices first!

//this constructor is degenerated
	public MeshRework(int[][] tets, int[][] bndTri, int[][] bndID, int[] bndTypes)	{
		//initialize, be careful because these are all passed by reference, which means
		//that if you change them here, they will change the original matlab matrices
		tMatrix = tets;
		bndTriMatrix = bndTri;
		bndIDMatrix = bndID;
		bndType = bndTypes;
		//dMatrix will be created later
	}
	public MeshRework()	{
	}
	
//most likely constructor to be used
	public MeshRework(double[][] verts, int[][] tets, int[][] domains)	{
		vMatrix = verts;
		tMatrix = tets;
		dMatrix = domains;
	}
	//REMEMBER TO CONVERT TET MATRIX TO JAVA INDICES BEFORE USING nervAniso (matlab indices start at 1)
	//this function creates piecewise anisotropic nerves based off of a user defined
	//contour line (usrCont).  It will create new domains within the dMatrix for those
	//subdomains listed in nerveDom, maxDist is the maximum distance between tet and contour segment
	//that will allow assignment of that contour segment to that tet
	//it returns a list of the anisotropic tensors used by COMSOL
	//in case of an error, the tetrahedron's domain will default to the original number
	//use AnisoRotationMatrix.m to find the tensors appropriate for each segment in usrCont
	public void nerveAniso(double[][] usrCont, int[] nerveDom, double maxDist)	{
		double perpParam = 0;		//intersection parameter of tet to contour segment
		double[] currentCentMass = new double[3];	//center of mass of each tetrahedron
		double[] cntStepVec = new double[3];		//direction vector of contour segment
		boolean nerveFlag;					//flags if its a tet that should be processed
		boolean firstIterFlag;
		boolean flagFoundContour;	//used to flag whether or not a perp line was found between a point and the user defined contour

		double[] pntTemp = new double[3];
		double minPerpDist = 0;			//used to find the closest contour line segment
		
		//first, cycle through the unchanged domain matrix and find the maximum domain index
		int maxDomNum = 1;		//holds the max domain number, domain numbering starts at 1, not 0		
		for (int q = 0; q < dMatrix[0].length; q++)	{
			if (maxDomNum < dMatrix[0][q])
				maxDomNum = (int) dMatrix[0][q];
		}
		
		//cycle through all of the tetrahedrons and re-assign their subdomain numbers
		for (int q = 0; q < dMatrix[0].length; q++)	{
			//see if its a tet we care about
			nerveFlag = false;
			for (int p = 0; p < nerveDom.length; p++)	{
				if (dMatrix[0][q] == nerveDom[p])
					nerveFlag = true;
			}
			if (nerveFlag)	{
				//calculate the center of mass for this tet
				currentCentMass = RHMath.v(vMatrix,(int) tMatrix[0][q]); 
				currentCentMass = RHMath.vecAdd(currentCentMass, RHMath.v(vMatrix, (int) tMatrix[1][q]));
				currentCentMass = RHMath.vecAdd(currentCentMass, RHMath.v(vMatrix, (int) tMatrix[2][q]));
				currentCentMass = RHMath.vecAdd(currentCentMass, RHMath.v(vMatrix, (int) tMatrix[3][q]));
				currentCentMass = RHMath.mult(currentCentMass, 0.25);				
				//iterate through the contour lines, finding which one has a perp line that connects the closest
				//if no perp line exists, then leave that tet as its original domain (iso nerve)->should be rare
				firstIterFlag = true;
				flagFoundContour = false;		//reset
				for (int i = 0; i<(usrCont[0].length-1); i++)	{
					//find the perp vector paramiterization
					perpParam = RHMath.perpDistance(RHMath.v(usrCont, i),RHMath.v(usrCont, i+1), currentCentMass);
					//now check to see if we lie within the boundaries for this contour segment
					if (perpParam >= 0 && perpParam <= 1)	{
						//we lie within the contour, but is it the closest one to the stepNode?
						//find the perp intersection point
						flagFoundContour = true;		//signal a valid perp vector was found
						cntStepVec = RHMath.unitVec(RHMath.v(usrCont, i+1), RHMath.v(usrCont, i));
						pntTemp[0] = usrCont[0][i] + cntStepVec[0]*perpParam;
						pntTemp[1] = usrCont[1][i] + cntStepVec[1]*perpParam;
						pntTemp[2] = usrCont[2][i] + cntStepVec[2]*perpParam;
						if (firstIterFlag)	{	//first iteration case
							//current minimum distance
							minPerpDist = RHMath.dist2(currentCentMass, pntTemp);	
							dMatrix[0][q] = maxDomNum + i + 1;		//assign new domain number
							firstIterFlag = false;
						}
						else	{	//find the closest perpindicular contour
							if (RHMath.dist2(currentCentMass, pntTemp) < minPerpDist)	{
								minPerpDist = RHMath.dist2(currentCentMass, pntTemp);
								dMatrix[0][q] = maxDomNum + i + 1;		//assign new domain number
							}
						}			
					}
				}
				//make sure we haven't been influenced by a contour line that is way out 
				//in the middle of no where
				if (minPerpDist > (maxDist*maxDist))	{
					flagFoundContour = false;		//default to the closest vertex/segment pair (see below)
				}
				
				//now check to see if a perp line was not found, one may have not been found
				//if the currentCentMass lies on the obtuse side of a notch in the contour line
				if (!flagFoundContour)	{
					//no valid perp line was found, so the segment with the closest vertex 
					int closestContNode = 0;
					double minUsrVertsNodeDist = RHMath.dist2(RHMath.v(usrCont, closestContNode), currentCentMass);
					//cycle through all the usrVerts and find the closest one, the segment after it will
					//be used to as the domain assigned to this tet
					for (int i = 0; i<(usrCont[0].length-1); i++)	{
						double tempDist2 = RHMath.dist2(RHMath.v(usrCont, i), currentCentMass);
						if (minUsrVertsNodeDist > tempDist2)	{
							closestContNode = i;
							minUsrVertsNodeDist = tempDist2;
						}
					}
					//assign the domain as the segment just after the closest contour vertex
					dMatrix[0][q] = maxDomNum + closestContNode + 1;//assign new domain number
				}
			}
		}
	}
	
//no longer used
	//creates the domain matrix for the new mesh, note that all tets are set to a domain
	//of 1, except for those distal boundary ID (id = 2) and those that have medial ID
	//(these will have an ID of 3), that way they will force differing boundaries
	public int[][] createDomains()	{
		//initialize new domain matrix
		dMatrix = new int[1][tMatrix[0].length];
		//now cycle through all the tets, and figure out if their domain is 1, 2, or 3
		for (int i = 0; i < tMatrix[0].length; i++)	{
			double[] currentTet = {tMatrix[0][i], tMatrix[1][i], tMatrix[2][i], tMatrix[3][i]};
			int id = isBoundaryDefined(currentTet);
			if (id == -1)
				dMatrix[0][i] = 1;		//non-boundary tet
			else	{		//boundary tet found
				//now find what number boundary ID it is
				int bID = bndIDMatrix[0][id];
				//now use the bID to see what the user assigned that boundary in the param file
				int type = bndType[bID-1];  //one is minimum, so subtract 1 to get an array index
				dMatrix[0][i] = 2 + type;
			}
		}
		
		return dMatrix;
	}
	
	//returns the boundary ID of the surface of a tet (will only 1 boundary ID if multiple sides are defined)
	//return -1 if not defined, otherwise 0 for distal and 1 for medial
	public int isBoundaryDefined(double[] tet) {
		int id = -1;
		double[] tri0 = {tet[0], tet[1], tet[2]};
		double[] tri1 = {tet[0], tet[1], tet[3]};
		double[] tri2 = {tet[0], tet[2], tet[3]};
		double[] tri3 = {tet[1], tet[2], tet[3]};
		id = triangleIndex(tri0);
		if (id != -1)
			return id;
		id = triangleIndex(tri1);
		if (id != -1)
			return id;
		id = triangleIndex(tri2);
		if (id != -1)
			return id;
		id = triangleIndex(tri3);
		if (id != -1)
			return id;
		
		return -1;
	}
	
	//returns the index of the triangle in bndTri matrix, -1 if its not there
	public int triangleIndex(double[] tri)	{
		int index = -1;
		//cycle through the boundary triangle matrix
		for (int i = 0; i < bndTriMatrix[0].length; i++)	{
			if((tri[0] == bndTriMatrix[0][i] && tri[1] == bndTriMatrix[1][i] && tri[2] == bndTriMatrix[2][i]))
				index = i;
			else if ((tri[0] == bndTriMatrix[0][i] && tri[2] == bndTriMatrix[1][i] && tri[1] == bndTriMatrix[2][i]))
				index = i;
			else if ((tri[1] == bndTriMatrix[0][i] && tri[0] == bndTriMatrix[1][i] && tri[2] == bndTriMatrix[2][i]))
				index = i;
			else if ((tri[1] == bndTriMatrix[0][i] && tri[2] == bndTriMatrix[1][i] && tri[0] == bndTriMatrix[2][i]))
				index = i;
			else if ((tri[2] == bndTriMatrix[0][i] && tri[0] == bndTriMatrix[1][i] && tri[1] == bndTriMatrix[2][i]))
				index = i;
			else if ((tri[2] == bndTriMatrix[0][i] && tri[1] == bndTriMatrix[1][i] && tri[0] == bndTriMatrix[2][i]))
				index = i;
		}
		return index;
	}
	
	//this function returns a uniform 3d grid on which to sample a COMSOL solution,
	//it automatically trims the grid to be only present inside the simulation space
	//Thus, tMatrix should only be of the sim space your want points to be created within
	//Also, tMatrix needs to be changed from Matlab to Java array indexing convention
	//Please use the Matlab wrapper of this function whenever possible, it takes care of these issues
	//dist will be the distance between sample points (isotropic)
	//vMatrix can be the vertex matrix of the entire mesh
	public double[][] gridSampleComsol(double dist, double[][] vertMatrix, int[][] tetMatrix) throws Exception	{

		//implement a user interface because this can take awhile
		JavaWindow outputWindow;
		//create an output window
		outputWindow = new JavaWindow("Lead Field Grid Creation", false);
		//show information
		outputWindow.displayProgress = true;
		outputWindow.memFlag = true;
		outputWindow.displayText = true;
		flagError = false;
		//register with outputWindow
		outputWindow.addKillJavaEventListener(this);
		//prepare output window
		outputWindow.progress = 0;
		outputWindow.text = "Initializing...";
		outputWindow.setVisible(true);

		int[] temp = new int[2];
		ArrayList<double[]> resultetMatrix = new ArrayList<double[]>(0);
		//first find the spacial extents in the x, y and z direction
		double[][] boundingBox = RHMath.boundingBox(vertMatrix);
		double[] pnt = new double[3];
		double maxEdge;
		//preprocess maximum Edge
		maxEdge = FiberTrajGen.maxEdgeLength(tetMatrix, vertMatrix);
		//find the amount of total iterations accurately
		int totalIterations = 0;
		for (double x = boundingBox[0][0]; x<boundingBox[1][0]; x = x + dist)	{
			for (double y = boundingBox[0][1]; y<boundingBox[1][1]; y = y + dist)	{
				for (double z = boundingBox[0][2]; z<boundingBox[1][2]; z = z + dist)	{
					totalIterations = totalIterations+1;
				}
			}
		}
		outputWindow.text = "Total Number of Points to Test: " + totalIterations;
		outputWindow.forceRepaint();

		int iterations = 0;
		//now cycle through all possible grid points, eliminating those that are outside the subdomains
		for (double x = boundingBox[0][0]; x<boundingBox[1][0]; x = x + dist)	{
			for (double y = boundingBox[0][1]; y<boundingBox[1][1]; y = y + dist)	{
				for (double z = boundingBox[0][2]; z<boundingBox[1][2]; z = z + dist)	{
					//check if user hit "KillJava"
					if (flagError)	{
						throw new Exception("User manually killed the java process.");
					}
					pnt[0] = x; pnt[1] = y; pnt[2] = z;
					temp = FiberTrajGen.isInsideSubdomain(tetMatrix, vertMatrix, pnt, maxEdge);
					if (temp[0] != -1)	{  //this one is within the subdomain
						resultetMatrix.add(pnt.clone());
					}
					iterations = iterations + 1;
				}
				//update the output window
				outputWindow.progress = ((double) iterations)/(((double) totalIterations)*1.0);
				outputWindow.text = "Total Number of Points to Test: " + totalIterations;
				outputWindow.forceRepaint();
			}
		}
		//now create a new matrix to output from resultetMatrix (for easy matlab use)
		double[][] result = new double[3][resultetMatrix.size()];
		for (int i = 0; i<resultetMatrix.size(); i++)	{
			result[0][i] = resultetMatrix.get(i)[0];
			result[1][i] = resultetMatrix.get(i)[1];
			result[2][i] = resultetMatrix.get(i)[2];
		}
		//hide the window
		outputWindow.setVisible(false);
		return result;
	}

	//user interface stuff
	public void handleKillJavaEvent(KillJavaEvent e)	{
		flagError = true;
	}
	
}
