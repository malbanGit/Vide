/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.ERROR;
import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.util.DownloaderPanel;
import de.malban.vide.vecx.VecX;
import java.io.File;
import java.io.Serializable;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.zip.CRC32;

/**
 *
 * @author malban
 */
public class Cartridge  implements Serializable
{
    public static int FLAG_BANKSWITCH_DONDZILA = 1;
    public static int FLAG_BANKSWITCH_VECFLASH = 2;
    public static int FLAG_EXTREM_MULTI = 4;
    public static int FLAG_RAM_ANIMACTION = 8;
    public static int FLAG_RAM_RA_SPECTRUM = 16;
    public static int FLAG_DS2430A = 32; // Herbert one wire eEprom
    public static int FLAG_VEC_VOICE = 64; //SP0256AL
    public static int FLAG_LIGHTPEN1 = 128;
    public static int FLAG_LIGHTPEN2 = 256;
    public static int FLAG_IMAGER = 512;
    public static int FLAG_VEC_VOX = 1024; // Speakjet
    public static int FLAG_MICROCHIP = 2048; // Tuts one wire eEprom

    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    // load transient stuff after save state
    public void init()
    {
        log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    }
    
    public DS2430A ds2430 = new DS2430A(this);
    public Microchip11AA010 microchip = new Microchip11AA010(this);
    transient VecX vecx;
    public void setVecx(VecX v)
    {
        vecx = v;
    }
    
    int typeFlags=0;
    public long crc=0;
    // default
    int[][] cart;          // [BankNo][MemoryAddress]
    int[] bankLength;      // size of each bank, last might be smaller
    String[] bankFileNames;      
    int loadLen = 0;       // size of cartridge rom loaded (of single rom)
    transient ArrayList<CartridgeListener> mListener= new ArrayList<CartridgeListener>();

    public CartridgeProperties currentCardProp = null;
    
    
    public ArrayList<CartridgeListener> getListener()
    {
        return mListener;
    }
    public void setListener(ArrayList<CartridgeListener> l)
    {
        mListener = l;
    }
    
    int bankMax = 1;
    
    public String cartName="MineStorm";

    int oldBank=-1;    
    int currentBank =0;
    boolean previousExternalLineB = false;
    
    long oldCycles = 0;
    public int getBankCount()
    {
        return bankMax;
    }
    public long getCRC()
    {
        CRC32 localCRC32 = new CRC32();
        for (int b=0; b<bankMax; b++)
            localCRC32.update(getByteData(b));
        return localCRC32.getValue();
    }
    public int getBankSize(int b)
    {
        return bankLength[b%bankMax];
    }
    public void addCartridgeListener(CartridgeListener listener)
    {
        if (mListener==null) mListener = new ArrayList<CartridgeListener>();
        mListener.remove(listener);
        mListener.add(listener);
    }

    public void removeCartridgeListener(CartridgeListener listener)
    {
        if (mListener==null) return;
        mListener.remove(listener);
    }
    public void fireCartridgeChanged(CartridgeEvent e)
    {
        
        if (mListener==null) return;
        for (int i=0; i<mListener.size(); i++)
        {
            mListener.get(i).cartridgeChanged(e);
        }
    }

    public int getCurrentBank()
    {
        return currentBank;
    }
    public void setBank(int newBank)
    {
        if (bankMax == 0) return;
        if (oldBank == (newBank%bankMax)) return;
        CartridgeEvent e= new CartridgeEvent();
        e.oldBank = oldBank;
        e.newBank = newBank%bankMax;

        oldBank = newBank%bankMax;
        currentBank = newBank%bankMax;
        
        fireCartridgeChanged(e );
    }
    // get one byte of card memory
    public int get_cart(int pos) 
    {
        // TODO move if away from EVERY CaARTRIDGE ACCESS!!!
        if (cart == null) return 0;
        if (cart.length<=currentBank) return 0;
        if (cart[currentBank] == null) return 0;
        if ((pos%32768)>=cart[currentBank].length) return 0;
        return cart[currentBank][pos%32768];
    }
    // allways to current bank!
    public void poke(int address, byte value)
    {
        if (cart == null) return;
        if (cart.length<=currentBank) return;
        if ((address%32768)>=cart[currentBank].length) return;
        cart[currentBank][address%32768] = value;
    }
    // as a  test only bad apple now!
    int cHi;
    int parm;
    byte[] allData= null;
    int pos;
    public void write(int addr, byte data)
    {
	int i;
	if (addr==1) cHi=data<<8;
	if (addr==0x7ffe) parm=data;
	if ((addr&0xff)==0xff) 
        {
            if (data==1) 
            {
                log.addLog("Cart: extreme multicard -> Unimplemented: multicart", WARN);
            } 
            else if (data==2) 
            {
                if (allData==null) 
                {
                    try
                    {
                        Path path = Paths.get("vec.bin");
                        if (currentCardProp != null)
                        {
                            path = Paths.get(currentCardProp.mextremeVecFileImage);
                        }
//                        log.addLog("Cart: extreme multicard -> hardcoded 'vec.bin' used", WARN);
                        allData = Files.readAllBytes(path);
                        pos = 0;
                    }
                    catch (Throwable ex)
                    {
                        
                    }
                }
                if (allData == null) return;
                if (allData.length<pos+1024+512) pos = 0;
                for (int ii=0; ii< 1024+512;ii++)
                {
                    cart[currentBank][0x4000+ii] = allData[pos];
                    pos++;
                }
//                i=fread(&cart[0x4000], 1, 1024+512, str);
//                printf("Read %d bytes %hhx.\n", i, cart[0x4000]);
            } 
            else if (data==66) 
            {
                log.addLog("Cart: extreme multicard -> doom not supported", WARN);
                System.out.println("Doom Boom!\n");
                    //Do a Doom render...
//                    printf("DOOM BOOOM Read %d bytes %hhx.\n", i, cart[0x4000]);
//                    voomVectrexFrame(parm, &cart[0x1000]);
            }
	}
    }
    
    public String getBankeRomName(int bank)
    {
        if (bankFileNames==null)
        {
            log.addLog("Cart: getBankeRomName() bankFileNames = null", WARN);
            return null;
        }
        if (bank >= bankFileNames.length)
        {
            log.addLog("Cart: getBankeRomName() bank > size", WARN);
            return null;
        }
        return bankFileNames[bank];
    }
    public byte[] getByteData(int bank)
    {
        if (bankLength==null)
        {
            log.addLog("Cart: getByteData() bankLength = null", WARN);
            return new byte[0];
        }
        if (bank >= bankLength.length)
        {
            log.addLog("Cart: getByteData() bank >= bankLength", WARN);
            return new byte[0];
        }
        
        
        
        byte[] ret = new byte[bankLength[bank]];
        for (int i=0; i< bankLength[bank];i++)
        {
            ret[i] = (byte)(cart[bank][i]&0xff);
        }
        return ret;
    }
    public boolean init(CartridgeProperties cartProp)
    {
        currentCardProp = cartProp;
        previousExternalLineB = false;
        oldCycles = 0;
        if (cartProp == null) 
        {
            log.addLog("Cart: init() cartProp = null", WARN);
            return false;
        }
        if (cartProp.mFullFilename == null) 
        {
            log.addLog("Cart: init() mFullFilename = null", WARN);
            return false;
        }
        cartName = cartProp.mCartName;
        
        bankMax = cartProp.mFullFilename.size();
        if (bankMax == 0) 
        {
            log.addLog("Cart: init() bankMax = 0", WARN);
            return false;
        }

        if (cartProp.mFullFilename.size()>0)
        {
            // checking file 0 is enough
            // if files are not loaded, than we have a problem!
            boolean ok = DownloaderPanel.ensureLocalFile("Cartridge", cartProp.mBinaryLink, cartProp.mFullFilename.elementAt(0));
            if (!ok)
            {
                log.addLog("Cart: Downloadable files not found...", WARN);
                return false;
            }
        }
        
        if (bankMax == 1)
        {
            // if cartridge consists of only one file
            // than load it "normally"
            // this enables us to load
            // multibanks with one file only
            // if number of roms is > 1, than each file must not be greater than 32768!
            if (!load(convertSeperator(cartProp.mFullFilename.elementAt(0)))) 
            {
                log.addLog("Cart: init() single bank not loaded: "+cartProp.mFullFilename, WARN);
                return false;
            }
        }
        else
        {
            // load multi part cartridge
            cart = new int[bankMax][];     // and so many banks as memory data
            bankLength = new int[bankMax]; // so many bank length we need
            bankFileNames = new String[bankMax];
            for (int bank=0; bank< bankMax; bank++)
            {
                bankFileNames[bank] = "";
                String romName = convertSeperator(cartProp.mFullFilename.elementAt(bank));
                bankFileNames[bank] = "";
                // only load available files
                // skipping unavailable might seems strange,
                // but vecflash can have "empty" slots - so thus does not have to be an error
                if (romName.trim().length() == 0) continue;
                File f = new File(romName);
                if (!f.exists()) 
                {
                    log.addLog("Cart: init() multi bank file does not exist: "+romName, WARN);
                    return false;
                }
                if (!load(romName, bank)) 
                {
                    log.addLog("Cart: init() multi bank file not loaded: "+romName, WARN);
                    return false;
                }
                bankFileNames[bank] = romName;
            }
        }
        
        // todo: Set and use type flag information!
        
        return true;
    }    
    // load routine for "ROM" files
    // roms are loaded to a maximum of 32768 bytes
    // the rest is cut of!
    // given bank is used
    // it is assumed, that card and banklength are arrays large enough to contain the given bank!
    private boolean load(String filenameRom, int bank)
    {
        // the following loads 1 file
        // if the file is larger than 32768 the rest is cut off
        // given bank no is filled with data of 32768 bytes, regardless of size loaded
        // each memory of bank is ALLWAYS 32768, the not "loaded" memory is filled with "1"
        // in bankLength[b] is the actual "used" length (loaded length) of each bank
        // (often less the 32768)
        try
        {
            Path path = Paths.get(convertSeperator(filenameRom));
            byte[] data = Files.readAllBytes(path);
            if (data.length>32768)
            {
                log.addLog("Cart: load() multi part rom is larger than 32768, additional data is ignored! - "+filenameRom, WARN);
            }
            
            int length = data.length;
            if (length > 32768)
                bankLength[bank] = 32768;
            else
                bankLength[bank] = length;

            cart[bank] = new int[32768]; // memory of a bank is allways 32768, since we need fillers
            for (int i=0; i< 32768;i++)
            {
                if (i>=data.length)
                    cart[bank][i] = 1; // polar rescue needs this!
                else
                    cart[bank][i] = data[i];
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, ERROR);
            return false;
        }
        return true;
    }    
    
    // load routine for "ROM" files
    // (instead of cartridge files)
    // there is NO additional information as of now
    // (TODO: check for CRC and get additional information from that)
    public boolean load(String filenameRom)
    {
        previousExternalLineB = false;
        oldCycles = 0;
        cartName = filenameRom;
        if (!new File(filenameRom).exists()) return false;
        if (new File(filenameRom).isDirectory()) return false;
        
        // the following loads 1 file
        // if the file is larger than 32768 a multi banked file is assumed
        // banks are filled with data of 32768 chunks
        // each memory of bank is ALLWAYS 32768, the not "loaded" memory is filled with "1"
        // in bankLength[b] is the actual "used" length (loaded length) of each bank
        // (often less the 32768)
        try
        {
            Path path = Paths.get(filenameRom);
            byte[] data = Files.readAllBytes(path);
            loadLen = data.length;
            bankMax=(data.length +32767)/32768; // file chunks of 37268 size are banks
            
            cart = new int[bankMax][];     // and so many banks as memory data
            bankLength = new int[bankMax]; // so many bank length we need
            bankFileNames= new String[bankMax];

            if (loadLen == 0) 
            {
                log.addLog("Cartridge not loaded, loadLen = 0", WARN);
                return false;
            }
            int length = loadLen;
            for (int b=0;b<bankMax;b++)
            {
                bankFileNames[b] = filenameRom;
                if (length > 32768)
                    bankLength[b] = 32768;
                else
                    bankLength[b] = length;
                length -= bankLength[b];
                cart[b] = new int[32768]; // memory of a bank is allways 32768, since we need fillers
                for (int i=0; i< 32768;i++)
                {
                    if (b*32768+i>=data.length)
                        cart[b][i] = 1; // polar rescue needs this!
                    else
                        cart[b][i] = data[b*32768+i];
                }
            }
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
            return false;
        }
        return true;
    }    
    // parameters to be compatible with vecxy
    public static void deepCopy(Cartridge from, Cartridge to, boolean doRam, boolean doTimer)
    {
        to.ds2430 = from.ds2430.clone();
        to.ds2430.cart = to;

        to.microchip = from.microchip.clone();
        to.microchip.cart = to;
        
        to.vecx = from.vecx;
    }
    
    // returns true if bank was switched
    public boolean checkBankswitch(boolean externalLine , long cycles)
    {
        // only interesting pin is pb6 external
        
        // and even THAT is only interesting if it changed
        if (previousExternalLineB != externalLine)
        {
            previousExternalLineB = externalLine;
            if (getBankCount()<3) // assume vecflash for more than 2 banks
            {
                setBank(previousExternalLineB ? 1 : 0);
                return true;
            }
            boolean switched=false;
            
   
            // there are two actions vecflash does
            // set bank to 0
            // or set bank = bank +1
            
            // 1) set bank 0
            // set EXTERNAL_LINE = 0 (from 1)
            // when time since last setting of external line to 0
            // greater than xxxx (1ms?)
            // -> bank is switched to 0
            
            // 2) set bank = bank +1
            // set EXTERNAL_LINE = 0 (from 1[the one must be got within time limit])
            // -> bank += 1
            
            // or
            long time = cycles - oldCycles;
            if (externalLine)
            {
                if (time > 1500)
                {
                    setBank(0);
                    switched = true;
                }
                
            }
            else 
            {
                setBank(getCurrentBank()+1);
                oldCycles = cycles;
                switched = true;
            }
            return switched;
        }        
        return false;
        
    }
    public static String convertSeperator(String filename)
    {
        String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
        ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
        return ret;
    }
    
    // line PB6
    // is set FROM vectrex
    // can be used by any "device" on line PB6, not XOR
    public void lineIn(boolean pb6)
    {
        if (vecx==null) return;
        if (vecx.ds2430Enabled)
        {
            ds2430.lineIn(pb6);
        }
        if (vecx.microchipEnabled)
        {
            microchip.lineIn(pb6);
        }
        
        if (vecx.config.enableBankswitch)
        {
            // send changed via port b out put to cartridge
            boolean changed = checkBankswitch(pb6, vecx.cyclesRunning);
            if (changed)
            {
                vecx.checkBankswitchBreakpoint();
            }
        }
        
    }
    // is set from device
    public void lineOut(boolean b)
    {
        vecx.setPB6FromExternal(b);
    }
    public void cartStep(long cycles)
    {
        if (vecx.ds2430Enabled)
        {
            ds2430.step(cycles);
        }
        if (vecx.microchipEnabled)
        {
            microchip.step(cycles);
        }
    }
    public void reset()
    {
        if (vecx.ds2430Enabled)
        {
            ds2430.reset();
        }
        if (vecx.microchipEnabled)
        {
            microchip.reset();
        }
        
    }
}
/*

alternative: 
 switch PB6 to out
 and work with writing to ORB PB6

input in y

switchroutineROM:
switch:
frome line art          

		ldb #$9f            ; setup ddrb, in bits 1001 1111, which means
                                    ; one means the corresponding bit in orb is set to OUTPUT
                                    ; zero means the corresponding bit in orb is set to INPUT
                                    ; 
                                    ; on INPUT the LINE goes than to HIGH (1)
                                    ; on OUT the LINE goes than to LOW (0) // until set otherwise
                                    ; this is sort of a "~" behavior
	
                stb <VIA_DDR_b      ; so, what this actually does 
                                    ; supply vecflash with an 5 Volt signal on PB6
                                    ; EXTERNAL LINE = 1

		leay -1,y           ; in y is the bank number to be switched to
                                    ; for each bank between 0 and the bank number we want to go

                clrb                ; b = 0
delay:	        decb                ; b = -1 which is $ff
		bne delay           ; this loop delays for xx cycles
                                    ; aboz 1300 cycles, pretty close to 1ms 

		ldb #$df            
		stb <VIA_DDR_b      ; change PB6 to OUTPUT and effectivly provide the xternal line with 0 volt, pulling it down
                                    ; EXTERNAL LINE = 0
		nop                 ; delay
		nop
		cmpy #0             ; have we switched enough? are we at the bank we want to go to?
		bne switch          ; no, continue switching
fastboot:
		jsr waitrecal
		jsr waitrecal
		jmp flashstart  
*/
