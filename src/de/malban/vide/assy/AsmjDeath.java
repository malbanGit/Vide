// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// Created by a condition that should terminate the program: either
// an inconsistency that indicates a programming bug, or an unexpected
// input error so severe that there would be no point in trying to
// recover.
package de.malban.vide.assy;

import java.io.StringWriter;
import java.io.PrintWriter;

public class AsmjDeath extends RuntimeException {
	public AsmjDeath(String s) { super(s); }
	public AsmjDeath(Throwable x) { super(getThrowableStackTrace(x)); }

	private static String getThrowableStackTrace( Throwable x ) {
		StringWriter w = new StringWriter();
		PrintWriter p = new PrintWriter(w);
		x.printStackTrace(p);
		return w.toString();
	}
}

