package de.malban.vide.assy.instructions;


import de.malban.vide.assy.expressions.Expression;
import de.malban.vide.assy.expressions.ExpressionString;
import de.malban.vide.assy.exceptions.ParseException;
import java.io.File;





public class include
  extends PseudoOp
{
  String filename;
  
  public boolean isInclude() { return true; }
  
  public String includeFilename() throws ParseException { Expression localExpression = ExpressionString.parse(this.source.rest, null, true);
  this.filename = ((ExpressionString)localExpression).getString();
    return this.filename;
  }
}
