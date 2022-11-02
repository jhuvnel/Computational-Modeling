/* this class is used to create the individual fiber tracks for neurons
 * that will be modelled inside an existing FEM model
 */

import java.util.HashMap;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Iterator;
import static java.lang.Math.*;

import java.lang.Integer;

//WARNING: java begins indexing at 0, so you need to -1 from tMatrix and bndMatrix
//with the function processMatrices()
//WARNING: due to this, you will have to add one when using these matrices in MATLAB
public class FiberTrajGen {

	//data matrices
	public double[][] vMatrix;
	public int[][] tMatrix;
	public int[][] bndMatrix;		//seed surface
	public double[][] bndTriNormals;//normals to the seed surface
	public int[][] outerTriMatrix;	//holds the outer surface of the nerve domain
	public double[][] outerTriNormals;	//normals to the outer boundary
	public HashMap<Integer, ArrayList<Integer>> outerTriVert;	//preprocessed information on how outer triangles relate to vertices
	public HashMap<Integer, double[]> seedVerts;//data matrix of seed surface (flattened)
	public ArrayList<int[]> contMatrix;			//holds the contour of the seed surface
	public double[] centerOfMass;				//where the flatten surface center of mass is
	public double maxEdgeLength; //maximum edge length of all tets in tMatrix
	public double[][] usrVerts;  //holds the contour line that describes the nerve (specified by the user)
	
	//flags
	private boolean flagTestInsideSubdomain;	//if true (the default), each generated node will be tested for being inside the nerve (slow)
	
//	for testing -------------------------------------------------------------------
	public int[] test0;
	public double[] test1;
	public double[] test2;
	public double[] test12;
	public double test3;
	public double test4;
	public double test5;
	public double test6;
	public double test7;	
	public static void main(String[] args) throws Exception {
		testFiberTrajGen();
		
	}	
	public static void testFiberTrajGen() throws Exception	{
		double offset = 0.5;
		double[] step = {0.25, -1};
		double locIndex = 10;
		double endDist = 0.3;
		double nominalRadius = 1;
		int maxIterAmount = 10000;
		
		double[][] vMatrix = {{1, 1, 1, 0}, 
							  {0, 1, 0, 0}, 
							  {0, 0, 1, 0}};

		int[][] tMatrix = {{1},{2},{3},{4}};

		double[][] contMatrix = {{2,0,-1},
								 {0.3,0.3,0.3},
								 {0.3,0.3,0.3}};
		int[][] bndMatrix = {{1},
								{2},
								{3}};
		int[][] outerBndMatrix = {{1},
								  {2},
								  {3}};

		FiberTrajGen g = new FiberTrajGen(vMatrix, tMatrix, bndMatrix, outerBndMatrix,contMatrix);
		g.generateTrajectory(step, locIndex, offset, endDist, nominalRadius, maxIterAmount);
	}
//end for testing----------------------------------------------------------------


	
	//creates a FiberTrajGen object, nodes = vertex matrix, tets = matrix of NERVE TETS ONLY
	//and bndBegin = boundary triangle matrix of the crista
	//bndOuter holds all of the outer triangles of the nerve subdomain (bndBegin should be a subset of this)
	//contour holds the verts of the contour that describes the center of the nerve (user defined)
	public FiberTrajGen(double[][] nodes, int[][] tets, int[][] bndBegin, 
							int[][] bndOuter, double[][] contour) throws Exception	{
		//initialize variables
		vMatrix = nodes;
		tMatrix = tets;
		bndMatrix = bndBegin;
		outerTriMatrix = bndOuter;
		usrVerts = contour;
		processMatrices();		//adjust indices so that the make since with Java, and not Matlab
		
		//now preprocess for ray-triangle intersection test
		outerTriNormals = computeTriNormals(outerTriMatrix);
		bndTriNormals = computeTriNormals(bndMatrix);
		//finish preprocessing for seed node generation
		maxEdgeLength = FiberTrajGen.maxEdgeLength(tMatrix, vMatrix);	//preprocess longest edge length
		flattenSeedSurface();		//populates seedVerts
		findContour();				//populates contMatrix (the external edge of the surf)
		findCenterOfMass();			//ok for now, but won't work in general case (needs to be user input)
		//preprocess for trajectory generation while loop
		preprocessOuterSurface();	//can be slow, but will greatly improve speed of generateTrajectory	
		flagTestInsideSubdomain = true;		//test if each node is within the nerve, may use the command subdomainTestOff to set to false
	}
	public void subdomainTestOff()	{
		flagTestInsideSubdomain = false;
	}
	public void subdomainTestOn() 	{
		flagTestInsideSubdomain = true;
	}
	//for testing
	public FiberTrajGen()	{	
	}
	//for testing
	public void setParams(double[][] nodes, int[][] tets, int[][] bndBegin, 
			int[][] bndOuter, double[][] contour) throws Exception	{

		//initialize variables
		vMatrix = nodes;
		tMatrix = tets;
		bndMatrix = bndBegin;
		outerTriMatrix = bndOuter;
		usrVerts = contour;
		processMatrices();		//adjust indices so that the make since with Java, and not Matlab
		
		//now preprocess for ray-triangle intersection test
		outerTriNormals = computeTriNormals(outerTriMatrix);
		bndTriNormals = computeTriNormals(bndMatrix);
		//finish preprocessing for seed node generation
		maxEdgeLength = FiberTrajGen.maxEdgeLength(tMatrix, vMatrix);	//preprocess longest edge length
		flattenSeedSurface();		//populates seedVerts
		findContour();				//populates contMatrix (the external edge of the surf)
		findCenterOfMass();			//ok for now, but won't work in general case (needs to be user input)
		//preprocess for trajectory generation while loop
		preprocessOuterSurface();	//can be slow, but will greatly improve speed of generateTrajectory	
}	

	//this method generates fiber trajectories, step = internode distance array and
	//a -1 in the step array will cause the trajectory to finish filling with the internode distance of the previous element
	//locIndex specifies where on the crista they will originate (10 = near center of crista, 0 = on edge of periphery)
	//offset = how far from the seed surface to travel (should be the depth to the basement membrane)
	//endDist = how close to the last usrVerts node we should get before finishing 
	//nominalNerveRadius = average radius of the nerve trunk, maxIterAmount = maximum allowed iterations
	//NOTICE!!!:: This is not garuanteed to generate a trajectory, if a node is generated outside the Nerve subdomain it will return NULL
	//The seedNode is the most likely to be outside the nerve, however all other nodes are tested (this test can be turned off for speed)
	//It will also fail if the seed node cannot connect to the first contour segment perpindicullarly
	//KEEP nominalNerveRadius as small as possible!!!, otherwise will run for hours
	public double[][] generateTrajectory(double[] step, double locIndex, double offset, double endDist,
											double nominalNerveRadius, int maxIterAmount) throws Exception	{
		
		endDist = pow(endDist,2);	//use the square of the distance because its faster
		int maxIter = 0;			//stop the iterations if an infinite loop is encountered, or if an unneccisarily small step distance
		ArrayList<double[]> result = new ArrayList<double[]>(0);  //will hold the growing trajectory
		boolean flagFinished = false;	//flags when the trajectory is complete
		
		//generate a seed node
		//
		//
		double[] node;
		node = seedNode(locIndex);
		int seedTriInd = inTriangle(node);		//figure out which triangle its in in bndMatrix
		node = map3D(node);			//map it into 3-space
		//now, in order to compute the normal that faces into the nerve find the tet node its on
		int[] seedTetInd = bndNeighbors((int) bndMatrix[0][seedTriInd],(int) bndMatrix[1][seedTriInd],(int) bndMatrix[2][seedTriInd]);
		int seedTetVert4Ind = 0;
		if (seedTetInd[0] != -1)	{
			seedTetVert4Ind = findUniqueVert((int) bndMatrix[0][seedTriInd],(int) bndMatrix[1][seedTriInd],(int) bndMatrix[2][seedTriInd], seedTetInd[0]);
		}
		else	{
			seedTetVert4Ind = findUniqueVert((int) bndMatrix[0][seedTriInd],(int) bndMatrix[1][seedTriInd],(int) bndMatrix[2][seedTriInd], seedTetInd[1]);
		}
		//now compute the normal vector to the seedTri
		double[] seedV1V0 = RHMath.vecSub(RHMath.v(vMatrix,(int) bndMatrix[1][seedTriInd]), RHMath.v(vMatrix,(int) bndMatrix[0][seedTriInd])); 
		double[] seedV2V0 = RHMath.vecSub(RHMath.v(vMatrix,(int) bndMatrix[2][seedTriInd]), RHMath.v(vMatrix,(int) bndMatrix[0][seedTriInd])); 
		double[] seedTriNormal = RHMath.cross(seedV1V0,seedV2V0);
		//now see if it points the right direction
		if (RHMath.dot(seedTriNormal,RHMath.vecSub(RHMath.v(vMatrix,seedTetVert4Ind), RHMath.v(vMatrix,(int) bndMatrix[0][seedTriInd]))) < 0)
			seedTriNormal = RHMath.mult(seedTriNormal, -1);  //if point outward
		seedTriNormal = RHMath.unitVec(seedTriNormal);	//normalize
		//now advance the seed node by the offset amount to finish the trajectory start
		node = RHMath.vecAdd(node, RHMath.mult(seedTriNormal,offset));
		result.add(node.clone());		//put in the first node!	
		//
		//
		//Done generating a seed node

		//variables used for the while loop below
		//
		double[] pntCnt = new double[3];	//used to hold the current point on the usr contour we are at
		double[] pntCntTemp = {0,0,0,0};	//used to find the next pntCnt
		double[] stepNode = new double[3];	//extrapolation of previous node (stepped forward) to finish defining a ray through the nerve from pntCnt
		double[] stepVec = new double[3];	//holds the current step direction
		double temp;
		double[] triIntersection = new double[3]; //coordinates of where the ray itnersects a triangle
		double[] triIntersectionTemp;
		ArrayList<Integer> triList;			//used to hold triangles close to pntCnt (possible intersections)
		double[] unitVecTemp;	//unit vector of ray from pntCnt to stepNode
		int currentStep;		//the current step distance we are on
		int flagFill;			//indicates whether or not to finish filling with the previous distance
		boolean firstIter;		//a flag to indicate first execution
	
		
		//find the first pntCnt by finding where it makes a perp vector with the first segment
		//Returns null if this does not happen (probably due to a poor contour line or too large of an offset)
		//
		//
		temp = RHMath.perpDistance(RHMath.v(usrVerts, 0),RHMath.v(usrVerts, 1), node);
		//now check to see if we lie within the boundaries for this contour segment
		if (temp >= 0 && temp <= 1)	{
			//find current step vector
			stepVec[0] = usrVerts[0][1]-usrVerts[0][0];
			stepVec[1] = usrVerts[1][1]-usrVerts[1][0];
			stepVec[2] = usrVerts[2][1]-usrVerts[2][0];
			//initialize pntCnt
			pntCnt[0] = usrVerts[0][0] + stepVec[0]*temp;
			pntCnt[1] = usrVerts[1][0] + stepVec[1]*temp;
			pntCnt[2] = usrVerts[2][0] + stepVec[2]*temp;
		}
		else {		//couldn't make a perp line between the seed node and segment one
			return null;
		}

		stepNode = node.clone();			//step node will trace out a parallel contour to the user defined contour
		pntCntTemp[3] = RHMath.dist(pntCnt, RHMath.v(usrVerts, 0));		//need this distance to find the nex pntCnt
		//see if the randomly generated seed node is within the subdomain
		//do this after the perpDistance call so the exception may be thrown if offset is outrageous
		int[] validNodeTemp = isInsideSubdomain(tMatrix, vMatrix, node, maxEdgeLength);
		if (validNodeTemp[1] == -1)
			return null;		//this node was invalid, return null
		//
		//
		//Done intializing pntCnt and stepNode and pntCntTemp

		//now begin the iteration as we step through the usr defined contour, sticking to the locIndex
		//factor for staying in the correct relitive location within the nerve cross-section
		//
		//
		currentStep = -1;		//initialize
		flagFill = 1;
		while (!flagFinished)	{
			//step along the contour line and find the new pntCnt
			currentStep = currentStep + flagFill;
			pntCntTemp = nextLocation(pntCntTemp[3], step[currentStep]);
			if (pntCntTemp == null)		//have we reached the end of the contour?
				break;					//break out of the while loop
			//find the current stepVector
			stepVec[0] = pntCntTemp[0] - pntCnt[0];
			stepVec[1] = pntCntTemp[1] - pntCnt[1];
			stepVec[2] = pntCntTemp[2] - pntCnt[2];
			//now update pntCnt
			pntCnt[0] = pntCntTemp[0]; pntCnt[1] = pntCntTemp[1]; pntCnt[2] = pntCntTemp[2];
			//now update stepNode
			stepNode = RHMath.vecAdd(stepNode, stepVec);
			//the ray is now defined as going from pntCnt through stepNode
			//try to find a triangle intersection
			triList = findCloseTri(pntCnt, nominalNerveRadius);
			//cycle through all of these triangles and see if we have an intersection
			firstIter = true;
			for (int i = 0; i<triList.size(); i++)	{
				//need to find the smallest distance from pntCnt 
				//because there may be multiple intersections for overlapping triangles
				triIntersectionTemp = rayTriIntersection(triList.get(i).intValue(), pntCnt, stepNode,
															outerTriMatrix, outerTriNormals);	
				//was there an intersection?
				if (triIntersectionTemp != null && triIntersectionTemp[0] != -1)	{
					//has triIntersection been assigned yet?
					if (firstIter)	{
						triIntersection = triIntersectionTemp.clone();
						firstIter = false;
					}
					else {	//check to see if the new intersection is closer
						temp = RHMath.dist2(triIntersectionTemp, pntCnt);
						if (temp < RHMath.dist2(triIntersection, pntCnt))	{
							triIntersection = triIntersectionTemp.clone();
						}
					}
				}
			}
			//check to see if there was an intersection, if so then find that distance, use locIndex and place node at that point
			if (!firstIter){
				temp = RHMath.dist(triIntersection,pntCnt)*((10-locIndex)/10);
				unitVecTemp = RHMath.unitVec(stepNode, pntCnt);
				//keep within the nominalNerveRadius
				if (temp > (nominalNerveRadius*((10-locIndex)/10)))	
					temp = nominalNerveRadius*((10-locIndex)/10);
				unitVecTemp = RHMath.mult(unitVecTemp, temp);	//use locIndex
				node = RHMath.vecAdd(pntCnt, unitVecTemp);	//find the new node
				//see if within the subdomain
				if (flagTestInsideSubdomain)	{
					int[] validNode = isInsideSubdomain(tMatrix, vMatrix, node, maxEdgeLength);
					if (validNode[1] == -1)
						return null;		//this node was invalid, return null
				}
				result.add(node.clone());
			}
			//if not, then use nominal distance and locIndex to place a node
			else	{
				temp = nominalNerveRadius*((10-locIndex)/10);
				unitVecTemp = RHMath.unitVec(stepNode, pntCnt);
				unitVecTemp = RHMath.mult(unitVecTemp, temp);	//use locIndex
				node = RHMath.vecAdd(pntCnt, unitVecTemp);	//find the new node
				//see if within the subdomain
				if (flagTestInsideSubdomain)	{
					int[] validNode = isInsideSubdomain(tMatrix, vMatrix, node, maxEdgeLength);
					if (validNode[1] == -1)
						return null;		//this node was invalid, return null
				}
				result.add(node.clone());
			}
			
			//check to see if we are finished, if we are endDist away from the last vertex
			//in the user defined contour
			if (RHMath.dist2(RHMath.v(usrVerts, (usrVerts[0].length-1)), pntCnt) < endDist)
				flagFinished = true;
			//check to see if we exhausted the step array
			if (currentStep == (step.length -1))
				flagFinished = true;
			else if (step[currentStep+1] == -1)		//or have we reached a fill condition
				flagFill = 0;			//fill until we get endDist from last usrVerts node
			//take care of an unexpected error, may also be caused by a very small step size
			maxIter = maxIter + 1;
			if (maxIter > maxIterAmount)
				throw new Exception("Max iterations reached for method generateTrajectory in the FiberTrajGen class.");
		}
		//now create a new matrix to output (for easy matlab use)
		double[][] resultMat = new double[3][result.size()];
		for (int i = 0; i<result.size(); i++)	{
			resultMat[0][i] = result.get(i)[0];
			resultMat[1][i] = result.get(i)[1];
			resultMat[2][i] = result.get(i)[2];
		}
		return resultMat;
	}
	
	//this process automates generateTrajectory, generating numToGen fiber tracks
	//each fiber will use the same internode distance array (step), however
	//each may have a different locIndex (use -1 as a fill condition), offset
	//remains the depth to the basement membrane, and endDist = stop distance from the last contour point
	//nominalNerveRadius and maxIterAmount are also the same as for generateTrajectory
	//maxOutOfSub sets the sensitivity to failed trajectory generations (its max amount
	//allowable, so an infinite loop isn't created if offset is too large or something)
	public double[][][] bulkGenerateTrajectory(int numToGen, double[] step, double[] locIndex, double offset, double endDist,
											double nominalNerveRadius, int maxIterAmount, int maxOutOfSub) throws Exception	{
		double[][][] result = new double[numToGen][3][];
		double currLocIndex;
		int currLocIndexInc = 1;
		int currLocIndexPos = -1;
		double[][] temp;
		boolean flagSuccessful;
		int currNumFails = 0;
		//loop through all trajectories
		for (int i = 0; i < numToGen; i++)	{
			//update curLocIndex;
			currLocIndexPos = currLocIndexPos + currLocIndexInc;
			if (currLocIndexPos != (locIndex.length-1))	{
				if (locIndex[currLocIndexPos + 1] == -1)
					currLocIndexInc = 0;		//fill condition
			}
			//update the locIndex
			currLocIndex = locIndex[currLocIndexPos];
			flagSuccessful = false;	//wait until 
			while (!flagSuccessful)	{
				temp = generateTrajectory(step, currLocIndex, offset, endDist,
													nominalNerveRadius, maxIterAmount);
				if (temp == null)		{	//failure
					currNumFails = currNumFails + 1;
					if (currNumFails > maxOutOfSub)
						throw new Exception("Error. bulkGenerateTrajectory has failed due to exceeding maxOutOfSub generate failures.");						
				}
				else	{
					result[i] = temp;
					flagSuccessful = true;
				}
			}
		}
		
		return result;
	}
		
		
//legacy:		
/*	//this method generates fiber trajectories, step = step distance (distance between points)
	//and locIndex specifies where on the crista they will originate (see method seedNode)
	//offset = how far from the seed surface to travel (should be the depth to the basement membrane)
	//endDist = minimum distance to the end surface (medial surface) to stop building a trajectory
	//endSurfID tells the algorithm which surface to stop at
	//import the sampled data points first!
	public double[][] generateTrajectory(double step, double locIndex, double offset, double endDist) throws Exception	{

		int maxIter = 0;			//stop the iterations if an infinite loop is encountered
		ArrayList<double[]> result = new ArrayList<double[]>(0);  //will hold the growing trajectory
		boolean flagFinished = false;	//flags when the trajectory is complete
		int checkDone = 0;			//causes us to check "doneness" on non-consecutive iterations
		double[] temp = new double[2];
		//generate a seed node
		double[] node;
		node = seedNode(locIndex);
		node = map3D(node);			//map it into 3-space
		//find the nearest node in the sampleVerts to this seed node
		int nodeSampInd;
		nodeSampInd = RHMath.closestNode(node, sampleVerts);
		//move it by the offset amount
		double[] jVec = RHMath.unitVec(RHMath.v(jVector, nodeSampInd));	//find current 
		node = RHMath.vecAdd(node, RHMath.mult(jVec, offset));
		result.add(node.clone());		//put in the first node!
		//now begin the iteration
		while (!flagFinished)	{
			//find the nearest node in sampleVerts
			nodeSampInd = RHMath.closestNode(node, sampleVerts);
			jVec = RHMath.unitVec(RHMath.v(jVector, nodeSampInd));	//find current			
			node = RHMath.vecAdd(node, RHMath.mult(jVec, step));
			result.add(node.clone());		//save that node
			
			if (checkDone <= 0)	{	//check to see if we are close enough to stop
				temp = distToBnd(node);
				if (temp[0] < endDist)
					flagFinished = true;		//close enough to the surface
				else if (temp[0] > (step*1000))	//otherwise, make it so we don't run this unnecessarily 
					checkDone = 900;
				else if (temp[0] > (step*100))
					checkDone = 90;
				else if (temp[0] > (step*20))
					checkDone = 15;
				else if (temp[0] > (step*10))
					checkDone = 5;
				else
					checkDone = 1;
			}
			checkDone = checkDone - 1;
			//take care of an unexpected error, may also be caused by a very small step size
			maxIter = maxIter + 1;
			//this could be caused by overshooting your ground surface, or having an overly small step value
			if (maxIter >10000)
				throw new Exception("Max iterations reached for method generateTrajectory in the FiberTrajGen class.");
		}
		//now create a new matrix to output (for easy matlab use)
		double[][] resultMat = new double[3][result.size()];
		for (int i = 0; i<result.size(); i++)	{
			resultMat[0][i] = result.get(i)[0];
			resultMat[1][i] = result.get(i)[1];
			resultMat[2][i] = result.get(i)[2];
		}
		return resultMat;
	}
*/
	//this method takes a given FiberTrajGen object and creates a seed node for a trajectory
	//returning a seedNode based off of locIndex (10 = near center of crista, 0 = on edge of periphery)
	//still need to map this to the 3D version of the crista
	public double[] seedNode(double locIndex)	{
		//loop until we generate something within the surface
		boolean flag = false;
		double[] result = null;
		while (!flag)	{
			//generate a random seedNode based off of locIndex
			double rand = random();		//from the java.lang.math library 0 to 1
			//now find an edge along the contour to start from
			int contInd = (int) floor((rand*contMatrix.size()));
			//now find a random length along that random edge to generate a useful point
			rand = random();
			double[] vert1 = seedVerts.get(new Integer(contMatrix.get(contInd)[0]));//verts of the edge
			double[] vert2 = seedVerts.get(new Integer(contMatrix.get(contInd)[1]));
			double dist12 = RHMath.dist(vert1, vert2);	//edge length
			double[] vec12 = RHMath.unitVec(vert2,vert1);	//unit vector from vert1 to vert2
			//now generate the vert that will connect with the centerOfMass vert
			double[] randVert = RHMath.vecAdd(vert1, RHMath.mult(vec12, (dist12*rand)));
			//now find the line from randVert to the centroid
			double distRC = RHMath.dist(centerOfMass, randVert);
			double[] vecRC = RHMath.unitVec(centerOfMass, randVert);	//unit vector from randVert to centerofmass
			//finally, divide distRC by 10 (your maximum locIndex)
			distRC = distRC/10.0;
			//now find the new point which we will return
			distRC = distRC*locIndex;
			result = RHMath.vecAdd(randVert, RHMath.mult(vecRC,distRC));
			//make sure its within the flattened surface
			if (inTriangle(result) != -1)	{
				flag = true;
			}
		}
		return result;
	}
	
	//seedNode generates a seed within the flattened surface, these needs to be mapped to the 3D
	public double[] map3D(double[] pnt)	{
		//what triangle is it in?
		int triInd = inTriangle(pnt);
		//find the pnt in triangle coordinates
		double[] vert1 = seedVerts.get(new Integer((int) bndMatrix[0][triInd]));
		double[] vert2 = seedVerts.get(new Integer((int) bndMatrix[1][triInd]));
		double[] vert3 = seedVerts.get(new Integer((int) bndMatrix[2][triInd]));
		double dist12 = RHMath.dist(vert2,vert1);
		double dist13 = RHMath.dist(vert3,vert1);
		double[] vec12 = RHMath.unitVec(vert2, vert1);	//first coordinate axis
		double[] vec13 = RHMath.unitVec(vert3, vert1);	//second coordinate axis
		vec13 = RHMath.vecSub(vec13, RHMath.mult(vec12, RHMath.dot(vec13,vec12)));	//make orthogonal
		vec13 = RHMath.unitVec(vec13);		//make a unit vector again
		dist13 = RHMath.dot(vec13, RHMath.vecSub(vert3,vert1));	//redo max distance on now orthogonal coordinate system
		double[] vec1P = RHMath.vecSub(pnt, vert1);
		double coord1 = RHMath.dot(vec1P,vec12)/dist12;
		double coord2 = RHMath.dot(vec1P,vec13)/dist13;
		//now put that in the real triangle on the 3D surface
		//reset vert1,2,and 3 because arrays are actually references in java
		vert1 = new double[3];
		vert2 = new double[3];
		vert3 = new double[3];
		vert1[0] = vMatrix[0][(int) bndMatrix[0][triInd]];
		vert1[1] = vMatrix[1][(int) bndMatrix[0][triInd]];
		vert1[2] = vMatrix[2][(int) bndMatrix[0][triInd]];
		vert2[0] = vMatrix[0][(int) bndMatrix[1][triInd]];
		vert2[1] = vMatrix[1][(int) bndMatrix[1][triInd]];
		vert2[2] = vMatrix[2][(int) bndMatrix[1][triInd]];
		vert3[0] = vMatrix[0][(int) bndMatrix[2][triInd]];
		vert3[1] = vMatrix[1][(int) bndMatrix[2][triInd]];
		vert3[2] = vMatrix[2][(int) bndMatrix[2][triInd]];
		dist12 = RHMath.dist(vert2,vert1);
		dist13 = RHMath.dist(vert3,vert1);
		vec12 = RHMath.unitVec(vert2, vert1);	//first coordinate axis
		vec13 = RHMath.unitVec(vert3, vert1);	//second coordinate axis
		vec13 = RHMath.vecSub(vec13, RHMath.mult(vec12, RHMath.dot(vec13,vec12)));	//make orthogonal
		vec13 = RHMath.unitVec(vec13);		//make a unit vector again
		dist13 = RHMath.dot(vec13, RHMath.vecSub(vert3,vert1));	//redo max distance on now orthogonal coordinate system
		//create new point in new coordinate system
		double[] result = vert1;		//initialize to first vertex
		double[] nvec12 = RHMath.mult(vec12, (coord1*dist12));	//new coordinate
		double[] nvec13 = RHMath.mult(vec13, (coord2*dist13));	//new coordinate
		result = RHMath.vecAdd(result, nvec12);		//map to new coordinates
		result = RHMath.vecAdd(result, nvec13);
		
		return result;
	}

	//originally, this function computes the center of mass for the flattened seed surface
	//to provide the "center" point for the crista, however now I calculate the intersection
	//of the crista surface with the first segment of the user defined contour because this 
	//will give more flexibility to the user
	public void findCenterOfMass()	throws Exception {
		double temp;
		double[] triIntersection = {0,0,0};
		double[] triIntersectionTemp;
		int triIntersectionInd = 0;
		boolean firstIter = true;
		boolean foundInter = false;
test3 = bndMatrix[0].length;
test4 = -1;
		//cycle through all of the triangles in the bndMatrix until we find an intersection
		for (int i = 0; i < (bndMatrix[0].length); i++)	{
if (i>test4)
	test4 = i;
			//need to find the smallest distance of intersection
			//because there may be multiple intersections for overlapping triangles
			triIntersectionTemp = rayTriIntersection(i, RHMath.v(usrVerts, 1), 
								RHMath.v(usrVerts, 0), bndMatrix, bndTriNormals);
test1 = RHMath.v(usrVerts, 0);
test2 = RHMath.v(usrVerts,1);
			//was there an intersection?
			if (triIntersectionTemp != null && triIntersectionTemp[0] != -1)	{
				foundInter = true;
				//has triIntersection been assigned yet?
				if (firstIter)	{
					triIntersection = triIntersectionTemp.clone();
					triIntersectionInd = i;			//remember which triangle
					firstIter = false;
				}
				else {	//check to see if the new intersection is closer
					temp = RHMath.dist2(triIntersectionTemp, RHMath.v(usrVerts,1));
					if (temp < RHMath.dist2(triIntersection, RHMath.v(usrVerts,1)))	{
						triIntersection = triIntersectionTemp.clone();
						triIntersectionInd = i;		//remember which triangle
					}
				}
			}
		}
		//check to see if we found an intersection
		if (!foundInter)	{
			throw new Exception("Error.  Could not find an intersection of the seed surface with the first segment of the nerve contour.");
		}				
		//a valid intersection has been found, need to map this into the 2D flattened surface
		//find the pnt in triangle coordinates
		double[] vert1 = RHMath.v(vMatrix, bndMatrix[0][triIntersectionInd]);
		double[] vert2 = RHMath.v(vMatrix, bndMatrix[1][triIntersectionInd]);
		double[] vert3 = RHMath.v(vMatrix, bndMatrix[2][triIntersectionInd]);
		double dist12 = RHMath.dist(vert2,vert1);
		double dist13 = RHMath.dist(vert3,vert1);
		double[] vec12 = RHMath.unitVec(vert2, vert1);	//first coordinate axis
		double[] vec13 = RHMath.unitVec(vert3, vert1);	//second coordinate axis
		vec13 = RHMath.vecSub(vec13, RHMath.mult(vec12, RHMath.dot(vec13,vec12)));	//make orthogonal
		vec13 = RHMath.unitVec(vec13);		//make a unit vector again
		dist13 = RHMath.dot(vec13, RHMath.vecSub(vert3,vert1));	//redo max distance on now orthogonal coordinate system
		double[] vec1P = RHMath.vecSub(triIntersection, vert1);
		double coord1 = RHMath.dot(vec1P,vec12)/dist12;
		double coord2 = RHMath.dot(vec1P,vec13)/dist13;
		//now put that in the real triangle on the 3D surface
		//reset vert1,2,and 3 because arrays are actually references in java
		vert1 = new double[3];
		vert2 = new double[3];
		vert3 = new double[3];
		vert1 = seedVerts.get(new Integer((int) bndMatrix[0][triIntersectionInd]));
		vert2 = seedVerts.get(new Integer((int) bndMatrix[1][triIntersectionInd]));
		vert3 = seedVerts.get(new Integer((int) bndMatrix[2][triIntersectionInd]));
		dist12 = RHMath.dist(vert2,vert1);
		dist13 = RHMath.dist(vert3,vert1);
		vec12 = RHMath.unitVec(vert2, vert1);	//first coordinate axis
		vec13 = RHMath.unitVec(vert3, vert1);	//second coordinate axis
		vec13 = RHMath.vecSub(vec13, RHMath.mult(vec12, RHMath.dot(vec13,vec12)));	//make orthogonal
		vec13 = RHMath.unitVec(vec13);		//make a unit vector again
		dist13 = RHMath.dot(vec13, RHMath.vecSub(vert3,vert1));	//redo max distance on now orthogonal coordinate system
		//create new point in new coordinate system
		double[] result = vert1;		//initialize to first vertex
		double[] nvec12 = RHMath.mult(vec12, (coord1*dist12));	//new coordinate
		double[] nvec13 = RHMath.mult(vec13, (coord2*dist13));	//new coordinate
		result = RHMath.vecAdd(result, nvec12);		//map to new coordinates
		result = RHMath.vecAdd(result, nvec13);
		result[2] = 0;			//make sure we are in the xy plane just in case of a small error
		centerOfMass = result;		//done!
		
//old code that originally calculated the center of mass
/*		//cycle through all of the triangles, and sum up their respective center of masses
		double[] vert1,vert2,vert3;
		double[] temp;
		double[] sum = {0,0,0};		//the running sum
		for (int i = 0; i<bndMatrix[0].length; i++)	{
			//get the triangle's verts
			vert1 = seedVerts.get(new Integer((int) bndMatrix[0][i]));
			vert2 = seedVerts.get(new Integer((int) bndMatrix[1][i]));
			vert3 = seedVerts.get(new Integer((int) bndMatrix[2][i]));
			temp = RHMath.vecAdd(vert1,vert2);
			temp = RHMath.vecAdd(temp,vert3);
			temp = RHMath.mult(temp, 1.0/3.0);

			sum = RHMath.vecAdd(sum, temp);
		}
		//now divide by the number of triangles
		sum = RHMath.mult(sum, (1.0/bndMatrix[0].length));
		centerOfMass = sum;	*/
	}
	
	//finds the outer most edge of the seed surface
	//flattenSeedSurface should be called first
	public void findContour()	{
		//intialize contMatrix
		contMatrix = new ArrayList<int[]>(0);
		int vertA,vertB,vertC;		//vertices of the triangles
		int[] neig;		//neighboring triangle indices
		//cycle through each triangle, an edge should only have one neighboring triangle if its a proper surface
		for (int i = 0; i<bndMatrix[0].length; i++)	{
			vertA = (int) bndMatrix[0][i];
			vertB = (int) bndMatrix[1][i];
			vertC = (int) bndMatrix[2][i];
			neig = edgeNeighbors(vertA, vertB);
			if (neig[0] == -1 || neig[1] == -1)	{	//edge found
				int[] temp = {vertA, vertB};
				contMatrix.add(temp);
			}
			neig = edgeNeighbors(vertA, vertC);
			if (neig[0] == -1 || neig[1] == -1)	{	//edge found
				int[] temp = {vertA, vertC};
				contMatrix.add(temp);
			}
			neig = edgeNeighbors(vertB, vertC);
			if (neig[0] == -1 || neig[1] == -1)	{	//edge found
				int[] temp = {vertB, vertC};
				contMatrix.add(temp);
			}
		}
	}
	//for testing, remember to add 1 in matlab!
	public int[][] contourValues()	{
		int[][] ind = new int[2][contMatrix.size()];
		for (int i = 0; i<contMatrix.size();i++)	{
			ind[0][i] = contMatrix.get(i)[0];
			ind[1][i] = contMatrix.get(i)[1];
		}
		return ind;
	}
	
	//returns the index of the bndTriangle which pnt resides within, or -1 if its not in any triangle
	//must have called flattenSeedSurface first (its only for the 2D case)
	public int inTriangle(double[] pnt)	{
		int result = -1;
		//cycle through each triangle
		double[] vertA;
		double[] vertB;
		double[] vertC;
		double[] vertAB;
		double[] vertBC;
		double[] vertCA;
		double[] vertAP;
		double[] vertBP;
		double[] vertCP;
		double[] ABcrossAP;
		double[] BCcrossBP;
		double product1;
		double product2;
		for (int i = 0; i< bndMatrix[0].length; i++)	{
			//common in triangle test, google it and you'll find it too
			vertA = seedVerts.get(new Integer((int) bndMatrix[0][i]));
			vertB = seedVerts.get(new Integer((int) bndMatrix[1][i]));
			vertC = seedVerts.get(new Integer((int) bndMatrix[2][i]));
			vertAB = RHMath.vecSub(vertB,vertA);
			vertBC = RHMath.vecSub(vertC,vertB);
			vertCA = RHMath.vecSub(vertA,vertC);
			vertAP = RHMath.vecSub(pnt,vertA);
			vertBP = RHMath.vecSub(pnt,vertB);
			vertCP = RHMath.vecSub(pnt,vertC);
			ABcrossAP = RHMath.cross(vertAB, vertAP);
			BCcrossBP = RHMath.cross(vertBC, vertBP);
			product1 = RHMath.dot(ABcrossAP, RHMath.cross(vertBC,vertBP));
			product2 = RHMath.dot(BCcrossBP, RHMath.cross(vertCA,vertCP));
			if (product1 >= 0 && product2 >= 0)	{		//will be in this triangle
				result = i;
			}
		}
		return result;
	}
	
	//this function takes the seed surface and creates a flattened version within
	//the new seedVerts matrix
	public void flattenSeedSurface() throws Exception	{
		//initialize seedVerts
		seedVerts = new HashMap<Integer, double[]>();
		//begin the flattening procedure by cycling through all triangles
		//flatten it against the x-y plane (normal = [0,0,1])
		//process the first triangle, of which the new surface will grow from
		double[] vert1 = RHMath.v(vMatrix, (int) bndMatrix[0][0]);
		double[] vert2 = RHMath.v(vMatrix, (int) bndMatrix[1][0]);
		double[] vert3 = RHMath.v(vMatrix, (int) bndMatrix[2][0]);
		double[] vertN1 = {0,0,0};		//new flattend vert1
		//start at the origin for the seed vertex
		seedVerts.put(new Integer((int) bndMatrix[0][0]), vertN1.clone());
		//now for vert1 to vert2 edge (will be oriented along the x axis
		double d21 = RHMath.dist(vert1,vert2);		//distance between vert 2 and vert 1
		double[] vertN2 = {1,0,0};		//new flattened vert2
		vertN2 = RHMath.mult(vertN2,d21);	
		seedVerts.put(new Integer((int) bndMatrix[1][0]), vertN2);
	//now for the last vertex (this is the complicated one)
		double[] vertN3 = vertN1;		//initialize to the new vert1
		//find the projection of line vert3-vert1 onto unit vector vert2,vert1
		double projDist3 = RHMath.dot(RHMath.unitVec(vert2,vert1),RHMath.vecSub(vert3,vert1));
		//find perpindicular distance of vert3 from line vert2-vert1
		double perpDist3 = sqrt(RHMath.dist2(vert1,vert3)-pow(projDist3,2));
		//find the unit perpindicular vector
		double[] vecPerp = {0,1,0};
		//find new vert3
		vertN3 = RHMath.vecAdd(vertN3, RHMath.mult(vecPerp,perpDist3));
		vertN3 = RHMath.vecAdd(vertN3, RHMath.mult(RHMath.unitVec(vertN2,vertN1), projDist3));
		seedVerts.put(new Integer((int) bndMatrix[2][0]), vertN3);
	//now initialize an array which will hold all of the triangles we have already processed
		int[] procTri = new int[bndMatrix[0].length];
		Arrays.fill(procTri, -1);		//fill with -1, to indicate if we have gotten to it
		procTri[0] = 1;			//we processed the first triangle
		int numProcTri = 1;		//amount of triangles we have already processed
	//now cycle through all the triangles until we have gotten to them all
		int maxNumIter = 0;			//once it hits 1000000, assume an improper surface
		while (numProcTri < bndMatrix[0].length)	{
			for (int i = 0; i < bndMatrix[0].length; i++)	{
				//take care of error condition
				maxNumIter = maxNumIter + 1;
				if (maxNumIter > 1000000){
					throw new Exception("Error.  Could not flatten surface.  Surface must be fully contiguous, and each triangle must share a full edge with another triangle.  Warning: Its possible that Amira may have created an improper surface.");
				}
				boolean pFlag = false;
				int vert1Ind = 0;
				int vert2Ind = 0;
				int vert3Ind = 0;
				//check to see if all its vertices have been calculated (all boundary triangles done)
				if ((procTri[i] == -1) && seedVerts.containsKey(new Integer((int) bndMatrix[0][i])) && seedVerts.containsKey(new Integer((int) bndMatrix[1][i])) && seedVerts.containsKey(new Integer((int) bndMatrix[2][i])))	{
					procTri[i] = 1;
					numProcTri = numProcTri + 1;
					pFlag = false;		//don't need to calculate this one
				}
				//now process the triangle, to be a candidate for processing two of its verts must be calculated already
				//move on if we have already gotten to this triangle
				if ((procTri[i] == -1) && seedVerts.containsKey(new Integer((int) bndMatrix[0][i])) && seedVerts.containsKey(new Integer((int) bndMatrix[1][i])))	{
					vert1 = RHMath.v(vMatrix, (int) bndMatrix[0][i]);
					vert2 = RHMath.v(vMatrix, (int) bndMatrix[1][i]);
					vert3 = RHMath.v(vMatrix, (int) bndMatrix[2][i]);
					vert1Ind = (int) bndMatrix[0][i];
					vert2Ind = (int) bndMatrix[1][i];
					vert3Ind = 2;
					pFlag = true;
					//now, ensure that the two vertices are shared by the SAME triangle (Amira can produce otherwise!)
					int[] nTri = edgeNeighbors((int) bndMatrix[0][i], (int) bndMatrix[1][i]);
					//also ensure that the neighboring triangle has been processed already
					if (nTri[0] == -1 || nTri[1] == -1 || (procTri[nTri[0]] == -1 && procTri[nTri[1]] == -1))	{
						pFlag = false;				//no good, it doesn't share an edge
					}
					else	{		//we can def. process this tri
						procTri[i] = 1;
						numProcTri = numProcTri + 1;
					}
	test7 = 1;
				}
				if ((procTri[i] == -1) && seedVerts.containsKey(new Integer((int) bndMatrix[0][i])) && seedVerts.containsKey(new Integer((int) bndMatrix[2][i])))	{
					vert1 = RHMath.v(vMatrix, (int) bndMatrix[0][i]);
					vert2 = RHMath.v(vMatrix, (int) bndMatrix[2][i]);
					vert3 = RHMath.v(vMatrix, (int) bndMatrix[1][i]);
					vert1Ind = (int) bndMatrix[0][i];
					vert2Ind = (int) bndMatrix[2][i];
					vert3Ind = 1;
					pFlag = true;
					//now, ensure that the two vertices are shared by the SAME triangle (Amira can produce otherwise!)
					int[] nTri = edgeNeighbors((int) bndMatrix[0][i], (int) bndMatrix[2][i]);
					//also ensure that the neighboring triangle has been processed already
					if (nTri[0] == -1 || nTri[1] == -1 || (procTri[nTri[0]] == -1 && procTri[nTri[1]] == -1))	{
						pFlag = false;				//no good, it doesn't share an edge
					}
					else	{		//we can def. process this tri
						procTri[i] = 1;
						numProcTri = numProcTri + 1;
					}
	test7 = 2;
				}
				if ((procTri[i] == -1) && seedVerts.containsKey(new Integer((int) bndMatrix[1][i])) && seedVerts.containsKey(new Integer((int) bndMatrix[2][i])))	{
					vert1 = RHMath.v(vMatrix, (int) bndMatrix[1][i]);
					vert2 = RHMath.v(vMatrix, (int) bndMatrix[2][i]);
					vert3 = RHMath.v(vMatrix, (int) bndMatrix[0][i]);
					vert1Ind = (int) bndMatrix[1][i];
					vert2Ind = (int) bndMatrix[2][i];
					vert3Ind = 0;
					pFlag = true;
					//now, ensure that the two vertices are shared by the SAME triangle (Amira can produce otherwise!)
					int[] nTri = edgeNeighbors((int) bndMatrix[1][i], (int) bndMatrix[2][i]);
					//also ensure that the neighboring triangle has been processed already
					if (nTri[0] == -1 || nTri[1] == -1 || (procTri[nTri[0]] == -1 && procTri[nTri[1]] == -1))	{
						pFlag = false;				//no good, it doesn't share an edge
					}
					else	{		//we can def. process this tri
						procTri[i] = 1;
						numProcTri = numProcTri + 1;
					}
	test7 = 3;
				}
				if (pFlag)	{		//processing
					vertN3 = findVertN3(vert1, vert2, vert3, seedVerts.get(new Integer(vert1Ind)), 
										seedVerts.get(new Integer(vert2Ind)), vert1Ind, vert2Ind, i);
					seedVerts.put(new Integer((int) bndMatrix[vert3Ind][i]), vertN3);
				}
			}
		}
		
	}
	//for testing
	public double[][] seedValues()	{
		double[][] temp = new double[4][vMatrix[0].length];
		Object[] keys = seedVerts.keySet().toArray();
		Arrays.sort(keys);
		for (int i = 0; i<seedVerts.size(); i++)	{
			double[] temp2 = seedVerts.get(keys[i]);
			int indexer = Integer.valueOf(keys[i].toString()).intValue();
			temp[0][indexer] = temp2[0];
			temp[1][indexer] = temp2[1];
			temp[2][indexer] = temp2[2];
			temp[3][indexer] = ((Integer) keys[i]).intValue();
		}
		return temp;
	}
	
	//this routine finds the last vertex given the first two and their respective new values
	public double[] findVertN3(double[] vert1, double[] vert2, double[] vert3, double[] vertN1, 
							double[] vertN2, int vert1Ind, int vert2Ind, int thisTriInd)	{
		double[] vertN3 = vertN1;		//initialize to the new vert1
		//find the projection of line vert3-vert1 onto unit vector vert2-vert1
		double projDist3 = RHMath.dot(RHMath.unitVec(vert2,vert1),RHMath.vecSub(vert3,vert1));
		//find perpindicular distance of vert3 from line vert2-vert1
		double perpDist3 = sqrt(RHMath.dist2(vert1,vert3)-pow(projDist3,2));
		//find the unit perpindicular vector
		//to figure out whether or not we need to invert vecPerp, we need to see what side the pre-existing neighbor is on
		int[] neigh = edgeNeighbors(vert1Ind, vert2Ind);	//find the triangle neighbor
		int vert4Ind;		//will hold the third vertex of the neighboring tri
	test4 = thisTriInd;
	test5 = vert1Ind;
	test3 = vert2Ind;
	test0 = neigh;
		if (neigh[0] == thisTriInd)	{
			vert4Ind = findUniqueVert(vert1Ind, vert2Ind, neigh[1]);
		}
		else	{
			vert4Ind = findUniqueVert(vert1Ind, vert2Ind, neigh[0]);
		}
		double[] vertN4 = seedVerts.get(new Integer(vert4Ind)); 
	test6 = vert4Ind;
		double[] diffN4N1 = RHMath.vecSub(vertN4, vertN1);	//difference vector into neighbo
		double[] diffN2N1 = RHMath.vecSub(vertN2,vertN1);	//find new diff vector betwen vertN2 and vertN1
		double[] vecPerp = {diffN2N1[1],-diffN2N1[0],0};
		vecPerp = RHMath.unitVec(vecPerp);		//we either need the positive of this, or its inverse
		if (RHMath.dot(vecPerp, diffN4N1) > 0) {	//need to invert
			vecPerp = RHMath.mult(vecPerp, -1);
		}
		//find new vert3
		vertN3 = RHMath.vecAdd(vertN3, RHMath.mult(vecPerp,perpDist3));
		vertN3 = RHMath.vecAdd(vertN3, RHMath.mult(RHMath.unitVec(vertN2,vertN1), projDist3));		
		return vertN3;
	}
	
	//this routine returns the indices of the two triangles that border a given edge
	public int[] edgeNeighbors(int vert1Ind, int vert2Ind)	{
		int[] result = new int[2];
		result[0] = -1; result[1] = -1;		//if on the contour edge, then one will be -1
		//cycle through all of the triangles
		for (int i = 0; i < bndMatrix[0].length; i++)	{
			if (bndMatrix[0][i] == vert1Ind || bndMatrix[1][i] == vert1Ind || bndMatrix[2][i] == vert1Ind)	{
				if (bndMatrix[0][i] == vert2Ind || bndMatrix[1][i] == vert2Ind || bndMatrix[2][i] == vert2Ind)	{
					//found one, add it to the list
					result[1] = result[0];
					result[0] = i;
				}
			}
		}
		
		return result;
	}
	
	//this routine returns the unique vertex, assuming vert1Ind and vert2Ind exist in triangle thisTriInd
	public int findUniqueVert(int vert1Ind, int vert2Ind, int thisTriInd)	{
		int result;
		int vert1 = (int) bndMatrix[0][thisTriInd];
		int vert2 = (int) bndMatrix[1][thisTriInd];
		int vert3 = (int) bndMatrix[2][thisTriInd];
		if ((vert1Ind == vert1 && vert2Ind == vert2) || (vert1Ind == vert2 && vert2Ind == vert1))	{
			result = (int) bndMatrix[2][thisTriInd];	//use minus 1 because indexing beings at 1
		}
		else if ((vert1Ind == vert1 && vert2Ind == vert3) || (vert1Ind == vert3 && vert2Ind == vert1))	{
			result = (int) bndMatrix[1][thisTriInd];			
		}
		else	{
			result = (int) bndMatrix[0][thisTriInd];
		}
		return result;
	}

	//same as above, but for a tetrahedron
	public int findUniqueVert(int vert1Ind, int vert2Ind, int vert3Ind, int thisTetInd)	{
		int result = 0;		//if improper input, 0 will probably be the output
		int[] verts = new int[4];
		verts[0] = (int) tMatrix[0][thisTetInd];
		verts[1] = (int) tMatrix[1][thisTetInd];
		verts[2] = (int) tMatrix[2][thisTetInd];
		verts[3] = (int) tMatrix[3][thisTetInd];
		for (int i = 0; i<4; i++)	{
			if ((verts[i] != vert1Ind) && (verts[i] != vert2Ind) && (verts[i] != vert3Ind))
				result = i;
		}

		return (int) tMatrix[result][thisTetInd];
	}

	//this function subtracts one from tMatrix and bndMatrix because java begins indexing at 0, not 1
	public void processMatrices()	{
		for (int i = 0; i< tMatrix[0].length; i++)	{
			tMatrix[0][i] = tMatrix[0][i] - 1;
			tMatrix[1][i] = tMatrix[1][i] - 1;
			tMatrix[2][i] = tMatrix[2][i] - 1;
			tMatrix[3][i] = tMatrix[3][i] - 1;
		}
		for (int i = 0; i<bndMatrix[0].length; i++)	{
			bndMatrix[0][i] = bndMatrix[0][i] - 1;
			bndMatrix[1][i] = bndMatrix[1][i] - 1;
			bndMatrix[2][i] = bndMatrix[2][i] - 1;
		}
		for (int i = 0; i<outerTriMatrix[0].length; i++)	{
			outerTriMatrix[0][i] = outerTriMatrix[0][i]-1;
			outerTriMatrix[1][i] = outerTriMatrix[1][i]-1;
			outerTriMatrix[2][i] = outerTriMatrix[2][i]-1;
		}
	}

	//this method tests if pnt is somewhere within
	//the subdomain defined by the tetrahedron matrix tets and the vertex matrix nodes
	//maxEdge = the maximum edge length
	//will return the index of the tet the pnt resides in (-1 if not in any tet)
	//the second term in the returned array will indicate if its on a tet surface or not
	//this will be 0 if its on the surface, and 1 if its fully within the tet
	public static int[] isInsideSubdomain(int[][] tets, double [][] nodes, double[] pnt,
											double maxEdge)	{
		int[] No_result = {-1,-1};
		int[] temp = new int[2];
		double xdist2;
		double ydist2;
		double zdist2;
		double[] vert1, vert2, vert3, vert4;		//a given tet's vertices
		double[][] tetVerts = new double[3][4];		
		maxEdge = pow(maxEdge,2);		//only concerned about the square of the edge length
		//cycle through all tets to see if its within the subdomain
		for (int i = 0; i<tets[0].length; i++)	{
			//get the current tet's information
			vert1 = RHMath.v(nodes, (int) tets[0][i]);
			//prescreen out a slice
			xdist2 = pow((pnt[0] - vert1[0]),2);
			if (xdist2 < (maxEdge*1.5))	{	//close
				ydist2 = pow((pnt[1] - vert1[1]),2);
				if (ydist2 < (maxEdge*1.5))	{	//reduced space to sample down to a line
					zdist2 = pow((pnt[2] - vert1[2]),2);
					if (zdist2 < (maxEdge*1.5))	{
						//we are close, so finish attaining the information for the tet
						vert2 = RHMath.v(nodes, (int) tets[1][i]);
						vert3 = RHMath.v(nodes, (int) tets[2][i]);
						vert4 = RHMath.v(nodes, (int) tets[3][i]);
						tetVerts[0][0] = vert1[0]; tetVerts[1][0] = vert1[1]; tetVerts[2][0] = vert1[2];
						tetVerts[0][1] = vert2[0]; tetVerts[1][1] = vert2[1]; tetVerts[2][1] = vert2[2];
						tetVerts[0][2] = vert3[0]; tetVerts[1][2] = vert3[1]; tetVerts[2][2] = vert3[2];
						tetVerts[0][3] = vert4[0]; tetVerts[1][3] = vert4[1]; tetVerts[2][3] = vert4[2];
						//now see if its actually in the tet
						temp[1] = RHMath.inTet(tetVerts, pnt);
						if (temp[1] != -1)	{
							temp[0] = i;
							return temp;
						}
					}
				}
			}
		}
		return No_result;
	}
	public int[] testInSub(double[] pnt)	{	//for testing
		int[] g = FiberTrajGen.isInsideSubdomain(tMatrix, vMatrix, pnt, maxEdgeLength);
		return g;
	}
	
	//this function returns the maximum edge length of all the tets in tMatrix which
	//are defined upon vMatrix, This is a pre-processing routine (its slow)
	public static double maxEdgeLength(int[][] tMatrix, double[][] vMatrix)	{
		double result = 0;
		//cycle through all of the tets
		double[] vert1, vert2, vert3, vert4;
		double dist12, dist13, dist14, dist23, dist24, dist34;
		for (int i = 0; i< tMatrix[0].length; i++)	{
			//find the vertices of the matrix
			vert1 = RHMath.v(vMatrix, (int) tMatrix[0][i]);
			vert2 = RHMath.v(vMatrix, (int) tMatrix[1][i]);
			vert3 = RHMath.v(vMatrix, (int) tMatrix[2][i]);
			vert4 = RHMath.v(vMatrix, (int) tMatrix[3][i]);
			//find edge distances
			dist12 = RHMath.dist(vert1,vert2);
			dist13 = RHMath.dist(vert1,vert3);
			dist14 = RHMath.dist(vert1,vert4);
			dist23 = RHMath.dist(vert2,vert3);
			dist24 = RHMath.dist(vert2,vert4);
			dist34 = RHMath.dist(vert3,vert4);
			if (dist12 > result)	
				result = dist12;
			if (dist13 > result)	
				result = dist13;
			if (dist14 > result)	
				result = dist14;
			if (dist23 > result)	
				result = dist23;
			if (dist24 > result)	
				result = dist24;
			if (dist34 > result)	
				result = dist34;
		}
		return result;
	}

//legacy:
	//this routine returns the minimum distance from pnt to a vertex to the bndStopMatrix
	//returns the dist in first element, node ID number in second array element
/*	public double[] distToBnd(double[] pnt){
		double dist;
		double tempDist;
		int nodeID;
		//initiallize to first node
		dist = RHMath.dist2(pnt,RHMath.v(vMatrix, (int) bndStopMatrix[0][0]));
		nodeID = (int) bndStopMatrix[0][0];
		//cycle through all relavent triangles
		for (int i = 0; i<bndStopMatrix[0].length; i++)	{
			tempDist = RHMath.dist2(pnt,RHMath.v(vMatrix, (int) bndStopMatrix[0][i]));
			if (tempDist < dist)	{
				dist = tempDist;
				nodeID = (int) bndStopMatrix[0][i];
			}
			tempDist = RHMath.dist2(pnt,RHMath.v(vMatrix, (int) bndStopMatrix[1][i]));
			if (tempDist < dist)	{
				dist = tempDist;
				nodeID = (int) bndStopMatrix[1][i];
			}
			tempDist = RHMath.dist2(pnt,RHMath.v(vMatrix, (int) bndStopMatrix[2][i]));
			if (tempDist < dist)	{
				dist = tempDist;
				nodeID = (int) bndStopMatrix[2][i];
			}
		}
		dist = sqrt(dist);
		double[] result = {dist, nodeID};
		return result;
	}
	*/
	
	//NOT TESTED, OPTED INSTEAD TO USE BOUNDARY CONDITIONS TO DEFINE OUTER TRIANGLES
	//this function preprocesses the tetrahedral space, finding and populating the outerTriangle
	//boundary matrix, It assumes that the FEM has already been downsampled to just the Nerve tissues
	public void findOuterTri()	{
		int[] neig;
		int[] temp = new int[3];
		ArrayList<int[]> triangles = new ArrayList<int[]>(0);
		int vert1, vert2, vert3, vert4; //vert indices of the tet
		//cycle through all of the tets
		for (int i = 0; i< tMatrix[0].length; i++)	{
			//find the vertices of the matrix
			vert1 = (int) tMatrix[0][i];
			vert2 = (int) tMatrix[1][i];
			vert3 = (int) tMatrix[2][i];
			vert4 = (int) tMatrix[3][i];
			//now test the four triangles of this tet
			neig = bndNeighbors(vert1,vert2,vert3);
			if (neig[0] == -1 || neig[1] == -1)	{
				temp[0] = vert1; temp[1] = vert2; temp[2] = vert3;
				triangles.add(temp.clone());
			}
			neig = bndNeighbors(vert1,vert2,vert4);
			if (neig[0] == -1 || neig[1] == -1)	{
				temp[0] = vert1; temp[1] = vert2; temp[2] = vert4;
				triangles.add(temp.clone());
			}
			neig = bndNeighbors(vert2,vert3,vert4);
			if (neig[0] == -1 || neig[1] == -1)	{
				temp[0] = vert2; temp[1] = vert3; temp[2] = vert4;
				triangles.add(temp.clone());
			}
			neig = bndNeighbors(vert1,vert3,vert4);
			if (neig[0] == -1 || neig[1] == -1)	{
				temp[0] = vert1; temp[1] = vert3; temp[2] = vert4;
				triangles.add(temp.clone());
			}
		}
		//now populate the matrix
		outerTriMatrix = new int[3][triangles.size()];
		for (int i = 0; i<triangles.size(); i++)	{
			outerTriMatrix[0][i] = triangles.get(i)[0];
			outerTriMatrix[1][i] = triangles.get(i)[1];
			outerTriMatrix[2][i] = triangles.get(i)[2];
		}
	}
	
	//this function preprocess all of the normals for the triangles in triMatrix
	//returns an array of normal vectors that correlates by index to triMatrix
	public double[][] computeTriNormals(int[][] triMatrix)	{
		//cycle through each triangle and store the unit vector of the cross product
		double[] temp;
		double[][] result = new double[3][triMatrix[0].length];  //initialize
		double[] vert1,vert2,vert3;
		for (int i = 0; i<result[0].length; i++)	{
			vert1 = RHMath.v(vMatrix,triMatrix[0][i]);
			vert2 = RHMath.v(vMatrix,triMatrix[1][i]);
			vert3 = RHMath.v(vMatrix,triMatrix[2][i]);
			//find the normal vector
			temp = RHMath.cross(RHMath.vecSub(vert2,vert1),RHMath.vecSub(vert3, vert1));
			temp = RHMath.unitVec(temp);		//normallize
			//store in array
			result[0][i] = temp[0];
			result[1][i] = temp[1];
			result[2][i] = temp[2];
		}
		return result;
	}

	//this routine returns the 2 indices of the tets that share the given triangle
	//defined on the vertex indices vert1Ind,vert2Ind,vert3Ind
	//returns -1 if the neighbor doesn't exist
	//must preprocess maxEdgeLength first
	public int[] bndNeighbors(int vert1Ind, int vert2Ind, int vert3Ind)	{
		int[] result = new int[2];
		double xdist2,ydist2,zdist2;
		double maxEdge = maxEdgeLength;
		maxEdge = pow(maxEdge,2);		//only concerned about the square of the edge length
		result[0] = -1; result[1] = -1;		//if on the outer boundary, then one will be -1
		//cycle through all of the tets
		for (int i = 0; i < tMatrix[0].length; i++)	{
			//prescreen out to a small volume
			xdist2 = pow((vMatrix[0][vert1Ind] - vMatrix[0][(int) tMatrix[0][i]]),2);
			if (xdist2 < (maxEdge*1.5))	{	//close
				ydist2 = pow((vMatrix[1][vert1Ind] - vMatrix[1][(int) tMatrix[0][i]]),2);
				if (ydist2 < (maxEdge*1.5))	{	//reduced space to sample down to a line
					zdist2 = pow((vMatrix[2][vert1Ind] - vMatrix[2][(int) tMatrix[0][i]]),2);
					if (zdist2 < (maxEdge*1.5))	{
						//may have a neighbor, now make sure
						if (tMatrix[0][i] == vert1Ind || tMatrix[1][i] == vert1Ind || tMatrix[2][i] == vert1Ind || tMatrix[3][i] == vert1Ind)	{
							if (tMatrix[0][i] == vert2Ind || tMatrix[1][i] == vert2Ind || tMatrix[2][i] == vert2Ind || tMatrix[3][i] == vert2Ind)	{
								if (tMatrix[0][i] == vert3Ind || tMatrix[1][i] == vert3Ind || tMatrix[2][i] == vert3Ind || tMatrix[3][i] == vert3Ind)	{
									//found one, add it to the list
									result[1] = result[0];
									result[0] = i;
								}
							}
						}
					}
				}
			}
		}
		return result;
	}
	
	//this method returns the point at which the ray (from the userContour to the current node) intersects a given triangle
	//returns null if it never intersects the triangle, or all -1's if its parallel the tri
	//the ray is defined as from pntCnt to pntNode, triMatrix is the triangles to check
	//and triNormals is a preprocessed matrix of the triangle normals of triMatrix
	public double[] rayTriIntersection(int triInd, double[] pntCnt, double[] pntNode,
										int[][] triMatrix, double[][] triNormals)	{
		double[] result = {-1,-1,-1};
		//first see if its parallel to the triangle
		//write out all of the dot products and subtacts out for speed (no use of RHMath)
		//denom = normal dot (pntNode-pntCnt)
		double denom = triNormals[0][triInd]*(pntNode[0]-pntCnt[0]) +
						triNormals[1][triInd]*(pntNode[1]-pntCnt[1]) +
						 triNormals[2][triInd]*(pntNode[2]-pntCnt[2]);
		//if this is 0, we have a parallel condition
		if (denom == 0)
			return result;
		//now calculate the numerator (this is the equation of finding the intersection of a ray with a plane (the tri surface extend to infinity)))
		//num = normal dot (point-in-plane - pntCnt)
		double num = triNormals[0][triInd]*(vMatrix[0][triMatrix[0][triInd]] - pntCnt[0]) +
					  triNormals[1][triInd]*(vMatrix[1][triMatrix[0][triInd]] - pntCnt[1]) +
					   triNormals[2][triInd]*(vMatrix[2][triMatrix[0][triInd]] - pntCnt[2]);
		//now find the parameteric value for the intersection
		double ri = num/denom;
		//if ri is negative, then this triangle is behind the ray, so it never intersect return null
		if (ri < 0)
			return null;
		//now that we have an intersection point (= pntCnt + ri*(pntNode-pntCnt)), see if its inside the triangle
		double[] pntI = new double[3];		//will hold the intersection point
		pntI[0] = pntCnt[0] + ri*(pntNode[0] - pntCnt[0]);
		pntI[1] = pntCnt[1] + ri*(pntNode[1] - pntCnt[1]);
		pntI[2] = pntCnt[2] + ri*(pntNode[2] - pntCnt[2]);
		//generate some vectors for code readibility
		double[] v = new double[3]; //= V2 - V0 of the triangle vertices
		v[0] = vMatrix[0][triMatrix[2][triInd]] - vMatrix[0][triMatrix[0][triInd]];
		v[1] = vMatrix[1][triMatrix[2][triInd]] - vMatrix[1][triMatrix[0][triInd]];
		v[2] = vMatrix[2][triMatrix[2][triInd]] - vMatrix[2][triMatrix[0][triInd]];
		double[] u = new double[3];	//= V1 - V0 of the triangle vertices
		u[0] = vMatrix[0][triMatrix[1][triInd]] - vMatrix[0][triMatrix[0][triInd]];
		u[1] = vMatrix[1][triMatrix[1][triInd]] - vMatrix[1][triMatrix[0][triInd]];
		u[2] = vMatrix[2][triMatrix[1][triInd]] - vMatrix[2][triMatrix[0][triInd]];
		double[] w = new double[3];	//= pntI - V0 (0th vertex in triangle)
		w[0] = pntI[0] - vMatrix[0][triMatrix[0][triInd]];
		w[1] = pntI[1] - vMatrix[1][triMatrix[0][triInd]];
		w[2] = pntI[2] - vMatrix[2][triMatrix[0][triInd]];
		//precalculate some dot products for speed
		double udotv = u[0]*v[0]+u[1]*v[1]+u[2]*v[2];
		double wdotv = w[0]*v[0]+w[1]*v[1]+w[2]*v[2];
		double wdotu = w[0]*u[0]+w[1]*u[1]+w[2]*u[2];
		double udotu = u[0]*u[0]+u[1]*u[1]+u[2]*u[2];
		double vdotv = v[0]*v[0]+v[1]*v[1]+v[2]*v[2];
		//now parameterize the plane, and find the values of the two parameters
		//this denominator is in both expressions = (u dot v)^2 - (u dot u)(v dot v)
		denom = pow((udotv),2);
		denom = denom - (udotu*vdotv);
		//now for the parameters
		double si, ti;
		si = ((udotv*wdotv)-(vdotv*wdotu))/denom;
		ti = ((udotv*wdotu)-(udotu*wdotv))/denom;
		//now see if its within the triangle
		if (si < 0 || ti < 0) 	//not in triangle
			return null;
		if ((si+ti) > 1)		//not in triangle
			return null;
		//at this point, we have a valid point in the triangle, need to return it
		return pntI;
	}
	
	//this function returns an array of bndTriangle indices in which may be candidates
	//for an intersection with the ray that is used in generateTrajectory
	//pnt is the current point you are at on the userCountour, nominalDist is the average
	//radius of the nerve branch (a trajectory won't be allowed to traverse past this, tri outside of this radius are ignored)
	//need to preprocess maxEdgeLength, will return null if no triangles within nominalDist radius
	public ArrayList<Integer> findCloseTri(double[] pnt, double nominalDist)	{
		Integer currKey;
		double[] currVert = new double[3];
		ArrayList<Integer> temp = new ArrayList<Integer>(0);
		ArrayList<Integer> temp2 = new ArrayList<Integer>(0);
		double distX2, distY2, distZ2;	//prescreen based upon first coordinate and maxEdgeLength
		double screenDist2 = pow((maxEdgeLength*1.5 + nominalDist),2);
		Iterator itr = outerTriVert.keySet().iterator(); //obtain an iterator to go through all boundary verts
		//iterator through all verts that exist on a boundary
		while (itr.hasNext())	{
			currKey = (Integer) itr.next();
			//find the current vertex
			currVert[0] = vMatrix[0][currKey.intValue()]; currVert[1] = vMatrix[1][currKey.intValue()]; currVert[2] = vMatrix[2][currKey.intValue()];
			//prescreen based on proximity
			distX2 = pow((pnt[0]-currVert[0]),2);
			if (distX2 < screenDist2)	{	//close
				distY2 = pow((pnt[1]-currVert[1]),2);
				if (distY2 < screenDist2)	{	//reduced space to sample down to a line
					distZ2 = pow((pnt[2]-currVert[2]),2);
					if (distZ2 < screenDist2)	{
						//its within our region of interest, so add the triangles that share this vert to our possibility list
						temp.addAll(outerTriVert.get(currKey));
					}
				}
			}
		}
		//now remove duplicates
		for (int i=0;i<temp.size();i++)	{
			if (!temp2.contains(temp.get(i)))
				temp2.add(temp.get(i));
		}
		return temp2;
	}
	
	//this routine is another preprocessor, it creates a hashMap of all vertices that are involved
	//in the outerBoundary surface, and then stores an int array of all the triangle vertices that deal with it
	//keys = vertex index, values = arrayList of all triangles that share that vertex
	public void preprocessOuterSurface()	{
		outerTriVert = new HashMap<Integer, ArrayList<Integer>>(0);
		ArrayList<Integer> temp;
		Integer tempInt;
		//cycle through all of the outer Boundary triangles
		for (int i = 0; i<outerTriMatrix[0].length; i++)	{
			//see if that vert is stored yet
			tempInt = new Integer(outerTriMatrix[0][i]);
			if (!outerTriVert.containsKey(tempInt))	{
				//don't have it yet, put one in
				//initialize a new array list
				temp = new ArrayList<Integer>(0);
				temp.add(new Integer(i));
				outerTriVert.put(tempInt, temp);   
			}
			else {
				//already have this one, see if we should add it
				temp = outerTriVert.get(tempInt);
				temp.add(new Integer(i));
				outerTriVert.put(tempInt, temp);   
			}
			//see if that vert is stored yet
			tempInt = new Integer(outerTriMatrix[1][i]);
			if (!outerTriVert.containsKey(tempInt))	{
				//don't have it yet, put one in
				//initialize a new array list
				temp = new ArrayList<Integer>(0);
				temp.add(new Integer(i));
				outerTriVert.put(tempInt, temp);   
			}
			else {
				//already have this one, see if we should add it
				temp = outerTriVert.get(tempInt);
				temp.add(new Integer(i));
				outerTriVert.put(tempInt, temp);   
			}
			//see if that vert is stored yet
			tempInt = new Integer(outerTriMatrix[2][i]);
			if (!outerTriVert.containsKey(tempInt))	{
				//don't have it yet, put one in
				//initialize a new array list
				temp = new ArrayList<Integer>(0);
				temp.add(new Integer(i));
				outerTriVert.put(tempInt, temp);   
			}
			else {
				//already have this one, see if we should add it
				temp = outerTriVert.get(tempInt);
				temp.add(new Integer(i));
				outerTriVert.put(tempInt, temp);   
			}
		}
	}


	//NOTE: THIS IS VERY SIMILAR TO THE ONE USED FOR TESTING THE AXON CLASS
	//BUT IT IS DIFFERENT
	//this method is used by other methods to traverse a trajectory while populating
	//location is how far down the axon the last node was placed and deltaD = distance to
	//the next node location, the function returns a dim=4 array which is 
	//[x, y, z, new current location], where xyz are the coords of the current node being placed
	public double[] nextLocation(double location, double deltaD) throws Exception	{
		try	{
			//these variables are used for walking through the trajectory
			double currDist = 0;		//length we have traveled down the axon
			double[] currUVect = {0,0,0};	//current unit vector of direction
			double currMaxDist = 0;		//maximum distance we can travel on this segment
			int currTrajIndex = 0;		//the starting point of the current segment
			
			//loop until we get to the desired location
			while (currDist < location+deltaD)	{	//this loop may throw an array out of bounds error (if our trajectory is too short)
				//update the currentunit vector and its currMaxDist
				currUVect[0] = usrVerts[0][currTrajIndex+1] - usrVerts[0][currTrajIndex];	//get the difference vector
				currUVect[1] = usrVerts[1][currTrajIndex+1] - usrVerts[1][currTrajIndex];
				currUVect[2] = usrVerts[2][currTrajIndex+1] - usrVerts[2][currTrajIndex];
				currMaxDist = sqrt(pow(currUVect[0],2)+pow(currUVect[1],2)+pow(currUVect[2],2));	//get the size of the vector
				currUVect[0] = currUVect[0]/currMaxDist;	//normalize
				currUVect[1] = currUVect[1]/currMaxDist;	
				currUVect[2] = currUVect[2]/currMaxDist;	
				
				//now we have a unit vector and the maximum length we can travel on this line segment
				if ((location+deltaD) < (currDist+currMaxDist))	{	//it will be on this line segment
					double distLeft = (location+deltaD) - currDist;	//how much more do we need to go
					//update the now non-unit vector with this distance
					currUVect[0] = currUVect[0]*distLeft;
					currUVect[1] = currUVect[1]*distLeft;
					currUVect[2] = currUVect[2]*distLeft;
					//now add this vector to the previous trajectory node
					currUVect[0] = currUVect[0] + usrVerts[0][currTrajIndex];
					currUVect[1] = currUVect[1] + usrVerts[1][currTrajIndex];
					currUVect[2] = currUVect[2] + usrVerts[2][currTrajIndex];
					//now return this new location along with the current distance
					double[] output = new double[4];
					output[0] = currUVect[0]; output[1] = currUVect[1]; output[2] = currUVect[2];
					output[3] = currDist + distLeft;
					return output;
				}
				else	{//we're not going to make it on this line segment, so go to the next line segment
					//update our current distance
					currDist = currDist + currMaxDist;
					//update this for the next loop iteration so we look at the next segment
					currTrajIndex = currTrajIndex + 1;				
				}
			}
		}
		catch (Exception e)	{		//out of bounds exception, meaning we ran out of trajectory
			return null;			//null will indicate the trajectory is full
		}
		return null;		//should never get here
	}
}
