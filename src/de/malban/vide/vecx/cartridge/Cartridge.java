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
import de.malban.vide.vecx.DisplayerInterface;
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
public class Cartridge implements Serializable
{
    public static int FLAG_BANKSWITCH_DONDZILA = 1;
    public static int FLAG_BANKSWITCH_VECFLASH = 2;
    public static int FLAG_EXTREME_MULTI = 4;
    public static int FLAG_RAM_ANIMACTION = 8;
    public static int FLAG_RAM_RA_SPECTRUM = 16;
    public static int FLAG_DS2430A = 32; // Herbert one wire eEprom
    public static int FLAG_VEC_VOICE = 64; //SP0256AL
    public static int FLAG_LIGHTPEN1 = 128;
    public static int FLAG_LIGHTPEN2 = 256;
    public static int FLAG_IMAGER = 512;
    public static int FLAG_VEC_VOX = 1024; // Speakjet
    public static int FLAG_MICROCHIP = 2048; // Tuts one wire eEprom
    public static int FLAG_DUALVEC1 = 4096; // 
    public static int FLAG_DUALVEC2 = 8192; // 
    public static int FLAG_LOGO = 16384; // 
    public static int FLAG_XMAS = 32768; // 
    public static int FLAG_DS2431 = 65536; // Thomas one wire eEprom
    public static int FLAG_32K_ONLY = 65536*2; // Thomas one wire eEprom

    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    // load transient stuff after save state
    public void init()
    {
        log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        if (ds2431 != null) ds2431.init();
        if (ds2430 != null) ds2430.init();
        if (microchip != null) microchip.init();
    }
    public String getTypInfoString()
    {
        String ret = "";
        if (currentCardProp == null) return ret;
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_BANKSWITCH_DONDZILA)!=0) ret+="Dondzila Bankswitch  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_BANKSWITCH_VECFLASH)!=0) ret+="VecFlash Bankswitch  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_EXTREME_MULTI)!=0) ret+="Extreme Multi  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_RAM_ANIMACTION)!=0) ret+="$2000 2k extra RAM  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_RAM_RA_SPECTRUM)!=0) ret+="$8000 2k extra RAM + LED at $A000  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_DS2430A)!=0) ret+="eEprom DS2430A  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_VEC_VOICE)!=0) ret+="VecVoice  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_LIGHTPEN1)!=0) ret+="Lightpen Port 0  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_LIGHTPEN2)!=0) ret+="Lightpen Port 1  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_IMAGER)!=0) ret+="3d Imager  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_VEC_VOX)!=0) ret+="VecVox  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_MICROCHIP)!=0) ret+="eEprom MICROCHIP  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_DUALVEC1)!=0) ret+="DualVec1  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_DUALVEC2)!=0) ret+="DualVec2  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_LOGO)!=0) ret+="$6000 8k extra RAM  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_XMAS)!=0) ret+="XMas LED  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_DS2431)!=0) ret+="eEprom DS2431  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_32K_ONLY)!=0) ret+="32k forced ";
        ret = ret.trim();
        ret = de.malban.util.UtilityString.replace(ret, "  ", ", ");
        return ret;
    }
    public DS2430A ds2430 = new DS2430A(this);
    public DS2431 ds2431 = new DS2431(this);
    
    public Microchip11AA010 microchip = new Microchip11AA010(this);
    transient VecX vecx;
    public void setVecx(VecX v)
    {
        vecx = v;
    }
    String getPC()
    {
        if (vecx==null) return "";
        
        ArrayList<Integer> stack = vecx.getCallstack();
        
        String ret ="";
        
        for (int i=0; i< stack.size(); i++)
        {
            ret+="$"+String.format("%04X", stack.get(i))+"->";
        }
        
        ret += "$"+String.format("%04X", vecx.getPC());
        return ret;
        
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
    
    boolean extraRam2000_2800_2k_Enabled = false;
    boolean extraRam8000_8800_2k_Enabled = false;
    boolean extraRam6000_7fff_8k_Enabled = false;
    boolean isXmas = false;
    boolean isDualVec = false;
    DualVec dualvec = null;
    XMasLED xMasLED = null;
    boolean extremeMulti = false;
    byte spectrumByte = 0;
    boolean _32kOnly = false;
    
    public byte getSpectrumByte()
    {
        return spectrumByte;
    }
    
    public boolean isExtra2000Ram2k()
    {
        return extraRam2000_2800_2k_Enabled;
    }
    public boolean isExtra8000Ram2k()
    {
        return extraRam8000_8800_2k_Enabled;
    }
    public boolean isExtra6000Ram8k()
    {
        return extraRam6000_7fff_8k_Enabled;
    }
    public byte[]  getExtraRam()
    {
        return extraRam;
    }
    
    byte[]  extraRam = null;
    
    int bankMax = 1;
    
    public String cartName="MineStorm";

    int oldBank=-1;    
    int currentBank =0;
    boolean previousExternalLineB = false;
    
    long oldCycles = 0;
    public ArrayList<CartridgeListener> getListener()
    {
        return mListener;
    }
    public void setListener(ArrayList<CartridgeListener> l)
    {
        mListener = l;
    }
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
        
        if (vecx != null)
        {
            if (!vecx.isDebugging())
            {
                if (vecx.microchipEnabled)
                {
                    // do no cartridge event we are in an active serial communication
                    if (microchip.isActive()) // otherwise the emulation may slow down dramatically!
                        return;
                }
                if (vecx.ds2430Enabled)
                {
                    // do no cartridge event we are in an active serial communication
                    if (ds2430.isActive()) // otherwise the emulation may slow down dramatically!
                        return;
                }
                if (vecx.ds2431Enabled)
                {
                    // do no cartridge event we are in an active serial communication
                    if (ds2431.isActive()) // otherwise the emulation may slow down dramatically!
                        return;
                }
            }
        }

        
        fireCartridgeChanged(e );
    }
    // get one byte of card memory
    public int get_cart(int pos) 
    {
        // TODO move if away from EVERY CaARTRIDGE ACCESS!!!
        if (cart == null) return 0;
        if (extraRam2000_2800_2k_Enabled)
        {
            if ((pos>=0x2000) && (pos <0x2800))
                return extraRam[pos-0x2000];
        }
        if (extraRam8000_8800_2k_Enabled)
        {
            if ((pos>=0x8000) && (pos <0x8800))
                return extraRam[pos-0x8000];
            if (pos==0xa000) 
                return spectrumByte;
        }
        if (extraRam6000_7fff_8k_Enabled)
        {
            if ((pos>=0x6000) && (pos <0x6000+8192))
                return extraRam[pos-0x6000];
        }
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
    public boolean isExtremeMulti()
    {
        return extremeMulti;
    }
    // as a  test only bad apple now!
    public void write(int address, byte data)
    {
        if (extremeMulti)
        {
            writeExtreme(address, data);
            return;
        }
        if ((address >= 0x2000) && (address < 0x2800) && (extraRam2000_2800_2k_Enabled))
        {
            extraRam[address-0x2000] = data;
        }
        
        else if ((address >= 0x8000) && (address < 0x8800) && (extraRam8000_8800_2k_Enabled))  
        {
            extraRam[address-0x8000] = data;
        }
        else if ((address == 0xa000) && (extraRam8000_8800_2k_Enabled))  
        {
            spectrumByte = data;
        }
        else if ((address >= 0x6000) && (address < 0x6000+8192) && (extraRam6000_7fff_8k_Enabled))  
        {
            extraRam[address-0x6000] = data;
        }
        
    }

    
    int cHi;
    int parm;
    byte[] allData= null;
    int pos;
    private void writeExtreme(int addr, byte data)
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
        extraRam2000_2800_2k_Enabled = (cartProp.getTypeFlags()&Cartridge.FLAG_RAM_ANIMACTION)!=0;
        extraRam8000_8800_2k_Enabled = (cartProp.getTypeFlags()&Cartridge.FLAG_RAM_RA_SPECTRUM)!=0;
        extraRam6000_7fff_8k_Enabled = (cartProp.getTypeFlags()&Cartridge.FLAG_LOGO)!=0;
        _32kOnly = (cartProp.getTypeFlags()&Cartridge.FLAG_32K_ONLY)!=0;
        isXmas =  ((cartProp.getTypeFlags()&Cartridge.FLAG_XMAS)!=0);
        isDualVec = (  ((cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC1)!=0) || ((cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC2)!=0));
        extremeMulti = (cartProp.getTypeFlags()&Cartridge.FLAG_EXTREME_MULTI)!=0;

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
        
        if (extraRam2000_2800_2k_Enabled)
        {
            extraRam = new byte[2048];
        }
        if (extraRam8000_8800_2k_Enabled)
        {
            extraRam = new byte[2048];
            setPB6FromCarrtridge(false);
        }
        if (extraRam6000_7fff_8k_Enabled)
        {
            extraRam = new byte[8192];
        }
        if (isDualVec)
        {
            int side = 0;
            if ((cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC2)!=0) side=1;
            dualvec = DualVec.getDualVec(side, this);
        }
        else
        {
            if (dualvec != null) dualvec.setCartridge(null);
            dualvec = null;
        }
        if (isXmas)
        {
            xMasLED = new XMasLED();
            xMasLED.setCartridge(this);
        }
        log.addLog("cart: init " + toString(cartProp), INFO);

        return true;
    }    
    public boolean inject(CartridgeProperties cartProp)
    {
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
        log.addLog("cart: inject " + toString(cartProp), INFO);
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

            if (loadLen > 32768)
            {
                if (!_32kOnly)
                    log.addLog("Cartridge size > 32k, bankswitching assumed!", WARN);
            }

            bankMax=(data.length +32767)/32768; // file chunks of 37268 size are banks

            if (_32kOnly)
            {
                if (loadLen > 32768)
                {
                    loadLen = 32768;
                    bankMax = 1;
                }
            }
            
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
        to.ds2431 = from.ds2431.clone();
        to.ds2431.cart = to;

        to.microchip = from.microchip.clone();
        to.microchip.cart = to;
        
        if (from.dualvec == null) 
        {
            to.dualvec = null;
        }
        else
        {
            to.dualvec = from.dualvec.clone();
            to.dualvec.cart = to;
        }
        
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
    public void setPB6FromVectrex(boolean pb6)
    {
        if (vecx==null) return;
        if (vecx.ds2430Enabled)
        {
            ds2430.lineIn(pb6);
        }
        if (vecx.ds2431Enabled)
        {
            ds2431.lineIn(pb6);
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
        if (extraRam8000_8800_2k_Enabled) // specturm
        {
            
        }
        if (isDualVec)
        {
            dualvec.setLine(pb6);
        }
        if (isXmas)
        {
            xMasLED.setLine(pb6);
        }
    }
    // is set from device
    public void setPB6FromCarrtridge(boolean b)
    {
        if (vecx != null)
            vecx.setPB6FromExternal(b);
    }
    // ?B6 of via in input mode
    // if true, data can be input from external
    public void setPB6InputEnabledFromExternal(boolean b)
    {
        if (isDualVec)
        {
            dualvec.setPB6InputEnabledFromExternal(b);
        }
    }
    public void cartStep(long cycles)
    {
        if (vecx.ds2430Enabled)
        {
            ds2430.step(cycles);
        }
        if (vecx.ds2431Enabled)
        {
            ds2431.step(cycles);
        }
        if (vecx.microchipEnabled)
        {
            microchip.step(cycles);
        }
        if (isDualVec)
        {
            dualvec.step(cycles);
        }
    }
    public void reset()
    {
        if (vecx==null) return;
        if (vecx.ds2430Enabled)
        {
            ds2430.reset();
        }
        if (vecx.ds2431Enabled)
        {
            ds2431.reset();
        }
        if (vecx.microchipEnabled)
        {
            microchip.reset();
        }
        
    }
    public DisplayerInterface getDisplay()
    {
        if (vecx==null) return null;
        return vecx.getDisplay();
    }
    String toString(CartridgeProperties prop)
    {
        return "\nTypes: "+getTypInfoString();
    }

}
