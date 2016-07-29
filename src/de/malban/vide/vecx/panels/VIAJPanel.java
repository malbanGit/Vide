/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.vide.vecx.VecXPanel;
import de.malban.config.Configuration;
import de.malban.gui.CSAMainFrame;
import de.malban.gui.Stateable;
import de.malban.gui.Windowable;
import de.malban.gui.components.CSAView;
import de.malban.vide.vecx.Breakpoint;
import de.malban.vide.vecx.Updatable;
import de.malban.vide.vecx.VecXState;
import java.awt.Color;
import java.awt.event.MouseEvent;
import java.io.Serializable;
import javax.swing.JTextField;

/**
 *
 * @author malban
 */
public class VIAJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    
    public void setVecxy(VecXPanel v)
    {
        vecxPanel = v;
    }

    
    @Override
    public void closing()
    {
        if (vecxPanel != null) vecxPanel.resetViai();
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
        mParentMenuItem.setText("VIA Registers");
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
    public void deinit()
    {
    }
    /**
     * Creates new form RegisterJPanel
     */
    public VIAJPanel() {
        initComponents();
    }

    
    

    VecXState currentDisplayed = new VecXState();
    private void update()
    {
        if (vecxPanel==null) return;
        Color output = jTextFieldoutput.getBackground();
        Color input = jTextFieldiput.getBackground();
        VecXState.deepCopy(vecxPanel.getVecXState(), currentDisplayed, false, false);
        
        jLabel11.setText("$"+String.format("%02X", currentDisplayed.via_orb));
        
        if ((currentDisplayed.via_acr & 0x80)!=0)  
        {
            jTextField17.setEnabled(true);
            jTextField1.setEnabled(false);
        }
        else  
        {
            jTextField17.setEnabled(false);
            jTextField1.setEnabled(true);
        }
        jTextField17.setText(""+(((currentDisplayed.via_t1pb7&0x80)==0x80)?"1":"0"));
        jTextField1.setText(""+(((currentDisplayed.via_orb&0x80)==0x80)?"1":"0"));
        
        jTextField2.setText(""+(((currentDisplayed.via_orb&0x40)==0x40)?"1":"0"));
        jTextField3.setText(""+(((currentDisplayed.alg_compare&0x20)==0x20)?"1":"0"));
        jTextField4.setText(""+(((currentDisplayed.via_orb&0x10)==0x10)?"1":"0"));
        jTextField5.setText(""+(((currentDisplayed.via_orb&0x08)==0x08)?"1":"0"));
        jTextField6.setText(""+(((currentDisplayed.via_orb&0x04)==0x04)?"1":"0"));
        jTextField7.setText(""+(((currentDisplayed.via_orb&0x02)==0x02)?"1":"0"));
        jTextField8.setText(""+(((currentDisplayed.via_orb&0x01)==0x01)?"1":"0"));
        
        
       // int porta
        int data = currentDisplayed.via_ora;
/*
        if ((currentDisplayed.via_orb & 0x18) == 0x08) 
        {
            / * the snd chip is driving port a * /
            data = vecxPanel.getE8910State().snd_regs[vecxPanel.getVecXState().snd_select];
        } 
*/
        
        jLabel12.setText("$"+String.format("%02X", data));
        jTextField9.setText(""+(((data&0x80)==0x80)?"1":"0"));
        jTextField10.setText(""+(((data&0x40)==0x40)?"1":"0"));
        jTextField11.setText(""+(((data&0x20)==0x20)?"1":"0"));
        jTextField12.setText(""+(((data&0x10)==0x10)?"1":"0"));
        jTextField13.setText(""+(((data&0x08)==0x08)?"1":"0"));
        jTextField14.setText(""+(((data&0x04)==0x04)?"1":"0"));
        jTextField15.setText(""+(((data&0x02)==0x02)?"1":"0"));
        jTextField16.setText(""+(((data&0x01)==0x01)?"1":"0"));
        
        jLabel32.setText("$"+String.format("%02X", currentDisplayed.via_ddrb));
        jTextField35.setText(""+(((currentDisplayed.via_ddrb&0x80)==0x80)?"1":"0"));
        jTextField36.setText(""+(((currentDisplayed.via_ddrb&0x40)==0x40)?"1":"0"));
        jTextField37.setText(""+(((currentDisplayed.via_ddrb&0x20)==0x20)?"1":"0"));
        jTextField38.setText(""+(((currentDisplayed.via_ddrb&0x10)==0x10)?"1":"0"));
        jTextField39.setText(""+(((currentDisplayed.via_ddrb&0x08)==0x08)?"1":"0"));
        jTextField40.setText(""+(((currentDisplayed.via_ddrb&0x04)==0x04)?"1":"0"));
        jTextField41.setText(""+(((currentDisplayed.via_ddrb&0x02)==0x02)?"1":"0"));
        jTextField42.setText(""+(((currentDisplayed.via_ddrb&0x01)==0x01)?"1":"0"));
        jTextField1.setBackground((((currentDisplayed.via_ddrb&0x80)==0x80)?(output):(input)));
        jTextField17.setBackground((((currentDisplayed.via_ddrb&0x80)==0x80)?(output):(input)));
        jTextField2.setBackground((((currentDisplayed.via_ddrb&0x40)==0x40)?(output):(input)));
        jTextField3.setBackground((((currentDisplayed.via_ddrb&0x20)==0x20)?(output):(input)));
        jTextField4.setBackground((((currentDisplayed.via_ddrb&0x10)==0x10)?(output):(input)));
        jTextField5.setBackground((((currentDisplayed.via_ddrb&0x08)==0x08)?(output):(input)));
        jTextField6.setBackground((((currentDisplayed.via_ddrb&0x04)==0x04)?(output):(input)));
        jTextField7.setBackground((((currentDisplayed.via_ddrb&0x02)==0x02)?(output):(input)));
        jTextField8.setBackground((((currentDisplayed.via_ddrb&0x01)==0x01)?(output):(input)));
    
        jLabel30.setText("$"+String.format("%02X", currentDisplayed.via_ddra));
        jTextField27.setText(""+(((currentDisplayed.via_ddra&0x80)==0x80)?"1":"0"));
        jTextField28.setText(""+(((currentDisplayed.via_ddra&0x40)==0x40)?"1":"0"));
        jTextField29.setText(""+(((currentDisplayed.via_ddra&0x20)==0x20)?"1":"0"));
        jTextField30.setText(""+(((currentDisplayed.via_ddra&0x10)==0x10)?"1":"0"));
        jTextField31.setText(""+(((currentDisplayed.via_ddra&0x08)==0x08)?"1":"0"));
        jTextField32.setText(""+(((currentDisplayed.via_ddra&0x04)==0x04)?"1":"0"));
        jTextField33.setText(""+(((currentDisplayed.via_ddra&0x02)==0x02)?"1":"0"));
        jTextField34.setText(""+(((currentDisplayed.via_ddra&0x01)==0x01)?"1":"0"));
        jTextField9.setBackground((((currentDisplayed.via_ddra&0x80)==0x80)?(output):(input)));
        jTextField10.setBackground((((currentDisplayed.via_ddra&0x40)==0x40)?(output):(input)));
        jTextField11.setBackground((((currentDisplayed.via_ddra&0x20)==0x20)?(output):(input)));
        jTextField12.setBackground((((currentDisplayed.via_ddra&0x10)==0x10)?(output):(input)));
        jTextField13.setBackground((((currentDisplayed.via_ddra&0x08)==0x08)?(output):(input)));
        jTextField14.setBackground((((currentDisplayed.via_ddra&0x04)==0x04)?(output):(input)));
        jTextField15.setBackground((((currentDisplayed.via_ddra&0x02)==0x02)?(output):(input)));
        jTextField16.setBackground((((currentDisplayed.via_ddra&0x01)==0x01)?(output):(input)));
        
        // via_t1c
        int tmp = (currentDisplayed.via_t1c)&0xff;
        jLabel34.setText("$"+String.format("%02X", tmp));
        jTextField43.setText(""+(((tmp&0x80)==0x80)?"1":"0"));
        jTextField44.setText(""+(((tmp&0x40)==0x40)?"1":"0"));
        jTextField45.setText(""+(((tmp&0x20)==0x20)?"1":"0"));
        jTextField46.setText(""+(((tmp&0x10)==0x10)?"1":"0"));
        jTextField47.setText(""+(((tmp&0x08)==0x08)?"1":"0"));
        jTextField48.setText(""+(((tmp&0x04)==0x04)?"1":"0"));
        jTextField49.setText(""+(((tmp&0x02)==0x02)?"1":"0"));
        jTextField50.setText(""+(((tmp&0x01)==0x01)?"1":"0"));

        
        // via_t1c
        tmp = (currentDisplayed.via_t1c>>8)&0xff;
        jLabel36.setText("$"+String.format("%02X", tmp));
        jTextField51.setText(""+(((tmp&0x80)==0x80)?"1":"0"));
        jTextField52.setText(""+(((tmp&0x40)==0x40)?"1":"0"));
        jTextField53.setText(""+(((tmp&0x20)==0x20)?"1":"0"));
        jTextField54.setText(""+(((tmp&0x10)==0x10)?"1":"0"));
        jTextField55.setText(""+(((tmp&0x08)==0x08)?"1":"0"));
        jTextField56.setText(""+(((tmp&0x04)==0x04)?"1":"0"));
        jTextField57.setText(""+(((tmp&0x02)==0x02)?"1":"0"));
        jTextField58.setText(""+(((tmp&0x01)==0x01)?"1":"0"));

        jLabel38.setText("$"+String.format("%02X", currentDisplayed.via_t1ll));
        jTextField59.setText(""+(((currentDisplayed.via_t1ll&0x80)==0x80)?"1":"0"));
        jTextField60.setText(""+(((currentDisplayed.via_t1ll&0x40)==0x40)?"1":"0"));
        jTextField61.setText(""+(((currentDisplayed.via_t1ll&0x20)==0x20)?"1":"0"));
        jTextField62.setText(""+(((currentDisplayed.via_t1ll&0x10)==0x10)?"1":"0"));
        jTextField63.setText(""+(((currentDisplayed.via_t1ll&0x08)==0x08)?"1":"0"));
        jTextField64.setText(""+(((currentDisplayed.via_t1ll&0x04)==0x04)?"1":"0"));
        jTextField65.setText(""+(((currentDisplayed.via_t1ll&0x02)==0x02)?"1":"0"));
        jTextField66.setText(""+(((currentDisplayed.via_t1ll&0x01)==0x01)?"1":"0"));

        jLabel40.setText("$"+String.format("%02X", currentDisplayed.via_t1lh));
        jTextField67.setText(""+(((currentDisplayed.via_t1lh&0x80)==0x80)?"1":"0"));
        jTextField68.setText(""+(((currentDisplayed.via_t1lh&0x40)==0x40)?"1":"0"));
        jTextField69.setText(""+(((currentDisplayed.via_t1lh&0x20)==0x20)?"1":"0"));
        jTextField70.setText(""+(((currentDisplayed.via_t1lh&0x10)==0x10)?"1":"0"));
        jTextField71.setText(""+(((currentDisplayed.via_t1lh&0x08)==0x08)?"1":"0"));
        jTextField72.setText(""+(((currentDisplayed.via_t1lh&0x04)==0x04)?"1":"0"));
        jTextField73.setText(""+(((currentDisplayed.via_t1lh&0x02)==0x02)?"1":"0"));
        jTextField74.setText(""+(((currentDisplayed.via_t1lh&0x01)==0x01)?"1":"0"));

        jLabel42.setText("$"+String.format("%02X", currentDisplayed.via_t2ll));
        jLabel58.setText("$"+String.format("%02X", currentDisplayed.via_t2c&0xff));
        jTextField75.setText(""+(((currentDisplayed.via_t2ll&0x80)==0x80)?"1":"0"));
        jTextField76.setText(""+(((currentDisplayed.via_t2ll&0x40)==0x40)?"1":"0"));
        jTextField77.setText(""+(((currentDisplayed.via_t2ll&0x20)==0x20)?"1":"0"));
        jTextField78.setText(""+(((currentDisplayed.via_t2ll&0x10)==0x10)?"1":"0"));
        jTextField79.setText(""+(((currentDisplayed.via_t2ll&0x08)==0x08)?"1":"0"));
        jTextField80.setText(""+(((currentDisplayed.via_t2ll&0x04)==0x04)?"1":"0"));
        jTextField81.setText(""+(((currentDisplayed.via_t2ll&0x02)==0x02)?"1":"0"));
        jTextField82.setText(""+(((currentDisplayed.via_t2ll&0x01)==0x01)?"1":"0"));
        

        tmp = (currentDisplayed.via_t2c>>8)&0xff;
        jLabel44.setText("$"+String.format("%02X", tmp));
        jTextField83.setText(""+(((tmp&0x80)==0x80)?"1":"0"));
        jTextField84.setText(""+(((tmp&0x40)==0x40)?"1":"0"));
        jTextField85.setText(""+(((tmp&0x20)==0x20)?"1":"0"));
        jTextField86.setText(""+(((tmp&0x10)==0x10)?"1":"0"));
        jTextField87.setText(""+(((tmp&0x08)==0x08)?"1":"0"));
        jTextField88.setText(""+(((tmp&0x04)==0x04)?"1":"0"));
        jTextField89.setText(""+(((tmp&0x02)==0x02)?"1":"0"));
        jTextField90.setText(""+(((tmp&0x01)==0x01)?"1":"0"));

        jLabel46.setText("$"+String.format("%02X", (currentDisplayed.via_sr&0xff)));
        jTextField91.setText(""+(((currentDisplayed.via_sr&0x80)==0x80)?"1":"0"));
        jTextField92.setText(""+(((currentDisplayed.via_sr&0x40)==0x40)?"1":"0"));
        jTextField93.setText(""+(((currentDisplayed.via_sr&0x20)==0x20)?"1":"0"));
        jTextField94.setText(""+(((currentDisplayed.via_sr&0x10)==0x10)?"1":"0"));
        jTextField95.setText(""+(((currentDisplayed.via_sr&0x08)==0x08)?"1":"0"));
        jTextField96.setText(""+(((currentDisplayed.via_sr&0x04)==0x04)?"1":"0"));
        jTextField97.setText(""+(((currentDisplayed.via_sr&0x02)==0x02)?"1":"0"));
        jTextField98.setText(""+(((currentDisplayed.via_sr&0x01)==0x01)?"1":"0"));

        jLabel20.setText("$"+String.format("%02X", currentDisplayed.via_acr));
        jTextField19.setText(""+(((currentDisplayed.via_acr&0x80)==0x80)?"1":"0"));
        jTextField20.setText(""+(((currentDisplayed.via_acr&0x40)==0x40)?"1":"0"));
        jTextField21.setText(""+(((currentDisplayed.via_acr&0x20)==0x20)?"1":"0"));
        jTextField22.setText(""+(((currentDisplayed.via_acr&0x10)==0x10)?"1":"0"));
        jTextField23.setText(""+(((currentDisplayed.via_acr&0x08)==0x08)?"1":"0"));
        jTextField24.setText(""+(((currentDisplayed.via_acr&0x04)==0x04)?"1":"0"));
        jTextField25.setText(""+(((currentDisplayed.via_acr&0x02)==0x02)?"1":"0"));
        jTextField26.setText(""+(((currentDisplayed.via_acr&0x01)==0x01)?"1":"0"));

        jLabel47.setText("$"+String.format("%02X", currentDisplayed.via_pcr));
        jTextField99.setText(""+(((currentDisplayed.via_pcr&0x80)==0x80)?"1":"0"));
        jTextField100.setText(""+(((currentDisplayed.via_pcr&0x40)==0x40)?"1":"0"));
        jTextField101.setText(""+(((currentDisplayed.via_pcr&0x20)==0x20)?"1":"0"));
        jTextField102.setText(""+(((currentDisplayed.via_pcr&0x10)==0x10)?"1":"0"));
        jTextField103.setText(""+(((currentDisplayed.via_pcr&0x08)==0x08)?"1":"0"));
        jTextField104.setText(""+(((currentDisplayed.via_pcr&0x04)==0x04)?"1":"0"));
        jTextField105.setText(""+(((currentDisplayed.via_pcr&0x02)==0x02)?"1":"0"));
        jTextField106.setText(""+(((currentDisplayed.via_pcr&0x01)==0x01)?"1":"0"));

        jLabel55.setText("$"+String.format("%02X", currentDisplayed.via_ifr));
        jTextField115.setText(""+(((currentDisplayed.via_ifr&0x80)==0x80)?"1":"0"));
        jTextField116.setText(""+(((currentDisplayed.via_ifr&0x40)==0x40)?"1":"0"));
        jTextField117.setText(""+(((currentDisplayed.via_ifr&0x20)==0x20)?"1":"0"));
        jTextField118.setText(""+(((currentDisplayed.via_ifr&0x10)==0x10)?"1":"0"));
        jTextField119.setText(""+(((currentDisplayed.via_ifr&0x08)==0x08)?"1":"0"));
        jTextField120.setText(""+(((currentDisplayed.via_ifr&0x04)==0x04)?"1":"0"));
        jTextField121.setText(""+(((currentDisplayed.via_ifr&0x02)==0x02)?"1":"0"));
        jTextField122.setText(""+(((currentDisplayed.via_ifr&0x01)==0x01)?"1":"0"));

        jLabel53.setText("$"+String.format("%02X", currentDisplayed.via_ier));
        jTextField107.setText(""+(((currentDisplayed.via_ier&0x80)==0x80)?"1":"0"));
        jTextField108.setText(""+(((currentDisplayed.via_ier&0x40)==0x40)?"1":"0"));
        jTextField109.setText(""+(((currentDisplayed.via_ier&0x20)==0x20)?"1":"0"));
        jTextField110.setText(""+(((currentDisplayed.via_ier&0x10)==0x10)?"1":"0"));
        jTextField111.setText(""+(((currentDisplayed.via_ier&0x08)==0x08)?"1":"0"));
        jTextField112.setText(""+(((currentDisplayed.via_ier&0x04)==0x04)?"1":"0"));
        jTextField113.setText(""+(((currentDisplayed.via_ier&0x02)==0x02)?"1":"0"));
        jTextField114.setText(""+(((currentDisplayed.via_ier&0x01)==0x01)?"1":"0"));

        jLabel13.setText("$"+String.format("%02X", currentDisplayed.via_ora));
        jTextField123.setText(""+(((currentDisplayed.via_ora&0x80)==0x80)?"1":"0"));
        jTextField124.setText(""+(((currentDisplayed.via_ora&0x40)==0x40)?"1":"0"));
        jTextField125.setText(""+(((currentDisplayed.via_ora&0x20)==0x20)?"1":"0"));
        jTextField126.setText(""+(((currentDisplayed.via_ora&0x10)==0x10)?"1":"0"));
        jTextField127.setText(""+(((currentDisplayed.via_ora&0x08)==0x08)?"1":"0"));
        jTextField128.setText(""+(((currentDisplayed.via_ora&0x04)==0x04)?"1":"0"));
        jTextField129.setText(""+(((currentDisplayed.via_ora&0x02)==0x02)?"1":"0"));
        jTextField130.setText(""+(((currentDisplayed.via_ora&0x01)==0x01)?"1":"0"));
        
    //    jTextField131
    
        jTextField131.setText(""+((currentDisplayed.via_ca1 !=0 )?"1":"0"));
        jTextField132.setText(""+((currentDisplayed.via_ca2 !=0 )?"1":"0"));
        jTextField133.setText(""+((currentDisplayed.sig_blank.intValue !=0 )?"1":"0"));
        jTextField135.setText(""+(((currentDisplayed.via_ifr&0x80) !=0 )?"1":"0"));
                
        
     }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPopupMenuPB6 = new javax.swing.JPopupMenu();
        jMenuItemPB6GoLow = new javax.swing.JMenuItem();
        jMenuItemPB6GoHigh = new javax.swing.JMenuItem();
        jMenuItemPB6Change = new javax.swing.JMenuItem();
        jPopupMenuCA1 = new javax.swing.JPopupMenu();
        jMenuItemCA1GoLow = new javax.swing.JMenuItem();
        jMenuItemCA1GoHigh = new javax.swing.JMenuItem();
        jMenuItemCA1Change = new javax.swing.JMenuItem();
        jLabel21 = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jTextField1 = new javax.swing.JTextField();
        jTextField2 = new javax.swing.JTextField();
        jTextField3 = new javax.swing.JTextField();
        jTextField4 = new javax.swing.JTextField();
        jTextField5 = new javax.swing.JTextField();
        jTextField6 = new javax.swing.JTextField();
        jTextField7 = new javax.swing.JTextField();
        jTextField8 = new javax.swing.JTextField();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel56 = new javax.swing.JLabel();
        jTextField17 = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        jLabel9 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jTextField9 = new javax.swing.JTextField();
        jTextField10 = new javax.swing.JTextField();
        jTextField11 = new javax.swing.JTextField();
        jTextField12 = new javax.swing.JTextField();
        jTextField13 = new javax.swing.JTextField();
        jTextField14 = new javax.swing.JTextField();
        jTextField15 = new javax.swing.JTextField();
        jTextField16 = new javax.swing.JTextField();
        jLabel57 = new javax.swing.JLabel();
        jPanel4 = new javax.swing.JPanel();
        jLabel29 = new javax.swing.JLabel();
        jLabel30 = new javax.swing.JLabel();
        jTextField27 = new javax.swing.JTextField();
        jTextField28 = new javax.swing.JTextField();
        jTextField29 = new javax.swing.JTextField();
        jTextField30 = new javax.swing.JTextField();
        jTextField31 = new javax.swing.JTextField();
        jTextField32 = new javax.swing.JTextField();
        jTextField33 = new javax.swing.JTextField();
        jTextField34 = new javax.swing.JTextField();
        jLabel61 = new javax.swing.JLabel();
        jPanel5 = new javax.swing.JPanel();
        jLabel31 = new javax.swing.JLabel();
        jLabel32 = new javax.swing.JLabel();
        jTextField35 = new javax.swing.JTextField();
        jTextField36 = new javax.swing.JTextField();
        jTextField37 = new javax.swing.JTextField();
        jTextField38 = new javax.swing.JTextField();
        jTextField39 = new javax.swing.JTextField();
        jTextField40 = new javax.swing.JTextField();
        jTextField41 = new javax.swing.JTextField();
        jTextField42 = new javax.swing.JTextField();
        jLabel59 = new javax.swing.JLabel();
        jPanel6 = new javax.swing.JPanel();
        jLabel33 = new javax.swing.JLabel();
        jLabel34 = new javax.swing.JLabel();
        jTextField43 = new javax.swing.JTextField();
        jTextField44 = new javax.swing.JTextField();
        jTextField45 = new javax.swing.JTextField();
        jTextField46 = new javax.swing.JTextField();
        jTextField47 = new javax.swing.JTextField();
        jTextField48 = new javax.swing.JTextField();
        jTextField49 = new javax.swing.JTextField();
        jTextField50 = new javax.swing.JTextField();
        jLabel60 = new javax.swing.JLabel();
        jPanel7 = new javax.swing.JPanel();
        jLabel35 = new javax.swing.JLabel();
        jLabel36 = new javax.swing.JLabel();
        jTextField51 = new javax.swing.JTextField();
        jTextField52 = new javax.swing.JTextField();
        jTextField53 = new javax.swing.JTextField();
        jTextField54 = new javax.swing.JTextField();
        jTextField55 = new javax.swing.JTextField();
        jTextField56 = new javax.swing.JTextField();
        jTextField57 = new javax.swing.JTextField();
        jTextField58 = new javax.swing.JTextField();
        jLabel62 = new javax.swing.JLabel();
        jTextFieldoutput = new javax.swing.JTextField();
        jTextFieldiput = new javax.swing.JTextField();
        jPanel8 = new javax.swing.JPanel();
        jLabel37 = new javax.swing.JLabel();
        jLabel38 = new javax.swing.JLabel();
        jTextField59 = new javax.swing.JTextField();
        jTextField60 = new javax.swing.JTextField();
        jTextField61 = new javax.swing.JTextField();
        jTextField62 = new javax.swing.JTextField();
        jTextField63 = new javax.swing.JTextField();
        jTextField64 = new javax.swing.JTextField();
        jTextField65 = new javax.swing.JTextField();
        jTextField66 = new javax.swing.JTextField();
        jLabel63 = new javax.swing.JLabel();
        jPanel9 = new javax.swing.JPanel();
        jLabel39 = new javax.swing.JLabel();
        jLabel40 = new javax.swing.JLabel();
        jTextField67 = new javax.swing.JTextField();
        jTextField68 = new javax.swing.JTextField();
        jTextField69 = new javax.swing.JTextField();
        jTextField70 = new javax.swing.JTextField();
        jTextField71 = new javax.swing.JTextField();
        jTextField72 = new javax.swing.JTextField();
        jTextField73 = new javax.swing.JTextField();
        jTextField74 = new javax.swing.JTextField();
        jLabel64 = new javax.swing.JLabel();
        jPanel10 = new javax.swing.JPanel();
        jLabel41 = new javax.swing.JLabel();
        jLabel42 = new javax.swing.JLabel();
        jTextField75 = new javax.swing.JTextField();
        jTextField76 = new javax.swing.JTextField();
        jTextField77 = new javax.swing.JTextField();
        jTextField78 = new javax.swing.JTextField();
        jTextField79 = new javax.swing.JTextField();
        jTextField80 = new javax.swing.JTextField();
        jTextField81 = new javax.swing.JTextField();
        jTextField82 = new javax.swing.JTextField();
        jLabel65 = new javax.swing.JLabel();
        jLabel58 = new javax.swing.JLabel();
        jPanel11 = new javax.swing.JPanel();
        jLabel43 = new javax.swing.JLabel();
        jLabel44 = new javax.swing.JLabel();
        jTextField83 = new javax.swing.JTextField();
        jTextField84 = new javax.swing.JTextField();
        jTextField85 = new javax.swing.JTextField();
        jTextField86 = new javax.swing.JTextField();
        jTextField87 = new javax.swing.JTextField();
        jTextField88 = new javax.swing.JTextField();
        jTextField89 = new javax.swing.JTextField();
        jTextField90 = new javax.swing.JTextField();
        jLabel66 = new javax.swing.JLabel();
        jPanel12 = new javax.swing.JPanel();
        jLabel45 = new javax.swing.JLabel();
        jLabel46 = new javax.swing.JLabel();
        jTextField91 = new javax.swing.JTextField();
        jTextField92 = new javax.swing.JTextField();
        jTextField93 = new javax.swing.JTextField();
        jTextField94 = new javax.swing.JTextField();
        jTextField95 = new javax.swing.JTextField();
        jTextField96 = new javax.swing.JTextField();
        jTextField97 = new javax.swing.JTextField();
        jTextField98 = new javax.swing.JTextField();
        jLabel67 = new javax.swing.JLabel();
        jPanel3 = new javax.swing.JPanel();
        jLabel19 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jTextField19 = new javax.swing.JTextField();
        jTextField20 = new javax.swing.JTextField();
        jTextField21 = new javax.swing.JTextField();
        jTextField22 = new javax.swing.JTextField();
        jTextField23 = new javax.swing.JTextField();
        jTextField24 = new javax.swing.JTextField();
        jTextField25 = new javax.swing.JTextField();
        jTextField26 = new javax.swing.JTextField();
        jLabel22 = new javax.swing.JLabel();
        jLabel23 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        jLabel28 = new javax.swing.JLabel();
        jLabel68 = new javax.swing.JLabel();
        jPanel13 = new javax.swing.JPanel();
        jLabel24 = new javax.swing.JLabel();
        jLabel47 = new javax.swing.JLabel();
        jTextField99 = new javax.swing.JTextField();
        jTextField100 = new javax.swing.JTextField();
        jTextField101 = new javax.swing.JTextField();
        jTextField102 = new javax.swing.JTextField();
        jTextField103 = new javax.swing.JTextField();
        jTextField104 = new javax.swing.JTextField();
        jTextField105 = new javax.swing.JTextField();
        jTextField106 = new javax.swing.JTextField();
        jLabel48 = new javax.swing.JLabel();
        jLabel50 = new javax.swing.JLabel();
        jLabel51 = new javax.swing.JLabel();
        jLabel52 = new javax.swing.JLabel();
        jLabel69 = new javax.swing.JLabel();
        jPanel14 = new javax.swing.JPanel();
        jLabel49 = new javax.swing.JLabel();
        jLabel53 = new javax.swing.JLabel();
        jTextField107 = new javax.swing.JTextField();
        jTextField108 = new javax.swing.JTextField();
        jTextField109 = new javax.swing.JTextField();
        jTextField110 = new javax.swing.JTextField();
        jTextField111 = new javax.swing.JTextField();
        jTextField112 = new javax.swing.JTextField();
        jTextField113 = new javax.swing.JTextField();
        jTextField114 = new javax.swing.JTextField();
        jLabel71 = new javax.swing.JLabel();
        jPanel15 = new javax.swing.JPanel();
        jLabel54 = new javax.swing.JLabel();
        jLabel55 = new javax.swing.JLabel();
        jTextField115 = new javax.swing.JTextField();
        jTextField116 = new javax.swing.JTextField();
        jTextField117 = new javax.swing.JTextField();
        jTextField118 = new javax.swing.JTextField();
        jTextField119 = new javax.swing.JTextField();
        jTextField120 = new javax.swing.JTextField();
        jTextField121 = new javax.swing.JTextField();
        jTextField122 = new javax.swing.JTextField();
        jLabel70 = new javax.swing.JLabel();
        jPanel16 = new javax.swing.JPanel();
        jLabel10 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jTextField123 = new javax.swing.JTextField();
        jTextField124 = new javax.swing.JTextField();
        jTextField125 = new javax.swing.JTextField();
        jTextField126 = new javax.swing.JTextField();
        jTextField127 = new javax.swing.JTextField();
        jTextField128 = new javax.swing.JTextField();
        jTextField129 = new javax.swing.JTextField();
        jTextField130 = new javax.swing.JTextField();
        jLabel72 = new javax.swing.JLabel();
        jPanel17 = new javax.swing.JPanel();
        jLabel73 = new javax.swing.JLabel();
        jTextField131 = new javax.swing.JTextField();
        jLabel81 = new javax.swing.JLabel();
        jPanel18 = new javax.swing.JPanel();
        jLabel74 = new javax.swing.JLabel();
        jTextField132 = new javax.swing.JTextField();
        jLabel78 = new javax.swing.JLabel();
        jPanel19 = new javax.swing.JPanel();
        jLabel75 = new javax.swing.JLabel();
        jTextField133 = new javax.swing.JTextField();
        jLabel79 = new javax.swing.JLabel();
        jPanel20 = new javax.swing.JPanel();
        jLabel76 = new javax.swing.JLabel();
        jTextField134 = new javax.swing.JTextField();
        jLabel80 = new javax.swing.JLabel();
        jPanel21 = new javax.swing.JPanel();
        jLabel77 = new javax.swing.JLabel();
        jTextField135 = new javax.swing.JTextField();
        jToggleButton3 = new javax.swing.JToggleButton();

        jMenuItemPB6GoLow.setLabel("Add Breakpoint on low");
        jMenuItemPB6GoLow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemPB6GoLowActionPerformed(evt);
            }
        });
        jPopupMenuPB6.add(jMenuItemPB6GoLow);

        jMenuItemPB6GoHigh.setText("Add Breakpoint on high");
        jMenuItemPB6GoHigh.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemPB6GoHighActionPerformed(evt);
            }
        });
        jPopupMenuPB6.add(jMenuItemPB6GoHigh);

        jMenuItemPB6Change.setText("Add Breakpoint on change");
        jMenuItemPB6Change.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemPB6ChangeActionPerformed(evt);
            }
        });
        jPopupMenuPB6.add(jMenuItemPB6Change);

        jMenuItemCA1GoLow.setLabel("Add Breakpoint on low");
        jMenuItemCA1GoLow.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCA1GoLowActionPerformed(evt);
            }
        });
        jPopupMenuCA1.add(jMenuItemCA1GoLow);

        jMenuItemCA1GoHigh.setText("Add Breakpoint on high");
        jMenuItemCA1GoHigh.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCA1GoHighActionPerformed(evt);
            }
        });
        jPopupMenuCA1.add(jMenuItemCA1GoHigh);

        jMenuItemCA1Change.setText("Add Breakpoint on change");
        jMenuItemCA1Change.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenuItemCA1ChangeActionPerformed(evt);
            }
        });
        jPopupMenuCA1.add(jMenuItemCA1Change);

        setName("regi"); // NOI18N

        jLabel21.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/VIAklein.png"))); // NOI18N

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel1.setText("ORB/IRA");

        jLabel11.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel11.setText("$ff");
        jLabel11.setToolTipText("ORB - no influenced by timer controlled bit 7!");

        jTextField1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField1.setText("0");
        jTextField1.setToolTipText("This line controls part of the vector drawing. It is an active LOW signal.\nOrb Controlled Bit!");

        jTextField2.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField2.setText("0");
        jTextField2.setName("pb6"); // NOI18N
        jTextField2.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTextField2MousePressed(evt);
            }
        });

        jTextField3.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField3.setText("0");
        jTextField3.setToolTipText("Feedback from the OP-AMP that does the comparison                     for calculation of analog joystick positions.");

        jTextField4.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField4.setText("0");
        jTextField4.setToolTipText("<html>\nThe above two bits are again \"bundled\" to 4 different possible states of communiction with the PSG chip:\n<UL>\n<LI>0 (binary: 00) PSG Inactive <BR>The PSG/CPU bus is inactive DA7--DA0 are in high impedance state.\n<LI>1 (binary: 01) Read from PSG <BR>This signal causes the contents of the register which is currently addressed to appear on the PSG/CPU bus. DA7--DA0 are in the output mode.\n<LI>2 (binary: 10) Write to PSG <BR>This signal indicates that the bus contains register data which should be latched into the currently addressed register. DA7--DA0 are in the input mode.\n<LI>3 (binary: 11) Latch address <BR>This signal indicates that the bus contains a register address which should be latched in the PSG. DA7--DA0 are in input mode.\n</UL>\n</html>");

        jTextField5.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField5.setText("0");
        jTextField5.setToolTipText("<html>\nThe above two bits are again \"bundled\" to 4 different possible states of communiction with the PSG chip:\n<UL>\n<LI>0 (binary: 00) PSG Inactive <BR>The PSG/CPU bus is inactive DA7--DA0 are in high impedance state.\n<LI>1 (binary: 01) Read from PSG <BR>This signal causes the contents of the register which is currently addressed to appear on the PSG/CPU bus. DA7--DA0 are in the output mode.\n<LI>2 (binary: 10) Write to PSG <BR>This signal indicates that the bus contains register data which should be latched into the currently addressed register. DA7--DA0 are in the input mode.\n<LI>3 (binary: 11) Latch address <BR>This signal indicates that the bus contains a register address which should be latched in the PSG. DA7--DA0 are in input mode.\n</UL>\n</html>");

        jTextField6.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField6.setText("0");
        jTextField6.setToolTipText("<html>\n<pre>\n        The other two inputs SEL0 and SEL1, again from PORT B of the 6522\n        Bits 1 & 2 respectively. These bits are used to form a 2 bit number\n        in the range 0-3, and when the multiplexer is active (see above)\n        these inputs are used to decide which ouput pin is connected to\n        the input pin. The Pin/Channel numbers for the Vector multiplexer\n        are given below:\n\n                0 - Y Axis integrator channel\n\n                1 - X,Y Axis integrator offset\n\n                2 - Z Axis (Vector Brightness) level\n\n                3 - Connected to sound output line via divider network\n</pre>\n</html>");

        jTextField7.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField7.setText("0");
        jTextField7.setToolTipText("<html>\n<pre>\n        The other two inputs SEL0 and SEL1, again from PORT B of the 6522\n        Bits 1 & 2 respectively. These bits are used to form a 2 bit number\n        in the range 0-3, and when the multiplexer is active (see above)\n        these inputs are used to decide which ouput pin is connected to\n        the input pin. The Pin/Channel numbers for the Vector multiplexer\n        are given below:\n\n                0 - Y Axis integrator channel\n\n                1 - X,Y Axis integrator offset\n\n                2 - Z Axis (Vector Brightness) level\n\n                3 - Connected to sound output line via divider network\n</pre>\n</html>");

        jTextField8.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField8.setText("0");

        jLabel2.setText("~MUX active");
        jLabel2.setToolTipText("Switch Control, enables/disables the analog multiplexer. AKA sample/hold.");

        jLabel3.setText("Mux select");
        jLabel3.setToolTipText("<html>\n<pre>\n        The other two inputs SEL0 and SEL1, again from PORT B of the 6522\n        Bits 1 & 2 respectively. These bits are used to form a 2 bit number\n        in the range 0-3, and when the multiplexer is active (see above)\n        these inputs are used to decide which ouput pin is connected to\n        the input pin. The Pin/Channel numbers for the Vector multiplexer\n        are given below:\n\n                0 - Y Axis integrator channel\n\n                1 - X,Y Axis integrator offset\n\n                2 - Z Axis (Vector Brightness) level\n\n                3 - Connected to sound output line via divider network\n</pre>\n</html>");

        jLabel4.setText("BC1");
        jLabel4.setToolTipText("Chip Select Signal for the AY-3-8192 Sound Chip");

        jLabel5.setText("Compare");
        jLabel5.setToolTipText("Feedback from the OP-AMP that does the comparison                     for calculation of analog joystick positions.");

        jLabel6.setText("BDIR");
        jLabel6.setToolTipText("Read/Write Signal for the AY-3-8192 Sound Chip");

        jLabel7.setText("~Ramp");
        jLabel7.setToolTipText("This line controls part of the vector drawing. It is an active LOW signal.");

        jLabel8.setText("external");

        jLabel56.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel56.setText("0");

        jTextField17.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField17.setText("0");
        jTextField17.setToolTipText("This line controls part of the vector drawing. It is an active LOW signal.\nTimer One Controlled Bit!\n");
        jTextField17.setEnabled(false);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(5, 5, 5)
                        .addComponent(jLabel56, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel11, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 49, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(3, 3, 3)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField17, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel7))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel8)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 37, Short.MAX_VALUE)
                        .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(62, 62, 62))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jLabel5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel6)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel3))
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(9, 9, 9)
                        .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel2)))
                .addContainerGap(33, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel11)
                    .addComponent(jTextField1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField8, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel56)
                    .addComponent(jTextField17, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(7, 7, 7)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel3)
                    .addComponent(jLabel5)
                    .addComponent(jLabel6)
                    .addComponent(jLabel7)
                    .addComponent(jLabel8)
                    .addComponent(jLabel1)
                    .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(0, 0, 0))
        );

        jPanel2.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel9.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel9.setText("ORA/IRA (goes to DAC)");

        jLabel12.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel12.setText("$ff");

        jTextField9.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField9.setText("0");

        jTextField10.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField10.setText("0");

        jTextField11.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField11.setText("0");

        jTextField12.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField12.setText("0");

        jTextField13.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField13.setText("0");

        jTextField14.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField14.setText("0");

        jTextField15.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField15.setText("0");

        jTextField16.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField16.setText("0");

        jLabel57.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel57.setText("1");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(5, 5, 5)
                .addComponent(jLabel57, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel12, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(3, 3, 3)
                .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField14, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField15, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField16, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 220, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel12)
                    .addComponent(jTextField9, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField10, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField11, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField12, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField13, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField14, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField15, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField16, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel57))
                .addGap(9, 9, 9)
                .addComponent(jLabel9))
        );

        jPanel4.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel29.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel29.setText("DDRA");

        jLabel30.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel30.setText("$ff");

        jTextField27.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField27.setText("0");

        jTextField28.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField28.setText("0");

        jTextField29.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField29.setText("0");

        jTextField30.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField30.setText("0");

        jTextField31.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField31.setText("0");

        jTextField32.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField32.setText("0");

        jTextField33.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField33.setText("0");

        jTextField34.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField34.setText("0");

        jLabel61.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel61.setText("3");

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel4Layout.createSequentialGroup()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addComponent(jLabel61)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel30, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel4Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel29, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addComponent(jTextField27, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField28, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField29, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField32, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField33, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField34, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel30)
                    .addComponent(jTextField27, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField28, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField29, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField30, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField31, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField32, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField33, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField34, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel61, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addComponent(jLabel29))
        );

        jPanel5.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel31.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel31.setText("DDRB");

        jLabel32.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel32.setText("$ff");

        jTextField35.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField35.setText("0");

        jTextField36.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField36.setText("0");

        jTextField37.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField37.setText("0");

        jTextField38.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField38.setText("0");

        jTextField39.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField39.setText("0");

        jTextField40.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField40.setText("0");

        jTextField41.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField41.setText("0");

        jTextField42.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField42.setText("0");

        jLabel59.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel59.setText("2");

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel5Layout.createSequentialGroup()
                        .addComponent(jLabel59, javax.swing.GroupLayout.PREFERRED_SIZE, 9, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel32, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(4, 4, 4)
                        .addComponent(jTextField35, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField36, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField37, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField38, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField39, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField40, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField41, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField42, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel31, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel32)
                    .addComponent(jTextField35, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField36, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField37, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField38, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField39, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField40, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField41, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField42, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel59))
                .addGap(9, 9, 9)
                .addComponent(jLabel31))
        );

        jPanel6.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel33.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel33.setText("T1C-L");
        jLabel33.setToolTipText("Can not be directly written to (allways latched from Reg 6)");

        jLabel34.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel34.setText("$ff");

        jTextField43.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField43.setText("0");

        jTextField44.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField44.setText("0");

        jTextField45.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField45.setText("0");

        jTextField46.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField46.setText("0");

        jTextField47.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField47.setText("0");

        jTextField48.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField48.setText("0");

        jTextField49.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField49.setText("0");

        jTextField50.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField50.setText("0");

        jLabel60.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel60.setText("4");

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel33, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(jPanel6Layout.createSequentialGroup()
                        .addComponent(jLabel60, javax.swing.GroupLayout.PREFERRED_SIZE, 9, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel34, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3)
                        .addComponent(jTextField43, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField44, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField45, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField46, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField47, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField48, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField49, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField50, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel34)
                    .addComponent(jTextField43, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField44, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField45, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField46, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField47, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField48, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField49, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField50, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel60))
                .addGap(9, 9, 9)
                .addComponent(jLabel33))
        );

        jPanel7.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel35.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel35.setText("T1C-H");
        jLabel35.setToolTipText("Cannot be directly written to, allways latched from reg 7, although latch can be written from reg 5");

        jLabel36.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel36.setText("$ff");

        jTextField51.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField51.setText("0");

        jTextField52.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField52.setText("0");

        jTextField53.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField53.setText("0");

        jTextField54.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField54.setText("0");

        jTextField55.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField55.setText("0");

        jTextField56.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField56.setText("0");

        jTextField57.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField57.setText("0");

        jTextField58.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField58.setText("0");

        jLabel62.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel62.setText("5");

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jLabel35, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addComponent(jLabel62, javax.swing.GroupLayout.PREFERRED_SIZE, 17, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel36, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(4, 4, 4)
                .addComponent(jTextField51, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField52, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField53, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField54, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField55, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField56, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField57, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField58, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel36)
                    .addComponent(jTextField51, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField52, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField53, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField54, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField55, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField56, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField57, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField58, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel62, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addComponent(jLabel35))
        );

        jTextFieldoutput.setBackground(new java.awt.Color(215, 255, 188));
        jTextFieldoutput.setText("output");
        jTextFieldoutput.setEnabled(false);

        jTextFieldiput.setBackground(new java.awt.Color(0, 203, 255));
        jTextFieldiput.setText("input");
        jTextFieldiput.setEnabled(false);

        jPanel8.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel37.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel37.setText("T1L-L");

        jLabel38.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel38.setText("$ff");

        jTextField59.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField59.setText("0");

        jTextField60.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField60.setText("0");

        jTextField61.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField61.setText("0");

        jTextField62.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField62.setText("0");

        jTextField63.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField63.setText("0");

        jTextField64.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField64.setText("0");

        jTextField65.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField65.setText("0");

        jTextField66.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField66.setText("0");

        jLabel63.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel63.setText("6");

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel8Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addComponent(jLabel63, javax.swing.GroupLayout.PREFERRED_SIZE, 9, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel38, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(1, 1, 1)
                        .addComponent(jTextField59, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField60, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField61, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField62, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField63, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField64, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField65, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField66, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel37, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel38)
                    .addComponent(jTextField59, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField60, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField61, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField62, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField63, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField64, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField65, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField66, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel63))
                .addGap(9, 9, 9)
                .addComponent(jLabel37))
        );

        jPanel9.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel39.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel39.setText("T1L-H");

        jLabel40.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel40.setText("$ff");

        jTextField67.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField67.setText("0");

        jTextField68.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField68.setText("0");

        jTextField69.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField69.setText("0");

        jTextField70.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField70.setText("0");

        jTextField71.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField71.setText("0");

        jTextField72.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField72.setText("0");

        jTextField73.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField73.setText("0");

        jTextField74.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField74.setText("0");

        jLabel64.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel64.setText("7");

        javax.swing.GroupLayout jPanel9Layout = new javax.swing.GroupLayout(jPanel9);
        jPanel9.setLayout(jPanel9Layout);
        jPanel9Layout.setHorizontalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel9Layout.createSequentialGroup()
                .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel9Layout.createSequentialGroup()
                        .addGap(6, 6, 6)
                        .addComponent(jLabel64, javax.swing.GroupLayout.PREFERRED_SIZE, 9, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(14, 14, 14)
                        .addComponent(jLabel40, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel9Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel39, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addComponent(jTextField67, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField68, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField69, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField70, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField71, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField72, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField73, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField74, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel9Layout.setVerticalGroup(
            jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel9Layout.createSequentialGroup()
                .addGroup(jPanel9Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel40)
                    .addComponent(jTextField67, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField68, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField69, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField70, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField71, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField72, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField73, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField74, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel64))
                .addGap(9, 9, 9)
                .addComponent(jLabel39))
        );

        jPanel10.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel41.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel41.setText("T2C-L");

        jLabel42.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel42.setText("$ff");

        jTextField75.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField75.setText("0");

        jTextField76.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField76.setText("0");

        jTextField77.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField77.setText("0");

        jTextField78.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField78.setText("0");

        jTextField79.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField79.setText("0");

        jTextField80.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField80.setText("0");

        jTextField81.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField81.setText("0");

        jTextField82.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField82.setText("0");

        jLabel65.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel65.setText("8");

        jLabel58.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel58.setText("$ff");
        jLabel58.setToolTipText("\"real\" counter low, above are the T2low latches");

        javax.swing.GroupLayout jPanel10Layout = new javax.swing.GroupLayout(jPanel10);
        jPanel10.setLayout(jPanel10Layout);
        jPanel10Layout.setHorizontalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel10Layout.createSequentialGroup()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addComponent(jLabel65)
                        .addGap(18, 18, 18)
                        .addComponent(jLabel42, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel10Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel41, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel10Layout.createSequentialGroup()
                        .addComponent(jTextField75, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField76, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField77, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField78, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField79, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField80, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField81, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField82, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel58, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel10Layout.setVerticalGroup(
            jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel10Layout.createSequentialGroup()
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel42)
                    .addComponent(jTextField75, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField76, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField77, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField78, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField79, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField80, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField81, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField82, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel65))
                .addGap(9, 9, 9)
                .addGroup(jPanel10Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel41)
                    .addComponent(jLabel58)))
        );

        jPanel11.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel43.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel43.setText("T2C-H");

        jLabel44.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel44.setText("$ff");

        jTextField83.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField83.setText("0");

        jTextField84.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField84.setText("0");

        jTextField85.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField85.setText("0");

        jTextField86.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField86.setText("0");

        jTextField87.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField87.setText("0");

        jTextField88.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField88.setText("0");

        jTextField89.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField89.setText("0");

        jTextField90.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField90.setText("0");

        jLabel66.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel66.setText("9");

        javax.swing.GroupLayout jPanel11Layout = new javax.swing.GroupLayout(jPanel11);
        jPanel11.setLayout(jPanel11Layout);
        jPanel11Layout.setHorizontalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel11Layout.createSequentialGroup()
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel11Layout.createSequentialGroup()
                        .addGap(6, 6, 6)
                        .addComponent(jLabel66)
                        .addGap(16, 16, 16)
                        .addComponent(jLabel44, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3))
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel11Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel43, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addComponent(jTextField83, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField84, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField85, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField86, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField87, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField88, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField89, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField90, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel11Layout.setVerticalGroup(
            jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel11Layout.createSequentialGroup()
                .addGroup(jPanel11Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel44)
                    .addComponent(jTextField83, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField84, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField85, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField86, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField87, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField88, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField89, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField90, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel66, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addComponent(jLabel43))
        );

        jPanel12.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel45.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel45.setText("Shift Register");

        jLabel46.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel46.setText("$ff");

        jTextField91.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField91.setText("0");

        jTextField92.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField92.setText("0");

        jTextField93.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField93.setText("0");

        jTextField94.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField94.setText("0");

        jTextField95.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField95.setText("0");

        jTextField96.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField96.setText("0");

        jTextField97.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField97.setText("0");

        jTextField98.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField98.setText("0");

        jLabel67.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel67.setText("10");

        javax.swing.GroupLayout jPanel12Layout = new javax.swing.GroupLayout(jPanel12);
        jPanel12.setLayout(jPanel12Layout);
        jPanel12Layout.setHorizontalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel12Layout.createSequentialGroup()
                .addGap(5, 5, 5)
                .addComponent(jLabel67)
                .addGap(10, 10, 10)
                .addComponent(jLabel46, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(3, 3, 3)
                .addComponent(jTextField91, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField92, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField93, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField94, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField95, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField96, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField97, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField98, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(jPanel12Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addComponent(jLabel45, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel12Layout.setVerticalGroup(
            jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel12Layout.createSequentialGroup()
                .addGroup(jPanel12Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel46)
                    .addComponent(jTextField91, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField92, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField93, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField94, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField95, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField96, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField97, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField98, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel67, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addComponent(jLabel45))
        );

        jPanel3.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel19.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel19.setText("ACR");

        jLabel20.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel20.setText("$ff");

        jTextField19.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField19.setText("0");
        jTextField19.setToolTipText("<html>\n<pre>\n      T1 TIMER CONTROL ---+   \n+-+-+----------------+-------+\n|7|6|OPERATION       | PB7   |\n+-+-+----------------+-------+\n|0|0|TIMED INTERRUPT |       |\n| | |EACH TIME T1 IS |       |\n| | |LOADED          |DISABLE|\n+-+-+----------------+       |\n|0|1|CONTINUOUS      |       |\n| | |INTERRUPTS      |       |\n+-+-+----------------+-------+\n|1|0|TIMED INTERRUPT |ONE-   |\n| | |EACH TIME T1 IS |SHOT   |\n| | |LOADED          |OUTPUT |\n+-+-+----------------+-------+\n|1|1|CONTINUOUS      |SQUARE |\n| | |INTERRUPTS      |WAVE   |\n| | |                |OUTPUT |\n+-+-+----------------+-------+\n\n</pre>\n</html>");

        jTextField20.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField20.setText("0");
        jTextField20.setToolTipText("<html>\n<pre>\n      T1 TIMER CONTROL ---+   \n+-+-+----------------+-------+\n|7|6|OPERATION       | PB7   |\n+-+-+----------------+-------+\n|0|0|TIMED INTERRUPT |       |\n| | |EACH TIME T1 IS |       |\n| | |LOADED          |DISABLE|\n+-+-+----------------+       |\n|0|1|CONTINUOUS      |       |\n| | |INTERRUPTS      |       |\n+-+-+----------------+-------+\n|1|0|TIMED INTERRUPT |ONE-   |\n| | |EACH TIME T1 IS |SHOT   |\n| | |LOADED          |OUTPUT |\n+-+-+----------------+-------+\n|1|1|CONTINUOUS      |SQUARE |\n| | |INTERRUPTS      |WAVE   |\n| | |                |OUTPUT |\n+-+-+----------------+-------+\n\n</pre>\n</html>");

        jTextField21.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField21.setText("0");
        jTextField21.setToolTipText("<html>\n<pre>\nT2 TIMER CONTROL -\n+-+-----------------+\n|5| OPERATION       |\n+-+-----------------+\n|0| TIMED INTERRUPT |\n+-+-----------------+\n|1| COUNT DOWN WITH |\n| | PULSES ON PB6   |\n+-+-----------------+\n</pre>\n</html>");

        jTextField22.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField22.setText("0");
        jTextField22.setToolTipText("<html><pre>\n+-+-+-+-----------------------------------+\n|4|3|2| OPERATION                         |\n+-+-+-+-----------------------------------+\n|0|0|0| DISABLED                          |\n+-+-+-+-----------------------------------+\n|0|0|1| SHIFT IN UNDER COMTROL OF T2      |\n+-+-+-+-----------------------------------+\n|0|1|0| SHIFT IN UNDER CONTROL OF 02      |\n+-+-+-+-----------------------------------+\n|0|1|1| SHIFT IN UNDER CONTROL OF EXT.CLK |\n+-+-+-+-----------------------------------+\n|1|0|0| SHIFT OUT FREE-RUNNING AT T2 RATE |\n+-+-+-+-----------------------------------+\n|1|0|1| SHIFT OUT UNDER CONTROL OF T2     |\n+-+-+-+-----------------------------------+\n|1|1|0| SHIFT OUT UNDER CONTROL OF 02     |\n+-+-+-+-----------------------------------+\n|1|1|1| SHIFT OUT UNDER CONTROL OF EXT.CLK|\n+-+-+-+-----------------------------------+\n</pre>\n</html>\n");

        jTextField23.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField23.setText("0");
        jTextField23.setToolTipText("<html><pre>\n+-+-+-+-----------------------------------+\n|4|3|2| OPERATION                         |\n+-+-+-+-----------------------------------+\n|0|0|0| DISABLED                          |\n+-+-+-+-----------------------------------+\n|0|0|1| SHIFT IN UNDER COMTROL OF T2      |\n+-+-+-+-----------------------------------+\n|0|1|0| SHIFT IN UNDER CONTROL OF 02      |\n+-+-+-+-----------------------------------+\n|0|1|1| SHIFT IN UNDER CONTROL OF EXT.CLK |\n+-+-+-+-----------------------------------+\n|1|0|0| SHIFT OUT FREE-RUNNING AT T2 RATE |\n+-+-+-+-----------------------------------+\n|1|0|1| SHIFT OUT UNDER CONTROL OF T2     |\n+-+-+-+-----------------------------------+\n|1|1|0| SHIFT OUT UNDER CONTROL OF 02     |\n+-+-+-+-----------------------------------+\n|1|1|1| SHIFT OUT UNDER CONTROL OF EXT.CLK|\n+-+-+-+-----------------------------------+\n</pre>\n</html>\n");

        jTextField24.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField24.setText("0");
        jTextField24.setToolTipText("<html><pre>\n+-+-+-+-----------------------------------+\n|4|3|2| OPERATION                         |\n+-+-+-+-----------------------------------+\n|0|0|0| DISABLED                          |\n+-+-+-+-----------------------------------+\n|0|0|1| SHIFT IN UNDER COMTROL OF T2      |\n+-+-+-+-----------------------------------+\n|0|1|0| SHIFT IN UNDER CONTROL OF 02      |\n+-+-+-+-----------------------------------+\n|0|1|1| SHIFT IN UNDER CONTROL OF EXT.CLK |\n+-+-+-+-----------------------------------+\n|1|0|0| SHIFT OUT FREE-RUNNING AT T2 RATE |\n+-+-+-+-----------------------------------+\n|1|0|1| SHIFT OUT UNDER CONTROL OF T2     |\n+-+-+-+-----------------------------------+\n|1|1|0| SHIFT OUT UNDER CONTROL OF 02     |\n+-+-+-+-----------------------------------+\n|1|1|1| SHIFT OUT UNDER CONTROL OF EXT.CLK|\n+-+-+-+-----------------------------------+\n</pre>\n</html>\n");

        jTextField25.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField25.setText("0");
        jTextField25.setToolTipText("0 Disable latching, 1 enable latching");

        jTextField26.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField26.setText("0");
        jTextField26.setToolTipText("");

        jLabel22.setText("PA");
        jLabel22.setToolTipText("0 Disable latching, 1 enable latching");

        jLabel23.setText("PB");
        jLabel23.setToolTipText("0 Disable latching, 1 enable latching");

        jLabel26.setText("Shift Control");
        jLabel26.setToolTipText("<html><pre>\n+-+-+-+-----------------------------------+\n|4|3|2| OPERATION                         |\n+-+-+-+-----------------------------------+\n|0|0|0| DISABLED                          |\n+-+-+-+-----------------------------------+\n|0|0|1| SHIFT IN UNDER COMTROL OF T2      |\n+-+-+-+-----------------------------------+\n|0|1|0| SHIFT IN UNDER CONTROL OF 02      |\n+-+-+-+-----------------------------------+\n|0|1|1| SHIFT IN UNDER CONTROL OF EXT.CLK |\n+-+-+-+-----------------------------------+\n|1|0|0| SHIFT OUT FREE-RUNNING AT T2 RATE |\n+-+-+-+-----------------------------------+\n|1|0|1| SHIFT OUT UNDER CONTROL OF T2     |\n+-+-+-+-----------------------------------+\n|1|1|0| SHIFT OUT UNDER CONTROL OF 02     |\n+-+-+-+-----------------------------------+\n|1|1|1| SHIFT OUT UNDER CONTROL OF EXT.CLK|\n+-+-+-+-----------------------------------+\n</pre>\n</html>\n");

        jLabel27.setText("T1 Timer Control");
        jLabel27.setToolTipText("<html>\n<pre>\n      T1 TIMER CONTROL ---+   \n+-+-+----------------+-------+\n|7|6|OPERATION       | PB7   |\n+-+-+----------------+-------+\n|0|0|TIMED INTERRUPT |       |\n| | |EACH TIME T1 IS |       |\n| | |LOADED          |DISABLE|\n+-+-+----------------+       |\n|0|1|CONTINUOUS      |       |\n| | |INTERRUPTS      |       |\n+-+-+----------------+-------+\n|1|0|TIMED INTERRUPT |ONE-   |\n| | |EACH TIME T1 IS |SHOT   |\n| | |LOADED          |OUTPUT |\n+-+-+----------------+-------+\n|1|1|CONTINUOUS      |SQUARE |\n| | |INTERRUPTS      |WAVE   |\n| | |                |OUTPUT |\n+-+-+----------------+-------+\n\n</pre>\n</html>");

        jLabel28.setText("T2 Timer Control");
        jLabel28.setToolTipText("<html>\n<pre>\nT2 TIMER CONTROL -\n+-+-----------------+\n|5| OPERATION       |\n+-+-----------------+\n|0| TIMED INTERRUPT |\n+-+-----------------+\n|1| COUNT DOWN WITH |\n| | PULSES ON PB6   |\n+-+-----------------+\n</pre>\n</html>");

        jLabel68.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel68.setText("11");

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(6, 6, 6)
                        .addComponent(jLabel68)
                        .addGap(8, 8, 8)
                        .addComponent(jLabel20, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel19, javax.swing.GroupLayout.PREFERRED_SIZE, 33, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(3, 3, 3)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTextField19, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField20, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel27))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel28)
                    .addComponent(jTextField21, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jTextField22, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField23, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField24, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel26))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jTextField25, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel23))
                .addGap(18, 18, 18)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel22)
                    .addComponent(jTextField26, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel20)
                    .addComponent(jTextField19, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField20, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField21, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField22, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField23, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField24, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField25, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField26, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel68, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(7, 7, 7)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel22)
                    .addComponent(jLabel23)
                    .addComponent(jLabel26)
                    .addComponent(jLabel27)
                    .addComponent(jLabel28)
                    .addComponent(jLabel19)))
        );

        jPanel13.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel24.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel24.setText("PCR");

        jLabel47.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel47.setText("$ff");

        jTextField99.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField99.setText("0");
        jTextField99.setToolTipText("<html>\n<pre>\n         CB2 CONTROL -----+      \n+-+-+-+------------------------+ \n|7|6|5| OPERATION              | \n+-+-+-+------------------------+ \n|0|0|0| INPUT NEG. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|0|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT NEGATIVE EDGE    | \n+-+-+-+------------------------+ \n|0|1|0| INPUT POS. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|1|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT POSITIVE EDGE    | \n+-+-+-+------------------------+ \n|1|0|0| HANDSHAKE OUTPUT       | \n+-+-+-+------------------------+ \n|1|0|1| PULSE OUTPUT           | \n+-+-+-+------------------------+ \n|1|1|0| LOW OUTPUT             | \n+-+-+-+------------------------+ \n|1|1|1| HIGH OUTPUT            | \n+-+-+-+------------------------+ \n\n</pre>\n</html>");

        jTextField100.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField100.setText("0");
        jTextField100.setToolTipText("<html>\n<pre>\n         CB2 CONTROL -----+      \n+-+-+-+------------------------+ \n|7|6|5| OPERATION              | \n+-+-+-+------------------------+ \n|0|0|0| INPUT NEG. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|0|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT NEGATIVE EDGE    | \n+-+-+-+------------------------+ \n|0|1|0| INPUT POS. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|1|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT POSITIVE EDGE    | \n+-+-+-+------------------------+ \n|1|0|0| HANDSHAKE OUTPUT       | \n+-+-+-+------------------------+ \n|1|0|1| PULSE OUTPUT           | \n+-+-+-+------------------------+ \n|1|1|0| LOW OUTPUT             | \n+-+-+-+------------------------+ \n|1|1|1| HIGH OUTPUT            | \n+-+-+-+------------------------+ \n\n</pre>\n</html>");

        jTextField101.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField101.setText("0");
        jTextField101.setToolTipText("<html>\n<pre>\n         CB2 CONTROL -----+      \n+-+-+-+------------------------+ \n|7|6|5| OPERATION              | \n+-+-+-+------------------------+ \n|0|0|0| INPUT NEG. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|0|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT NEGATIVE EDGE    | \n+-+-+-+------------------------+ \n|0|1|0| INPUT POS. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|1|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT POSITIVE EDGE    | \n+-+-+-+------------------------+ \n|1|0|0| HANDSHAKE OUTPUT       | \n+-+-+-+------------------------+ \n|1|0|1| PULSE OUTPUT           | \n+-+-+-+------------------------+ \n|1|1|0| LOW OUTPUT             | \n+-+-+-+------------------------+ \n|1|1|1| HIGH OUTPUT            | \n+-+-+-+------------------------+ \n\n</pre>\n</html>");

        jTextField102.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField102.setText("0");
        jTextField102.setToolTipText("<html>\n<pre>\n    CB1 INTERRUPT CONTROL ---\n+--------------------------+ \n| 0 = NEGATIVE ACTIVE EDGE | \n| 1 = POSITIVE ACTIVE EDGE | \n+--------------------------+ \n                             \n\n</pre> </html> ");

        jTextField103.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField103.setText("0");
        jTextField103.setToolTipText("<html>\n<pre>\n +---- CA2 INTERRUPT CONTROL     \n  +-+-+-+------------------------+\n  |3|2|1| OPERATION              |\n  +-+-+-+------------------------+\n  |0|0|0| INPUT NEG. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|0|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT NEGATIVE EDGE    |\n  +-+-+-+------------------------+\n  |0|1|0| INPUT POS. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|1|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT POSITIVE EDGE    |\n  +-+-+-+------------------------+\n  |1|0|0| HANDSHAKE OUTPUT       |\n  +-+-+-+------------------------+\n  |1|0|1| PULSE OUTPUT           |\n  +-+-+-+------------------------+\n  |1|1|0| LOW OUTPUT             |\n  +-+-+-+------------------------+\n  |1|1|1| HIGH OUTPUT            |\n  +-+-+-+------------------------+\n</pre>\n</html>");

        jTextField104.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField104.setText("0");
        jTextField104.setToolTipText("<html>\n<pre>\n +---- CA2 INTERRUPT CONTROL     \n  +-+-+-+------------------------+\n  |3|2|1| OPERATION              |\n  +-+-+-+------------------------+\n  |0|0|0| INPUT NEG. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|0|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT NEGATIVE EDGE    |\n  +-+-+-+------------------------+\n  |0|1|0| INPUT POS. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|1|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT POSITIVE EDGE    |\n  +-+-+-+------------------------+\n  |1|0|0| HANDSHAKE OUTPUT       |\n  +-+-+-+------------------------+\n  |1|0|1| PULSE OUTPUT           |\n  +-+-+-+------------------------+\n  |1|1|0| LOW OUTPUT             |\n  +-+-+-+------------------------+\n  |1|1|1| HIGH OUTPUT            |\n  +-+-+-+------------------------+\n</pre>\n</html>");

        jTextField105.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField105.setText("0");
        jTextField105.setToolTipText("<html>\n<pre>\n +---- CA2 INTERRUPT CONTROL     \n  +-+-+-+------------------------+\n  |3|2|1| OPERATION              |\n  +-+-+-+------------------------+\n  |0|0|0| INPUT NEG. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|0|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT NEGATIVE EDGE    |\n  +-+-+-+------------------------+\n  |0|1|0| INPUT POS. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|1|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT POSITIVE EDGE    |\n  +-+-+-+------------------------+\n  |1|0|0| HANDSHAKE OUTPUT       |\n  +-+-+-+------------------------+\n  |1|0|1| PULSE OUTPUT           |\n  +-+-+-+------------------------+\n  |1|1|0| LOW OUTPUT             |\n  +-+-+-+------------------------+\n  |1|1|1| HIGH OUTPUT            |\n  +-+-+-+------------------------+\n</pre>\n</html>");

        jTextField106.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField106.setText("0");
        jTextField106.setToolTipText("<html>\n<PRE>\n    +- CA1 INTERRUPT CONTROL\n+--------------------------+\n| 0 = NEGATIVE ACTIVE EDGE |\n| 1 = POSITIVE ACTIVE EDGE |\n+--------------------------+\n</pre>\n</html>");

        jLabel48.setText("CA1 IRQ Control");
        jLabel48.setToolTipText("<html>\n<PRE>\n    +- CA1 INTERRUPT CONTROL\n+--------------------------+\n| 0 = NEGATIVE ACTIVE EDGE |\n| 1 = POSITIVE ACTIVE EDGE |\n+--------------------------+\n</pre>\n</html>");

        jLabel50.setText("CA2 IRQ Control");
        jLabel50.setToolTipText("<html>\n<pre>\n +---- CA2 INTERRUPT CONTROL     \n  +-+-+-+------------------------+\n  |3|2|1| OPERATION              |\n  +-+-+-+------------------------+\n  |0|0|0| INPUT NEG. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|0|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT NEGATIVE EDGE    |\n  +-+-+-+------------------------+\n  |0|1|0| INPUT POS. ACTIVE EDGE |\n  +-+-+-+------------------------+\n  |0|1|1| INDEPENDENT INTERRUPT  |\n  | | | | INPUT POSITIVE EDGE    |\n  +-+-+-+------------------------+\n  |1|0|0| HANDSHAKE OUTPUT       |\n  +-+-+-+------------------------+\n  |1|0|1| PULSE OUTPUT           |\n  +-+-+-+------------------------+\n  |1|1|0| LOW OUTPUT             |\n  +-+-+-+------------------------+\n  |1|1|1| HIGH OUTPUT            |\n  +-+-+-+------------------------+\n</pre>\n</html>");

        jLabel51.setText("CB2 Control");
        jLabel51.setToolTipText("<html>\n<pre>\n         CB2 CONTROL -----+      \n+-+-+-+------------------------+ \n|7|6|5| OPERATION              | \n+-+-+-+------------------------+ \n|0|0|0| INPUT NEG. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|0|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT NEGATIVE EDGE    | \n+-+-+-+------------------------+ \n|0|1|0| INPUT POS. ACTIVE EDGE | \n+-+-+-+------------------------+ \n|0|1|1| INDEPENDENT INTERRUPT  | \n| | | | INPUT POSITIVE EDGE    | \n+-+-+-+------------------------+ \n|1|0|0| HANDSHAKE OUTPUT       | \n+-+-+-+------------------------+ \n|1|0|1| PULSE OUTPUT           | \n+-+-+-+------------------------+ \n|1|1|0| LOW OUTPUT             | \n+-+-+-+------------------------+ \n|1|1|1| HIGH OUTPUT            | \n+-+-+-+------------------------+ \n\n</pre>\n</html>");

        jLabel52.setText("CB1 IRQ Control");
        jLabel52.setToolTipText("<html>\n<pre>\n    CB1 INTERRUPT CONTROL ---\n+--------------------------+ \n| 0 = NEGATIVE ACTIVE EDGE | \n| 1 = POSITIVE ACTIVE EDGE | \n+--------------------------+ \n</pre> </html> ");

        jLabel69.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel69.setText("12");

        javax.swing.GroupLayout jPanel13Layout = new javax.swing.GroupLayout(jPanel13);
        jPanel13.setLayout(jPanel13Layout);
        jPanel13Layout.setHorizontalGroup(
            jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel13Layout.createSequentialGroup()
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel13Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addComponent(jLabel69)
                        .addGap(8, 8, 8)
                        .addComponent(jLabel47, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel13Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel24, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(3, 3, 3)
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel13Layout.createSequentialGroup()
                        .addComponent(jTextField99, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField100, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField101, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel51))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel52)
                    .addComponent(jTextField102, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel13Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addComponent(jTextField103, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField104, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField105, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel13Layout.createSequentialGroup()
                        .addGap(12, 12, 12)
                        .addComponent(jLabel50)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel48)
                    .addComponent(jTextField106, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel13Layout.setVerticalGroup(
            jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel13Layout.createSequentialGroup()
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel47)
                    .addComponent(jTextField99, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField100, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField101, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField102, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField103, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField104, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField105, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField106, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel69, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(7, 7, 7)
                .addGroup(jPanel13Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel48)
                    .addComponent(jLabel50)
                    .addComponent(jLabel51)
                    .addComponent(jLabel52)
                    .addComponent(jLabel24)))
        );

        jPanel14.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel49.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel49.setText("IER Interrupt Enable Register");
        jLabel49.setToolTipText("<html>\n<pre>\n<html>\n<pre>\n+-+-+-+-+-+-+-+-+\n|7|6|5|4|3|2|1|0|             SET BY                    CLEARED BY\n+-+-+-+-+-+-+-+-+    +-----------------------+------------------------------+\n | | | | | | | +--CA2| CA2 ACTIVE EDGE       | READ OR WRITE REG 1 (ORA)*   |\n | | | | | | |       +-----------------------+------------------------------+\n | | | | | | +--CA1--| CA1 ACTIVE EDGE       | READ OR WRITE REG 1 (ORA)    |\n | | | | | |         +-----------------------+------------------------------+\n | | | | | +SHIFT REG| COMPLETE 8 SHIFTS     | READ OR WRITE SHIFT REG      |\n | | | | |           +-----------------------+------------------------------+\n | | | | +-CB2-------| CB2 ACTIVE EDGE       | READ OR WRITE ORB*           |\n | | | |             +-----------------------+------------------------------+\n | | | +-CB1---------| CB1 ACTIVE EDGE       | READ OR WRITE ORB            |\n | | |               +-----------------------+------------------------------+\n | | +-TIMER 2-------| TIME-OUT OF T2        | READ T2 LOW OR WRITE T2 HIGH |\n | |                 +-----------------------+------------------------------+\n | +-TIMER 1---------| TIME-OUT OF T1        | READ T1 LOW OR WRITE T1 HIGH |\n |                   +-----------------------+------------------------------+\n +-IRQ---------------| ANY ENABLED INTERRUPT | CLEAR ALL INTERRUPTS         |\n                     +-----------------------+------------------------------+\n</pre>\n</html>\n</pre>\n<(/html>");

        jLabel53.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel53.setText("$ff");

        jTextField107.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField107.setText("0");

        jTextField108.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField108.setText("0");

        jTextField109.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField109.setText("0");

        jTextField110.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField110.setText("0");

        jTextField111.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField111.setText("0");

        jTextField112.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField112.setText("0");

        jTextField113.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField113.setText("0");

        jTextField114.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField114.setText("0");

        jLabel71.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel71.setText("14");

        javax.swing.GroupLayout jPanel14Layout = new javax.swing.GroupLayout(jPanel14);
        jPanel14.setLayout(jPanel14Layout);
        jPanel14Layout.setHorizontalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addComponent(jLabel71)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel53, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3)
                        .addComponent(jTextField107, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField108, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField109, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField110, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField111, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField112, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField113, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField114, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel14Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel49, javax.swing.GroupLayout.PREFERRED_SIZE, 211, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel14Layout.setVerticalGroup(
            jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel14Layout.createSequentialGroup()
                .addGroup(jPanel14Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel53)
                    .addComponent(jTextField107, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField108, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField109, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField110, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField111, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField112, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField113, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField114, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel71, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addComponent(jLabel49))
        );

        jPanel15.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel54.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel54.setText("IFR Interrupt Flag Register");
        jLabel54.setToolTipText("<html>\n<pre>\n+-+-+-+-+-+-+-+-+\n|7|6|5|4|3|2|1|0|             SET BY                    CLEARED BY\n+-+-+-+-+-+-+-+-+    +-----------------------+------------------------------+\n | | | | | | | +--CA2| CA2 ACTIVE EDGE       | READ OR WRITE REG 1 (ORA)*   |\n | | | | | | |       +-----------------------+------------------------------+\n | | | | | | +--CA1--| CA1 ACTIVE EDGE       | READ OR WRITE REG 1 (ORA)    |\n | | | | | |         +-----------------------+------------------------------+\n | | | | | +SHIFT REG| COMPLETE 8 SHIFTS     | READ OR WRITE SHIFT REG      |\n | | | | |           +-----------------------+------------------------------+\n | | | | +-CB2-------| CB2 ACTIVE EDGE       | READ OR WRITE ORB*           |\n | | | |             +-----------------------+------------------------------+\n | | | +-CB1---------| CB1 ACTIVE EDGE       | READ OR WRITE ORB            |\n | | |               +-----------------------+------------------------------+\n | | +-TIMER 2-------| TIME-OUT OF T2        | READ T2 LOW OR WRITE T2 HIGH |\n | |                 +-----------------------+------------------------------+\n | +-TIMER 1---------| TIME-OUT OF T1        | READ T1 LOW OR WRITE T1 HIGH |\n |                   +-----------------------+------------------------------+\n +-IRQ---------------| ANY ENABLED INTERRUPT | CLEAR ALL INTERRUPTS         |\n                     +-----------------------+------------------------------+\n</pre>\n</html>");

        jLabel55.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel55.setText("$ff");

        jTextField115.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField115.setText("0");

        jTextField116.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField116.setText("0");

        jTextField117.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField117.setText("0");

        jTextField118.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField118.setText("0");

        jTextField119.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField119.setText("0");

        jTextField120.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField120.setText("0");

        jTextField121.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField121.setText("0");

        jTextField122.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField122.setText("0");

        jLabel70.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel70.setText("13");

        javax.swing.GroupLayout jPanel15Layout = new javax.swing.GroupLayout(jPanel15);
        jPanel15.setLayout(jPanel15Layout);
        jPanel15Layout.setHorizontalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel15Layout.createSequentialGroup()
                .addGap(4, 4, 4)
                .addComponent(jLabel70)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel55, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(3, 3, 3)
                .addComponent(jTextField115, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField116, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField117, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField118, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField119, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField120, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField121, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextField122, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(24, Short.MAX_VALUE))
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addGap(2, 2, 2)
                .addComponent(jLabel54, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel15Layout.setVerticalGroup(
            jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel15Layout.createSequentialGroup()
                .addGroup(jPanel15Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel55)
                    .addComponent(jTextField115, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField116, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField117, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField118, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField119, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField120, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField121, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField122, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel70, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addComponent(jLabel54))
        );

        jPanel16.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel10.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel10.setText("ORA / IRA (no handshake)");

        jLabel13.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel13.setText("$ff");

        jTextField123.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField123.setText("0");

        jTextField124.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField124.setText("0");

        jTextField125.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField125.setText("0");

        jTextField126.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField126.setText("0");

        jTextField127.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField127.setText("0");

        jTextField128.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField128.setText("0");

        jTextField129.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField129.setText("0");

        jTextField130.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField130.setText("0");

        jLabel72.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel72.setText("15");

        javax.swing.GroupLayout jPanel16Layout = new javax.swing.GroupLayout(jPanel16);
        jPanel16.setLayout(jPanel16Layout);
        jPanel16Layout.setHorizontalGroup(
            jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel16Layout.createSequentialGroup()
                .addGroup(jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel16Layout.createSequentialGroup()
                        .addGap(4, 4, 4)
                        .addComponent(jLabel72)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jLabel13, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(3, 3, 3)
                        .addComponent(jTextField123, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField124, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField125, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField126, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField127, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField128, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField129, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField130, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel16Layout.createSequentialGroup()
                        .addGap(2, 2, 2)
                        .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 276, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel16Layout.setVerticalGroup(
            jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel16Layout.createSequentialGroup()
                .addGroup(jPanel16Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel13)
                    .addComponent(jTextField123, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField124, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField125, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField126, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField127, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField128, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField129, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField130, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel72, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addComponent(jLabel10))
        );

        jPanel17.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel73.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel73.setText("CA1 ");

        jTextField131.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField131.setText("0");
        jTextField131.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jTextField131MousePressed(evt);
            }
        });

        jLabel81.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel81.setText("->PSG IO7");
        jLabel81.setToolTipText("Lightpen interrupt e.g. is recieved via this line!");

        javax.swing.GroupLayout jPanel17Layout = new javax.swing.GroupLayout(jPanel17);
        jPanel17.setLayout(jPanel17Layout);
        jPanel17Layout.setHorizontalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel17Layout.createSequentialGroup()
                .addGroup(jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel17Layout.createSequentialGroup()
                        .addComponent(jLabel73, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField131, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jLabel81, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel17Layout.setVerticalGroup(
            jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel17Layout.createSequentialGroup()
                .addGroup(jPanel17Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField131, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel73))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel81))
        );

        jPanel18.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel74.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel74.setText("CA2 ");
        jLabel74.setToolTipText("<html>\n<pre>\n    CA2 - ~ZERO     \n   Connected to the integrators that form part of the\n   vector drawing hardware. This line will cause them\n   to be zero'd (both X and Y) and has the effect of\n   bringing the beam back to the centre of the CRT. \n    As with RAMP is is an active low\n    signal. During any integration operation this line must be set to\n    the inactive state (HIGH).\n\n    When ACTIVE this line will cause the integrator output to be set to\n    0V which will be the centre of the screen. This line should be\n    ACTIVATED before any line drawing sequence to set the integrators to\n    a known value. The integrator output value is held by a small capacitor\n    and this will leak charge, basically the result is that over a period\n    of time the when the integrator in not in RAMP mode its output will\n    slowly fall to zero. So after drawing a sequence of vectors it is best\n    to zero the output to give a solid reference.\n</pre>\n</html>\n");

        jTextField132.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField132.setText("0");
        jTextField132.setToolTipText("<html>\n<pre>\n    CA2 - ~ZERO     \n   Connected to the integrators that form part of the\n   vector drawing hardware. This line will cause them\n   to be zero'd (both X and Y) and has the effect of\n   bringing the beam back to the centre of the CRT. \n    As with RAMP is is an active low\n    signal. During any integration operation this line must be set to\n    the inactive state (HIGH).\n\n    When ACTIVE this line will cause the integrator output to be set to\n    0V which will be the centre of the screen. This line should be\n    ACTIVATED before any line drawing sequence to set the integrators to\n    a known value. The integrator output value is held by a small capacitor\n    and this will leak charge, basically the result is that over a period\n    of time the when the integrator in not in RAMP mode its output will\n    slowly fall to zero. So after drawing a sequence of vectors it is best\n    to zero the output to give a solid reference.\n</pre>\n</html>\n");

        jLabel78.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel78.setText("~ZERO");
        jLabel78.setToolTipText("<html>\n<pre>\n    CA2 - ~ZERO     \n   Connected to the integrators that form part of the\n   vector drawing hardware. This line will cause them\n   to be zero'd (both X and Y) and has the effect of\n   bringing the beam back to the centre of the CRT. \n    As with RAMP is is an active low\n    signal. During any integration operation this line must be set to\n    the inactive state (HIGH).\n\n    When ACTIVE this line will cause the integrator output to be set to\n    0V which will be the centre of the screen. This line should be\n    ACTIVATED before any line drawing sequence to set the integrators to\n    a known value. The integrator output value is held by a small capacitor\n    and this will leak charge, basically the result is that over a period\n    of time the when the integrator in not in RAMP mode its output will\n    slowly fall to zero. So after drawing a sequence of vectors it is best\n    to zero the output to give a solid reference.\n</pre>\n</html>\n");

        javax.swing.GroupLayout jPanel18Layout = new javax.swing.GroupLayout(jPanel18);
        jPanel18.setLayout(jPanel18Layout);
        jPanel18Layout.setHorizontalGroup(
            jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel18Layout.createSequentialGroup()
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel18Layout.createSequentialGroup()
                        .addComponent(jLabel74, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField132, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel78, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel18Layout.setVerticalGroup(
            jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel18Layout.createSequentialGroup()
                .addGroup(jPanel18Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField132, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel74))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel78))
        );

        jPanel19.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel75.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel75.setText("CB2 ");
        jLabel75.setToolTipText("<html>\n<pre>\n    CB2 - ~BLANK    This Active LOW signal is the BEAM ON/OFF signal\n                    to the Vector drawing hardware, and is used to hide\n                    the beam when it is being positioned for re-draw.\n                    See Vector hardware section for more info.\n</pre>\n</html>\n");

        jTextField133.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField133.setText("0");
        jTextField133.setToolTipText("<html>\n<pre>\n    CB2 - ~BLANK    This Active LOW signal is the BEAM ON/OFF signal\n                    to the Vector drawing hardware, and is used to hide\n                    the beam when it is being positioned for re-draw.\n                    See Vector hardware section for more info.\n</pre>\n</html>\n");

        jLabel79.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel79.setText("~BLANK");
        jLabel79.setToolTipText("<html>\n<pre>\n    CB2 - ~BLANK    This Active LOW signal is the BEAM ON/OFF signal\n                    to the Vector drawing hardware, and is used to hide\n                    the beam when it is being positioned for re-draw.\n                    See Vector hardware section for more info.\n</pre>\n</html>\n");

        javax.swing.GroupLayout jPanel19Layout = new javax.swing.GroupLayout(jPanel19);
        jPanel19.setLayout(jPanel19Layout);
        jPanel19Layout.setHorizontalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel19Layout.createSequentialGroup()
                        .addComponent(jLabel75, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField133, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel79, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel19Layout.setVerticalGroup(
            jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel19Layout.createSequentialGroup()
                .addGroup(jPanel19Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField133, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel75))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel79))
        );

        jPanel20.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel76.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel76.setText("CB1 ");

        jTextField134.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField134.setText("?");

        jLabel80.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel80.setText("not used!");

        javax.swing.GroupLayout jPanel20Layout = new javax.swing.GroupLayout(jPanel20);
        jPanel20.setLayout(jPanel20Layout);
        jPanel20Layout.setHorizontalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel20Layout.createSequentialGroup()
                        .addComponent(jLabel76, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField134, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jLabel80, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel20Layout.setVerticalGroup(
            jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel20Layout.createSequentialGroup()
                .addGroup(jPanel20Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField134, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel76))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel80))
        );

        jPanel21.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel77.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel77.setText("IRQ");

        jTextField135.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jTextField135.setText("?");

        javax.swing.GroupLayout jPanel21Layout = new javax.swing.GroupLayout(jPanel21);
        jPanel21.setLayout(jPanel21Layout);
        jPanel21Layout.setHorizontalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel21Layout.createSequentialGroup()
                .addComponent(jLabel77, javax.swing.GroupLayout.PREFERRED_SIZE, 37, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(2, 2, 2)
                .addComponent(jTextField135, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel21Layout.setVerticalGroup(
            jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel21Layout.createSequentialGroup()
                .addGroup(jPanel21Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField135, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel77))
                .addGap(20, 20, 20))
        );

        jToggleButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton3.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton3.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton3.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel21)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jPanel17, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jPanel18, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jPanel20, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGap(6, 6, 6)
                        .addComponent(jPanel19, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGap(18, 18, 18)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextFieldiput, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldoutput, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jPanel21, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jPanel15, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel14, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jPanel13, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jPanel10, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel8, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel6, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(15, 15, 15)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jPanel9, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel7, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jPanel11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                    .addComponent(jPanel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(122, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jToggleButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(7, 7, 7)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jPanel7, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel13, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jPanel15, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jPanel14, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jPanel17, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel18, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel20, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel19, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jPanel21, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(9, 9, 9)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel21)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jTextFieldiput, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextFieldoutput, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(117, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jToggleButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton3ActionPerformed
        updateEnabled = jToggleButton3.isSelected();
    }//GEN-LAST:event_jToggleButton3ActionPerformed

    private void jMenuItemPB6GoLowActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemPB6GoLowActionPerformed
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = 0;
        bp.targetBank = 0;
        bp.targetType = Breakpoint.BP_TARGET_CARTRIDGE;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CARTRIDGE_PB6;
        bp.type = Breakpoint.BP_BITCOMPARE | Breakpoint.BP_MULTI ;
        bp.name = "pb6 go low";
        bp.compareValue = 0;
        vecxPanel.breakpointSet(bp);
        popUpName = "";
    }//GEN-LAST:event_jMenuItemPB6GoLowActionPerformed

    private void jMenuItemPB6GoHighActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemPB6GoHighActionPerformed
//        if (popUpName.contains("pb6"))

        Breakpoint bp = new Breakpoint();
        bp.targetAddress = 0;
        bp.targetBank = 0;
        bp.targetType = Breakpoint.BP_TARGET_CARTRIDGE;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CARTRIDGE_PB6;
        bp.type = Breakpoint.BP_BITCOMPARE | Breakpoint.BP_MULTI ;
        bp.name = "pb6 go high";
        bp.compareValue = 1;
        vecxPanel.breakpointSet(bp);
        popUpName = "";
    }//GEN-LAST:event_jMenuItemPB6GoHighActionPerformed

    private void jTextField2MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextField2MousePressed
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            JTextField tf =(JTextField) evt.getSource();
            popUpName = tf.getName();
            jPopupMenuPB6.show(tf, evt.getX()-20,evt.getY()-20);
        }        
    }//GEN-LAST:event_jTextField2MousePressed

    private void jMenuItemPB6ChangeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemPB6ChangeActionPerformed

        Breakpoint bp = new Breakpoint();
        bp.targetAddress = 0;
        bp.targetBank = 0;
        bp.targetType = Breakpoint.BP_TARGET_CARTRIDGE;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_CARTRIDGE_PB6;
        bp.type = Breakpoint.BP_WRITE | Breakpoint.BP_MULTI ;
        bp.name = "pb6 changed";
        bp.compareValue = 1;
        vecxPanel.breakpointSet(bp);
        popUpName = "";
    }//GEN-LAST:event_jMenuItemPB6ChangeActionPerformed

    private void jTextField131MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jTextField131MousePressed
        if (evt.getButton() == MouseEvent.BUTTON3)
        {
            JTextField tf =(JTextField) evt.getSource();
            popUpName = tf.getName();
            jPopupMenuCA1.show(tf, evt.getX()-20,evt.getY()-20);
        }        
    }//GEN-LAST:event_jTextField131MousePressed

    private void jMenuItemCA1GoLowActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCA1GoLowActionPerformed
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = 0;
        bp.targetBank = 0;
        bp.targetType = Breakpoint.BP_TARGET_VIA;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_VIA_CA1;
        bp.type = Breakpoint.BP_BITCOMPARE | Breakpoint.BP_MULTI ;
        bp.name = "ca1 go low";
        bp.compareValue = 0;
        vecxPanel.breakpointSet(bp);
        popUpName = "";
    }//GEN-LAST:event_jMenuItemCA1GoLowActionPerformed

    private void jMenuItemCA1GoHighActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCA1GoHighActionPerformed
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = 0;
        bp.targetBank = 0;
        bp.targetType = Breakpoint.BP_TARGET_VIA;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_VIA_CA1;
        bp.type = Breakpoint.BP_BITCOMPARE | Breakpoint.BP_MULTI ;
        bp.name = "ca1 go high";
        bp.compareValue = 1;
        vecxPanel.breakpointSet(bp);
        popUpName = "";
    }//GEN-LAST:event_jMenuItemCA1GoHighActionPerformed

    private void jMenuItemCA1ChangeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenuItemCA1ChangeActionPerformed
        Breakpoint bp = new Breakpoint();
        bp.targetAddress = 0;
        bp.targetBank = 0;
        bp.targetType = Breakpoint.BP_TARGET_VIA;
        bp.targetSubType = Breakpoint.BP_SUBTARGET_VIA_CA1;
        bp.type = Breakpoint.BP_WRITE | Breakpoint.BP_MULTI ;
        bp.name = "ca1 change";
        bp.compareValue = 0;
        vecxPanel.breakpointSet(bp);
        popUpName = "";
    }//GEN-LAST:event_jMenuItemCA1ChangeActionPerformed
    String popUpName = "";

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel21;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel23;
    private javax.swing.JLabel jLabel24;
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
    private javax.swing.JLabel jLabel9;
    private javax.swing.JMenuItem jMenuItemCA1Change;
    private javax.swing.JMenuItem jMenuItemCA1GoHigh;
    private javax.swing.JMenuItem jMenuItemCA1GoLow;
    private javax.swing.JMenuItem jMenuItemPB6Change;
    private javax.swing.JMenuItem jMenuItemPB6GoHigh;
    private javax.swing.JMenuItem jMenuItemPB6GoLow;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel10;
    private javax.swing.JPanel jPanel11;
    private javax.swing.JPanel jPanel12;
    private javax.swing.JPanel jPanel13;
    private javax.swing.JPanel jPanel14;
    private javax.swing.JPanel jPanel15;
    private javax.swing.JPanel jPanel16;
    private javax.swing.JPanel jPanel17;
    private javax.swing.JPanel jPanel18;
    private javax.swing.JPanel jPanel19;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel20;
    private javax.swing.JPanel jPanel21;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JPanel jPanel9;
    private javax.swing.JPopupMenu jPopupMenuCA1;
    private javax.swing.JPopupMenu jPopupMenuPB6;
    private javax.swing.JTextField jTextField1;
    private javax.swing.JTextField jTextField10;
    private javax.swing.JTextField jTextField100;
    private javax.swing.JTextField jTextField101;
    private javax.swing.JTextField jTextField102;
    private javax.swing.JTextField jTextField103;
    private javax.swing.JTextField jTextField104;
    private javax.swing.JTextField jTextField105;
    private javax.swing.JTextField jTextField106;
    private javax.swing.JTextField jTextField107;
    private javax.swing.JTextField jTextField108;
    private javax.swing.JTextField jTextField109;
    private javax.swing.JTextField jTextField11;
    private javax.swing.JTextField jTextField110;
    private javax.swing.JTextField jTextField111;
    private javax.swing.JTextField jTextField112;
    private javax.swing.JTextField jTextField113;
    private javax.swing.JTextField jTextField114;
    private javax.swing.JTextField jTextField115;
    private javax.swing.JTextField jTextField116;
    private javax.swing.JTextField jTextField117;
    private javax.swing.JTextField jTextField118;
    private javax.swing.JTextField jTextField119;
    private javax.swing.JTextField jTextField12;
    private javax.swing.JTextField jTextField120;
    private javax.swing.JTextField jTextField121;
    private javax.swing.JTextField jTextField122;
    private javax.swing.JTextField jTextField123;
    private javax.swing.JTextField jTextField124;
    private javax.swing.JTextField jTextField125;
    private javax.swing.JTextField jTextField126;
    private javax.swing.JTextField jTextField127;
    private javax.swing.JTextField jTextField128;
    private javax.swing.JTextField jTextField129;
    private javax.swing.JTextField jTextField13;
    private javax.swing.JTextField jTextField130;
    private javax.swing.JTextField jTextField131;
    private javax.swing.JTextField jTextField132;
    private javax.swing.JTextField jTextField133;
    private javax.swing.JTextField jTextField134;
    private javax.swing.JTextField jTextField135;
    private javax.swing.JTextField jTextField14;
    private javax.swing.JTextField jTextField15;
    private javax.swing.JTextField jTextField16;
    private javax.swing.JTextField jTextField17;
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
    private javax.swing.JTextField jTextField52;
    private javax.swing.JTextField jTextField53;
    private javax.swing.JTextField jTextField54;
    private javax.swing.JTextField jTextField55;
    private javax.swing.JTextField jTextField56;
    private javax.swing.JTextField jTextField57;
    private javax.swing.JTextField jTextField58;
    private javax.swing.JTextField jTextField59;
    private javax.swing.JTextField jTextField6;
    private javax.swing.JTextField jTextField60;
    private javax.swing.JTextField jTextField61;
    private javax.swing.JTextField jTextField62;
    private javax.swing.JTextField jTextField63;
    private javax.swing.JTextField jTextField64;
    private javax.swing.JTextField jTextField65;
    private javax.swing.JTextField jTextField66;
    private javax.swing.JTextField jTextField67;
    private javax.swing.JTextField jTextField68;
    private javax.swing.JTextField jTextField69;
    private javax.swing.JTextField jTextField7;
    private javax.swing.JTextField jTextField70;
    private javax.swing.JTextField jTextField71;
    private javax.swing.JTextField jTextField72;
    private javax.swing.JTextField jTextField73;
    private javax.swing.JTextField jTextField74;
    private javax.swing.JTextField jTextField75;
    private javax.swing.JTextField jTextField76;
    private javax.swing.JTextField jTextField77;
    private javax.swing.JTextField jTextField78;
    private javax.swing.JTextField jTextField79;
    private javax.swing.JTextField jTextField8;
    private javax.swing.JTextField jTextField80;
    private javax.swing.JTextField jTextField81;
    private javax.swing.JTextField jTextField82;
    private javax.swing.JTextField jTextField83;
    private javax.swing.JTextField jTextField84;
    private javax.swing.JTextField jTextField85;
    private javax.swing.JTextField jTextField86;
    private javax.swing.JTextField jTextField87;
    private javax.swing.JTextField jTextField88;
    private javax.swing.JTextField jTextField89;
    private javax.swing.JTextField jTextField9;
    private javax.swing.JTextField jTextField90;
    private javax.swing.JTextField jTextField91;
    private javax.swing.JTextField jTextField92;
    private javax.swing.JTextField jTextField93;
    private javax.swing.JTextField jTextField94;
    private javax.swing.JTextField jTextField95;
    private javax.swing.JTextField jTextField96;
    private javax.swing.JTextField jTextField97;
    private javax.swing.JTextField jTextField98;
    private javax.swing.JTextField jTextField99;
    private javax.swing.JTextField jTextFieldiput;
    private javax.swing.JTextField jTextFieldoutput;
    private javax.swing.JToggleButton jToggleButton3;
    // End of variables declaration//GEN-END:variables

    public static String SID = "viai";
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
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
