/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.assy;

import de.malban.vide.assy.instructions.struct;

/**
 *
 * @author salchr
 */
public class Struct {
    struct s=null;
    int startValue;
    int currentPosition;
    int lineNumber;
    public Struct(struct s)
    {
        this.s = s;
        startValue = s.getStartPosition();
        currentPosition = startValue;
    }
    public void endStruct()
    {
        s.setSymbolValue(currentPosition);
        s.defineIt();
    }
}
