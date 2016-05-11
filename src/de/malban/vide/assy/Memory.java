// Placed in public domain by William J. Yakowenko, 2002.  Share and enjoy!
//
// This program is provided "as-is", with no warranty of any kind.
// In no event shall the author or any contributor to this program
// be held liable for any damages arising in any way from any action
// related to this program.


// Eventually support multiple memory segments.
// But for now, there is only one segment.
package de.malban.vide.assy;

import java.util.Vector;
import java.io.IOException;
import java.io.OutputStream;

public class Memory 
{
	Vector /* of MemorySegment */ segments;
	MemorySegment current;
        public static final int MEM_UNKOWN = 0;
        public static final int MEM_CODE = 1;
        public static final int MEM_CODE_POSTBYTE = 2;

        public static final int MEM_CHAR_DATA = 4;
        public static final int MEM_BYTE_DATA = 8;
        public static final int MEM_WORD_DATA = 16;
        
	
	public Memory() 
        {
            current = null;
            segments = new Vector();
	}

	public void write( int address, int value , int type) 
        {
            if (current == null) 
            {
                current = new MemorySegment( "default", address );
                segments.addElement( current );
            }
            current.write( address, value, type );
	}

	public void write( int addr, int value, int len, boolean bigendian, int type ) 
        {
            for (int i=0; i<len; i++) 
            {
                int shift = bigendian? len-1-i : i;
                if (type == MEM_CODE)
                {
                    if (i == 0)
                        write( addr+i, (value >>> (shift*8)) & 255, type );
                    else
                        write( addr+i, (value >>> (shift*8)) & 255, MEM_CODE_POSTBYTE );
                }
                else
                {
                    write( addr+i, (value >>> (shift*8)) & 255, type );
                }
            }
	}

	public int read( int address ) 
        {
            // Check multiple segments?
            if (current == null) { return 0; }
            return current.read( address );
	}
	public int getType( int address ) 
        {
            // Check multiple segments?
            if (current == null) { return 0; }
            return current.getType( address );
	}

	public void write( OutputStream out ) {
            // Write multiple segments?
            // Without addressing info, the resulting file would be bad...
            if (current == null) { return; }
            current.write(out);
	}

	public void writeSRecords( OutputStream out, int xferAddr )
		throws IOException
	{
		writeSRecords(out);
		
		if (segments.size() == 0) { return; }
		MemorySegment s = (MemorySegment)segments.elementAt(0);
		if (s != null && xferAddr >= 0) {
			s.writeS9Record(out,xferAddr); // throws IOException
		}
	}

	public void writeSRecords( OutputStream out )
		throws IOException
	{
		MemorySegment s;
		int count;
		
		s = null;
		count = 0;
		for (int i=0; i<segments.size(); i++) {
			s = (MemorySegment)segments.elementAt(i);
			count += s.writeSRecords(out); // throws IOException
		}
		if (s != null) {
			s.writeS5Record(out,count); // throws IOException
		}
	}

}

