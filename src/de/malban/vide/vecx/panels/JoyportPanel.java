/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.vide.vecx.VecXPanel;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.INFO;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.vide.VideConfig;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.vecx.Updatable;
import de.malban.vide.vecx.devices.Imager3dDevice;
import de.malban.vide.vecx.devices.JoyportDevice;
import de.malban.vide.vecx.devices.LightpenDevice;
import de.malban.vide.vecx.devices.VecSpeechDevice;
import de.malban.vide.vecx.devices.VectrexJoyport;
import de.malban.vide.vecx.devices.WheelData;
import java.awt.Color;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import javax.swing.JLabel;

/**
 *
 * @author malban
 */
public class JoyportPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    transient LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    public boolean isLoadSettings() { return true; }
    public VideConfig config = VideConfig.getConfig();

    
    
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    private DissiPanel dissi = null;
    public static String SID = "device";
    boolean nameChanged = false;
    WheelData currentWheel = null;
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    
    public void setDissi(DissiPanel v)
    {
        dissi = v;
        if (dissi == null) return;
    }
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
    }

    @Override public boolean isIcon()
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return false;
        return frame.getInternalFrame(this).isIcon();
    }
    @Override public void setIcon(boolean b)
    {
        CSAMainFrame frame = ((CSAMainFrame)Configuration.getConfiguration().getMainFrame());
        if (frame.getInternalFrame(this) == null) return;
        try
        {
            frame.getInternalFrame(this).setIcon(b);
        }
        catch (Throwable e){}
    }
    
    @Override
    public void closing()
    {
        if (vecxPanel != null) vecxPanel.resetDevice();
        deinit();
    }
    @Override
    public void setParentWindow(CSAView jpv)
    {
        mParent = jpv;
    }
    @Override
    public void setMenuItem(javax.swing.JMenuItem item)
    {
        mParentMenuItem = item;
        mParentMenuItem.setText("Device");
    }
    @Override
    public javax.swing.JMenuItem getMenuItem()
    {
        return mParentMenuItem;
    }
    @Override
    public javax.swing.JPanel getPanel()
    {
        return this;
    }
    public void deinit()
    {
    }
    /**
     * Creates new form RegisterJPanel
     */
    public JoyportPanel() {
        initComponents();
        initWheelList();
    }


    private void update()
    {        
        if (vecxPanel==null) return;
        updateDevice();
        updateLightpen();
        updateVecVox();
        updateVecVoice();
        boolean ok = updateImager();
    }
    void updateDevice()
    {
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        
        if (portDevice.isButton1(false))
            jTextField1.setText("released");
        else
            jTextField1.setText("pressed");
        if (portDevice.isButton2(false))
            jTextField2.setText("released");
        else
            jTextField2.setText("pressed");
        if (portDevice.isButton3(false))
            jTextField3.setText("released");
        else
            jTextField3.setText("pressed");
        if (portDevice.isButton4(false))
            jTextField4.setText("released");
        else
            jTextField4.setText("pressed");
        
        int x = portDevice.getHorizontal()&0xff;
        if (x==0x80)
            jTextField5.setText("no");
        else if (x>0x80)
            jTextField5.setText("right");
        else 
            jTextField5.setText("left");
        jTextField6.setText("$"+String.format("%02X", x));

        int y = portDevice.getVertical()&0xff;
        if (y==0x80)
            jTextField7.setText("no");
        else if (y>0x80)
            jTextField7.setText("up");
        else 
            jTextField7.setText("down");
        jTextField8.setText("$"+String.format("%02X", y));
        
    }
    void updateLightpen()
    {
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof LightpenDevice)) return;
        
        LightpenDevice lightpen = (LightpenDevice)device;
        
        // vectrex coordionates like vector list
        // transformed to upper left corner. (is 0,0)
        // values from 0 to ALG_MAX_X and 0 to ALG_MAX_Y
        
        
        int x = lightpen.lightpenX;
        if (x == LightpenDevice.LIGHTPEN_OUT_OF_BOUNDS)
            jTextField9.setText("n/a");
        else
        {
            int calc_x = (int)x-config.ALG_MAX_X/2;
            boolean neg = calc_x<0;
            int pos = Math.abs(calc_x)&0x0ffff;
            if (neg)
                jTextField9.setText("-$"+String.format("%04X", pos));
            else
                jTextField9.setText("$"+String.format("%04X", pos));
        }
        int y = lightpen.lightpenY;
        if (y == LightpenDevice.LIGHTPEN_OUT_OF_BOUNDS)
            jTextField10.setText("n/a");
        else
        {
            int calc_y = (int)y-config.ALG_MAX_Y/2;
            boolean neg = calc_y<0;
            int pos = Math.abs(calc_y)&0x0ffff;
            if (neg)
                jTextField10.setText("-$"+String.format("%04X", pos));
            else
                jTextField10.setText("$"+String.format("%04X", pos));
        }
        
    }
    void updateVecVox()
    {
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof VecSpeechDevice)) return;
        
        VecSpeechDevice vox = (VecSpeechDevice)device;
        if (vox.isVecVoice()) return;

        
        jTextField15.setText(""+vox.getLowLevelState());
        jTextField22.setText(""+vox.getSyncCycles());
        jTextField18.setText(""+vox.getBitCounterFromVectrex());
        jTextField25.setText(""+vox.getBitFromVectrex());
        jTextField19.setText(""+vox.getInputLine());
        
        
        jTextField23.setText(""+vox.getCommand());
        
        jTextField30.setText(""+((int)(vox.getSpVolume()*127)));
        jTextField29.setText(""+((int)vox.getSpTempo()));
        jTextField31.setText(""+((int)vox.getSpPitch()));
        jTextField34.setText(""+((int)vox.getSpBend()));
        jTextField35.setText(""+((int)vox.getSpRepeat()));
        jTextField36.setText(""+((int)vox.getSpDelay()));

        jTextField27.setText(vox.isSpNextFast()?"yes":"no");
        jTextField28.setText(vox.isSpNextSlow()?"yes":"no");
        jTextField32.setText(vox.isSpNextStress()?"yes":"no");
        jTextField33.setText(vox.isSpNextRelax()?"yes":"no");
        
        jTextField37.setText(""+vox.getQueueLength());
        
    }
    void updateVecVoice()
    {
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof VecSpeechDevice)) return;
        
        VecSpeechDevice vox = (VecSpeechDevice)device;
        if (!vox.isVecVoice()) return;

        
        jTextField16.setText(""+vox.getLowLevelState());
        jTextField24.setText(""+vox.getSyncCycles());
        jTextField20.setText(""+vox.getBitCounterFromVectrex());
        jTextField38.setText(""+vox.getBitFromVectrex());
        jTextField21.setText(""+vox.getInputLine());
        
        
        jTextField26.setText(""+vox.getCommand());
        
        
        
        jTextField49.setText(""+vox.getQueueLength());
        
    }
    boolean updateImager()
    {
        jCheckBox3.setSelected(false);
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return false;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return false;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return false;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return false;
        if (!(device instanceof Imager3dDevice)) return false;
        Imager3dDevice imager = (Imager3dDevice)device;

        
        WheelData d = imager.getWheel();
        if (d == null)
        {
            currentWheel = null; 
            return false;
        }
        if (currentWheel==null)
        {
            currentWheel = d;
            setCurrentWheelAsSelection();
            initWheel();
        }
        else if (currentWheel.id != d.id)
        {
            currentWheel = d;
            setCurrentWheelAsSelection();
            initWheel();
        }
        
        imagerWheel1.setAngle(imager.getAngle());
        jCheckBox3.setSelected(true);
        
        if (jRadioButton2.isSelected())
            jTextField11.setText(""+String.format("%.4f", imager.getSpinPerSecond()));
        jTextField14.setText(""+String.format("%.2f", 360.0-imager.getAngle()));
        
        double spinTime = 1.0/imager.getSpinPerSecond();
        jTextField44.setText(""+String.format("%.6f", spinTime));   
        
        
        jTextField17.setText(""+imager.getCyclePerSpin());
        jTextField39.setText(""+String.format("%.6f", imager.getAnglePerCycle()));   
        

        long low = imager.getPulseLen();
        long wlen = imager.getWaveLen();
        jTextField12.setText(""+low);
        jTextField13.setText(""+wlen);

        double lowMS = ((double)low)* (1.0/1500000.0);
        double highMS = ((double)wlen)* (1.0/1500000.0);
        jTextField41.setText(""+String.format("%.6f", lowMS));
        jTextField40.setText(""+String.format("%.6f", highMS));
        
        long indexPulse = imager.getLastIndexPulse();
        jTextField42.setText(""+indexPulse+"("+imager.getReallyLastIndexPulse()+")");
        double indexPulseMS = ((double)indexPulse)* (1.0/1500000.0);
        jTextField43.setText(""+String.format("%.6f", indexPulseMS));
        
        int colorIndexLeft = imager.getLeftColor();
        if (colorIndexLeft>=0)
            jCheckBox1.setBackground(imager.getWheel().colors[colorIndexLeft]);
        else jCheckBox1.setBackground(Color.white);

        int colorIndexRight = imager.getRightColor();
        if (colorIndexRight>=0)
            jCheckBox2.setBackground(imager.getWheel().colors[colorIndexRight]);
        else jCheckBox2.setBackground(Color.white);
        
        if (jRadioButton2.isSelected())
        {
            jSlider1.setValue((int)imager.getSpinPerSecond());
        }
        
        double percent = ((double)low)/((double)wlen);
        jTextField51.setText(""+String.format("%.2f", percent));
        
        setTimerValues();
        return true;
    }
    
    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        buttonGroup2 = new javax.swing.ButtonGroup();
        buttonGroup3 = new javax.swing.ButtonGroup();
        jToggleButton1 = new javax.swing.JToggleButton();
        jTabbedPane2 = new javax.swing.JTabbedPane();
        jPanel4 = new javax.swing.JPanel();
        jLabel8 = new javax.swing.JLabel();
        jTextField9 = new javax.swing.JTextField();
        jTextField10 = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();
        jTextField18 = new javax.swing.JTextField();
        jLabel20 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jTextField15 = new javax.swing.JTextField();
        jLabel23 = new javax.swing.JLabel();
        jTextField22 = new javax.swing.JTextField();
        jLabel19 = new javax.swing.JLabel();
        jLabel24 = new javax.swing.JLabel();
        jTextField23 = new javax.swing.JTextField();
        jTextField25 = new javax.swing.JTextField();
        jLabel25 = new javax.swing.JLabel();
        jTextField27 = new javax.swing.JTextField();
        jLabel26 = new javax.swing.JLabel();
        jTextField28 = new javax.swing.JTextField();
        jLabel27 = new javax.swing.JLabel();
        jLabel28 = new javax.swing.JLabel();
        jTextField29 = new javax.swing.JTextField();
        jTextField30 = new javax.swing.JTextField();
        jLabel29 = new javax.swing.JLabel();
        jTextField31 = new javax.swing.JTextField();
        jLabel30 = new javax.swing.JLabel();
        jTextField32 = new javax.swing.JTextField();
        jTextField33 = new javax.swing.JTextField();
        jLabel31 = new javax.swing.JLabel();
        jLabel32 = new javax.swing.JLabel();
        jTextField34 = new javax.swing.JTextField();
        jLabel33 = new javax.swing.JLabel();
        jTextField35 = new javax.swing.JTextField();
        jLabel34 = new javax.swing.JLabel();
        jTextField36 = new javax.swing.JTextField();
        jLabel11 = new javax.swing.JLabel();
        jTextField37 = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jTextField19 = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        jTextField20 = new javax.swing.JTextField();
        jLabel21 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jTextField16 = new javax.swing.JTextField();
        jLabel35 = new javax.swing.JLabel();
        jTextField24 = new javax.swing.JTextField();
        jLabel22 = new javax.swing.JLabel();
        jLabel36 = new javax.swing.JLabel();
        jTextField26 = new javax.swing.JTextField();
        jTextField38 = new javax.swing.JTextField();
        jLabel13 = new javax.swing.JLabel();
        jTextField49 = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        jTextField21 = new javax.swing.JTextField();
        jPanel3 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        imagerWheel1 = new de.malban.vide.vecx.devices.ImagerWheel();
        jCheckBox1 = new javax.swing.JCheckBox();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jSlider1 = new javax.swing.JSlider();
        jLabel15 = new javax.swing.JLabel();
        jTextField11 = new javax.swing.JTextField();
        jLabel18 = new javax.swing.JLabel();
        jLabel37 = new javax.swing.JLabel();
        jLabel38 = new javax.swing.JLabel();
        jTextField12 = new javax.swing.JTextField();
        jTextField13 = new javax.swing.JTextField();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jCheckBox3 = new javax.swing.JCheckBox();
        jLabel39 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jLabel41 = new javax.swing.JLabel();
        jTextField14 = new javax.swing.JTextField();
        jTextField17 = new javax.swing.JTextField();
        jTextField39 = new javax.swing.JTextField();
        jTextField40 = new javax.swing.JTextField();
        jTextField41 = new javax.swing.JTextField();
        jLabel42 = new javax.swing.JLabel();
        jLabel43 = new javax.swing.JLabel();
        jTextField42 = new javax.swing.JTextField();
        jLabel44 = new javax.swing.JLabel();
        jTextField43 = new javax.swing.JTextField();
        jTextField44 = new javax.swing.JTextField();
        jLabel45 = new javax.swing.JLabel();
        jLabel46 = new javax.swing.JLabel();
        jLabel47 = new javax.swing.JLabel();
        jLabel48 = new javax.swing.JLabel();
        jLabel49 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jPanel6 = new javax.swing.JPanel();
        jLabel50 = new javax.swing.JLabel();
        jTextField45 = new javax.swing.JTextField();
        jSlider2 = new javax.swing.JSlider();
        jSlider3 = new javax.swing.JSlider();
        jTextField46 = new javax.swing.JTextField();
        jLabel51 = new javax.swing.JLabel();
        jSlider4 = new javax.swing.JSlider();
        jTextField47 = new javax.swing.JTextField();
        jLabel52 = new javax.swing.JLabel();
        jLabel53 = new javax.swing.JLabel();
        jTextField48 = new javax.swing.JTextField();
        jSlider5 = new javax.swing.JSlider();
        jLabel54 = new javax.swing.JLabel();
        jTextField50 = new javax.swing.JTextField();
        jSlider6 = new javax.swing.JSlider();
        jLabel56 = new javax.swing.JLabel();
        jLabel57 = new javax.swing.JLabel();
        jLabel58 = new javax.swing.JLabel();
        jLabel59 = new javax.swing.JLabel();
        jLabel60 = new javax.swing.JLabel();
        jLabel61 = new javax.swing.JLabel();
        jLabel62 = new javax.swing.JLabel();
        jLabel63 = new javax.swing.JLabel();
        jTextField51 = new javax.swing.JTextField();
        jLabel55 = new javax.swing.JLabel();
        jComboBoxWheelList = new javax.swing.JComboBox();
        jButtonWRTracker = new javax.swing.JButton();
        jComboBox1 = new javax.swing.JComboBox();
        jLabel4 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jTextField4 = new javax.swing.JTextField();
        jLabel1 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jTextField7 = new javax.swing.JTextField();
        jTextField8 = new javax.swing.JTextField();
        jTextField6 = new javax.swing.JTextField();
        jTextField5 = new javax.swing.JTextField();

        setName("regi"); // NOI18N

        jToggleButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton1.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton1.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton1ActionPerformed(evt);
            }
        });

        jLabel8.setText("X Pos");

        jLabel9.setText("Y Pos");

        jLabel10.setForeground(new java.awt.Color(102, 102, 102));
        jLabel10.setText("in vectrex coordinates");

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel8)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel10))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel9)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(381, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel8)
                    .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel10))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(510, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("Lightpen", jPanel4);

        jTextField18.setToolTipText("in from vectrex");

        jLabel20.setText("current bit");

        jLabel16.setText("low level state");

        jLabel23.setText("sync cycles");

        jLabel19.setText("bit counter");

        jLabel24.setText("command");

        jTextField25.setToolTipText("in from vectrex");

        jLabel25.setText("next fast");

        jTextField27.setToolTipText("in from vectrex");

        jLabel26.setText("next slow");

        jTextField28.setToolTipText("in from vectrex");

        jLabel27.setText("volume");

        jLabel28.setText("tempo");

        jTextField29.setToolTipText("in from vectrex");

        jTextField30.setToolTipText("in from vectrex");

        jLabel29.setText("pitch");

        jTextField31.setToolTipText("in from vectrex");

        jLabel30.setText("next stress");

        jTextField32.setToolTipText("in from vectrex");

        jTextField33.setToolTipText("in from vectrex");

        jLabel31.setText("next relax");

        jLabel32.setText("bend");

        jTextField34.setToolTipText("in from vectrex");

        jLabel33.setText("repeat");

        jTextField35.setToolTipText("in from vectrex");

        jLabel34.setText("delay");

        jTextField36.setToolTipText("in from vectrex");

        jLabel11.setText("queue length");

        jTextField37.setToolTipText("in from vectrex");

        jLabel12.setText("input line");

        jTextField19.setToolTipText("in from vectrex");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel29)
                    .addComponent(jLabel33)
                    .addComponent(jLabel34)
                    .addComponent(jLabel27)
                    .addComponent(jLabel28)
                    .addComponent(jLabel32)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jLabel24, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField15, javax.swing.GroupLayout.PREFERRED_SIZE, 220, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField19, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField23, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField29, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField34, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField35, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField36, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel23)
                    .addComponent(jLabel19, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel20)
                    .addComponent(jLabel11)
                    .addComponent(jLabel31)
                    .addComponent(jLabel25)
                    .addComponent(jLabel30)
                    .addComponent(jLabel26))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField22, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField18, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField25)
                    .addComponent(jTextField37, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField27, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField28, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField32, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField33, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(149, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel16)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel23)
                                .addComponent(jTextField22, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField18, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel19)
                            .addComponent(jLabel12)
                            .addComponent(jTextField19, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField25, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel20))
                        .addGap(13, 13, 13))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                        .addComponent(jTextField15, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(68, 68, 68)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField23, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel24)
                            .addComponent(jLabel11)
                            .addComponent(jTextField37, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel25)
                                    .addComponent(jTextField27, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel26)
                                    .addComponent(jTextField28, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel27)
                                    .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel28)
                                    .addComponent(jTextField29, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel29)
                        .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel30)
                            .addComponent(jTextField32, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel31)
                            .addComponent(jTextField33, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel32)
                            .addComponent(jTextField34, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel33)
                    .addComponent(jTextField35, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel34)
                    .addComponent(jTextField36, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(286, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("VecVox", jPanel1);

        jTextField20.setToolTipText("in from vectrex");

        jLabel21.setText("current bit");

        jLabel17.setText("low level state");

        jLabel35.setText("sync cycles");

        jLabel22.setText("bit counter");

        jLabel36.setText("command");

        jTextField38.setToolTipText("in from vectrex");

        jLabel13.setText("queue length");

        jTextField49.setToolTipText("in from vectrex");

        jLabel14.setText("input line");

        jTextField21.setToolTipText("in from vectrex");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel17)
                    .addComponent(jLabel14)
                    .addComponent(jLabel36))
                .addGap(6, 6, 6)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField16, javax.swing.GroupLayout.PREFERRED_SIZE, 220, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField21, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField26, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel35)
                            .addComponent(jLabel22, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel21))
                        .addGap(15, 15, 15))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel13)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField38)
                    .addComponent(jTextField20, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField24, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField49, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(149, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel17)
                            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel35)
                                .addComponent(jTextField24, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField20, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel22)
                            .addComponent(jLabel14)
                            .addComponent(jTextField21, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField38, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel21)))
                    .addComponent(jTextField16, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextField26, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel36))
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel13)
                        .addComponent(jTextField49, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(456, Short.MAX_VALUE))
        );

        jTabbedPane2.addTab("VecVoice", jPanel2);

        jPanel5.setPreferredSize(new java.awt.Dimension(600, 536));

        imagerWheel1.setBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED));

        jCheckBox1.setText("left");
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        jCheckBox2.setText("right");
        jCheckBox2.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox2ActionPerformed(evt);
            }
        });

        jCheckBox4.setText("b/w");
        jCheckBox4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox4ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout imagerWheel1Layout = new javax.swing.GroupLayout(imagerWheel1);
        imagerWheel1.setLayout(imagerWheel1Layout);
        imagerWheel1Layout.setHorizontalGroup(
            imagerWheel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(imagerWheel1Layout.createSequentialGroup()
                .addComponent(jCheckBox1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 164, Short.MAX_VALUE)
                .addComponent(jCheckBox2))
            .addGroup(imagerWheel1Layout.createSequentialGroup()
                .addComponent(jCheckBox4)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        imagerWheel1Layout.setVerticalGroup(
            imagerWheel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(imagerWheel1Layout.createSequentialGroup()
                .addGroup(imagerWheel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox1)
                    .addComponent(jCheckBox2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jCheckBox4)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jSlider1.setMajorTickSpacing(10);
        jSlider1.setMaximum(30);
        jSlider1.setMinorTickSpacing(1);
        jSlider1.setPaintLabels(true);
        jSlider1.setPaintTicks(true);
        jSlider1.setSnapToTicks(true);
        jSlider1.setValue(0);
        jSlider1.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSlider1StateChanged(evt);
            }
        });

        jLabel15.setText("spin per second");

        jTextField11.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField11FocusLost(evt);
            }
        });
        jTextField11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField11ActionPerformed(evt);
            }
        });

        jLabel18.setText("vectrex pulse");

        jLabel37.setText("low");

        jLabel38.setText("len");

        buttonGroup3.add(jRadioButton1);
        jRadioButton1.setSelected(true);
        jRadioButton1.setText("manual");
        jRadioButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton1ActionPerformed(evt);
            }
        });

        buttonGroup3.add(jRadioButton2);
        jRadioButton2.setText("auto");
        jRadioButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton2ActionPerformed(evt);
            }
        });

        jCheckBox3.setText("available");

        jLabel39.setText("current Angle");

        jLabel40.setText("cycles per Spin");

        jLabel41.setText("angle per cycle");

        jLabel42.setText("cycles");

        jLabel43.setText("s");

        jLabel44.setText("index pulse");

        jTextField44.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextField44FocusLost(evt);
            }
        });
        jTextField44.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField44ActionPerformed(evt);
            }
        });

        jLabel45.setText("s");

        jLabel46.setText("cycles");

        jLabel47.setText("cycles");

        jLabel48.setText("s");

        jLabel49.setForeground(new java.awt.Color(102, 102, 102));
        jLabel49.setText("looking through the imager");

        jButton1.setText("default");
        jButton1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jLabel50.setText("sync led");

        jSlider2.setMajorTickSpacing(10);
        jSlider2.setMaximum(360);
        jSlider2.setMinorTickSpacing(1);
        jSlider2.setOrientation(javax.swing.JSlider.VERTICAL);
        jSlider2.setPaintTicks(true);
        jSlider2.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSlider2StateChanged(evt);
            }
        });

        jSlider3.setMajorTickSpacing(10);
        jSlider3.setMaximum(360);
        jSlider3.setMinorTickSpacing(1);
        jSlider3.setOrientation(javax.swing.JSlider.VERTICAL);
        jSlider3.setPaintTicks(true);
        jSlider3.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSlider3StateChanged(evt);
            }
        });

        jLabel51.setText("sync hole");

        jSlider4.setMajorTickSpacing(10);
        jSlider4.setMaximum(360);
        jSlider4.setMinimum(180);
        jSlider4.setMinorTickSpacing(1);
        jSlider4.setOrientation(javax.swing.JSlider.VERTICAL);
        jSlider4.setPaintTicks(true);
        jSlider4.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSlider4StateChanged(evt);
            }
        });

        jLabel52.setText("angle 1");

        jLabel53.setText("angle 2");

        jSlider5.setMajorTickSpacing(10);
        jSlider5.setMaximum(360);
        jSlider5.setMinimum(180);
        jSlider5.setMinorTickSpacing(1);
        jSlider5.setOrientation(javax.swing.JSlider.VERTICAL);
        jSlider5.setPaintTicks(true);
        jSlider5.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSlider5StateChanged(evt);
            }
        });

        jLabel54.setText("angle 3");

        jSlider6.setMajorTickSpacing(10);
        jSlider6.setMaximum(360);
        jSlider6.setMinimum(180);
        jSlider6.setMinorTickSpacing(1);
        jSlider6.setOrientation(javax.swing.JSlider.VERTICAL);
        jSlider6.setPaintTicks(true);
        jSlider6.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                jSlider6StateChanged(evt);
            }
        });

        jLabel56.setText("0x0000");
        jLabel56.setToolTipText("start at cycles [relation to index whole]");

        jLabel57.setText("right");
        jLabel57.setToolTipText("start at cycles [relation to index whole]");

        jLabel58.setText("left");
        jLabel58.setToolTipText("start at cycles [relation to index whole]");

        jLabel59.setText("0x0000");
        jLabel59.setToolTipText("start at cycles [relation to index whole]");

        jLabel60.setText("0x0000");
        jLabel60.setToolTipText("start at cycles [relation to index whole]");

        jLabel61.setText("0x0000");
        jLabel61.setToolTipText("start at cycles [relation to index whole]");

        jLabel62.setText("0x0000");
        jLabel62.setToolTipText("start at cycles [relation to index whole]");

        jLabel63.setText("0x0000");
        jLabel63.setToolTipText("start at cycles [relation to index whole]");

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel50)
                            .addComponent(jSlider2, javax.swing.GroupLayout.DEFAULT_SIZE, 45, Short.MAX_VALUE)
                            .addComponent(jTextField45))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel51)
                            .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jSlider3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jTextField46, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 45, Short.MAX_VALUE)))
                        .addGap(27, 27, 27))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel57)
                            .addComponent(jLabel58))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)))
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel52)
                            .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jSlider4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jTextField47, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel53)
                            .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel61)
                                    .addComponent(jLabel60))
                                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addComponent(jSlider5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(jTextField48, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addComponent(jLabel56)
                    .addComponent(jLabel59))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel63)
                    .addComponent(jLabel62)
                    .addComponent(jLabel54)
                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jSlider6, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jTextField50, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 45, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel54)
                        .addGap(4, 4, 4)
                        .addComponent(jTextField50, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jSlider6, javax.swing.GroupLayout.PREFERRED_SIZE, 138, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel53)
                        .addGap(4, 4, 4)
                        .addComponent(jTextField48, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jSlider5, javax.swing.GroupLayout.PREFERRED_SIZE, 138, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel6Layout.createSequentialGroup()
                            .addComponent(jLabel50)
                            .addGap(4, 4, 4)
                            .addComponent(jTextField45, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jSlider2, javax.swing.GroupLayout.PREFERRED_SIZE, 138, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel6Layout.createSequentialGroup()
                            .addComponent(jLabel51)
                            .addGap(4, 4, 4)
                            .addComponent(jTextField46, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jSlider3, javax.swing.GroupLayout.PREFERRED_SIZE, 138, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel6Layout.createSequentialGroup()
                            .addComponent(jLabel52)
                            .addGap(4, 4, 4)
                            .addComponent(jTextField47, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jSlider4, javax.swing.GroupLayout.PREFERRED_SIZE, 138, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addGroup(jPanel6Layout.createSequentialGroup()
                            .addComponent(jLabel56)
                            .addGap(4, 4, 4)
                            .addComponent(jLabel59))
                        .addGroup(jPanel6Layout.createSequentialGroup()
                            .addComponent(jLabel61)
                            .addGap(4, 4, 4)
                            .addComponent(jLabel60)))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel63)
                        .addGap(4, 4, 4)
                        .addComponent(jLabel62))
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel57)
                        .addGap(4, 4, 4)
                        .addComponent(jLabel58))))
        );

        jLabel55.setText("%");

        jComboBoxWheelList.setPreferredSize(new java.awt.Dimension(120, 20));
        jComboBoxWheelList.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBoxWheelListActionPerformed(evt);
            }
        });

        jButtonWRTracker.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/page_edit.png"))); // NOI18N
        jButtonWRTracker.setToolTipText("show tracker");
        jButtonWRTracker.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonWRTracker.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonWRTrackerActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(imagerWheel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(6, 6, 6)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel15, javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel18, javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel39, javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel40, javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel41, javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel44, javax.swing.GroupLayout.Alignment.LEADING))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextField42)
                            .addComponent(jTextField39)
                            .addComponent(jTextField17)
                            .addComponent(jTextField14)
                            .addComponent(jRadioButton2)
                            .addComponent(jTextField41)
                            .addComponent(jTextField12)
                            .addComponent(jLabel37)
                            .addComponent(jTextField11)
                            .addComponent(jTextField43)
                            .addComponent(jTextField44, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGap(5, 5, 5)
                                .addComponent(jLabel48))
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGap(4, 4, 4)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField40, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                                        .addComponent(jLabel38)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jTextField51, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel43)
                                    .addComponent(jLabel42)
                                    .addComponent(jLabel55)))
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGap(4, 4, 4)
                                .addComponent(jRadioButton1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 109, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGap(5, 5, 5)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel47)
                                    .addComponent(jLabel45)
                                    .addComponent(jLabel46))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jSlider1, javax.swing.GroupLayout.PREFERRED_SIZE, 98, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonWRTracker, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGap(6, 6, 6)
                                .addComponent(jComboBoxWheelList, javax.swing.GroupLayout.PREFERRED_SIZE, 192, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addContainerGap())
                    .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jCheckBox3)
                .addGap(18, 18, 18)
                .addComponent(jLabel49)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jCheckBox3)
                    .addComponent(jLabel49))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(imagerWheel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel39)
                            .addComponent(jTextField14, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jComboBoxWheelList, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(5, 5, 5)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel40)
                                .addComponent(jTextField17, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jButtonWRTracker, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel41)
                            .addComponent(jTextField39, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel37)
                            .addComponent(jLabel38)
                            .addComponent(jTextField51, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel55))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel18)
                            .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel42))
                        .addGap(8, 8, 8)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField41, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField40, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel43))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jRadioButton1)
                            .addComponent(jRadioButton2)
                            .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel15)
                                    .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel46))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField44, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel45))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField42, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel44)
                                    .addComponent(jLabel47)))
                            .addComponent(jSlider1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField43, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel48))
                        .addGap(5, 5, 5)
                        .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
        );

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, 646, Short.MAX_VALUE)
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, 570, Short.MAX_VALUE)
        );

        jTabbedPane2.addTab("Imager3d", jPanel3);

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "0", "1" }));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        jLabel4.setText("Port");

        jLabel3.setText("Button 3");

        jLabel5.setText("Button 4");

        jLabel1.setText("Button 1");

        jLabel2.setText("Button 2");

        jLabel6.setText("Horizontal");

        jLabel7.setText("Vertical");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jLabel4))
                            .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel1)
                            .addComponent(jLabel2))
                        .addGap(18, 18, 18)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextField1, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
                            .addComponent(jTextField2, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
                            .addComponent(jTextField3, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
                            .addComponent(jTextField4, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
                            .addComponent(jComboBox1, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(35, 35, 35)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel6)
                            .addComponent(jLabel7))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jTextField6, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
                            .addComponent(jTextField8, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE))
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jTabbedPane2)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6)
                            .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(27, 27, 27)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel1)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel3)
                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel5)
                            .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane2))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jToggleButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton1ActionPerformed
        updateEnabled = jToggleButton1.isSelected();
    }//GEN-LAST:event_jToggleButton1ActionPerformed

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed
        update();
    }//GEN-LAST:event_jComboBox1ActionPerformed

    private void jSlider1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSlider1StateChanged
        if (jRadioButton1.isSelected())
        {
            jTextField11.setText(""+String.format("%.4f", (double)jSlider1.getValue()));
            jTextField11ActionPerformed(null);
        }
    }//GEN-LAST:event_jSlider1StateChanged

    private void jRadioButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton1ActionPerformed
        jSlider1.setEnabled(jRadioButton1.isSelected());
        if (jRadioButton1.isSelected())
        {
            int port = jComboBox1.getSelectedIndex();
            if ((port <0) || (port >1)) return;
            VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
            if (portDevices == null) return;
            VectrexJoyport portDevice = portDevices[port];
            if (portDevice == null) return;
            JoyportDevice device = portDevice.getDevice();
            if (device == null) return;
            if (!(device instanceof Imager3dDevice)) return;
            Imager3dDevice imager = (Imager3dDevice)device;
            imager.setAuto(false);
        }
    }//GEN-LAST:event_jRadioButton1ActionPerformed

    private void jRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton2ActionPerformed
        jSlider1.setEnabled(jRadioButton1.isSelected());
        if (jRadioButton2.isSelected())
        {
            int port = jComboBox1.getSelectedIndex();
            if ((port <0) || (port >1)) return;
            VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
            if (portDevices == null) return;
            VectrexJoyport portDevice = portDevices[port];
            if (portDevice == null) return;
            JoyportDevice device = portDevice.getDevice();
            if (device == null) return;
            if (!(device instanceof Imager3dDevice)) return;
            Imager3dDevice imager = (Imager3dDevice)device;
            imager.setAuto(true);
        }
            
    }//GEN-LAST:event_jRadioButton2ActionPerformed

    private void jTextField11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField11ActionPerformed
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        imager.forceSpinPerSecond(de.malban.util.UtilityString.DoubleX(jTextField11.getText(), 0));
    }//GEN-LAST:event_jTextField11ActionPerformed

    private void jTextField11FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField11FocusLost
        jTextField11ActionPerformed(null);
    }//GEN-LAST:event_jTextField11FocusLost

    private void jTextField44FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextField44FocusLost
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField44FocusLost

    private void jTextField44ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField44ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField44ActionPerformed

    private void jSlider2StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSlider2StateChanged
        jTextField45.setText(""+jSlider2.getValue());
        Imager3dDevice.photoReceiverAngleStart = jSlider2.getValue();
        imagerWheel1.repaintWheel();
    }//GEN-LAST:event_jSlider2StateChanged

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        double v = imager.getWheel().defaultFrequency;
        jSlider1.setValue((int) v);
        jTextField11.setText(""+String.format("%.4f", (double)v));
        jRadioButton1.setSelected(true);
        jSlider1.setEnabled(jRadioButton1.isSelected());
        jTextField11ActionPerformed(null);
        imagerWheel1.repaintWheel();
        if (jRadioButton1.isSelected())
        {
            imager.setAuto(false);
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jSlider3StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSlider3StateChanged
        if (currentWheel==null) return;
        if (mClassSetting == 0)
            currentWheel.indexAngle = jSlider3.getValue();
        jTextField46.setText(""+jSlider3.getValue());
        imagerWheel1.repaintWheel();
    }//GEN-LAST:event_jSlider3StateChanged

    private void jSlider4StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSlider4StateChanged
        if (currentWheel==null) return;
        if (currentWheel.startAngle.length<1) return;
        if (mClassSetting == 0)
            currentWheel.startAngle[1] = jSlider4.getValue();
        jTextField47.setText(""+(int)currentWheel.startAngle[1]);
        imagerWheel1.repaintWheel();
        int t = jSlider5.getValue();
        jSlider5.setMinimum(jSlider4.getValue());
        jSlider5.setValue(t);
    }//GEN-LAST:event_jSlider4StateChanged

    private void jSlider5StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSlider5StateChanged
        if (currentWheel==null) return;
        if (currentWheel.startAngle.length<2) return;
        if (mClassSetting == 0)
            currentWheel.startAngle[2] = jSlider5.getValue();
        jTextField48.setText(""+(int)currentWheel.startAngle[2]);
        imagerWheel1.repaintWheel();
        int t = jSlider6.getValue();
        jSlider6.setMinimum(jSlider5.getValue());
        jSlider6.setValue(t);
    }//GEN-LAST:event_jSlider5StateChanged

    private void jSlider6StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jSlider6StateChanged
        if (currentWheel==null) return;
        if (currentWheel.startAngle.length<3) return;
        if (mClassSetting == 0)
            currentWheel.startAngle[3] = jSlider6.getValue();
        jTextField50.setText(""+(int)currentWheel.startAngle[3]);
        imagerWheel1.repaintWheel();
    }//GEN-LAST:event_jSlider6StateChanged

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        imager.setLeftEnabled(jCheckBox1.isSelected());
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jCheckBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox2ActionPerformed
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        imager.setRightEnabled(jCheckBox2.isSelected());
    }//GEN-LAST:event_jCheckBox2ActionPerformed

    private void jCheckBox4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox4ActionPerformed
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        imager.setBwEnabled(jCheckBox4.isSelected());
    }//GEN-LAST:event_jCheckBox4ActionPerformed

    private void jButtonWRTrackerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonWRTrackerActionPerformed
        WheelEdit.showWheelEdit();
        correctWheelAfterEditor();
    }//GEN-LAST:event_jButtonWRTrackerActionPerformed

    private void jComboBoxWheelListActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBoxWheelListActionPerformed
        if (mClassSetting>0) return;
        loadSelectedWheel();
    }//GEN-LAST:event_jComboBoxWheelListActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.ButtonGroup buttonGroup3;
    private de.malban.vide.vecx.devices.ImagerWheel imagerWheel1;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButtonWRTracker;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBoxWheelList;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel21;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel23;
    private javax.swing.JLabel jLabel24;
    private javax.swing.JLabel jLabel25;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel27;
    private javax.swing.JLabel jLabel28;
    private javax.swing.JLabel jLabel29;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel30;
    private javax.swing.JLabel jLabel31;
    private javax.swing.JLabel jLabel32;
    private javax.swing.JLabel jLabel33;
    private javax.swing.JLabel jLabel34;
    private javax.swing.JLabel jLabel35;
    private javax.swing.JLabel jLabel36;
    private javax.swing.JLabel jLabel37;
    private javax.swing.JLabel jLabel38;
    private javax.swing.JLabel jLabel39;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel40;
    private javax.swing.JLabel jLabel41;
    private javax.swing.JLabel jLabel42;
    private javax.swing.JLabel jLabel43;
    private javax.swing.JLabel jLabel44;
    private javax.swing.JLabel jLabel45;
    private javax.swing.JLabel jLabel46;
    private javax.swing.JLabel jLabel47;
    private javax.swing.JLabel jLabel48;
    private javax.swing.JLabel jLabel49;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel50;
    private javax.swing.JLabel jLabel51;
    private javax.swing.JLabel jLabel52;
    private javax.swing.JLabel jLabel53;
    private javax.swing.JLabel jLabel54;
    private javax.swing.JLabel jLabel55;
    private javax.swing.JLabel jLabel56;
    private javax.swing.JLabel jLabel57;
    private javax.swing.JLabel jLabel58;
    private javax.swing.JLabel jLabel59;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel60;
    private javax.swing.JLabel jLabel61;
    private javax.swing.JLabel jLabel62;
    private javax.swing.JLabel jLabel63;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JSlider jSlider1;
    private javax.swing.JSlider jSlider2;
    private javax.swing.JSlider jSlider3;
    private javax.swing.JSlider jSlider4;
    private javax.swing.JSlider jSlider5;
    private javax.swing.JSlider jSlider6;
    private javax.swing.JTabbedPane jTabbedPane2;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField10;
    private javax.swing.JTextField jTextField11;
    private javax.swing.JTextField jTextField12;
    private javax.swing.JTextField jTextField13;
    private javax.swing.JTextField jTextField14;
    private javax.swing.JTextField jTextField15;
    private javax.swing.JTextField jTextField16;
    private javax.swing.JTextField jTextField17;
    private javax.swing.JTextField jTextField18;
    private javax.swing.JTextField jTextField19;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField20;
    private javax.swing.JTextField jTextField21;
    private javax.swing.JTextField jTextField22;
    private javax.swing.JTextField jTextField23;
    private javax.swing.JTextField jTextField24;
    private javax.swing.JTextField jTextField25;
    private javax.swing.JTextField jTextField26;
    private javax.swing.JTextField jTextField27;
    private javax.swing.JTextField jTextField28;
    private javax.swing.JTextField jTextField29;
    private javax.swing.JTextField jTextField3;
    private javax.swing.JTextField jTextField30;
    private javax.swing.JTextField jTextField31;
    private javax.swing.JTextField jTextField32;
    private javax.swing.JTextField jTextField33;
    private javax.swing.JTextField jTextField34;
    private javax.swing.JTextField jTextField35;
    private javax.swing.JTextField jTextField36;
    private javax.swing.JTextField jTextField37;
    private javax.swing.JTextField jTextField38;
    private javax.swing.JTextField jTextField39;
    private javax.swing.JTextField jTextField4;
    private javax.swing.JTextField jTextField40;
    private javax.swing.JTextField jTextField41;
    private javax.swing.JTextField jTextField42;
    private javax.swing.JTextField jTextField43;
    private javax.swing.JTextField jTextField44;
    private javax.swing.JTextField jTextField45;
    private javax.swing.JTextField jTextField46;
    private javax.swing.JTextField jTextField47;
    private javax.swing.JTextField jTextField48;
    private javax.swing.JTextField jTextField49;
    private javax.swing.JTextField jTextField5;
    private javax.swing.JTextField jTextField50;
    private javax.swing.JTextField jTextField51;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextField7;
    private javax.swing.JTextField jTextField8;
    private javax.swing.JTextField jTextField9;
    private javax.swing.JToggleButton jToggleButton1;
    // End of variables declaration//GEN-END:variables

    private boolean updateEnabled = false;
    public void updateValues(boolean forceUpdate)
    {
        if (!forceUpdate)
            if (!updateEnabled) return;
        update();
    }
    public void setUpdateEnabled(boolean b)
    {
        updateEnabled = b;
    }
    void initWheel()
    {
        mClassSetting++;
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        imager.setBwEnabled(jCheckBox4.isSelected());

        jRadioButton2.setSelected(imager.isAuto());
        jRadioButton1.setSelected(!imager.isAuto());
        jSlider1.setEnabled(!imager.isAuto());
        imagerWheel1.setWheel(currentWheel);
        
        jSlider2.setValue((int)Imager3dDevice.DEFAULT_TRANSISTOR_ANGLE);
        jTextField45.setText(""+(int)Imager3dDevice.DEFAULT_TRANSISTOR_ANGLE);

        jSlider3.setValue((int)currentWheel.indexAngle);
        jTextField46.setText(""+(int)currentWheel.indexAngle);

        jSlider4.setValue((int)currentWheel.startAngle[1]);
        jTextField47.setText(""+(int)currentWheel.startAngle[1]);
        
        jSlider5.setValue((int)currentWheel.startAngle[2]);
        jTextField48.setText(""+(int)currentWheel.startAngle[2]);
       
        jSlider6.setValue((int)currentWheel.startAngle[3]);
        jTextField50.setText(""+(int)currentWheel.startAngle[3]);
        
        jCheckBox1.setSelected(imager.isLeftEnabled());
        jCheckBox2.setSelected(imager.isRightEnabled());
        jCheckBox4.setSelected(imager.isBwEnabled());
        
        if (!jRadioButton2.isSelected())
        {
            jButton1ActionPerformed(null);
        }
        mClassSetting--;
        repaint();
    }
    void initWheelList()
    {
        mClassSetting++;
        String path = "xml"+File.separator+"wheels";
        ArrayList<String> files = de.malban.util.UtilityFiles.getXMLFileList(path);
        jComboBoxWheelList.removeAllItems();
        for (String name: files)
        {
            jComboBoxWheelList.addItem(de.malban.util.UtilityString.replace(name.toLowerCase(), ".xml", ""));
        }
        mClassSetting--;
    }
    void loadSelectedWheel()
    {
        int i = jComboBoxWheelList.getSelectedIndex();
        if (i<0) 
        {
            log.addLog("No entry selected - can't load.", WARN);
            return;
        }
        String fname = jComboBoxWheelList.getSelectedItem().toString()+".xml";
        String path = "xml"+File.separator+"wheels"+File.separator+fname;
        WheelData loadedWheel = WheelData.loadWheel(path);
        if (loadedWheel==null) 
        {
            log.addLog("Wheel not loaded.", WARN);
            return;
        }
        currentWheel = loadedWheel;

        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        
        imager.setWheel(currentWheel);
        initWheel();
        log.addLog("Wheel "+currentWheel.name+" loaded.", INFO);
    }

    void correctWheelAfterEditor()
    {
        if (currentWheel==null) return;
        String currentName = de.malban.util.UtilityString.replace(currentWheel.name.toLowerCase(), ".xml", "");
        mClassSetting++;
        initWheelList();
        int index = -1;
        for (int i=0; i<jComboBoxWheelList.getItemCount(); i++)
        {
            if (currentName.equals(jComboBoxWheelList.getItemAt(i).toString()))
            {
                index = i;
                break;
            }
        }
        if (index >=0)
        {
            jComboBoxWheelList.setSelectedIndex(index);
        }
        
        initWheel();
        
        mClassSetting--;
    }
    void setCurrentWheelAsSelection()
    {
        if (currentWheel==null) return;
        String currentName = de.malban.util.UtilityString.replace(currentWheel.name.toLowerCase(), ".xml", "");
        mClassSetting++;
        int index = -1;
        for (int i=0; i<jComboBoxWheelList.getItemCount(); i++)
        {
            if (currentName.equals(jComboBoxWheelList.getItemAt(i).toString()))
            {
                index = i;
                break;
            }
        }
        if (index >=0)
        {
            jComboBoxWheelList.setSelectedIndex(index);
        }
        initWheel();
        mClassSetting--;
    }
    
    
    
    void setTimerValues()
    {
        int port = jComboBox1.getSelectedIndex();
        if ((port <0) || (port >1)) return;
        VectrexJoyport[] portDevices =  vecxPanel.getJoyportDevices();
        if (portDevices == null) return;
        VectrexJoyport portDevice = portDevices[port];
        if (portDevice == null) return;
        JoyportDevice device = portDevice.getDevice();
        if (device == null) return;
        if (!(device instanceof Imager3dDevice)) return;
        Imager3dDevice imager = (Imager3dDevice)device;
        
        
        double frequency =  imager.getSpinPerSecond();
        double angleRight1 = 0;
        double angleRight2 = 0;
        double angleRight3 = 0;
        double angleLeft1 = 0;
        double angleLeft2 = 0;
        double angleLeft3 = 0;
        
        
        if (currentWheel.startAngle.length>=1)
        {
            angleRight1 = currentWheel.startAngle[1]+90; // after black complete +90 degrees for right eye
            angleLeft1 = currentWheel.startAngle[1] + 90+180; // left is 180 degrees from right
        }
        if (currentWheel.startAngle.length>=2)
        {
            angleRight2 = currentWheel.startAngle[2]+90; // after black complete +90 degrees for right eye
            angleLeft2 = currentWheel.startAngle[2] + 90+180; // left is 180 degrees from right
        }
        if (currentWheel.startAngle.length>=3)
        {
            angleRight3 = currentWheel.startAngle[3]+90; // after black complete +90 degrees for right eye
            angleLeft3 = currentWheel.startAngle[3] + 90+180; // left is 180 degrees from right
        }
        
        setCycle(angleRight1, jLabel56, imager, currentWheel);
        setCycle(angleRight2, jLabel61, imager, currentWheel);
        setCycle(angleRight3, jLabel63, imager, currentWheel);
        setCycle(angleLeft1, jLabel59, imager, currentWheel);
        setCycle(angleLeft2, jLabel60, imager, currentWheel);
        setCycle(angleLeft3, jLabel62, imager, currentWheel);
    }
    public static void setCycle(double angle, JLabel label, Imager3dDevice imager, WheelData wheel)
    {
        
        double angleOffset = ((Imager3dDevice.indexAngleWidth+Imager3dDevice.photoReceiverAngleStart+(360-wheel.indexAngle))%360);
        angle += angleOffset;
        
        angle = angle %360;
        double anglePerCycle = imager.getAnglePerCycle();

        double cycles = angle / anglePerCycle;
        label.setText("0x"+String.format("%04X", ((int)cycles)));
    }
}
