// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;


import de.malban.vide.assy.exceptions.AlreadyExistsException;
import java.util.Vector;
import java.io.OutputStream;
import java.io.PrintStream;
import java.io.IOException;

public class Option {
	static Vector allOptions = new Vector();

	String name;
	boolean unique, valueOK, valueNeeded, negativeValueOK, parsed;
	boolean sign, default_sign;
	String value, default_value;
	OutputStream stream;

	public Option( String name, boolean ds, String dv ) {
		this.name = name;
		default_sign = ds;
		default_value = dv;
		stream = null;
		
		// these could be adjusted, but are usually OK as-is
		unique = true;
		valueOK = true;
		valueNeeded = false;
		negativeValueOK = false;
		
		// these will be set when the option is parsed
		sign = false;
		value = null;
		parsed = false;
		
		allOptions.addElement(this);
	}

	public boolean getSign() {
		return parsed? sign :default_sign;
	}

	public String getValue() {
		return parsed? value :default_value;
	}

	public OutputStream getOutputStream() throws IOException {
		stream = null;
		if (!getSign()) { return null; } // no output
		if (getValue()==null) { return System.out; } // not to file
		stream = DynamicFile.getOutputStream(getValue()); // to file
		return stream;
	}

	public PrintStream getPrintStream() throws IOException {
		stream = null;
		if (!getSign()) { return null; } // no output
		if (getValue()==null) { return System.out; } // not to file
		stream = DynamicFile.getPrintStream(getValue()); // to file
		return (PrintStream)stream;
	}

	// if we opened the stream, close it now
	public void closeStream() throws IOException {
		if (stream!=null) {
			stream.close();
			stream = null;
		}
	}

	public boolean parse( String arg )
		throws AlreadyExistsException, IllegalArgumentException
	{
		boolean opt_sign;
		String opt = arg;
		
		if (opt.startsWith("-")) {
			opt_sign = false;
		} else if (opt.startsWith("+")) {
			opt_sign = true;
		} else {
			return false;
		}
		opt = opt.substring(1);
		
		if ( ! opt.startsWith(name) ) { return false; }
		opt = opt.substring(name.length());
		
		// Now we've recognized that it is definitely this option
		
		if (parsed) {
			// we've already got one
			if (unique) {
				// only one is allowed
				throw new AlreadyExistsException(name);
			} else {
				// many allowed; make another instance
				Option another = new Option(
					name, default_sign, default_value );
				another.unique = unique;
				another.valueOK = valueOK;
				another.valueNeeded = valueNeeded;
				another.negativeValueOK = negativeValueOK;
				return another.parse(arg);
			}
		}
		
		// not parsed yet
		
		sign = opt_sign;
		parsed = true;
		if (opt.length() == 0) {
			if (valueNeeded) {
				throw new IllegalArgumentException(
					"missing value for option "+name );
			}
			return true;
		}
		
		// Some value was given after the name
		
		if (!valueOK) {
			throw new IllegalArgumentException("value not allowed");
		}
		
		if (opt.charAt(0) == '=') {
			if (opt.length() <= 1) {
				throw new IllegalArgumentException(
					"missing value for option "+name );
			}
			opt = opt.substring(1);
		}
		value = opt;
		
		return true;
	}

	public static Option parseAny( String arg )
		throws AlreadyExistsException, IllegalArgumentException
	{
		for (int i=0; i<allOptions.size(); i++) {
			Option x = (Option)allOptions.elementAt(i);
			if (x.parse(arg)) { return x; }
		}
		return null;
	}
}

