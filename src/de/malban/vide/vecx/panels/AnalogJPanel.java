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
import de.malban.vide.vecx.E8910State;
import de.malban.vide.vecx.Updatable;
import de.malban.vide.vecx.VecX;
import de.malban.vide.vecx.VecXState;
import de.malban.vide.vecx.VecXStatics;
import de.malban.vide.vecx.devices.VectrexJoyport;
import java.awt.Color;
import java.io.Serializable;

/**
 *
 * @author malban
 */
public class AnalogJPanel extends javax.swing.JPanel implements
        Windowable, Stateable, Updatable{
    public boolean isLoadSettings() { return true; }
    private CSAView mParent = null;
    private javax.swing.JMenuItem mParentMenuItem = null;
    private int mClassSetting=0;
    private VecXPanel vecxPanel = null; // needed for vectrex memory access
    public static String SID = "ani";
    public String getID()
    {
        return SID;
    }
    public Serializable getAdditionalStateinfo(){return null;}
    public void setAdditionalStateinfo(Serializable ser){}
    
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
        if (vecxPanel != null) vecxPanel.resetAni();
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
        mParentMenuItem.setText("Analog Stuff");
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
    public AnalogJPanel() {
        initComponents();
    }


    
    int ramp;
    int blank;
    int zero = 0;
    int x_sh= 0;
    int y_sh;
    int z_sh;
    int r_sh;
    int s_sh;
    int x_int;
    int y_int;
    int dac;
    
    int joy0;
    int joy1;
    int joy2;
    int joy3;
    int jsh;
    int buttons=0;

    private void update()
    {        
        if (vecxPanel==null) return;
        VecXState state = vecxPanel.getVecXState();
        jLabel11.setText( ""+(state.sig_ramp.intValue!=0?"1":"0") );
        if (state.sig_ramp.intValue != ramp) jLabel11.setForeground(Color.red);
        else jLabel11.setForeground(Color.black);
        ramp = state.sig_ramp.intValue;
        if (ramp == 0)
            jLabel1.setBackground(Color.orange);
        else
            jLabel1.setBackground(jLabel34.getBackground());

        jLabel12.setText( ""+(state.sig_zero.intValue!=0?"1":"0") );
        if (state.sig_zero.intValue != zero) jLabel12.setForeground(Color.red);
        else jLabel12.setForeground(Color.black);
        zero = state.sig_zero.intValue;
        if (zero == 0)
            jLabel2.setBackground(Color.orange);
        else
            jLabel2.setBackground(jLabel34.getBackground());

        jLabel15.setText( ""+(state.sig_blank.intValue!=0?"1":"0") );
        if (state.sig_blank.intValue != blank) jLabel15.setForeground(Color.red);
        else jLabel15.setForeground(Color.black);
        blank = state.sig_blank.intValue;
        if (blank == 0)
            jLabel3.setBackground(Color.orange);
        else
            jLabel3.setBackground(jLabel34.getBackground());
            
        
        jLabel14.setText("$"+String.format("%02X", state.alg_DAC.intValue&0x0ff));
        if (state.alg_DAC.intValue != dac) jLabel14.setForeground(Color.red);
        else jLabel14.setForeground(Color.black);
        dac = state.alg_DAC.intValue;
        jLabel14.setToolTipText("decimal: "+dac);
        
        jLabel13.setText("$"+String.format("%02X", state.alg_xsh.intValue&0x0ff));
        if (state.alg_xsh.intValue != x_sh) jLabel13.setForeground(Color.red);
        else jLabel13.setForeground(Color.black);
        x_sh = state.alg_xsh.intValue;
        jLabel13.setToolTipText("decimal: "+x_sh);
        
        jLabel16.setText("$"+String.format("%02X", state.alg_ysh.intValue&0x0ff));
        if (state.alg_ysh.intValue != y_sh) jLabel16.setForeground(Color.red);
        else jLabel16.setForeground(Color.black);
        y_sh = state.alg_ysh.intValue;
        jLabel16.setToolTipText("decimal: "+y_sh);
        
        jLabel17.setText("$"+String.format("%02X", state.alg_zsh.intValue&0x0ff));
        if (state.alg_zsh.intValue != z_sh) jLabel17.setForeground(Color.red);
        else jLabel17.setForeground(Color.black);
        z_sh = state.alg_zsh.intValue;
        jLabel17.setToolTipText("decimal: "+z_sh);
        
        jLabel18.setText("$"+String.format("%02X", state.alg_ssh.intValue&0x0ff));
        if (state.alg_ssh.intValue != s_sh) jLabel18.setForeground(Color.red);
        else jLabel18.setForeground(Color.black);
        s_sh = state.alg_ssh.intValue;
        jLabel18.setToolTipText("decimal: "+s_sh);
        
        jLabel19.setText("$"+String.format("%02X", state.alg_rsh.intValue&0x0ff));
        if (state.alg_rsh.intValue != r_sh) jLabel19.setForeground(Color.red);
        else jLabel19.setForeground(Color.black);
        r_sh = state.alg_rsh.intValue;
        jLabel19.setToolTipText("decimal: "+r_sh);
        
        if (state instanceof VecX)
        {
            VectrexJoyport[] joyport = ((VecX)state).joyport;
            jLabel24.setText("$"+String.format("%02X", joyport[0].getHorizontal()&0x0ff));
            if (joyport[0].getHorizontal() != joy0) jLabel24.setForeground(Color.red);
            else jLabel24.setForeground(Color.black);
            joy0 = joyport[0].getHorizontal();
            jLabel24.setToolTipText("decimal: "+joyport[0].getHorizontal());

            jLabel26.setText("$"+String.format("%02X", joyport[0].getVertical()&0x0ff));
            if (joyport[0].getVertical() != joy1) jLabel26.setForeground(Color.red);
            else jLabel26.setForeground(Color.black);
            joy1 = joyport[0].getVertical();
            jLabel26.setToolTipText("decimal: "+joyport[0].getVertical());

            jLabel29.setText("$"+String.format("%02X", joyport[1].getHorizontal()&0x0ff));
            if (joyport[1].getHorizontal() != joy2) jLabel29.setForeground(Color.red);
            else jLabel29.setForeground(Color.black);
            joy2 = joyport[1].getHorizontal();
            jLabel29.setToolTipText("decimal: "+joyport[1].getHorizontal()+"");

            jLabel30.setText("$"+String.format("%02X", joyport[1].getVertical()&0x0ff));
            if (joyport[1].getVertical() != joy3) jLabel30.setForeground(Color.red);
            else jLabel30.setForeground(Color.black);
            joy3 = joyport[1].getVertical();
            jLabel30.setToolTipText("decimal: "+joyport[1].getVertical()+"");
            
            jTextField110.setText(""+((  (!joyport[0].isButton1(false))?"1":"0")) );
            jTextField109.setText(""+((  (!joyport[0].isButton2(false))?"1":"0")) );
            jTextField107.setText(""+((  (!joyport[0].isButton3(false))?"1":"0")) );
            jTextField108.setText(""+((  (!joyport[0].isButton4(false))?"1":"0")) );
            
            jTextField114.setText(""+((  (!joyport[1].isButton1(false))?"1":"0")) );
            jTextField113.setText(""+((  (!joyport[1].isButton2(false))?"1":"0")) );
            jTextField112.setText(""+((  (!joyport[1].isButton3(false))?"1":"0")) );
            jTextField111.setText(""+((  (!joyport[1].isButton4(false))?"1":"0")) );
            
            if ((joyport[0].isButton1(false)) != ((buttons&0x01)==0x01)) jTextField110.setForeground(Color.red); else jTextField110.setForeground(Color.black);
            if ((joyport[0].isButton2(false)) != ((buttons&0x02)==0x02)) jTextField109.setForeground(Color.red); else jTextField109.setForeground(Color.black);
            if ((joyport[0].isButton3(false)) != ((buttons&0x04)==0x04)) jTextField107.setForeground(Color.red); else jTextField107.setForeground(Color.black);
            if ((joyport[0].isButton4(false)) != ((buttons&0x08)==0x08)) jTextField108.setForeground(Color.red); else jTextField108.setForeground(Color.black);
            if ((joyport[1].isButton1(false)) != ((buttons&0x10)==0x10)) jTextField114.setForeground(Color.red); else jTextField114.setForeground(Color.black);
            if ((joyport[1].isButton2(false)) != ((buttons&0x20)==0x20)) jTextField113.setForeground(Color.red); else jTextField113.setForeground(Color.black);
            if ((joyport[1].isButton3(false)) != ((buttons&0x40)==0x40)) jTextField112.setForeground(Color.red); else jTextField112.setForeground(Color.black);
            if ((joyport[1].isButton4(false)) != ((buttons&0x80)==0x80)) jTextField111.setForeground(Color.red); else jTextField111.setForeground(Color.black);

            buttons = 0;
            buttons += (joyport[0].isButton1(false))?0x01:0;
            buttons += (joyport[0].isButton2(false))?0x02:0;
            buttons += (joyport[0].isButton3(false))?0x04:0;
            buttons += (joyport[0].isButton4(false))?0x08:0;
            buttons += (joyport[1].isButton1(false))?0x10:0;
            buttons += (joyport[1].isButton2(false))?0x20:0;
            buttons += (joyport[1].isButton3(false))?0x40:0;
            buttons += (joyport[1].isButton4(false))?0x80:0;
            
/*        
        E8910State e8910State = vecxPanel.getE8910State();
        jTextField110.setText(""+(((e8910State.snd_regs[14]&0x01)==0)?"1":"0"));
        jTextField109.setText(""+(((e8910State.snd_regs[14]&0x02)==0)?"1":"0"));
        jTextField107.setText(""+(((e8910State.snd_regs[14]&0x04)==0)?"1":"0"));
        jTextField108.setText(""+(((e8910State.snd_regs[14]&0x08)==0)?"1":"0"));
        if ((e8910State.snd_regs[14]&0x01) != (buttons&0x01)) jTextField110.setForeground(Color.red); else jTextField110.setForeground(Color.black);
        if ((e8910State.snd_regs[14]&0x02) != (buttons&0x02)) jTextField109.setForeground(Color.red); else jTextField109.setForeground(Color.black);
        if ((e8910State.snd_regs[14]&0x04) != (buttons&0x04)) jTextField107.setForeground(Color.red); else jTextField107.setForeground(Color.black);
        if ((e8910State.snd_regs[14]&0x08) != (buttons&0x08)) jTextField108.setForeground(Color.red); else jTextField108.setForeground(Color.black);
        buttons = e8910State.snd_regs[14];
*/            
            
        }
        else
        {
            
        }
        
        
        jLabel32.setText("$"+String.format("%02X", state.alg_jsh&0x0ff));
        if (state.alg_jsh != jsh) jLabel32.setForeground(Color.red);
        else jLabel32.setForeground(Color.black);
        jsh = state.alg_jsh;
        jLabel32.setToolTipText("decimal: "+state.alg_jsh);
        
        
        

        int calc_x = (int)state.alg_curr_x-VecXStatics.ALG_MAX_X/2;
        boolean neg = calc_x<0;
        int pos = Math.abs(calc_x)&0x0ffff;
        if (neg)
            jLabel20.setText("-$"+String.format("%04X", pos));
        else
            jLabel20.setText("$"+String.format("%04X", pos));
        if (calc_x != x_int) jLabel20.setForeground(Color.red);
        else jLabel20.setForeground(Color.black);
        x_int = calc_x;
        jLabel20.setToolTipText("decimal: "+x_int);
        /*
        boolean neg = state.alg_curr_x<0;
        int pos = Math.abs(state.alg_curr_x)&0x0ffff;
        if (neg)
            jLabel20.setText("-$"+String.format("%04X", pos));
        else
            jLabel20.setText("$"+String.format("%04X", pos));
        if (state.alg_curr_x != x_int) jLabel20.setForeground(Color.red);
        else jLabel20.setForeground(Color.black);
        x_int = state.alg_curr_x;
        jLabel20.setToolTipText("decimal: "+x_int);
        */
        
        int cacl_y = (int)state.alg_curr_y-VecXStatics.ALG_MAX_Y/2;
        neg = cacl_y<0;
        pos = Math.abs(cacl_y)&0x0ffff;
        if (neg)
            jLabel22.setText("-$"+String.format("%04X", pos));
        else
            jLabel22.setText("$"+String.format("%04X", pos));
        if (cacl_y != y_int) jLabel22.setForeground(Color.red);
        else jLabel22.setForeground(Color.black);
        y_int = cacl_y;
        jLabel22.setToolTipText("decimal: "+y_int);
        /*
        neg = state.alg_curr_y<0;
        pos = Math.abs(state.alg_curr_y)&0x0ffff;
        if (neg)
            jLabel22.setText("-$"+String.format("%04X", pos));
        else
            jLabel22.setText("$"+String.format("%04X", pos));
        if (state.alg_curr_y != y_int) jLabel22.setForeground(Color.red);
        else jLabel22.setForeground(Color.black);
        y_int = state.alg_curr_y;
        jLabel22.setToolTipText("decimal: "+y_int);
        */
        repaint();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel14 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jLabel19 = new javax.swing.JLabel();
        jLabel20 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jLabel22 = new javax.swing.JLabel();
        jLabel23 = new javax.swing.JLabel();
        jLabel24 = new javax.swing.JLabel();
        jLabel25 = new javax.swing.JLabel();
        jLabel26 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        jLabel28 = new javax.swing.JLabel();
        jLabel29 = new javax.swing.JLabel();
        jLabel30 = new javax.swing.JLabel();
        jLabel31 = new javax.swing.JLabel();
        jLabel32 = new javax.swing.JLabel();
        jLabel33 = new javax.swing.JLabel();
        jTextField107 = new javax.swing.JTextField();
        jTextField108 = new javax.swing.JTextField();
        jTextField109 = new javax.swing.JTextField();
        jTextField110 = new javax.swing.JTextField();
        jTextField111 = new javax.swing.JTextField();
        jTextField112 = new javax.swing.JTextField();
        jTextField113 = new javax.swing.JTextField();
        jTextField114 = new javax.swing.JTextField();
        jLabel34 = new javax.swing.JLabel();
        jToggleButton1 = new javax.swing.JToggleButton();

        setName("regi"); // NOI18N

        jLabel1.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel1.setText("~RAMP");
        jLabel1.setToolTipText("If 0 the integrators are integrating, if 1 not!");

        jLabel2.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel2.setText("~ZERO");
        jLabel2.setToolTipText("If 0 the integrators are grounded and kept to 0, no matter what, if one, integration is possible!");

        jLabel3.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel3.setText("~BLANK");
        jLabel3.setToolTipText("If 0 BLANK is active, meaning the color of the vector beam is allways OFF. If 1 the color of the beam is what is currently in Z-SH.");

        jLabel4.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel4.setText("DAC");

        jLabel5.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel5.setText("X-SH");
        jLabel5.setToolTipText("always = DAC, the value that is added to X-integrators\n");

        jLabel6.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel6.setText("Y-SH");
        jLabel6.setToolTipText("if MUX bits = 00, the value that is added to the y integrators");

        jLabel7.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel7.setText("Int X");

        jLabel8.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel8.setText("Z-SH");
        jLabel8.setToolTipText("if MUX bits = 10, Color of the vector beam. If bit 7 is set (0x80) than color is OFF.\n");

        jLabel9.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel9.setText("S-SH");
        jLabel9.setToolTipText("if MUX bits = 11, value that is put to the soundchip");

        jLabel10.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel10.setText("R-SH");
        jLabel10.setToolTipText("if MUX bits = 01");

        jLabel11.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel11.setText("0");
        jLabel11.setToolTipText("");

        jLabel12.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel12.setText("0");

        jLabel13.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel13.setText("$ff");
        jLabel13.setToolTipText("always = DAC");

        jLabel14.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel14.setText("$ff");

        jLabel15.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel15.setText("0");

        jLabel16.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel16.setText("$ff");
        jLabel16.setToolTipText("if MUX bits = 00");

        jLabel17.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel17.setText("$ff");
        jLabel17.setToolTipText("if MUX bits = 10");

        jLabel18.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel18.setText("$ff");
        jLabel18.setToolTipText("if MUX bits = 11");

        jLabel19.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel19.setText("$ff");
        jLabel19.setToolTipText("if MUX bits = 01, value that is used as offsets for the integrators");

        jLabel20.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel20.setText("$ffff");
        jLabel20.setToolTipText("Current X coordinate");

        jLabel21.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel21.setText("Int Y");

        jLabel22.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel22.setText("$ffff");
        jLabel22.setToolTipText("current y coordinate");

        jLabel23.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel23.setText("Joy0 X");
        jLabel23.setToolTipText("if MUX bits = 01");

        jLabel24.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel24.setText("$ff");
        jLabel24.setToolTipText("positive left, negative right(0x80 middle)");

        jLabel25.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel25.setText("Joy0 Y");
        jLabel25.setToolTipText("if MUX bits = 01");

        jLabel26.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel26.setText("$ff");
        jLabel26.setToolTipText("positive down, negative up (0x80 middle)");

        jLabel27.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel27.setText("Joy1 Y");
        jLabel27.setToolTipText("if MUX bits = 01");

        jLabel28.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel28.setText("Joy1 X");
        jLabel28.setToolTipText("if MUX bits = 01");

        jLabel29.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel29.setText("$ff");
        jLabel29.setToolTipText("positive left, negative right(0x80 middle)");

        jLabel30.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel30.setText("$ff");
        jLabel30.setToolTipText("positive down, negative up (0x80 middle)");

        jLabel31.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel31.setText("J-SH");
        jLabel31.setToolTipText("if MUX bits = 01");

        jLabel32.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel32.setText("$ff");
        jLabel32.setToolTipText("if MUX bits = 01, value that is used as offsets for the integrators");

        jLabel33.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel33.setText("But0");
        jLabel33.setToolTipText("if MUX bits = 01");

        jTextField107.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField107.setText("0");

        jTextField108.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField108.setText("0");

        jTextField109.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField109.setText("0");

        jTextField110.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField110.setText("0");

        jTextField111.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField111.setText("0");
        jTextField111.setToolTipText("not implemented");

        jTextField112.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField112.setText("0");
        jTextField112.setToolTipText("not implemented");

        jTextField113.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField113.setText("0");
        jTextField113.setToolTipText("not implemented");

        jTextField114.setFont(new java.awt.Font("Courier", 0, 11)); // NOI18N
        jTextField114.setText("0");
        jTextField114.setToolTipText("not implemented");

        jLabel34.setFont(new java.awt.Font("Courier", 0, 12)); // NOI18N
        jLabel34.setText("But1");
        jLabel34.setToolTipText("not implemented");

        jToggleButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcam.png"))); // NOI18N
        jToggleButton1.setToolTipText("Toggle Update (always or only while debug)");
        jToggleButton1.setMargin(new java.awt.Insets(0, 1, 0, -1));
        jToggleButton1.setSelectedIcon(new javax.swing.ImageIcon(getClass().getResource("/de/malban/vide/images/webcamSelect.png"))); // NOI18N
        jToggleButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jToggleButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(48, 48, 48)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel22, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel24, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel26, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel29, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel30, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel32, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel15, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel14)
                            .addComponent(jLabel13)
                            .addComponent(jLabel16)
                            .addComponent(jLabel17)
                            .addComponent(jLabel18)
                            .addComponent(jLabel19)
                            .addComponent(jLabel20))
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jLabel25, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel23, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel21, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel10, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel7, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jLabel31, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel27, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel28, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel33, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel34, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addGap(6, 6, 6)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jTextField114, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField113, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField112, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField111, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(layout.createSequentialGroup()
                                .addComponent(jTextField110, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField109, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField107, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jTextField108, javax.swing.GroupLayout.PREFERRED_SIZE, 15, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(70, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jToggleButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(7, 7, 7)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jLabel11))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel4)
                            .addComponent(jLabel14)))
                    .addComponent(jLabel15))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jLabel13))
                .addGap(4, 4, 4)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(jLabel16))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel8)
                    .addComponent(jLabel17))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(jLabel18))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel10)
                    .addComponent(jLabel19))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel7)
                    .addComponent(jLabel20))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel21)
                    .addComponent(jLabel22))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel23)
                    .addComponent(jLabel24))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel25)
                    .addComponent(jLabel26))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel28)
                    .addComponent(jLabel29))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel27)
                    .addComponent(jLabel30))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel31)
                    .addComponent(jLabel32))
                .addGap(2, 2, 2)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel33)
                    .addComponent(jTextField110, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField109, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField107, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField108, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel34)
                    .addComponent(jTextField114, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField113, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField112, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jTextField111, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(28, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jToggleButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jToggleButton1ActionPerformed
        updateEnabled = jToggleButton1.isSelected();
    }//GEN-LAST:event_jToggleButton1ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
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
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JTextField jTextField107;
    private javax.swing.JTextField jTextField108;
    private javax.swing.JTextField jTextField109;
    private javax.swing.JTextField jTextField110;
    private javax.swing.JTextField jTextField111;
    private javax.swing.JTextField jTextField112;
    private javax.swing.JTextField jTextField113;
    private javax.swing.JTextField jTextField114;
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
