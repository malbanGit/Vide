/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx;

/**
 *
 * @author malban
 */
public interface E6809Statics {

    public static final int FLAG_E	= 0x80;
    public static final int FLAG_F	= 0x40;
    public static final int FLAG_H	= 0x20;
    public static final int FLAG_I	= 0x10;
    public static final int FLAG_N	= 0x08;
    public static final int FLAG_Z	= 0x04;
    public static final int FLAG_V	= 0x02;
    public static final int FLAG_C	= 0x01;
    public static final int IRQ_NORMAL	= 0;
    public static final int IRQ_SYNC	= 1;
    public static final int IRQ_CWAI	= 2;
}
