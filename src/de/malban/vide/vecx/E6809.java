/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

// java does not know about "unsigned"

// all data is kept as INT
// of smaller values are needed, they must be converted where USED!

/**
 *
 * @author Malban
 */
public class E6809 extends E6809State implements E6809Statics
{
    transient E6809Access vecx=null;
    transient Profiler profiler = null;

    /* Some times bad things happen...
      Artmaster for example, uses an IRQ to check for lightpen (handler at: 0x7ce)
      The handler discards all stack information and exists the interrupt by "RTS", so
      the PC which was put on the stack is "cleared" without our callstack noticing.
      
      Note: the stack is not PULLED, a "leas  12,s" is done!
  
      here we just do a check if our callstacks addresses are somewhere on the stack!
      and  if not - we remove them!
    
    */
    void callstackSanityCheck()
    {
        synchronized (callStack)
        {
            // check a depth of 10, anything more we are in trouble anyway :-)

            for (int j=callStack.size()-1; j>=0; j--)
            {
                int check = callStack.get(j);
                boolean found = false;
                int adr = reg_s.intValue;
                for (int i=0; i< 20;i++)
                {
                    int datahi = vecx.e6809_readOnly8((adr+i)   & 0xffff);
                    int datalo = vecx.e6809_readOnly8((adr+1+i) & 0xffff);
                    if (check == (datahi&0xff)*256+(datalo&0xff))
                    {
                        found = true;
                        break;
                    }
                }
                if (!found)
                {
                    callStack.remove(callStack.get(j));
                }
            }
        }
    }
    // called after a lds
    void resetCallstack()
    {
        callStack.clear();
    }
    
    
    int read_xyus(int r)
    {
        if (r==0) return reg_x;
        if (r==1) return reg_y;
        if (r==2) return reg_u.intValue;
        return reg_s.intValue;
    }
    void write_xyus(int r, int v)
    {
        if (r==0) reg_x = v;
        else if (r==1) reg_y = v;
        else if (r==2) reg_u.intValue = v;
        else reg_s.intValue = v;
    }

    /* obtain a particular condition code. returns 0 or 1. */
    int get_cc(int flag)
    {
            return (reg_cc / flag) & 1;
    }

    /* set a particular condition code to either 0 or 1.
     * value parameter must be either 0 or 1.
     */
    void set_cc (int flag, int value)
    {
            reg_cc &= ~flag;
            reg_cc |= value * flag;
    }

    /* test carry */
    int test_c (int i0, int i1, int r, int sub)
    {
        int flag;
        flag  = (i0 | i1) & ~r; /* one of the inputs is 1 and output is 0 */
        flag |= (i0 & i1);      /* both inputs are 1 */
        flag  = (flag >> 7) & 1;
        flag ^= sub; /* on a sub, carry is opposite the carry of an add */
        return flag;
    }

    /* test negative */
    int test_n (int r)
    {
        return (r >> 7) & 1;
    }

    /* test for zero in lower 8 bits */

    int test_z8(int r)
    {
        int flag;
        flag = ~r;
        flag = (flag >> 4) & (flag & 0xf);
        flag = (flag >> 2) & (flag & 0x3);
        flag = (flag >> 1) & (flag & 0x1);
        return flag;
    }

    /* test for zero in lower 16 bits */

    int test_z16 (int r)
    {
        int flag;
        flag = ~r;
        flag = (flag >> 8) & (flag & 0xff);
        flag = (flag >> 4) & (flag & 0xf);
        flag = (flag >> 2) & (flag & 0x3);
        flag = (flag >> 1) & (flag & 0x1);
        return flag;
    }

    /* overflow is set whenever the sign bits of the inputs are the same
     * but the sign bit of the result is not same as the sign bits of the
     * inputs.
     */
    int test_v(int i0, int i1, int r)
    {
        int flag;
        flag  = ~(i0 ^ i1); /* input sign bits are the same */
        flag &=  (i0 ^ r);  /* input sign and output sign not same */
        flag  = (flag >> 7) & 1;
        return flag;
    }

    int get_reg_d()
    {
        return ((reg_a << 8)&0xff00) | (reg_b & 0xff);
    }

    void set_reg_d (int value)
    {
        reg_a = (value >> 8) & 0xff;
        reg_b = value & 0xff;
    }

    /* read a byte ... the returned value has the lower 8-bits set to the byte
     * while the upper bits are all zero.
     */
    int read8 (int address)
    {
        return vecx.e6809_read8(address & 0xffff) ;
    }

    /* write a byte ... only the lower 8-bits of the int data
     * is written. the upper bits are ignored.
     */

    void write8 (int address, int data)
    {
        vecx.e6809_write8(address & 0xffff,  data);
    }

    int read16 (int address)
    {
        int datahi, datalo;

        datahi = read8 (address);
        datalo = read8 (address + 1);

        return (datahi << 8) | datalo;
    }
    int read16 (int address, boolean doCycles)
    {
        int datahi, datalo;

        datahi = read8 (address);
        vecx.vectrexNonCPUStep(1);
        datalo = read8 (address + 1);

        return (datahi << 8) | datalo;
    }

    void write16 (int address, int data)
    {
        write8 (address, data >> 8);
        write8 (address + 1, data); // write 8 does & 0xff
    }

    void write16 (int address, int data, boolean doCycles)
    {
        write8 (address, data >> 8);
        vecx.vectrexNonCPUStep(1);
        write8 (address + 1, data); // write 8 does & 0xff
    }

    void push8 (IntegerPointer sp, int data)
    {
        sp.intValue--;
        write8 (sp.intValue, data);
    }

    int pull8 (IntegerPointer sp)
    {
        int data;
        data = read8(sp.intValue);
        sp.intValue++;
        return data;
    }

    void push16 (IntegerPointer sp, int data)
    {
        push8 (sp, data);
        push8 (sp, data >> 8);
    }

    int pull16 (IntegerPointer sp)
    {
        int datahi, datalo;

        datahi = pull8 (sp);
        datalo = pull8 (sp);

        return (datahi << 8) | datalo;
    }

    /* read a byte from the address pointed to by the pc */
    int pc_read8()
    {
        int data;
        data = read8(reg_pc);
        reg_pc=(reg_pc+1)&0xffff;
        return data;
    }

    /* read a word from the address pointed to by the pc */

    int pc_read16()
    {
        int data;
        data = read16 (reg_pc);
        reg_pc=(reg_pc+2)&0xffff;
        return data;
    }

    /* sign extend an 8-bit quantity into a 16-bit quantity */
    int sign_extend (int data)
    {
        return (~(data & 0x80) + 1) | (data & 0xff);
    }

    /* direct addressing, upper byte of the address comes from
     * the direct page register, and the lower byte comes from the
     * instruction itself.
     */
    int ea_direct()
    {
        return (reg_dp << 8) | pc_read8 ();
    }

    /* extended addressing, address is obtained from 2 bytes following
     * the instruction.
     */
    int ea_extended ()
    {
        return pc_read16 ();
    }

    /* indexed addressing */
    int ea_indexed (IntegerPointer cycles)
    {
        int r, op, ea;

        /* post byte */
        op = pc_read8 ();
        r = (op >> 5) & 3;
        switch (op) 
        {
            case 0x00: case 0x01: case 0x02: case 0x03:
            case 0x04: case 0x05: case 0x06: case 0x07:
            case 0x08: case 0x09: case 0x0a: case 0x0b:
            case 0x0c: case 0x0d: case 0x0e: case 0x0f:
            case 0x20: case 0x21: case 0x22: case 0x23:
            case 0x24: case 0x25: case 0x26: case 0x27:
            case 0x28: case 0x29: case 0x2a: case 0x2b:
            case 0x2c: case 0x2d: case 0x2e: case 0x2f:
            case 0x40: case 0x41: case 0x42: case 0x43:
            case 0x44: case 0x45: case 0x46: case 0x47:
            case 0x48: case 0x49: case 0x4a: case 0x4b:
            case 0x4c: case 0x4d: case 0x4e: case 0x4f:
            case 0x60: case 0x61: case 0x62: case 0x63:
            case 0x64: case 0x65: case 0x66: case 0x67:
            case 0x68: case 0x69: case 0x6a: case 0x6b:
            case 0x6c: case 0x6d: case 0x6e: case 0x6f:
                /* R, +[0, 15] */
                cycles.intValue++;
                vecx.vectrexNonCPUStep(1);
                ea = read_xyus(r) + (op & 0xf);
                break;
            case 0x10: case 0x11: case 0x12: case 0x13:
            case 0x14: case 0x15: case 0x16: case 0x17:
            case 0x18: case 0x19: case 0x1a: case 0x1b:
            case 0x1c: case 0x1d: case 0x1e: case 0x1f:
            case 0x30: case 0x31: case 0x32: case 0x33:
            case 0x34: case 0x35: case 0x36: case 0x37:
            case 0x38: case 0x39: case 0x3a: case 0x3b:
            case 0x3c: case 0x3d: case 0x3e: case 0x3f:
            case 0x50: case 0x51: case 0x52: case 0x53:
            case 0x54: case 0x55: case 0x56: case 0x57:
            case 0x58: case 0x59: case 0x5a: case 0x5b:
            case 0x5c: case 0x5d: case 0x5e: case 0x5f:
            case 0x70: case 0x71: case 0x72: case 0x73:
            case 0x74: case 0x75: case 0x76: case 0x77:
            case 0x78: case 0x79: case 0x7a: case 0x7b:
            case 0x7c: case 0x7d: case 0x7e: case 0x7f:
                /* R, +[-16, -1] */
                cycles.intValue++;
                vecx.vectrexNonCPUStep(1);
                ea = read_xyus(r) + (op & 0xf) - 0x10;
                break;
            case 0x80: case 0x81:
            case 0xa0: case 0xa1:
            case 0xc0: case 0xc1:
            case 0xe0: case 0xe1:
                /* ,R+ / ,R++ */
                cycles.intValue+= 2 + (op & 1);
                vecx.vectrexNonCPUStep((2 + (op & 1)));
                ea = read_xyus(r);
                write_xyus(r, read_xyus(r)+1 + (op & 1));
                break;
            case 0x90: case 0x91:
            case 0xb0: case 0xb1:
            case 0xd0: case 0xd1:
            case 0xf0: case 0xf1:
                /* [,R+] ??? / [,R++] */
                cycles.intValue+= 5 + (op & 1);
                vecx.vectrexNonCPUStep((5 + (op & 1)));
                ea = read16(read_xyus(r));
                write_xyus(r, read_xyus(r)+1 + (op & 1));
                break;
            case 0x82: case 0x83:
            case 0xa2: case 0xa3:
            case 0xc2: case 0xc3:
            case 0xe2: case 0xe3:
                /* ,-R / ,--R */
                cycles.intValue+= 2 + (op & 1);
                vecx.vectrexNonCPUStep((2 + (op & 1)));
                write_xyus(r, read_xyus(r)-(1 + (op & 1)));
                ea = read_xyus(r);
                break;
            case 0x92: case 0x93:
            case 0xb2: case 0xb3:
            case 0xd2: case 0xd3:
            case 0xf2: case 0xf3:
                /* [,-R] ??? / [,--R] */
                cycles.intValue+= 5 + (op & 1);
                vecx.vectrexNonCPUStep((5 + (op & 1)));
                write_xyus(r, read_xyus(r)-(1 + (op & 1)));
                ea = read16 (read_xyus(r));
                break;
            case 0x84: case 0xa4:
            case 0xc4: case 0xe4:
                /* ,R */
                ea = read_xyus(r);
                break;
            case 0x94: case 0xb4:
            case 0xd4: case 0xf4:
                /* [,R] */
                cycles.intValue+= 2;
                vecx.vectrexNonCPUStep(2);
                ea = read16 (read_xyus(r));
                break;
            case 0x85: case 0xa5:
            case 0xc5: case 0xe5:
                /* B,R */
                cycles.intValue+= 1;
                vecx.vectrexNonCPUStep(1);
                ea = read_xyus(r) + sign_extend (reg_b);
                break;
            case 0x95: case 0xb5:
            case 0xd5: case 0xf5:
                /* [B,R] */
                cycles.intValue+= 4;
                vecx.vectrexNonCPUStep(4);
                ea = read16 (read_xyus(r) + sign_extend (reg_b));
                break;
            case 0x86: case 0xa6:
            case 0xc6: case 0xe6:
                /* A,R */
                cycles.intValue+= 1;
                vecx.vectrexNonCPUStep(1);
                ea = read_xyus(r) + sign_extend (reg_a);
                break;
            case 0x96: case 0xb6:
            case 0xd6: case 0xf6:
                /* [A,R] */

                cycles.intValue+= 4;
                vecx.vectrexNonCPUStep(4);
                ea = read16 (read_xyus(r) + sign_extend (reg_a));
                break;
            case 0x88: case 0xa8:
            case 0xc8: case 0xe8:
                /* byte,R */

                cycles.intValue+= 1;
                vecx.vectrexNonCPUStep(1);
                ea = read_xyus(r) + sign_extend (pc_read8 ());
                break;
            case 0x98: case 0xb8:
            case 0xd8: case 0xf8:
                /* [byte,R] */

                cycles.intValue+= 4;
                vecx.vectrexNonCPUStep(4);
                ea = read16 (read_xyus(r) + sign_extend (pc_read8 ()));
                break;
            case 0x89: case 0xa9:
            case 0xc9: case 0xe9:
                /* word,R */
                cycles.intValue+= 4;
                vecx.vectrexNonCPUStep(4);
                ea = read_xyus(r) + pc_read16 ();
                break;
            case 0x99: case 0xb9:
            case 0xd9: case 0xf9:
                /* [word,R] */

                cycles.intValue+= 7;
                vecx.vectrexNonCPUStep(7);
                ea = read16 (read_xyus(r) + pc_read16 ());
                break;
            case 0x8b: case 0xab:
            case 0xcb: case 0xeb:
                /* D,R */

                cycles.intValue+= 4;
                vecx.vectrexNonCPUStep(4);
                ea = read_xyus(r) + get_reg_d ();
                break;
            case 0x9b: case 0xbb:
            case 0xdb: case 0xfb:
                /* [D,R] */

                cycles.intValue+= 7;
                vecx.vectrexNonCPUStep(7);
                ea = read16 (read_xyus(r) + get_reg_d ());
                break;
            case 0x8c: case 0xac:
            case 0xcc: case 0xec:
                /* byte, PC */
                vecx.vectrexNonCPUStep(1);
                ea = reg_pc + r;
                cycles.intValue+= 1;
                r = sign_extend (pc_read8 ());
                break;
            case 0x9c: case 0xbc:
            case 0xdc: case 0xfc:
                /* [byte, PC] */
                vecx.vectrexNonCPUStep(4);
                r = sign_extend (pc_read8 ());
                cycles.intValue+= 4;
                ea = read16 (reg_pc + r);
                break;
            case 0x8d: case 0xad:
            case 0xcd: case 0xed:
                /* word, PC */
                vecx.vectrexNonCPUStep(5);
                r = pc_read16 ();
                ea = reg_pc + r;
                cycles.intValue+= 5;
                break;
            case 0x9d: case 0xbd:
            case 0xdd: case 0xfd:
                /* [word, PC] */
                vecx.vectrexNonCPUStep(8);
                r = pc_read16 ();
                ea = read16 (reg_pc + r);
                cycles.intValue+= 8;
                break;
            case 0x9f:
                /* [address] */
                vecx.vectrexNonCPUStep(5);
                ea = read16 (pc_read16 ());
                cycles.intValue+= 5;
                break;
            default:
                ea = 0;
                System.out.println ("undefined post-byte\n");
                break;
        }

        return ea&0xffff;
    }

/* instruction: neg
 * essentially (0 - data).
 */

int inst_neg (int data)
{
    int i0, i1, r;

    i0 = 0;
    i1 = ~data;
    r = i0 + i1 + 1;

    set_cc (FLAG_H, test_c (i0 << 4, i1 << 4, r << 4, 0));
    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));
    set_cc (FLAG_C, test_c (i0, i1, r, 1));

    return r;
}

/* instruction: com */
int inst_com (int data)
{
    int r;

    r = ~data;

    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, 0);
    set_cc (FLAG_C, 1);

    return r;
}

/* instruction: lsr
 * cannot be faked as an add or substract.
 */

int inst_lsr (int data)
{
    int r;

    r = (data >> 1) & 0x7f;

    set_cc (FLAG_N, 0);
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_C, data & 1);

    return r;
}

/* instruction: ror
 * cannot be faked as an add or substract.
 */

int inst_ror (int data)
{
    int r, c;

    c = get_cc (FLAG_C);
    r = ((data >> 1) & 0x7f) | (c << 7);

    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_C, data & 1);

    return r;
}

/* instruction: asr
 * cannot be faked as an add or substract.
 */

int inst_asr (int data)
{
    int r;

    r = ((data >> 1) & 0x7f) | (data & 0x80);

    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_C, data & 1);

    return r;
}

/* instruction: asl
 * essentially (data + data). simple addition.
 */

int inst_asl (int data)
{
    int i0, i1, r;

    i0 = data;
    i1 = data;
    r = i0 + i1;

    set_cc (FLAG_H, test_c (i0 << 4, i1 << 4, r << 4, 0));
    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));
    set_cc (FLAG_C, test_c (i0, i1, r, 0));

// Is that the same as above?    
// Malban, this is what my books say
    int b6 = (data & 0x40)>>6;
    int b7 = (data & 0x80)>>7;
    set_cc (FLAG_V, (b6==b7?0:1));
    set_cc (FLAG_C, (data&0x80)>>7);
    
    
    return r&0xff;
}

/* instruction: rol
 * essentially (data + data + carry). addition with carry.
 */

int inst_rol (int data)
{
    int i0, i1, c, r;

    i0 = data;
    i1 = data;
    c = get_cc (FLAG_C);
    r = i0 + i1 + c;

    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));
    set_cc (FLAG_C, test_c (i0, i1, r, 0));

// Is that the same as above?    
    // Malban, this is what my books say
    int b6 = (data & 0x40)>>6;
    int b7 = (data & 0x80)>>7;
    set_cc (FLAG_V, (b6==b7?0:1));
    set_cc (FLAG_C, (data&0x80)>>7);
    
    return r&0xff;
}

/* instruction: dec
 * essentially (data - 1).
 */

int inst_dec (int data)
{
    int i0, i1, r;

    i0 = data;
    i1 = 0xff;
    r = i0 + i1;

    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));

// Is that the same as above?    
    // Malban, this is what my books say
    set_cc (FLAG_V, data==0x80?1:0);

    return r&0xff;
}

/* instruction: inc
 * essentially (data + 1).
 */

int inst_inc (int data)
{
    int i0, i1, r;

    i0 = data;
    i1 = 1;
    r = i0 + i1;

    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));

// Is that the same as above?    
    // Malban, this is what my books say
    set_cc (FLAG_V, data==0x7f?1:0);

    return r&0xff;
}

/* instruction: tst */

void inst_tst8 (int data)
{
    set_cc (FLAG_N, test_n (data));
    set_cc (FLAG_Z, test_z8 (data));
    set_cc (FLAG_V, 0);
}

void inst_tst16 (int data)
{
    set_cc (FLAG_N, test_n (data >> 8));
    set_cc (FLAG_Z, test_z16 (data));
    set_cc (FLAG_V, 0);
}

/* instruction: clr */

void inst_clr ()
{
    set_cc (FLAG_N, 0);
    set_cc (FLAG_Z, 1);
    set_cc (FLAG_V, 0);
    set_cc (FLAG_C, 0);
}

/* instruction: suba/subb */

int inst_sub8 (int data0, int data1)
{
    int i0, i1, r;

    i0 = data0;
    i1 = ~data1;
    r = i0 + i1 + 1;

    set_cc (FLAG_H, test_c (i0 << 4, i1 << 4, r << 4, 0));
    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));
    set_cc (FLAG_C, test_c (i0, i1, r, 1));

    return r&0xff;
}

/* instruction: sbca/sbcb/cmpa/cmpb.
 * only 8-bit version, 16-bit version not needed.
 */

int inst_sbc (int data0, int data1)
{
    int i0, i1, c, r;

    i0 = data0;
    i1 = ~data1;
    c = 1 - get_cc (FLAG_C);
    r = i0 + i1 + c;

    set_cc (FLAG_H, test_c (i0 << 4, i1 << 4, r << 4, 0));
    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));
    set_cc (FLAG_C, test_c (i0, i1, r, 1));

    return r&0xff;
}

/* instruction: anda/andb/bita/bitb.
 * only 8-bit version, 16-bit version not needed.
 */

int inst_and (int data0, int data1)
{
    int r;

    r = data0 & data1;

    inst_tst8 (r);

    return r;
}

/* instruction: eora/eorb.
 * only 8-bit version, 16-bit version not needed.
 */

int inst_eor (int data0, int data1)
{
    int r;

    r = data0 ^ data1;

    inst_tst8 (r);

    return r;
}

/* instruction: adca/adcb
 * only 8-bit version, 16-bit version not needed.
 */

int inst_adc (int data0, int data1)
{
    int i0, i1, c, r;

    i0 = data0;
    i1 = data1;
    c = get_cc (FLAG_C);
    r = (i0 + i1 + c)&0xff;

    set_cc (FLAG_H, test_c (i0 << 4, i1 << 4, r << 4, 0));
    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));
    set_cc (FLAG_C, test_c (i0, i1, r, 0));

    return r;
}

/* instruction: ora/orb.
 * only 8-bit version, 16-bit version not needed.
 */

int inst_or (int data0, int data1)
{
    int r;

    r = data0 | data1;

    inst_tst8 (r);

    return r;
}

/* instruction: adda/addb */

int inst_add8 (int data0, int data1)
{
    int i0, i1, r;

    i0 = data0;
    i1 = data1;
    r = (i0 + i1)&0xff;

    set_cc (FLAG_H, test_c (i0 << 4, i1 << 4, r << 4, 0));
    set_cc (FLAG_N, test_n (r));
    set_cc (FLAG_Z, test_z8 (r));
    set_cc (FLAG_V, test_v (i0, i1, r));
    set_cc (FLAG_C, test_c (i0, i1, r, 0));

    return r;
}

/* instruction: addd */

int inst_add16 (int data0, int data1)
{
    int i0, i1, r;

    i0 = data0;
    i1 = data1;
    r = (i0 + i1)&0xffff;

    set_cc (FLAG_N, test_n (r >> 8));
    set_cc (FLAG_Z, test_z16 (r));
    set_cc (FLAG_V, test_v (i0 >> 8, i1 >> 8, r >> 8));
    set_cc (FLAG_C, test_c (i0 >> 8, i1 >> 8, r >> 8, 0));

    return r;
}

/* instruction: subd */

int inst_sub16 (int data0, int data1)
{
    int i0, i1, r;

    i0 = data0;
    i1 = ~data1;
    r = (i0 + i1 + 1)&0xffff;

    set_cc (FLAG_N, test_n (r >> 8));
    set_cc (FLAG_Z, test_z16 (r));
    set_cc (FLAG_V, test_v (i0 >> 8, i1 >> 8, r >> 8));
    set_cc (FLAG_C, test_c (i0 >> 8, i1 >> 8, r >> 8, 1));

    return r;
}

/* instruction: 8-bit offset branch */
void inst_bra8 (int test, int op, IntegerPointer cycles)
{
    int offset, mask;
    offset = pc_read8 ();

    /* trying to avoid an if statement */
    mask = (test ^ (op & 1)) - 1; /* 0xffff when taken, 0 when not taken */
    reg_pc += sign_extend (offset) & mask;
    reg_pc = reg_pc & 0xffff;
    cycles.intValue += 3;
    // dont care analog
}

/* instruction: 16-bit offset branch */

void inst_bra16 (int test, int op, IntegerPointer cycles)
{
    int offset, mask;
    offset = pc_read16 ();

    /* trying to avoid an if statement */
    mask = (test ^ (op & 1)) - 1; /* 0xffff when taken, 0 when not taken */
    reg_pc += offset & mask;
    reg_pc = reg_pc & 0xffff;
    cycles.intValue += 5 - mask;
    // dont care analog
}

/* instruction: pshs/pshu */
void inst_psh (int op, IntegerPointer sp, IntegerPointer data, IntegerPointer cycles)
{
    if ((op & 0x80) !=0)
    {
        push16 (sp, reg_pc);
        synchronized (callStack)
        {
            callStack.add(reg_pc & 0xffff);
        }
        cycles.intValue += 2;
        // dont care analog
    }

    if ((op & 0x40)!=0) {
        /* either s or u */
        push16 (sp, data.intValue);
        cycles.intValue += 2;
        // dont care analog
    }

    if ((op & 0x20)!=0) {
            push16 (sp, reg_y);
            cycles.intValue += 2;
            // dont care analog
    }

    if ((op & 0x10)!=0) {
            push16 (sp, reg_x);
            cycles.intValue += 2;
            // dont care analog
    }

    if ((op & 0x08)!=0) {
            push8 (sp, reg_dp);
            cycles.intValue += 1;
            // dont care analog
    }

    if ((op & 0x04)!=0) {
            push8 (sp, reg_b);
            cycles.intValue += 1;
            // dont care analog
    }

    if ((op & 0x02)!=0) {
            push8 (sp, reg_a);
            cycles.intValue += 1;
            // dont care analog
    }

    if ((op & 0x01)!=0) {
            push8 (sp, reg_cc);
            cycles.intValue += 1;
            // dont care analog
    }
}

/* instruction: puls/pulu */
void inst_pul (int op, IntegerPointer sp, IntegerPointer osp, IntegerPointer cycles)
{
    if ((op & 0x01)!=0) 
    {
        reg_cc = pull8 (sp);
        cycles.intValue += 1;
        // dont care analog
    }

    if ((op & 0x02)!=0) 
    {
        reg_a = pull8 (sp);
        cycles.intValue += 1;
        // dont care analog
    }

    if ((op & 0x04)!=0) 
    {
        reg_b = pull8 (sp);
        cycles.intValue += 1;
        // dont care analog
    }

    if ((op & 0x08)!=0) 
    {
        reg_dp = pull8 (sp);
        cycles.intValue += 1;
        // dont care analog
    }

    if ((op & 0x10)!=0) 
    {
        reg_x = pull16 (sp);
        cycles.intValue += 2;
        // dont care analog
    }

    if ((op & 0x20)!=0) 
    {
        reg_y = pull16 (sp);
        cycles.intValue += 2;
        // dont care analog
    }

    if ((op & 0x40)!=0) 
    {
        /* either s or u */
        osp.intValue = pull16 (sp);
        cycles.intValue += 2;
        // dont care analog
    }

    if ((op & 0x80)!=0) 
    {
        reg_pc = pull16 (sp);
        synchronized (callStack)
        {
            if (callStack.size()>0) callStack.remove(callStack.size()-1);
        }
        cycles.intValue += 2;
        // dont care analog
    }
}

int exgtfr_read (int reg)
{
	int data;
    
	switch (reg) {
        case 0x0:
            data = get_reg_d ();
            break;
        case 0x1:
            data = reg_x;
            break;
        case 0x2:
            data = reg_y;
            break;
        case 0x3:
            data = reg_u.intValue;
            break;
        case 0x4:
            data = reg_s.intValue;
            break;
        case 0x5:
            data = reg_pc;
            break;
        case 0x8:
            data = reg_a;
            break;
        case 0x9:
            data = reg_b;
            break;
        case 0xa:
            data = reg_cc;
            break;
        case 0xb:
            data =reg_dp;
            break;
        default:
            data = 0xffff;
            System.out.println("illegal exgtfr reg "+reg+"\n");
            break;
	}
    
	return data;
}

void exgtfr_write (int reg, int data)
{
	switch (reg) {
        case 0x0:
            set_reg_d (data);
            break;
        case 0x1:
            reg_x = data;
            break;
        case 0x2:
            reg_y = data;
            break;
        case 0x3:
            reg_u.intValue = data;
            break;
        case 0x4:
            reg_s.intValue = data;
            break;
        case 0x5:
            reg_pc = data;
            break;
        case 0x8:
            reg_a = data &0xff;
            break;
        case 0x9:
            reg_b = data &0xff;
            break;
        case 0xa:
            reg_cc = data &0xff;
            break;
        case 0xb:
            reg_dp = data &0xff;
            break;
        default:
            System.out.println ("illegal exgtfr reg "+reg+"\n");
            break;
	}
}

/* instruction: exg */

void inst_exg ()
{
    int op, tmp;

    op = pc_read8 ();

    tmp = exgtfr_read (op & 0xf);
    exgtfr_write (op & 0xf, exgtfr_read (op >> 4));
    exgtfr_write (op >> 4, tmp);
}

public static final int PRE_CLR_STEPS = 4;
public static final int POST_CLR_ADDSTEPS = -1;

/* instruction: tfr */

void inst_tfr ()
{
    int op;

    op = pc_read8 ();

    exgtfr_write (op & 0xf, exgtfr_read (op >> 4));
}

/* reset the 6809 */

public void e6809_reset ()
{
    profiler = null;
    reg_x = 0;
    reg_y = 0;
    reg_u.intValue = 0;
    reg_s.intValue = 0;

    reg_a = 0;
    reg_b = 0;

    reg_dp = 0;
    cyclesRunning =0;
    reg_cc = FLAG_I | FLAG_F;
    irq_status = IRQ_NORMAL;
    synchronized (callStack)
    {
        callStack.clear();
    }

    reg_pc = read16 (0xfffe);
}

/* execute a single instruction or handle interrupts and return */
int e6809_sstep (int irq_i, int irq_f)
{
    int op;
    IntegerPointer cycles = new IntegerPointer();
    cycles.intValue = 0;
    int ea, i0, i1, r;

    if (irq_f!=0) 
    {
        if (get_cc (FLAG_F) == 0) 
        {
            if (irq_status != IRQ_CWAI) 
            {
                set_cc (FLAG_E, 0);
                inst_psh (0x81, reg_s, reg_u, cycles);

                if (profiler != null)
                {
                    profiler.addContext(read16 (0xfff6), reg_s.intValue+1, reg_pc & 0xffff);
                }
            }

            set_cc (FLAG_I, 1);
            set_cc (FLAG_F, 1);

            
            
           
            reg_pc = read16 (0xfff6);
            irq_status = IRQ_NORMAL;
            cycles.intValue += 7;
            // dont care analog
        } 
        else 
        {
            if (irq_status == IRQ_SYNC) 
            {
                irq_status = IRQ_NORMAL;
            }
        }
    }
    
    if (irq_i!=0) 
    {
        if (get_cc (FLAG_I) == 0) 
        {
            if (irq_status != IRQ_CWAI) 
            {
                set_cc (FLAG_E, 1);
                int olds = reg_s.intValue;
                inst_psh (0xff, reg_s, reg_u, cycles);
                
                if (profiler != null)
                {
                    profiler.addContext(read16 (0xfff8), olds-2, reg_pc & 0xffff);
                }
                
            }
            set_cc (FLAG_I, 1);
            reg_pc = read16 (0xfff8);
            irq_status = IRQ_NORMAL;
            cycles.intValue += 7;
            // dont care analog
        } 
        else 
        {
            if (irq_status == IRQ_SYNC) 
            {
                irq_status = IRQ_NORMAL;
            }
        }
    }

    if (irq_status != IRQ_NORMAL) 
    {
        // dont care analog
        cyclesRunning += cycles.intValue + 1;
        return cycles.intValue + 1;
    }
    
    op = pc_read8 ();
    switch (op) 
    {
        /* page 0 instructions */
            
            /* neg, nega, negb */
        case 0x00:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_neg (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x40:
            reg_a = inst_neg (reg_a)&0xff;
            // dont care analog
            vecx.vectrexNonCPUStep(2);
            break;
        case 0x50:
            reg_b = inst_neg (reg_b)&0xff;
            // dont care analog
            vecx.vectrexNonCPUStep(2);
            break;
        case 0x60:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_neg (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x70:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_neg (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* com, coma, comb */
        case 0x03:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_com (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x43:
            reg_a = inst_com (reg_a)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x53:
            reg_b = inst_com (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x63:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_com (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x73:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_com (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* lsr, lsra, lsrb */
        case 0x04:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_lsr (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x44:
            reg_a = inst_lsr (reg_a)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x54:
            reg_b = inst_lsr (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x64:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_lsr (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x74:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_lsr (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* ror, rora, rorb */
        case 0x06:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_ror (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x46:
            reg_a = inst_ror (reg_a)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x56:
            reg_b = inst_ror (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x66:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_ror (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x76:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_ror (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* asr, asra, asrb */
        case 0x07:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_asr (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x47:
            reg_a = inst_asr (reg_a)&0xff;
            vecx.vectrexNonCPUStep(1);
            // dont care analog
            break;
        case 0x57:
            reg_b = inst_asr (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x67:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_asr (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x77:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_asr (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* asl, asla, aslb */
        case 0x08:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_asl (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x48:
            reg_a = inst_asl (reg_a)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x58:
            reg_b = inst_asl (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x68:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_asl (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x78:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_asl (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* rol, rola, rolb */
        case 0x09:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_rol (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x49:
            reg_a = inst_rol (reg_a)&0xff;
            cycles.intValue += 2;
            // dont care analog
            break;
        case 0x59:
            reg_b = inst_rol (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x69:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_rol (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x79:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_rol (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* dec, deca, decb */
        case 0x0a:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_dec (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x4a:
            reg_a = inst_dec (reg_a)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x5a:
            reg_b = inst_dec (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x6a:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_dec (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x7a:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_dec (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* inc, inca, incb */
        case 0x0c:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            r = inst_inc (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x4c:
            reg_a = inst_inc (reg_a)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x5c:
            reg_b = inst_inc (reg_b)&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x6c:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            r = inst_inc (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 6;
            break;
        case 0x7c:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            r = inst_inc (read8 (ea));
            vecx.vectrexNonCPUStep(2+1);
            write8 (ea, r);
            
            cycles.intValue += 7;
            break;
            /* tst, tsta, tstb */
        case 0x0d:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3);
            inst_tst8 (read8 (ea));
            // dont care analog
            cycles.intValue += 6;
            break;
        case 0x4d:
            inst_tst8 (reg_a);
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x5d:
            inst_tst8 (reg_b);
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x6d:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3);
            inst_tst8 (read8 (ea));
            // dont care analog
            cycles.intValue += 6;
            break;
        case 0x7d:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4);
            inst_tst8 (read8 (ea));
            // dont care analog
            cycles.intValue += 7;
            break;
            /* jmp */
        case 0x0e:
            reg_pc = ea_direct ();
            // dont care analog
            cycles.intValue += 3;
            break;
        case 0x6e:
            reg_pc = ea_indexed (cycles);
            // dont care analog
            cycles.intValue += 3;
            break;
        case 0x7e:
            reg_pc = ea_extended ();
            // dont care analog
            cycles.intValue += 4;
            break;
            /* clr */
        case 0x0f:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(PRE_CLR_STEPS);
            inst_clr ();
            read8(ea); // clear reads! important for shift reg emulation! e.g.
            vecx.vectrexNonCPUStep(2+1+POST_CLR_ADDSTEPS);
            write8 (ea, 0);
            cycles.intValue += 6;
            break;
        case 0x4f:
            inst_clr ();
            reg_a = 0;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x5f:
            inst_clr ();
            reg_b = 0;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x6f:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(PRE_CLR_STEPS);
            inst_clr ();
            read8(ea); // clear reads! important for shift reg emulation! e.g.
            vecx.vectrexNonCPUStep(2+1+POST_CLR_ADDSTEPS);
            write8 (ea, 0);
            
            cycles.intValue += 6;
            break;
        case 0x7f:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(1+PRE_CLR_STEPS);
            inst_clr ();
            read8(ea); // clear reads! important for shift reg emulation! e.g.
            vecx.vectrexNonCPUStep(2+1+POST_CLR_ADDSTEPS);
            write8 (ea, 0);
            
            cycles.intValue += 7;
            break;
            /* suba */
        case 0x80:
            vecx.vectrexNonCPUStep(1+1);
            reg_a = inst_sub8 (reg_a, pc_read8 ())&0xff;
            
            cycles.intValue += 2;
            break;
        case 0x90:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_sub8 (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xa0:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_sub8 (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xb0:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            reg_a = inst_sub8 (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 5;
            break;
            /* subb */
        case 0xc0:
            vecx.vectrexNonCPUStep(1+1);
            reg_b = inst_sub8 (reg_b, pc_read8 ())&0xff;
            
            cycles.intValue += 2;
            break;
        case 0xd0:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_sub8 (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xe0:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_sub8 (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xf0:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            reg_b = inst_sub8 (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 5;
            break;
            /* cmpa */
        case 0x81:
            vecx.vectrexNonCPUStep(1+1);
            inst_sub8 (reg_a, pc_read8 ());
            
            cycles.intValue += 2;
            break;
        case 0x91:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            inst_sub8 (reg_a, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xa1:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            inst_sub8 (reg_a, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xb1:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            inst_sub8 (reg_a, read8 (ea));
            
            cycles.intValue += 5;
            break;
            /* cmpb */
        case 0xc1:
            vecx.vectrexNonCPUStep(1+1);
            inst_sub8 (reg_b, pc_read8 ());
            
            cycles.intValue += 2;
            break;
        case 0xd1:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            inst_sub8 (reg_b, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xe1:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            inst_sub8 (reg_b, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xf1:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            inst_sub8 (reg_b, read8 (ea));
            
            cycles.intValue += 5;
            break;
            /* sbca */
        case 0x82:
            vecx.vectrexNonCPUStep(1+1);
            reg_a = inst_sbc (reg_a, pc_read8 ())&0xff;
            
            cycles.intValue += 2;
            break;
        case 0x92:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_sbc (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xa2:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_sbc (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xb2:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            reg_a = inst_sbc (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 5;
            break;
            /* sbcb */
        case 0xc2:
            vecx.vectrexNonCPUStep(1+1);
            reg_b = inst_sbc (reg_b, pc_read8 ())&0xff;
            
            cycles.intValue += 2;
            break;
        case 0xd2:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_sbc (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xe2:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_sbc (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xf2:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            reg_b = inst_sbc (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 5;
            break;
            /* anda */
        case 0x84:
            vecx.vectrexNonCPUStep(1+1);
            reg_a = inst_and (reg_a, pc_read8 ())&0xff;
            
            cycles.intValue += 2;
            break;
        case 0x94:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_and (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xa4:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_and (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xb4:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            reg_a = inst_and (reg_a, read8 (ea))&0xff;
            
            cycles.intValue += 5;
            break;
            /* andb */
        case 0xc4:
            vecx.vectrexNonCPUStep(1+1);
            reg_b = inst_and (reg_b, pc_read8 ())&0xff;
            
            cycles.intValue += 2;
            break;
        case 0xd4:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_and (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xe4:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_and (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 4;
            break;
        case 0xf4:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            reg_b = inst_and (reg_b, read8 (ea))&0xff;
            
            cycles.intValue += 5;
            break;
            /* bita */
        case 0x85:
            vecx.vectrexNonCPUStep(1+1);
            inst_and (reg_a, pc_read8 ());
            
            cycles.intValue += 2;
            break;
        case 0x95:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            inst_and (reg_a, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xa5:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            inst_and (reg_a, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xb5:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            inst_and (reg_a, read8 (ea));
            
            cycles.intValue += 5;
            break;
            /* bitb */
        case 0xc5:
            vecx.vectrexNonCPUStep(1+1);
            inst_and (reg_b, pc_read8 ());
            
            cycles.intValue += 2;
            break;
        case 0xd5:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            inst_and (reg_b, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xe5:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            inst_and (reg_b, read8 (ea));
            
            cycles.intValue += 4;
            break;
        case 0xf5:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            inst_and (reg_b, read8 (ea));
            
            cycles.intValue += 5;
            break;
            /* lda */
        case 0x86:
            reg_a = pc_read8 ();
            vecx.vectrexNonCPUStep(1+1);
            inst_tst8 (reg_a);
            
            cycles.intValue += 2;
            break;
        case 0x96:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_a = read8 (ea);
            vecx.vectrexNonCPUStep(1);
            inst_tst8 (reg_a);
            cycles.intValue += 4;
            break;
        case 0xa6:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_a = read8 (ea);
            vecx.vectrexNonCPUStep(1);
            inst_tst8 (reg_a);
            cycles.intValue += 4;
            break;
        case 0xb6:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = read8 (ea);
            vecx.vectrexNonCPUStep(1);
            inst_tst8 (reg_a);
            cycles.intValue += 5;
            break;
            /* ldb */
        case 0xc6:
            reg_b = pc_read8 ();
            vecx.vectrexNonCPUStep(1+1);
            inst_tst8 (reg_b);
            
            cycles.intValue += 2;
            break;
        case 0xd6:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_b = read8 (ea);
            vecx.vectrexNonCPUStep(1);
            inst_tst8 (reg_b);
            cycles.intValue += 4;
            break;
        case 0xe6:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_b = read8 (ea);
            vecx.vectrexNonCPUStep(1);
            inst_tst8 (reg_b);
            cycles.intValue += 4;
            break;
        case 0xf6:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = read8 (ea);
            vecx.vectrexNonCPUStep(1);
            inst_tst8 (reg_b);
            cycles.intValue += 5;
            break;
            /* sta */
        case 0x97:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            write8 (ea, reg_a);
            
            inst_tst8 (reg_a);
            cycles.intValue += 4;
            break;
        case 0xa7:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            write8 (ea, reg_a);
            
            inst_tst8 (reg_a);
            cycles.intValue += 4;
            break;
        case 0xb7:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            write8 (ea, reg_a);
            
            inst_tst8 (reg_a);
            cycles.intValue += 5;
            break;
            /* stb */
        case 0xd7:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            write8 (ea, reg_b);
            
            inst_tst8 (reg_b);
            cycles.intValue += 4;
            break;
        case 0xe7:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            write8 (ea, reg_b);
            
            inst_tst8 (reg_b);
            cycles.intValue += 4;
            break;
        case 0xf7:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            write8 (ea, reg_b);
            
            inst_tst8 (reg_b);
            cycles.intValue += 5;
            break;
            /* eora */
        case 0x88:
            reg_a = inst_eor (reg_a, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x98:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_eor (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xa8:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_eor (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xb8:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_eor (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* eorb */
        case 0xc8:
            reg_b = inst_eor (reg_b, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0xd8:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_eor (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xe8:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_eor (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xf8:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_eor (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* adca */
        case 0x89:
            reg_a = inst_adc (reg_a, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x99:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_adc (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xa9:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_adc (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xb9:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_adc (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* adcb */
        case 0xc9:
            reg_b = inst_adc (reg_b, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0xd9:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_adc (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xe9:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_adc (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xf9:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_adc (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* ora */
        case 0x8a:
            reg_a = inst_or (reg_a, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x9a:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_or (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xaa:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_or (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xba:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_or (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* orb */
        case 0xca:
            reg_b = inst_or (reg_b, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0xda:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_or (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xea:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_or (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xfa:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_or (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* adda */
        case 0x8b:
            reg_a = inst_add8 (reg_a, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0x9b:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_add8 (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xab:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_a = inst_add8 (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xbb:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_a = inst_add8 (reg_a, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* addb */
        case 0xcb:
            reg_b = inst_add8 (reg_b, pc_read8 ())&0xff;
            // dont care analog
            cycles.intValue += 2;
            break;
        case 0xdb:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_add8 (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xeb:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            reg_b = inst_add8 (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 4;
            break;
        case 0xfb:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            reg_b = inst_add8 (reg_b, read8 (ea))&0xff;
            vecx.vectrexNonCPUStep(1);
            cycles.intValue += 5;
            break;
            /* subd */
        case 0x83:
            set_reg_d (inst_sub16 (get_reg_d (), pc_read16 ()));
            // dont care analog
            cycles.intValue += 4;
            break;
        case 0x93:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            set_reg_d (inst_sub16 (get_reg_d (), read16 (ea)));
            vecx.vectrexNonCPUStep(2);
            cycles.intValue += 6;
            break;
        case 0xa3:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            set_reg_d (inst_sub16 (get_reg_d (), read16 (ea)));
            vecx.vectrexNonCPUStep(2);
            cycles.intValue += 6;
            break;
        case 0xb3:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            set_reg_d (inst_sub16 (get_reg_d (), read16 (ea)));
            vecx.vectrexNonCPUStep(2);
            cycles.intValue += 7;
            break;
            /* cmpx */
        case 0x8c:
            inst_sub16 (reg_x, pc_read16 ());
            // dont care analog
            cycles.intValue += 4;
            break;
        case 0x9c:
            ea = ea_direct ();
            inst_sub16 (reg_x, read16 (ea));
            // dont care analog
            cycles.intValue += 6;
            break;
        case 0xac:
            ea = ea_indexed (cycles);
            inst_sub16 (reg_x, read16 (ea));
            // dont care analog
            cycles.intValue += 6;
            break;
        case 0xbc:
            ea = ea_extended ();
            inst_sub16 (reg_x, read16 (ea));
            // dont care analog
            cycles.intValue += 7;
            break;
            /* ldx */
        case 0x8e:
            reg_x = pc_read16 ();
            inst_tst16 (reg_x);
            // dont care analog
            cycles.intValue += 3;
            break;
        case 0x9e:
            ea = ea_direct ();
            reg_x = read16 (ea);
            // dont care analog
            inst_tst16 (reg_x);
            cycles.intValue += 5;
            break;
        case 0xae:
            ea = ea_indexed (cycles);
            reg_x = read16 (ea);
            inst_tst16 (reg_x);
            // dont care analog
            cycles.intValue += 5;
            break;
        case 0xbe:
            ea = ea_extended ();
            reg_x = read16 (ea);
            inst_tst16 (reg_x);
            // dont care analog
            cycles.intValue += 6;
            break;
            /* ldu */
        case 0xce:
            reg_u.intValue = pc_read16 ();
            inst_tst16 (reg_u.intValue);
            // dont care analog
            cycles.intValue += 3;
            break;
        case 0xde:
            ea = ea_direct ();
            reg_u.intValue = read16 (ea);
            inst_tst16 (reg_u.intValue);
            // dont care analog
            cycles.intValue += 5;
            break;
        case 0xee:
            ea = ea_indexed (cycles);
            reg_u.intValue = read16 (ea);
            inst_tst16 (reg_u.intValue);
            // dont care analog
            cycles.intValue += 5;
            break;
        case 0xfe:
            ea = ea_extended ();
            reg_u.intValue = read16 (ea);
            inst_tst16 (reg_u.intValue);
            // dont care analog
            cycles.intValue += 6;
            break;
            /* stx */
        case 0x9f:
            ea = ea_direct ();
            write16 (ea, reg_x);
            inst_tst16 (reg_x);
            // dont care analog
            cycles.intValue += 5;
            break;
        case 0xaf:
            ea = ea_indexed (cycles);
            write16 (ea, reg_x);
            inst_tst16 (reg_x);
            // dont care analog
            cycles.intValue += 5;
            break;
        case 0xbf:
            ea = ea_extended ();
            write16 (ea, reg_x);
            // dont care analog
            inst_tst16 (reg_x);
            cycles.intValue += 6;
            break;
            /* stu */
        case 0xdf:
            ea = ea_direct ();
            write16 (ea, reg_u.intValue);
            // dont care analog
            inst_tst16 (reg_u.intValue);
            cycles.intValue += 5;
            break;
        case 0xef:
            ea = ea_indexed (cycles);
            write16 (ea, reg_u.intValue);
            // dont care analog
            inst_tst16 (reg_u.intValue);
            cycles.intValue += 5;
            break;
        case 0xff:
            ea = ea_extended ();
            write16 (ea, reg_u.intValue);
            // dont care analog
            inst_tst16 (reg_u.intValue);
            cycles.intValue += 6;
            break;
            /* addd */
        case 0xc3:
            set_reg_d (inst_add16 (get_reg_d (), pc_read16 ()));
            // dont care analog
            cycles.intValue += 4;
            break;
        case 0xd3:
            ea = ea_direct ();
            set_reg_d (inst_add16 (get_reg_d (), read16 (ea)));
            // dont care analog
            cycles.intValue += 6;
            break;
        case 0xe3:
            ea = ea_indexed (cycles);
            set_reg_d (inst_add16 (get_reg_d (), read16 (ea)));
            // dont care analog
            cycles.intValue += 6;
            break;
        case 0xf3:
            ea = ea_extended ();
            set_reg_d (inst_add16 (get_reg_d (), read16 (ea)));
            // dont care analog
            cycles.intValue += 7;
            break;
            /* ldd */
        case 0xcc:
            set_reg_d (pc_read16 ());
            // dont care analog
            inst_tst16 (get_reg_d ());
            cycles.intValue += 3;
            break;
        case 0xdc:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(2+1);
            set_reg_d (read16 (ea, true));
            vecx.vectrexNonCPUStep(1);
            inst_tst16 (get_reg_d ());
            cycles.intValue += 5;
            break;
        case 0xec:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(2+1);
            set_reg_d (read16 (ea, true));
            vecx.vectrexNonCPUStep(1);
            inst_tst16 (get_reg_d ());
            cycles.intValue += 5;
            break;
        case 0xfc:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(3+1);
            set_reg_d (read16 (ea, true));
            vecx.vectrexNonCPUStep(1);
            inst_tst16 (get_reg_d ());
            cycles.intValue += 6;
            break;
            /* std */
        case 0xdd:
            ea = ea_direct ();
            vecx.vectrexNonCPUStep(3+1);
            write16 (ea, get_reg_d (), true);
            
            inst_tst16 (get_reg_d ());
            cycles.intValue += 5;
            break;
        case 0xed:
            ea = ea_indexed (cycles);
            vecx.vectrexNonCPUStep(3+1);
            write16 (ea, get_reg_d (), true);
            
            inst_tst16 (get_reg_d ());
            cycles.intValue += 5;
            break;
        case 0xfd:
            ea = ea_extended ();
            vecx.vectrexNonCPUStep(4+1);
            write16 (ea, get_reg_d (), true);
            
            inst_tst16 (get_reg_d ());
            cycles.intValue += 6;
            break;
            /* nop */
        case 0x12:
            // dont care analog
            cycles.intValue += 2;
            break;
            /* mul */
        case 0x3d:
            r = (reg_a & 0xff) * (reg_b & 0xff);
            set_reg_d (r);
            
            set_cc (FLAG_Z, test_z16 (r));
            set_cc (FLAG_C, (r >> 7) & 1);
            
            // dont care analog
            cycles.intValue += 11;
            break;
            /* bra */
        case 0x20:
            /* brn */
        case 0x21:
            // dont care analog
            inst_bra8 (0, op, cycles);
            break;
            /* bhi */
        case 0x22:
            /* bls */
        case 0x23:
            // dont care analog
            inst_bra8 (get_cc (FLAG_C) | get_cc (FLAG_Z), op, cycles);
            break;
            /* bhs/bcc */
        case 0x24:
            /* blo/bcs */
        case 0x25:
            // dont care analog
            inst_bra8 (get_cc (FLAG_C), op, cycles);
            break;
            /* bne */
        case 0x26:
            /* beq */
        case 0x27:
            // dont care analog
            inst_bra8 (get_cc (FLAG_Z), op, cycles);
            break;
            /* bvc */
        case 0x28:
            /* bvs */
        case 0x29:
            inst_bra8 (get_cc (FLAG_V), op, cycles);
            break;
            /* bpl */
        case 0x2a:
            /* bmi */
        case 0x2b:
            inst_bra8 (get_cc (FLAG_N), op, cycles);
            break;
            /* bge */
        case 0x2c:
            /* blt */
        case 0x2d:
            // dont care analog
            inst_bra8 (get_cc (FLAG_N) ^ get_cc (FLAG_V), op, cycles);
            break;
            /* bgt */
        case 0x2e:
            /* ble */
        case 0x2f:
            // dont care analog
            inst_bra8 (get_cc (FLAG_Z) | (get_cc (FLAG_N) ^ get_cc (FLAG_V)), op, cycles);
            break;
            /* lbra */
        case 0x16:
            // dont care analog
            r = pc_read16 ();
            reg_pc = (reg_pc+r)&0xffff;
            
            cycles.intValue += 5;
            break;
            /* lbsr */
        case 0x17:
            r = pc_read16 ();
            push16 (reg_s, reg_pc);
            synchronized (callStack)
            {
                callStack.add(reg_pc & 0xffff);
            }
            reg_pc = (reg_pc+r)&0xffff;
            // dont care analog
            cycles.intValue += 9;
            break;
            /* bsr */
        case 0x8d:
            r = pc_read8 ();
            push16 (reg_s, reg_pc);
            synchronized (callStack)
            {
                callStack.add(reg_pc & 0xffff);
            }
            if (profiler != null)
            {
                profiler.addContext(((reg_pc+sign_extend (r))&0xffff), reg_s.intValue, reg_pc & 0xffff);
            }
            // dont care analog
            reg_pc = (reg_pc+sign_extend (r))&0xffff;
            cycles.intValue += 7;
            break;
            /* jsr */
        case 0x9d:
            ea = ea_direct ();
            push16 (reg_s, reg_pc);
            synchronized (callStack)
            {
                callStack.add(reg_pc & 0xffff);
            }
            if (profiler != null)
            {
                profiler.addContext(ea, reg_s.intValue, reg_pc & 0xffff);
            }
            // dont care analog
            reg_pc = ea;
            cycles.intValue += 7;
            break;
        case 0xad:
            ea = ea_indexed (cycles);
            push16 (reg_s, reg_pc);
            synchronized (callStack)
            {
                callStack.add(reg_pc & 0xffff);
            }
            if (profiler != null)
            {
                profiler.addContext(ea, reg_s.intValue, reg_pc & 0xffff);
            }
            // dont care analog
            reg_pc = ea;
            cycles.intValue += 7;
            break;
        case 0xbd:
            ea = ea_extended ();
            push16 (reg_s, reg_pc);
            synchronized (callStack)
            {
                callStack.add(reg_pc & 0xffff);
            }
            if (profiler != null)
            {
                profiler.addContext(ea, reg_s.intValue, reg_pc & 0xffff);
            }
            // dont care analog
            reg_pc = ea;
            cycles.intValue += 8;
            break;
            /* leax */
        case 0x30:
            reg_x = ea_indexed (cycles);
            // dont care analog
            set_cc (FLAG_Z, test_z16 (reg_x));
            cycles.intValue += 4;
            break;
            /* leay */
        case 0x31:
            reg_y = ea_indexed (cycles);
            // dont care analog
            set_cc (FLAG_Z, test_z16 (reg_y));
            cycles.intValue += 4;
            break;
            /* leas */
        case 0x32:
            reg_s.intValue = ea_indexed (cycles);
            // dont care analog
            cycles.intValue += 4;
            break;
            /* leau */
        case 0x33:
            reg_u.intValue = ea_indexed (cycles);
            // dont care analog
            cycles.intValue += 4;
            break;
            /* pshs */
        case 0x34:
            inst_psh (pc_read8 (), reg_s, reg_u, cycles);
            cycles.intValue += 5;
            // dont care analog
            break;
            /* puls */
        case 0x35:
            inst_pul (pc_read8 (), reg_s, reg_u, cycles);
            cycles.intValue += 5;
            // dont care analog
            break;
            /* pshu */
        case 0x36:
            inst_psh (pc_read8 (), reg_u, reg_s, cycles);
            cycles.intValue += 5;
            // dont care analog
            break;
            /* pulu */
        case 0x37:
            inst_pul (pc_read8 (), reg_u, reg_s, cycles);
            cycles.intValue += 5;
            // dont care analog
            break;
            /* rts */
        case 0x39:
            reg_pc = pull16 (reg_s);
            synchronized (callStack)
            {
                if (callStack.size()>0) callStack.remove(callStack.size()-1);
            }
            // dont care analog
            cycles.intValue += 5;
            break;
            /* abx */
        case 0x3a:
            reg_x += reg_b & 0xff;
            cycles.intValue += 3;
            // dont care analog
            break;
            /* orcc */
        case 0x1a:
            reg_cc |= pc_read8 ();
            // dont care analog
            cycles.intValue += 3;
            break;
            /* andcc */
        case 0x1c:
            reg_cc &= pc_read8 ();
            // dont care analog
            cycles.intValue += 3;
            break;
            /* sex */
        case 0x1d:
            set_reg_d (sign_extend (reg_b));
            set_cc (FLAG_N, test_n (reg_a));
            set_cc (FLAG_Z, test_z16 (get_reg_d ()));
            // dont care analog
            cycles.intValue += 2; 
            break;
            /* exg */
        case 0x1e:
            inst_exg ();
            // dont care analog
            cycles.intValue += 8;
            break;
            /* tfr */
        case 0x1f:
            inst_tfr ();
            // dont care analog
            cycles.intValue += 6;
            break;
            /* rti */
        case 0x3b:
            inst_pul (0x01, reg_s, reg_u, cycles);
            if ((get_cc (FLAG_E)) !=0)
            {
                inst_pul (0xfe, reg_s, reg_u, cycles);
            } 
            else 
            {
                inst_pul (0x80, reg_s, reg_u, cycles);
            }
            
            // dont care analog
            cycles.intValue += 3;
            break;
            /* swi */
        case 0x3f:
            set_cc (FLAG_E, 1);
            inst_psh (0xff, reg_s, reg_u, cycles);
            set_cc (FLAG_I, 1);
            set_cc (FLAG_F, 1);
            reg_pc = read16 (0xfffa);
            // dont care analog
            cycles.intValue += 7;
            break;
            /* sync */
        case 0x13:
            irq_status = IRQ_SYNC;
            cycles.intValue += 2;
            // dont care analog
            break;
            /* daa */
        case 0x19:
            i0 = reg_a;
            i1 = 0;
            
            if ((reg_a & 0x0f) > 0x09 || get_cc (FLAG_H) == 1) {
                i1 |= 0x06;
            }
            
            if ((reg_a & 0xf0) > 0x80 && (reg_a & 0x0f) > 0x09) {
                i1 |= 0x60;
            }
            
            if ((reg_a & 0xf0) > 0x90 || get_cc (FLAG_C) == 1) {
                i1 |= 0x60;
            }
            
            reg_a = (i0 + i1)&0xff;
            
            set_cc (FLAG_N, test_n (reg_a));
            set_cc (FLAG_Z, test_z8 (reg_a));
            set_cc (FLAG_V, 0);
            set_cc (FLAG_C, test_c (i0, i1, reg_a, 0));
            // dont care analog
            cycles.intValue += 2;
            break;
            /* cwai */
        case 0x3c:
/*            
// malban seeking Polar Rescue!            
byte tmp = (byte)pc_read8 ();
set_cc (FLAG_E, 1);
inst_psh (0xff, reg_s, reg_u, cycles);
irq_status = IRQ_CWAI;
reg_cc &= tmp;

            // dont care analog
            cycles.intValue += 4;
*/
            reg_cc &= pc_read8 ();
            set_cc (FLAG_E, 1);
            inst_psh (0xff, reg_s, reg_u, cycles);
            irq_status = IRQ_CWAI;
            // dont care analog
            cycles.intValue += 4;
  
                    break;
            
            /* page 1 instructions */
            
        case 0x10:
            op = pc_read8 ();
            vecx.vectrexNonCPUStep(2);
            
            switch (op) {
                    /* lbra */
                case 0x20:
                    /* lbrn */
                case 0x21:
                    inst_bra16 (0, op, cycles);
                    break;
                    /* lbhi */
                case 0x22:
                    /* lbls */
                case 0x23:
                    inst_bra16 (get_cc (FLAG_C) | get_cc (FLAG_Z), op, cycles);
                    break;
                    /* lbhs/lbcc */
                case 0x24:
                    /* lblo/lbcs */
                case 0x25:
                    inst_bra16 (get_cc (FLAG_C), op, cycles);
                    break;
                    /* lbne */
                case 0x26:
                    /* lbeq */
                case 0x27:
                    inst_bra16 (get_cc (FLAG_Z), op, cycles);
                    break;
                    /* lbvc */
                case 0x28:
                    /* lbvs */
                case 0x29:
                    inst_bra16 (get_cc (FLAG_V), op, cycles);
                    break;
                    /* lbpl */
                case 0x2a:
                    /* lbmi */
                case 0x2b:
                    inst_bra16 (get_cc (FLAG_N), op, cycles);
                    break;
                    /* lbge */
                case 0x2c:
                    /* lblt */
                case 0x2d:
                    inst_bra16 (get_cc (FLAG_N) ^ get_cc (FLAG_V), op, cycles);
                    break;
                    /* lbgt */
                case 0x2e:
                    /* lble */
                case 0x2f:
                    inst_bra16 (get_cc (FLAG_Z) |
                                (get_cc (FLAG_N) ^ get_cc (FLAG_V)), op, cycles);
                    break;
                    /* cmpd */
                case 0x83:
                    inst_sub16 (get_reg_d (), pc_read16 ());
                    // dont care analog
                    cycles.intValue += 5;
                    break;
                case 0x93:
                    ea = ea_direct ();
                    vecx.vectrexNonCPUStep(4+1);
                    inst_sub16 (get_reg_d (), read16 (ea, true));
                    
                    vecx.vectrexNonCPUStep(1);
                    cycles.intValue += 7;
                    break;
                case 0xa3:
                    ea = ea_indexed (cycles);
                    vecx.vectrexNonCPUStep(4+1);
                    inst_sub16 (get_reg_d (), read16 (ea, true));
                    
                    vecx.vectrexNonCPUStep(1);
                    cycles.intValue += 7;
                    break;
                case 0xb3:
                    ea = ea_extended ();
                    vecx.vectrexNonCPUStep(5+1);
                    inst_sub16 (get_reg_d (), read16 (ea, true));
                    
                    vecx.vectrexNonCPUStep(1);
                    cycles.intValue += 8;
                    break;
                    /* cmpy */
                case 0x8c:
                    inst_sub16 (reg_y, pc_read16 ());
                    // dont care analog
                    cycles.intValue += 5;
                    break;
                case 0x9c:
                    ea = ea_direct ();
                    inst_sub16 (reg_y, read16 (ea));
                    // dont care analog
                    cycles.intValue += 7;
                    break;
                case 0xac:
                    ea = ea_indexed (cycles);
                    // dont care analog
                    inst_sub16 (reg_y, read16 (ea));
                    cycles.intValue += 7;
                    break;
                case 0xbc:
                    ea = ea_extended ();
                    inst_sub16 (reg_y, read16 (ea));
                    // dont care analog
                    cycles.intValue += 8;
                    break;
                    /* ldy */
                case 0x8e:
                    reg_y = pc_read16 ();
                    // dont care analog
                    inst_tst16 (reg_y);
                    cycles.intValue += 4;
                    break;
                case 0x9e:
                    ea = ea_direct ();
                    reg_y = read16 (ea);
                    // dont care analog
                    inst_tst16 (reg_y);
                    cycles.intValue += 6;
                    break;
                case 0xae:
                    ea = ea_indexed (cycles);
                    reg_y = read16 (ea);
                    // dont care analog
                    inst_tst16 (reg_y);
                    cycles.intValue += 6;
                    break;
                case 0xbe:
                    ea = ea_extended ();
                    reg_y = read16 (ea);
                    // dont care analog
                    inst_tst16 (reg_y);
                    cycles.intValue += 7;
                    break;
                    /* sty */
                case 0x9f:
                    ea = ea_direct ();
                    write16 (ea, reg_y);
                    inst_tst16 (reg_y);
                    cycles.intValue += 6;
                    // dont care analog
                    break;
                case 0xaf:
                    ea = ea_indexed (cycles);
                    write16 (ea, reg_y);
                    // dont care analog
                    inst_tst16 (reg_y);
                    cycles.intValue += 6;
                    break;
                case 0xbf:
                    ea = ea_extended ();
                    write16 (ea, reg_y);
                    // dont care analog
                    inst_tst16 (reg_y);
                    cycles.intValue += 7;
                    break;
                    /* lds */
                case 0xce:
                    reg_s.intValue = pc_read16 ();
                    // dont care analog
                    inst_tst16 (reg_s.intValue);
                    cycles.intValue += 4;
                    resetCallstack();
                    break;
                case 0xde:
                    ea = ea_direct ();
                    reg_s.intValue = read16 (ea);
                    // dont care analog
                    inst_tst16 (reg_s.intValue);
                    cycles.intValue += 6;
                    resetCallstack();
                    break;
                case 0xee:
                    ea = ea_indexed (cycles);
                    reg_s.intValue = read16 (ea);
                    // dont care analog
                    inst_tst16 (reg_s.intValue);
                    cycles.intValue += 6;
                    resetCallstack();
                    break;
                case 0xfe:
                    ea = ea_extended ();
                    reg_s.intValue = read16 (ea);
                    // dont care analog
                    inst_tst16 (reg_s.intValue);
                    cycles.intValue += 7;
                    resetCallstack();
                    break;
                    /* sts */
                case 0xdf:
                    ea = ea_direct ();
                    write16 (ea, reg_s.intValue);
                    // dont care analog
                    inst_tst16 (reg_s.intValue);
                    cycles.intValue += 6;
                    break;
                case 0xef:
                    ea = ea_indexed (cycles);
                    write16 (ea, reg_s.intValue);
                    // dont care analog
                    inst_tst16 (reg_s.intValue);
                    cycles.intValue += 6;
                    break;
                case 0xff:
                    ea = ea_extended ();
                    write16 (ea, reg_s.intValue);
                    // dont care analog
                    inst_tst16 (reg_s.intValue);
                    cycles.intValue += 7;
                    break;
                    /* swi2 */
                case 0x3f:
                    set_cc (FLAG_E, 1);
                    inst_psh (0xff, reg_s, reg_u, cycles);
                    reg_pc = read16 (0xfff4);
                    // dont care analog
                    cycles.intValue += 8;
                    break;
                default:
                    System.out.println ("unknown page-1 op code: "+op+"\n");
                    break;
            }
            
            break;
            
            /* page 2 instructions */
            
        case 0x11:
            op = pc_read8 ();
            vecx.vectrexNonCPUStep(2);
            switch (op) {
                    /* cmpu */
                case 0x83:
                    inst_sub16 (reg_u.intValue, pc_read16 ());
                    // dont care analog
                    cycles.intValue += 5;
                    break;
                case 0x93:
                    ea = ea_direct ();
                    inst_sub16 (reg_u.intValue, read16 (ea));
                    // dont care analog
                    cycles.intValue += 7;
                    break;
                case 0xa3:
                    ea = ea_indexed (cycles);
                    inst_sub16 (reg_u.intValue, read16 (ea));
                    // dont care analog
                    cycles.intValue += 7;
                    break;
                case 0xb3:
                    ea = ea_extended ();
                    inst_sub16 (reg_u.intValue, read16 (ea));
                    // dont care analog
                    cycles.intValue += 8;
                    break;
                    /* cmps */
                case 0x8c:
                    inst_sub16 (reg_s.intValue, pc_read16 ());
                    // dont care analog
                    cycles.intValue += 5;
                    break;
                case 0x9c:
                    ea = ea_direct ();
                    inst_sub16 (reg_s.intValue, read16 (ea));
                    // dont care analog
                    cycles.intValue += 7;
                    break;
                case 0xac:
                    ea = ea_indexed (cycles);
                    inst_sub16 (reg_s.intValue, read16 (ea));
                    // dont care analog
                    cycles.intValue += 7;
                    break;
                case 0xbc:
                    ea = ea_extended ();
                    inst_sub16 (reg_s.intValue, read16 (ea));
                    // dont care analog
                    cycles.intValue += 8;
                    break;
                    /* swi3 */
                case 0x3f:
                    set_cc (FLAG_E, 1);
                    inst_psh (0xff, reg_s, reg_u, cycles);
                    reg_pc = read16 (0xfff2);
                    cycles.intValue += 8;
                    break;
                default:
                    System.out.println ("unknown page-2 op code: "+op+"\n");
                    break;
            }
            
            break;
            
        default:
            System.out.println ("unknown page-0 op code: "+op+"PC: "+reg_pc+"\n");
            break;
	}
        cyclesRunning += cycles.intValue;
	return cycles.intValue;
    }

}