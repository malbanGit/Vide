// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class opens files for I/O, but references the file-I/O classes
// only dynamically.  This allows Asmj to be loaded into an environment
// with file security restrictions (ie, an Applet), and only throws an
// exception if file access is actually attempted.  As long as the applet
// does not attempt file I/O, everything is fine.  (As an applet, the
// assembler can read and write to/from TextAreas on a GUI).
package de.malban.vide.assy;

import java.io.Reader;
import java.io.LineNumberReader;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public class DynamicFile {

	public static OutputStream getOutputStream( String filename )
		throws IOException
	{
		return (OutputStream)
			getFileIOClass( "FileOutputStream", filename );
	}

	public static LineNumberReader getLineNumberReader( String filename )
		throws IOException
	{
		Reader r = (Reader)getFileIOClass( "FileReader", filename );
		return new LineNumberReader( r );
	}

	public static PrintStream getPrintStream( String filename )
		throws IOException
	{
		return new PrintStream( getOutputStream(filename) );
	}

	private static Object getFileIOClass( String className, String arg )
		throws IOException
	{
		try {
			Class c = Class.forName( "java.io."+className );
			// throws ClassNotFoundException
			
			Class types[] = { "".getClass() };
			Constructor k = c.getDeclaredConstructor( types );
			// throws NoSuchMethodException, SecurityException
			
			Object parameters[] = { arg };
			Object x = k.newInstance( parameters );
			// throws InstantiationException IllegalAccessException,
			//  IllegalArgumentException, InvocationTargetException
			
			return x;
		} catch (InvocationTargetException x) {
			if (x.getTargetException() instanceof IOException) {
				throw (IOException)x.getTargetException();
			}
		} catch (SecurityException x) {
			throw new IOException("Cannot open file '"+arg+"'");
		} catch (Exception x) {
			throw new AsmjDeath(x);
		}
		
		return null;
	}


}

