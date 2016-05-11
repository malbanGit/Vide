/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package de.malban.util;

import java.io.*;
import javax.swing.JFileChooser;

/**
 *
 * @author Malban
 */
public class JavaPrintFile {

    public static void printFile()
    {
        //Create a file chooser
        final JFileChooser fc = new JFileChooser();
        fc.setCurrentDirectory(new File("."+File.separator));
        int returnVal = fc.showOpenDialog(null);
        if (returnVal != JFileChooser.APPROVE_OPTION) return;
        File f = fc.getSelectedFile();
        System.out.println("Selected File to Print: "+f.getAbsoluteFile());
        BufferedReader reader;
        BufferedWriter writer;

        try {
            // see also: http://java.sun.com/j2se/1.4.2/docs/api/java/nio/charset/Charset.html
            //           http://www.wsoftware.de/practices/charsets.html
            Reader r = new InputStreamReader(new FileInputStream(f));
            reader =   new BufferedReader(r);
            Writer w = new OutputStreamWriter(new FileOutputStream(new File(f.getAbsolutePath()+"Print.java") ));
            writer =   new BufferedWriter(w);

            writer.write("private Vector<String> generate()\n");
            writer.write("{\n");
            writer.write("\tVector<String> r = new Vector<String>();\n");
            writer.write("\tString bPackage = jTextFieldPackage.getText();\n");
            writer.write("\tString bClass = jTextFieldClass.getText();\n");

            String zeile = null;
            do
            {
                zeile = reader.readLine();
                if (zeile == null) continue;

                zeile = de.malban.util.UtilityString.replace(zeile, "\"", "#+#+#");
                zeile = de.malban.util.UtilityString.replace(zeile, "#+#+#", "\\\"");

                writer.write("\tr.addElement(\""+zeile+"\");\n");
                writer.flush();

            } while (zeile != null);

            writer.write("\treturn r;\n");
            writer.write("}\n");
            writer.close();
            reader.close();

        } catch (IOException e)
        {
            System.err.println("Error reading/writing file.");
            e.printStackTrace();
        }
        return;
    }

}
