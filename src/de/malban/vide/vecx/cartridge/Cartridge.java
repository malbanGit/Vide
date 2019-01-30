/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.cartridge;

import de.malban.Global;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.ERROR;
import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.VERBOSE;
import de.malban.util.DownloaderPanel;
import static de.malban.util.Utility.makeGlobalAbsolute;
import de.malban.vide.VideConfig;
import de.malban.vide.vecx.DisplayerInterface;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.cartridge.resid.SID.State;
import java.io.File;
import java.io.FileOutputStream;
import java.io.Serializable;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.zip.CRC32;

// todo 
// extra ram to cartridge interface!
// extreme vectrex as cart
// RAM rerad write to cart
// todo bankswitching in cartridge interface?
//      load ALL memory to cartridge
//      and let the interface decide how to handle banksiwtching and how to "divide" memory
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
    public static int FLAG_MICROCHIP = 2048; // Tuts one wire eEprom, VPilot
    public static int FLAG_DUALVEC1 = 4096; // 
    public static int FLAG_DUALVEC2 = 8192; // 
    public static int FLAG_LOGO = 16384; // 
    public static int FLAG_XMAS = 32768; // 
    public static int FLAG_DS2431 = 65536; // Thomas one wire eEprom
    public static int FLAG_32K_ONLY = 65536*2; // 
    public static int FLAG_SID = FLAG_32K_ONLY*2; // SID chip board at $8000 (kokovec)
    public static int FLAG_48K = FLAG_SID*2; // 


    // todo
    public static int FLAG_V4E_16K_BS = FLAG_48K*2; // 
    public static int FLAG_ATMEL_EEPROM = FLAG_V4E_16K_BS*2; // VPATROL - DONE
    public static int FLAG_PIC_EEPROM = FLAG_ATMEL_EEPROM*2; // BLOXORZ
    public static int FLAG_KEYBOARD = FLAG_PIC_EEPROM*2; // 
    

    //
    public static int FLAG_FLASH_SUPPORT = FLAG_KEYBOARD*2; // 
    public static int FLAG_BS_PB6_IRQ = FLAG_FLASH_SUPPORT*2; // 
    
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();

    public boolean isMicrochip = false;
    public boolean isAtmel = false;
    public boolean isDS2431 = false;
    public boolean is2430a = false;
    public boolean isVecFeverCartridge = false;
    boolean extraRam2000_2800_2k_Enabled = false;
    boolean extraRam8000_8800_2k_Enabled = false;
    boolean extraRam6000_7fff_8k_Enabled = false;

    public boolean currentIRQ = true;
    public boolean currentPB6 = true;
    public boolean flashSupport = true;

    // redundant to flag
    boolean isXmas = false;
    boolean isDualVec = false;
    boolean sidEnabled = false;
    boolean extremeMulti = false;
    boolean rom48KEnabled = false;
    byte spectrumByte = 0;
    boolean _32kOnly = false;
    
    boolean v4e_16k_bankswitch = false;
    boolean isPB6IRQBankswitch = false;

    public Microchip11AA010 microchip = new Microchip11AA010(this);
    public AT24C02 atmel = new AT24C02(this);
    public DS2430A ds2430 = new DS2430A(this);
    public DS2431 ds2431 = new DS2431(this);
    public VSID vsid = null;
    DualVec dualvec = null;
    XMasLED xMasLED = null;
    // todo array of CartridgeInternalInterface

    // load transient stuff after save state
    public void init()
    {
        log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
        if (ds2431 != null) ds2431.init();
        if (ds2430 != null) ds2430.init();
        if (microchip != null) microchip.init();
        if (atmel != null) atmel.init();
        
      //  if (vsid != null) vsid.init();
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
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_32K_ONLY)!=0) ret+="32k forced  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_SID)!=0) ret+="SID extension  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_48K)!=0) ret+="48k ROM  ";
        
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_V4E_16K_BS)!=0) ret+="V4E 16k BS  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_ATMEL_EEPROM)!=0) ret+="eEprom atmel  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_PIC_EEPROM)!=0) ret+="eEprom PIC  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_KEYBOARD)!=0) ret+="Keyboard  ";

        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_FLASH_SUPPORT)!=0) ret+="Flash support  ";
        if ((currentCardProp.getTypeFlags()&Cartridge.FLAG_BS_PB6_IRQ)!=0) ret+="Quad BS ";

        
        
        
        ret = ret.trim();
        ret = de.malban.util.UtilityString.replace(ret, "  ", ", ");
        return ret;
    }

    public int MAX_BANK_SIZE = 32768;    
    
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
    
    byte[]  extraRam = null;
    int bankMax = 1;
    public String cartName="MineStorm";
    int oldBank=-1;    
    int currentBank =0;
    boolean previousExternalLineB = true;
    boolean previousExternalLineIRQ = true;
    
    long oldCycles = 0;
    
    public byte getSpectrumByte()
    {
        return spectrumByte;
    }
    
    public boolean is48KROM()
    {
        return rom48KEnabled;
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
    public boolean isDualVec()
    {
        return isDualVec;
    }
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

    public int getCurrentBankLength()
    {
        if (cart == null) return 0;
        if (cart.length<=currentBank) return 0;
        if (cart[currentBank] == null) return 0;
        return cart[currentBank].length;
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
                if (isMicrochip)
                {
                    // do no cartridge event we are in an active serial communication
                    if ((microchip.usesPB6()) && (microchip.isActive())) // otherwise the emulation may slow down dramatically!
                        return;
                }
                if (is2430a)
                {
                    // do no cartridge event we are in an active serial communication
                    if ((ds2430.usesPB6()) && (ds2430.isActive())) // otherwise the emulation may slow down dramatically!
                        return;
                }
                if (isDS2431)
                {
                    // do no cartridge event we are in an active serial communication
                    if ((ds2431.usesPB6()) && (ds2431.isActive())) // otherwise the emulation may slow down dramatically!
                        return;
                }
                if (isAtmel)
                {
                    // do no cartridge event we are in an active serial communication
                    if ((atmel.usesPB6()) && (atmel.isActive())) // otherwise the emulation may slow down dramatically!
                        return;
                }
            }
        }

        
        fireCartridgeChanged(e );
    }
    // get one byte of card memory
    // & 0xff needed, since conversion from byte to int is "signed", and a negative value
    // is returned on x >=128, which in turn  does not
    // fit the other parts of emulation
    public int readByte(int pos) 
    {
        // TODO move if away from EVERY CaARTRIDGE ACCESS!!!
        if (cart == null) return 0;
        
        if (flashSupport)
        {
            if ((idSequenceData == 3) && (idSequenceAddress == 3)  )
            {
                if ((pos%2) == 0)
                {
                    log.addLog("FLASH ID read: $bf", INFO);
                    return 0xbf;
                }
                else
                {
                    log.addLog("FLASH ID read: $b6", INFO);
                    return 0xb6; // SST39SF020A
                }
            }

        }
        
        if (extraRam2000_2800_2k_Enabled)
        {
            if ((pos>=0x2000) && (pos <0x2800))
                return extraRam[pos-0x2000]&0xff;
        }
        if (extraRam8000_8800_2k_Enabled)
        {
            if ((pos>=0x8000) && (pos <0x8800))
                return extraRam[pos-0x8000]&0xff;
            if (pos==0xa000) 
                return spectrumByte&0xff;
        }
        if (extraRam6000_7fff_8k_Enabled)
        {
            if ((pos>=0x6000) && (pos <0x6000+8192))
                return extraRam[pos-0x6000]&0xff;
        }
        if (sidEnabled)
        {
            if ((pos>=0x8000) && (pos <0x8020))
            {
                if (vecx != null)
                    return vsid.performRead(pos, vecx.getCycles());
            }
        }
        if (v4e_16k_bankswitch)
        {
            if ((pos&0xc000) == 0xc000)
            {
                int b = pos & 0x00ff; // for now 4 banks only
                if (b==0) setBank(0);
                if (b==1) setBank(1);
                if (b==2) setBank(2);
                if (b==3) setBank(3);
            }
        }
        
        if (cart.length<=currentBank) return 0xff;
        if (cart[currentBank] == null) return 0xff;
        if ((pos%MAX_BANK_SIZE)>=cart[currentBank].length) return 0xff;
        return cart[currentBank][pos%MAX_BANK_SIZE];
    }

    public boolean isExtremeMulti()
    {
        return extremeMulti;
    }
    public void write(int address, byte data)
    {
        if (sidEnabled)
        {
            if ((address>=0x8000) && (address <0x8020))
            {
                if (vecx != null)
                {
                    vsid.performWrite(address, data, vecx.getCycles());
                }
                return;
            }
        }
        
        
        if (extremeMulti)
        {
            writeExtreme(address, data);
            return;
        }
        if ((address >= 0x2000) && (address < 0x2800) && (extraRam2000_2800_2k_Enabled))
        {
            extraRam[address-0x2000] = data;
        }
        boolean flashDone = false;
        if (flashSupport)
        {
            if ((writeSequenceAddress >= 3) && (writeSequenceData >= 3))
            {
                if (address!=0x5555) 
                {
                    flashDone = true;
                    writeSequenceAddress = 0;
                    writeSequenceData = 0;
                    if (cart.length<=currentBank) return;

                    if ((address%MAX_BANK_SIZE)>=cart[currentBank].length) return;
                    byte oldData = (byte) cart[currentBank][address%MAX_BANK_SIZE];

                    // only erase of bit is allowed!
                    byte newData = (byte) (data & oldData);
                    cart[currentBank][address%MAX_BANK_SIZE] = newData;
                    log.addLog("FLASH write ("+currentBank+","+(address%MAX_BANK_SIZE)+"->"+newData+")", INFO);
                }
            }
        }
        if (!flashDone)
        {
            if ((address >= 0x8000) && (address < 0x8800) && (extraRam8000_8800_2k_Enabled))  
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
            else
            {
                if (v4e_16k_bankswitch)
                {
                    if ((pos&0xc000) == 0xc000)
                    {
                        int b = pos & 0xc000; // for now 4 banks only
                        if (b==0) setBank(0);
                        if (b==1) setBank(1);
                        if (b==2) setBank(2);
                        if (b==3) setBank(3);
                    }
                }

                if (cart.length<=currentBank) return;

                if (vecx.config.ramAccessAllowed)
                {
                    if ((address%MAX_BANK_SIZE)>=cart[currentBank].length) return;
                    cart[currentBank][address%MAX_BANK_SIZE] = data;
                }
                else
                {
                    log.addLog("ROM write-access at: $" + String.format("%04X", address)+", $"+String.format("%02X", (data&0xff))+" from $"+String.format("%04X", vecx.getPC()), VERBOSE);
                    if (vecx.config.breakpointsActive) vecx.checkROMBreakPoint(address, data);
                }
            }            
        }

    }
    
    int cHi;
    int parm;
    byte[] allData= null;
    int pos;
    // as a  test only bad apple now!
    int big = 0;
    boolean doExtremeOutput = false;
    private void writeExtreme(int addr, byte data)
    {
	int i;
	if (addr==1) cHi=data<<8;
        if (addr==2) 
        {
            int timerT2 = (cHi+data)&0xffff;
            int timerT2Real = ((data<<8)+(cHi>>8))&0xffff;
            if (doExtremeOutput)
            {
                System.out.println("DBG: 1 "+String.format("%04X", timerT2)+"");
                if (timerT2Real >0xc350)
                {
     //           System.out.println("DBG: 1  "+String.format("%04X", timerT2)+",");
                    big++;
                    if (big>1) 
                    {
                        System.out.println("Buh");
                    }
                }
                else
                {
                    big=0;
                }
            }
        }
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
                        Path path = Paths.get(Global.mainPathPrefix+"vec.bin");
                        if (currentCardProp != null)
                        {
                            String s = "vec.bin";
                            if(currentCardProp.mFullFilename.size()>0)
                            {
                                String org = currentCardProp.mFullFilename.elementAt(0);
                                int t = org.lastIndexOf(File.separator)+1;
                                s = org.substring(0, t)+s;
                            }
                            path = Paths.get(Global.mainPathPrefix+s);
                            if (currentCardProp.mextremeVecFileImage==null)
                            {
                            }
                            else
                            {
                                if (currentCardProp.mextremeVecFileImage.trim().length()==0)
                                {
                                }
                                else
                                {
                                    path = Paths.get(Global.mainPathPrefix+currentCardProp.mextremeVecFileImage);
                                }
                            }
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
//System.out.println("Extreme bank switch");                    
                    pos++;
                }
//                i=fread(&cart[0x4000], 1, 1024+512, str);
//                printf("Read %d bytes %hhx.\n", i, cart[0x4000]);
                if (doExtremeOutput)
                    System.out.println("Read 1536 bytes "+String.format("%02X", cart[currentBank][0x4000])+".");
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
        rom48KEnabled = (cartProp.getTypeFlags()&Cartridge.FLAG_48K)!=0;
        MAX_BANK_SIZE = 32768;
        if (rom48KEnabled) MAX_BANK_SIZE = 32768+32768/2;
        
        is2430a = (cartProp.getTypeFlags()&Cartridge.FLAG_DS2430A)!=0;
        isDS2431 = (cartProp.getTypeFlags()&Cartridge.FLAG_DS2431)!=0;
        isAtmel = (cartProp.getTypeFlags()&Cartridge.FLAG_ATMEL_EEPROM)!=0;
        isMicrochip = (cartProp.getTypeFlags()&Cartridge.FLAG_MICROCHIP)!=0;
        
        isPB6IRQBankswitch = (cartProp.getTypeFlags()&Cartridge.FLAG_BS_PB6_IRQ)!=0;
        _32kOnly = (cartProp.getTypeFlags()&Cartridge.FLAG_32K_ONLY)!=0;
        isXmas =  ((cartProp.getTypeFlags()&Cartridge.FLAG_XMAS)!=0);
        isDualVec = (  ((cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC1)!=0) || ((cartProp.getTypeFlags()&Cartridge.FLAG_DUALVEC2)!=0));
        extremeMulti = (cartProp.getTypeFlags()&Cartridge.FLAG_EXTREME_MULTI)!=0;
        sidEnabled = (cartProp.getTypeFlags()&Cartridge.FLAG_SID)!=0;
// todo
// for now always enabled!
        flashSupport = (cartProp.getTypeFlags()&Cartridge.FLAG_FLASH_SUPPORT)!=0;
        
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
            boolean ok = DownloaderPanel.ensureLocalFile("Cartridge", cartProp.mBinaryLink, makeGlobalAbsolute(de.malban.util.UtilityFiles.convertSeperator(cartProp.mFullFilename.elementAt(0))));
            if (!ok)
            {
                log.addLog("Cart: Downloadable files not found...", WARN);
                return false;
            }
        }
//        log.addLog("Cart init: "+getTypInfoString(), INFO);
        
        if (bankMax == 1)
        {
            // if cartridge consists of only one file
            // than load it "normally"
            // this enables us to load
            // multibanks with one file only
            // if number of roms is > 1, than each file must not be greater than 32768!
            if (!load(makeGlobalAbsolute(cartProp.mFullFilename.elementAt(0)))) 
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
                String romName = makeGlobalAbsolute(cartProp.mFullFilename.elementAt(bank));
                bankFileNames[bank] = "";
                // only load available files
                // skipping unavailable might seems strange,
                // but vecflash can have "empty" slots - so thus does not have to be an error
                if (cartProp.mFullFilename.elementAt(bank).trim().length() == 0) continue;
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

            if (!isPB6IRQBankswitch)
            {
                if (getBankCount()<3) // assume vecflash for more than 2 banks
                {
                    setBank(previousExternalLineB ? 1 : 0);
                    log.addLog("cart: init " + toString(cartProp), INFO);
                    return true;
                }
            }
        }
        
        if (extraRam2000_2800_2k_Enabled)
        {
            extraRam = new byte[2048];
        }
        if (extraRam8000_8800_2k_Enabled)
        {
            extraRam = new byte[2048];
            setPB6FromCartridge(false);
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

        if (cartProp.mConfigOverwrite)
        {
            VideConfig config = VideConfig.getConfig();
            config.autoSync = cartProp.mCF_AutoSync;
            config.ramAccessAllowed = cartProp.mCF_AllowROMWrite;
            config.romAndPcBreakpoints = cartProp.mCF_ROM_PC_BreakPoints;
            
            if ((cartProp.mCF_IntegratorMaxX != 0) && (cartProp.mCF_IntegratorMaxY != 0))
            {
                config.ALG_MAX_X = cartProp.mCF_IntegratorMaxX;
                config.ALG_MAX_Y = cartProp.mCF_IntegratorMaxY;
            }
            
            if (cartProp.mCF_OverlayThreshold != 0)
            {
                config.JOGLOverlayAlphaThreshold = cartProp.mCF_OverlayThreshold;
            }
            if (cartProp.mCF_DotdwellDivisor != 0)
            {
                config.JOGLDotDwellDivisor = cartProp.mCF_DotdwellDivisor;
            }
        }
        
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
            if (!load(makeGlobalAbsolute(cartProp.mFullFilename.elementAt(0)))) 
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
                String romName = makeGlobalAbsolute(cartProp.mFullFilename.elementAt(bank));
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
            if (data.length>MAX_BANK_SIZE)
            {
                log.addLog("Cart: load() multi part rom is larger than "+MAX_BANK_SIZE+", additional data is ignored! - "+filenameRom, WARN);
            }
            
            int length = data.length;
            if (length > MAX_BANK_SIZE)
                bankLength[bank] = MAX_BANK_SIZE;
            else
                bankLength[bank] = length;

            cart[bank] = new int[MAX_BANK_SIZE]; // memory of a bank is allways 32768, since we need fillers
            for (int i=0; i< MAX_BANK_SIZE;i++)
            {
                if (i>=data.length)
                    cart[bank][i] = 1; // polar rescue needs this!
                else
                    cart[bank][i] = data[i]&0xff;;
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
        if (filenameRom.toLowerCase().endsWith(".v4e"))
        {
            // do something
            boolean ret = loadV4E(filenameRom);
            return ret;
        }
        
        
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

            if (loadLen > MAX_BANK_SIZE)
            {
                if (!_32kOnly)
                    log.addLog("Cartridge size > 32k, bankswitching assumed!", WARN);
            }

            bankMax=(data.length +(MAX_BANK_SIZE-1))/MAX_BANK_SIZE; // file chunks of 37268 size are banks

            if (_32kOnly)
            {
                if (loadLen > MAX_BANK_SIZE)
                {
                    loadLen = MAX_BANK_SIZE;
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
                if (length > MAX_BANK_SIZE)
                    bankLength[b] = MAX_BANK_SIZE;
                else
                    bankLength[b] = length;
                length -= bankLength[b];
                cart[b] = new int[MAX_BANK_SIZE]; // memory of a bank is allways 32768, since we need fillers
                for (int i=0; i< MAX_BANK_SIZE;i++)
                {
                    if (b*MAX_BANK_SIZE+i>=data.length)
                        cart[b][i] = 1; // polar rescue needs this!
                    else
                        cart[b][i] = data[b*MAX_BANK_SIZE+i]&0xff;
                }
            }
            
            if (bankMax>1)
            {
                if (getBankCount()<3) 
                {
                    if (!isPB6IRQBankswitch)
                        setBank(previousExternalLineB ? 1 : 0);
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
        to.atmel = from.atmel.clone();
        to.atmel.cart = to;
        to.ds2430 = from.ds2430.clone();
        to.ds2430.cart = to;
        to.ds2431 = from.ds2431.clone();
        to.ds2431.cart = to;
        to.microchip = from.microchip.clone();
        to.microchip.cart = to;
        to.isPB6IRQBankswitch = to.isPB6IRQBankswitch;
        
        if (from.dualvec == null) 
        {
            to.dualvec = null;
        }
        else
        {
            to.dualvec = from.dualvec.clone();
            to.dualvec.cart = to;
        }

        // todo FLASH
        to.vecx = from.vecx;
    }

    private static enum VECFLASH
    {
        RESET,  LOW_CHECK,  LOW_PULSE;
    }    
    VECFLASH vfState = VECFLASH.LOW_PULSE;

    // returns true if bank was switched
    public boolean checkBankswitchPB6(boolean externalLine , long cycles)
    {
        if (v4e_16k_bankswitch) return false; // no pb6 bankswitch!
        // only interesting pin is pb6 external
        
        // and even THAT is only interesting if it changed
        if (previousExternalLineB != externalLine)
        {
            previousExternalLineB = externalLine;
            
            if (isPB6IRQBankswitch) 
            {
                setPB6IRQBank();
                return true;
            }
            
            
            if (getBankCount()<3) // assume vecflash for more than 2 banks
            {
                setBank(previousExternalLineB ? 1 : 0);
                return true;
            }
            if (getBankCount()>32) // assume vecflash for more than 2 banks
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
            
            
            // this is actual copy and paste code from ParaJVE

 //do
        {
              switch (vfState)
              {
                    case RESET: 
            if (!externalLine)
            {
                            setBank(0);
                            switched = true;
                            vfState = VECFLASH.LOW_CHECK;
            }
                            break;
                    case LOW_CHECK: 
                        if (!externalLine)
                        {
                            setBank(getCurrentBank()+1);
                            switched = true;
                            vfState = VECFLASH.LOW_PULSE;
                            oldCycles = cycles;
                        }
                        return switched;
                    case LOW_PULSE: 
                        if (!externalLine)
                        {
                            vfState = VECFLASH.LOW_PULSE;
                        }
                        else
                        {
                            long l = cycles - oldCycles;
                            if (l < 80L)
                            {
                                  vfState = VECFLASH.LOW_CHECK;
                                  return switched;
                            }
                            vfState = VECFLASH.RESET;
                        }
                        break;
              } 
        }
//            while (true);
 return switched;
        }        
        return false;
        
    }
    private void setPB6IRQBank()
    {
        // 2 bit number
        // PB6 is bit 0
        // IRQ is bit 1

        // IRQ is per default (non active) = 1
        // PB6 is per default 1
        //
        // so the "start" bank is actually bank 3
        int newBank = 0;
        if (previousExternalLineB) newBank +=1;
        if (previousExternalLineIRQ) newBank +=2;
        setBank(newBank);
    } 
    
    // returns true if bank was switched
    // IRQLine is zero active
    // if IRQ occured the IRQLine is FALSE
    public boolean checkBankswitchIRQ(boolean IRQLine , long cycles)
    {
        if (!isPB6IRQBankswitch) return false;
        // and even THAT is only interesting if it changed
        if (previousExternalLineIRQ != IRQLine)
        {
            previousExternalLineIRQ = IRQLine;
            setPB6IRQBank();
            return true;
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
        currentPB6 = pb6;
        if (isAtmel)
        {
            atmel.linePB6In(pb6);
        }
        if (is2430a)
        {
            ds2430.linePB6In(pb6);
        }
        if (isDS2431)
        {
            ds2431.linePB6In(pb6);
        }
        if (isMicrochip)
        {
            microchip.linePB6In(pb6);
        }
        
        if (vecx.config.enableBankswitch)
        {
            // send changed via port b out put to cartridge
            boolean changed = checkBankswitchPB6(pb6, vecx.cyclesRunning);
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
            dualvec.linePB6In(pb6);
        }
        if (isXmas)
        {
            xMasLED.linePB6In(pb6);
        }
    }

    // line IRQ
    // is set FROM vectrex
    // can be used by any "device" on line IRQ
    // if IRW = true, than IRQ occured
    public void setIRQFromVectrex(boolean irq)
    {
        if (vecx==null) return;
        currentIRQ = !irq;
        if (isAtmel)
        {
            // ATTENTION IRQ is zero active -
            // at the moment that is falsly
            // implemented in vecxi!!!!
            
            atmel.lineIRQIn(!irq);
        }
        if (isPB6IRQBankswitch)
        {
            if (vecx.config.enableBankswitch)
            {
                // send changed via port b out put to cartridge
                // IRQ "external" line is zero active -> therefore invert the IRQ
                boolean changed = checkBankswitchIRQ(!irq, vecx.cyclesRunning);
                if (changed)
                {
                    vecx.checkBankswitchBreakpoint();
                }
            }
        }
        
    }    
    // is set from device
    public void setPB6FromCartridge(boolean b)
    {
        currentPB6 = b;
        if (vecx != null)
            vecx.setPB6FromExternal(b);
    }
    public void setCyclesRunning(long n)
    {
        if (isSIDEnabled())
        {
            vsid.setCyclesRunning(n);
        }
    }
    public void updateSound()
    {
        if (sidEnabled)
        {
            vsid.updateSound();
        }
    }
    public State getSidState()
    {
        if (!sidEnabled)
            return null;
        if (vsid == null) return null;
        return vsid.sid.read_state();
    }
    public boolean isSIDEnabled()
    {
        return sidEnabled;
    }
    
    public void cartStep(long cycles)
    {
        if (vecx==null) return;
        
        
        if (isAtmel)
        {
            atmel.step(cycles);
        }
        if (is2430a)
        {
            ds2430.step(cycles);
        }
        if (isDS2431)
        {
            ds2431.step(cycles);
        }
        if (isMicrochip)
        {
            microchip.step(cycles);
        }
        if (sidEnabled)
        {
            if (vsid == null)
            {
                vsid = new VSID(this);
                vsid.init();
            }
            vsid.step(cycles);
        }
        if (isDualVec)
        {
            dualvec.step(cycles);
        }
        if (flashSupport) // watch lines!
        {
            // todo use device
            checkEraseSequence();
            checkIDSequence();
            checkWriteSequence();
        }
    }
    int eraseAddress = 0;
    int eraseSequenceAddress = 0;
    int eraseSequenceData = 0;
    private void checkEraseSequence()
    {
        int addressBUS = vecx.getAddressBUS();
        int dataBUS = (int) ((vecx.getDataBUS()) & 0xff);

        if ((eraseSequenceAddress == 0) && (addressBUS == 0x5555)) eraseSequenceAddress = 1;
        else if ((eraseSequenceAddress == 1) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x2aaa) eraseSequenceAddress = 2;
        }
        else if ((eraseSequenceAddress == 2) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x2aaa) eraseSequenceAddress = 3;
        }
        else if ((eraseSequenceAddress == 3) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x5555) eraseSequenceAddress = 4;
        }
        else if ((eraseSequenceAddress == 4) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x2aaa) eraseSequenceAddress = 5; 
        }
        else if ((eraseSequenceAddress == 5) && (addressBUS == 0x2aaa) )
        {
            ;
        }
        else if ((eraseSequenceAddress == 5) && (addressBUS != 0x2aaa) )
        {
            eraseAddress = addressBUS;
            eraseSequenceAddress = 6;
        }
        else if ((eraseSequenceAddress == 6) && (addressBUS != eraseAddress) )
        {
            eraseSequenceAddress = 0;
        }
        else eraseSequenceAddress = 0;

        if ((eraseSequenceData == 0) && (dataBUS == 0xaa))
        {
            eraseSequenceData = 1;
        }
        else if ((eraseSequenceData == 1) && ( (dataBUS == 0xaa)||(dataBUS == 0x55) ))
        {
            if (dataBUS == 0x55) eraseSequenceData = 2;
        }
        else if ((eraseSequenceData == 2) && ( (dataBUS == 0x55)||(dataBUS == 0x80) ))
        {
            if (dataBUS == 0x80) eraseSequenceData = 3;
        }
        else if ((eraseSequenceData == 3) && ( (dataBUS == 0xaa)||(dataBUS == 0x80) ))
        {
            if (dataBUS == 0xaa) eraseSequenceData = 4;
        }
        else if ((eraseSequenceData == 4) && ( (dataBUS == 0xaa)||(dataBUS == 0x55) ))
        {
            if (dataBUS == 0x55) eraseSequenceData = 5;
        }
        else if ((eraseSequenceData == 5) && ( (dataBUS == 0x30)||(dataBUS == 0x55) ))
        {
            if (dataBUS == 0x30) 
            {
                eraseSequenceData = 6;
            }
        }
        else if ((eraseSequenceData == 6) &&  (dataBUS == 0x30))
        {
            ;
        }
        else eraseSequenceData = 0;

        if ((eraseSequenceAddress == 6) && (eraseSequenceData == 6))
        {
            log.addLog("Erase sequence ...", INFO);
            eraseSequenceAddress = 0;
            eraseSequenceData = 0;
            int start = eraseAddress & 0xffff000;
            for (int i= start; i<start+4096;i++)
            {
                cart[currentBank][i%MAX_BANK_SIZE] = 0xff;
            }
        }
    }
    int idSequenceAddress = 0;
    int idSequenceData = 0;
    private void checkIDSequence()
    {
        int addressBUS = vecx.getAddressBUS();
        int dataBUS = (int) ((vecx.getDataBUS()) & 0xff);

        if ((idSequenceAddress == 0) && (addressBUS == 0x5555)) idSequenceAddress = 1;
        else if ((idSequenceAddress == 1) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x2aaa) idSequenceAddress = 2;
        }
        else if ((idSequenceAddress == 2) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x5555) idSequenceAddress = 3;
        }
        else if ((idSequenceAddress == 3) && (addressBUS == 0x5555) )
        {
            ; 
        }
        else if ((idSequenceData == 3) && (idSequenceAddress == 3)  )
        {
            ;
        }
        else idSequenceAddress = 0;

        if ((idSequenceData == 0) && (dataBUS == 0xaa))
        {
            idSequenceData = 1;
        }
        else if ((idSequenceData == 1) && ( (dataBUS == 0xaa)||(dataBUS == 0x55) ))
        {
            if (dataBUS == 0x55) idSequenceData = 2;
        }
        else if ((idSequenceData == 2) && ( (dataBUS == 0x55)||(dataBUS == 0x90) ))
        {
            if (dataBUS == 0x90) idSequenceData = 3;
        }
        else if ((idSequenceData == 3) && (dataBUS == 0x90) )
        {
            ;
        }
        else if ((idSequenceData == 3) && (idSequenceAddress == 3)  )
        {
            log.addLog("Id Sequence on", INFO);
        }
        else idSequenceData = 0;

        if ((idSequenceAddress == 3) && (idSequenceData == 3))
        {
            if (dataBUS==0xf0)
            {
                idSequenceAddress = 0;
                idSequenceData = 0;
                log.addLog("Id Sequence off", INFO);
            }
        }
        
    }
    int writeSequenceAddress = 0;
    int writeSequenceData = 0;
//    int writeAddress = 0;
//    int writeData = 0;
    private void checkWriteSequence()
    {
        int addressBUS = vecx.getAddressBUS();
        int dataBUS = (int) ((vecx.getDataBUS()) & 0xff);

        if ((writeSequenceAddress == 0) && (addressBUS == 0x5555)) writeSequenceAddress = 1;
        else if ((writeSequenceAddress == 1) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x2aaa) writeSequenceAddress = 2;
        }
        else if ((writeSequenceAddress == 2) && ((addressBUS == 0x5555) || (addressBUS == 0x2aaa) ))
        {
            if (addressBUS == 0x5555) writeSequenceAddress = 3;
        }
        else if ((writeSequenceAddress == 3) && (addressBUS == 0x5555) )
        {
            ; 
        }
        else if ((writeSequenceData >= 3) && (writeSequenceAddress == 3)  )
        {
//            writeAddress = addressBUS;
            writeSequenceAddress=4;
        }
        else if ((writeSequenceData >= 3) && (writeSequenceAddress == 4)  )
        {
        }
        else writeSequenceAddress = 0;

        if ((writeSequenceData == 0) && (dataBUS == 0xaa))
        {
            writeSequenceData = 1;
        }
        else if ((writeSequenceData == 1) && ( (dataBUS == 0xaa)||(dataBUS == 0x55) ))
        {
            if (dataBUS == 0x55) writeSequenceData = 2;
        }
        else if ((writeSequenceData == 2) && ( (dataBUS == 0x55)||(dataBUS == 0xA0) ))
        {
            if (dataBUS == 0xA0) writeSequenceData = 3;
        }
        else if ((writeSequenceData == 3) && (dataBUS == 0xA0) )
        {
            ;
        }
        else if ((writeSequenceData == 3) && (writeSequenceAddress >= 3)  )
        {
            writeSequenceData = 4;
        }
        else if ((writeSequenceData == 4) && (writeSequenceAddress >= 3)  )
        {
        }
        else writeSequenceData = 0;

        
    }

    public void reset()
    {
        if (vecx==null) return;
        
        if (isAtmel)
        {
            atmel.reset();
        }
        if (is2430a)
        {
            ds2430.reset();
        }
        if (isDS2431)
        {
            ds2431.reset();
        }
        if (isMicrochip)
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
    public String dumpCurrentROM()
    {
        String filename = Global.mainPathPrefix+"tmp"+File.separator+"dump.rom";
        FileOutputStream output=null;
        try
        {
            output = new FileOutputStream(filename, false);
            if (cart.length>=2)
            {
                // 64K
                for (int i=0; i<cart[0].length; i++)
                {
                    output.write(cart[0][i]);
                }
                for (int i=0; i<cart[1].length; i++)
                {
                    output.write(cart[1][i]);
                }
            }
            else
            {
                // 32k
                for (int i=0; i<cart[0].length; i++)
                {
                    output.write(cart[0][i]);
                }
            }
        }
        catch (Throwable e)
        {
            return null;
        }
        finally
        {
            if (output != null)
            {
                try
                {
                    output.close();            
                }
                catch (Throwable e)
                {
                    return null;
                }
            }
        }
        return filename;
    }
            
    public void initFromStateSave()
    {
        if (sidEnabled)
        {
            vsid.recallState();
        }
    }
    public void initStateSave()
    {
        if (sidEnabled)
        {
            vsid.rememberState();
        }
    }
    
    
    // load routine for "ROM" files
    // (instead of cartridge files)
    // there is NO additional information as of now
    // (TODO: check for CRC and get additional information from that)
    public boolean loadV4E(String filenameRom)
    {
        cartName = filenameRom;
        if (!new File(filenameRom).exists()) return false;
        if (new File(filenameRom).isDirectory()) return false;
        
        try
        {
            Path path = Paths.get(filenameRom);
            byte[] data = Files.readAllBytes(path);
            loadLen = data.length;

            boolean hasHeader = true;
            if (data[0] != 'V') hasHeader = false;
            if (data[1] != '4') hasHeader = false;
            if (data[2] != 'E') hasHeader = false;
            if (data[3] != 'B') hasHeader = false;
            
            if (!hasHeader)
            {
                hasHeader = true;
                if (data[0] != 'V') hasHeader = false;
                if (data[1] != '4') hasHeader = false;
                if (data[2] != 'E') hasHeader = false;
                if (data[3] != 'C') hasHeader = false;
                if (hasHeader)
                {
                    log.addLog("Crypted V4E file found - cannot decrypt - cannot load...", WARN);
                }
                else
                    log.addLog("No valid header found in V4E file", WARN);
                return false;
            }
            
/*
 * 4/5   :  cartridge type (upper bits: version no.)
 *           0 - read only ROM
 *           1 - ROM plus RAM
 *           2 - VecFever cartridge
 *           3 - ROM cartridge with DS2430 1-wire chip
 *           4 - ROM cartridge with DS2431 1-wire chip
 *           5 - ROM cartridge with xx 1-wire chip (Vector Pilot)
 *           6 - ROM cartridge with 50k flat rom space
 *           7 - ROM cartridge with 16k rom banks at 0x8000
            
 VecFever 16K Bankswitch:
            
            
            
            Here's a test firmware where I have added both v4e+decompress code in the ramdisk and the 50k and now -tadaaaa- brand new
and shiny 32k+16k bank switched mode to the VecFever.
 
I've also attached my test bin - a 32k+4x16k binary where I switch to all banks per frame and display a text string in those banks.
Plus I've put the previous main48k.bin both in the 50k format and the 32+1*16k format, also works (and you don't need to specify ‚50K'
in the GCE year since the cart. type is part of the v4e header).
 
There are of course a few boundary conditions: most importantly the resulting .v4e needs to be <=64k and can only hold
up to four 16k banks.
And of course you need to create a v4e that you can hand over to the VecFever - there's no way to give it an uncompressed 16k multibank
binary. The source for a command line utility that does just that is also part of the test folder.
 
The way this is implemented is straightforward:
0x0000-0x7FFF  32K fixed ROM
0x8000-0xBFFF 16K banked ROM
0xC000-0xC003 bank select
 
i've refrained from a single bank reg. at the last second and used a safer approach by using the lower adr. bits - just like
the original Atari 2600 bank switching - so selecting banks is via access to (C000+bank_no), like this:
main            jsr     DP_to_D0
                JSR     Wait_Recal              ; Vectrex BIOS recalibration
                JSR     Intensity_5F
                ldu     #text_1
                jsr     Print_Str_hwyx
                lda     $c000                   ; select bank 0
                ldu     #$8000
                jsr     Print_Str_hwyx
                lda     $c003                   ; select bank 3
                ldu     #$8000
                jsr     Print_Str_hwyx
                lda     $c001                   ; select bank 1
                ldu     #$8000
                jsr     Print_Str_hwyx
                lda     $c002                   ; select bank 2
                ldu     #$8000
                jsr     Print_Str_hwyx
                bra     main
 

            
            
*/            
            int v4eType = (data[4]&0xff)*256+(data[5]&0xff);
            log.addLog("V4E cart type: "+v4eType, INFO);
            int v4eBanks = (data[6]&0xff)*256+(data[7]&0xff);
            log.addLog("    banks    : "+v4eBanks, INFO);

            long crcSeed = VFCompress.CRC_SEED;
            
            long[] bankedCRC = new long[v4eBanks];
            int[] bankedSize = new int[v4eBanks];

            bankedCRC[0] = (data[8]&0xff)*256*256*256 + (data[9]&0xff)*256*256+ (data[10]&0xff)*256 +(data[11]&0xff);
            
            bankedSize[0] = (data[12]&0xff)*256 +(data[13]&0xff); // zipped size


            int index = 14;
            for (int banks=1; banks<v4eBanks; banks++)
            {
                bankedCRC[banks] = (data[index]&0xff)*256*256*256 + (data[index+1]&0xff)*256*256+ (data[index+2]&0xff)*256 +(data[index+3]&0xff);
                bankedSize[banks] = (data[index+4]&0xff)*256 +(data[index+5]&0xff); // zipped size
                index+=6;
            }                

            cart = new int[v4eBanks][];     // and so many banks as memory data
            bankLength = new int[v4eBanks]; // so many bank length we need

            

            bankMax=v4eBanks; // file chunks of 37268 size are banks

            bankFileNames= new String[v4eBanks];

            if (loadLen == 0) 
            {
                log.addLog("Cartridge not loaded, loadLen = 0", WARN);
                return false;
            }
            
            // all types are loaded with below zip bank loading.
            // different types are sorted out later
            
            int length = loadLen;
            for (int b=0;b<bankMax;b++)
            {
                int zipedSize = bankedSize[b];
                
                // todo
                int bankSize = 32768; // we don't know the unzipped size, so we reserve memory for a whole 32k Bank
                byte[] buffer = new byte[bankSize]; 
                
                bankFileNames[b] = filenameRom;

                cart[b] = new int[bankSize];
                
                /*
                TODO verify CRC
                                byte[] crcBuffer = new byte[zipedSize];
                                for (int tt=0;tt<zipedSize;tt++)
                                    crcBuffer[tt] = data[tt+index];
        
                
                 int newDzipdata_crc  = VFCompress.mycrc32(VFCompress.CRC_SEED, crcBuffer, zipedSize);
                System.out.println("CRC Verify "+b+": "+newDzipdata_crc);            
                */

                
                index = dunzip(buffer, data, zipedSize, index);
                
                bankLength[b] = lastUnzippedSize; // todo correct it
                for (int i=0; i< lastUnzippedSize;i++)
                {
                    cart[b][i] = buffer[i]&0xff;
                }
            }
            
            if ((v4eType&0xff) == 0)
            {
                
            }
            if ((v4eType&0xff) == 1)
            {
                // no specifics given, Thomas said "switch all on" :-)
                // this on the other hand is with the current RAM implementation not possible
                // therefore we just make ther complete "ROM" writeable
                vecx.config.ramAccessAllowed = true;
                
                // for this to work 
                // we must also ensure that we have allocated enought ROM memory...
                // which should be all right
            }
            if ((v4eType&0xff) == 2)
            {
                isVecFeverCartridge = true; // possibly extensive bankswitching (Bad apple)
                // for now - dum the banks

                String to = Global.mainPathPrefix+"tmp"+File.separator+"";
                for (int b=0;b<bankMax;b++)
                {
                    if (b==0)
                   de.malban.util.UtilityFiles.writeBinFile(to+b+".bin", cart[b], false);
                }


                
                
            }
            if ((v4eType&0xff) == 3)
            {
                is2430a = true;
            }
            if ((v4eType&0xff) == 4)
            {
                isDS2431 = true;
            }
            if ((v4eType&0xff) == 5)
            {
                isMicrochip = true;
            }
/*            
 *           0 - read only ROM
 *           1 - ROM plus RAM
 *           2 - VecFever cartridge
 *           3 - ROM cartridge with DS2430 1-wire chip
 *           4 - ROM cartridge with DS2431 1-wire chip
 *           5 - ROM cartridge with xx 1-wire chip (Vector Pilot)
 *           6 - ROM cartridge with 50k flat rom space
 *           7 - ROM cartridge with 16k rom banks at 0x8000            
           */ 
            
            
            if ((v4eType&0xff) == 7)
            {
                if (bankMax<=2) v4eType = 6;
            }
            if ((v4eType&0xff) == 7)
            {
                
                // for each bank we construct a "flat" model of 50k
                // upon bankswitch than we only need to switch to another flat model
                // if the base is "writeable" this will result in inconsistency!
                
                MAX_BANK_SIZE = 32768+32768/2;
                
                
                int[][] cart2 = new int[bankMax-1][MAX_BANK_SIZE];     // and so many banks as memory data
                int[] bankLength2 = new int[bankMax-1]; // so many bank length we need
                String[] bankFileNames2= new String[bankMax-1];
                

                for (int b=1; b<bankMax; b++)
                {
                    bankLength2[b-1] = MAX_BANK_SIZE;
                    bankFileNames2[b-1] = filenameRom;
                    int[] ibuffer = cart2[b-1]; 

                    for (int i=0; i< 32768; i++)
                    {
                        if (i<cart[0].length)
                            ibuffer[i] = cart[0][i];
                        else
                            ibuffer[i] = 1;
                    }
                    for (int i=0; i< 32768/2; i++)
                    {
                        if (i<cart[b].length)
                            ibuffer[i+32768] = cart[b][i];
                        else
                            ibuffer[i+32768] = 1;
                    }                
                }
                cart = cart2;    
                bankLength = bankLength2; 
                bankFileNames = bankFileNames2;

                rom48KEnabled = true;
                v4e_16k_bankswitch = true;
                currentBank = 0;
                
                bankMax = bankMax-1;
            }
            
            // 6 - ROM cartridge with 50k flat rom space
            if ((v4eType&0xff) == 6)
            {
                rom48KEnabled = true;
                MAX_BANK_SIZE = 32768+32768/2;

                int[] ibuffer = new int[MAX_BANK_SIZE]; 
                
                for (int i=0; i< 32768; i++)
                {
                    if (i<cart[0].length)
                        ibuffer[i] = cart[0][i];
                    else
                        ibuffer[i] = 1;
                }
                if (bankMax>1)
                {
                    for (int i=0; i< 32768/2; i++)
                    {
                        if (i<cart[1].length)
                            ibuffer[i+32768] = cart[1][i];
                        else
                            ibuffer[i+32768] = 1;
                    }

                }
                else
                {
                    MAX_BANK_SIZE = 32768;
                }
                cart = new int[1][];     // and so many banks as memory data
                bankMax = 1;
                bankLength = new int[1]; // so many bank length we need
                bankFileNames= new String[1];
                
                cart[0] = ibuffer;
                bankLength[0] = MAX_BANK_SIZE;
                bankFileNames[0] = filenameRom;
                
            }            
            
            
        }
        catch (Throwable e)
        {
            e.printStackTrace();
            log.addLog(e, WARN);
            return false;
        }
        if (bankMax>1)
            currentBank = 1;
        return true;
    }        
    
    

    /* simple zip.  encodes as:
     * 1iiiiiii 0nnnnnnn - repeat 128-n (1-128) bytes from current + 1i (-ve 2s cmp)
     * 1iiiiiii 1jjjjjjj nnnnnnnn - repeat 128-n (1-256) bytes from current + 1ij
     * 0nnnnnnn - directly copy next 128-n (1-128) bytes */

        //  DECOMPRESSION ROUTINE

    final static int BACKREFERENCESIZE =0x1000;
    int window_pos;
    int dump_backref(int outsize, byte[] window, byte[] dest, int offset, int count) 
    {
            for (; count > 0; count--) 
            {
                    int from = window_pos + offset;
                    while (from < 0) 
                    {
                            from += BACKREFERENCESIZE;
                    }
                    
                    
                    dest[outsize++] = window[from];
                    window[window_pos++] = window[from];
                    window_pos %= BACKREFERENCESIZE;
            }
        return (outsize);
    }
    
    int lastUnzippedSize = 0;
    
    int dunzip(byte[] dest, byte[] source, int zipSize, int startPosition) 
    {
        int outsize = 0;
        window_pos = 0;
        int dunzipposition = 0;
        byte[] window = new byte[BACKREFERENCESIZE];        //= scratch_decompressbuffer_mem;
        lastUnzippedSize = 0;
        while (dunzipposition < zipSize) 
        {
            byte a = source[startPosition+dunzipposition++];
            if ((a & 0x80) !=0)
            {
                int b = source[startPosition+dunzipposition++];
                if (dunzipposition > zipSize) 
                {
                    System.out.println("ERROR UNZIP");
                }
                if ((b & 0x80) != 0)
                {
                    /* long backref */
                    int offset = (a << 7) | (b & 0x7f);
                    offset = offset & 0x7fff;
                    offset = -((offset ^ 0x7fff) + 1);
                    int count = source[startPosition+dunzipposition++];
                    if (dunzipposition > zipSize) 
                    {
                        System.out.println("ERROR UNZIP");
                    }
                    count = (384 - count) & 0xff;
                    if (count == 0) count = 256;
                    outsize = dump_backref(outsize, window, dest, offset, count);
                } 
                else 
                {
                    /* short backref */
                    int offset = -(   ((int)((byte)(a ^ 0xff))) + 1);
                    int count = 128 - b;
                    outsize = dump_backref(outsize, window, dest, offset, count);
                }
            } 
            else 
            {
                int count;
                for (count = 128 - a; count > 0; count--) 
                {
                    byte c = source[startPosition+dunzipposition++];
                    if (dunzipposition > zipSize) 
                    {
                        System.out.println("ERROR UNZIP");
                        break;
                    }
                    dest[outsize++] = c;
                    window[window_pos++] = c;
                    window_pos %= BACKREFERENCESIZE;
                }
            }
        }
        lastUnzippedSize= outsize;
        return dunzipposition+startPosition;
    }    
}
