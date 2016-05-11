// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// Instructions are defined in the processor-specific code, by the
// class InstructionSet.  That class builds a hashtable associating
// each mnemonic with the parameters of that instruction.  When
// parsing assembly source, each mnemonic is passed to the
// InstructionSet, which does a lookup in its hashtable and attempts
// to make an instance of the instruction.  Most will be instances of
// an InstructionGroup, which will then be given the parameters to
// make it into the specific instruction.
//
// This gets us most of the benefits of inheritance (instruction
// instances are almost like subclasses of the group) without the
// clutter of having a separate Java class for each instruction (as
// the initial design did).
package de.malban.vide.assy.instructions;

public abstract class InstructionGroup extends Instruction {
	String mnemonic, restrictions;
        public String getMnemonic()
        {
            return mnemonic;
        }
	// Instruction holds opcode, opcodelength, datalength

	// Subclasses representing instruction groups will use this to
	// parameterize themselves to become specific instructions.
	public void setDetails( String m, int o, int p, int d, String r ) {
		this.mnemonic     = m;
		this.opcode       = o;
		this.opcodelength = p;
		this.datalength   = d;
		this.restrictions = r;
	}

	public String getRestrictions() { return restrictions; }

}

