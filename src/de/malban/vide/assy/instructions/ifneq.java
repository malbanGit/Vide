package de.malban.vide.assy.instructions;



public class ifneq
  extends ifeq
{
  public boolean getCondition()
  {
    return !this.condition;
  }
}
