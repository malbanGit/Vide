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

public class ExpressionNumberMotorola extends ExpressionNumber {

	public ExpressionNumberMotorola() { super(0); }

	public int parseNumber( ParseString s ) throws ParseException {
		int n;
		String s2 = null;

		parseStart(s);
		if (s.skip("$")) {
			// motorola hexadecimal number
			int p1 = s.getPosition();
			while ( s.length()>0 && isHexDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			n = s.getPosition() - p1;
			if (n==0) { parseError("missing hex digits",false); }
			s2 = s.substring(-n,0);
			try { value = Integer.parseInt( s2, 16 ); }
			catch (NumberFormatException x) {
				throw new AsmjDeath(
					"Asmj bug: format of $"+s2 );
			}
			return value;
		} else if (s.skip("@")) {
			// motorola octal number
			int p1 = s.getPosition();
			while ( s.length()>0 && isOctalDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			n = s.getPosition() - p1;
			if (n==0) { parseError("missing octal digits",false); }
			s2 = s.substring(-n,0);
			try { value = Integer.parseInt( s2, 8 ); }
			catch (NumberFormatException x) {
				throw new AsmjDeath(
					"Asmj bug: format of $"+s2 );
			}
			return value;
		} else if (s.skip("%")) {
			// motorola binary number
			int p1 = s.getPosition();
			while ( s.length()>0 && isBinaryDigit(s.charAt(0)) ) {
				s.skip(1);
			}
			n = s.getPosition() - p1;
			if (n==0) { parseError("missing binary digits",false); }
			s2 = s.substring(-n,0);
			try { value = Integer.parseInt( s2, 2 ); }
			catch (NumberFormatException x) {
				throw new AsmjDeath(
					"Asmj bug: format of $"+s2 );
			}
			return value;
		}

		// s does not hold a Motorola hex/octal/binary number
		parseError("missing numeric literal");

		return 0; // unreachable, but javac doesn't know that.
	}
}

