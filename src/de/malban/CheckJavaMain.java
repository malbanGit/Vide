/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import javax.swing.JOptionPane;

// this needs to be compiled "standalone" with a different java version as buolt version
// have not done this, since in netbeans this must be a seperate project

/**
 *
 * @author malban
 */
public class CheckJavaMain {
    
    
    public static void main(String[] args) {
        String props = System.getProperty("java.version");
        System.out.println(props);
        String[] v = props.split("\\.");
        int mainV = Integer.valueOf(v[0]);
        int subV = Integer.valueOf(v[1]);
        boolean toLow = false;
        if (mainV<1) toLow = true;
        if (mainV==1)
        {
            if (subV<7) 
                toLow = true;
        }
        if (!toLow)
        {
            VideMain.main(args);
        }
        else
        {
            JOptionPane.showMessageDialog(null, "Java version to low!\nYou need Java 1.7 or greater to run VIDE!", "Java version error!",JOptionPane.ERROR_MESSAGE);
        }
    }    
}
