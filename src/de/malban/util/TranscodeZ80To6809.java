/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util;

import java.io.File;
import java.util.ArrayList;
import java.util.Vector;

/**
 *
 * @author salchr
 */
public class TranscodeZ80To6809 {
    
    public static boolean doTranscode(String in, String out)
    {
        Vector<String> sLines =  de.malban.util.UtilityString.readTextFileToString(new File(in));
        ArrayList<String> outLines = new ArrayList<String>();

        for (int i=0; i< sLines.size(); i++)
        {
            String orgLine = sLines.elementAt(i);
            Z80ASMLine z80 = new Z80ASMLine(orgLine);
            outLines.add(transcodeLine(z80));
        }        
        
        StringBuilder outString = new StringBuilder();
        for (String s: outLines) outString.append(s).append("\n");
        de.malban.util.UtilityString.writeToTextFile(outString.toString(), new File(out));
        return true;
    }
    
    static String transcodeLine(Z80ASMLine z80)
    {
        String ret = "";
        
        if (z80.mnenomic.equals("nop")) ret = "nop";
        if (z80.mnenomic.equals("im")) ret = "Interrup Mode Handler" + z80.operandAll;
        if (z80.mnenomic.equals("halt")) ret = "sync";
        if (z80.mnenomic.equals("neg")) ret = "nega";
        
        if (z80.mnenomic.equals("ld")) ret = handleLD(z80);
        
        /*
            // DJNZ = Decreases B and jumps to a label if not zero
            if ((strncmp(z80, "DJNZ" ,4) == 0)) {
                strcpy(m6809,"DECB\n");
                strcat(m6809, "        LBNE    ");
                point = getsingle(line, first);
                strcat(m6809,first);
                strcat(m6809,"                            ");
            }
            //JP = JMP
            if ((strncmp(z80, "JP  " ,4) == 0)) {
                strncpy(temp, line+ORG_DUMP_START, 2);
                temp[2] = '\0';
                if ((strncmp(temp, "C3" ,2) == 0)) {
                    strcpy(m6809, "LBRA    ");
                    point = getsingle(line, first);
                    strcat(m6809,first);
                }
                else {
                    //get getparts
                    getparts(line, first, second);
                    if (strlen(first) == 2) {
                        if ((strncmp(first, "NZ" ,2) == 0)) {
                            strcpy(m6809, "LBNE    ");
                        }
                        if ((strncmp(first, "NC" ,2) == 0)) {
                            strcpy(m6809, "LBCC    ");
                        }
                    }
                    if ((strncmp(first, "C" ,1) == 0)) {
                        strcpy(m6809, "LBCS    ");
                    }
                    if ((strncmp(first, "Z" ,1) == 0)) {
                        strcpy(m6809, "LBEQ    ");
                    }
                    if ((strncmp(first, "M" ,1) == 0)) {
                        strcpy(m6809, "LBMI    ");
                    }
                    strcat(m6809,second);
                    if ((strncmp(m6809, "UNKNOWN" ,7) == 0)) {
                        strcpy(m6809, "JMP     ,");
                        point = getsingle(line, first);
                        change(first);
                        strcat(m6809,first);
                    }
                }
            }
            //JR = Relative jump (BRA)
            if ((strncmp(z80, "JR  " ,4) == 0)) {
                strncpy(temp, line+ORG_DUMP_START, 2);
                temp[2] = '\0';
                if ((strncmp(temp, "18" ,2) == 0)) {
                    strcpy(m6809, "LBRA    ");
                    point = getsingle(line, first);
                    strcat(m6809,first);
                }
                else {
                    //get getparts
                    getparts(line, first, second);
                    if (strlen(first) == 2) {
                        if ((strncmp(first, "NZ" ,2) == 0)) {
                            strcpy(m6809, "LBNE    ");
                        }
                        if ((strncmp(first, "NC" ,2) == 0)) {
                            strcpy(m6809, "LBCC    ");
                        }
                    }
                    if ((strncmp(first, "C" ,1) == 0)) {
                        strcpy(m6809, "LBCS    ");
                    }
                    if ((strncmp(first, "Z" ,1) == 0)) {
                        strcpy(m6809, "LBEQ    ");
                    }
                    if ((strncmp(first, "M" ,1) == 0)) {
                        strcpy(m6809, "LBMI    ");
                    }
                    strcat(m6809,second);
                    if ((strncmp(m6809, "UNKNOWN" ,7) == 0)) {
                        strcpy(m6809, "JMP     ,");
                    }
                }
            }
            //DEC = DEC
            if ((strncmp(z80, "DEC " ,4) == 0)) {
                // Get value
                point = getsingle(line, first);
                // 0 - register
                // 2 - memory location - $1e00
                // 3 - points to memory location [$1e00]
                if ((point == 0) || (point == 2) || (point == 3)) {
                    strcpy(temp, "DEC     ");
                    if (strlen(first) < 3) {
                        strcat(temp,"");
                    }
                    change(first);
                    if ((strncmp(first, "A" ,1) == 0) || (strncmp(first, "B" ,1) == 0)) {
                        strcpy(m6809, "DEC");
                        strcat(m6809,first);
                        strcat(m6809,"    ");
                    }
                    else {
                    strcat(temp, first);
                    strcpy(m6809, temp);
                    }
                }
                // 1 - points to register mem location [register]
                if (point == 1) {
                    strcpy(temp, "DEC      ");
                    if (strlen(first) < 3) {
                        strcat(temp,",");
                    }
                    change(first);
                    strcat(temp, first);
                    strcat(temp, " ");
                    strcpy(m6809, temp);
                }
                if ((strncmp(m6809, "DEC     X" ,9) == 0)) {
                    strcpy(m6809, "LEAX    -1,X");
                }
                if ((strncmp(m6809, "DEC     Y" ,9) == 0)) {
                    strcpy(m6809, "LEAY    -1,Y");
                }
            }
            //INC = INC
            if ((strncmp(z80, "INC " ,4) == 0)) {
                // Get value
                point = getsingle(line, first);
                // 0 - register
                // 2 - memory location - $1e00
                // 3 - points to memory location [$1e00]
                if ((point == 0) || (point == 2) || (point == 3)) {
                    strcpy(temp,"INC     ");
                    if (strlen(first) < 3) {
                        strcat(temp,"");
                    }
                    change(first);
                    if ((strncmp(first, "A" ,1) == 0) || (strncmp(first, "B" ,1) == 0)) {
                        strcpy(m6809, "INC");
                        strcat(m6809,first);
                        strcat(m6809,"    ");
                    }
                    else {
                        strcat(temp, first);
                        strcpy(m6809, temp);
                    }
                }
                // 1 - points to register mem location [register]
                if (point == 1) {
                    strcpy(temp, "INC      ");
                    if (strlen(first) < 3) {
                        strcat(temp,",");
                    }
                    change(first);
                    strcat(temp, first);
                    strcat(temp, " ");
                    strcpy(m6809, temp);
                }
                if ((strncmp(m6809, "INC     X" ,9) == 0)) {
                    strcpy(m6809, "LEAX    1,X");
                }
                if ((strncmp(m6809, "INC     Y" ,9) == 0)) {
                    strcpy(m6809, "LEAY    1,Y");
                }
            }
            //RAR = Rotate Right, bit 0 is Copied to Carry old Carry bit to bit 7
            if ((strncmp(z80, "RRA " ,4) == 0)) {
                //get getparts
//                getparts(line, first, second); ; ERROR mot commented
                strcpy(m6809,"RORA");
            }
            //RAL = Rotate Left, bit 7 is Copied to Carry old Carry bit to bit 0
            if ((strncmp(z80, "RLA " ,4) == 0)) {
                //get getparts
//                getparts(line, first, second); ; ERROR mot commented
                strcpy(m6809,"ROLA");
            }
            //ADD = ADD
            if ((strncmp(z80, "ADD " ,4) == 0)) {
                point = 0;
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"ADD     ");
                change(first);
                strcat(m6809,first);
                strcat(m6809,"=");
                strcat(m6809,first);
                strcat(m6809,"+");
                if (second[0] == '(') {
//                    point = 1;
                    strncpy(temp, second+1, strlen(second)-2);
                    temp[strlen(second)-2] = '\0';
                    strcpy(second, temp);
                }
                if (point == 1) {
                    strcpy(temp, "[");
                    change(second);
                    strcat(temp, second);
                    strcat(temp, "]");
                    strcpy(second, temp);
                }
                else {
                    change(second);
                    strcat(m6809,second);
                }
                if ((strncmp(m6809, "ADD     A=A+" ,12) == 0)) {
                    strcpy(m6809, "ADDA    ,");
                    change(second);
                    strcat(m6809,second);
                    if (second[0] == '$') {
                        strcpy(m6809, "ADDA    #");
                        strcat(m6809,second);
                    }
                    if ((strncmp(m6809, "ADDA    ,A" ,10) == 0))
                        strcpy(m6809,"ASLA    ");
                }
            }
            //AND = AND
            if ((strncmp(z80, "AND " ,4) == 0)) {
                // Get value
                point = getsingle(line, first);
                strncpy(temp, line+6, 2);
                temp[2] = '\0';
                if (strcmp(temp,"E6") == 0) {
                    point = 2;
                    strncpy(temp, line+8, 2);
                    temp[2] = '\0';
                    strcpy(first,"$");
                    strcat(first,temp);
                }
                // 0 - register
                // 3 - points to memory location [$1e00]
                if ((point == 0) ||  (point == 3)) {
                    strcpy(m6809,"ANDA    ");
                    if (strncmp(first, "A", 1) == 0) {
                        strcpy(m6809,"TSTA");
                    }
                    else {
                        strcat(m6809,first);
                    }
                }
                // 2 - value - $A00
                if (point == 2) {
                    strcpy(m6809,"ANDA    #");
                    strcat(m6809,first);
                }
                // 1 - points to register mem location [register]
                if (point == 1) {
                    strcpy(m6809,"ANDA     ,");
                    change(first);
                    strcat(m6809,first);
                }
            }
            //CP = subtraction from A but doesn't modify A
            //Work out similar function with CMPA - Compare A 6809
            if ((strncmp(z80, "CP  " ,4) == 0)) {
                // Get value
                point = getsingle(line, first);
                // 0 - register
                // 3 - points to memory location [$1e00]
                if ((point == 0) || (point == 3)) {
                    strncpy(temp, line+6, 2);
                    temp[2] = '\0';
                    if ((strncmp(temp, "FE" ,2) == 0)) {
                        strncpy(temp, line+8, 2);
                        temp[2] = '\0';
                        strcpy(m6809,"CMPA    #$");
                        strcat(m6809, temp);
                    }
                    else {
                    strcpy(m6809,"CMPA    ");
                    strcat(m6809,first);
                    strcat(m6809,"_Temp");
                    }
                }
                // 2 - value - $A00
                if (point == 2) {
                    strcpy(m6809,"CMPA    #");
                    strcat(m6809,first);
                }
                // 1 - points to register mem location register
                if (point == 1) {
                    strcpy(m6809,"CMPA     ,");
                    change(first);
                    strcat(m6809,first);
                }
            }
            //CPI = This is a cp (hl); inc hl; dec bc combined in one instruction. The carry is preserved
            //      N is set and all the other flags are affected as defined.
            //      P/V denotes the overflowing of BC, while the Z flag is set if A=(HL) at the time of the comparison.
            if ((strncmp(z80, "CPI " ,4) == 0)) {
                flag = 1;    // Don't add space in the front of this section
                strcpy(m6809,"        DECB\n");
                strcat(m6809,"        CMPA     ,X+                                ");
            }
            //CPIR = CPI repeated until either BC becomes zero or A is equal to (HL).
            if ((strncmp(z80, "CPIR" ,4) == 0)) {
                flag = 1;    // Don't add space in the front of this section
                strcpy(m6809,"!       CMPA     ,X+\n");
                strcat(m6809,"        BEQ      >\n");
                strcat(m6809,"        DECB\n");
                strcat(m6809,"        BNE      <\n");
                strcat(m6809,"!                          *** If A = (X) then X should not be incremented check the code to see if X is used next.\n");
                strcat(m6809,"                           *** If X value is used then change above to CMPA  ,X next line BEQ  > next line LEAX  +1,X\n");
                strcat(m6809,"                                                    ");
            }
            //CPD = This is a cp (hl); dec hl; dec bc combined in one instruction. The carry is preserved
            //      N is set and all the other flags are affected as defined.
            //      P/V denotes the overflowing of BC, while the Z flag is set if A=(HL) at the time of the comparison.
            if ((strncmp(z80, "CPD " ,4) == 0)) {
                flag = 1;    // Don't add space in the front of this section
                strcpy(m6809,"        DECB\n");
                strcat(m6809,"        CMPA     ,X\n");
                strcat(m6809,"        PSHS     CC\n");
                strcat(m6809,"        LEAX     -1,X\n");
                strcat(m6809,"        PULS     CC                                 ");
            }
            //CPDR = CPD repeated until either BC becomes zero or A is equal to (HL).
            if ((strncmp(z80, "CPDR" ,4) == 0)) {
                flag = 1;    // Don't add space in the front of this section
                strcpy(m6809,"!       CMPA     ,X\n");
                strcat(m6809,"        BEQ      >\n");
                strcat(m6809,"        LEAX     -1,X\n");
                strcat(m6809,"        DECB\n");
                strcat(m6809,"        BNE      <\n");
                strcat(m6809,"!                        \n");
                strcat(m6809,"                                                    ");
            }
            //SBI = Subtract with borrow A <- A - byte - Carry
            if ((strncmp(z80, "SBI " ,4) == 0)) {
                point = 0;
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"SBCA     #");
                strcat(m6809,second);
            }
            //SUI = Subtract Immediate from accumulator
            if ((strncmp(z80, "SUI " ,4) == 0)) {
                point = 0;
                //get getparts
                point = getsingle(line, first);
                strcpy(m6809,"SUBA    #");
                strcat(m6809,first);
            }
            //SUB  A = subtract A from A - same as 6809 CLRA
            if ((strncmp(z80, "SUB     A" ,9) == 0)) {
                strcpy(m6809, "CLRA");
            }
            //SUB = Sub stands for subtract but only takes one input. It subtracts the input from the accumulator and writes back to it.
            if ((strncmp(z80, "SUB " ,4) == 0)) {
                point = 0;
                //get getparts
                point = getsingle(line, first);
                strncpy(temp, line+6, 2);
                temp[2] = '\0';
                if (strcmp(temp,"D6") == 0) {
                    point = 2;
                    strncpy(temp, line+8, 2);
                    temp[2] = '\0';
                    strcpy(first,"#$");
                    strcat(first,temp);
                }
                else {
                    change(first);
                    strcpy(temp,",");
                    strcat(temp,first);
                    strcpy(first,temp);
                }
                strcpy(m6809,"SUBA    ");
                strcat(m6809,first);
            }
            //SCF = Set Carry Flag
            if ((strncmp(z80, "SCF " ,4) == 0)) {
                strcpy(m6809,"ORCC     #$01");
            }
            //CPL = Compliment the Accumulator
            if ((strncmp(z80, "CPL " ,4) == 0)) {
                strcpy(m6809,"COMA         ");
            }
            //XOR = XORS A with A or with Registor or memory
            if ((strncmp(z80, "XOR " ,4) == 0)) {
                strcpy(m6809, "EORA    ");
                // Get value
                point = getsingle(line, first);
                strcat(m6809,first);
                if ((strncmp(m6809, "EORA    A" ,9) == 0)) {
                    strcpy(m6809,"CLRA         ");
                }
                else {
                    strncpy(temp, line+6, 2);
                    temp[2] = '\0';
                    if (strcmp(temp,"EE") == 0) {
                        point = 2;
                        strncpy(temp, line+8, 2);
                        temp[2] = '\0';
                        strcpy(first,"#$");
                        strcat(first,temp);
                    }
                    else {
                        change(first);
                        strcpy(temp,",");
                        strcat(temp,first);
                        strcpy(first,temp);
                    }
                    strcpy(m6809,"EORA    ");
                    strcat(m6809,first);
                }
            }
            // di = Disable the interrupts
            if ((strncmp(z80, "DI  " ,4) == 0)) {
                strcpy(m6809,"ORCC    #$50");
            }
            // Instructions that need more lines of code to work correctly are below...
            //IN = Read value from hardware port into A
            if ((strncmp(z80, "IN  " ,4) == 0)) {
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"LDA     ");
                strncpy(z80, line+9, 2);
                z80[2] = '\0';
                strcat(m6809,"IO_");
                strcat(m6809,z80);
                strcat(m6809,"_");
                if (second[0] == '(') {
                    strncpy(temp, second+1, strlen(second)-2);
                    temp[strlen(second)-2] = '\0';
                    strcpy(second, temp);
                }
                strcat(m6809,second);
                // Let's see if it's new and if so add it to the bottom of the table
                found = 0;
                strncpy(temp, m6809+8, strlen(m6809)-8);
                temp[strlen(m6809)-8] = '\0';
                for (x = 0; x < count ; x++) {
                    if (strcmp(temp,in_out[x]) == 0) {
                        found = 1;
                        x = count;
                    }
                }
                if (found == 0) {
                    //               printf("Adding-%s\n",temp);
                    strcpy(in_out[count],temp);
                    count++;
                }
            }
            //OUT = Store value to hardware port from A
            if ((strncmp(z80, "OUT " ,4) == 0)) {
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"STA     ");
                strncpy(z80, line+9, 2);
                z80[2] = '\0';
                strcat(m6809,"IO_");
                strcat(m6809,z80);
                strcat(m6809,"_");
                if (first[0] == '(') {
                    strncpy(temp, first+1, strlen(first)-2);
                    temp[strlen(first)-2] = '\0';
                    strcpy(first, temp);
                }
                strcat(m6809,first);
                // Let's see if it's new and if so add it to the bottom of the table
                found = 0;
                strncpy(temp, m6809+8, strlen(m6809)-8);
                temp[strlen(m6809)-8] = '\0';
                for (x = 0; x < count ; x++) {
                    if (strcmp(temp,in_out[x]) == 0) {
                        found = 1;
                        x = count;
                    }
                }
                if (found == 0) {
                    //               printf("Adding-%s\n",temp);
                    strcpy(in_out[count],temp);
                    count++;
                }
            }
            //DAA = convert the A register into two BCD values 4 bits each
            if ((strncmp(z80, "DAA " ,4) == 0)) {
                strcpy(m6809, "DAA     ");
                strncpy(z80, line+ORG_OPERAND_START, 2);
                z80[2] = '\0';
                strcat(m6809,z80);
            }
            //CALL = LBSR
            if ((strncmp(z80, "CALL" ,4) == 0)) {
                strncpy(temp, line+6, 2);
                temp[2] = '\0';
                if ((strncmp(temp, "CD" ,2) == 0)) {
                    strcpy(m6809, "LBSR    ");
                    point = getsingle(line, first);
                    strcat(m6809,first);
                }
                else {
                    //get getparts
                    getparts(line, first, second);
                    if (strlen(first) == 2) {
                        if ((strncmp(first, "NZ" ,2) == 0)) {   // if Z = 0
                            x = (int)strtol(address, NULL, 16);
                            x = x + 3;
                            sprintf(temp, "%04X", x);
                            strcpy(other, "        BEQ     >");
//                            strcat(other,temp);
                            strcat(other,"                                   ;");
                            strcat(other,address);
                            strcat(other," -");
                            strcat(other,comment);
                            strcat(other,"\n");
                            strcpy(address,"****");
                            strcpy(comment," Added for 6809 worakaround");
                            strcpy(m6809, "LBSR    ");
                        }
                        if ((strncmp(first, "NC" ,2) == 0)) {   // if C = 0
                            x = (int)strtol(address, NULL, 16);
                            x = x + 3;
                            sprintf(temp, "%04X", x);
                            strcpy(other, "        BCS     >");
                            //                            strcat(other,temp);
                            strcat(other,"                                   ;");
                            strcat(other,address);
                            strcat(other," -");
                            strcat(other,comment);
                            strcat(other,"\n");
                            strcpy(address,"****");
                            strcpy(comment," Added for 6809 worakaround");
                            strcpy(m6809, "LBSR    ");
                        }
                    }
                    if ((strncmp(first, "C" ,1) == 0)) {   // if C = 1
                        x = (int)strtol(address, NULL, 16);
                        x = x + 3;
                        sprintf(temp, "%04X", x);
                        strcpy(other, "        BCC     >");
                        //                        strcat(other,temp);
                        strcat(other,"                                   ;");
                        strcat(other,address);
                        strcat(other," -");
                        strcat(other,comment);
                        strcat(other,"\n");
                        strcpy(address,"****");
                        strcpy(comment," Added for 6809 worakaround");
                        strcpy(m6809, "LBSR    ");
                    }
                    if ((strncmp(first, "Z" ,1) == 0)) {   // if Z = 1
                        x = (int)strtol(address, NULL, 16);
                        x = x + 3;
                        sprintf(temp, "%04X", x);
                        strcpy(other, "        BNE     >");
                        //                        strcat(other,temp);
                        strcat(other,"                                   ;");
                        strcat(other,address);
                        strcat(other," -");
                        strcat(other,comment);
                        strcat(other,"\n");
                        strcpy(address,"****");
                        strcpy(comment," Added for 6809 worakaround");
                        strcpy(m6809, "LBSR    ");
                    }
                    //                if ((strncmp(first, "M" ,1) == 0)) {   // if M = 1
                    //                    strcpy(m6809, "LBSR based on LBMI    ");
                    //                }
                    strcat(m6809,second);
                    strcat(m6809,"\n");
                    strcat(m6809,"!       ***     Jump here                           ");
                }
            }
            //PUSH = PSHS
            if ((strncmp(z80, "PUSH" ,4) == 0)) {
                strcpy(m6809, "PSHS    ");
                strncpy(z80, line+ORG_OPERAND_START, 2);
                z80[2] = '\0';
                change(z80);
                strcat(m6809,z80);
            }
            //POP = PULS
            if ((strncmp(z80, "POP " ,4) == 0)) {
                strcpy(m6809, "PULS    ");
                strncpy(z80, line+ORG_OPERAND_START, 2);
                z80[2] = '\0';
                change(z80);
                strcat(m6809,z80);
            }
            //EI = Enable Interrupts
            if ((strncmp(z80, "EI  " ,4) == 0)) {
                strcpy(m6809, "ANDCC    #$AF");
                strncpy(z80, line+ORG_OPERAND_START, 2);
                z80[2] = '\0';
                strcat(m6809,z80);
            }
            //RST = Jump to subroutines at lower RAM (this will need to be tweaked for each source code listing)
            if ((strncmp(z80, "RST " ,4) == 0)) {
                strcpy(m6809,"LBSR    ");
                // Get value
                point = getsingle(line, first);
                if (strcmp(first,"8") == 0)
                    strcat(m6809,"Memset");
                if (strcmp(first,"10h") == 0)
                    strcat(m6809,"LookupByteA");
                if (strcmp(first,"18h") == 0)
                    strcat(m6809,"LookupWordHL");
                if (strcmp(first,"20h") == 0)
                    strcat(m6809,"CallFunction");
                if (strcmp(first,"28h") == 0)
                    strcat(m6809,"InsertTask");
                if (strcmp(first,"30h") == 0)
                    strcat(m6809,"InsertIRQTask");
            }
            //RET = Return from subroutine or Return from Interrupt
            if ((strncmp(z80, "RET " ,4) == 0)) {
                strncpy(temp, line+6, 2);
                temp[2] = '\0';
                if ((strncmp(temp, "C9" ,2) == 0)) {
                    strcpy(m6809, "RTS");
                }
                else {
                    // Get value
                    point = getsingle(line, first);
                    if (strlen(first) == 2) {
                        if ((strncmp(first, "PE" ,2) == 0)) {
                            strcpy(m6809, "RTS - If PE is set    ");
                        }
                        if ((strncmp(first, "NZ" ,2) == 0)) {
                            strcpy(m6809, "BNE to RTS address  ");
                        }
                        if ((strncmp(first, "NC" ,2) == 0)) {
                            strcpy(m6809, "BCC to RTS address  ");
                        }
                    }
                    if ((strncmp(first, "C" ,1) == 0)) {
                        strcpy(m6809, "BCS to RTS address  ");
                    }
                    if ((strncmp(first, "M" ,1) == 0)) {
                        strcpy(m6809, "BMI to RTS address  ");
                    }
                    if ((strncmp(first, "Z" ,1) == 0)) {
                        strcpy(m6809, "BEQ to RTS address  ");
                    }
                }
            }
            //EX = Exchange registers or memory pointed to
            if ((strncmp(z80, "EX  " ,4) == 0)) {
                point = 0;
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"EXG     ");
                change(first);
                strcat(m6809,first);
                strcat(m6809,",");
                change(second);
                strcat(m6809,second);
            }
            //OR = ORA with operand
            if ((strncmp(z80, "OR  " ,4) == 0)) {
                // Get value
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    strcpy(m6809,"ORA   Register - need tweaking  ");
                    strcat(m6809,first);
                }
                // 2 - value - $A00
                if (point == 2) {
                    strcpy(m6809,"ORA     #");
                    strcat(m6809,first);
                }
                // 1 - points to register mem location [register]
                // 3 - points to memory location [$1e00]
                if (point == 1) {
                    strcpy(m6809,"ORA      ,");
                    change(first);
                    strcat(m6809,first);
                }
                if (point == 3) {
                    strcpy(m6809,"ORA      ");
                    strcat(m6809,first);
                }
            }
            //PCHL = Load Program Counter , TFR HL,PC
            if ((strncmp(z80, "PCHL" ,4) == 0)) {
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"TFR     HL,PC  transfer HL to Program counter - Fix");
                strcat(m6809,second);
            }
            //SET = Set the specified bit of register or memory
            if ((strncmp(z80, "SET " ,4) == 0)) {
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"PSHS    A\n");
                if (second[0] == '(') {
                    strncpy(temp, second+1, strlen(second)-2);
                    temp[strlen(second)-2] = '\0';
                    strcpy(second, temp);
                }
                change(second);
                strcat(m6809,"        LDA     ,");
                strcat(m6809,second);
                strcat(m6809,"\n        ORA   #$       * Set bit ");
                strcat(m6809,first);
                strcat(m6809,"\n        STA     ,");
                strcat(m6809,second);
                strcat(m6809,"\n        PULS     A                                  ");
            }
            //RES = Clear the specified bit of register or memory
            if ((strncmp(z80, "RES " ,4) == 0)) {
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"PSHS    A\n");
                if (second[0] == '(') {
                    strncpy(temp, second+1, strlen(second)-2);
                    temp[strlen(second)-2] = '\0';
                    strcpy(second, temp);
                }
                change(second);
                strcat(m6809,"        LDA     ,");
                strcat(m6809,second);
                strcat(m6809,"\n        ANDA   #$       * Clear bit ");
                strcat(m6809,first);
                strcat(m6809,"\n        STA     ,");
                strcat(m6809,second);
                strcat(m6809,"\n        PULS     A                                  ");
            }
            //BIT = Tests if the specified bit is set of a register or memory
            if ((strncmp(z80, "BIT " ,4) == 0)) {
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"Test bit ");
                strcat(m6809,first);
                strcat(m6809," of ");
                strcat(m6809,second);
                strcat(m6809," Use BITA or BITB");
            }
            //ADC = ADD two operands plus the carry flag store it back into first operand
            if ((strncmp(z80, "ADC " ,4) == 0)) {
                point = 0;
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"ADC     ");
                strcat(m6809,first);
                strcat(m6809,",");
                strcat(m6809,second);
                strcat(m6809," - Fix");
            }
            //SBC = Subtract two operands with the carry flag store it back into first operand
            if ((strncmp(z80, "SBC " ,4) == 0)) {
                point = 0;
                //get getparts
                getparts(line, first, second);
                strcpy(m6809,"SBC     ");
                strcat(m6809,first);
                strcat(m6809,",");
                strcat(m6809,second);
                strcat(m6809," - Fix");
            }
            //CCF  = Inverts the carry flag.
            if ((strncmp(z80, "CCF " ,4) == 0)) {
                strcpy(m6809,"BCS     >            * Jump if Carry Set\n");
                strcat(m6809,"        ORCC    #$01         * Set the Carry\n");
                strcat(m6809,"        BRA     L_CCF_Fix    * Jump ahead\n");
                strcat(m6809,"!       ANDCC   #$FE         * Clear the Carry\n");
                strcat(m6809,"L_CCF_Fix:                                          ");
            }
            //SRA = 0 Arithmatic Shift Right bit 0 to carry, bit 7 stays the same (keeps the sign neagtive or positive)
            if ((strncmp(z80, "SRA " ,4) == 0)) {
                //get getparts
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    if ((strncmp(first, "A" ,1) == 0) || (strncmp(first, "B" ,1) == 0)) {
                        if (strncmp(first, "A" ,1) == 0)
                            strcpy(m6809,"        ASRA                                        ");
                        if (strncmp(first, "B" ,1) == 0)
                            strcpy(m6809,"        ASRB                                        ");
                    }
                    else {
                        strcpy(m6809,"ASR         * Register may need tweaking ");
                        strncpy(z80, line+39, 2);
                        z80[2] = '\0';
                        change(z80);
                        strcat(m6809,z80);
                    }
                }
            }
            //SLA = 0 Arithmatic Shift Left bit 7 to carry, bit 0  gets a zero
            if ((strncmp(z80, "SLA " ,4) == 0)) {
                //get getparts
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    if ((strncmp(first, "A" ,1) == 0) || (strncmp(first, "B" ,1) == 0)) {
                        if (strncmp(first, "A" ,1) == 0)
                            strcpy(m6809,"        ASLA                                        ");
                        if (strncmp(first, "B" ,1) == 0)
                            strcpy(m6809,"        ASLB                                        ");
                    }
                    else {
                        strcpy(m6809,"ASL         * Register may need tweaking ");
                        strncpy(z80, line+39, 2);
                        z80[2] = '\0';
                        change(z80);
                        strcat(m6809,z80);
                    }
                }
            }
            //SRL = The bits are all shifted right, 0 is put into bit 7 with bit 0 put into the carry flag
            if ((strncmp(z80, "SRL " ,4) == 0)) {
                //get getparts
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    if ((strncmp(first, "A" ,1) == 0) || (strncmp(first, "B" ,1) == 0)) {
                        if (strncmp(first, "A" ,1) == 0)
                            strcpy(m6809,"        LSRA                                        "); // ERROR strcat
                        if (strncmp(first, "B" ,1) == 0)
                            strcpy(m6809,"        LSRB                                        ");
                    }
                    else {
                        strcpy(m6809,"        LSR   * Register may need tweaking  ");
                        strncpy(z80, line+39, 2);
                        z80[2] = '\0';
                        change(z80);
                        strcat(m6809,z80);
                        strcat(m6809,"      ");
                    }
                }
            }
            //RRCA = Rotate Right, Copy bit 0 to Carry, Copy bit 0 to bit 7
            if ((strncmp(z80, "RRCA" ,4) == 0)) {
                strcpy(m6809,"LSRA\n");
                strcat(m6809,"        BCC     >\n");
                strcat(m6809,"        ORA     #$80\n");
                strcat(m6809,"!                                                   ");
                }
            //RRC = Rotate Right, Copy bit 0 to Carry, Copy bit 0 to bit 7 and the carry
            if ((strncmp(z80, "RRC " ,4) == 0)) {
                // Get value
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    if (strncmp(first, "B" ,1) == 0) {
                        strcpy(m6809,"LSRB\n");
                        strcat(m6809,"        BCC     >\n");
                        strcat(m6809,"        ORB     #$80\n");
                        strcat(m6809,"!                                                   ");
                }
                    else {
                        strcpy(m6809,"LSR??\n");
                        strcat(m6809,"        BCC     >\n");
                        strcat(m6809,"        OR??    #$80\n");
                        strcat(m6809,"!                                                   ");
                        strncpy(z80, line+39, 2);
                        z80[2] = '\0';
                        change(z80);
                        strcat(m6809,z80);
                    }
                }
            }
            //RLCA = Rotate Left, Copy bit 7 to Carry, Copy bit 7 to bit 0
            if ((strncmp(z80, "RLCA" ,4) == 0)) {
                strcpy(m6809,"LSLA\n");
                strcat(m6809,"        BCC     >\n");
                strcat(m6809,"        ORA     #$01\n");
                strcat(m6809,"!                                                   ");
            }
            //RLC = Rotate Left, Copy bit 7 to Carry, Copy bit 7 to bit 0
            if ((strncmp(z80, "RLC " ,4) == 0)) {
                // Get value
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    if (strncmp(first, "B" ,1) == 0) {
                        strcpy(m6809,"LSLB\n");
                        strcat(m6809,"        BCC     >\n");
                        strcat(m6809,"        ORB     #$01\n");
                        strcat(m6809,"!                                                   ");
                    }
                    else {
                        strcpy(m6809,"LSL??\n");
                        strcat(m6809,"        BCC     >\n");
                        strcat(m6809,"        OR??     #$01\n");
                        strcat(m6809,"!                                                   ");
                        strncpy(z80, line+39, 2);
                        z80[2] = '\0';
                        change(z80);
                        strcat(m6809,z80);
                    }
                }
            }
            //RL  = 9-bit rotation to the left. the register's bits are shifted left. The carry value is put into 0th bit of the register,
            //      and the leaving 7th bit is put into the carry.
            if ((strncmp(z80, "RL  " ,4) == 0)) {
                //get getparts
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    if ((strncmp(first, "A" ,1) == 0) || (strncmp(first, "B" ,1) == 0)) {
                        if (strncmp(first, "A" ,1) == 0)
                            strcpy(m6809,"ROLA                                        ");
                        if (strncmp(first, "B" ,1) == 0)
                            strcpy(m6809,"ROLB                                        ");
                    }
                    else {
                        strcpy(m6809,"ROL * Register may need tweaking ");
                        strcat(m6809,first);
                    }
                }
                // 2 - value - $A00
                if (point == 2) {
                    strcpy(m6809,"ROL     #");
                    strcat(m6809,first);
                }
                // 1 - points to register mem location [register]
                // 3 - points to memory location [$1e00]
                if (point == 1) {
                    strcpy(m6809,"ROL     ,");
                    change(first);
                    strcat(m6809,first);
                }
                if (point == 3) {
                    strcpy(m6809,"ROL     ");
                    strcat(m6809,first);
                }
            }
            //RR = 9-bit rotation to the right. The carry is copied into bit 7, and the bit leaving on the right is copied into the carry.
            if ((strncmp(z80, "RR  " ,4) == 0)) {
                //get getparts
                point = getsingle(line, first);
                // 0 - register
                if (point == 0) {
                    if ((strncmp(first, "A" ,1) == 0) || (strncmp(first, "B" ,1) == 0)) {
                        if (strncmp(first, "A" ,1) == 0)
                            strcpy(m6809,"RORA                                        ");
                        if (strncmp(first, "B" ,1) == 0)
                            strcpy(m6809,"RORB                                        ");
                    }
                    else {
                        strcpy(m6809,"ROR * Register may need tweaking ");
                        strcat(m6809,first);
                    }
                }
                // 2 - value - $A00
                if (point == 2) {
                    strcpy(m6809,"ROR     #");
                    strcat(m6809,first);
                }
                // 1 - points to register mem location [register]
                // 3 - points to memory location [$1e00]
                if (point == 1) {
                    strcpy(m6809,"ROR     ,");
                    change(first);
                    strcat(m6809,first);
                }
                if (point == 3) {
                    strcpy(m6809,"ROR     ");
                    strcat(m6809,first);
                }
            }
            //LDI = Performs a "LD (DE),(HL)", then increments DE and HL, and decrements BC.
            if ((strncmp(z80, "LDI " ,4) == 0)) {
                flag = 1;    // Don't add space in the front of this section
                strcpy(m6809,"        LDA     ,X+\n");
                strcat(m6809,"        STA     ,Y+\n");
                strcat(m6809,"        LEAU    -1,U                                ");
            }
            //LDIR = A block copy in one instruction copy BC (U) bytes from HL(X) to DE(Y)
            if ((strncmp(z80, "LDIR" ,4) == 0)) {
                flag = 1;    // Don't add space in the front of this section
                strcpy(m6809,"        PSHS    D       *** Check U is an even #\n");
                strcat(m6809,"!       LDD     ,X++\n");
                strcat(m6809,"        STD     ,Y++\n");
                strcat(m6809,"        LEAU    -2,U\n");
                strcat(m6809,"        CMPU    #$0000\n");
                strcat(m6809,"        BNE     <\n");
                strcat(m6809,"        PULS    D                                   ");
            }
            //EXX = exchanges BC, DE, and HL with shadow registers with BC', DE', and HL'.
            if ((strncmp(z80, "EXX " ,4) == 0)) {
                flag = 1;    // Don't add space in the front of this section
                strcpy(m6809,"        PSHS    D\n");
                strcat(m6809,"        LDD     HS_Temp\n");
                strcat(m6809,"        STX     HS_Temp\n");
                strcat(m6809,"        STD     H_Temp\n");
                strcat(m6809,"        LDX     H_Temp\n");
                strcat(m6809,"        LDD     DS_Temp\n");
                strcat(m6809,"        STY     DS_Temp\n");
                strcat(m6809,"        STD     D_Temp\n");
                strcat(m6809,"        LDY     D_Temp\n");
                strcat(m6809,"        LDD     BS_Temp\n");
                strcat(m6809,"        STU     BS_Temp\n");
                strcat(m6809,"        STD     B_Temp\n");
                strcat(m6809,"        LDU     B_Temp\n");
                strcat(m6809,"        PULS    D                  *** Check this   ");
            }
            //DB = Insert Byte of Data - FCB data
            if ((strncmp(z80, "DB " ,3) == 0)) {
                strcpy(m6809,"FCB     ");
                strncpy(temp, line+34, strlen(line)-34);
                temp[strlen(line)-34] = '\0';
                strcpy(hxbyte,"");
                found = 0;
                for (y = 0 ; y < strlen(temp) ; y++) {
                    if (temp[y] == ';') {
                        pos = y;
                        found = 1;
                    }
                }
                if (found == 0)
                    pos = y;
                strcpy(temp2,"00");
                for (x = 0 ; x < pos ; x++) {
                    if (temp[x] != 'h') {
                        if (temp[x] == ',') {
                            strncpy(temp3, temp2+strlen(temp2)-2, 2);
                            temp3[2] = '\0';
                            strcpy(temp2,"$");
                            strcat(hxbyte,temp2);
                            strcat(hxbyte,temp3);
                            strcat(hxbyte,",");
                            strcpy(temp2,"00");
                        }
                        else {
                            if (temp[x] != ' ') {
                                strncpy(temp3,temp+x,1);
                                temp3[1] = '\0';
                                strcat(temp2,temp3);
                            }
                        }
                    }
                }
                strncpy(temp3, temp2+strlen(temp2)-2, 2);
                temp3[2] = '\0';
                strcpy(temp2,"$");
                strcat(hxbyte,temp2);
                strcat(hxbyte,temp3);
                count = 0;
                strcpy(temp2,"");
                for (y = 0 ; y < strlen(hxbyte) ; y++) {
                    if (hxbyte[y] == ',') {
                        count++;
                        if (count == 4) {
                            count = 0;
                            y++;
                            strcat(temp2,"\n        FCB     ");
                        }
                    }
                    strncpy(temp3,hxbyte+y,1);
                    temp3[1] = '\0';
                    strcat(temp2,temp3);
                }
                strcat(temp2,"               ");
                if (count == 0)
                    strcat(temp2,"                  ");
                if (count == 1)
                    strcat(temp2,"              ");
                if (count == 2)
                    strcat(temp2,"          ");
                if (count == 3)
                    strcat(temp2,"       ");
                strcat(m6809,temp2);
            }
            //DW = Insert Word of Data - FDB data two bytes of data, when Z80 assemblers assemble the code the bytes
            //     are swapped so it's store as LSB,MSB in RAM
            if ((strncmp(z80, "DW " ,3) == 0)) {
                strcpy(m6809,"FDB     ");
                strncpy(temp, line+34, strlen(line)-34);
                temp[strlen(line)-34] = '\0';
                strcpy(hxbyte,"");
                found = 0;
                for (y = 0 ; y < strlen(temp) ; y++) {
                    if (temp[y] == ';') {
                        pos = y;
                        found = 1;
                    }
                }
                if (found == 0)
                    pos = y;
                strcpy(temp2,"0000");
                for (x = 0 ; x < pos ; x++) {
                    if (temp[x] != 'h') {
                        if (temp[x] == ',') {
                            strncpy(temp3, temp2+strlen(temp2)-4, 4);
                            temp3[4] = '\0';
                            strcpy(temp2,"$");
                            strcat(hxbyte,temp2);
                            strcat(hxbyte,temp3);
                            strcat(hxbyte,",");
                            strcpy(temp2,"0000");
                        }
                        else {
                            if (temp[x] != ' ') {
                                strncpy(temp3,temp+x,1);
                                temp3[1] = '\0';
                                strcat(temp2,temp3);
                            }
                        }
                    }
                }
                strncpy(temp3, temp2+strlen(temp2)-4, 2);
                temp3[2] = '\0';
                strncpy(temp2, temp2+strlen(temp2)-2, 2);
                temp2[2] = '\0';
                strcpy(temp,"$");
                strcat(temp,temp2);
                strcat(hxbyte,temp);
                strcat(hxbyte,temp3);
//                strcat(hxbyte,"                          \n                                                  ");
                strcat(m6809,hxbyte);
            }
            
            
            //DL = Insert Double word of data all four bytes are to be reversed - convert to FCB data
            if ((strncmp(z80, "DL " ,3) == 0)) {
                strcpy(m6809,"FQB     ");
                strncpy(temp, line+34, 9);
                temp[9] = '\0';
                x = 8;
                if (temp[8] == 'h') {
                    x = 7;
                }
                strcpy(hxbyte,"");
                x = x - 1;
                strcat(hxbyte,"$");
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                x++;
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                strcat(m6809,hxbyte);
                
//                strcpy(hxbyte,",");
                strcpy(hxbyte,"");
                x = x - 3;
//                strcat(hxbyte,"$");
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                x++;
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                strcat(m6809,hxbyte);
                
//                strcpy(hxbyte,",");
                strcpy(hxbyte,"");
                x = x - 3;
//                strcat(hxbyte,"$");
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                x++;
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                strcat(m6809,hxbyte);
                
//                strcpy(hxbyte,",");
                strcpy(hxbyte,"");
                x = x - 3;
//                strcat(hxbyte,"$");
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                x++;
                strncpy(temp2, temp+x, 1);
                temp2[1] = '\0';
                strcat(hxbyte,temp2);
                strcat(m6809,hxbyte);
            }
            
                
        
        */
        
        ret += ";"+z80.org;
        return ret;
    }
    static String handleLD(Z80ASMLine z80)
    {
        /*
            // check if command is LD
            if ((strncmp(z80, "LD  " ,4) == 0)) 
			{
//                printf("oldcode =%s=\n",oldcode);
                // Get first,second values
                //get getparts
                getparts(line, first, second);
                if (((first[0] != '(') && (second[0] != '(')) && ((first[0] != '$') && (second[0] != '$'))) {
                    strcpy(m6809, "TFR");
                    strcat(m6809,"     ");
                    change(first);
                    change(second);
                    strcat(m6809,second);
                    strcat(m6809,",");
                    strcat(m6809,first);
                }
                else {
                    strcpy(m6809, "LD");
                    if (second[0] == '$') {
                        strcpy(temp,"#");
                        strcat(temp,second);
                        strcpy(second,temp);
                        point = 0;
                    }
                    if (first[0] == '(') {
                        store = 1;
                        point = 1;
                        strncpy(temp, first+1, strlen(first)-2);
                        temp[strlen(first)-2] = '\0';
                        //reverse order of first, second
                        strcpy(first,second);
                        strcpy(second,temp);
                        strcpy(m6809, "ST");
                    }
                    if (second[0] == '(') {
                        point = 1;
                        strncpy(temp, second+1, strlen(second)-2);
                        temp[strlen(second)-2] = '\0';
                        strcpy(second, temp);
                    }
                    if (point == 1) {
                        strcpy(temp, "");
                        if (strlen(second) < 3) {
                            strcat(temp,",");
                        }
                        change(second);
                        strcat(temp, second);
                        strcat(temp, "");
                        strcpy(second, temp);
                    }
                    if (strncmp(second,"IX+",3) == 0) {
                        strncpy(temp, line+10, 2);
                        temp[2] = '\0';
                        strcpy(temp2,"$");
                        strcat(temp2,temp);
                        if (strcmp(temp2,"$00") == 0)
                            strcpy(temp2,"");
                        strcat(temp2,",U");
                        strcpy(second,temp2);
                    }
                    if (strncmp(second,"IY+",3) == 0) {
                        strncpy(temp, line+10, 2);
                        temp[2] = '\0';
                        strcpy(temp2,"$");
                        strcat(temp2,temp);
                        if (strcmp(temp2,"$00") == 0)
                            strcpy(temp2,"");
                        strcat(temp2,",Y");
                        strcpy(second,temp2);
                    }
                    change(first);
                    strcat(m6809,first);
                    strcat(m6809,"     ");
                    strcat(m6809,second);
                    if (strncmp(m6809, "ST#$0     ,X" ,12) == 0) {
                        strcpy(m6809, "CLR     ,X");
                    }
                    if (strncmp(m6809, "ST#$0     ,Y" ,12) == 0) {
                        strcpy(m6809, "CLR     ,Y");
                    }
                    if (strncmp(m6809, "ST#$0     ,U" ,12) == 0) {
                        strcpy(m6809, "CLR     ,U");
                    }
                }
            }
        */
        return "";
    }
}
