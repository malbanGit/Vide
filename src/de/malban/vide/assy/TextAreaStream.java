// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This is an OutputStream that puts the written data into a TextArea.
//
// The naive approach (appending each byte to the TextArea) was far too
// slow.  A better approach is to append bytes into a StringBuffer to
// get whole lines, and then append each line to the TextArea.
//
// We could also accumulate all text into the StringBuffer, and only
// copy that into the TextArea in close().  While even faster than the
// line-at-a-time approach, this runs the risk of never showing any text
// at all if close() is never called for whatever reason (say, a bug or
// runtime exception).  Since this entire project is still rather crude,
// such an event is not at all unlikely, so this most-efficient technique
// is too risky.
//
// If you want maximum efficiency and are willing to accept the risk of
// getting no output at all, uncomment the lines marked by '// do file',
// and comment out the lines marked by '// do line'
package de.malban.vide.assy;

import java.awt.TextArea;
import java.io.OutputStream;
import java.io.IOException;


public class TextAreaStream extends OutputStream {
	TextArea ta;
	StringBuffer sb;

	public TextAreaStream( TextArea ta ) {
		this.ta = ta;
		sb = new StringBuffer();
	}

	public void write(int b) throws IOException {
		sb.append((char)b);
		if (b == '\n') {                    // do line
			ta.append( sb.toString() ); // do line
			sb.setLength(0);            // do line
		}                                   // do line
	}

	//public void close() throws IOException {  // do file
	//	ta.setText( sb.toString() );        // do file
	//	super.close();                      // do file
	//}                                         // do file

}

