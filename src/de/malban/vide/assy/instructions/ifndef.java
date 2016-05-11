package de.malban.vide.assy.instructions;



public class ifndef
  extends ifdef
{
  public boolean getCondition()
  {
    return !this.condition;
  }
}
