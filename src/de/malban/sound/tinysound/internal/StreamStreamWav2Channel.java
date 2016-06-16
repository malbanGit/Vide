
package de.malban.sound.tinysound.internal;


import de.malban.sound.tinysound.Stream;
import static de.malban.vide.vedi.sound.ibxm.IBXM.IBXM_MAXBUFFER;

/**
 * Thes StreamSound class is an implementation of the Stream interface that
 * streams audio data from a temporary file to reduce memory overhead.
 * 
 * @author 
 */
public class StreamStreamWav2Channel implements Stream {
	
	private Mixer mixer;
	private final int ID;
        private int inputFormat;
        double volume = 1.0;
        StreamStreamReference ref;

        /**
	 * Construct a new StreamSound with the given data and Mixer which will
	 * handle this StreamSound.

         * @param mixer Mixer that will handle this StreamSound
	 * @param id unique ID of this StreamSound
	 */
	public StreamStreamWav2Channel(Mixer mixer, int id, int inputFormat)  
        {
            this.mixer = mixer;
            this.ID = id;
            this.inputFormat = inputFormat;

            ref = new StreamStreamReference(volume, 0, this.ID, inputFormat);
        }
        public void start()
        {
            this.mixer.registerStreamReference(ref);
        }

        public int available()
        {
            return ref.available();
        }
        
        // in opposite to a "real" audio line, this one does not block!
        // 16 bit signed, 2 channel 
        public int write(byte[] soundBytes, int offset, int soundLength)
        {
            return ref.write(soundBytes,  offset,  soundLength);
        }
	/**
	 * Stops this StreamSound from playing.  Note that if this StreamSound was
	 * played repeatedly in an overlapping fashion, all instances of this
	 * StreamSound still playing will be stopped.
	 */
	@Override
	public void stop() {
		this.mixer.unRegisterStreamReference(this.ID);
	}

	/**
	 * Unloads this StreamSound from the system.  Attempts to use this
	 * StreamSound after unloading will result in error.
	 */
	@Override
	public void unload() {
		this.mixer.unRegisterStreamReference(this.ID);
		this.mixer = null;
	}
	
        @Override
	public void setVolume(double v) {
		volume = v;
                if (ref == null) return;
                ref.setVolume(volume);
                
        }
	/////////////
	//Reference//
	/////////////
	
	/**
	 * The StreamSoundReference class is an implementation of the StreamReference
	 * interface.
	 * 
	 * @Finn Kuusisto
	 */
	public class StreamStreamReference implements StreamReference 
        {
		public final int SOUND_ID;
		
		private double volume;
		private double pan;
		private byte[] buf;
                private byte[] inbuffer = new byte[IBXM_MAXBUFFER];
                byte[] outBuffer = new byte[IBXM_MAXBUFFER];

                int inbufferUsed = 0;       // in real bytes
                private int bytesInBuffer;  // in real bytes
                int posInOutBuffer;         // in real bytes
                int outBufferAvailable = 0; // in real bytes

                // so many data bytes can be "written" to the stream
                synchronized public int available()
                {
                    return inbuffer.length-inbufferUsed;
                }

                // 16 bit signed, 2 channel expected 
                // this line is "compatible" to a sourceline 
                // only: in opposite to a "real" audio line, this one does not block!
                // the data received is buffered, till it is requested by the tinysound updater
                // than it will be "prepared" for tinySound
                synchronized public int write(byte[] soundBytes, int offset, int soundLength)
                {
                    if (soundLength == 0) return 0;
                    if (soundLength+inbufferUsed>inbuffer.length)
                        soundLength = inbuffer.length-inbufferUsed;
                    if (soundLength == 0) return 0;
                    System.arraycopy(soundBytes, offset, inbuffer, inbufferUsed, soundLength-1);
                    inbufferUsed += soundLength;
                    return soundLength;
                }
                
                static final int TINYSOUND_FRAME_LENGTH = 4;
                static final int MOD_FRAME_LENGTH = 4;
                // prepare read
                // converts the mod 16 bit signed, two channel data [BigEndian]
                // to 16 bit, 2 channel data [little Endian]
                // the updater of tinysound expects that format!
                // count is the number of (frames*(frameLength of expected format)) [= 4 bytes] to prepare (one mod frame = 4 byte)
                // output buffer is updated with 4 bytes of each mod frame to 4 bytes output for target frame
                public int prepareRead(int countInTinySoundFramesBytes)
                {
                    int countInModFrames = countInTinySoundFramesBytes /(TINYSOUND_FRAME_LENGTH);

                    // outbuffer is allways used from pos 0
                    // data will be read soon, prepare

                    // if given count > outbuffer, than max it to outbuffer length
                    if (countInModFrames*MOD_FRAME_LENGTH >outBuffer.length) 
                    {
                        countInModFrames = outBuffer.length/MOD_FRAME_LENGTH;
                    }
                    
                    if (countInModFrames*MOD_FRAME_LENGTH >inbufferUsed) 
                    {
                        countInModFrames = inbufferUsed/MOD_FRAME_LENGTH;
                    }
                    if (countInModFrames == 0) 
                    {
                        return 0;
                    }
                    for (int i=0; i<countInModFrames*MOD_FRAME_LENGTH; i+=MOD_FRAME_LENGTH)
                    {
                        // left channel
                        this.outBuffer[0+i*(TINYSOUND_FRAME_LENGTH/MOD_FRAME_LENGTH)] = (byte)(inbuffer[i+0]&0xff); //LSB
                        this.outBuffer[1+i*(TINYSOUND_FRAME_LENGTH/MOD_FRAME_LENGTH)] = (byte)(inbuffer[i+1]&0xff); //MSB
                        
                        // right channel
                        this.outBuffer[2+i*(TINYSOUND_FRAME_LENGTH/MOD_FRAME_LENGTH)] = (byte)(inbuffer[i+2]&0xff); //LSB
                        this.outBuffer[3+i*(TINYSOUND_FRAME_LENGTH/MOD_FRAME_LENGTH)] = (byte)(inbuffer[i+3]&0xff); //MSB
                    }              
                    posInOutBuffer=0;
                    outBufferAvailable = countInModFrames*(TINYSOUND_FRAME_LENGTH);
                    
                    // remove the just "used" data from the inbuffer
                    // (and keep the data we have not "used")
                    try
                    {
                        System.arraycopy(inbuffer, countInModFrames*MOD_FRAME_LENGTH, inbuffer,0 , inbuffer.length-(countInModFrames*MOD_FRAME_LENGTH)-1);
                    }
                    catch (Throwable e)
                    {
                        System.out.println("Buh");
                    }
                    inbufferUsed-=countInModFrames*MOD_FRAME_LENGTH;
                    return countInModFrames;
                    
                }                      
                
                
                
		/**
		 * Construct a new StreamSoundReference with the given reference data.
		 * @param volume volume at which to play the sound
		 * @param pan pan at which to play the sound
		 * @param soundID ID of the StreamSound for which this is a reference
		 */
		public StreamStreamReference( double volume, double pan, int soundID, int inputFormat) 
                {
			this.volume = (volume >= 0.0) ? volume : 1.0;
			this.pan = (pan >= -1.0 && pan <= 1.0) ? pan : 0.0;
			this.buf = new byte[4];
			this.SOUND_ID = soundID;
                        this.bytesInBuffer = 0;
		}
                // how many free bytes are available to put sound into

		/**
		 * Get the ID of the StreamSound that produced this
		 * StreamSoundReference.
		 * @return the ID of this StreamSoundReference's parent StreamSound
		 */
		@Override
		public int getSoundID() 
                {
                    return this.SOUND_ID;
		}

		/**
		 * Gets the volume of this StreamSoundReference.
		 * @return volume of this StreamSoundReference
		 */
		@Override
		public double getVolume() {
			return this.volume;
		}
                public void setVolume(double v) {
                        volume = v;
                }

		/**
		 * Gets the pan of this StreamSoundReference.
		 * @return pan of this StreamSoundReference
		 */
		@Override
		public double getPan() {
			return this.pan;
		}

                // how many bytes are available for the playback routine
                // prepare must be called befor!
		/**
		 * Get the number of bytes remaining for each channel.
		 * @return number of bytes remaining for each channel
		 */
		@Override
		public long bytesAvailable() {
                    return (outBufferAvailable - posInOutBuffer)/2;
		}		

		/**
		 * Skip a specified number of bytes of the audio data.
		 * @param num number of bytes to skip
		 */
		@Override
		public void skipBytes(long num) 
                {
                    if (num >inbufferUsed)
                    {
                        inbufferUsed = 0;
                        return;
                    }
                    System.arraycopy(inbuffer, (int)num, inbuffer,0 , inbuffer.length-(int)num-1);
                    inbufferUsed-=num;
                }
		
		/**
		 * Get the next two bytes from the sound data in the specified
		 * endianness.
		 * @param data length-2 array to write in next two bytes from each
		 * channel
		 * @param bigEndian true if the bytes should be read big-endian
		 */
		@Override
		synchronized public void nextTwoBytes(int[] data, boolean bigEndian) 
                {
                    this.buf[0] = outBuffer[posInOutBuffer++]; //LSB
                    this.buf[1] = outBuffer[posInOutBuffer++]; //MSB
                    this.buf[2] = outBuffer[posInOutBuffer++]; //LSB
                    this.buf[3] = outBuffer[posInOutBuffer++]; //MSB
                    //copy the values into the caller buffer
                    if (bigEndian) 
                    {
                            //left
                            data[0] = ((this.buf[0] << 8) |
                                            (this.buf[1] & 0xFF));
                            //right
                            data[1] = ((this.buf[2] << 8) |
                                            (this.buf[3] & 0xFF));
                    }
                    else 
                    {
                            //left
                            data[0] = ((this.buf[1] << 8) |
                                            (this.buf[0] & 0xFF));
                            //right
                            data[1] = ((this.buf[3] << 8) |
                                            (this.buf[2] & 0xFF));
                    }	                            
		}

		/**
		 * Does any cleanup necessary to dispose of resources in use by this
		 * StreamSoundReference.
		 */
		@Override
		public void dispose() 
                {
		}
                
        }

}
