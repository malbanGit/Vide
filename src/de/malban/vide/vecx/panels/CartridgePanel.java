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
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.vecx.Updatable;
import de.malban.vide.vecx.cartridge.Cartridge;
import de.malban.vide.vecx.cartridge.DS2430A;
import de.malban.vide.vecx.cartridge.DS2431;
import de.malban.vide.vecx.cartridge.Microchip11AA010;
import de.muntjak.tinylookandfeel.Theme;
import java.awt.Color;
import java.beans.PropertyChangeEvent;
import java.beans.PropertyChangeListener;
import java.io.Serializable;
import javax.swing.JTextField;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author malban
 */
public class CartridgePanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    public boolean isLoadSettings() { return true; }

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    private DissiPanel dissi = null;
    public static String SID = "cartridges";
    boolean nameChanged = false;
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
        if (vecxPanel != null) vecxPanel.resetCartridge();
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
        mParentMenuItem.setText("Cartridge");
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
        removeUIListerner();
    }
    /**
     * Creates new form RegisterJPanel
     */
    public CartridgePanel() {
        initComponents();
        
        MemoryDumpTableModelMC modelMC = new MemoryDumpTableModelMC();
        MemoryDumpTableModelDS modelDS = new MemoryDumpTableModelDS();
        MemoryDumpTableModelDS1 modelDS1 = new MemoryDumpTableModelDS1();
        MemoryDumpTableModelRAM modelRAM = new MemoryDumpTableModelRAM();
        jTable1.setModel(modelMC);
        jTable2.setModel(modelDS);
        jTable3.setModel(modelRAM);
        jTable4.setModel(modelDS1);
        jPanel4.setVisible(false);
        
        UIManager.addPropertyChangeListener(pListener);
        updateMyUI(); 
       
        
        correctTableMC();
        correctTableDS();
        correctTableDS1();
        correctTableRAM();
    }
    public void correctTableMC()
    {
        jTable1.tableChanged(null);
        
        MemoryDumpTableModelMC model = (MemoryDumpTableModelMC)jTable1.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable1.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }
    public void correctTableDS()
    {
        jTable2.tableChanged(null);
        
        MemoryDumpTableModelDS model = (MemoryDumpTableModelDS)jTable2.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable2.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }    
    public void correctTableDS1()
    {
        jTable4.tableChanged(null);
        
        MemoryDumpTableModelDS1 model = (MemoryDumpTableModelDS1)jTable4.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable4.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }
    public void correctTableRAM()
    {
        jTable3.tableChanged(null);
        
        MemoryDumpTableModelRAM model = (MemoryDumpTableModelRAM)jTable3.getModel();
        
        for (int i=0; i< model.getColumnCount(); i++)
        {
            jTable3.getColumnModel().getColumn(i).setPreferredWidth(model.getColWidth(i));                
        }
    }

    
    private void update()
    {        
        if (vecxPanel==null) return;
        updateMicrochip();
        updateDS2430A();
        updateDS2431();
        updateRamExtension();
//        updateBankswitch();

    }
    DS2431 oldDS1 = null;
    DS2431 currentDS1 = null;
    DS2430A oldDS = null;
    DS2430A currentDS = null;
    Cartridge currentCart = null;
    Cartridge oldCart = null;
    
    private void updateRamExtension()
    {        
        if (vecxPanel==null) return;
        currentCart = vecxPanel.getCartridge();
        if (currentCart == null) return;
        if ((!currentCart.isExtra2000Ram2k()) && (!currentCart.isExtra8000Ram2k())&& (!currentCart.isExtra6000Ram8k())) return;
        jTable3.tableChanged(null);
        jPanel4.setVisible(currentCart.isExtra8000Ram2k());
        if (currentCart.isExtra8000Ram2k())
        {
            byte sb = currentCart.getSpectrumByte();
            jRadioButtonJ01.setSelected((sb&0x01)==0x01);
            jRadioButtonJ02.setSelected((sb&0x02)==0x02);
            jRadioButtonJ03.setSelected((sb&0x04)==0x04);
            jRadioButtonJ04.setSelected((sb&0x08)==0x08);
            jRadioButtonJ11.setSelected((sb&0x10)==0x10);
            jRadioButtonJ12.setSelected((sb&0x20)==0x20);
            jRadioButtonJ13.setSelected((sb&0x40)==0x40);
            jRadioButtonJ14.setSelected((sb&0x80)==0x80);
            jLabel26.setText(""+DASM6809.printbinary(sb));
        }
        correctTableRAM();
    }    
    long oldRegSum=0;
    private void updateDS2430A()
    {        
        if (vecxPanel==null) return;

        currentDS = vecxPanel.getDS2430A();
        if (currentDS == null) return;

        
        if (oldRegSum != currentDS.getRegSum())
        {
            oldRegSum=currentDS.getRegSum();

            jTextFieldReg0.setText("$"+String.format("%02X",(currentDS.epromData.reg[0])));
            jTextFieldReg1.setText("$"+String.format("%02X",(currentDS.epromData.reg[1])));
            jTextFieldReg2.setText("$"+String.format("%02X",(currentDS.epromData.reg[2])));
            jTextFieldReg3.setText("$"+String.format("%02X",(currentDS.epromData.reg[3])));
            jTextFieldReg4.setText("$"+String.format("%02X",(currentDS.epromData.reg[4])));
            jTextFieldReg5.setText("$"+String.format("%02X",(currentDS.epromData.reg[5])));
            jTextFieldReg6.setText("$"+String.format("%02X",(currentDS.epromData.reg[6])));
            jTextFieldReg7.setText("$"+String.format("%02X",(currentDS.epromData.reg[7])));
        }
        
        
        jTextFieldRegPointer.setText("$" + String.format("%02X",(currentDS.getRegPointer())));
        jTextFieldOutVal.setText("$" + String.format("%02X",(currentDS.getCurrentOutValue())));
        
        
        
        jTextField15.setText(""+currentDS.getLowLevelName());
        jTextField16.setText(""+currentDS.getHighLevelName());
        jTextField23.setText(""+currentDS.get1WCommandName());
        jTextField17.setText(""+currentDS.get2430CommandName());

        
        jTextField22.setText(""+currentDS.getSyncCycles());
        if (currentDS.isInputToDS())
            jRadioButton3.setSelected(true);
        else
            jRadioButton4.setSelected(true);
        jTextField20.setText(""+currentDS.getLineIn());
        jTextField21.setText(""+currentDS.getLineOut());
        
        jTextField18.setText(""+currentDS.getBitCounterFromVectrex());
        jTextField24.setText(""+currentDS.getBitCounterFromDS());
        
        jTextField25.setText(""+currentDS.getBitFromVectrex());
        jTextField26.setText(""+currentDS.getBitFromDS());

        jTable2.tableChanged(null);
        correctTableDS();
        oldDS = currentDS.clone();
    }    
    long oldSerial = 0;
    private void updateDS2431()
    {        
        if (vecxPanel==null) return;

        currentDS1 = vecxPanel.getDS2431();
        if (currentDS1 == null) return;

        if (oldSerial != currentDS1.getSerial())
        {
            oldSerial=currentDS1.getSerial();

            jTextFieldS1.setText("$"+String.format("%02X",(currentDS1.SERIAL_NUMBER[0])));
            jTextFieldS2.setText("$"+String.format("%02X",(currentDS1.SERIAL_NUMBER[1])));
            jTextFieldS3.setText("$"+String.format("%02X",(currentDS1.SERIAL_NUMBER[2])));
            jTextFieldS4.setText("$"+String.format("%02X",(currentDS1.SERIAL_NUMBER[3])));
            jTextFieldS5.setText("$"+String.format("%02X",(currentDS1.SERIAL_NUMBER[4])));
            jTextFieldS6.setText("$"+String.format("%02X",(currentDS1.SERIAL_NUMBER[5])));
        }
        
        jTextFieldOutVal1.setText("$" + String.format("%02X",(currentDS1.getCurrentOutValue())));
        jTextFieldTA1.setText("$" + String.format("%02X",(currentDS1.getTA1())));
        jTextFieldTA2.setText("$" + String.format("%02X",(currentDS1.getTA2())));
        jTextFieldES.setText("$" + String.format("%02X",(currentDS1.getES())));

        
        
        jTextField27.setText(""+currentDS1.getLowLevelName());
        jTextField28.setText(""+currentDS1.getHighLevelName());
        jTextField34.setText(""+currentDS1.get1WCommandName());
        jTextField29.setText(""+currentDS1.get2431CommandName());

        
        jTextField33.setText(""+currentDS1.getSyncCycles());
        if (currentDS1.isInputToDS())
            jRadioButton5.setSelected(true);
        else
            jRadioButton6.setSelected(true);
        jTextField31.setText(""+currentDS1.getLineIn());
        jTextField32.setText(""+currentDS1.getLineOut());
        
        jTextField30.setText(""+currentDS1.getBitCounterFromVectrex());
        jTextField35.setText(""+currentDS1.getBitCounterFromDS());
        
        jTextField36.setText(""+currentDS1.getBitFromVectrex());
        jTextField37.setText(""+currentDS1.getBitFromDS());

        jTable4.tableChanged(null);
        correctTableDS1();
        oldDS1 = currentDS1.clone();
    }    
    Microchip11AA010 oldMC = null;
    Microchip11AA010 currentMC = null;
    private void updateMicrochip()
    {        
        if (vecxPanel==null) return;

        currentMC = vecxPanel.getMicrochip();
        if (currentMC == null) 
            return;
        
        jTextField1.setText(""+currentMC.getLowLevelName());
        jTextField2.setText(""+currentMC.getMediumLevelName());
        jTextField3.setText(""+currentMC.getHighLevelName());
        jTextField6.setText(""+currentMC.getCommandName());
        jTextField7.setText(""+currentMC.getStatusRegister());
        jTextField8.setText(""+currentMC.getAddressRegister());
        jTextField12.setText(""+currentMC.getManchester0());
        jTextField13.setText(""+currentMC.getManchester1());
        if (currentMC.isInputToMicrochip())
            jRadioButton1.setSelected(true);
        else
            jRadioButton2.setSelected(true);
        
        jTextField5.setText(""+currentMC.getSyncBase());
        jTextField4.setText(""+currentMC.getSyncCounter());
        jTextField10.setText(""+currentMC.getLineIn());
        jTextField14.setText(""+currentMC.getLineOut());
        jTextField9.setText(""+currentMC.getBitCounter());
        jTextField11.setText(""+currentMC.getBit());

        jTextField19.setText(""+currentMC.getWriteTimer());
        oldMC = currentMC.clone();
        jTable1.tableChanged(null);
        correctTableMC();
    }    
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup3 = new javax.swing.ButtonGroup();
        jToggleButton1 = new javax.swing.JToggleButton();
        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel1 = new javax.swing.JPanel();
        jLabel16 = new javax.swing.JLabel();
        jTextField15 = new javax.swing.JTextField();
        jLabel17 = new javax.swing.JLabel();
        jTextField16 = new javax.swing.JTextField();
        jLabel18 = new javax.swing.JLabel();
        jTextField17 = new javax.swing.JTextField();
        jLabel19 = new javax.swing.JLabel();
        jTextField18 = new javax.swing.JTextField();
        jLabel20 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jRadioButton3 = new javax.swing.JRadioButton();
        jRadioButton4 = new javax.swing.JRadioButton();
        jLabel22 = new javax.swing.JLabel();
        jTextField20 = new javax.swing.JTextField();
        jTextField21 = new javax.swing.JTextField();
        jLabel23 = new javax.swing.JLabel();
        jTextField22 = new javax.swing.JTextField();
        jLabel24 = new javax.swing.JLabel();
        jTextField23 = new javax.swing.JTextField();
        jTextField24 = new javax.swing.JTextField();
        jTextField25 = new javax.swing.JTextField();
        jTextField26 = new javax.swing.JTextField();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jTextField40 = new javax.swing.JTextField();
        jLabel38 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jTextFieldReg7 = new javax.swing.JTextField();
        jTextFieldReg6 = new javax.swing.JTextField();
        jTextFieldReg5 = new javax.swing.JTextField();
        jTextFieldReg4 = new javax.swing.JTextField();
        jTextFieldReg3 = new javax.swing.JTextField();
        jTextFieldReg2 = new javax.swing.JTextField();
        jTextFieldReg1 = new javax.swing.JTextField();
        jTextFieldReg0 = new javax.swing.JTextField();
        jLabel41 = new javax.swing.JLabel();
        jTextFieldRegPointer = new javax.swing.JTextField();
        jTextFieldOutVal = new javax.swing.JTextField();
        jLabel42 = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        jLabel27 = new javax.swing.JLabel();
        jTextField27 = new javax.swing.JTextField();
        jLabel28 = new javax.swing.JLabel();
        jTextField28 = new javax.swing.JTextField();
        jLabel29 = new javax.swing.JLabel();
        jTextField29 = new javax.swing.JTextField();
        jLabel30 = new javax.swing.JLabel();
        jTextField30 = new javax.swing.JTextField();
        jLabel31 = new javax.swing.JLabel();
        jLabel32 = new javax.swing.JLabel();
        jRadioButton5 = new javax.swing.JRadioButton();
        jRadioButton6 = new javax.swing.JRadioButton();
        jLabel33 = new javax.swing.JLabel();
        jTextField31 = new javax.swing.JTextField();
        jTextField32 = new javax.swing.JTextField();
        jLabel34 = new javax.swing.JLabel();
        jTextField33 = new javax.swing.JTextField();
        jLabel35 = new javax.swing.JLabel();
        jTextField34 = new javax.swing.JTextField();
        jTextField35 = new javax.swing.JTextField();
        jTextField36 = new javax.swing.JTextField();
        jTextField37 = new javax.swing.JTextField();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTable4 = new javax.swing.JTable();
        jTextField38 = new javax.swing.JTextField();
        jTextField39 = new javax.swing.JTextField();
        jLabel37 = new javax.swing.JLabel();
        jLabel39 = new javax.swing.JLabel();
        jTextField41 = new javax.swing.JTextField();
        jTextFieldS4 = new javax.swing.JTextField();
        jTextFieldS3 = new javax.swing.JTextField();
        jTextFieldS2 = new javax.swing.JTextField();
        jTextFieldS1 = new javax.swing.JTextField();
        jTextFieldS5 = new javax.swing.JTextField();
        jTextFieldS6 = new javax.swing.JTextField();
        jLabel36 = new javax.swing.JLabel();
        jLabel43 = new javax.swing.JLabel();
        jTextFieldOutVal1 = new javax.swing.JTextField();
        jLabel44 = new javax.swing.JLabel();
        jTextFieldTA1 = new javax.swing.JTextField();
        jTextFieldTA2 = new javax.swing.JTextField();
        jTextFieldES = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jTextField2 = new javax.swing.JTextField();
        jTextField3 = new javax.swing.JTextField();
        jTextField4 = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jTextField5 = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jTextField6 = new javax.swing.JTextField();
        jLabel6 = new javax.swing.JLabel();
        jTextField7 = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jTextField8 = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jTextField9 = new javax.swing.JTextField();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jTextField10 = new javax.swing.JTextField();
        jTextField11 = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        jTextField12 = new javax.swing.JTextField();
        jTextField13 = new javax.swing.JTextField();
        jTextField14 = new javax.swing.JTextField();
        jLabel15 = new javax.swing.JLabel();
        jTextField19 = new javax.swing.JTextField();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jPanel3 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTable3 = new javax.swing.JTable();
        jPanel4 = new javax.swing.JPanel();
        jLabel25 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        jRadioButtonJ02 = new javax.swing.JRadioButton();
        jRadioButtonJ01 = new javax.swing.JRadioButton();
        jRadioButtonJ03 = new javax.swing.JRadioButton();
        jRadioButtonJ04 = new javax.swing.JRadioButton();
        jRadioButtonJ11 = new javax.swing.JRadioButton();
        jRadioButtonJ12 = new javax.swing.JRadioButton();
        jRadioButtonJ13 = new javax.swing.JRadioButton();
        jRadioButtonJ14 = new javax.swing.JRadioButton();

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

        jLabel16.setText("low level state");

        jTextField15.setPreferredSize(new java.awt.Dimension(220, 20));

        jLabel17.setText("high level state");

        jTextField16.setPreferredSize(new java.awt.Dimension(220, 20));

        jLabel18.setText("last 2430 command");

        jTextField17.setPreferredSize(new java.awt.Dimension(220, 20));

        jLabel19.setText("bit counter");

        jTextField18.setToolTipText("in from vectrex");
        jTextField18.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextField18.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField18ActionPerformed(evt);
            }
        });

        jLabel20.setText("current bit");

        jLabel21.setText("mode");

        buttonGroup3.add(jRadioButton3);
        jRadioButton3.setText("input to DS");

        buttonGroup3.add(jRadioButton4);
        jRadioButton4.setText("output from DS");
        jRadioButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton4ActionPerformed(evt);
            }
        });

        jLabel22.setText("external line");

        jTextField20.setToolTipText("in from vectrex");
        jTextField20.setPreferredSize(new java.awt.Dimension(40, 20));

        jTextField21.setToolTipText("out from DS");
        jTextField21.setPreferredSize(new java.awt.Dimension(40, 20));

        jLabel23.setText("sync cycles");

        jTextField22.setPreferredSize(new java.awt.Dimension(80, 20));

        jLabel24.setText("last 1w command");

        jTextField23.setPreferredSize(new java.awt.Dimension(220, 20));

        jTextField24.setToolTipText("out from DS");
        jTextField24.setPreferredSize(new java.awt.Dimension(40, 20));

        jTextField25.setToolTipText("in from vectrex");
        jTextField25.setPreferredSize(new java.awt.Dimension(40, 20));

        jTextField26.setToolTipText("out from DS");
        jTextField26.setPreferredSize(new java.awt.Dimension(40, 20));

        jTable2.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTable2.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane2.setViewportView(jTable2);

        jTextField40.setEditable(false);
        jTextField40.setText("$14");
        jTextField40.setToolTipText("");
        jTextField40.setPreferredSize(new java.awt.Dimension(40, 20));

        jLabel38.setText("family code");

        jLabel40.setText("application registers");

        jTextFieldReg7.setText("$00");
        jTextFieldReg7.setToolTipText("");
        jTextFieldReg7.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg7.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg7FocusLost(evt);
            }
        });
        jTextFieldReg7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg7ActionPerformed(evt);
            }
        });

        jTextFieldReg6.setText("$00");
        jTextFieldReg6.setToolTipText("");
        jTextFieldReg6.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg6.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg6FocusLost(evt);
            }
        });
        jTextFieldReg6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg6ActionPerformed(evt);
            }
        });

        jTextFieldReg5.setText("$00");
        jTextFieldReg5.setToolTipText("");
        jTextFieldReg5.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg5.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg5FocusLost(evt);
            }
        });
        jTextFieldReg5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg5ActionPerformed(evt);
            }
        });

        jTextFieldReg4.setText("$00");
        jTextFieldReg4.setToolTipText("");
        jTextFieldReg4.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg4.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg4FocusLost(evt);
            }
        });
        jTextFieldReg4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg4ActionPerformed(evt);
            }
        });

        jTextFieldReg3.setText("$00");
        jTextFieldReg3.setToolTipText("");
        jTextFieldReg3.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg3.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg3FocusLost(evt);
            }
        });
        jTextFieldReg3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg3ActionPerformed(evt);
            }
        });

        jTextFieldReg2.setText("$00");
        jTextFieldReg2.setToolTipText("");
        jTextFieldReg2.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg2.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg2FocusLost(evt);
            }
        });
        jTextFieldReg2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg2ActionPerformed(evt);
            }
        });

        jTextFieldReg1.setText("$00");
        jTextFieldReg1.setToolTipText("");
        jTextFieldReg1.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg1.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg1FocusLost(evt);
            }
        });
        jTextFieldReg1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg1ActionPerformed(evt);
            }
        });

        jTextFieldReg0.setText("$00");
        jTextFieldReg0.setToolTipText("");
        jTextFieldReg0.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldReg0.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldReg0FocusLost(evt);
            }
        });
        jTextFieldReg0.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldReg0ActionPerformed(evt);
            }
        });

        jLabel41.setText("reg pointer");

        jTextFieldRegPointer.setText("$00");
        jTextFieldRegPointer.setToolTipText("");
        jTextFieldRegPointer.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldRegPointer.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldRegPointerFocusLost(evt);
            }
        });
        jTextFieldRegPointer.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldRegPointerActionPerformed(evt);
            }
        });

        jTextFieldOutVal.setText("$00");
        jTextFieldOutVal.setToolTipText("");
        jTextFieldOutVal.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldOutVal.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldOutValFocusLost(evt);
            }
        });
        jTextFieldOutVal.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldOutValActionPerformed(evt);
            }
        });

        jLabel42.setText("current/last out value");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel24)
                            .addComponent(jLabel18)
                            .addComponent(jLabel17)
                            .addComponent(jLabel16)
                            .addComponent(jLabel40)
                            .addComponent(jLabel41))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jRadioButton4)
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addComponent(jTextFieldRegPointer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(jLabel42))
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                            .addComponent(jTextField16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField23, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField17, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jRadioButton3)
                                            .addComponent(jTextField15, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jLabel23)
                                            .addComponent(jLabel22)
                                            .addComponent(jLabel19)
                                            .addComponent(jLabel20)
                                            .addComponent(jLabel38))))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jTextField40, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldOutVal, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextField20, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField18, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField25, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addGap(18, 18, 18)
                                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextField26, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField21, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField24, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(jTextField22, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jTextFieldReg7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldReg6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(6, 6, 6)
                                .addComponent(jTextFieldReg5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(6, 6, 6)
                                .addComponent(jTextFieldReg4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldReg3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldReg2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldReg1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(6, 6, 6)
                                .addComponent(jTextFieldReg0, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(jLabel21)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGap(110, 110, 110)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel16)
                                    .addComponent(jTextField15, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField16, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel17))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField23, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel24))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField17, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel18))
                                .addGap(6, 6, 6)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jRadioButton3)
                                    .addComponent(jLabel21)))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel23)
                                    .addComponent(jTextField22, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel22)
                                    .addComponent(jTextField20, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField21, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel19)
                                    .addComponent(jTextField18, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel20)
                                    .addComponent(jTextField25, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField26, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jTextField40, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel38))))
                        .addGap(0, 0, 0)
                        .addComponent(jRadioButton4)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextFieldReg5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldReg4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldReg3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldReg2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldReg6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldReg7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel40)
                            .addComponent(jTextFieldReg1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextFieldReg0, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(8, 8, 8)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel41)
                            .addComponent(jTextFieldRegPointer, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextFieldOutVal, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel42)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 141, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(93, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("DS 2430A", jPanel1);

        jLabel27.setText("low level state");

        jTextField27.setPreferredSize(new java.awt.Dimension(200, 20));

        jLabel28.setText("high level state");

        jTextField28.setPreferredSize(new java.awt.Dimension(200, 20));

        jLabel29.setText("last 2431 command");

        jTextField29.setPreferredSize(new java.awt.Dimension(200, 20));

        jLabel30.setText("bit counter");

        jTextField30.setToolTipText("in from vectrex");
        jTextField30.setPreferredSize(new java.awt.Dimension(40, 20));

        jLabel31.setText("current bit");

        jLabel32.setText("mode");

        buttonGroup3.add(jRadioButton5);
        jRadioButton5.setText("input to DS");

        buttonGroup3.add(jRadioButton6);
        jRadioButton6.setText("output from DS");
        jRadioButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton6ActionPerformed(evt);
            }
        });

        jLabel33.setText("external line");

        jTextField31.setToolTipText("in from vectrex");
        jTextField31.setPreferredSize(new java.awt.Dimension(40, 20));

        jTextField32.setToolTipText("out from DS");
        jTextField32.setPreferredSize(new java.awt.Dimension(40, 20));

        jLabel34.setText("sync cycles");

        jTextField33.setPreferredSize(new java.awt.Dimension(86, 20));

        jLabel35.setText("last 1w command");

        jTextField34.setPreferredSize(new java.awt.Dimension(200, 20));

        jTextField35.setToolTipText("out from DS");
        jTextField35.setPreferredSize(new java.awt.Dimension(40, 20));

        jTextField36.setToolTipText("in from vectrex");
        jTextField36.setPreferredSize(new java.awt.Dimension(40, 20));

        jTextField37.setToolTipText("out from DS");
        jTextField37.setPreferredSize(new java.awt.Dimension(40, 20));

        jTable4.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTable4.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane4.setViewportView(jTable4);

        jTextField38.setToolTipText("in from vectrex");
        jTextField38.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextField38.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField38ActionPerformed(evt);
            }
        });

        jTextField39.setToolTipText("in from vectrex");
        jTextField39.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextField39.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField39ActionPerformed(evt);
            }
        });

        jLabel37.setText("User ID bytes");

        jLabel39.setText("family code");

        jTextField41.setEditable(false);
        jTextField41.setText("$2d");
        jTextField41.setToolTipText("in from vectrex");
        jTextField41.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextField41.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextField41ActionPerformed(evt);
            }
        });

        jTextFieldS4.setEditable(false);
        jTextFieldS4.setText("$00");
        jTextFieldS4.setToolTipText("");
        jTextFieldS4.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldS4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldS4ActionPerformed(evt);
            }
        });

        jTextFieldS3.setEditable(false);
        jTextFieldS3.setText("$00");
        jTextFieldS3.setToolTipText("");
        jTextFieldS3.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldS3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldS3ActionPerformed(evt);
            }
        });

        jTextFieldS2.setEditable(false);
        jTextFieldS2.setText("$00");
        jTextFieldS2.setToolTipText("");
        jTextFieldS2.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldS2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldS2ActionPerformed(evt);
            }
        });

        jTextFieldS1.setEditable(false);
        jTextFieldS1.setText("$00");
        jTextFieldS1.setToolTipText("");
        jTextFieldS1.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldS1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldS1ActionPerformed(evt);
            }
        });

        jTextFieldS5.setEditable(false);
        jTextFieldS5.setText("$00");
        jTextFieldS5.setToolTipText("");
        jTextFieldS5.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldS5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldS5ActionPerformed(evt);
            }
        });

        jTextFieldS6.setEditable(false);
        jTextFieldS6.setText("$00");
        jTextFieldS6.setToolTipText("");
        jTextFieldS6.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldS6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldS6ActionPerformed(evt);
            }
        });

        jLabel36.setText("serial code");

        jLabel43.setText("out value");

        jTextFieldOutVal1.setText("$00");
        jTextFieldOutVal1.setToolTipText("");
        jTextFieldOutVal1.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldOutVal1.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusLost(java.awt.event.FocusEvent evt) {
                jTextFieldOutVal1FocusLost(evt);
            }
        });
        jTextFieldOutVal1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldOutVal1ActionPerformed(evt);
            }
        });

        jLabel44.setText("TA1/TA2/ES");

        jTextFieldTA1.setEditable(false);
        jTextFieldTA1.setText("$00");
        jTextFieldTA1.setToolTipText("");
        jTextFieldTA1.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldTA1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldTA1ActionPerformed(evt);
            }
        });

        jTextFieldTA2.setEditable(false);
        jTextFieldTA2.setText("$00");
        jTextFieldTA2.setToolTipText("");
        jTextFieldTA2.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldTA2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldTA2ActionPerformed(evt);
            }
        });

        jTextFieldES.setEditable(false);
        jTextFieldES.setText("$00");
        jTextFieldES.setToolTipText("");
        jTextFieldES.setPreferredSize(new java.awt.Dimension(40, 20));
        jTextFieldES.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jTextFieldESActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel44)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel43)
                        .addGap(0, 0, Short.MAX_VALUE))))
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel35)
                            .addComponent(jLabel29)
                            .addComponent(jLabel28)
                            .addComponent(jLabel27)
                            .addComponent(jLabel36)))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(jLabel32)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE)
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextFieldOutVal1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addComponent(jTextFieldTA1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldTA2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldES, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addGroup(jPanel5Layout.createSequentialGroup()
                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addComponent(jTextFieldS6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldS5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldS4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldS3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldS2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextFieldS1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jRadioButton6)
                            .addGroup(jPanel5Layout.createSequentialGroup()
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextField27, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField28, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField29, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel5Layout.createSequentialGroup()
                                        .addComponent(jRadioButton5)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jTextField39, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel33)
                                    .addComponent(jLabel30)
                                    .addComponent(jLabel31)
                                    .addComponent(jLabel34)
                                    .addComponent(jLabel37)
                                    .addComponent(jLabel39))
                                .addGap(18, 18, 18)
                                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jTextField38, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addGroup(jPanel5Layout.createSequentialGroup()
                                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField36, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextField32, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField37, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(jTextField41, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextField33, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                        .addContainerGap(64, Short.MAX_VALUE))))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel27)
                    .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jTextField27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel34)
                        .addComponent(jTextField33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField28, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel28)
                    .addComponent(jLabel33)
                    .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField32, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel35)
                    .addComponent(jLabel30)
                    .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField29, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel29)
                    .addComponent(jLabel31)
                    .addComponent(jTextField36, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField37, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jRadioButton5)
                    .addComponent(jLabel32)
                    .addComponent(jTextField39, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel37)
                    .addComponent(jTextField38, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField41, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jRadioButton6)
                    .addComponent(jLabel39))
                .addGap(7, 7, 7)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldS6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldS5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldS4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldS3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldS2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldS1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel36))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel44)
                    .addComponent(jTextFieldTA1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldTA2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextFieldES, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel43)
                    .addComponent(jTextFieldOutVal1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(10, 10, 10)
                .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 198, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );

        jTabbedPane1.addTab("DS 2431", jPanel5);

        jLabel1.setText("low level state");

        jLabel4.setText("high level state");

        jLabel5.setText("medium level state");

        jLabel7.setText("sync counter");

        jLabel2.setText("sync base");

        jLabel3.setText("command");

        jLabel6.setText("status register");

        jLabel8.setText("address register");

        jLabel9.setText("mode");

        buttonGroup3.add(jRadioButton1);
        jRadioButton1.setText("input to microchip");

        buttonGroup3.add(jRadioButton2);
        jRadioButton2.setText("output from microchip");
        jRadioButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton2ActionPerformed(evt);
            }
        });

        jLabel10.setText("external line");

        jLabel11.setText("bit counter");

        jLabel12.setText("current bit");

        jLabel13.setText("manchester half bit 0");

        jTextField10.setToolTipText("in from vectrex");

        jLabel14.setText("manchester half bit 1");

        jTextField14.setToolTipText("out from Microchip");

        jLabel15.setText("write timer");

        jTable1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane1.setViewportView(jTable1);

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(5, 5, 5)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel3)
                            .addComponent(jLabel4)
                            .addComponent(jLabel5)
                            .addComponent(jLabel1)
                            .addComponent(jLabel8)
                            .addComponent(jLabel6)
                            .addComponent(jLabel9)
                            .addComponent(jLabel13)
                            .addComponent(jLabel14))
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jRadioButton1)
                            .addComponent(jRadioButton2)
                            .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 120, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel15)
                            .addComponent(jLabel2)
                            .addComponent(jLabel7)
                            .addComponent(jLabel10))
                        .addGap(10, 10, 10)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addGroup(jPanel2Layout.createSequentialGroup()
                                    .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                    .addComponent(jTextField14))
                                .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jTextField19, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(10, 10, 10)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel11)
                            .addComponent(jLabel12))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel2Layout.createSequentialGroup()
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel11)
                                    .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel12)
                                    .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel10)
                            .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel4)
                            .addComponent(jTextField14, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel15)
                                .addComponent(jTextField19, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel3))))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel1))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel5))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel6))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel8))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jRadioButton1)
                    .addComponent(jLabel9))
                .addGap(0, 0, 0)
                .addComponent(jRadioButton2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel13)
                    .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel14)
                    .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 170, Short.MAX_VALUE)
                .addContainerGap())
        );

        jTabbedPane1.addTab("Microchip 11AA010", jPanel2);

        jTable3.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTable3.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane3.setViewportView(jTable3);

        jLabel25.setText("LED flag:");

        jButton1.setText("insert coin");
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButton1MousePressed(evt);
            }
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jButton1MouseReleased(evt);
            }
        });

        jRadioButtonJ02.setBackground(new java.awt.Color(255, 153, 102));

        jRadioButtonJ01.setBackground(new java.awt.Color(51, 51, 51));

        jRadioButtonJ03.setBackground(new java.awt.Color(51, 255, 51));

        jRadioButtonJ04.setBackground(new java.awt.Color(153, 102, 255));

        jRadioButtonJ11.setBackground(new java.awt.Color(255, 255, 0));

        jRadioButtonJ12.setBackground(new java.awt.Color(153, 153, 153));

        jRadioButtonJ13.setBackground(new java.awt.Color(153, 102, 0));

        jRadioButtonJ14.setBackground(new java.awt.Color(0, 0, 255));

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jLabel25)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, 112, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addComponent(jButton1)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel4Layout.createSequentialGroup()
                                .addGap(31, 31, 31)
                                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addGroup(jPanel4Layout.createSequentialGroup()
                                        .addComponent(jRadioButtonJ02)
                                        .addGap(18, 18, 18)
                                        .addComponent(jRadioButtonJ03))
                                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel4Layout.createSequentialGroup()
                                        .addComponent(jRadioButtonJ13)
                                        .addGap(18, 18, 18)
                                        .addComponent(jRadioButtonJ01)))
                                .addGap(32, 32, 32))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jRadioButtonJ14)
                                    .addComponent(jRadioButtonJ04))
                                .addGap(81, 81, 81)
                                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jRadioButtonJ12, javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jRadioButtonJ11, javax.swing.GroupLayout.Alignment.TRAILING))))))
                .addGap(0, 323, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel25)
                    .addComponent(jLabel26, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jRadioButtonJ01)
                    .addComponent(jRadioButtonJ13))
                .addGap(11, 11, 11)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jRadioButtonJ11)
                    .addComponent(jRadioButtonJ14))
                .addGap(18, 18, 18)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jRadioButtonJ12)
                    .addComponent(jRadioButtonJ04))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 12, Short.MAX_VALUE)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton1, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jRadioButtonJ02)
                            .addComponent(jRadioButtonJ03))
                        .addGap(18, 18, 18))))
        );

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(6, 6, 6)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 527, Short.MAX_VALUE)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 273, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jTabbedPane1.addTab("extra ram", jPanel3);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 548, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTabbedPane1)
                .addGap(0, 0, 0))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jToggleButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton1ActionPerformed
        updateEnabled = jToggleButton1.isSelected();
    }//GEN-LAST:event_jToggleButton1ActionPerformed

    private void jRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jRadioButton2ActionPerformed

    private void jRadioButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton4ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jRadioButton4ActionPerformed

    private void jButton1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MousePressed
        if (vecxPanel==null) return;
        currentCart = vecxPanel.getCartridge();
        if (currentCart == null) return;
        currentCart.setPB6FromCarrtridge(true);
    }//GEN-LAST:event_jButton1MousePressed

    private void jButton1MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseReleased
        if (vecxPanel==null) return;
        currentCart = vecxPanel.getCartridge();
        if (currentCart == null) return;
        currentCart.setPB6FromCarrtridge(false);
    }//GEN-LAST:event_jButton1MouseReleased

    private void jTextFieldReg7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg7ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(7, (DASM6809.toNumber(jTextFieldReg7.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg7ActionPerformed

    private void jTextFieldReg6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg6ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(6, (DASM6809.toNumber(jTextFieldReg6.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg6ActionPerformed

    private void jTextFieldReg5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg5ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(5, (DASM6809.toNumber(jTextFieldReg5.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg5ActionPerformed

    private void jTextFieldReg4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg4ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(4, (DASM6809.toNumber(jTextFieldReg4.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg4ActionPerformed

    private void jTextFieldReg3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg3ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(3, (DASM6809.toNumber(jTextFieldReg3.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg3ActionPerformed

    private void jTextFieldReg2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg2ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(2, (DASM6809.toNumber(jTextFieldReg2.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg2ActionPerformed

    private void jTextFieldReg1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg1ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(1, (DASM6809.toNumber(jTextFieldReg1.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg1ActionPerformed

    private void jTextFieldReg0ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldReg0ActionPerformed
        if (currentDS == null) return;
        currentDS.setRegs(0, (DASM6809.toNumber(jTextFieldReg0.getText()) & 0xff) );
    }//GEN-LAST:event_jTextFieldReg0ActionPerformed

    private void jTextFieldReg0FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg0FocusLost
        jTextFieldReg0ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg0FocusLost

    private void jTextFieldReg1FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg1FocusLost
        jTextFieldReg1ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg1FocusLost

    private void jTextFieldReg2FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg2FocusLost
        jTextFieldReg2ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg2FocusLost

    private void jTextFieldReg3FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg3FocusLost
        jTextFieldReg3ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg3FocusLost

    private void jTextFieldReg4FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg4FocusLost
        jTextFieldReg4ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg4FocusLost

    private void jTextFieldReg5FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg5FocusLost
        jTextFieldReg5ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg5FocusLost

    private void jTextFieldReg6FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg6FocusLost
        jTextFieldReg6ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg6FocusLost

    private void jTextFieldReg7FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldReg7FocusLost
        jTextFieldReg7ActionPerformed(null);
    }//GEN-LAST:event_jTextFieldReg7FocusLost

    private void jTextFieldRegPointerFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldRegPointerFocusLost
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldRegPointerFocusLost

    private void jTextFieldRegPointerActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldRegPointerActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldRegPointerActionPerformed

    private void jTextFieldOutValFocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldOutValFocusLost
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldOutValFocusLost

    private void jTextFieldOutValActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldOutValActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldOutValActionPerformed

    private void jTextField18ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField18ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField18ActionPerformed

    private void jTextFieldESActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldESActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldESActionPerformed

    private void jTextFieldTA2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldTA2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldTA2ActionPerformed

    private void jTextFieldTA1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldTA1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldTA1ActionPerformed

    private void jTextFieldOutVal1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldOutVal1ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldOutVal1ActionPerformed

    private void jTextFieldOutVal1FocusLost(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_jTextFieldOutVal1FocusLost
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldOutVal1FocusLost

    private void jTextFieldS6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldS6ActionPerformed
        currentDS1.SERIAL_NUMBER[5] = (byte)(DASM6809.toNumber(jTextFieldS6.getText())&0xff);
    }//GEN-LAST:event_jTextFieldS6ActionPerformed

    private void jTextFieldS5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldS5ActionPerformed
        currentDS1.SERIAL_NUMBER[4] = (byte)(DASM6809.toNumber(jTextFieldS5.getText())&0xff);
    }//GEN-LAST:event_jTextFieldS5ActionPerformed

    private void jTextFieldS1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldS1ActionPerformed
        currentDS1.SERIAL_NUMBER[0] = (byte)(DASM6809.toNumber(jTextFieldS1.getText())&0xff);
    }//GEN-LAST:event_jTextFieldS1ActionPerformed

    private void jTextFieldS2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldS2ActionPerformed
        currentDS1.SERIAL_NUMBER[1] = (byte)(DASM6809.toNumber(jTextFieldS2.getText())&0xff);
    }//GEN-LAST:event_jTextFieldS2ActionPerformed

    private void jTextFieldS3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldS3ActionPerformed
        currentDS1.SERIAL_NUMBER[2] = (byte)(DASM6809.toNumber(jTextFieldS3.getText())&0xff);
    }//GEN-LAST:event_jTextFieldS3ActionPerformed

    private void jTextFieldS4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldS4ActionPerformed
        currentDS1.SERIAL_NUMBER[3] = (byte)(DASM6809.toNumber(jTextFieldS4.getText())&0xff);
    }//GEN-LAST:event_jTextFieldS4ActionPerformed

    private void jTextField41ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField41ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextField41ActionPerformed

    private void jTextField39ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField39ActionPerformed
        int id = DASM6809.toNumber(jTextField39.getText());
        if (currentDS1 != null)
        currentDS1.setIDByte2(id);
        correctTableDS1();
    }//GEN-LAST:event_jTextField39ActionPerformed

    private void jTextField38ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextField38ActionPerformed
        int id = DASM6809.toNumber(jTextField38.getText());
        if (currentDS1 != null)
        currentDS1.setIDByte1(id);
        correctTableDS1();
    }//GEN-LAST:event_jTextField38ActionPerformed

    private void jRadioButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton6ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jRadioButton6ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup3;
    private javax.swing.JButton jButton1;
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
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JRadioButton jRadioButton3;
    private javax.swing.JRadioButton jRadioButton4;
    private javax.swing.JRadioButton jRadioButton5;
    private javax.swing.JRadioButton jRadioButton6;
    private javax.swing.JRadioButton jRadioButtonJ01;
    private javax.swing.JRadioButton jRadioButtonJ02;
    private javax.swing.JRadioButton jRadioButtonJ03;
    private javax.swing.JRadioButton jRadioButtonJ04;
    private javax.swing.JRadioButton jRadioButtonJ11;
    private javax.swing.JRadioButton jRadioButtonJ12;
    private javax.swing.JRadioButton jRadioButtonJ13;
    private javax.swing.JRadioButton jRadioButtonJ14;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    private javax.swing.JTable jTable3;
    private javax.swing.JTable jTable4;
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
    private javax.swing.JTextField jTextField5;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextField7;
    private javax.swing.JTextField jTextField8;
    private javax.swing.JTextField jTextField9;
    private javax.swing.JTextField jTextFieldES;
    private javax.swing.JTextField jTextFieldOutVal;
    private javax.swing.JTextField jTextFieldOutVal1;
    private javax.swing.JTextField jTextFieldReg0;
    private javax.swing.JTextField jTextFieldReg1;
    private javax.swing.JTextField jTextFieldReg2;
    private javax.swing.JTextField jTextFieldReg3;
    private javax.swing.JTextField jTextFieldReg4;
    private javax.swing.JTextField jTextFieldReg5;
    private javax.swing.JTextField jTextFieldReg6;
    private javax.swing.JTextField jTextFieldReg7;
    private javax.swing.JTextField jTextFieldRegPointer;
    private javax.swing.JTextField jTextFieldS1;
    private javax.swing.JTextField jTextFieldS2;
    private javax.swing.JTextField jTextFieldS3;
    private javax.swing.JTextField jTextFieldS4;
    private javax.swing.JTextField jTextFieldS5;
    private javax.swing.JTextField jTextFieldS6;
    private javax.swing.JTextField jTextFieldTA1;
    private javax.swing.JTextField jTextFieldTA2;
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
    

    String asciiDumpRAM(int row)
    {
        if (vecxPanel==null) return "";
        String dump = "";
        for (int i=0;i<16; i++)
        {
            int v = currentCart.getExtraRam()[ row*16+i] &0xff;
            if (v<0x20) dump+=".";
            else if (v>0x6F) dump+=".";
            else if (v<0x5F) dump+=(char)v;
            else dump += "~";
        }
        return dump;
    }
    String asciiDumpMC(int row)
    {
        if (vecxPanel==null) return "";
        String dump = "";
        for (int i=0;i<16; i++)
        {
            int v = currentMC.getData()[ row*16+i] &0xff;
            if (v<0x20) dump+=".";
            else if (v>0x6F) dump+=".";
            else if (v<0x5F) dump+=(char)v;
            else dump += "~";
        }
        return dump;
    }
    String asciiDumpDS(int row)
    {
        if (vecxPanel==null) return "";
        String dump = "";
        for (int i=0;i<16; i++)
        {
            int v = currentDS.getData()[ row*16+i] &0xff;
            if (v<0x20) dump+=".";
            else if (v>0x6F) dump+=".";
            else if (v<0x5F) dump+=(char)v;
            else dump += "~";
        }
        return dump;
    }
    String asciiDumpDS1(int row)
    {
        if (vecxPanel==null) return "";
        String dump = "";
        for (int i=0;i<16; i++)
        {
            int v = currentDS1.getData()[ row*16+i] &0xff;
            if (v<0x20) dump+=".";
            else if (v>0x6F) dump+=".";
            else if (v<0x5F) dump+=(char)v;
            else dump += "~";
        }
        return dump;
    }
    public class MemoryDumpTableModelMC extends AbstractTableModel
    {
        public int getRowCount()
        {
            return 128/16;
        }
        public int getColumnCount()
        {
            return 18;
        }
        public Object getValueAt(int row, int col)
        {
            if (currentMC == null) return "";
            if (col == 0)
                return"$"+String.format("%02X",getAddress( row,  col)+1) ;
            if (col == 17)
                return asciiDumpMC(row);
            return "$"+String.format("%02X", currentMC.getData()[getAddress( row,  col)]);
        }

        public int getIntegerValueAt(int row, int col)
        {
            if (col == 0) return -1;
            if (col == 17) return -1;
            
            return currentMC.getData()[getAddress( row,  col)];
        }
        public int getAddress(int row, int col)
        {
            return row *16 + (col-1);
        }
        public String getColumnName(int column) {
            if (column == 0) return "Address";
            if (column == 17) return "Chars";
            return "$"+String.format("%02X",(column&0xff)-1);
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 40;
            if (col == 17) return 120;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
        
    }
    public class MemoryDumpTableModelDS extends AbstractTableModel
    {
        public int getRowCount()
        {
            return 32/16;
        }
        public int getColumnCount()
        {
            return 18;
        }
        public Object getValueAt(int row, int col)
        {
            if (currentDS == null) return "";
            if (col == 0)
                return"$"+String.format("%02X",getAddress( row,  col)+1) ;
            if (col == 17)
                return asciiDumpDS(row);
            return "$"+String.format("%02X", currentDS.getData()[getAddress( row,  col)]);
        }

        public int getIntegerValueAt(int row, int col)
        {
            if (col == 0) return -1;
            if (col == 17) return -1;
            
            return currentDS.getData()[getAddress( row,  col)];
        }
        public int getAddress(int row, int col)
        {
            return row *16 + (col-1);
        }
        public String getColumnName(int column) {
            if (column == 0) return "Address";
            if (column == 17) return "Chars";
            return "$"+String.format("%02X",(column&0xff)-1);
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 40;
            if (col == 17) return 120;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
        
    }
    public class MemoryDumpTableModelDS1 extends AbstractTableModel
    {
        public int getRowCount()
        {
            return (128+16)/16;
        }
        public int getColumnCount()
        {
            return 18;
        }
        public Object getValueAt(int row, int col)
        {
            if (currentDS1 == null) return "";
            if (col == 0)
                return"$"+String.format("%02X",getAddress( row,  col)+1) ;
            if (col == 17)
                return asciiDumpDS1(row);
            return "$"+String.format("%02X", currentDS1.getData()[getAddress( row,  col)]);
        }

        public int getIntegerValueAt(int row, int col)
        {
            if (col == 0) return -1;
            if (col == 17) return -1;
            
            return currentDS1.getData()[getAddress( row,  col)];
        }
        public int getAddress(int row, int col)
        {
            return row *16 + (col-1);
        }
        public String getColumnName(int column) {
            if (column == 0) return "Address";
            if (column == 17) return "Chars";
            return "$"+String.format("%02X",(column&0xff)-1);
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 40;
            if (col == 17) return 120;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
        
    }
    public class MemoryDumpTableModelRAM extends AbstractTableModel
    {
        public int getRowCount()
        {
            if (currentCart == null) return 0;
            if (currentCart.getExtraRam() == null) return 0;
            return currentCart.getExtraRam().length/16;
        }
        public int getColumnCount()
        {
            return 18;
        }
        public Object getValueAt(int row, int col)
        {
            if (currentCart == null) return "";
            if (currentCart.getExtraRam()==null) return "";
            if (col == 0)
            {
                int adr = getAddress( row,  col)+1;
                if (currentCart.isExtra2000Ram2k()) adr += 0x2000;
                if (currentCart.isExtra8000Ram2k()) adr += 0x8000;
                if (currentCart.isExtra6000Ram8k()) adr += 0x6000;
                return"$"+String.format("%04X",adr) ;
                
            }
            if (col == 17)
                return asciiDumpRAM(row);
            return "$"+String.format("%02X", currentCart.getExtraRam()[getAddress( row,  col)]);
        }

        public int getIntegerValueAt(int row, int col)
        {
            if (col == 0) return -1;
            if (col == 17) return -1;
            
            return currentCart.getExtraRam()[getAddress( row,  col)];
        }
        public int getAddress(int row, int col)
        {
            return row *16 + (col-1);
        }
        public String getColumnName(int column) {
            if (column == 0) return "Address";
            if (column == 17) return "Chars";
            return "$"+String.format("%02X",(column&0xff)-1);
        }
        public Class<?> getColumnClass(int columnIndex) {
            return String.class;
        }
        public boolean isCellEditable(int rowIndex, int columnIndex) {
            return false;
        }
        public int getColWidth(int col)
        {
            if (col == 0) return 40;
            if (col == 17) return 120;
            return 20;
        }
        public Color getBackground(int col)
        {
            if (col == 0) return new Color(200,255,200,255);
            return null; // default
        }
        
    }
    public void removeUIListerner()
    {
        UIManager.removePropertyChangeListener(pListener);
    }
    private PropertyChangeListener pListener = new PropertyChangeListener()
    {
        public void propertyChange(PropertyChangeEvent evt)
        {
            updateMyUI();
        }
    };
    void updateMyUI()
    {
        int fontSize = Theme.textFieldFont.getFont().getSize();
        int rowHeight = fontSize+3;
        jTable1.setRowHeight(rowHeight);
        jTable2.setRowHeight(rowHeight);
        jTable3.setRowHeight(rowHeight);
        jTable4.setRowHeight(rowHeight);
    }
}
