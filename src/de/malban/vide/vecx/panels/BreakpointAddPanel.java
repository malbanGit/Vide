/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.panels;

import de.malban.vide.vecx.Breakpoint;

/**
 *
 * @author malban
 */
public class BreakpointAddPanel extends javax.swing.JPanel {

    Breakpoint breakpoint;
    /**
     * Creates new form OneBreakpointPanel
     */
    public BreakpointAddPanel() {
        initComponents();
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
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jTextFieldAddress = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jTextFieldCompare = new javax.swing.JTextField();
        jLabel6 = new javax.swing.JLabel();
        jTextFieldCounter = new javax.swing.JTextField();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jComboBox1 = new javax.swing.JComboBox();
        jComboBox2 = new javax.swing.JComboBox();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jRadioButton3 = new javax.swing.JRadioButton();
        jRadioButton4 = new javax.swing.JRadioButton();
        jCheckBox1 = new javax.swing.JCheckBox();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        jCheckBox4 = new javax.swing.JCheckBox();
        jCheckBox5 = new javax.swing.JCheckBox();
        jCheckBox6 = new javax.swing.JCheckBox();
        jCheckBox7 = new javax.swing.JCheckBox();
        jComboBox3 = new javax.swing.JComboBox();
        jComboBox4 = new javax.swing.JComboBox();

        setBorder(javax.swing.BorderFactory.createEtchedBorder());
        setLayout(null);

        jLabel1.setText("target");
        add(jLabel1);
        jLabel1.setBounds(4, 4, 33, 15);

        jLabel2.setText("subsystem");
        add(jLabel2);
        jLabel2.setBounds(220, 4, 58, 15);

        jLabel3.setText("type");
        add(jLabel3);
        jLabel3.setBounds(4, 80, 24, 15);

        jLabel4.setText("target address");
        add(jLabel4);
        jLabel4.setBounds(4, 30, 79, 15);
        add(jTextFieldAddress);
        jTextFieldAddress.setBounds(100, 26, 115, 19);

        jLabel5.setText("compare value");
        add(jLabel5);
        jLabel5.setBounds(4, 50, 77, 15);
        add(jTextFieldCompare);
        jTextFieldCompare.setBounds(100, 50, 115, 19);

        jLabel6.setText("counter");
        add(jLabel6);
        jLabel6.setBounds(220, 50, 40, 15);
        add(jTextFieldCounter);
        jTextFieldCounter.setBounds(320, 50, 37, 19);

        jLabel7.setText("bank");
        add(jLabel7);
        jLabel7.setBounds(220, 30, 25, 15);

        jLabel8.setText("exit");
        add(jLabel8);
        jLabel8.setBounds(370, 30, 20, 15);

        jComboBox1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }));
        jComboBox1.setPreferredSize(new java.awt.Dimension(59, 19));
        add(jComboBox1);
        jComboBox1.setBounds(320, 26, 40, 19);

        jComboBox2.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox2.setPreferredSize(new java.awt.Dimension(59, 19));
        add(jComboBox2);
        jComboBox2.setBounds(100, 2, 115, 19);

        buttonGroup1.add(jRadioButton1);
        jRadioButton1.setText("once");
        add(jRadioButton1);
        jRadioButton1.setBounds(100, 80, 46, 19);

        buttonGroup1.add(jRadioButton2);
        jRadioButton2.setText("multi");
        add(jRadioButton2);
        jRadioButton2.setBounds(100, 100, 48, 19);

        buttonGroup2.add(jRadioButton3);
        jRadioButton3.setText("read");
        add(jRadioButton3);
        jRadioButton3.setBounds(170, 80, 44, 19);

        buttonGroup2.add(jRadioButton4);
        jRadioButton4.setText("write");
        add(jRadioButton4);
        jRadioButton4.setBounds(170, 100, 48, 19);

        jCheckBox1.setText("compare");
        add(jCheckBox1);
        jCheckBox1.setBounds(240, 100, 82, 19);

        jCheckBox2.setText("info");
        add(jCheckBox2);
        jCheckBox2.setBounds(240, 80, 41, 19);

        jCheckBox3.setText("bank");
        add(jCheckBox3);
        jCheckBox3.setBounds(320, 100, 60, 19);

        jCheckBox4.setText("hey");
        add(jCheckBox4);
        jCheckBox4.setBounds(320, 80, 39, 19);

        jCheckBox5.setText("quiet");
        jCheckBox5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox5ActionPerformed(evt);
            }
        });
        add(jCheckBox5);
        jCheckBox5.setBounds(240, 120, 50, 19);

        jCheckBox6.setText("bit compare");
        add(jCheckBox6);
        jCheckBox6.setBounds(380, 80, 100, 19);

        jCheckBox7.setText("cycles");
        add(jCheckBox7);
        jCheckBox7.setBounds(380, 100, 82, 19);

        jComboBox3.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        jComboBox3.setPreferredSize(new java.awt.Dimension(59, 19));
        add(jComboBox3);
        jComboBox3.setBounds(320, 2, 130, 19);

        jComboBox4.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "exit", "info" }));
        jComboBox4.setPreferredSize(new java.awt.Dimension(59, 19));
        add(jComboBox4);
        jComboBox4.setBounds(400, 26, 50, 19);
    }// </editor-fold>//GEN-END:initComponents

    private void jCheckBox5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox5ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jCheckBox5ActionPerformed


    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JCheckBox jCheckBox4;
    private javax.swing.JCheckBox jCheckBox5;
    private javax.swing.JCheckBox jCheckBox6;
    private javax.swing.JCheckBox jCheckBox7;
    private javax.swing.JComboBox jComboBox1;
    private javax.swing.JComboBox jComboBox2;
    private javax.swing.JComboBox jComboBox3;
    private javax.swing.JComboBox jComboBox4;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JRadioButton jRadioButton3;
    private javax.swing.JRadioButton jRadioButton4;
    private javax.swing.JTextField jTextFieldAddress;
    private javax.swing.JTextField jTextFieldCompare;
    private javax.swing.JTextField jTextFieldCounter;
    // End of variables declaration//GEN-END:variables

    public void setBreakpoint(Breakpoint bp)
    {
        breakpoint = bp;
/*
        jTextFieldTarget.setText(breakpoint.getTargetString());
        jTextFieldsub.setText(breakpoint.getTargetSubtypeString());
        jTextFieldType.setText(breakpoint.getTypeString());
        jTextFieldAddress.setText(String.format("0x%04X", breakpoint.getTargetAddress() & 0xFFFF));
        jTextFieldBank.setText( ""+breakpoint.getTargetBank());
        jTextFieldExit.setText(breakpoint.getExitTypeString());
        jTextFieldCompare.setText(String.format("0x%04X", breakpoint.getCompareValue() & 0xFFFF));
        jTextFieldCounter.setText(""+breakpoint.getCounter());
*/
    }
}
