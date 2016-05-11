/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.dissy;

import java.util.HashMap;

/**
 *
 * @author salchr
 */
public class GenFlexData extends DASMStatics 
{
    
    public GenFlexData(boolean genFlex)
    {
        if (genFlex)
        {
            genFlexData();
        }
        if (!genFlex)
        {
            genJavaTokenData();
        }
        genFlexDataAlt();
        
        
    }
    void genFlexData()
    {
        HashMap<String, String> singleOpcodes = new HashMap<String, String>();
        for (int i=0; i<pgpointers.length; i++)
        {
            for (int j = 0; j < pgpointers[i].length; j++)
            {
                singleOpcodes. put(pgpointers[i][j].name, pgpointers[i][j].name);
            }
        }
        for (String op :  singleOpcodes.values())
        {
            System.out.println("<YYINITIAL> \""+op.toUpperCase()+"\" {");
            System.out.println("    lastToken = M6809Token.RESERVED_WORD_"+op.toUpperCase()+";");
            System.out.println("    String text = yytext();");
            System.out.println("    JavaToken t = (new JavaToken(lastToken,text,yyline,yychar,yychar+text.length(),nextState));");
            System.out.println("    return (t);");
            System.out.println("}");
        }
    }
    void genJavaTokenData()
    {
        int wordIDStart = 0x100;
        HashMap<String, String> singleOpcodes = new HashMap<String, String>();
        for (int i=0; i<pgpointers.length; i++)
        {
            for (int j = 0; j < pgpointers[i].length; j++)
            {
                singleOpcodes. put(pgpointers[i][j].name, pgpointers[i][j].name);
            }
        }
        for (String op :  singleOpcodes.values())
        {
            System.out.println("public final static int  M6809Token.RESERVED_WORD_"+op.toUpperCase()+" = 0x"+String.format("%04X", wordIDStart++)+";");
        }
    }
    void genFlexDataAlt()
    {
        System.out.println("keyword=(");
        boolean first = true;
        HashMap<String, String> singleOpcodes = new HashMap<String, String>();
        int count = 0;
        for (int i=0; i<pgpointers.length; i++)
        {
            for (int j = 0; j < pgpointers[i].length; j++)
            {
                singleOpcodes. put(pgpointers[i][j].name, pgpointers[i][j].name);
            }
        }

        
        for (String op :  singleOpcodes.values())
        {
            if (!first)
            {
                System.out.print("|");
            }
            System.out.print("\""+op.toUpperCase()+"\"");
            count++;
            if (count >= 10)
            {
                count = 0;
                System.out.println("");
            }
            first = false;
        }
        
        System.out.println(")");
    }
}
