/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.util.extractor;
import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.zip.GZIPInputStream;


public class Phonemes {

    public static final String DATA_FILE = "data/packs/phonems.jvepak";
    private static final byte DATAFORMAT_VERSION = 1;
    private static final String DATAFILE_HEADER = "ParaJVE/samples/vecvoice\u0001";
    public static final int DATASTREAM_RAW = 1;
    public static final int DATASTREAM_GZIP = 2;
    private static Phonem[] phonems;
    private static int sampleBits;

    public static final void main(String[] arrstring) throws IOException {
        Phonemes.loadSamples(16);
        int n = 0;
        while (n < 64) {
            System.out.println(" " + phonems[n].getName() + "\t -> " + phonems[n].getDataLength(1) / 2 + " bytes");
            ++n;
        }
    }

    public static final byte[] getFileHeader(int n) {
        return ("ParaJVE/samples/vecvoice\u0001" + (char)n).getBytes();
    }

    public static final Phonem getPhonem(int n) {
        return phonems[n];
    }

    public static final int getIndex(String string) {
        int n = phonems.length;
        while (n-- > 0) {
            if (!phonems[n].getName().equals(string)) continue;
            return n;
        }
        return -1;
    }

    public static final void loadSamples(int n) {
        if (phonems == null || sampleBits != n) {
            try {
                Phonemes.loadSamplesImpl(n);
                sampleBits = n;
            }
            catch (Exception var1_1) {
                throw new RuntimeException("Error while loading phonems table", var1_1);
            }
        }
    }

    public static File getFile(String string) {
        return string == null ? null : getFile(new File(string));
    }

    public static File getFile(File file) {
        String string;
        if (file != null && System.getProperty("os.name").toLowerCase().contains("linux") && ((string = file.getPath()).startsWith("~/") || string.startsWith("$HOME/"))) {
            file = new File(String.valueOf(System.getProperty("user.home")) + string.substring(string.indexOf(47)));
        }
        return file;
    }

    public static InputStream getResourceStream(String string) throws IOException {
        InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream(string);
        Exception exception = null;
        if (inputStream == null) {
            try {
                File file = getFile(string);
                if (file.exists()) {
                    inputStream = new FileInputStream(file);
                }
            }
            catch (Exception var3_4) {
                exception = var3_4;
            }
            if (inputStream == null) {
                throw new RuntimeException("Cannot open resource [" + string + "]", exception);
            }
        }
        return inputStream;
    }
    private static final void loadSamplesImpl(int n) throws IOException {
        BufferedInputStream bufferedInputStream = new BufferedInputStream(getResourceStream((String)"data/packs/phonems.jvepak"));
        try {
            phonems = Phonemes.loadSamplesImpl(bufferedInputStream, n);
        }
        catch (IOException var2_2) 
        {
            try 
            {
                bufferedInputStream.close();
            }
            catch (Exception v0) 
            {
            }
            throw var2_2;
        }
        try {
            bufferedInputStream.close();
        }
        catch (Exception v1) {}
    }
    
    public static boolean checkHeader(InputStream inputStream, byte[] arrby) throws IOException {
        byte[] arrby2 = new byte[arrby.length];
        inputStream.read(arrby2);
        int n = arrby.length;
        while (n-- > 0) {
            if (arrby2[n] == arrby[n]) continue;
            return false;
        }
        return true;
    }


    private static final Phonem[] loadSamplesImpl(InputStream inputStream, int n) throws IOException {
        Phonem[] arrphonem;
        block22 : {
            DataInputStream filterInputStream = null;
            try {
                if (!checkHeader((InputStream)inputStream, (byte[])"ParaJVE/samples/vecvoice\u0001".getBytes())) {
                    throw new IOException("The phonemes file header is invalid.");
                }
                switch (inputStream.read()) {
                    case 1: {
                        break;
                    }
                    case 2: {
                        inputStream = new GZIPInputStream(inputStream);
                        break;
                    }
                    default: {
                        throw new IOException("Unsupported data stream mode!");
                    }
                }
                filterInputStream = new DataInputStream(inputStream);
                Phonem[] arrphonem2 = new Phonem[64];
                byte[] arrby = new byte[5];
                int n2 = 0;
                while (n2 < arrphonem2.length) {
                    filterInputStream.read(arrby, 0, 4);
                    String string = new String(arrby);
                    string = string.substring(0, string.indexOf(0));
                    arrphonem2[n2] = new Phonem(n2, string);
                    ++n2;
                }
                int[] arrn = new int[64];
                int n3 = 0;
                while (n3 < arrphonem2.length) {
                    arrn[n3] = filterInputStream.readUnsignedShort(); // read unsigned short
                    ++n3;
                }
                if (n == 15) {
                    n3 = 0;
                    while (n3 < arrphonem2.length) {
                        int n4 = arrn[n3];
                        int[] arrn2 = new int[n4];
                        int n5 = 0;
                        while (n5 < n4) {
                            int n6;
                            arrn2[n5] = n6 = (filterInputStream.read() & 255) * 32767 / 255;
                            ++n5;
                        }
                        arrphonem2[n3].setData1(arrn2, 0, n4);
                        ++n3;
                    }
                } else if (n == 16) {
                    n3 = 0;
                    while (n3 < arrphonem2.length) {
                        int n7 = arrn[n3];
                        int[] arrn3 = new int[n7];
                        int n8 = 0;
                        while (n8 < n7) {
                            int n9 = filterInputStream.read() & 255;
                            arrn3[n8] = (n9 << 8) - 32768;
                            ++n8;
                        }
                        arrphonem2[n3].setData1(arrn3, 0, n7);
                        ++n3;
                    }
                } else {
                    throw new IllegalArgumentException("Number of bits not supported : " + n);
                }
                arrphonem = arrphonem2;
                if (filterInputStream == null) break block22;
            }
            catch (IOException var11_18) {
                if (filterInputStream != null) {
                    try {
                        filterInputStream.close();
                    }
                    catch (Exception v0) {}
                }
                throw var11_18;
            }
            try {
                filterInputStream.close();
            }
            catch (Exception v1) {}
        }
        return arrphonem;
    }
    private static final Phonem[] loadSamplesImplWithSave(InputStream inputStream, int convertToSampleBits) throws IOException {
        Phonem[] arrphonem;
        block22 : {
            DataInputStream filterInputStream = null;
            try {
                if (!checkHeader((InputStream)inputStream, (byte[])"ParaJVE/samples/vecvoice\u0001".getBytes())) {
                    throw new IOException("The phonemes file header is invalid.");
                }
                switch (inputStream.read()) {
                    case 1: {
                        break;
                    }
                    case 2: {
                        inputStream = new GZIPInputStream(inputStream);
                        break;
                    }
                    default: {
                        throw new IOException("Unsupported data stream mode!");
                    }
                }
                filterInputStream = new DataInputStream(inputStream);
                Phonem[] phonemArray = new Phonem[64];
                byte[] phonemNameBytes = new byte[5];
                int phonemCounter = 0;
                while (phonemCounter < phonemArray.length) 
                {
                    filterInputStream.read(phonemNameBytes, 0, 4);
                    String string = new String(phonemNameBytes);
                    string = string.substring(0, string.indexOf(0));
                    phonemArray[phonemCounter] = new Phonem(phonemCounter, string);
                    ++phonemCounter;
                }
                int[] phonemDataLengthPerSampleArray = new int[64];
                int onePhonemCounter = 0;
                while (onePhonemCounter < phonemArray.length) 
                {
                    phonemDataLengthPerSampleArray[onePhonemCounter] = filterInputStream.readUnsignedShort(); // read unsigned short
                    ++onePhonemCounter;
                }
//                outputPhonem(phonemArray[phonemCounter], phonemRawInputData);
                
                if (convertToSampleBits == 15) {
                    onePhonemCounter = 0;
                    while (onePhonemCounter < phonemArray.length) 
                    {
                        int phonemDataLength = phonemDataLengthPerSampleArray[onePhonemCounter];
                        int[] phonemActualData = new int[phonemDataLength];
                        byte[] phonemActualRaw = new byte[phonemDataLength];
                        int phonemActualDataCounter = 0;
                        while (phonemActualDataCounter < phonemDataLength) 
                        {
                            phonemActualRaw[phonemActualDataCounter] = (byte) (filterInputStream.read() & 255);
                            phonemActualData[phonemActualDataCounter] = (phonemActualRaw[phonemActualDataCounter] & 255) * 32767 / 255;
                            ++phonemActualDataCounter;
                        }
                        phonemArray[onePhonemCounter].setData1(phonemActualData, 0, phonemDataLength);
                        outputPhonem(phonemArray[onePhonemCounter], phonemActualRaw);
                        ++onePhonemCounter;
                    }
                } 
                else if (convertToSampleBits == 16) 
                {
                    onePhonemCounter = 0;
                    while (onePhonemCounter < phonemArray.length) 
                    {
                        int n7 = phonemDataLengthPerSampleArray[onePhonemCounter];
                        int[] arrn3 = new int[n7];
                        byte[] phonemActualRaw = new byte[n7];
                        int n8 = 0;
                        while (n8 < n7) {
                            phonemActualRaw[n8] = (byte) (filterInputStream.read() & 255);
                            int n9 = phonemActualRaw[n8] & 255;
                            arrn3[n8] = (n9 << 8) - 32768;
                            ++n8;
                        }
                        phonemArray[onePhonemCounter].setData1(arrn3, 0, n7);
                        outputPhonem(phonemArray[onePhonemCounter], phonemActualRaw);
                        ++onePhonemCounter;
                        
                    }
                } else {
                    throw new IllegalArgumentException("Number of bits not supported : " + convertToSampleBits);
                }
                arrphonem = phonemArray;
                if (filterInputStream == null) 
                    break block22;
            }
            catch (IOException var11_18) {
                if (filterInputStream != null) {
                    try {
                        filterInputStream.close();
                    }
                    catch (Exception v0) {}
                }
                throw var11_18;
            }
            try {
                filterInputStream.close();
            }
            catch (Exception v1) {}
        }
        return arrphonem;
    }

    static void outputPhonem(Phonem phonem, byte[] data)
    {
        int index = phonem.getIndex();
        String name = phonem.getName();
        try
        {
            FileOutputStream fo = new FileOutputStream(outPath+File.separator+name+"_"+index+".phonem");
            DataOutputStream dataOut = new DataOutputStream(fo);
            dataOut.write(data);   
            dataOut.close();
            fo.close();
        }
        catch (Throwable e)
        {
            e.printStackTrace();
        }
    }


    static String outPath = "";
    public static final void loadSamplesWithSave(int n, String op) {
        outPath = op;
        try 
        {
            BufferedInputStream bufferedInputStream = new BufferedInputStream(getResourceStream((String)"phonems.jvepak"));
            try {
                phonems = Phonemes.loadSamplesImplWithSave(bufferedInputStream, n);
            }
            catch (IOException var2_2) {
                try {
                    bufferedInputStream.close();
                }
                catch (Exception v0) {}
                throw var2_2;
            }
            try {
                bufferedInputStream.close();
            }
            catch (Exception v1) {}
            sampleBits = n;
        }
        catch (Exception var1_1) {
            throw new RuntimeException("Error while loading phonems table", var1_1);
        }
    }
}


