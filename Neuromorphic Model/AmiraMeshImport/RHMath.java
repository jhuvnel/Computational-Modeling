/*this is Russ Hayden's custom math package to extend upon Java's math package
 * everything is static, so you never need to implement an object of 'RHMath'
 * All these functions return independent arrays, so your not still accessing
 * the origal vector (nor making changes to it inadvertantly (remember that Java
 * passes objects and arrays by reference))
 */

//import required library
import static java.lang.Math.*;

public class RHMath {
	
	//this function returns is used to find the point along a ray which (when connected to 
	//the other point pnt) will result in two perpindicular rays.  It returns the value of the 
	//parameter r which describes the intersection along the original ray from point v0
	//v0 to v1 describe the original ray (user defined cnt), pnt should be the stepped
	//version of the previous node
	//be careful of a zero vector!
	public static double perpDistance(double[] v0, double[] v1, double[] pnt)	{
		//first find the ray
		double[] ray = {v1[0] - v0[0], v1[1] - v0[1], v1[2] - v0[2]};//new double[3];
		//calculate required dot products
		double rayDotPnt = ray[0]*pnt[0]+ray[1]*pnt[1]+ray[2]*pnt[2];
		double rayDotV0 = ray[0]*v0[0]+ray[1]*v0[1]+ray[2]*v0[2];
		double rayDotRay = ray[0]*ray[0]+ray[1]*ray[1]+ray[2]*ray[2];
		//calculate value of parameter
		double r = (rayDotPnt - rayDotV0)/rayDotRay;
		return r;
	}
	
	//vec1 - vec2 
	public static double[] vecSub(double[] vec1, double[] vec2)	{
		double[] result = new double[3];
		result[0] = vec1[0] - vec2[0];
		result[1] = vec1[1] - vec2[1];
		result[2] = vec1[2] - vec2[2];
		return result;
	}

	//vec1 + vec2 
	public static double[] vecAdd(double[] vec1, double[] vec2)	{
		double[] result = new double[3];
		result[0] = vec1[0] + vec2[0];
		result[1] = vec1[1] + vec2[1];
		result[2] = vec1[2] + vec2[2];
		return result;
	}

	//returns the scalar product of vec with m
	public static double[] mult(double[] vec, double m)	{
		double[] result = new double[3];
		result[0] = vec[0]*m;
		result[1] = vec[1]*m;
		result[2] = vec[2]*m;
		return result;
	}
	
	//dot product of vec1 and vec2
	public static double dot(double[] vec1, double[] vec2)	{
		double result = vec1[0]*vec2[0];
		result = result + vec1[1]*vec2[1];
		result = result + vec1[2]*vec2[2];
		return result;
	}
	
	//vec1 cross vec2
	public static double[] cross(double[] vec1, double[] vec2)	{
		double[] result = new double[3];
		result[0] = vec1[1]*vec2[2] - vec1[2]*vec2[1];
		result[1] = vec1[2]*vec2[0] - vec1[0]*vec2[2];
		result[2] = vec1[0]*vec2[1] - vec1[1]*vec2[0];
		return result;
	}
	
	//return the magintude of a vector
	public static double mag(double[] vec)	{
		return sqrt(dot(vec,vec));
	}
	
	//returns unit vect of vec
	public static double[] unitVec(double[] vec)	{
		double mag = mag(vec);
		double[] result = new double[3];
		result[0] = vec[0]/mag;
		result[1] = vec[1]/mag;
		result[2] = vec[2]/mag;
		return result;
	}
	
	//returns unit vect of the difference vector 
	public static double[] unitVec(double[] vec1, double[] vec2)	{
		double[] vec = vecSub(vec1,vec2);
		double mag = mag(vec);
		double[] result = new double[3];
		if (mag == 0)	{	//in case vec1 == vec2, return a zero vector
			result[0] = 0; result[1] = 0; result[2] = 0;
			return result;
		}
		result[0] = vec[0]/mag;
		result[1] = vec[1]/mag;
		result[2] = vec[2]/mag;
		return result;
	}
	//return the distance between two vectors
	public static double dist(double[] vec1, double[] vec2)	{
		double[] diff = vecSub(vec1,vec2);
		double result = mag(diff);
		return result;
	}
	
	//return the square of the distance between to vectors
	//so we avoid the squareroot of mag
	public static double dist2(double[] vec1, double[] vec2)	{
		double[] diff = vecSub(vec1,vec2);
		diff[0] = diff[0]*diff[0];
		diff[1] = diff[1]*diff[1];
		diff[2] = diff[2]*diff[2];
		return diff[0]+diff[1]+diff[2];
	}
	
	//returns a vector compatible with these functions from comsol's form
	//just a transpose, but in java you cannot access an array going down easily
	public static double[] v(double[][] data, int i)	{
		double[] result = new double[3];
		result[0] = data[0][i];
		result[1] = data[1][i];
		result[2] = data[2][i];
		return result;
	}
	
	//this routine finds the closest vertex to pnt within the vertex matrix vMatrix
	//returns the index of the closest vertex
	public static int closestNode(double[] pnt, double[][] vMatrix)	{
		double temp;
		//initiallize to the first node
		double result = dist2(pnt, v(vMatrix,0));
		int resultInd = 0;
		//cycle through all the nodes
		for (int i = 0; i<vMatrix[0].length; i++)	{
			temp = dist2(pnt, v(vMatrix,i));
			if (temp < result)	{
				result = temp;
				resultInd = i;
			}
		}
		return resultInd;
	}
	
	//this routine returns the physical extents of the vertices in a vert Matrix
	public static double[][] boundingBox(double[][] vMatrix)	{
		//intialize to the first node
		double minX = vMatrix[0][0];
		double maxX = vMatrix[0][0];
		double minY = vMatrix[1][0];
		double maxY = vMatrix[1][0];
		double minZ = vMatrix[2][0];
		double maxZ = vMatrix[2][0];
		//cycle through all the vertices
		for (int i = 0; i<vMatrix[0].length; i++)	{
			if (vMatrix[0][i] < minX)
				minX = vMatrix[0][i];
			if (vMatrix[0][i] > maxX)
				maxX = vMatrix[0][i];
			if (vMatrix[1][i] < minY)
				minY = vMatrix[1][i];
			if (vMatrix[1][i] > maxY)
				maxY = vMatrix[1][i];
			if (vMatrix[2][i] < minZ)
				minZ = vMatrix[2][i];
			if (vMatrix[2][i] > maxZ)
				maxZ = vMatrix[2][i];
		}
		//prepare matrix for output
		double[][] result = new double[2][3];
		result[0][0] = minX; result[1][0] = maxX;
		result[0][1] = minY; result[1][1] = maxY;
		result[0][2] = minZ; result[1][2] = maxZ;
		
		return result;
	}
	
	//returns 6 times the volume of the tet defined by the vectors a b c d
	//also, if you want true volume, take the abs value
	public static double tetVolume6(double[] a, double[] b, double[] c, double[] d)	{
		double[] da = vecSub(d,a);
		double[] db = vecSub(d,b);
		double[] dc = vecSub(d,c);
		double result =  dot(da, cross(db,dc));
		return result;
	}
	
	//this method returns -1 if the point is not in the tet, 0 if its on the surface
	//and 1 if its inside the tet
	//NOTE: THIS CAN BE IMPLEMENTED MUCH FASTER IF SOMEONE HAS TIME TO DO IT
	public static int inTet(double[][] tetVerts, double[] pnt)	{
		//first check to see if the pnt is one of the verts
		if (v(tetVerts,0).equals(pnt) || v(tetVerts,1).equals(pnt) || v(tetVerts,2).equals(pnt) || v(tetVerts,3).equals(pnt))
			return 0;		//just say its on the surface		
		int result = -1;
		double w = RHMath.tetVolume6(RHMath.v(tetVerts, 0),RHMath.v(tetVerts, 1),RHMath.v(tetVerts, 2),RHMath.v(tetVerts, 3));
		double s = RHMath.tetVolume6(RHMath.v(tetVerts, 0),pnt,RHMath.v(tetVerts, 2),RHMath.v(tetVerts, 3));
		double u = RHMath.tetVolume6(RHMath.v(tetVerts, 0),RHMath.v(tetVerts, 1),pnt,RHMath.v(tetVerts, 3));
		double t = RHMath.tetVolume6(RHMath.v(tetVerts, 0),RHMath.v(tetVerts, 1),RHMath.v(tetVerts, 2),pnt);
		//if they all have the same sign
		if ((w>=0 && s>=0 && u>=0 && t>=0) || (w<=0 && s<=0 && u<=0 && t<=0))	{
			double tot = abs(s) + abs(u) + abs(t);
			if (tot < abs(w))	{		//total less than w
				//now check to see if any are coplanar
				if (s == 0 || u == 0 || t == 0)
					result = 0;
				else
					result = 1;
			}
		}	
		return result;
	}
	
	public static int tetTest(int amount)
	{
		for (int i = 0; i < (amount-1); i++)	{
			double[][] tet = new double[3][4];
			tet[0][0] = 0; tet[0][1] = 1; tet[0][2] = 0; tet[0][3] = 0;
			tet[1][0] = 0; tet[1][1] = 0; tet[1][2] = 1; tet[1][3] = 0;
			tet[2][0] = 0; tet[2][1] = 0; tet[2][2] = 0; tet[2][3] = 1;
			double[] pnt = {0.1, 0.1, 0.1};
			inTet(tet, pnt);
		}
		return amount;
	}
	public static int tetTest2(int amount)
	{
		int result = 1;
		for (int i = 0; i < (amount - 1); i++)	{
			double[] pnt = {0.1, 0.1, 0.1};
			double[] pnt2 = {0.2, 0.1, 0.1};
			double [] vec = vecSub(pnt, pnt2);
			double dist = dot(vec,vec);
			
			if (dist > 0.001)	{
				result=1;
			}
		}
		return amount*result;
	}

}
