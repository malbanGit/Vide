// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.
package de.malban.vide.assy;


import java.io.OutputStream;
import java.io.IOException;

public class MemorySegment {
	int  base, length, allocated, cksum;
	byte contents[]; 
	int contentType[]; 
	String name;

	public MemorySegment( String name, int base ) 
        {
            this.name = name;
            this.base = base;

            length = 0;
            allocated = 128;
            contents = new byte[allocated];
            fillNop(contents);
            contentType= new int[allocated];
	}

        public int size()
        {
            return length;
        }
        // fill with NOP
        // rather than 0 (neg)
        // in case of jump optimization, their might be "empty" spaces
        void fillNop(byte c[])
        {
            for (int i=0; i<c.length; i++) c[i]=0x12;
        }
	// write a value into memory
	public void write( int address, int value , int type) 
        {
            int  new_base, new_length, new_allocated;
            byte new_contents[];
            int new_contentType[];

            int offset = address - base;
            if (offset < 0) 
            {
                new_base = address;
                new_length = length - offset;
                new_allocated = allocated - offset;
                new_contents = new byte[new_allocated];
                fillNop(new_contents);
                new_contentType = new int[new_allocated];
                for (int a=0; a<length; a++) 
                {
                    new_contents[a-offset] = contents[a];
                    new_contentType[a-offset] = contentType[a];
                }
                base = new_base;
                length = new_length;
                allocated = new_allocated;
                contents = new_contents;
                contentType = new_contentType;
                offset = 0;
            }
            if (offset >= allocated) 
            {
                // base and length are unchanged
                new_allocated = allocated + offset + 128;
                new_contents = new byte[new_allocated];
                fillNop(new_contents);
                new_contentType = new int[new_allocated];
                for (int a=0; a<length; a++) 
                {
                    new_contents[a] = contents[a];
                    new_contentType[a] = contentType[a];
                }
                allocated = new_allocated;
                contents = new_contents;
                contentType = new_contentType;
            }
            if (offset >= length) 
            {
                length = offset+1;
            }

            contents[offset] = (byte)( value & 255 );
            contentType[offset] = type;
	}
        public int getType(int address )
        {
            int offset = address - base;
            if (offset < 0 || offset >= length) { return 0; }
            
            return contentType[offset];
                
        }
        
	public int read( int address ) {
		int offset = address - base;
		if (offset < 0 || offset >= length) { return -1; }
		return contents[offset];
	}

	// write memory contents to a stream
	public void write( OutputStream out ) {
		try { out.write( contents, 0, length ); }
		catch (IOException x) {
			// problem!
		}
	}

	public synchronized int writeSRecords( OutputStream out )
		throws IOException
	{
		int addr, firstAddr, lastAddr, reclen, reccount;
		
		firstAddr = base;
		lastAddr  = base + length - 1;
		reccount = 0;
		for (addr=firstAddr; addr<=lastAddr; addr+=32) {
			reclen = lastAddr+1 - addr;
			if (reclen > 32) { reclen = 32; }
			
			cksum = 0;
			write( out, "S1" );
			write( out, sRecordByte( reclen+3 ) );
			write( out, sRecordByte( addr>>>8 ) );
			write( out, sRecordByte( addr ) );
			for (int i=0; i<reclen; i++) {
				int b = contents[addr-base+i];
				write( out, sRecordByte( b ) );
			}
			write( out, sRecordByte( 255 - cksum ) );
			write( out, "\n" );
			
			reccount += 1;
		}
		
		return reccount;
	}

	public synchronized void writeS5Record( OutputStream out, int count )
		throws IOException
	{
		writeS59Record(out,5,count);
	}

	public synchronized void writeS9Record( OutputStream out, int addr )
		throws IOException
	{
		writeS59Record(out,9,addr);
	}

	private synchronized void writeS59Record( OutputStream out,
		int type, int num )
		throws IOException
	{
		cksum = 0;
		write( out, "S"+type );
		write( out, sRecordByte( 3 ) );
		write( out, sRecordByte( num>>>8 ) );
		write( out, sRecordByte( num ) );
		write( out, sRecordByte( 255 - cksum ) );
		write( out, "\n" );
	}

	private void write( OutputStream out, String s ) throws IOException {
		for (int i=0; i<s.length(); i++) {
			out.write( s.charAt(i) );
		}
	}

	private String sRecordByte( int b ) {
		b &= 255;
		cksum = (cksum + b) & 255;
		return hexByte( b );
	}

	private static String hexByte( int n ) {
		String s = "00" + Integer.toHexString(n).toUpperCase();
		return s.substring( s.length() - 2 );
	}

}
