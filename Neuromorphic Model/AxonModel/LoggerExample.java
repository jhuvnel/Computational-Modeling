/**
 * 
 */
import java.io.IOException;
import java.util.logging.*;

/**
 * @author Evan
 *
 */
public class LoggerExample {

	/**
	 * @param args
	 */
	private static final Logger LOGGER = Logger.getLogger(LoggerExample.class.getName());
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		LOGGER.setLevel(Level.ALL);
		LOGGER.info("Logger name: "+LOGGER.getName());
		LOGGER.warning("Can cause ArrayIndexOutOfBoundsException");
		
		Handler fileHandler = null; //declare Handler object
		Formatter simpleFormatter = null;
		
		try { // define Handler object and add it to LOGGER object
		fileHandler = new FileHandler("./testlog.log"); 
		LOGGER.addHandler(fileHandler);
		fileHandler.setLevel(Level.ALL);
		
		// define simpleFormatter and assign it to fileHandler
		simpleFormatter = new SimpleFormatter();
		fileHandler.setFormatter(simpleFormatter);
		
		
		LOGGER.config("Configuration done.");
		LOGGER.log(Level.FINE, "Finer test log.");
		}catch(IOException exception){
			LOGGER.log(Level.SEVERE, "Error occured in FileHandler.", exception);
		}
		
		
		// an array of size 3
		int []a = {1,2,3};
		int index = 2;
		LOGGER.config("index is set to "+index);
		
		try {
			System.out.println(a[index]);
			LOGGER.log(Level.FINE, "Index = "+index+", a[index] = "+a[index]);
		}catch(ArrayIndexOutOfBoundsException ex) {
			LOGGER.log(Level.SEVERE, "Exception occur", ex);
		}
	}

}
