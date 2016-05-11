// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy.arguments;

import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;


public abstract class Argument 
{
    protected static void parseEndOfExpression( ParseString s ) throws ParseException
    {
        if ( ! s.endOfExpression() ) 
        {
            throw new ParseException("illegal trailing characters");
        }
    }

}

