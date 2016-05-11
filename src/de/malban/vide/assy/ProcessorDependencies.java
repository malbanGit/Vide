// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;

import de.malban.vide.assy.expressions.ExpressionNumberMotorola;
import de.malban.vide.assy.instructions.InstructionSet;
import de.malban.vide.assy.expressions.ExpressionNumber;
import java.util.Hashtable;


public class ProcessorDependencies 
{
    public Hashtable instructionSet;
    public ExpressionNumber numberParser;
    public Comment commentRecognizer;
    public String name;
    public ProcessorDependencies() 
    {
        name = "6809";
        instructionSet = new InstructionSet();
        numberParser = new ExpressionNumberMotorola();
        commentRecognizer = new Comment();
    }
    public void sanityCheck() 
    {
        if (instructionSet == null) 
        {
            throw new AsmjDeath( "Asmj bug - missing instructionSet!");
        }
    }
}

