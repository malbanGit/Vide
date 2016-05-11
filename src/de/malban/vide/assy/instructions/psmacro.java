package de.malban.vide.assy.instructions;

import de.malban.vide.assy.exceptions.ParseException;





public class psmacro
  extends PseudoOp
{
  String name;
  
  public boolean isBeginMacro() { return true; }
  
  public String macroName() throws ParseException { this.name = this.source.label;
    if (this.name == null) throw new ParseException("needs a label");
    return this.name;
  }
  
  public boolean definesLabel() { return true; }
}
