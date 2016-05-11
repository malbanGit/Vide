// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.arguments;

import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;
import de.malban.vide.assy.Register;
import de.malban.vide.assy.RegisterSet;

public class ArgumentRegisterList extends Argument6809 {
	int numRegisters;
	Register[] registers;

        public int getNumRegisters()
        {
            return numRegisters;
        }
	public ArgumentRegisterList( String arg, String restr, int encoding )
		throws ParseException
	{
            ParseString s = new ParseString(arg);
            registers = new Register[10]; // should be enough
            numRegisters = 0;
            while (s.length() > 0) 
            {
                Register reg = RegisterSet.parseReg(s,restr,encoding);
                if (reg == null) 
                {
                    throw new ParseException("illegal register");
                }
                if (numRegisters >= 10) {
                    throw new ParseException("too many registers");
                }
                registers[numRegisters++] = reg;
                if (s.length() < 1 || s.charAt(0) != ',') { break; }
                s.skip(1); // comma
            }
	}

	// get a register from the list
	public Register getReg(int n) 
        {
            if (registers == null || n > numRegisters) { return null; }
            return registers[n];
	}

}

