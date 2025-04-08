/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban;

import com.jogamp.opengl.GLProfile;
import static de.malban.Global.initLAF;
import de.malban.jogl.JOGLSupport;
import de.malban.config.Configuration;
import de.malban.event.EventSupport;
import de.malban.gui.CSAMainFrame;
import static de.malban.gui.panels.LogPanel.INFO;
import de.malban.input.SystemController;
import de.malban.sound.tinysound.TinySound;
import de.malban.util.extractor.Extractor;
import de.malban.vide.CLI;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.Toolkit;
import java.io.File;
import java.util.ArrayList;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import javax.swing.JFrame;
import javax.swing.JPanel;
/**
 *
 * @author malban
 */
public class VideMain {

    public static void main(String[] args) {
//GLProfile.initSingleton();
        
/*

 class IdealCollision45DegreeSimulation extends JPanel implements Runnable {

    private static final int WIDTH = 800;
    private static final int HEIGHT = 600;
    private static final int DIAMETER = 50;
    private static final double GRAVITY = 9.81;
    private static final double ANGLE = Math.PI / 4.0;
    private static final double SPEED = 30.0;

    private double x, y, vx, vy;

    public IdealCollision45DegreeSimulation() {
        setPreferredSize(new Dimension(WIDTH, HEIGHT));
        x = WIDTH / 2.0;
        y = HEIGHT - DIAMETER;
        vx = SPEED * Math.cos(ANGLE);
        vy = -SPEED * Math.sin(ANGLE);
    }

    public void run() {
        while (true) {
            update();
            repaint();
            try {
                Thread.sleep(10);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private void update() {
        // Check for collision with the ground
        if (y + DIAMETER / 2.0 >= HEIGHT) {
            vy = -vy;
        }
        // Check for collision with the walls
        if (x - DIAMETER / 2.0 <= 0 || x + DIAMETER / 2.0 >= WIDTH) {
            vx = -vx;
        }
        // Check for collision with the 45-degree plane
        if (y + DIAMETER / 2.0 >= (HEIGHT - x - DIAMETER / 2.0)) {
            // Calculate the normal vector of the plane
            double nx = 1.0 / Math.sqrt(2);
            double ny = -1.0 / Math.sqrt(2);
            // Calculate the dot product of the velocity vector and the normal vector
            double dot = vx * nx + vy * ny;
            // Calculate the new velocity vector by reflecting the old one around the normal vector
            double newvx = vx - 2 * dot * nx;
            double newvy = vy - 2 * dot * ny;
            // Update the velocity vector
            vx = newvx;
            vy = newvy;
        }
        // Apply gravity
        vy += GRAVITY * 0.01;
        // Update position
        x += vx * 0.01;
        y += vy * 0.01;
    }

    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;
        // Draw the 45-degree plane
        g2d.setColor(Color.BLACK);
        int[] xPoints = {0, HEIGHT, HEIGHT, 0};
        int[] yPoints = {HEIGHT, HEIGHT - HEIGHT / 2, HEIGHT - HEIGHT / 2 + WIDTH / 2, WIDTH / 2};
        g2d.fillPolygon(xPoints, yPoints, 4);
        // Draw the ball
        g2d.setColor(Color.RED);
        g2d.fillOval((int) (x - DIAMETER / 2), (int) (y - DIAMETER / 2), DIAMETER, DIAMETER);
    }
}
        JFrame frame = new JFrame("Ideal Collision Simulation");
        IdealCollision45DegreeSimulation simulation = new IdealCollision45DegreeSimulation();
        frame.setContentPane(simulation);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.pack();
        frame.setVisible(true);
        Thread thread = new Thread(simulation);
        thread.start();

*/

    






















     {
         
        
 int gridSize = 7;
        int stepSize = 50;

        int minCoord = -(3*stepSize);
        int maxCoord = (3*stepSize);

        // Iteriere zuerst über y, dann über x
        for (int y = 0; y < gridSize; y++) {
            for (int x = 0; x < gridSize; x++) {
                int xCoord = minCoord + x * stepSize;
                int yCoord = maxCoord - y * stepSize;

                // Berechne Radius und Winkel in Bogenmaß
                double radius = Math.sqrt(xCoord * xCoord + yCoord * yCoord);
                double angleRad = Math.atan2(yCoord, xCoord);

                // Konvertiere Winkel in Grad

// mathematically positiv is counter clockwise
// do it "logical" positiv
                double angleDeg = -Math.toDegrees(angleRad);
                if (angleDeg<0) angleDeg+=360;
                if (angleDeg<0) angleDeg+=360;
                if (angleDeg>360) angleDeg-=360;
                if (angleDeg>360) angleDeg-=360;
                
                double angle255 = angleDeg/360;
                angle255 *= 512;
                
                // Gib Polarkoordinaten aus
                System.out.printf("\t db %.0f, %d, %d\t; radius, angle(512) in degree, from:  %.0f rad, ", radius, ((int)angle255)/256,((int)angle255) -(int) 256*(((int)angle255)/256) , angleRad);

                // Berechne kartesische Koordinaten
                double xCart = radius * Math.cos(angleRad);
                double yCart = radius * Math.sin(angleRad);

                // Gib kartesische Koordinaten aus
                System.out.printf("y,x: %.0f, %.0f\n", yCart, xCart);
            }
            System.out.println();
        }

    }      


//Extractor.ensureParaAvailable();
//        Extractor.extractPara();
        String javaVersion2 =   System.getProperty("java.vm.name") + " (build " +
                                System.getProperty("java.vm.version") + ", " +
                                System.getProperty("java.vm.info") + ")";
        String javaVersion1 = System.getProperty("java.version") + " " +
                              System.getProperty("java.vendor");
        String javaDir = "Java Home: "+System.getProperty("java.home");
         
        String osName = System.getProperty("os.name");
        String osVersion = System.getProperty("os.version");
        int majorVersion = 0;
        String[] v = osVersion.split(".");
        v = de.malban.util.UtilityString.cleanStringArray(v);
        if (v.length >0)
        {
            majorVersion = de.malban.util.UtilityString.Int0(v[0]);
        }
        
        Global g = new Global();
        Configuration.getConfiguration().getDebugEntity();
        Configuration.getConfiguration().getDebugEntity().addLog("Global boot log: \n"+Global.bootString, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog("---\n", INFO);

        Configuration.getConfiguration().getDebugEntity().addLog("Vide version: "+Global.VideVersion, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog("Operating system: "+osName+" Version: "+osVersion, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog("Running on: "+javaVersion1, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog(""+javaVersion2, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog(""+javaDir, INFO);
        Configuration.getConfiguration().getDebugEntity().addLog("VIDE_HOME = "+Global.mainPathPrefix, INFO);

        
                
        Toolkit.getDefaultToolkit().setDynamicLayout(true);
        System.setProperty("sun.awt.noerasebackground", "true");
        JFrame.setDefaultLookAndFeelDecorated(true);
        JDialog.setDefaultLookAndFeelDecorated(true);

        initLAF();
        EventSupport.getEventSupport();

        String name = "vide.cli";
        
        args = makeArgs(de.malban.util.UtilityString.readTextFileToOneString(new File (Global.mainPathPrefix+name)));
        
        CLI cli = CLI.getCLI();
        boolean doExit = cli.parseArguments(args);
        // if help was invoked - exit
        if (doExit) return;
        cli.injectCLIConfig();
        
        
        
        
        
        SystemController.isJInputSupported();
        JOGLSupport.isJOGLSupported();
  
        TinySound.init();
        SwingUtilities.invokeLater(new Runnable()
        {
            public void run()
            {
                CSAMainFrame mainFrame = new CSAMainFrame();
                mainFrame.setVisible(true);
                
                /*
                String javaVersion = System.getProperty("java.version");
                String[] splitter = javaVersion.split("\\.");
                if (splitter.length == 0)
                {
                    ShowWarningDialog.showWarningDialog("Java version", "Java version cannot be determined,\nyou need at least Java version 10, procede at own risk!");
                }
                else
                {
                    int v = DASM6809.toNumber(splitter[0]);
                    Logable l = Configuration.getConfiguration().getDebugEntity();
                    l.addLog("Version string found: "+javaVersion+"("+v+")", INFO);
                    if (v<10)
                    {
                        if (Global.doTestJava)
                        {
                            ShowErrorDialog.showErrorDialog("Java version", "You need at least Java version 10 to run Vide!\nPlease update Java.");
                            System.exit(1);
                        }
                    }
                }
                */
                
            }
        });

    }

    public static String[] makeArgs(String s)
    {
        String[] relevantLines = s.split("\n");
        StringBuilder sb = new StringBuilder();
        for (String l: relevantLines)
        {
            if (!l.startsWith("#"))
                sb.append(l+"\n");
        }
        
        
        
        s = de.malban.util.UtilityString.replaceWhiteSpaces(sb.toString(), " ");
        s = de.malban.util.UtilityString.replace(s, "  ", " ");
        String[] ret = de.malban.util.UtilityString.cleanStringArray(s.split(" "));
        return ret;
    }
}
