package de.malban.vide.assy.instructions;

import de.malban.vide.VideConfig;
import de.malban.vide.assy.Asmj;
import static de.malban.vide.assy.Asmj.localOpt;
import de.malban.vide.assy.exceptions.ParseException;



public class opt extends PseudoOp
{
    int value;

    public boolean parse(String paramString) throws ParseException
    {
        setLength(0);
        localOpt = true;
        return true;
    }
}
