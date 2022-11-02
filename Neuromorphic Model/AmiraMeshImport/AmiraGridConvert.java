/* This class is used to convert an ASCII Amira Mesh Grid file to a format readable by COMSOL
 * AmiraGridConvert is meant only for tetrahedra meshes
 * READ ALL WARNINGS IN THE COMMENTS OF THIS FILE BEFORE TRYING TO USE AmiraGridConvert
 * Please remember to call AmiraGridConvert.closeFile() when you are finished
 * This routine is more robust, but less user friendly, than UCDConvert
 * Author: Russell Hayden, 2007
 */

import java.io.*;

//WARNING: indexing begins at 1 in these matrices, so subtract one when using in java


public class AmiraGridConvert {
	private String fileName;		    //file name of the ASCII mesh file to be read
	private StreamTokenizer filePars;	//tokenizer used to pars the file
	private FileReader fr;				//file handle
	
	//unlike UCDConvert, you have direct access to these variables
	public int numVert;					//amount of vertices
	public int numTet;					//amount of tetrahedrons
	public int numBndTri;				//amount of triangles assigned a boundary ID
	public double[][] vMatrix;		    //these three variables are the matrices femmesh needs
	public double[][] tMatrix;
	public double[][] dMatrix;
	public double[][] bndMatrix;		//hold triangle vertices for boundary triangles
	public int[][] bndID;					//holds the boundary ID number for each boundary triangle
	
	//constructor
	public AmiraGridConvert(String fileName)	throws Exception	{
		this.fileName = fileName;
		fr = new FileReader(this.fileName);				//create access to the file
		BufferedReader br = new BufferedReader(fr);		//improves file access performance
		filePars = new StreamTokenizer(br);				
		//initialize tokenizer for our case
		filePars.resetSyntax();
		filePars.whitespaceChars(0, ' ');				//specifiy what a whitespace is
		filePars.eolIsSignificant(false);				//don't want end of line markers
		filePars.wordChars(33,255);						//all normal characters can be parsed
		filePars.commentChar('#');						//# is used for comments in UCD files
		filePars.parseNumbers();						//return double precision numbers
		
		//obtain the amount of tet and vertices, bnd triangles, etc.
		boolean foundMatrixSize = false;		//flags if we found all the boundary info we need
		//search for the size to dim the arrays at, should be first few values
		while (!foundMatrixSize)	{
			filePars.nextToken();
			if (filePars.ttype == StreamTokenizer.TT_WORD)	{
				if (filePars.sval.equals("nNodes"))	{
					filePars.nextToken();	//now it has the number of vertices
					numVert = (int) filePars.nval;
				}
				else if (filePars.sval.equals("nTetrahedra"))	{
					filePars.nextToken();	//now it has the number of tets
					numTet = (int) filePars.nval;
				}
				else if (filePars.sval.equals("nBoundaryTriangles"))	{
					filePars.nextToken();	//now it has the number of bnd triangles
					numBndTri = (int) filePars.nval;
					//finished finding all the values we need, break the loop
					foundMatrixSize = true;
				}
			}
			else if (filePars.ttype == StreamTokenizer.TT_EOF)
				throw new Exception("Error: AmiraGridConvert could not find all values needed.  Make sure you defined Boundary IDs.");			
		}		
	}
	public AmiraGridConvert()	throws Exception	{
		throw new Exception("Cannot use standard constructor for AmiraGridConvert class.");
	}
	
	//conversion functions
	//WARNING: run only once per instance (otherwise buffer location will be wrong!)
	public void convert() throws Exception	{
		vMatrix = new double[3][numVert];		//initialize matrices
		tMatrix = new double[4][numTet];
		dMatrix = new double[1][numTet];
		bndMatrix = new double[3][numBndTri];
		bndID = new int[1][numBndTri];
		
		int i, j;								//iterators
		//first find the starting point of vertex coordinates
		boolean foundInfo = false;		//used for the search loops below
		boolean foundOnce = false;		//need to find each token twice
		//try to find the token @1 twice, the second time vertex info is listed below
		while (!foundInfo)	{
			filePars.nextToken();
			if (filePars.ttype == StreamTokenizer.TT_WORD)	{
				if (filePars.sval.equals("@1") && foundOnce == false)	
					foundOnce = true;
				else if (filePars.sval.equals("@1") && foundOnce == true)
					foundInfo = true;
			}
			else if (filePars.ttype == StreamTokenizer.TT_EOF)
				throw new Exception("Found end of file before vertex info found.");
		}
		
		//now pull in each vertex coordinate and store it in the matrix
		for (i = 0; i < numVert; i++)	{
			for (j=0; j < 3; j++)	{
				filePars.nextToken();	//get a coordinate
				if (filePars.ttype == StreamTokenizer.TT_NUMBER)	
					vMatrix[j][i] = filePars.nval;
				else
					throw new Exception("Error while pulling in vertex info.");
			}
		}
		
		//now try to find tetrahedron information, located after @2
		foundInfo = false;		//reset flag
		while (!foundInfo)	{
			filePars.nextToken();
			if (filePars.ttype == StreamTokenizer.TT_WORD)	{
				if (filePars.sval.equals("@2"))	
					foundInfo = true;
			}
			else if (filePars.ttype == StreamTokenizer.TT_EOF)
				throw new Exception("Found end of file before tetrahedron info found.");
		}
		
		//now pull in each tetrahedron vertex index and store it in the matrix
		for (i = 0; i < numTet; i++)	{
			for (j=0; j < 4; j++)	{
				filePars.nextToken();	//get a vertex index, amira starts at 1 not 0 in this case
				if (filePars.ttype == StreamTokenizer.TT_NUMBER)	
					tMatrix[j][i] = filePars.nval;	
				else
					throw new Exception("Error while pulling in tetrahedron info.");
			}
		}
		
		//now try to find domain information, located after @3
		foundInfo = false;		//reset flag
		while (!foundInfo)	{
			filePars.nextToken();
			if (filePars.ttype == StreamTokenizer.TT_WORD)	{
				if (filePars.sval.equals("@3"))	
					foundInfo = true;
			}
			else if (filePars.ttype == StreamTokenizer.TT_EOF)
				throw new Exception("Found end of file before domain info found.");
		}
		
		//now populate the domain matrix
		for (i = 0; i < numTet; i++)	{
			filePars.nextToken();	//get a domain number
			if (filePars.ttype == StreamTokenizer.TT_NUMBER)	
				dMatrix[0][i] = filePars.nval + 1;	//can't have zeros when dealing with comsol
			else
				throw new Exception("Error while pulling in domain info.");
		}
		
		//now find the bndTriangle bndIDs, located after @4
		foundInfo = false;		//reset flag
		while (!foundInfo)	{
			filePars.nextToken();
			if (filePars.ttype == StreamTokenizer.TT_WORD)	{
				if (filePars.sval.equals("@4"))	
					foundInfo = true;
			}
			else if (filePars.ttype == StreamTokenizer.TT_EOF)
				throw new Exception("Found end of file before bndTriangle domain info found.");
		}
		
		//now populate the bndID matrix
		for (i = 0; i < numBndTri; i++)	{
			filePars.nextToken();	//get a vertex number
			if (filePars.ttype == StreamTokenizer.TT_NUMBER)	
				bndID[0][i] = (int) filePars.nval;
			else
				throw new Exception("Error while pulling in bndTriangle domain info.");
		}

		//now find the bndTriangle vertex index numbers, located after @5
		foundInfo = false;		//reset flag
		while (!foundInfo)	{
			filePars.nextToken();
			if (filePars.ttype == StreamTokenizer.TT_WORD)	{
				if (filePars.sval.equals("@5"))	
					foundInfo = true;
			}
			else if (filePars.ttype == StreamTokenizer.TT_EOF)
				throw new Exception("Found end of file before bndTriangle vertex info found.");
		}

		//now populate the bndMatrix
		for (i = 0; i < numBndTri; i++)	{
			for (j=0; j < 3; j++)	{
				filePars.nextToken();	//get a coordinate
				if (filePars.ttype == StreamTokenizer.TT_NUMBER)	
					bndMatrix[j][i] = filePars.nval;
				else
					throw new Exception("Error while pulling in bndTriangle vertex info.");
			}
		}
	}
	
	//close your files
	public void closeFile()	{
		try	{
			fr.close();
		}
		catch (Exception e)	{
			//do nothing, either we already closed it, or it was closed by the system (hopefully)
		}
	}
	//destructor
	protected void finalize()	{
		try	{
			fr.close();
		}
		catch (Exception e)	{
			//do nothing, either we already closed it, or it was closed by the system (hopefully)
		}
	}
}
