/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util;

import de.malban.config.Configuration;
import static de.malban.gui.panels.LogPanel.WARN;
import java.nio.file.*;
import java.nio.file.attribute.*;
import static java.nio.file.StandardCopyOption.*;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
 
import java.io.*;
import java.nio.charset.Charset;
import java.util.ArrayList;


/**
 *
 * @author Malban
 */
public class UtilityFiles 
{
    // Uses Java 1.7
    
    public static String error="";
    public static String warning="";

    private static void init()
    {
        error="";
        warning="";
    }
    
    // only FILES ending with ".xml"
    public static ArrayList<String> getXMLFileList(String filePath)
    {
        ArrayList<String> files= new ArrayList<String>();
        File directory = new File(filePath);
        if (!directory.isDirectory())
        {
            if (directory.getParent()!=null)
                directory = new File(directory.getParent());
            if (!directory.isDirectory()) return files; // empty list
        }
        filePath = directory.toString();
        // get all the files from a directory
        File[] fList = directory.listFiles();
        for (File file : fList) 
        {
            if (file.isDirectory()) continue;
            if (!file.getName().contains(".xml")) continue;
            files.add(file.getName());
        }
        return files;
    }
    static class DeleteDirectoryVisitor extends SimpleFileVisitor<Path> 
    {
        public Path notme = null;
         @Override
        public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException 
        {
            if (notme != null)
            {
                if (!notme.equals(dir))
                    Files.delete(dir);
            }
            else
            {
                Files.delete(dir);
            }
            return FileVisitResult.CONTINUE;
        }
        @Override
        public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException 
        {
            Files.delete(file);
            return FileVisitResult.CONTINUE;
        }
    }      
    public static boolean deleteFile(String p)
    {
        boolean ret = true;
        init();
        Path base = Paths.get("./");
        Path path = base.resolve(Paths.get(p));
        try
        {
            Files.delete(path);
        }
        catch (Exception x)
        {
            error = x.getMessage()+"\n"+Utility.getStackTrace(x);
            ret = false;
        }
        return ret;
    }    
    public static boolean deleteDirectoryRecursive(String p)
    {
        boolean ret = true;
        init();
        DeleteDirectoryVisitor visitor = new DeleteDirectoryVisitor();
        
        Path base = Paths.get("./");
        
        Path path = base.resolve(Paths.get(p));
        try
        {
            Files.walkFileTree(path, visitor);
        }
        catch (Exception x)
        {
            error = x.getMessage()+"\n"+Utility.getStackTrace(x);
            ret = false;
        }
        return ret;
    }
    // delete everything IN one dir, but leave dir itself
    public static boolean cleanDirectory(String p)
    {
        boolean ret = true;
        init();
        DeleteDirectoryVisitor visitor = new DeleteDirectoryVisitor();
        
        Path base = Paths.get("./");
        
        Path path = base.resolve(Paths.get(p));
        visitor.notme = path;
        try
        {
            Files.walkFileTree(path, visitor);
        }
        catch (Exception x)
        {
            error = x.getMessage()+"\n"+Utility.getStackTrace(x);
            ret = false;
        }
        return ret;
    }
    
    static class CopyDirVisitor extends SimpleFileVisitor<Path> 
    {
        public Path fromPath;
        public Path toPath;
        CopyOption[] options = new CopyOption[] { COPY_ATTRIBUTES, REPLACE_EXISTING };
        @Override
        public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) throws IOException 
        {
            Path targetPath = toPath.resolve(fromPath.relativize(dir));
            if(!Files.exists(targetPath))
            {
                Files.createDirectory(targetPath);
            }
            return FileVisitResult.CONTINUE;
        }
        @Override
        public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException 
        {
            Files.copy(file, toPath.resolve(fromPath.relativize(file)), options);
            return FileVisitResult.CONTINUE;
        }
    }            
    public static boolean copyDirectoryAllFiles(String from, String to)
    {
        boolean ret = true;
        init();
        CopyDirVisitor visitor = new CopyDirVisitor();
        
        Path base = Paths.get("."+File.separator);
        
        visitor.fromPath = base.resolve(Paths.get(from));
        visitor.toPath = base.resolve(Paths.get(to));
        try
        {
            Files.walkFileTree(visitor.fromPath, visitor);
        
        }
        catch (Exception x)
        {
            error = x.getMessage()+"\n"+Utility.getStackTrace(x);
            ret = false;
        }
        return ret;
    }
    public static boolean copyOneFile(String from, String to)
    {
        boolean ret = true;
        init();
        CopyOption[] options = new CopyOption[] { COPY_ATTRIBUTES, REPLACE_EXISTING };
        if (from.startsWith("."+File.separator))
        {
            from = from.substring(("."+File.separator).length());
        }
        if (to.startsWith("."+File.separator))
        {
            to = to.substring(("."+File.separator).length());
        }
        Path base = Paths.get("."+File.separator);
        
        Path fromPath = base.resolve(Paths.get(from));
        Path toPath = base.resolve(Paths.get(to));
        try
        {
            Files.copy(fromPath, toPath, options);
        
        }
        catch (Exception x)
        {
            error = x.getMessage()+"\n"+Utility.getStackTrace(x);
            ret = false;
        }
        return ret;
    }
    public static boolean createTextFile(String file, String text)
    {
        boolean ret = true;
        init();
        try
        {
            BufferedWriter writer;
            Writer w = new OutputStreamWriter(new FileOutputStream(file) );
            writer =   new BufferedWriter(w);
            writer.write(text);
            writer.flush();
            writer.close();
            return true;
        }
        catch (Exception x)
        {
            error = x.getMessage()+"\n"+Utility.getStackTrace(x);
            ret = false;
        }
        return ret;
    }  
    public static boolean move(String pathAndNameFrom, String pathAndNameTo)
    {
        boolean ret = true;
        init();
        Path base = Paths.get("./");
        
        Path fromPath = base.resolve(Paths.get(pathAndNameFrom));
        Path toPath = base.resolve(Paths.get(pathAndNameTo));
        try
        {
            Files.move(fromPath, toPath, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }
        catch (Exception x)
        {
            error = x.getMessage()+"\n"+Utility.getStackTrace(x);
            ret = false;
        }
        return ret;
    }
    public static boolean rename(String pathAndName, String newNameOnly)
    {
        boolean ret = true;
        init();
        Path base = Paths.get("./");
        
        Path fromPath = base.resolve(Paths.get(pathAndName));
        Path toPath = fromPath.resolveSibling(newNameOnly);
        
        return move(fromPath.toString(), toPath.toString());
    }
    
    public static long getFileSize(String f)
    {
        File file = new File(f);
        return file.length();
    }
    
    public static boolean padFile(String filename, byte fillerByte, int upTo)
    {
        File file = new File(filename);
        long len = file.length();
        if (len>=upTo) return false;
        copyOneFile(filename, filename+".fil");
        byte[] filler = new byte[(int)(upTo-len)];
        for (int i=0;i<upTo-len;i++) filler[i]=fillerByte;
        
        try
        {
            FileOutputStream output = new FileOutputStream(filename+".fil", true);
            try 
            {
               output.write(filler);
            } 
            finally 
            {
               output.close();
            }        
        }
        catch (Throwable e)
        {
            return false;
        }
        return true;
    }
    public static boolean concatFiles(String filename1, String filename2)
    {
        copyOneFile(filename1, filename1+".con");

        try
        {
            Path path = Paths.get(filename2);
            byte[] data = Files.readAllBytes(path);            
            FileOutputStream output = new FileOutputStream(filename1+".con", true);
            try 
            {
               output.write(data);
            } 
            finally 
            {
               output.close();
            }        
        }
        catch (Throwable e)
        {
            return false;
        }
        return true;
    }
    
    

    /**
     * This utility extracts files and directories of a standard zip file to
     * a destination directory.
     * @author www.codejava.net
     *
     */

    /**
     * Size of the buffer to read/write data
     */
    private static final int BUFFER_SIZE = 4096;
    /**
     * Extracts a zip file specified by the zipFilePath to a directory specified by
     * destDirectory (will be created if does not exists)
     * @param zipFilePath
     * @param destDirectory
     * @throws IOException
     */
    public static void unzip(String zipFilePath, String destDirectory) throws IOException 
    {
        String[] charsets = {"Cp437", "ISO-8859-1", "UTF-8"};
        
        File destDir = new File(destDirectory);
        if (!destDir.exists()) 
        {
            destDir.mkdir();
        }
        ZipInputStream zipIn = new ZipInputStream(new FileInputStream(zipFilePath),Charset.forName(charsets[0]));
        
        ZipEntry entry = zipIn.getNextEntry();
        // iterates over entries in the zip file
        while (entry != null) {
            try
            {
                String filePath = destDirectory + File.separator + entry.getName();
                filePath = convertSeperator(filePath);
                
                if (!entry.isDirectory()) 
                {
                    // if the entry is a file, extracts it
                    extractFile(zipIn, filePath);
                } 
                else 
                {
                    // if the entry is a directory, make the directory
                    File dir = new File(filePath);
                    dir.mkdir();
                }
            }
            catch (java.io.FileNotFoundException e)
            {
                // it CAN be that zipped files are in a  subdir, which does not have a ZIP entry
                // try creating a DIR and retry unzip
                String filePath = destDirectory + File.separator + entry.getName();
                filePath = convertSeperator(filePath);
                String splitter = File.separator;
                if (splitter.equals("\\"))
                {
                    splitter="\\\\";
                }
                String[] dirs = filePath.split(splitter);
                String path = "";
                for (int i=0; i< dirs.length-1; i++)
                {
                    path += dirs[i];
                    File dir = new File(path);
                    dir.mkdir();
                    path+=File.separator;
                }
                extractFile(zipIn, filePath);
            }
            catch (Throwable e)
            {
                Configuration.getConfiguration().getDebugEntity().addLog(e, WARN);
            }
            zipIn.closeEntry();
            entry = zipIn.getNextEntry();
        }
        zipIn.close();
    }
    /**
     * Extracts a zip entry (file entry)
     * @param zipIn
     * @param filePath
     * @throws IOException
     */
    private static void extractFile(ZipInputStream zipIn, String filePath) throws IOException 
    {
        BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filePath));
        byte[] bytesIn = new byte[BUFFER_SIZE];
        int read = 0;
        while ((read = zipIn.read(bytesIn)) != -1) 
        {
            bos.write(bytesIn, 0, read);
        }
        bos.close();
    }
    public static String convertSeperator(String filename)
    {
        String ret = de.malban.util.UtilityString.replace(filename, "/", File.separator);
        ret = de.malban.util.UtilityString.replace(ret, "\\", File.separator);
        return ret;
    }

    
}
