// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.

// This class represents a line of source code, with information about
// the instruction generated from it (if any), the macro that it refers
// to (if any), the file and line number that it came from, any error
// messages that result from trying to asseble it, and a reference to
// the following line.
package de.malban.vide.assy;

import de.malban.vide.assy.instructions.Instruction;
import java.io.File;
import java.util.Vector;

public class SourceLine {
	public String label, op, rest, inputLine; // the line & its parts
	String fileName;      // name of the file this line was read from
	int lineNumber;       // line number in file
	Vector errorMessages; // error messages regarding this line
	Vector warningMessages; // error messages regarding this line
	Vector optimizeMessages; // error messages regarding this line
	Instruction instr;    // if this is an instruction, instr holds it
	Macro macro;          // if this is a macro reference, macro holds it
	boolean parsedOK;     // line looks OK
	SourceLine next;      // the next line
	int macroDepth;       // how many macros expanded to produce this line?
	boolean hidden;       // supress this line in the output listing?
        String endOfLineComment = "";
        boolean endOfLineCommentDone = false;
        String fullLineComment = "";
        int dp_value = -1;
        private boolean optimize = false;
        public boolean isOptimize() { return optimize;}
        public void  setOptimize(boolean b)
        {  
            optimize= b;
        }
        public int getDP()
        {
            return dp_value;
        }
        public void setDP(int d)
        {
            dp_value = d;
        }
	static Comment commentRecognizer = Asmj.processor.commentRecognizer;

        public String getEndOfLineComment()
        {
            return endOfLineComment;
        }
        // used by comment out in asm and set by instruction EQU
        public void setEndOfLineCommentProcessed(boolean b)
        {
            endOfLineCommentDone = b;
        }
        public static String convertSeperator(String filename)
        {
            String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
            ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
            return ret;
        }
	public SourceLine( String line, String fname, int lineNum ) 
        {
            inputLine = line;
            fileName = fname;
            lineNumber = lineNum;

            label = op = rest = null;
            errorMessages = null;
            instr = null;
            macro = null;
            macroDepth = 0;
            hidden = false;

            parsedOK = false;
            
            if (line.toLowerCase().contains("include"))
            {
                line = convertSeperator(line);
                // cheap circumvention of direct quotes after include
                line = de.malban.util.UtilityString.replace(line, "clude\"", "clude \"");
                line = de.malban.util.UtilityString.replace(line, "CLUDE\"", "CLUDE \"");
            }            
            ParseString s = new ParseString(line);
            s.setPosition(0);

            if (line == null || line.trim().length() == 0) { return; }
            // label?
            
            // workaround so that LABEL=1 gets recognized without changing the complete parsing!
            // replace "=" with " = "
            String tlabel = s.nextWord();
            if (tlabel.length() == 0) 
            {
                s.setPosition(0);
            }
            else
            {
                if (line.contains(" set "))
                {
                    String newLine = de.malban.util.UtilityString.replace(line, " set ", " = ");
                    inputLine = newLine;
                    line = newLine;
                    s = new ParseString(line);
                    
                }
                if (tlabel.contains("="))
                {
                    String newStart = de.malban.util.UtilityString.replace(tlabel, "=", " = ");
                    String newLine = de.malban.util.UtilityString.replace(line, tlabel, newStart);
                    inputLine = newLine;
                    line = newLine;
                    s = new ParseString(line);
                }
                s.setPosition(0);
            }
            
            // comment completeLine
            if (commentRecognizer != null &&  commentRecognizer.recognizes(s) ) 
            { 
                fullLineComment = line.trim().substring(1).trim();
                return; 
            }
            if (commentRecognizer != null  ) 
            { 
                endOfLineComment = commentRecognizer.removeEndOfLineComment(s);
                
            }

            // label?
            s.setPosition(0);
            label = s.nextWord();
            if (label.length() == 0) 
            { 
                label = null; 
            }

            // malban
            if (label != null)
            {
                if (label.endsWith(":")) label = label.substring(0, label.length()-1);
            }
            s.skipSpaces();
            if (s.length() == 0 && label != null) 
            {
                // a label on a line by itself means "label equ *"
                op = "equ";
                rest = "*";
            } 
            else 
            {
                op = s.nextWord();
                
                
                
                rest = s.trim(); // arg + comment
            }
            parsedOK = true;
            next = null;
	}

	public SourceLine( SourceLine p0 ) 
        {
            fileName      = p0.fileName;
            lineNumber    = p0.lineNumber;
            label         = p0.label;
            op            = p0.op;
            rest          = p0.rest;
            inputLine     = p0.inputLine;
            endOfLineComment= p0.endOfLineComment;
            fullLineComment= p0.fullLineComment;
            
            errorMessages = new Vector();
            macro         = p0.macro;
            parsedOK      = p0.parsedOK;
            instr         = null;
            if (parsedOK && p0.instr != null) 
            {
                instr = Instruction.create( p0.instr.getControl(), p0.instr.getSource() );
            }
            next          = null;
            macroDepth    = 0;
            hidden = false;
	}

	public void setInstruction( Instruction i ) { instr = i; }
	public Instruction getInstruction() { return instr; }
	public boolean parsed() { return parsedOK; }

	public void setMacro( Macro m ) { macro = m; }
	public Macro getMacro() { return macro; }

	public void setLabel( String s ) { label = s; }
	public String getLabel() { return label; }

	public void setOp( String s ) { op = s; }
	public String getOp() { return op; }

	public void setRest( String s ) { rest = s; }
	public String getRest() { return rest; }

	public void setInputLine( String s ) { inputLine = s; }
	public String getInputLine() { return inputLine; }

	public void setFilename( String s ) { 
            fileName = s; }
	public String getFilename() { return fileName; }

	public void setLineNumber( int i ) { lineNumber = i; }
	public int getLineNumber() { return lineNumber; }

	public void setNext( SourceLine p ) { next = p; }
	public SourceLine getNext() { return next; }

	public void setMacroDepth( int i ) { macroDepth = i; }
	public int getMacroDepth() { return macroDepth; }

	public void setHidden( boolean h ) { hidden = h; }
	public boolean getHidden() { return hidden; }

	public String toString() {
		return (label!=null? label :"") + " " + op + " " + rest;
	}

	public void addErrorMessage( String m ) {
		if (errorMessages == null) { errorMessages = new Vector(); }
		errorMessages.addElement( m );
	}
	public void addWarningMessage( String m ) {
		if (warningMessages == null) { warningMessages = new Vector(); }
		warningMessages.addElement( m );
	}
	public void addOptimizeMessage( String m ) {
		if (optimizeMessages == null) { optimizeMessages = new Vector(); }
		optimizeMessages.addElement( m );
	}

	public void eraseErrorMessages() {
		if (errorMessages != null) {
			errorMessages.removeAllElements();
		}
	}
	public void eraseWarningMessages() {
		if (warningMessages != null) {
			warningMessages.removeAllElements();
		}
	}
	public void eraseOptimizeMessages() {
		if (optimizeMessages != null) {
			optimizeMessages.removeAllElements();
		}
	}

}

