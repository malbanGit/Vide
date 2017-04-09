/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.libayemu;

/**
 *
 * @author Sashnov Alexander / Roman Scherbakov, Java port: malban
 */
public class SndFmt {
	
    private int freq=44100;		/*< sound freq */
    private int channels=1;	/*< channels (1-mono, 2-stereo) */

		

    /**
     * @return the freq
     */
    public int getFreq() {
        return freq;
    }

    /**
     * @param freq the freq to set
     */
    public boolean setFreq(int freq) {
        if(freq<50)
        {
 //                throw new ArgumentException("Output sound frequency must be higher than 50.");
            this.freq =44100;
            return false;
        }
        this.freq = freq;
        return true;
    }

    /**
     * @return the channels
     */
    public int getChannels() {
        return channels;
    }

    /**
     * @param channels the channels to set
     */
    public boolean setChannels(int channels) {

				if(!(channels==1 || channels==2))
				{
                                    this.channels = 1;
//					throw new ArgumentException("Incorrect number of channels. Values supported are 1 (Mono) or 2 (Stereo).");
                                    return false;
				}
        
        this.channels = channels;
        return true;
    }
	
}
