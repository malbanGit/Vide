package de.malban.vide.assy.instructions;

import de.malban.vide.assy.exceptions.ParseException;



public class data extends PseudoOp
{
    int value;

    public boolean parse(String paramString) throws ParseException
    {
        setLength(0);
        control.switchSegment(control.SEGMENT_DATA);
        setLength(control.getGlobalAddress() - this.address);
        return true;
    }
}
