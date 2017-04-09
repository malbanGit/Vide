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
	public class RegData
	{
		private int tone_a;		    /*< R0, R1 */
		private int tone_b;			/*< R2, R3 */	
		private int tone_c;			/*< R4, R5 */
		private int noise;			/*< R6 */
		private int R7_tone_a;		/*< R7 bit 0 */
		private int R7_tone_b;		/*< R7 bit 1 */
		private int R7_tone_c;		/*< R7 bit 2 */
		private int R7_noise_a;	/*< R7 bit 3 */
		private int R7_noise_b;	/*< R7 bit 4 */
		private int R7_noise_c;	/*< R7 bit 5 */
		private int vol_a;			/*< R8 bits 3-0 */
		private int vol_b;			/*< R9 bits 3-0 */
		private int vol_c;			/*< R10 bits 3-0 */
		private int env_a;			/*< R8 bit 4 */
		private int env_b;			/*< R9 bit 4 */
		private int env_c;			/*< R10 bit 4 */
		private int env_freq;		/*< R11, R12 */
		private int env_style;		/*< R13 */

		public RegData()
		{
		}

    /**
     * @return the tone_a
     */
    public int getTone_a() {
        return tone_a;
    }

    /**
     * @param tone_a the tone_a to set
     */
    public void setTone_a(int tone_a) {
        this.tone_a = tone_a;
    }

    /**
     * @return the tone_b
     */
    public int getTone_b() {
        return tone_b;
    }

    /**
     * @param tone_b the tone_b to set
     */
    public void setTone_b(int tone_b) {
        this.tone_b = tone_b;
    }

    /**
     * @return the tone_c
     */
    public int getTone_c() {
        return tone_c;
    }

    /**
     * @param tone_c the tone_c to set
     */
    public void setTone_c(int tone_c) {
        this.tone_c = tone_c;
    }

    /**
     * @return the noise
     */
    public int getNoise() {
        return noise;
    }

    /**
     * @param noise the noise to set
     */
    public void setNoise(int noise) {
        this.noise = noise;
    }

    /**
     * @return the R7_tone_a
     */
    public int getR7_tone_a() {
        return R7_tone_a;
    }

    /**
     * @param R7_tone_a the R7_tone_a to set
     */
    public void setR7_tone_a(int R7_tone_a) {
        this.R7_tone_a = R7_tone_a;
    }

    /**
     * @return the R7_tone_b
     */
    public int getR7_tone_b() {
        return R7_tone_b;
    }

    /**
     * @param R7_tone_b the R7_tone_b to set
     */
    public void setR7_tone_b(int R7_tone_b) {
        this.R7_tone_b = R7_tone_b;
    }

    /**
     * @return the R7_tone_c
     */
    public int getR7_tone_c() {
        return R7_tone_c;
    }

    /**
     * @param R7_tone_c the R7_tone_c to set
     */
    public void setR7_tone_c(int R7_tone_c) {
        this.R7_tone_c = R7_tone_c;
    }

    /**
     * @return the R7_noise_a
     */
    public int getR7_noise_a() {
        return R7_noise_a;
    }

    /**
     * @param R7_noise_a the R7_noise_a to set
     */
    public void setR7_noise_a(int R7_noise_a) {
        this.R7_noise_a = R7_noise_a;
    }

    /**
     * @return the R7_noise_b
     */
    public int getR7_noise_b() {
        return R7_noise_b;
    }

    /**
     * @param R7_noise_b the R7_noise_b to set
     */
    public void setR7_noise_b(int R7_noise_b) {
        this.R7_noise_b = R7_noise_b;
    }

    /**
     * @return the R7_noise_c
     */
    public int getR7_noise_c() {
        return R7_noise_c;
    }

    /**
     * @param R7_noise_c the R7_noise_c to set
     */
    public void setR7_noise_c(int R7_noise_c) {
        this.R7_noise_c = R7_noise_c;
    }

    /**
     * @return the vol_a
     */
    public int getVol_a() {
        return vol_a;
    }

    /**
     * @param vol_a the vol_a to set
     */
    public void setVol_a(int vol_a) {
        this.vol_a = vol_a;
    }

    /**
     * @return the vol_b
     */
    public int getVol_b() {
        return vol_b;
    }

    /**
     * @param vol_b the vol_b to set
     */
    public void setVol_b(int vol_b) {
        this.vol_b = vol_b;
    }

    /**
     * @return the vol_c
     */
    public int getVol_c() {
        return vol_c;
    }

    /**
     * @param vol_c the vol_c to set
     */
    public void setVol_c(int vol_c) {
        this.vol_c = vol_c;
    }

    /**
     * @return the env_a
     */
    public int getEnv_a() {
        return env_a;
    }

    /**
     * @param env_a the env_a to set
     */
    public void setEnv_a(int env_a) {
        this.env_a = env_a;
    }

    /**
     * @return the env_b
     */
    public int getEnv_b() {
        return env_b;
    }

    /**
     * @param env_b the env_b to set
     */
    public void setEnv_b(int env_b) {
        this.env_b = env_b;
    }

    /**
     * @return the env_c
     */
    public int getEnv_c() {
        return env_c;
    }

    /**
     * @param env_c the env_c to set
     */
    public void setEnv_c(int env_c) {
        this.env_c = env_c;
    }

    /**
     * @return the env_freq
     */
    public int getEnv_freq() {
        return env_freq;
    }

    /**
     * @param env_freq the env_freq to set
     */
    public void setEnv_freq(int env_freq) {
        this.env_freq = env_freq;
    }

    /**
     * @return the env_style
     */
    public int getEnv_style() {
        return env_style;
    }

    /**
     * @param env_style the env_style to set
     */
    public void setEnv_style(int env_style) {
        this.env_style = env_style;
    }

        }