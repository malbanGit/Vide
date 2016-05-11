/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.assy;

import java.util.Vector;

/**
 *
 * @author malban
 */
    // A line's context is the stack of enclosing macro definitions/ifdefs,
    // the linked list of lines of which it is an element, and a reference
    // to the outermost enclosing macro definition (if any).
    public class LineContext 
    {
        SourceLine first,last,current; // linked list of lines
        Macro macroDef; // non-null iff in macro a definition
        public static int directRegister = -1; // -1 undefined
    
        Struct currentStruct;
        public void setStruct(Struct s)
        {
            currentStruct = s;
        }
        
        Vector /* of Conditional */ conditionalStack;
        Conditional top;   // cached top element on conditionalStack
        boolean condition; // cached top.getState()

        public LineContext( SourceLine pline ) 
        {
                first = last = current = pline;
                macroDef = null;
                Struct currentStruct = null;

                conditionalStack = new Vector();

                // To simplify the coding, we are always in a
                // Conditional of some sort - outer/if/macro
                top = new Conditional(); // outer
                conditionalStack.addElement(top);
                condition = top.getState(); // ie: true
                // if (!condition) { // sanity check
                // 	throw new AsmjDeath("Asmj bug: outer false!");
                // }
        }

        public void addLine( SourceLine pline ) {
                pline.setNext( current.getNext() );
                current.setNext( pline );
                if (last == current) { last = pline; }
                current = pline;
        }

        // A conditional's state may change when, eg, elseif is parsed
        public void refreshState() { condition = top.getState(); }

        public Conditional getTopConditional() {
                return top;
        }

        public Conditional popContext() {
                int nc = conditionalStack.size();	
                if (nc <= 1) {
                        throw new AsmjDeath("Asmj bug: empty stack");
                }
                conditionalStack.removeElementAt(nc-1);
                top = (Conditional)conditionalStack.elementAt(nc-2);
                
                
                
//                System.out.println("WHY ist that encclosing? that should be STATE?");
                // Malban changed: condition = top.getEnclosingState();
                condition = top.getState();
                return top;
        }
        private Conditional pushContext( Conditional c ) 
        {
            top = c;
            condition = top.getState();
            conditionalStack.addElement(top);
            return top;
        }

        public boolean processInstructions() 
        { 
            return condition; 
        }

        public Conditional beginMacro() 
        {
            return pushContext( new Conditional( current.getMacroDepth(), condition ) );
        }
        public boolean assertMacro() 
        {
            if (!top.isMacro()) 
            {
                    Asmj.error(current,"No preceding 'macro'");
                    return false;
            }
            return true;
        }

        public Conditional beginIf( boolean test ) 
        {
            return pushContext(
                    new Conditional(
                            current.getMacroDepth(), condition, test
                    )
            );
        }
        public boolean assertIf() 
        {
            if (!top.isIf()) {
                    Asmj.error(current,"No preceding 'if'");
                    return false;
            }
            return true;
        }
        public boolean assertPastElse( boolean past ) {
                if (top.pastElse() != past) {
                        String verb = past? "precede" :"follow";
                        Asmj.error(current,"Cannot "+verb+" 'else'");
                        return false;
                }
                return true;
        }

        // convenience method to prettify listing output of macros
        public void hideInMacro( SourceLine s ) {
                if (s.getMacroDepth() > 0) { s.setHidden(true); }
        }

        public boolean assertEndOfContext() {
                if (conditionalStack.size() == 1) {
                        return true;
                }
                if (top.isIf()) {
                        Asmj.error(last,"unterminated conditional");
                        return false;
                } else if (top.isMacro()) {
                        Asmj.error(last,"unterminated macro");
                        return false;
                } else {
                        throw new AsmjDeath("Asmj bug: "
                                +"unrecognized Conditional");
                }
        }

        public int getDepth() { return conditionalStack.size(); }
    }