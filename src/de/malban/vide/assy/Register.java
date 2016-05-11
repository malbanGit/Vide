// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents a generic register.  Instances of this class
// are made by the RegisterSet class, which encapsulates the information
// about the register set for a particular processor.
//
// There are typically several different ways that a register might be
// encoded into an instruction.  For example, when used as an index,
// it might be a bit pattern embedded in the middle of the opcode itself,
// but when used in a move/load/store instruction it might need some other
// bit pattern in a different place in the instruction.
//
// The RegisterSet class will define how many such encodings there are,
// and set the actual code values for each encoding of each register.
// The setNumberOfEncodings() and setCode() methods are provided to allow
// for this.
package de.malban.vide.assy;

public class Register {
	public String name, restrictionCode;
	public int size; // in bytes
	public int[] codes;
	public boolean[] allowed;

	// Parameters:
	//   name is the symbol for this register in the assembly source code.
	//   restriction is compared with instruction's restriction codes.
	//   size is the number of bytes that the register holds.
	public Register( String n, int s, String r ) {
		name = n;
		size = s;
		restrictionCode = r;
		int len = 1; // may later be changed by RegisterSet
		allowed = new boolean[ len ];
		codes   = new int[ len ];
		for (int i=0; i<len; i++) { allowed[i] = false; }
	}

	public String  getName()                  { return name; }
	public int     getSize()                  { return size; }
	public String  getRestrictionCode()       { return restrictionCode; }
	public boolean getAllowed( int encoding ) { return allowed[encoding]; }
	public int     getCode( int encoding )    { return codes[encoding]; }

	// These should be called only from RegisterSet, which encapsulates
	// the information about the register set for a particular processor.
	public void setNumberOfEncodings( int num ) {
		int[]     enc = new int[num];
		boolean[] alw = new boolean[num];
		for (int i=0; i<num; i++) { alw[i] = false; }
		// keep existing code info
		if (codes != null) {
			for (int i=0; i<codes.length && i<num; i++) {
				enc[i] = codes[i];
				alw[i] = allowed[i];
			}
		}
		codes   = enc;
		allowed = alw;
	}
	public void setCode( int encoding, int num ) {
		allowed[encoding] = true;
		codes[encoding] = num;
	}

}
