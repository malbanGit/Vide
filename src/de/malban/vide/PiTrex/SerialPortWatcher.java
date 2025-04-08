/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.PiTrex;

import com.fazecast.jSerialComm.SerialPort;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
/**
 *
 * @author salom
 */
public class SerialPortWatcher {
    private HashSet<String> knownPorts = new HashSet<>();
    protected int pollingInterval = 1000; // 1 second

    private boolean threadActive = false;
    protected interface PortListener 
    {
        void onPortAdded(String portName);
        void onPortRemoved(String portName);
    }

    private PortListener listener;

    protected SerialPortWatcher(PortListener listener) {
        this.listener = listener;
    }
    protected void stopWatching() 
    {
        threadActive = false;
    }

    protected void startWatching() 
    {
        if (threadActive) return;
        new Thread(() -> 
        {
            while (threadActive) 
            {
                try 
                {
                    
                    SerialPort[] ports = SerialPort.getCommPorts();
                    HashSet<String> currentSet = new HashSet<String>();
                    for (SerialPort p: ports)
                    {
                        if (!p.getDescriptivePortName().toLowerCase().contains("dial"))
                        {
                            currentSet.add(p.getDescriptivePortName());
                        }                        
                    }

                    // Detect added ports
                    for (String port : currentSet) 
                    {
                        if (!knownPorts.contains(port)) 
                        {
                            listener.onPortAdded(port);
                        }
                    }

                    // Detect removed ports
                    for (String port : knownPorts) 
                    {
                        if (!currentSet.contains(port)) 
                        {
                            listener.onPortRemoved(port);
                        }
                    }

                    knownPorts = currentSet;
                    Thread.sleep(pollingInterval);
                } catch (Exception e) 
                {
                    e.printStackTrace();
                }
            }
        }).start();
        threadActive = true;
    }
}