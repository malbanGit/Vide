package de.malban.vide.assy.instructions;

import de.malban.vide.assy.exceptions.ParseException;
import de.malban.vide.assy.ParseString;
import java.util.Vector;






public class ifeq
  extends PseudoOp
{
  boolean condition = false;
  
  public boolean parse(String paramString) throws ParseException {
    Vector localVector = ParseString.parseArgs(paramString);
    if (localVector.size() != 2)
    {
      throw new ParseException("need two arguments");
    }
    // TODO
    // for simplicity for now remove paraenthies
    
    
    
    String str1 = (String)localVector.elementAt(0);
    String str2 = (String)localVector.elementAt(1);
    str1 = de.malban.util.UtilityString.replace(str1, "(", "");
    str1 = de.malban.util.UtilityString.replace(str1, ")", "");
    str2 = de.malban.util.UtilityString.replace(str2, "(", "");
    str2 = de.malban.util.UtilityString.replace(str2, ")", "");

    this.condition = str1.equals(str2);
    

    return true;
  }
  
  public boolean isIf() { return true; }
  public boolean getCondition() { return this.condition; }
}
