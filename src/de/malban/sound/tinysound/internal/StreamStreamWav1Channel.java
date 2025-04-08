
package de.malban.sound.tinysound.internal;


import de.malban.sound.tinysound.Stream;
import static de.malban.vide.vedi.sound.ibxm.IBXM.IBXM_MAXBUFFER;

/**
 * Thes StreamSound class is an implementation of the Stream interface that
 * streams audio data from a temporary file to reduce memory overhead.
 * 
 * @author 
 */
public class StreamStreamWav1Channel implements Stream {
    /*
    // debug stuff
    // tinyAudio Format for one channel only
    transient static final AudioFormat audioFormat = new AudioFormat(
                    AudioFormat.Encoding.PCM_SIGNED, //linear signed PCM
                    44100, //44.1kHz sampling rate
                    16, //16-bit
                    1, //2 channels fool
                    2, //frame size 4 bytes (16-bit, 2 channel)
                    44100,//44100, //same as sampling rate
                    false //little-endian
                    );        
        public static byte [] output = new byte[0];
    public static byte[] concat(byte[] a, byte[] b) 
    {
       int aLen = a.length;
       int bLen = b.length;
       byte[] c= new byte[aLen+bLen];
       System.arraycopy(a, 0, c, 0, aLen);
       System.arraycopy(b, 0, c, aLen, bLen);
       return c;
    }	
    public static byte[] concat(byte[] a, byte[] b, int bMax) 
    {
       int aLen = a.length;
       int bLen = bMax;
       byte[] c= new byte[aLen+bLen];
       System.arraycopy(a, 0, c, 0, aLen);
       System.arraycopy(b, 0, c, aLen, bLen);
       return c;
    }	
    public void writeCollection()
    {
        if (!DEBUG_WAV_OUT) return;
        String name = "tySampleOut.wav";
        try
        {
            byte[] orgData16Bit1Channel  = output;
            AudioFormat tinyformat = audioFormat;
            AudioInputStream audioStream = new AudioInputStream( new ByteArrayInputStream(orgData16Bit1Channel) ,tinyformat, orgData16Bit1Channel.length/2 );
            AudioFileFormat.Type targetType = SampleJPanel.findTargetType("wav");
            AudioSystem.write(audioStream,  targetType, new File(name));
            output = new byte[0];
        }
        catch (Throwable e)
        {
            Configuration.getConfiguration().getDebugEntity().addLog(e, WARN);
        }
        
    }
    */
    
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
	public StreamStreamWav1Channel(Mixer mixer, int id, int inputFormat)  
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
        // 16 bit signed, 1 channel 
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
                private byte[] inbuffer = new byte[IBXM_MAXBUFFER/2];
                byte[] outBuffer = new byte[IBXM_MAXBUFFER/2];

                int inbufferUsed = 0;       // in real bytes
                private int bytesInBuffer;  // in real bytes
                int posInOutBuffer;         // in real bytes
                int outBufferAvailable = 0; // in real bytes

                // so many data bytes can be "written" to the stream
                synchronized public int available()
                {
                    return inbuffer.length-inbufferUsed;
                }

                // 16 bit signed, 1 channel expected 
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
                    System.arraycopy(soundBytes, offset, inbuffer, inbufferUsed, soundLength);
//output = concat(output, inbuffer, soundLength);
                    inbufferUsed += soundLength;
                    return soundLength;
                }
                
                static final int TINYSOUND_FRAME_LENGTH = 4;
                static final int MOD_FRAME_LENGTH = 2;
                // prepare read
                // in this case copies one buffer to another
                public int prepareRead(int bytesToCopy)
                {
                    bytesToCopy/=2;

                    // outbuffer is allways used from pos 0
                    // data will be read soon, prepare

                    // if given count > outbuffer, than max it to outbuffer length
                    if (bytesToCopy >outBuffer.length) 
                    {
                        bytesToCopy = outBuffer.length;
                    }
                    
                    if (bytesToCopy >inbufferUsed) 
                    {
                        bytesToCopy = inbufferUsed;
                    }
                    if (bytesToCopy == 0) 
                    {
                        return 0;
                    }
                    System.arraycopy(inbuffer, 0, outBuffer,0 , bytesToCopy);
                    posInOutBuffer=0;
                    outBufferAvailable = bytesToCopy*(2);
                    
                    // remove the just "used" data from the inbuffer
                    // (and keep the data we have not "used")
                    try
                    {
                        System.arraycopy(inbuffer, bytesToCopy, inbuffer,0 , inbuffer.length-(bytesToCopy)/* -1 */);
                    }
                    catch (Throwable e)
                    {
                        //System.out.println("Buh");
                    }
                    inbufferUsed-=bytesToCopy;
                    
                            
                            
                    
                    return bytesToCopy*2;
                    
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
                    num /=2;
                    if (num >inbufferUsed)
                    {
                        inbufferUsed = 0;
                        return;
                    }
                    System.arraycopy(inbuffer, (int)num, inbuffer,0 , inbuffer.length-(int)num);
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
                    this.buf[0] = outBuffer[posInOutBuffer+0]; //LSB
                    this.buf[1] = outBuffer[posInOutBuffer+1]; //MSB
                    this.buf[2] = outBuffer[posInOutBuffer+0]; //LSB
                    this.buf[3] = outBuffer[posInOutBuffer+1]; //MSB
                    posInOutBuffer+=2;
                    
                    
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
