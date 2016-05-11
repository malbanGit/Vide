// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.expressions;

import de.malban.vide.assy.AsmjDeath;
import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;

public class ExpressionNumberIntel extends ExpressionNumber {

	public ExpressionNumberIntel() { super(0); }

	public int parseNumber( ParseString s ) throws ParseException {
		char ch0 = s.charAt(0);
		int p0 = s.getPosition();

		parseStart(s);
		
		if ( isDecimalDigit(ch0) ) {
			// maybe intel format hex number?
			// (If not, don't throw an exception, just
			// try the following possibilities.)
			s.skip(1); // first digit
			while ( s.length()>0 && isHexDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			int n = s.getPosition() - p0;
			String s2 = s.substring(-n,0);
			// n==0 is not an error, it is just not intel hex
			if (n>0 && s.skipCase("h")) {
				try { value = Integer.parseInt( s2, 16 ); }
				catch (NumberFormatException x) {
					throw new AsmjDeath(
						"Asmj bug: format of $"+s2 );
				}
				return value;
			}
		}
		
		s.setPosition(p0);
		// warning: intel decimal numbers are valid prefixes for
		// intel hex numbers: 12d could be the beginning of 12d0H -
		// hexadecimal 12d0.  Be sure to look for hex numbers first
		// to avoid mistaking 12d0H for decimal 12.
		if ( isDecimalDigit(ch0) ) {
			// maybe intel format decimal number?
			// (If not, don't throw an exception, just
			// try the following possibilities.)
			s.skip(1); // first digit
			while ( s.length()>0 && isDecimalDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			int n = s.getPosition() - p0;
			String s2 = s.substring(-n,0);
			// n==0 is not an error, it is just not intel hex
			if (n>0 && s.skipCase("d")) {
				try { value = Integer.parseInt( s2, 10 ); }
				catch (NumberFormatException x) {
					throw new AsmjDeath(
						"Asmj bug: format of $"+s2 );
				}
				return value;
			}
		}
		
		s.setPosition(p0);
		if ( isOctalDigit(ch0) ) {
			// maybe intel format octal number?
			// (If not, don't throw an exception, just
			// try the following possibilities.)
			s.skip(1); // first digit
			while ( s.length()>0 && isOctalDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			int n = s.getPosition() - p0;
			String s2 = s.substring(-n,0);
			// n==0 is not an error, it is just not intel hex
			if (n>0 && (s.skipCase("o") || s.skipCase("q"))) {
				try { value = Integer.parseInt( s2, 8 ); }
				catch (NumberFormatException x) {
					throw new AsmjDeath(
						"Asmj bug: format of $"+s2 );
				}
				return value;
			}
		}
		
		s.setPosition(p0);
		if ( isBinaryDigit(ch0) ) {
			// maybe intel format binary number?
			// (If not, don't throw an exception, just
			// try the following possibilities.)
			s.skip(1); // first digit
			while ( s.length()>0 && isBinaryDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			int n = s.getPosition() - p0;
			String s2 = s.substring(-n,0);
			// n==0 is not an error, it is just not intel hex
			if (n>0 && s.skipCase("b")) {
				try { value = Integer.parseInt( s2, 2 ); }
				catch (NumberFormatException x) {
					throw new AsmjDeath(
						"Asmj bug: format of $"+s2 );
				}
				return value;
			}
		}
		
		// s does not hold a Intel hex number
		parseError("missing numeric literal");
		
		return 0; // unreachable, but javac doesn't know that.
	}

}

