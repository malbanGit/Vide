// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;

public class RegisterSet {

	private static int numberOfEncodings = 4;

	public static final int
		INDEX_ENCODING  = 0,
		OFFSET_ENCODING = 1,
		STACK_ENCODING  = 2,
		XFER_ENCODING   = 3;

	public static Register a, b, d, x, y, u, s, pc, cc, dp;

	private static Register[] allRegisters = {
		a  = new Register( "a",  1, "A" ),
		b  = new Register( "b",  1, "B" ),
		d  = new Register( "d",  2, "D" ),
		x  = new Register( "x",  2, "X" ),
		y  = new Register( "y",  2, "Y" ),
		u  = new Register( "u",  2, "U" ),
		s  = new Register( "s",  2, "S" ),
		pc = new Register( "pc", 2, "P" ),
		cc = new Register( "cc", 1, "C" ),
		dp = new Register( "dp", 1, "G" )
	};

	static {
		setNumberOfEncodings( 4 );
		
		// used as the base-register in indexed-mode addressing
		x.setCode(  INDEX_ENCODING, 0x00 );
		y.setCode(  INDEX_ENCODING, 0x20 );
		u.setCode(  INDEX_ENCODING, 0x40 );
		s.setCode(  INDEX_ENCODING, 0x60 );
		pc.setCode( INDEX_ENCODING, 0x0c );
		
		// used as the offset in indexed-mode addressing
		a.setCode( OFFSET_ENCODING, 0x06 );
		b.setCode( OFFSET_ENCODING, 0x05 );
		d.setCode( OFFSET_ENCODING, 0x0b );
		
		// used in tfr/exg instructions
		d.setCode(  XFER_ENCODING, 0 );
		x.setCode(  XFER_ENCODING, 1 );
		y.setCode(  XFER_ENCODING, 2 );
		u.setCode(  XFER_ENCODING, 3 );
		s.setCode(  XFER_ENCODING, 4 );
		pc.setCode( XFER_ENCODING, 5 );
		a.setCode(  XFER_ENCODING, 8 );
		b.setCode(  XFER_ENCODING, 9 );
		cc.setCode( XFER_ENCODING, 10 );
		dp.setCode( XFER_ENCODING, 11 );
		
		// being pushed or pulled by pshs/pshu/puls/pulu
		cc.setCode( STACK_ENCODING, 1 );
		a.setCode(  STACK_ENCODING, 2 );
		b.setCode(  STACK_ENCODING, 4 );
		d.setCode(  STACK_ENCODING, 6 );
		dp.setCode( STACK_ENCODING, 8 );
		x.setCode(  STACK_ENCODING, 16 );
		y.setCode(  STACK_ENCODING, 32 );
		u.setCode(  STACK_ENCODING, 64 );
		s.setCode(  STACK_ENCODING, 64 );
		pc.setCode( STACK_ENCODING, 128 );
	}

	public RegisterSet() { }

	// Look up a register by name, restriction, and encoding.  Fail
	// (return null) if no such name/lack of restriction/encoding is
	// found.
	public static Register parseReg( ParseString s, String bad, int encoding )
	{
            s.skipSpaces();
            String sym = s.nextSymbol(); 
            if (sym == null) { return null; }

            // malban
            // substitue SP for S
            if (sym.toLowerCase().equals("sp"))
            {
                Register ri = allRegisters[6];
                if (bad.indexOf(ri.getRestrictionCode()) < 0 &&   ri.getAllowed(encoding) ) 
                {
                    s.skip(sym);
                    s.skipSpaces();
                    return ri; // OK!
                }
            }
            
            for (int i=0; i<allRegisters.length; i++) 
            {
                Register ri = allRegisters[i];
                // malban lower / upper case irrelevant with registers!
                if ( ri.getName().equals(sym.toLowerCase()) &&   bad.indexOf(ri.getRestrictionCode()) < 0 &&   ri.getAllowed(encoding) ) 
                {
                    s.skip(sym);
                    s.skipSpaces();
                    return ri; // OK!
                }
            }
		
            return null;
	}

	private static void setNumberOfEncodings( int num ) 
        {
            numberOfEncodings = num;
            for (int i=0; i<allRegisters.length; i++) 
            {
                allRegisters[i].setNumberOfEncodings( num );
            }
	}

}

