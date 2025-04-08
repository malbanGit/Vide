/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.PiTrex;
import com.fazecast.jSerialComm.SerialPort;
import static com.fazecast.jSerialComm.SerialPort.NO_PARITY;
import static com.fazecast.jSerialComm.SerialPort.ONE_STOP_BIT;
import com.fazecast.jSerialComm.SerialPortDataListener;
import com.fazecast.jSerialComm.SerialPortEvent;
import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import static de.malban.vide.PiTrex.PiTrexEvent.PITREX_CONNECTION_STATE_CHANGED;
import de.malban.vide.PiTrex.SerialPortWatcher.PortListener;
import de.malban.vide.VideConfig;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author salom
 */
public class PiTrexSingleton implements PortListener
{
    private static PiTrexSingleton instance;
    public static synchronized PiTrexSingleton getPiTrex() 
    {
        if (instance == null) { // First check (no locking)
            synchronized (PiTrexSingleton.class) {
                if (instance == null) { // Second check (with locking)
                    instance = new PiTrexSingleton();
                }
            }
        }
        return instance;
    }    

    
    VideConfig config = VideConfig.getConfig();
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private final List<PiTrexListenerInterface> listeners = new ArrayList<>();
    SerialPort ubxPort = null;
    SerialPort[] ports;
    SerialPortWatcher swatcher = new SerialPortWatcher(this); 
    
    private PiTrexSingleton() 
    {
        init();
        if (config.piTrexSerialName.length() != 0)
        {
            startwatchSerialPorts();
        }
    }
    public boolean isReady()
    {
        return ubxPort!=null;
    }
    void init()
    {
        fillSerial();
        connect(config.piTrexSerialName);
    }
    public SerialPort[] getSerialPorts()
    {
        return ports;
    }
    public SerialPort getActiveSerialPort()
    {
        return ubxPort;
    }
    void deinit()
    {
        if (ubxPort != null)
        {
            ubxPort.removeDataListener();
            ubxPort.closePort();
        }
        ubxPort = null;
        currentName = "";
    }    
    public void fillSerial()
    {
        ports = SerialPort.getCommPorts();
                
        ArrayList<SerialPort> pp = new ArrayList<SerialPort>();
        for (SerialPort p: ports)
        {
            if (!p.getDescriptivePortName().toLowerCase().contains("dial"))
            {
                pp.add(p);
            }
        }
        ports = pp.toArray(new SerialPort[0]);
    }
    public void rescanConnect()
    {
        disconnect();
        init();
    }
    public boolean connect(String name)
    {
        int index = -1;
        int counter=0;
        for (SerialPort p: ports)
        {
            if (p.getDescriptivePortName().equals(name))
            {
                index = counter;
                break;
            }
            counter++;
        }
        return connect(index);
    }
    private int getConnectedIndex()
    {
        if (ubxPort == null) return -1;
        if (currentName.length()==0)  return -1;
        int counter=0;
        fillSerial();
        for (SerialPort p: ports)
        {
            if (p.getDescriptivePortName().equals(currentName))
            {
                return counter;
            }
            counter++;
        }
        return -1;
    }
    String currentName="";
    boolean alreadyConnected() // 
    {
        if (currentName.length()==0) return false;
        if (ubxPort == null) 
        {
            disconnect();
            return false;
        }
        fillSerial();
        for (SerialPort p: ports)
        {
            if (p.getDescriptivePortName().equals(currentName))
            {
                if (ubxPort.isOpen()) return true;
                disconnect();
                return false;
            }
        }
        disconnect();
        return false;
    }
    boolean alreadyConnected(int index)
    {
        if (index == -1) return false;
        if (currentName.length()==0) return false;
        
        if (ports.length<=index) return false;
        if (ports[index].getDescriptivePortName().equals(currentName))
            return true;
        return false;
    }
    public boolean disconnect()
    {
        if (!isReady()) return false;
        if (ubxPort != null)
        {
            ubxPort.removeDataListener();
            ubxPort.closePort();
            ubxPort = null;
        }
        ubxPort = null;
        currentName="";
        notifyListeners(new PiTrexEvent(PITREX_CONNECTION_STATE_CHANGED)); 
        log.addLog("PiTrex: Serial port disconnected.");
        return true;
    }
    public boolean connect(int index)
    {
        if (alreadyConnected(index)) return true;
        if (ubxPort != null)
        {
            ubxPort.removeDataListener();
            ubxPort.closePort();
            ubxPort = null;
        }
        if (index == -1) return false;
        if (ports.length<=index) return false;
        ubxPort = ports[index];
        boolean isReady = ubxPort.openPort();
        if (!isReady)
        {
            if (ubxPort!=null)
            {
                log.addLog("PiTrex: Serial port '"+ubxPort.getDescriptivePortName()+"' available, but cannot be opened. Opened in another terminal?");
            }
            ubxPort = null;
            currentName="";
            return !isReady;
        }
        currentName = ubxPort.getDescriptivePortName();
        int baud = 921600;
        ubxPort.setBaudRate(baud);
        ubxPort.setNumDataBits(8);
        ubxPort.setParity(NO_PARITY);
        ubxPort.setNumStopBits(ONE_STOP_BIT);
        
        ubxPort.setBaudRate(config.piTrexBaud);
        ubxPort.setNumDataBits(config.piDataBits);
        ubxPort.setParity(config.piParity);
        ubxPort.setNumStopBits(config.piStopBit);
        ubxPort.setComPortTimeouts(SerialPort.TIMEOUT_NONBLOCKING, 1000, 0);

        
        ubxPort.setComPortTimeouts(SerialPort.TIMEOUT_NONBLOCKING, 1000, 0);

        ubxPort.addDataListener(listener);
        toCard(""+((char)0x0a)); // clear possible wrong buffer
        toCard(""+((char)0x0a)); // clear possible wrong buffer
        notifyListeners(new PiTrexEvent(PITREX_CONNECTION_STATE_CHANGED)); 
        log.addLog("PiTrex: Serial port '"+ubxPort.getDescriptivePortName()+"' connected.");

        return isReady;
    }    
    
    void toCard(byte[] buffer)
    {
        try
        {
            ubxPort.writeBytes(buffer, buffer.length);
            ubxPort.getOutputStream().flush();
        }
        catch (Throwable e)
        {
            log.addLog(e);
        }
    }
    void toCard(String buffer)
    {
        String ret = "" + ((char)0x0a);
        buffer = de.malban.util.UtilityString.replace(buffer, "\n", ret);
        toCard(buffer.getBytes());
    }

    // text must be transfered slower
    // I because text is only registered
    // every 10000 vectrex cycles in the emulation loop
    // PiTrex emulation dependened
    void toCardSepSlow(byte[] buffer)
    {
        int M_L=1;
        byte[] b = new byte[M_L];
        try
        {
            int len = M_L;
            int pos = 0;
            do
            {
                if (buffer.length-pos>M_L)
                    len = M_L;
                else
                    len = buffer.length-pos;
                for (int i=0;i<len; i++) b[i]=buffer[pos+i];
                pos += len;
                
                ubxPort.writeBytes(b, len);
                ubxPort.getOutputStream().flush();
                Thread.sleep(1);
            } while (pos <buffer.length);
        }
        catch (Throwable e)
        {
            log.addLog(e);
        }
    }
    void toCardSepFast(byte[] buffer)
    {
        int M_L=10000000;
        byte[] b = new byte[M_L];
        try
        {
            int len = M_L;
            int pos = 0;
            do
            {
                if (buffer.length-pos>M_L)
                    len = M_L;
                else
                    len = buffer.length-pos;
                for (int i=0;i<len; i++) b[i]=buffer[pos+i];
                pos += len;
                
                ubxPort.writeBytes(b, len);
                ubxPort.getOutputStream().flush();
                Thread.sleep(1);
            } while (pos <buffer.length);
        }
        catch (Throwable e)
        {
            log.addLog(e);
        }
    }
    void toCardSep(String buffer)
    {
        String ret = "" + ((char)0x0a);
        buffer = de.malban.util.UtilityString.replace(buffer, "\n", ret);
        toCardSepSlow(buffer.getBytes());
    }    
    
    void startTransfer(byte[] data, int size, String name)
    {
        Thread one = new Thread("Transfer: "+name) 
        {
            public void run() 
            {
                toCardSep(""+((char)0x0a)); // clear possible wrong buffer
                toCardSep("vlb"+((char)0x0a)); 
                writeSerialNumAscii(size);

                writeSerialBinary(data, size);
                log.addLog("Transfer done");
                toCardSep("vpb"+((char)0x0a)); // 
            }  
        };
        one.start();
    }
    
    
    SerialPortDataListener listener = new SerialPortDataListener() 
    {
        @Override
        public int getListeningEvents() { return SerialPort.LISTENING_EVENT_DATA_AVAILABLE; }
        @Override
        synchronized public void serialEvent(SerialPortEvent event)
        {
            SerialPort comPort = event.getSerialPort();
            int available = comPort.bytesAvailable();
            if (available<0) return;
            byte[] newData = new byte[available];
            notifyListeners(new PiTrexEvent(event)); 
        }
    };    

    void writeSerialNumAscii(int loadLen)
    {
        String n = ""+loadLen+((char)0x0a);
        toCardSep(n);
    }
    void writeSerialBinary(byte[] data, int loadLen)
    {
        byte[] b = new byte[loadLen];
        for(int i=0;i<loadLen; i++) b[i] = data[i];
        toCardSepFast(b);
    }
    
    public int romToPiTrex(byte[] data, int size)
    {
        startTransfer(data, size, "RomTransfer");
        return 0;
    }
    public boolean resetPi()
    {
        if (!isReady()) return false;
        try
        {
            toCardSep(""+((char)0x0a)); // clear possible wrong buffer
            ubxPort.getOutputStream().flush();
            toCardSep("reset"+((char)0x0a));
            ubxPort.getOutputStream().flush();
        }
        catch (Exception x)
        {
            log.addLog(x);
            return false;
        }
        return true;
    }

    public int fileToPiTrex(String p)
    {
        try
        {
            Path path = Paths.get(p);
            byte[] data = Files.readAllBytes(path);
            int loadLen = data.length;
            log.addLog("File '"+p+"' loaded, size: "+loadLen);
            startTransfer(data, loadLen, p);
        }
        catch (Throwable e)
        {
            log.addLog(e, WARN);
            return 1;
        }
        return 0;
    }
    
    // Method to add a listener
    public void addListener(PiTrexListenerInterface listener) {
        if (listener != null) {
            listeners.add(listener);
        }
    }

    // Method to remove a listener
    public void removeListener(PiTrexListenerInterface listener) {
        listeners.remove(listener);
    }

    // Method to notify all listeners of an event
    private void notifyListeners(PiTrexEvent event) {
        for (PiTrexListenerInterface listener : listeners) {
            listener.piTrexEvent(event);
        }
    }
    
    public void stopWatchSerialPorts()
    {
        swatcher.stopWatching();
    }
    public void startwatchSerialPorts()
    {
        startWatchSerialPorts(1000);
    }
    public void startWatchSerialPorts(int intervall)
    {
        swatcher.pollingInterval = intervall;
        swatcher.startWatching();
    }
    
    public void onPortAdded(String portName)
    {
        if (alreadyConnected()) return;
        if (portName.equals(config.piTrexSerialName))
        {
            init();
        }
    }
    public void onPortRemoved(String portName)
    {
        if (ubxPort == null) return;
        if (currentName.length() == 0) return;
        if (currentName.equals(portName))
        {
            disconnect();
        }
    }
}
