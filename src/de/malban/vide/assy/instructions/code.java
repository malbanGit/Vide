package de.malban.vide.assy.instructions;

import de.malban.vide.assy.Asmj;
import de.malban.vide.assy.exceptions.ParseException;



public class code extends PseudoOp
{
    int value;

    public boolean parse(String paramString) throws ParseException
    {
        control.switchSegment(Asmj.SEGMENT_CODE);
        setLength(control.getGlobalAddress() - this.address);
        return true;
    }
}
