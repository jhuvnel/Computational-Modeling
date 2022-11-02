/* This class is used to convert a UCD file to a format readable by COMSOL
 * UCDConvert is meant only for tetrahedra meshes
 * READ ALL WARNINGS IN THE COMMENTS OF THIS FILE BEFORE TRYING TO USE UCDConvert
 * Please remember to call UCDConvert.closeFile() when you are finished
 * Author: Russell Hayden, 2006
 */
import java.io.*;

public class UCDConvert {	
	private String fileName;		    //file name of the UCD file (*.inp) to be read
	private StreamTokenizer filePars;	//tokenizer used to pars the file
	private FileReader fr;				//file handle
	private int numVert;				//amount of vertices
	private int numTet;					//amount of tetrahedrons
	private double[][] vMatrix;		    //these three variables are the matrices femmesh needs
	private double[][] tMatrix;
	private double[][] dMatrix;
	
	//constructor
	public UCDConvert(String fileName)	throws Exception	{
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
		
		//obtain the amount of tet and vertices
		filePars.nextToken();
		if (filePars.ttype == StreamTokenizer.TT_WORD)
			throw new Exception("Illegal UCD format");
		numVert = (int) filePars.nval;
		filePars.nextToken();
		if (filePars.ttype == StreamTokenizer.TT_WORD)
			throw new Exception("Illegal UCD format");
		numTet = (int) filePars.nval;
		
		//clear the next 3 values (not used)
		filePars.nextToken(); filePars.nextToken(); filePars.nextToken();
	}
	public UCDConvert()	throws Exception	{
		throw new Exception("Cannot use standard constructor for UCDconvert class");
	}
	
	//accessor functions
	public int numVert()	{
		return numVert;
	}
	public int numTet()	{
		return numTet;
	}
	//WARNING: run these accessor functions after UCDConvert.convert is run
	public double[][] vMatrix()	{
		return vMatrix;
	}
	public double[][] tMatrix()	{
		return tMatrix;
	}
	public double[][] dMatrix()	{
		return dMatrix;
	}
	
	//conversion functions
	//WARNING: run only once per instance (otherwise buffer location will be wrong!)
	public void convert() throws Exception	{
		vMatrix = new double[3][numVert];		//initialize matrices
		tMatrix = new double[4][numTet];
		dMatrix = new double[1][numTet];
		int i, j;								//iterators
		//vertices are listed first in the UCD file
		for (i = 0; i < numVert; i++)	{
			//first token is the numbert of the vert, not needed here
			filePars.nextToken();
			for (j=0; j < 3; j++)	{
				filePars.nextToken();	//get a coordinate
				if (filePars.ttype == StreamTokenizer.TT_NUMBER)	
					vMatrix[j][i] = filePars.nval;
				else
					throw new Exception("Illegal UCD format");
			}
		}
		//tetrahedrons and domains are listed next
		for (i = 0; i < numTet; i++)	{
			//first token is the number of the tet, not needed
			filePars.nextToken();
			//next token is the domain number for this particular tet
			filePars.nextToken();
			if (filePars.ttype == StreamTokenizer.TT_WORD)
				throw new Exception("Illegal UCD format");
			dMatrix[0][i] = filePars.nval + 1;		//add 1 because COMSOL doesn't use 0
			//the next token describes the object type, only tet is allowed
			filePars.nextToken();
			if (filePars.ttype != StreamTokenizer.TT_WORD)
				throw new Exception("Illegal UCD format");
			else	{
				if (!filePars.sval.equals("tet"))
					throw new Exception("Only Tetrahedral Meshes Allowed");
			}		
			//now pars the four vertex numbers for this particular tet
			for (j=0; j < 4; j++)	{
				filePars.nextToken();	//get a vertex number
				if (filePars.ttype == StreamTokenizer.TT_NUMBER)	
					tMatrix[j][i] = filePars.nval + 1;	//add 1 because COMSOL doesn't use 0
				else
					throw new Exception("Illegal UCD format");
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

