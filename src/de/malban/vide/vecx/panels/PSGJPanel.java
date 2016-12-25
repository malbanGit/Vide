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
import de.malban.gui.dialogs.InternalFrameFileChoser;
import de.malban.vide.dissy.DASM6809;
import de.malban.vide.dissy.DissiPanel;
import de.malban.vide.vecx.E8910State;
import de.malban.vide.vecx.Updatable;
import java.awt.Color;
import java.io.File;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class PSGJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    public boolean isLoadSettings() { return true; }
    public static final int REC_YM = 0;
    public static final int REC_BIN = 1;
    public static final int REC_DATA = 2;

    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    private DissiPanel dissi = null;
    public static String SID = "ayi";
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
        if (vecxPanel != null) vecxPanel.resetAyi();
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
        mParentMenuItem.setText("PSG");
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
    public PSGJPanel() {
        initComponents();
        jLabel43.setVisible(false);
        jTextField2.setText("tmp"+File.separator+"record.ym");
        

    }


    
    E8910State last = new E8910State();

    private void update()
    {        
        if (vecxPanel==null) return;

        E8910State now = vecxPanel.getE8910State();

        jLabel12.setText( ""+(now.PSG.PeriodA) );
        if (now.PSG.PeriodA != last.PSG.PeriodA) jLabel12.setForeground(Color.red);
        else jLabel12.setForeground(Color.black);
        
        jLabel36.setText( ""+(now.PSG.PeriodB) );
        if (now.PSG.PeriodB != last.PSG.PeriodB) jLabel36.setForeground(Color.red);
        else jLabel36.setForeground(Color.black);
        
        jLabel38.setText( ""+(now.PSG.PeriodC) );
        if (now.PSG.PeriodC != last.PSG.PeriodC) jLabel38.setForeground(Color.red);
        else jLabel38.setForeground(Color.black);
        
        jLabel40.setText( ""+(now.PSG.PeriodN) );
        if (now.PSG.PeriodN != last.PSG.PeriodN) jLabel40.setForeground(Color.red);
        else jLabel40.setForeground(Color.black);
        
        jLabel42.setText( ""+(now.PSG.PeriodE) );
        if (now.PSG.PeriodE != last.PSG.PeriodE) jLabel42.setForeground(Color.red);
        else jLabel42.setForeground(Color.black);
        
        
        jLabel45.setText( ""+(now.PSG.CountA) );
        if (now.PSG.CountA != last.PSG.CountA) jLabel45.setForeground(Color.red);
        else jLabel45.setForeground(Color.black);

        jLabel47.setText( ""+(now.PSG.CountB) );
        if (now.PSG.CountB != last.PSG.CountB) jLabel47.setForeground(Color.red);
        else jLabel47.setForeground(Color.black);

        jLabel49.setText( ""+(now.PSG.CountC) );
        if (now.PSG.CountC != last.PSG.CountC) jLabel49.setForeground(Color.red);
        else jLabel49.setForeground(Color.black);

        jLabel51.setText( ""+(now.PSG.CountN) );
        if (now.PSG.CountN != last.PSG.CountN) jLabel51.setForeground(Color.red);
        else jLabel51.setForeground(Color.black);

        jLabel53.setText( ""+(now.PSG.CountE) );
        if (now.PSG.CountE != last.PSG.CountE) jLabel53.setForeground(Color.red);
        else jLabel53.setForeground(Color.black);


        jLabel56.setText( ""+(now.PSG.VolA) );
        if (now.PSG.VolA != last.PSG.VolA) jLabel56.setForeground(Color.red);
        else jLabel56.setForeground(Color.black);

        jLabel58.setText( ""+(now.PSG.VolB) );
        if (now.PSG.VolB != last.PSG.VolB) jLabel58.setForeground(Color.red);
        else jLabel58.setForeground(Color.black);

        jLabel60.setText( ""+(now.PSG.VolC) );
        if (now.PSG.VolC != last.PSG.VolC) jLabel60.setForeground(Color.red);
        else jLabel60.setForeground(Color.black);

        jLabel62.setText( ""+(now.PSG.VolE) );
        if (now.PSG.VolE != last.PSG.VolE) jLabel62.setForeground(Color.red);
        else jLabel62.setForeground(Color.black);
        

        jLabel64.setText( ""+(now.PSG.EnvelopeA) );
        if (now.PSG.EnvelopeA != last.PSG.EnvelopeA) jLabel64.setForeground(Color.red);
        else jLabel64.setForeground(Color.black);
        
        jLabel65.setText( ""+(now.PSG.EnvelopeB) );
        if (now.PSG.EnvelopeB != last.PSG.EnvelopeB) jLabel65.setForeground(Color.red);
        else jLabel65.setForeground(Color.black);
        
        jLabel67.setText( ""+(now.PSG.EnvelopeC) );
        if (now.PSG.EnvelopeC != last.PSG.EnvelopeC) jLabel67.setForeground(Color.red);
        else jLabel67.setForeground(Color.black);
        
        jLabel70.setText( ""+(now.PSG.OutputA) );
        if (now.PSG.OutputA != last.PSG.OutputA) jLabel70.setForeground(Color.red);
        else jLabel70.setForeground(Color.black);
        
        jLabel71.setText( ""+(now.PSG.OutputB) );
        if (now.PSG.OutputB != last.PSG.OutputB) jLabel71.setForeground(Color.red);
        else jLabel71.setForeground(Color.black);
        
        jLabel73.setText( ""+(now.PSG.OutputC) );
        if (now.PSG.OutputC != last.PSG.OutputC) jLabel73.setForeground(Color.red);
        else jLabel73.setForeground(Color.black);
        
        jLabel75.setText( ""+(now.PSG.OutputN) );
        if (now.PSG.OutputN != last.PSG.OutputN) jLabel75.setForeground(Color.red);
        else jLabel75.setForeground(Color.black);
        

        jLabel13.setText( ""+(now.PSG.CountEnv) );
        if (now.PSG.CountEnv != last.PSG.CountEnv) jLabel13.setForeground(Color.red);
        else jLabel13.setForeground(Color.black);

        jLabel14.setText( ""+(now.PSG.Hold) );
        if (now.PSG.Hold != last.PSG.Hold) jLabel14.setForeground(Color.red);
        else jLabel14.setForeground(Color.black);
        
        jLabel15.setText( ""+(now.PSG.Alternate) );
        if (now.PSG.Alternate != last.PSG.Alternate) jLabel15.setForeground(Color.red);
        else jLabel15.setForeground(Color.black);
        
        jLabel16.setText( ""+(now.PSG.Attack) );
        if (now.PSG.Attack != last.PSG.Attack) jLabel16.setForeground(Color.red);
        else jLabel16.setForeground(Color.black);
        
        jLabel17.setText( ""+(now.PSG.Continue) );
        if (now.PSG.Continue != last.PSG.Continue) jLabel17.setForeground(Color.red);
        else jLabel17.setForeground(Color.black);
        
        jLabel18.setText( ""+(now.PSG.RNG) );
        if (now.PSG.RNG != last.PSG.RNG) jLabel18.setForeground(Color.red);
        else jLabel18.setForeground(Color.black);

        int reg = 0;
        jLabel77.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel77.setForeground(Color.red);
        else jLabel77.setForeground(Color.black);
        reg++;

        jLabel78.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel78.setForeground(Color.red);
        else jLabel78.setForeground(Color.black);
        reg++;
        
        jLabel79.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel79.setForeground(Color.red);
        else jLabel79.setForeground(Color.black);
        reg++;
        
        jLabel80.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel80.setForeground(Color.red);
        else jLabel80.setForeground(Color.black);
        reg++;
        
        jLabel84.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel84.setForeground(Color.red);
        else jLabel84.setForeground(Color.black);
        reg++;
        
        jLabel83.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel83.setForeground(Color.red);
        else jLabel83.setForeground(Color.black);
        reg++;
        
        jLabel82.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel82.setForeground(Color.red);
        else jLabel82.setForeground(Color.black);
        reg++;
        
        jLabel81.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel81.setForeground(Color.red);
        else jLabel81.setForeground(Color.black);

        String tt = "<html>\n";
        tt+= "hex: "+"$"+String.format("%02X", now.snd_regs[reg]&0x0ff);
        if ((now.snd_regs[reg] & 0x40) == 0x40)
        {
            tt+="<BR> bit 6 == 1 -> output enabled";
        }
        else
        {
            tt+="<BR> bit 6 == 0 -> input enabled";
        }
        
        tt += "</html>\n";
jLabel81.setToolTipText(tt);
        reg++;
        
        
        jLabel92.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel92.setForeground(Color.red);
        else jLabel92.setForeground(Color.black);
        reg++;
        
        jLabel91.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel91.setForeground(Color.red);
        else jLabel91.setForeground(Color.black);
        reg++;
        
        jLabel90.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel90.setForeground(Color.red);
        else jLabel90.setForeground(Color.black);
        reg++;
        
        jLabel89.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel89.setForeground(Color.red);
        else jLabel89.setForeground(Color.black);
        reg++;
        
        jLabel88.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel88.setForeground(Color.red);
        else jLabel88.setForeground(Color.black);
        reg++;
        
        jLabel87.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel87.setForeground(Color.red);
        else jLabel87.setForeground(Color.black);
        reg++;
        
        jLabel86.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel86.setForeground(Color.red);
        else jLabel86.setForeground(Color.black);
        reg++;
        
        jLabel85.setText( ""+(now.snd_regs[reg]) );
        if (now.snd_regs[reg] != last.snd_regs[reg]) jLabel85.setForeground(Color.red);
        else jLabel85.setForeground(Color.black);
        reg++;
        
        
        jLabel93.setText( ""+vecxPanel.getVecXState().snd_select );
        if (vecxPanel.getVecXState().snd_select != oldLatch) jLabel93.setForeground(Color.red);
        else jLabel93.setForeground(Color.black);
        
        oldLatch = vecxPanel.getVecXState().snd_select;
        E8910State.deepCopy(now, last);
        
        
        jLabelR00.setText("$"+String.format("%02X",now.snd_regs[0]&0x0ff));
        jLabelR01.setText("$"+String.format("%02X",now.snd_regs[1]&0x0ff));
        jLabelR02.setText("$"+String.format("%02X",now.snd_regs[2]&0x0ff));
        jLabelR03.setText("$"+String.format("%02X",now.snd_regs[3]&0x0ff));
        jLabelR04.setText("$"+String.format("%02X",now.snd_regs[4]&0x0ff));
        jLabelR05.setText("$"+String.format("%02X",now.snd_regs[5]&0x0ff));
        jLabelR06.setText("$"+String.format("%02X",now.snd_regs[6]&0x0ff));
        jLabelR07.setText("$"+String.format("%02X",now.snd_regs[7]&0x0ff));
        jLabelR08.setText("$"+String.format("%02X",now.snd_regs[8]&0x0ff));
        jLabelR09.setText("$"+String.format("%02X",now.snd_regs[9]&0x0ff));
        jLabelR0a.setText("$"+String.format("%02X",now.snd_regs[10]&0x0ff));
        jLabelR0b.setText("$"+String.format("%02X",now.snd_regs[11]&0x0ff));
        jLabelR0c.setText("$"+String.format("%02X",now.snd_regs[12]&0x0ff));
        jLabelR0d.setText("$"+String.format("%02X",now.snd_regs[13]&0x0ff));
        jLabelR0e.setText("$"+String.format("%02X",now.snd_regs[14]&0x0ff));
        jLabelR0f.setText("$"+String.format("%02X",now.snd_regs[15]&0x0ff));
    }

    int oldLatch = -1;
    
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
        jLabel2 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jToggleButton1 = new javax.swing.JToggleButton();
        jLabel35 = new javax.swing.JLabel();
        jLabel36 = new javax.swing.JLabel();
        jLabel37 = new javax.swing.JLabel();
        jLabel38 = new javax.swing.JLabel();
        jLabel39 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jLabel41 = new javax.swing.JLabel();
        jLabel42 = new javax.swing.JLabel();
        jLabel45 = new javax.swing.JLabel();
        jLabel46 = new javax.swing.JLabel();
        jLabel47 = new javax.swing.JLabel();
        jLabel48 = new javax.swing.JLabel();
        jLabel49 = new javax.swing.JLabel();
        jLabel50 = new javax.swing.JLabel();
        jLabel51 = new javax.swing.JLabel();
        jLabel52 = new javax.swing.JLabel();
        jLabel53 = new javax.swing.JLabel();
        jLabel54 = new javax.swing.JLabel();
        jLabel55 = new javax.swing.JLabel();
        jLabel56 = new javax.swing.JLabel();
        jLabel57 = new javax.swing.JLabel();
        jLabel58 = new javax.swing.JLabel();
        jLabel59 = new javax.swing.JLabel();
        jLabel60 = new javax.swing.JLabel();
        jLabel61 = new javax.swing.JLabel();
        jLabel62 = new javax.swing.JLabel();
        jLabel63 = new javax.swing.JLabel();
        jLabel64 = new javax.swing.JLabel();
        jLabel65 = new javax.swing.JLabel();
        jLabel66 = new javax.swing.JLabel();
        jLabel67 = new javax.swing.JLabel();
        jLabel68 = new javax.swing.JLabel();
        jLabel69 = new javax.swing.JLabel();
        jLabel70 = new javax.swing.JLabel();
        jLabel71 = new javax.swing.JLabel();
        jLabel72 = new javax.swing.JLabel();
        jLabel73 = new javax.swing.JLabel();
        jLabel74 = new javax.swing.JLabel();
        jLabel75 = new javax.swing.JLabel();
        jLabel76 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jLabel77 = new javax.swing.JLabel();
        jLabel78 = new javax.swing.JLabel();
        jLabel79 = new javax.swing.JLabel();
        jLabel80 = new javax.swing.JLabel();
        jLabel81 = new javax.swing.JLabel();
        jLabel82 = new javax.swing.JLabel();
        jLabel83 = new javax.swing.JLabel();
        jLabel84 = new javax.swing.JLabel();
        jLabel22 = new javax.swing.JLabel();
        jLabel23 = new javax.swing.JLabel();
        jLabel24 = new javax.swing.JLabel();
        jLabel25 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jLabel85 = new javax.swing.JLabel();
        jLabel86 = new javax.swing.JLabel();
        jLabel87 = new javax.swing.JLabel();
        jLabel88 = new javax.swing.JLabel();
        jLabel89 = new javax.swing.JLabel();
        jLabel90 = new javax.swing.JLabel();
        jLabel91 = new javax.swing.JLabel();
        jLabel92 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        jLabel28 = new javax.swing.JLabel();
        jLabel29 = new javax.swing.JLabel();
        jLabel30 = new javax.swing.JLabel();
        jLabel31 = new javax.swing.JLabel();
        jLabel32 = new javax.swing.JLabel();
        jLabel33 = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();
        jButtonStop3 = new javax.swing.JButton();
        jTextField1 = new javax.swing.JTextField();
        jButtonRecord = new javax.swing.JButton();
        jLabel11 = new javax.swing.JLabel();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jRadioButton3 = new javax.swing.JRadioButton();
        jLabel34 = new javax.swing.JLabel();
        jTextField2 = new javax.swing.JTextField();
        jButtonFileSelect3 = new javax.swing.JButton();
        jLabel43 = new javax.swing.JLabel();
        jRadioButton4 = new javax.swing.JRadioButton();
        jRadioButton5 = new javax.swing.JRadioButton();
        jTextField3 = new javax.swing.JTextField();
        jLabel1 = new javax.swing.JLabel();
        jLabel93 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jLabelR00 = new javax.swing.JLabel();
        jLabelR01 = new javax.swing.JLabel();
        jLabelR02 = new javax.swing.JLabel();
        jLabelR03 = new javax.swing.JLabel();
        jLabelR06 = new javax.swing.JLabel();
        jLabelR07 = new javax.swing.JLabel();
        jLabelR04 = new javax.swing.JLabel();
        jLabelR05 = new javax.swing.JLabel();
        jLabelR0e = new javax.swing.JLabel();
        jLabelR0f = new javax.swing.JLabel();
        jLabelR0d = new javax.swing.JLabel();
        jLabelR0c = new javax.swing.JLabel();
        jLabelR0b = new javax.swing.JLabel();
        jLabelR0a = new javax.swing.JLabel();
        jLabelR09 = new javax.swing.JLabel();
        jLabelR08 = new javax.swing.JLabel();
        jLabel44 = new javax.swing.JLabel();

        setName("regi"); // NOI18N

        jLabel2.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel2.setText("PeriodA");
        jLabel2.setToolTipText("");

        jLabel12.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel12.setText("0");

        jToggleButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton1.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton1.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton1ActionPerformed(evt);
            }
        });

        jLabel35.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel35.setText("PeriodB");
        jLabel35.setToolTipText("");

        jLabel36.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel36.setText("0");

        jLabel37.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel37.setText("PeriodC");
        jLabel37.setToolTipText("");

        jLabel38.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel38.setText("0");

        jLabel39.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel39.setText("PeriodN");
        jLabel39.setToolTipText("");

        jLabel40.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel40.setText("0");

        jLabel41.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel41.setText("PeriodE");
        jLabel41.setToolTipText("");

        jLabel42.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel42.setText("0");

        jLabel45.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel45.setText("0");

        jLabel46.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel46.setText("CountA");
        jLabel46.setToolTipText("");

        jLabel47.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel47.setText("0");

        jLabel48.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel48.setText("CountB");
        jLabel48.setToolTipText("");

        jLabel49.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel49.setText("0");

        jLabel50.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel50.setText("CountC");
        jLabel50.setToolTipText("");

        jLabel51.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel51.setText("0");

        jLabel52.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel52.setText("CountN");
        jLabel52.setToolTipText("");

        jLabel53.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel53.setText("0");

        jLabel54.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel54.setText("CountE");
        jLabel54.setToolTipText("");

        jLabel55.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel55.setText("VolA");
        jLabel55.setToolTipText("");

        jLabel56.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel56.setText("0");

        jLabel57.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel57.setText("VolB");
        jLabel57.setToolTipText("");

        jLabel58.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel58.setText("0");

        jLabel59.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel59.setText("VolC");
        jLabel59.setToolTipText("");

        jLabel60.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel60.setText("0");

        jLabel61.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel61.setText("VolE");
        jLabel61.setToolTipText("");

        jLabel62.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel62.setText("0");

        jLabel63.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel63.setText("EnvelopeA");
        jLabel63.setToolTipText("");

        jLabel64.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel64.setText("0");

        jLabel65.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel65.setText("0");

        jLabel66.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel66.setText("EnvelopeB");
        jLabel66.setToolTipText("");

        jLabel67.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel67.setText("0");

        jLabel68.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel68.setText("EnvelopeC");
        jLabel68.setToolTipText("");

        jLabel69.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel69.setText("OutputA");
        jLabel69.setToolTipText("");

        jLabel70.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel70.setText("0");

        jLabel71.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel71.setText("0");

        jLabel72.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel72.setText("OutputB");
        jLabel72.setToolTipText("");

        jLabel73.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel73.setText("0");

        jLabel74.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel74.setText("OutputC");
        jLabel74.setToolTipText("");

        jLabel75.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel75.setText("0");

        jLabel76.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel76.setText("OutputN");
        jLabel76.setToolTipText("");

        jLabel3.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel3.setText("CountEnv");
        jLabel3.setToolTipText("");

        jLabel13.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel13.setText("0");

        jLabel14.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel14.setText("0");

        jLabel4.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel4.setText("Hold");
        jLabel4.setToolTipText("");

        jLabel15.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel15.setText("0");

        jLabel5.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel5.setText("Alternate");
        jLabel5.setToolTipText("");

        jLabel16.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel16.setText("0");

        jLabel6.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel6.setText("Attack");
        jLabel6.setToolTipText("");

        jLabel17.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel17.setText("0");

        jLabel7.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel7.setText("Holding");
        jLabel7.setToolTipText("");

        jLabel8.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel8.setText("RNG");
        jLabel8.setToolTipText("");

        jLabel18.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel18.setText("0");

        jLabel9.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel9.setText("Registers");
        jLabel9.setToolTipText("If 0 the integrators are grounded and kept to 0, no matter what, if one, integration is possible!");

        jLabel10.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel10.setText("$00: ");
        jLabel10.setToolTipText("");

        jLabel19.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel19.setText("$01: ");
        jLabel19.setToolTipText("");

        jLabel20.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel20.setText("$02: ");
        jLabel20.setToolTipText("");

        jLabel21.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel21.setText("$03: ");
        jLabel21.setToolTipText("");

        jLabel77.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel77.setText("0");

        jLabel78.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel78.setText("0");

        jLabel79.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel79.setText("0");

        jLabel80.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel80.setText("0");

        jLabel81.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel81.setText("0");

        jLabel82.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel82.setText("0");

        jLabel83.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel83.setText("0");

        jLabel84.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel84.setText("0");

        jLabel22.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel22.setText("$04: ");
        jLabel22.setToolTipText("");

        jLabel23.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel23.setText("$05: ");
        jLabel23.setToolTipText("");

        jLabel24.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel24.setText("$06: ");
        jLabel24.setToolTipText("");

        jLabel25.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel25.setText("$07: ");
        jLabel25.setToolTipText("");

        jLabel26.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel26.setText("$0f: ");
        jLabel26.setToolTipText("");

        jLabel85.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel85.setText("0");

        jLabel86.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel86.setText("0");

        jLabel87.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel87.setText("0");

        jLabel88.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel88.setText("0");

        jLabel89.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel89.setText("0");

        jLabel90.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel90.setText("0");

        jLabel91.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel91.setText("0");

        jLabel92.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel92.setText("0");

        jLabel27.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel27.setText("$08: ");
        jLabel27.setToolTipText("");

        jLabel28.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel28.setText("$09: ");
        jLabel28.setToolTipText("");

        jLabel29.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel29.setText("$0a: ");
        jLabel29.setToolTipText("");

        jLabel30.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel30.setText("$0b: ");
        jLabel30.setToolTipText("");

        jLabel31.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel31.setText("$0c: ");
        jLabel31.setToolTipText("");

        jLabel32.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel32.setText("$0d: ");
        jLabel32.setToolTipText("");

        jLabel33.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel33.setText("$0e: ");
        jLabel33.setToolTipText("");

        jPanel1.setBorder(javax.swing.BorderFactory.createTitledBorder("YM record"));

        jButtonStop3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_stop_blue.png"))); // NOI18N
        jButtonStop3.setToolTipText("Stop recording");
        jButtonStop3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonStop3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonStop3ActionPerformed(evt);
            }
        });

        jTextField1.setText("$0047");

        jButtonRecord.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/control_record_blue.png"))); // NOI18N
        jButtonRecord.setToolTipText("Record a YM");
        jButtonRecord.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonRecord.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonRecordActionPerformed(evt);
            }
        });

        jLabel11.setText("save as:");

        buttonGroup1.add(jRadioButton1);
        jRadioButton1.setText("data");
        jRadioButton1.setToolTipText("Saved as unpacked data asm data statements, 16 registers, x times");
        jRadioButton1.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jRadioButton1.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jRadioButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton1ActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButton2);
        jRadioButton2.setText("bin");
        jRadioButton2.setToolTipText("Saved as direct binary, 16 registers in a row, X times");
        jRadioButton2.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jRadioButton2.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jRadioButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton2ActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButton3);
        jRadioButton3.setSelected(true);
        jRadioButton3.setText("ym");
        jRadioButton3.setToolTipText("Saved in interleaved unpacked YM6! format.");
        jRadioButton3.setHorizontalAlignment(javax.swing.SwingConstants.TRAILING);
        jRadioButton3.setHorizontalTextPosition(javax.swing.SwingConstants.LEADING);
        jRadioButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton3ActionPerformed(evt);
            }
        });

        jLabel34.setText("filename:");

        jTextField2.setText("tmp/record.ym");
        jTextField2.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jTextField2KeyTyped(evt);
            }
        });

        jButtonFileSelect3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/folder_go.png"))); // NOI18N
        jButtonFileSelect3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jButtonFileSelect3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButtonFileSelect3ActionPerformed(evt);
            }
        });

        jLabel43.setForeground(new java.awt.Color(255, 0, 0));
        jLabel43.setText("RECORDING...");

        buttonGroup2.add(jRadioButton4);
        jRadioButton4.setSelected(true);
        jRadioButton4.setText("record when address:");

        buttonGroup2.add(jRadioButton5);
        jRadioButton5.setText("each # of cycles:");

        jTextField3.setText("30000");

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addComponent(jLabel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(jLabel11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jButtonRecord)
                                .addGap(18, 18, 18)
                                .addComponent(jButtonStop3)))
                        .addGap(0, 0, 0)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jRadioButton5)
                                            .addComponent(jRadioButton4))
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                            .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)
                                            .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 80, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                    .addComponent(jTextField2))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jButtonFileSelect3))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jRadioButton1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jRadioButton2)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jRadioButton3))))
                    .addComponent(jLabel43))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButtonStop3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButtonRecord, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jRadioButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(5, 5, 5)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jRadioButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel11, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jRadioButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jRadioButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jRadioButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel34, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jButtonFileSelect3, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(5, 5, 5)
                .addComponent(jLabel43, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jLabel1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel1.setText("latched: ");

        jLabel93.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabel93.setText("0");

        jLabelR00.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR00.setText("$00");

        jLabelR01.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR01.setText("$00");

        jLabelR02.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR02.setText("$00");

        jLabelR03.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR03.setText("$00");

        jLabelR06.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR06.setText("$00");

        jLabelR07.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR07.setText("$00");

        jLabelR04.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR04.setText("$00");

        jLabelR05.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR05.setText("$00");

        jLabelR0e.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR0e.setText("$00");

        jLabelR0f.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR0f.setText("$00");

        jLabelR0d.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR0d.setText("$00");

        jLabelR0c.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR0c.setText("$00");

        jLabelR0b.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR0b.setText("$00");

        jLabelR0a.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR0a.setText("$00");

        jLabelR09.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR09.setText("$00");

        jLabelR08.setFont(new java.awt.Font("Courier", 0, 10)); // NOI18N
        jLabelR08.setText("$00");

        jLabel44.setFont(new java.awt.Font("Geneva", 2, 11)); // NOI18N
        jLabel44.setText("ym 'line'");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jLabelR00, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR01, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR02, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR03, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR04, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR05, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR06, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR07, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR08, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR09, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR0a, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR0b, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR0c, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR0d, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR0e, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabelR0f, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel44)
                .addGap(0, 53, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabelR07, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel44, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR08, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR02, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR0a, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR01, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR0b, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR00, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR0c, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR0d, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR0f, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR0e, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR05, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR04, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR06, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR03, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabelR09, javax.swing.GroupLayout.Alignment.TRAILING))
                .addGap(0, 0, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel41)
                            .addComponent(jLabel39)
                            .addComponent(jLabel37)
                            .addComponent(jLabel35)
                            .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(10, 10, 10)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                        .addComponent(jLabel36, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addComponent(jLabel38, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addComponent(jLabel40, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addComponent(jLabel42, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel12, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                .addComponent(jLabel48, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel46, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel50, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel52, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel54, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(2, 2, 2)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel53, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel45, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel47, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel49, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel51, javax.swing.GroupLayout.PREFERRED_SIZE, 46, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel56, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel63, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel64, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel69, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel70, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel61, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel62, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel57, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel58, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel66, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel65, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel72, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel71, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel59, javax.swing.GroupLayout.PREFERRED_SIZE, 38, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel60, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel68, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(jLabel67, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel76, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel75, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel74, javax.swing.GroupLayout.PREFERRED_SIZE, 63, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel73, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addGap(2, 2, 2)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel18, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel13, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel17, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel16, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel15, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel14, javax.swing.GroupLayout.PREFERRED_SIZE, 50, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel9)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel10)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel77, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel19)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel78, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel20)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel79, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel21)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel80, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel22)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel84, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel23)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel83, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel24)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel82, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel25)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel81, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel27)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel92, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel28)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel91, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel29)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel90, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel30)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel89, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel31)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel88, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel32)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel87, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel33)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel86, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))
                                    .addGroup(layout.createSequentialGroup()
                                        .addComponent(jLabel26)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jLabel85, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE))))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addGap(0, 0, 0)
                                .addComponent(jLabel93, javax.swing.GroupLayout.PREFERRED_SIZE, 30, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel2)
                            .addComponent(jLabel12)
                            .addComponent(jLabel46)
                            .addComponent(jLabel45)
                            .addComponent(jLabel55)
                            .addComponent(jLabel56)
                            .addComponent(jLabel63)
                            .addComponent(jLabel64)
                            .addComponent(jLabel69)
                            .addComponent(jLabel70))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel35)
                            .addComponent(jLabel36)
                            .addComponent(jLabel48)
                            .addComponent(jLabel47)
                            .addComponent(jLabel57)
                            .addComponent(jLabel58)
                            .addComponent(jLabel66)
                            .addComponent(jLabel65)
                            .addComponent(jLabel72)
                            .addComponent(jLabel71))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel37)
                            .addComponent(jLabel38)
                            .addComponent(jLabel50)
                            .addComponent(jLabel49)
                            .addComponent(jLabel59)
                            .addComponent(jLabel60)
                            .addComponent(jLabel68)
                            .addComponent(jLabel67)
                            .addComponent(jLabel74)
                            .addComponent(jLabel73))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel39)
                            .addComponent(jLabel40)
                            .addComponent(jLabel52)
                            .addComponent(jLabel51)
                            .addComponent(jLabel76)
                            .addComponent(jLabel75))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel62, javax.swing.GroupLayout.PREFERRED_SIZE, 11, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                .addComponent(jLabel41)
                                .addComponent(jLabel42)
                                .addComponent(jLabel54)
                                .addComponent(jLabel53)
                                .addComponent(jLabel61))))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel3)
                            .addComponent(jLabel13))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel4)
                            .addComponent(jLabel14))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel5)
                            .addComponent(jLabel15))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel6)
                            .addComponent(jLabel16))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel7)
                            .addComponent(jLabel17))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel8)
                            .addComponent(jLabel18, javax.swing.GroupLayout.PREFERRED_SIZE, 12, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel9)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel10)
                                    .addComponent(jLabel77))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel19)
                                    .addComponent(jLabel78))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel20)
                                    .addComponent(jLabel79))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel21)
                                    .addComponent(jLabel80))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel22)
                                    .addComponent(jLabel84))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel23)
                                    .addComponent(jLabel83))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel24)
                                    .addComponent(jLabel82))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel25)
                                    .addComponent(jLabel81)))
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel27)
                                    .addComponent(jLabel92))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel28)
                                    .addComponent(jLabel91))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel29)
                                    .addComponent(jLabel90))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel30)
                                    .addComponent(jLabel89))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel31)
                                    .addComponent(jLabel88))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel32)
                                    .addComponent(jLabel87))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel33)
                                    .addComponent(jLabel86))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                                    .addComponent(jLabel26)
                                    .addComponent(jLabel85, javax.swing.GroupLayout.PREFERRED_SIZE, 12, javax.swing.GroupLayout.PREFERRED_SIZE))))
                        .addGap(3, 3, 3)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel1)
                            .addComponent(jLabel93, javax.swing.GroupLayout.PREFERRED_SIZE, 12, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(2, 2, 2)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jToggleButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton1ActionPerformed
        updateEnabled = jToggleButton1.isSelected();
    }//GEN-LAST:event_jToggleButton1ActionPerformed

    private void jButtonStop3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonStop3ActionPerformed

        
        vecxPanel.stopRecord();
        jLabel43.setVisible(false);
        // TODO add your handling code here:
    }//GEN-LAST:event_jButtonStop3ActionPerformed

    private void jButtonRecordActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRecordActionPerformed

        int type = REC_YM;
        if (jRadioButton3.isSelected()) type = REC_YM;
        if (jRadioButton2.isSelected()) type = REC_BIN;
        if (jRadioButton1.isSelected()) type = REC_DATA;
        if (vecxPanel == null) return;
        if (jRadioButton4.isSelected())
            vecxPanel.startRecord(jTextField2.getText(), type,true, DASM6809.toNumber(jTextField1.getText()));
        else
            vecxPanel.startRecord(jTextField2.getText(), type,false, DASM6809.toNumber(jTextField3.getText()));
        jLabel43.setVisible(true);
        
    }//GEN-LAST:event_jButtonRecordActionPerformed

    private void jButtonFileSelect3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFileSelect3ActionPerformed

        InternalFrameFileChoser fc = new de.malban.gui.dialogs.InternalFrameFileChoser();
        fc.setMultiSelectionEnabled(false);
        fc.setCurrentDirectory(new File("tmp"));

        int r = fc.showOpenDialog(Configuration.getConfiguration().getMainFrame());
        if (r != InternalFrameFileChoser.APPROVE_OPTION) return;
        File files = fc.getSelectedFile();
        if (files != null)
        {
            String fullPath = fc.getSelectedFile().getAbsolutePath();
            jTextField2.setText(de.malban.util.Utility.makeRelative(fullPath));
        }
    }//GEN-LAST:event_jButtonFileSelect3ActionPerformed

    private void jTextField2KeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jTextField2KeyTyped
        nameChanged = true;
    }//GEN-LAST:event_jTextField2KeyTyped

    private void jRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton2ActionPerformed
        if (!nameChanged) jTextField2.setText("tmp"+File.separator+"record.bin");
    }//GEN-LAST:event_jRadioButton2ActionPerformed

    private void jRadioButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton3ActionPerformed
        if (!nameChanged) jTextField2.setText("tmp"+File.separator+"record.ym");
    }//GEN-LAST:event_jRadioButton3ActionPerformed

    private void jRadioButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton1ActionPerformed
        if (!nameChanged) jTextField2.setText("tmp"+File.separator+"record.asm");
    }//GEN-LAST:event_jRadioButton1ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.JButton jButtonFileSelect3;
    private javax.swing.JButton jButtonRecord;
    private javax.swing.JButton jButtonStop3;
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
    private javax.swing.JLabel jLabel64;
    private javax.swing.JLabel jLabel65;
    private javax.swing.JLabel jLabel66;
    private javax.swing.JLabel jLabel67;
    private javax.swing.JLabel jLabel68;
    private javax.swing.JLabel jLabel69;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel70;
    private javax.swing.JLabel jLabel71;
    private javax.swing.JLabel jLabel72;
    private javax.swing.JLabel jLabel73;
    private javax.swing.JLabel jLabel74;
    private javax.swing.JLabel jLabel75;
    private javax.swing.JLabel jLabel76;
    private javax.swing.JLabel jLabel77;
    private javax.swing.JLabel jLabel78;
    private javax.swing.JLabel jLabel79;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel80;
    private javax.swing.JLabel jLabel81;
    private javax.swing.JLabel jLabel82;
    private javax.swing.JLabel jLabel83;
    private javax.swing.JLabel jLabel84;
    private javax.swing.JLabel jLabel85;
    private javax.swing.JLabel jLabel86;
    private javax.swing.JLabel jLabel87;
    private javax.swing.JLabel jLabel88;
    private javax.swing.JLabel jLabel89;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JLabel jLabel90;
    private javax.swing.JLabel jLabel91;
    private javax.swing.JLabel jLabel92;
    private javax.swing.JLabel jLabel93;
    private javax.swing.JLabel jLabelR00;
    private javax.swing.JLabel jLabelR01;
    private javax.swing.JLabel jLabelR02;
    private javax.swing.JLabel jLabelR03;
    private javax.swing.JLabel jLabelR04;
    private javax.swing.JLabel jLabelR05;
    private javax.swing.JLabel jLabelR06;
    private javax.swing.JLabel jLabelR07;
    private javax.swing.JLabel jLabelR08;
    private javax.swing.JLabel jLabelR09;
    private javax.swing.JLabel jLabelR0a;
    private javax.swing.JLabel jLabelR0b;
    private javax.swing.JLabel jLabelR0c;
    private javax.swing.JLabel jLabelR0d;
    private javax.swing.JLabel jLabelR0e;
    private javax.swing.JLabel jLabelR0f;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JRadioButton jRadioButton3;
    private javax.swing.JRadioButton jRadioButton4;
    private javax.swing.JRadioButton jRadioButton5;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField2;
    private javax.swing.JTextField jTextField3;
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
    

}
