/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.script;

import bsh.Interpreter;

/**
 *
 * @author Malban
 */
public interface Scriptable {
    public String getScriptPoolBaseName();
    public void setScriptVars(Interpreter i)throws bsh.EvalError;

}
