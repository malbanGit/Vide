/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.extractor;


// http://atariage.com/forums/topic/103270-vec-fu-my-homebrew-kungfu-game-for-the-vectrex/page-2
// It emulates the VecVoice (or VecVox in VecVoice mode), it does this using a set of SPO256 (speech chip) sounds samples. 
// Works quite well, but the Speakjet based VecVox/x is much more flexible (Franck thinks emulation is nearly impossible).
// http://little-scale.blogspot.de/2009/02/sp0256-al2-creative-commons-sample-pack.html

// https://www.sparkfun.com/products/9578
// http://atariage.com/forums/topic/88811-emulating-the-atarivox/

public class Phonem {
    private final int index;
    private final String name;
    private int[] data1;
    private int[] data2;
    private int[] data4;

    Phonem(int n, String string) {
        this.index = n;
        this.name = string;
    }

    final void setData1(int[] arrn, int n, int n2) {
        this.data1 = new int[n2 * 1];
        this.data2 = new int[n2 * 2];
        this.data4 = new int[n2 * 4];
        System.arraycopy(arrn, n, this.data1, 0, n2);
        int n3 = 0;
        while (n3 < n2) {
            int n4;
            this.data2[2 * n3] = n4 = arrn[n3];
            this.data2[2 * n3 + 1] = n4;
            this.data4[4 * n3] = n4;
            this.data4[4 * n3 + 1] = n4;
            this.data4[4 * n3 + 2] = n4;
            this.data4[4 * n3 + 3] = n4;
            ++n3;
        }
        System.arraycopy(arrn, n, this.data1, 0, n2);
    }

    public final String getName() {
        return this.name;
    }

    public final int getIndex() {
        return this.index;
    }

    public final int getDataLength(int n) {
        return this.data1.length * n;
    }

    public final int[] getData(int n) {
        switch (n) {
            case 1: {
                return this.data1;
            }
            case 2: {
                return this.data2;
            }
            case 4: {
                return this.data4;
            }
        }
        throw new RuntimeException("Invalid sample rate multiplier : " + n);
    }
}
