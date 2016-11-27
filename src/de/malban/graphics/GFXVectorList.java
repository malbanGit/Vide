/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.graphics;

import de.malban.config.Configuration;
import de.malban.gui.panels.LogPanel;
import static de.malban.gui.panels.LogPanel.WARN;
import de.malban.util.XMLSupport;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author malban
 */
public class GFXVectorList {
    
    public static boolean hex = true;
    public static boolean db = true;
    
    public static String getDW()
    {
        if (db) return "DW";
        return "fdb";
    }
    public static String getDB()
    {
        if (db) return "DB";
        return "fcb";
    }
    
    // signed number
    static String hex(int b)
    {
        String s="";
        int idata = b;
        idata = idata & 0xff;
        if (idata>=128)
        {
            idata -= 256;
            idata *= -1;
            s+="-";
        }
        else
        {
            s+="+";
        }
        if (hex)
        {
            s+="$";
            s+=String.format("%02X",idata);
        }
        else
        {
            s+=idata;
        }
        return s;
    }
    // unsigend number
    static String hexU(int b)
    {
        String s="";
        int idata = b;
        idata = idata & 0xff;
        if (hex)
        {
            s+="$";
            s+=String.format("%02X",idata);
        }
        else
        {
            return hex(b);
        }
        return s;
    }
    
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private static int UID = 0;
    public int load_uid;
    public int uid = ++UID;
    public int order = 0;
    static long tuid=0; // to build unique labels in code gen!
    
    
    public ArrayList<GFXVector> list = new ArrayList<GFXVector>();
    
    public GFXVectorList()
    {
        order = uid;
    }
    
    public GFXVectorList(String filename)
    {
        loadFromXML(filename);
    }
    public String toString()
    {
        String out = "";
        for (GFXVector v: list)
        {
            out+=v.toString()+"\n";
        }
        return out+"----\n";
    }
    public GFXVectorList clone()
    {
        GFXVectorList ret = new GFXVectorList();
        
        HashMap<String, Vertex> doubleTestMap = new HashMap<String, Vertex>();
        for (GFXVector v : list)
        {
            GFXVector cv = (GFXVector) v.clone();
            
            // ensure single vertice are not double cloned
            if (v.start != null)
            {
                if (doubleTestMap.get(""+v.start.uid) == null)
                {
                    doubleTestMap.put(""+v.start.uid, cv.start);
                }
                else
                {
                    cv.start = doubleTestMap.get(""+v.start.uid);
                }
            }
            if (v.end != null)
            {
                if (doubleTestMap.get(""+v.end.uid) == null)
                {
                    doubleTestMap.put(""+v.end.uid, cv.end);
                }
                else
                {
                    cv.end = doubleTestMap.get(""+v.end.uid);
                }
            }
            

            // relative is not cloned
            // since if "single" cloned, vectors are not relative anymore!
            cv.setRelativ(v.relativ);
//            cv.relativ = v.relativ; 
            ret.add(cv); 
        }
        // postprocess vector cloning 
        // connections must be set!
        for (int i=0; i< list.size(); i++)
        {
            GFXVector oldv = list.get(i);
            GFXVector newv = ret.list.get(i);
            ret.setCloneStart(newv, oldv.uid_start_connect, oldv);
            ret.setCloneEnd(newv, oldv.uid_end_connect, oldv);
        }
        return ret;
    }
    public void resetSelection()
    {
        for(GFXVector v: list)
        {
            v.resetSelection();
        }
    }
    public void resetDisplay()
    {
        for(GFXVector v: list)
        {
            v.resetDisplay();
        }
    }
    // vec must be element of list
    private void setCloneStart(GFXVector vec, int oldCloneId, GFXVector oldv)
    {
        if (oldCloneId == -1) return;
        for (GFXVector v : list)
        {
            if (v.getOldCloneUID() == oldCloneId)
            {
                vec.uid_start_connect = v.uid;
                vec.start_connect = v;
                if (oldv.start.equals(v.start))
                    vec.start = v.start;
                if (oldv.start.equals(v.end))
                    vec.start = v.end;
                return;
            }
        }
    }
    // vec must be element of list
    private void setCloneEnd(GFXVector vec, int oldCloneId, GFXVector oldv)
    {
        if (oldCloneId == -1) return;
        for (GFXVector v : list)
        {
            if (v.getOldCloneUID() == oldCloneId)
            {
                vec.uid_end_connect = v.uid;
                vec.end_connect = v;
                if (oldv.end.equals(v.end))
                    vec.end = v.end;
                if (oldv.end.equals(v.start))
                    vec.end = v.start;
                return;
            }
        }
    }    
    
    
    // some convenience methods directly to arraylist
    public int size()
    {
        return list.size();
    }
    public void clear()
    {
        synchronized (list)
        {
            list.clear();
        }
    }
    public GFXVector get(int i)
    {
        return list.get(i);
    }
    public boolean remove(GFXVector v)
    {
        synchronized (list)
        {
            return list.remove(v);
        }
    }
    public boolean add(GFXVector v)
    {
        synchronized (list)
        {
            return list.add(v);
        }
    }
    
    public boolean toXML(StringBuilder s, String tag)
    {
        s.append("<").append(tag).append(">\n");
        boolean ok = true;
        ok = ok & XMLSupport.addElement(s, "id", uid);
        ok = ok & XMLSupport.addElement(s, "order", order);
        for(GFXVector v: list)
        {
            ok = ok & v.toXML(s, "GFXVector");
        }
        
        s.append("</").append(tag).append(">\n");
        return ok;        
    }

    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        list = new ArrayList<GFXVector>();
        int errorCode = 0;
//        StringBuilder xmlBuffer = new StringBuilder(xml);
        load_uid= xmlSupport.getIntElement("id", xml);errorCode|=xmlSupport.errorCode;
        order= xmlSupport.getIntElement("order", xml);errorCode|=xmlSupport.errorCode;
        //while (XMLSupport.hasTag("GFXVector", xmlBuffer))
        StringBuilder oneElement = null;
        do
        {
            oneElement = xmlSupport.removeTag("GFXVector", xml);
            if (oneElement == null) break;
            errorCode|=xmlSupport.errorCode;
            GFXVector v = new GFXVector();
            v.fromXML((oneElement), xmlSupport);
            errorCode|=xmlSupport.errorCode;
            list.add(v);
        } while (true);

        HashMap<String, Vertex> noDoubles = new HashMap<String, Vertex>();
        // if Vertex are the same -> unify
        // new! -> respect load_uid
        for(GFXVector v: list)
        {
            if (v.start != null)
            {
                String cid = v.start.buildCompareId();
                if (noDoubles.get(cid) == null)
                {
                    noDoubles.put(cid, v.start);
                }
                else
                {
                    v.start = noDoubles.get(cid);
                }
            }
            if (v.end != null)
            {
                String cid = v.end.buildCompareId();
                if (noDoubles.get(cid) == null)
                {
                    noDoubles.put(cid, v.end);
                }
                else
                {
                    v.end = noDoubles.get(cid);
                }
            }
        }
        
        
        correctVectorUIDs();
        
        
        setRelativeWherePossible(); // do connected vectors per IDs
        if (errorCode!= 0) return false;
        return true;
    }
    // ensures that vector UIDS are not doubled thru the load procedure
    // that load uids are replaced with correct uids
    private void correctVectorUIDs()
    {
        for(GFXVector v: list)
        {
            int luid = v.load_uid;
            for(GFXVector v2: list)
            {
                if (v2.uid_end_connect == luid) v2.uid_end_connect = v.uid;
                if (v2.uid_start_connect == luid) v2.uid_start_connect = v.uid;
            }
        }           
     }
    
    /*
    // a xml "list" of an arbitrary number of GFXVectors
    public boolean fromXML(StringBuilder xml, XMLSupport xmlSupport)
    {
        list = new ArrayList<>();
        int errorCode = 0;
        StringBuilder xmlBuffer = new StringBuilder(xml);
        uid= xmlSupport.getIntElement("id", xml);errorCode|=xmlSupport.errorCode;
        order= xmlSupport.getIntElement("order", xml);errorCode|=xmlSupport.errorCode;
        //while (XMLSupport.hasTag("GFXVector", xmlBuffer))
        StringBuilder oneElement = null;
        do
        {
            oneElement = xmlSupport.removeTag("GFXVector", xmlBuffer);
            if (oneElement == null) break;
            errorCode|=xmlSupport.errorCode;
            GFXVector v = new GFXVector();
            v.fromXML((oneElement), xmlSupport);
            errorCode|=xmlSupport.errorCode;
            list.add(v);
        } while (true);
        postProcessXMLLoad(); // do connected vectors per IDs
        if (errorCode!= 0) return false;
        return true;
    }
    */
    public boolean saveAsXML(String filename)
    {
        StringBuilder xml = new StringBuilder();
        correctOrder();
        boolean ok = toXML(xml, "GFXVectorList");
        if (!ok)
        {
            log.addLog("GFXVectorList save 'toXML' return false", WARN);
            return false;
        }
        ok = de.malban.util.UtilityFiles.createTextFile(filename, xml.toString());
        if (!ok)
        {
            log.addLog("GFXVectorList create file '"+filename+"' return false", WARN);
            return false;
        }
        return true; 
    }
    public boolean loadFromXML(String filename)
    {
        String xml = de.malban.util.UtilityString.readTextFileToOneString(new File (filename));
        boolean ok = fromXML(new StringBuilder(xml), new XMLSupport());
        
        if (!ok)
        {
            log.addLog("GFXVectorList load from xml '"+filename+"' return false", WARN);
            return false;
        }
        correctOrder();
        
        return true;
    }
    
    // connect vector directlsy not only by id
    public void setRelativeWherePossible()
    {
        for(GFXVector v: list)
        {
            v.start_connect = getVectorID(v.uid_start_connect);
            if (v.start_connect != null)
            {
                if (v.start.equals(v.start_connect.end))
                    v.start = v.start_connect.end;
                else if (v.start.equals(v.start_connect.start))
                    v.start = v.start_connect.start;
            }
            v.end_connect = getVectorID(v.uid_end_connect);
            if (v.end_connect != null)
            {
                if (v.end.equals(v.end_connect.start))
                    v.end = v.end_connect.start;
                else if (v.end.equals(v.end_connect.start))
                    v.end = v.end_connect.end;
            }
        }           
        for(GFXVector v: list)
        {
            v.setRelativ(((v.uid_end_connect != -1) && (v.uid_start_connect != -1)));
        }           
        
        // for compatibility with old saves - ensure, that if a vector IS used double
        // and no connections are set, that that vector is "singled" again
        for(GFXVector v: list)
        {
            Vertex start = v.start;
            if ((v.uid_start_connect == -1) || (v.start_connect == null))
            {
                // see if used otherwise
                for(GFXVector v2: list)
                {
                    if (v.uid != v2.uid) // only other Vectors
                    {
                        if (v2.end.uid == start.uid)
                        {
                            v.uid_start_connect = -1;
                            v.start_connect = null;
                            v2.uid_end_connect = -1;
                            v2.end_connect = null;
                            v2.end = new Vertex(v2.end);
                        }
                        if (v2.start.uid == start.uid)
                        {
                            v.uid_start_connect = -1;
                            v.start_connect = null;
                            v2.uid_end_connect = -1;
                            v2.start_connect = null;
                            v2.start = new Vertex(v2.start);
                        }
                    }
                }
            }
            
        }
        
    }
    private GFXVector getVectorID(int id)
    {
        for(GFXVector v: list)
        {
            if (v.uid == id) return v;
        }
        return null;
    }
    
    // order start with zero and go up in 1 steps
    private void correctOrder()
    {
        int o = 0;
        GFXVector v = null;
        do
        {
            v = getLowestOrder(o);
            if (v != null)
            {
                v.order = o++;
            }
        } 
        while (v != null);
    }
    // get vlowest vector order, which is at least MIN
    private GFXVector getLowestOrder(int min)
    {
        int currentMin = Integer.MAX_VALUE;
        GFXVector currentVector = null;
        for(GFXVector v: list)
        {
            if (v.order >= min) 
            {
                if (v.order<currentMin)
                {
                    currentVector = v;
                    currentMin = v.order;
                }
            }
        }
        return currentVector;
    }
    public double getMaxAbsValue()
    {
        double max = 0;
        GFXVectorList vl = this;
        
        for (int i=0; i< vl.size(); i++)
        {
            double vmax = vl.get(i).getMaxAbsValue();
            if (max<vmax)  max = vmax;
        }       
        return max;
    }
    public double getMaxAbsLenValue()
    {
        double max = 0;
        GFXVectorList vl = this;
        
        for (int i=0; i< vl.size(); i++)
        {
            double vmax = vl.get(i).getMaxAbsLenValue();
            if (max<vmax)  max = vmax;
        }       
        return max;
    }
    
    // safety map is used to
    // ensure no vertices are scaled double
    // this would happen for "joined" vectors
    public void scaleAll(double scale, HashMap<Vertex, Boolean> safetyMap)
    {
        GFXVectorList al = this;
        for (int i=0; i< al.size(); i++)
        {
            al.get(i).scaleAll(scale, safetyMap);
        }       
    }
    public void connectWherePossible(boolean ignoreFirst)
    {
        GFXVectorList listNow = this;
        if (listNow.size()==0) return;
        GFXVector first = new GFXVector();
        GFXVector last = new GFXVector();
        if (ignoreFirst)
        {
            first = listNow.list.get(0);
            last = listNow.list.get(listNow.list.size()-1);
        }
        
        
        for (int i=0; i<listNow.size(); i++)
        {
            GFXVector v1 = listNow.get(i);
            for (int i2 = i+1;i2<listNow.size(); i2++)
            {
                GFXVector v2 = listNow.get(i2);
                if (v1.uid != first.uid)
                {
                    if ((v1.start.x() == v2.end.x()) && (v1.start.y() == v2.end.y() ) && (v1.start.z() == v2.end.z() ))
                    {
                        if (v1.start_connect == null)
                        {
                            v1.start_connect = v2;
                            v1.uid_start_connect = v2.uid;
                        }

                        if (v2.end_connect == null)
                        {
                            v2.end_connect = v1;
                            v2.end = v1.start;
                            v2.uid_end_connect = v1.uid;
                        }

                    }
                }
                if (v1.uid != last.uid)
                {
                    if ((v1.end.x() == v2.start.x()) && (v1.end.y() == v2.start.y()) && (v1.end.z() == v2.start.z()))
                    {
                        if (v1.end_connect == null)
                        {
                            v1.end_connect = v2;
                            v1.uid_end_connect = v2.uid;
                        }

                        if (v2.start_connect == null)
                        {
                            v2.start_connect = v1;
                            v2.start = v1.end;
                            v2.uid_start_connect = v1.uid;
                        }
                    }
                }
            }
            v1.setRelativ(((v1.uid_end_connect != -1) && (v1.uid_start_connect != -1)));
        }        
    }    
    // adds a clone, no direct adding!
    public void add(GFXVectorList vl)
    {
        for (GFXVector v: vl.clone().list)
            list.add(v);
    }
    public boolean isAllSameIntensity()
    {
        if (list.isEmpty()) return true;
        int in = list.get(0).intensity;
        for (GFXVector v: list)
            if (v.intensity != in) 
                return false;
        return true;
    }
    public boolean isAllSamePattern()
    {
        if (list.isEmpty()) return true;
        int pa = list.get(0).pattern;
        for (GFXVector v: list)
            if (v.pattern != pa) 
                return false;
        return true;
    }
    public boolean isAllPatternHigh()
    {
        if (list.isEmpty()) return true;
        int pa = list.get(0).pattern & 0xff;
        for (GFXVector v: list)
            if (v.pattern < 128) 
                return false;
        return true;
    }
    
    public boolean isPure2d()
    {
        if (list.isEmpty()) return true;
        for (GFXVector v: list)
        {
            if (v.start.z() != 0) return false;
            if (v.end.z() != 0) return false;
        }
        return true;
    }
    // except first and last vector
    public boolean isCompleteRelative()
    {
        if (list.size()<2) return true;
        if (list.size()==2)
        {
            GFXVector v1 = list.get(0);
            GFXVector v2 = list.get(1);
            if (v1.uid_end_connect == -1) return false;
            return (v1.uid_end_connect == v2.uid) &&(v2.uid_start_connect == v1.uid);
        }
        
        for (int i=1; i< list.size()-1; i++)
        {
            GFXVector v = list.get(i);
            if (!v.isRelativ()) return false;
        }
        GFXVector v1 = list.get(0);
        if (v1.uid_end_connect == -1) return false;
        v1 = list.get(list.size()-1);
        if (v1.uid_start_connect == -1) return false;
        return true;
    }
    public boolean isClosed()
    {
        if (list.isEmpty()) return false;
        for (int i=0; i< list.size(); i++)
        {
            GFXVector v = list.get(i);
            if (!v.isRelativ()) return false;
        }
        return true;
    }
    
    public boolean isOnePath()
    {
        if (list.size() == 0) return true;
        HashMap<String, String> safetyNet = new HashMap<String, String>();
        ArrayList<GFXVector> copy = (ArrayList<GFXVector>)list.clone();
        
        GFXVector v = copy.get(0);
        while (true)
        {
            copy.remove(v);
            safetyNet.put(""+v.uid, "");
            if (copy.size() == 0) break;
            if (v.end_connect == null) return false;
            if (safetyNet.get(""+v.end_connect.uid) != null) return false; // circle
            v = v.end_connect;
        }
        
        return true;
    }
    
    public boolean isOrderedClosed()
    {
        if (!isClosed()) return false;
        
        for (int i=0; i< list.size(); i++)
        {
            GFXVector v1 = list.get(i);
            GFXVector v2;
            if (i==0) v2 = list.get(list.size()-1);
            else v2 = list.get(i-1);
            if (v1.uid_start_connect != v2.uid) return false;
            if (v2.uid_end_connect != v1.uid) return false;
        }

        return true;
    }

    public int getXMin()
    {
        if (list.isEmpty()) return 0;
        double min = Integer.MAX_VALUE;
        for (GFXVector v: list)
        {
            if (v.start.x()<min) min = v.start.x();
            if (v.end.x()<min) min = v.end.x();
        }
        return (int)min;
    }
    public int getYMin()
    {
        if (list.isEmpty()) return 0;
        double min = Integer.MAX_VALUE;
        for (GFXVector v: list)
        {
            if (v.start.y()<min) min = v.start.y();
            if (v.end.y()<min) min = v.end.y();
        }
        return (int)min;
    }
    public int getZMin()
    {
        if (list.isEmpty()) return 0;
        double min = Integer.MAX_VALUE;
        for (GFXVector v: list)
        {
            if (v.start.z()<min) min = v.start.z();
            if (v.end.z()<min) min = v.end.z();
        }
        return (int)min;
    }
    public int getXMax()
    {
        if (list.isEmpty()) return 0;
        double max = Integer.MIN_VALUE;
        for (GFXVector v: list)
        {
            if (v.start.x()>max) max = v.start.x();
            if (v.end.x()>max) max = v.end.x();
        }
        return (int)max;
    }
    public int getYMax()
    {
        if (list.isEmpty()) return 0;
        double max = Integer.MIN_VALUE;
        for (GFXVector v: list)
        {
            if (v.start.y()>max) max = v.start.y();
            if (v.end.y()>max) max = v.end.y();
        }
        return (int)max;
    }
    public int getZMax()
    {
        if (list.isEmpty()) return 0;
        double max = Integer.MIN_VALUE;
        for (GFXVector v: list)
        {
            if (v.start.z()>max) max = v.start.z();
            if (v.end.z()>max) max = v.end.z();
        }
        return (int)max;
    }
    public int getXMaxLength()
    {
        if (list.isEmpty()) return 0;
        double max = Integer.MIN_VALUE;
        for (GFXVector v: list)
        {
            double s = v.start.x();
            double e = v.end.x();
            double dif = Math.abs(s-e);
            if (dif > max) max = dif;
        }
        return (int)max;
    }
    public int getYMaxLength()
    {
        if (list.isEmpty()) return 0;
        double max = Integer.MIN_VALUE;
        for (GFXVector v: list)
        {
            double s = v.start.y();
            double e = v.end.y();
            double dif = Math.abs(s-e);
            if (dif > max) max = dif;
        }
        return (int)max;
    }
    public int getZMaxLength()
    {
        if (list.isEmpty()) return 0;
        double max = Integer.MIN_VALUE;
        for (GFXVector v: list)
        {
            double s = v.start.z();
            double e = v.end.z();
            double dif = Math.abs(s-e);
            if (dif > max) max = dif;
        }
        return (int)max;
    }
    // ensure that starts are connected with ends and vice versa
    // not starts with starts or ends with ends!
    void cleanupStartEnd()
    {
        for (GFXVector vA: list)
        {
            // A test for start duplicity
            GFXVector vB = vA.start_connect;
            if (vB != null)
            {
                if ((vA.start.uid == vB.start.uid) && (vB.uid_start_connect == vA.uid))
                {
                    // switchin move vectors not allowed
                    if (vA.pattern != 0)
                    {
                        // swap in a end and start
                        Vertex e = vA.end;
                        int ue = vA.uid_end_connect;
                        GFXVector ec = vA.end_connect;
                        
                        
                        
                        vA.end = vA.start;
                        vA.start = e;
                        vA.uid_end_connect = vA.uid_start_connect;
                        vA.uid_start_connect = ue;
                        vA.end_connect = vA.start_connect;
                        vA.start_connect = ec;
                    }
                    
/*                    
                    
                    // two starts
                    // now swap Vector A start to vector A end 
                    
                    // the actual coordinates (vertexes)
                    Vertex s = vB.start;
                    vB.start = vB.end;
                    vB.end = s;

                    // and the UIDs
                    int u = vB.uid_start_connect;
                    vB.uid_start_connect = vB.uid_end_connect;
                    vB.uid_end_connect = u;

                    // and the connects
                    vB.start_connect = vB.end_connect;
                    vB.end_connect = vA;
*/        
                
                }
            }
            
            
            // A test for end duplicity
            vB = vA.end_connect;
            if (vB != null)
            {
                if ((vA.end.uid == vB.end.uid) && (vB.uid_end_connect == vA.uid))
                {
                    // switchin move vectors not allowed
                    if (vB.pattern != 0)
                    {
                        // SWAP in B
                        // swap in a end and start
                        Vertex e = vB.end;
                        int ue = vB.uid_end_connect;
                        GFXVector ec = vB.end_connect;
                        
                        vB.end = vB.start;
                        vB.start = e;
                        vB.uid_end_connect = vB.uid_start_connect;
                        vB.uid_start_connect = ue;
                        vB.end_connect = vB.start_connect;
                        vB.start_connect = ec;
                        
                    }
                    
                    
                    
                    
                    
                    
                    /*
                    
                    // two ends
                    // now swap Vector A end to vector A end 
                    
                    // the actual coordinates (vertexes)
                    Vertex e = vB.end;
                    vB.end = vB.start;
                    vB.start = e;

                    // and the UIDs
                    int u = vB.uid_end_connect;
                    vB.uid_end_connect = vB.uid_start_connect;
                    vB.uid_start_connect = u;

                    // and the connects
                    vB.end_connect = vB.start_connect;
                    vB.start_connect = vA;
                            */
                }
            }
        }
    }
    boolean isOrdered()
    {
        GFXVectorList clone = this;//.clone();
        String oldUID = "";
        int count =0;
        for (GFXVector v: clone.list)
            oldUID += "("+(count++)+")"+v.uid+"_"+v.start.uid+"_"+v.end.uid;
        clone.doOrder();
        String newUID = "";
        count =0;
        for (GFXVector v: clone.list)
            newUID += "("+(count++)+")"+v.uid+"_"+v.start.uid+"_"+v.end.uid;
        boolean ret = newUID.equals(oldUID);
        if (!ret)
        {
//            log.addLog("Order old: "+oldUID, WARN);
//            log.addLog("Order new: "+newUID, WARN);
        }
        
        return ret;
    }
    public boolean testOrdered()
    {
        GFXVectorList clone = this.clone();
        StringBuilder oldUID = new StringBuilder();
        int count =0;
        for (GFXVector v: clone.list)
            oldUID.append("(").append(count++).append(")").append(v.uid).append("_").append(v.start.uid).append("_").append(v.end.uid);
        clone.doOrder();
        StringBuilder newUID = new StringBuilder();
        count =0;
        for (GFXVector v: clone.list)
             newUID.append("(").append(count++).append(")").append(v.uid).append("_").append(v.start.uid).append("_").append(v.end.uid);
        boolean ret = newUID.toString().equals(oldUID.toString());
        if (!ret)
        {
//            log.addLog("Order old: "+oldUID, WARN);
//            log.addLog("Order new: "+newUID, WARN);
        }
        
        return ret;
    }

    //
    public void doOrder()
    {
        // there can be actually circles with "startpoint" out of the circle
        // this can happen if more than one vectors are joined at one point!
        HashMap<String, String> safetyNet = new HashMap<String, String>();
        
        ArrayList<GFXVector> newList = new ArrayList<GFXVector>();
        for (GFXVector v: list) v.order = -1;
        cleanupStartEnd();
        
        GFXVector start;
        int pos = 0;
        while (list.size()>0)
        {
            GFXVector v = list.get(0);
            safetyNet.put(""+v.uid, "");
            int uidStart = v.uid;
            start = v;
            // see if we have a startvector
            // if so, check if it already is added (error!)
            // otherwise go backwards thru the connections until
            // start is null (or circle detected)
            while (v.start_connect != null) 
            {
                // alert!
                if (v.start_connect.order >=0)
                {
//                    log.addLog("Error while ordering vectors! start missed?", WARN);
//                    System.out.println("ERROR while ordering! start missed?");
                    break;
                }
                v = v.start_connect;
                safetyNet.put(""+v.uid, "");

                if ((v.start_connect != null) && (safetyNet.get(""+v.start_connect.uid) != null))
                {
                    v = start;
                    break;
                }
            }
            
            // remove from old list and add to new in the correct order (pos)
            list.remove(v);
            v.order = pos++;
            newList.add(v);
            safetyNet = new HashMap<String, String>();
            uidStart = v.uid;
            safetyNet.put(""+v.uid, "");
            
            
            // check if there is an end connect
            // if not, just continue to the next vector
            // if so, check if already in list (error, when not connection between last and first)

            // follow the end to end connections till none is availble, than continue with the "natural" order
            while (v.end_connect != null)
            {
                if (v.end_connect.order>0) 
                {
//                    log.addLog("Error while ordering vectors (2)!", WARN);
//                    System.out.println("ERROR while ordering (2)!");
                    break;
                }
                v = v.end_connect;
                safetyNet.put(""+v.uid, "");
                list.remove(v);
                v.order = pos++;
                newList.add(v);
                
                if ((v.end_connect != null) && (safetyNet.get(""+v.end_connect.uid) != null))
                {
                    break;
                }
            }
        }
        list = newList;
    }
    // does a connect where possible
    // and a doOrder in advance!
    // than all missing connections are filled with "move" vectors
    // NO! Move vector is placed between first and last vector!
    // since the possibility of more than two way connections, no easy closed list guarateed
    public void fillgaps(boolean doLine)
    {
        connectWherePossible(true);
   
        doOrder();
        ArrayList<GFXVector> newList = new ArrayList<GFXVector>();
        int pos = 0;
        int pattern = doLine?255:0;
        
        GFXVector startv = list.get(0);
        GFXVector endv = list.get(0);

        // 1. do all "end connects
        while (list.size()>0)
        {
            GFXVector v = list.get(0);

            list.remove(v);
            v.order = pos++;
            newList.add(v);
            
            // if this was the last vector, don't bother finding a connection
            if (list.size() == 0) continue;
            if (v.uid_end_connect == -1)
            {
                // add an additional vector!
                GFXVector v2 = new GFXVector();
                v2.order = pos++;
                v2.pattern=pattern;
                v2.intensity = v.intensity;
                
                // do end -> start connection
                v.uid_end_connect = v2.uid;
                v.end_connect = v2;
                v2.uid_start_connect = v.uid;
                v2.start_connect = v;
                v2.start = v.end;

                // do start -> end connection
                v2.end_connect = list.get(0);
                v2.uid_end_connect = list.get(0).uid;
                v2.end = list.get(0).start;
                
                // don't overwrite previous "circular" connections
                if (list.get(0).uid_start_connect == -1)
                {
                    list.get(0).uid_start_connect = v2.uid;
                    list.get(0).start_connect = v2;
                }
                
                // do relatives
                v2.setRelativ(true);
                if (newList.size()!=1) v.setRelativ(true);
                if (list.size() != 1) list.get(0).setRelativ(true);
                
                // and add new vector!
                newList.add(v2);
            }
        }
        list = newList;
        
        
        // 2. do all start connects
        newList = new ArrayList<GFXVector>();
        pos = 0;
        while (list.size()>0)
        {
            GFXVector v = list.get(0);

            list.remove(v);
            
            // if this is the first vector, don't bother finding a connection
            if (pos == 0) 
            {
                v.order = pos++;
                newList.add(v);
                continue; 
            }
            
            if (v.uid_start_connect == -1)
            {
                // add an additional vector!
                GFXVector v2 = new GFXVector();
                v2.order = pos++;
                v2.pattern=pattern;
                v2.intensity = v.intensity;
                
                // do start -> end connection
                v.uid_start_connect = v2.uid;
                v.start_connect = v2;
                v2.uid_end_connect = v.uid;
                v2.end_connect = v;
                v2.end = v.start;

                // do end -> start connection
                v2.start_connect = newList.get(newList.size()-1);
                v2.uid_start_connect = newList.get(newList.size()-1).uid;
                v2.start = newList.get(newList.size()-1).start;

                // don't overwrite previous "circular" connections
                if (newList.get(newList.size()-1).uid_end_connect == -1)
                {
                    newList.get(newList.size()-1).uid_end_connect = v2.uid;
                    newList.get(newList.size()-1).end_connect = v2;
                }
                
                // do relatives
                v2.setRelativ(true);
                if (list.size()!=0) v.setRelativ(true);
                if (newList.size()!=1) newList.get(newList.size()-1).setRelativ(true);
                
                // and add new vector!
                newList.add(v2);
            }
            v.order = pos++;
            newList.add(v);
            
        }
        list = newList;    
        
        splitWhereNeeded(127);
    }
    /*
    public void polygon(boolean doLine)
    {
        fillgaps(doLine);
        if (list.size()<2) return;
        GFXVector vStart = list.get(0);
        GFXVector vEnd = list.get(list.size()-1);
        
        
        if (vStart.uid_start_connect != -1) return;
        int pos = list.size();
        int pattern = doLine?255:0;
        
        // add an additional vector!
        GFXVector v2 = new GFXVector();
        v2.order = pos;
        v2.pattern=pattern;
        v2.intensity = vStart.intensity;

        // do end -> start connection
        vEnd.uid_end_connect = v2.uid;
        vEnd.end_connect = v2;
        v2.uid_start_connect = vEnd.uid;
        v2.start_connect = vEnd;
        v2.start = vEnd.end;

        // do start -> end connection
        v2.end_connect = vStart;
        v2.uid_end_connect = vStart.uid;
        v2.end = vStart.start;
        vStart.uid_start_connect = v2.uid;
        vStart.start_connect = v2;

        // do relatives
        v2.setRelativ(true);
        vStart.setRelativ(true);
        vEnd.setRelativ(true);

        // and add new vector!
        list.add(v2);        
    }
    */
    // seperate entities are allways clones!
    public ArrayList<GFXVectorList> seperatePaths()
    {
        ArrayList<GFXVectorList> seps = new ArrayList<GFXVectorList>();
        GFXVectorList vl = this.clone();
        
        vl.connectWherePossible(true);
        vl.doOrder();
        
        // only one!
        if (vl.isOnePath())
        {
            seps.add(vl);
            return seps;
        }
        
        
        while (vl.size()>0)
        {
            HashMap<String, String> safetyNet = new HashMap<String, String>();
            GFXVectorList newList = new GFXVectorList();
            int pos = 0;

            GFXVector v = vl.get(0);
            GFXVector start = v;
            int uidStart = v.uid;
            safetyNet.put(""+v.uid, "");
            
            // see if we have a startvector
            // if , go backwards thru the connections until
            // start is null
            if (v.start_connect != null) 
            {
                while (v.start_connect != null)
                {
                    if (!vl.list.contains(v.start_connect)) break; // this vector was already used in some path!
                    v = v.start_connect;
                    safetyNet.put(""+v.uid, "");
                    
                    // circle detected! This can happen if the first vector is not start connected to the last vector, but there is a circle nonethless!
                    if (safetyNet.get(""+v.uid) != null)
                    {
                        v = start; // if circle, we start with the first entry 
                        break;
                    }
                    //if (v.uid == uidStart) 
                    //    break;
                }
            }
            
            // now we have a correct start vector for the current path
            // this we follow till all are added
            v.order = pos++;
            vl.list.remove(v);
            newList.add(v);
            uidStart = v.uid;
            safetyNet = new HashMap<String, String>();
            safetyNet.put(""+v.uid, "");
                        
            // follow the end to end connections till none is availble, than continue with the "natural" order
            while (v.end_connect != null)
            {
                if (!vl.list.contains(v.end_connect)) break; // this vector was already used in some path!
                
                v = v.end_connect;
                safetyNet.put(""+v.uid, "");
                vl.list.remove(v);
                v.order = pos++;
                newList.add(v);
                
                // circle detected! This can happen if the first vector is not start connected to the last vector, but there is a circle nonethless!
                if (safetyNet.get(""+v.uid_end_connect) != null)
                {
                    break;
                }
            }
            seps.add(newList);
        }
        return seps;
    }

    // this might leave the list "unordered"
    // since the neighboring vectors are not changed at all!
    private void swapPoints(GFXVector v)
    {
        GFXVector start = v.start_connect;
        GFXVector end = v.end_connect;
        Vertex startVertex = v.start;
        Vertex endVertex = v.end;
        v.end_connect = start;
        v.start_connect = end;
        if (v.end_connect != null) v.uid_end_connect = v.end_connect.uid; else v.uid_end_connect = -1;
        if (v.start_connect != null) v.uid_start_connect = v.start_connect.uid; else v.uid_start_connect = -1;
        v.start = endVertex;
        v.end = startVertex;
    }
    
    private int getVectorPosFromVertexStart(Vertex here)
    {
        int count = 0;
        int found = -1;
        for (GFXVector v: list)
        {
            if (v.start.uid == here.uid)
            {
                found = count;
                break;
            }
            count++;
        }      
        return found;
    }
    private int getVectorPosFromVertexEnd(Vertex here)
    {
        int count = 0;
        int found = -1;
        for (GFXVector v: list)
        {
            if (v.end.uid == here.uid)
            {
                found = count;
                break;
            }
            count++;
        }      
        return found;
    }
    public void setPointZero(Vertex here)
    {
        setPointZero(here, 0, true);
    }
    private void setPointZero(Vertex here, int depth, boolean reoderOnStart)
    {
        depth++;
        int count = 0;
        boolean isEnd = false;
        if (reoderOnStart)
            doOrder();
        int found = getVectorPosFromVertexStart(here);
        if (found == -1)
        {
            isEnd = true;
            found = getVectorPosFromVertexEnd(here);
        }

        if (found == -1)
            return; // error!
        if (isEnd)
        {
            GFXVector v = list.get(found);
            swapPoints(v);
            // ensure reording after a swap
            
            setPointZero(here, depth, false);
            return;
        }
        ArrayList<GFXVector> newList = new ArrayList<GFXVector>();
        for (int i=0; i< list.size(); i++)
        {
            int index = (i+found) %size();
            newList.add(list.get(index));
        }
        list = newList;
        doOrder();
        found = getVectorPosFromVertexStart(here);
        if (found == -1)
            return;
        
        
        
        newList = new ArrayList<GFXVector>();
        for (int i=0; i< list.size(); i++)
        {
            int index = (i+found) %size();
            newList.add(list.get(index));
        }
        list = newList;
    }
    

    
    // assuming list is ordered
    // and vectors are continuous!
    // y,x
    String getRelativeCoordString(GFXVector v, boolean factor)
    {
        String ret = "";
        if (!factor)
            ret +=hex((int)getRelY(v))+", "+hex((int)getRelX(v));
        else
            ret +=hex((int)getRelY(v))+"*BLOW_UP, "+hex((int)getRelX(v))+"*BLOW_UP";
        return ret;
    }
    // assuming list is ordered
    // and vectors are continuous!
    // X,y 
    String getRelativeCoordStringReverse(GFXVector v, boolean factor)
    {
        String ret = "";
        if (!factor)
            ret +=hex((int)getRelX(v))+", "+hex((int)getRelY(v));
        else
            ret +=hex((int)getRelX(v))+"*BLOW_UP, "+hex((int)getRelY(v))+"*BLOW_UP";
        return ret;
    }
    // assuming list is ordered
    // and vectors are continuous!
    // X,y 
    String getCoordStringReverse(GFXVector v, boolean factor)
    {
        String ret = "";
        if (!factor)
            ret +=hex((int)v.end.x())+", "+hex((int)v.end.y());
        else
            ret +=hex((int)v.end.x())+"*BLOW_UP, "+hex((int)v.end.y())+"*BLOW_UP";
        return ret;
    }
    
    double getRelX(GFXVector v)
    {
        return v.end.x() - v.start.x();
    }
    double getRelY(GFXVector v)
    {
        return v.end.y() - v.start.y();
    }
    
    
    public boolean isMov_Draw_VLc_a()
    {
        if ((getXMaxLength()>127) || (getYMaxLength()>127)|| (getZMaxLength()>127))
        {
            log.addLog("isMov_Draw_VLc_a failed, single vectors to large!", WARN);
            return false;
        }
        
        if (!isOrdered())
        {
            log.addLog("isMov_Draw_VLc_a failed, not ordered!", WARN);
            return false;
        }
        if (!isAllSamePattern())
        {
            log.addLog("isMov_Draw_VLc_a failed, not same pattern!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isMov_Draw_VLc_a failed, not continuos!", WARN);
            return false;
        }
        return true;
    }
    public boolean isDraw_VLc()
    {
        if ((getXMaxLength()>127) || (getYMaxLength()>127)|| (getZMaxLength()>127))
        {
            log.addLog("isDraw_VLc failed, single vectors to large!", WARN);
            return false;
        }
        if (!isOrdered())
        {
            log.addLog("isDraw_VLc failed, not ordered!", WARN);
            return false;
        }
        if (!isAllSamePattern())
        {
            log.addLog("isDraw_VLc failed, not same pattern!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_VLc failed, not continuos!", WARN);
            return false;
        }
        return true;
        
    }
    public boolean isDraw_VLp()
    {
        if ((getXMaxLength()>127) || (getYMaxLength()>127)|| (getZMaxLength()>127))
        {
            log.addLog("isDraw_VLp failed, single vectors to large!", WARN);
            return false;
        }
        if (!isOrdered())
        {
            log.addLog("isDraw_VLp failed, not ordered!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_VLp failed, not continuous!", WARN);
            return false;
        }
        if (!isAllPatternHigh())
        {
            log.addLog("isDraw_VLp failed, low patterns found!", WARN);
            return false;
        }
        
        return true;
    }
    public boolean isDraw_VL_mode()
    {
        if ((getXMaxLength()>127) || (getYMaxLength()>127)|| (getZMaxLength()>127))
        {
            log.addLog("isDraw_VL_mode failed, single vectors to large!", WARN);
            return false;
        }
        if (!isOrdered())
        {
            log.addLog("isDraw_VL_mode failed, not ordered!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_VL_mode failed, not continuos!", WARN);
            return false;
        }
        return true;
    }    
    public boolean isDraw_CodeGen()
    {
        if ((getXMaxLength()>127) || (getYMaxLength()>127)|| (getZMaxLength()>127))
        {
            log.addLog("isDraw_CodeGen failed, single vectors to large!", WARN);
            return false;
        }
        if (!isOrdered())
        {
            log.addLog("isDraw_CodeGen failed, not ordered!", WARN);
            return false;
        }
        if (!isCompleteRelative())
        {
            log.addLog("isDraw_CodeGen failed, not continuos!", WARN);
            return false;
        }
        return true;
    }
    
    public String createASMMov_Draw_VLc_a(boolean includeMove, String name, boolean factor)
    {
        if (includeMove)
            if (!isMov_Draw_VLc_a()) return "";
        else
            if (!isDraw_VLc()) return "";
        StringBuilder s = new StringBuilder();
        
        GFXVectorList vl = clone();
        int count = vl.size();
        if (!includeMove) count--;
        
        s.append(name).append(":\n");
        s.append(" "+GFXVectorList.getDB()+" ").append(hex(count)).append(" ; number of lines to draw\n");

        boolean init = includeMove;
        for (GFXVector v : vl.list)
        {
            if (init)
            {
                init = false;
                if (!( (((int)v.start.y()) == 0) && (((int)v.start.x()) == 0)))
                    s.append(" "+GFXVectorList.getDB()+" ").append(hex((int)v.start.y())).append(", ").append(hex((int)v.start.x())).append(" ; move to y, x\n");
            }
            s.append(" "+GFXVectorList.getDB()+" ").append(getRelativeCoordString(v, factor)).append(" ; draw to y, x\n");
            
        }
        String text = s.toString();
        return text;
    }
    
    // if highbyte in a pattern is cleared
    // it is FORCED set!
    public String createASMDraw_VLp(String name, boolean factor)
    {
        if (!isDraw_VLp()) return "";
        StringBuilder s = new StringBuilder();
        
        s.append(name).append(":\n");
        GFXVectorList vl = this;
        for (GFXVector v : vl.list)
        {
            boolean warn = false;
            int pattern = v.pattern&0xff;
            if (pattern < 128)
            {
                warn = true;
                pattern +=128; // high bit is forcible set!
            }
            s.append(" "+GFXVectorList.getDB()+" ").append(hexU(pattern)).append(", ");
            s.append(getRelativeCoordString(v, factor));
            if (warn)
                s.append(" ; WARN pattern high bit set!\n");
            else
                s.append(" ; pattern, y, x\n");
                
        }
        s.append(" "+GFXVectorList.getDB()+" ").append(hexU(1)).append(" ; endmarker (high bit in pattern not set)\n");
        
        String text = s.toString();
        return text;
    }
    
    public String createASMDraw_VL_mode(String name, boolean includeInitialMove, boolean factor)
    {
        if (!isDraw_VL_mode()) return "";
        StringBuilder s = new StringBuilder();
        
        GFXVectorList vl = this;
        s.append(name).append(":\n");
        boolean init = true;
        for (GFXVector v : vl.list)
        {
            if ((includeInitialMove) && (init))
            {
                init = false;
                if (!( (((int)v.start.y()) == 0) && (((int)v.start.x()) == 0)))
                    s.append(" "+GFXVectorList.getDB()+" ").append(hexU(0)).append(", ").append(hex((int)v.start.y())).append(", ").append(hex((int)v.start.x())).append(" ; move to y, x\n");
            }

            boolean warn = false;
            int mode;
            int pattern = v.pattern&0xff;
            if (pattern != 0)
            {
                if (pattern < 128)
                {
                    warn = true;
                    pattern +=128; // high byte is forcible set!
                }
            }
            if (pattern == 0) mode = 0; // move
            else if ((pattern == 255) && (!warn)) mode = 2; // draw full
            else  mode = -1; // use pattern from memory
            
            
            
            s.append(" "+GFXVectorList.getDB()+" ").append(hexU(mode)).append(", ");
            s.append(getRelativeCoordString(v, factor));
            s.append(" ; mode, y, x\n");
                
        }
        s.append(" "+GFXVectorList.getDB()+" ").append(hexU(1)).append(" ; endmarker (1)\n");
        
        String text = s.toString();
        return text;
    }
    public String createASMDraw_VL_modeBASIC(String name)
    {
        if (!isDraw_VL_mode()) return "";
        StringBuilder s = new StringBuilder();
        
        GFXVectorList vl = this;
        s.append(name).append("={_\n");
        boolean init = true;
        for (GFXVector v : vl.list)
        {
            if (!init)
            {
                s.append(", _\n");
            }
            init = false;
            int mode;
            int pattern = v.pattern&0xff;
            if (pattern == 0) 
                mode = 0; // move
            else 
                mode = 1;  // draw full
            s.append("        {");
            
            if (mode == 1)
                s.append("DrawTo, ");
            else
                s.append("MoveTo, ");
            s.append(getCoordStringReverse(v, false));
            s.append("}");
        }
        s.append("}\n");
        
        String text = s.toString();
        return text;
    }    
    
    public void splitHalf(ArrayList<GFXVector> aList, GFXVector v, int newPos)
    {
        
        double halfX = v.start.x() + ((v.end.x() - v.start.x())/2);
        double halfY = v.start.y() + ((v.end.y() - v.start.y())/2);
        double halfZ = v.start.z() + ((v.end.z() - v.start.z())/2);

        GFXVector nv = v.clone();
        nv.relativ = v.relativ;
        nv.order = newPos;

        
        // set new end to end of org
        nv.end_connect = v.end_connect;
        nv.end = v.end;
        nv.uid_end_connect = v.uid_end_connect;
        
 /*       
        all other vectors which have that vector as start or end point!
        if (nv.end_connect != null)
        {
            if (nv.end_connect.start_connect == v)
            {
                nv.end_connect.start_connect = nv;
                nv.end_connect.uid_start_connect = nv.uid;
            }
            else if (nv.end_connect.end_connect == v)
            {
                nv.end_connect.end_connect = nv;
                nv.end_connect.uid_end_connect = nv.uid;
            }
        }
*/
        HashMap<String, String> saftyNet = new HashMap<String, String>();
        saftyNet.put(""+v.uid, "");
        saftyNet.put(""+nv.uid, "");

        if (nv.end != null)
        {
            for (int i=0; i<aList.size(); i++)
            {
                GFXVector vv = aList.get(i);
                if (saftyNet.get(""+vv.uid) != null) continue;
                if ((vv.start == nv.end) && (vv.uid_start_connect == v.uid))
                {
                    vv.start_connect = nv;
                    vv.uid_start_connect = nv.uid;
                }
                else if ((vv.end == nv.end) && (vv.uid_end_connect == v.uid))
                {
                    vv.end_connect = nv;
                    vv.uid_end_connect = nv.uid;
                }
            }        
        }
        

            
        
        
        
        // set new start to end
        nv.start_connect = v;
        nv.uid_start_connect = v.uid;

        // set orgEnd to new
        v.end = nv.start;
        v.uid_end_connect = nv.uid;
        v.end_connect = nv;
        
        
        v.end.x((int)halfX);
        v.end.y((int)halfY);
        v.end.z((int)halfZ);
        
 
        
        int pos = aList.indexOf(v);
        aList.add(pos+1, nv);
        
        saftyNet = new HashMap<String, String>();
        saftyNet.put(""+v.uid, "");
        saftyNet.put(""+nv.uid, "");

        for (int i=0; i<aList.size(); i++)
        {
            GFXVector vv = aList.get(i);
            if (saftyNet.get(""+vv.uid) != null) continue;
            if (vv.order >= newPos) vv.order++;
        }
    }

    public void splitWhereNeeded(int splitValue)
    {
//        int splitValue = 127;
        for (int i=0; i< list.size(); i++)
        {
            boolean didSplit;
            do
            {
                didSplit = false;
                GFXVector v = list.get(i);
                if ((Math.abs(v.start.x()-v.end.x()) > splitValue) || (Math.abs(v.start.y()-v.end.y()) > splitValue) || (Math.abs(v.start.z()-v.end.z()) > splitValue))
                {
                    splitHalf(list, v, v.order+1);
                    didSplit = true;
                }
            } while (didSplit);
        }
    }
    
    String templateInsert(String ret, double y, double x, int pattern, int intensity)
    {
        ret = de.malban.util.UtilityString.replace(ret, "%XRELPOS%", hexU((int)x));
        ret = de.malban.util.UtilityString.replace(ret, "%YRELPOS%", hexU((int)y));
        ret = de.malban.util.UtilityString.replace(ret, "%PATTERN%", hexU(pattern));
        ret = de.malban.util.UtilityString.replace(ret, "%INTENSITY%", hexU(intensity));
        ret = de.malban.util.UtilityString.replace(ret, "%UID%", ""+(tuid++));
        return ret;
    }
    
    public String createASMCodeGen(String name)
    {
        // same check as mode!
        if (!isDraw_CodeGen()) return "";
        StringBuilder s = new StringBuilder();
        Path template = Paths.get(".", "template", "codeGenDraw.template");
        String drawASM = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        template = Paths.get(".", "template", "codeGenMove.template");
        String moveASM = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        template = Paths.get(".", "template", "codeGenPattern.template");
        String patternASM = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        template = Paths.get(".", "template", "codeGenInit.template");
        String initASM = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        template = Paths.get(".", "template", "codeGenDeInit.template");
        String deinitASM = de.malban.util.UtilityString.readTextFileToOneString(new File(template.toString()));
        
        GFXVectorList vl = this;
        s.append(name).append(":\n");
        boolean init = true;
        s.append(initASM);
        for (GFXVector v : vl.list)
        {
            if (init)
            {
                init = false;
                if (!( (((int)v.start.y()) == 0) && (((int)v.start.x()) == 0)))
                    s.append(templateInsert(moveASM, v.start.y(), v.start.x(), v.pattern, v.intensity));
            }
            if (v.pattern == 0)
            {
                s.append(templateInsert(moveASM, getRelY(v), getRelX(v), v.pattern, v.intensity));
            }
            else
            if (v.pattern == 255)
            {
                s.append(templateInsert(drawASM, getRelY(v), getRelX(v), v.pattern, v.intensity));
            }
            else
            {
                s.append(templateInsert(patternASM, getRelY(v), getRelX(v), v.pattern, v.intensity));
            }
        }
        s.append(deinitASM);
        
        String text = s.toString();
        return text;
    }
    
    // removes redundant move vectors
    // if directly following move vectors can be joined (<127, -128) than joins these
    GFXVectorList optimizeMove(GFXVectorList vl)
    {
        vl = vl.clone();
        
        vl.connectWherePossible(true);
        vl.doOrder();
        
        boolean optimizeDone = false;
        do
        {
            optimizeDone = false;
            int index = 0;
            while (index < vl.size()-1)
            {
                GFXVector v1 = vl.get(index);
                GFXVector v2 = vl.get(index+1);
                index++;
                if (v1.pattern != 0) continue;
                if (v2.pattern != 0) continue;
                // now to consecutive movevectors
                // see if some of moves are within byte range, than 
                // build a resulting move and replace the vectors!
                
                double xDelta1 = v1.start.x() - v1.end.x(); 
                double yDelta1 = v1.start.y() - v1.end.y(); 
                double zDelta1 = v1.start.z() - v1.end.z(); 

                double xDelta2 = v2.start.x() - v2.end.x(); 
                double yDelta2 = v2.start.y() - v2.end.y(); 
                double zDelta2 = v2.start.z() - v2.end.z(); 

                double sumXDelta = xDelta1 + xDelta2; 
                double sumYDelta = yDelta1 + yDelta2; 
                double sumZDelta = zDelta1 + zDelta2; 
            
                if ( ((sumXDelta<=127) && (sumXDelta>=-128)) && 
                     ((sumYDelta<=127) && (sumYDelta>=-128)) && 
                     ((sumZDelta<=127) && (sumZDelta>=-128)) 
                   )
                {
                    optimizeDone = true;
                    v1.end = v2.end;
                    v1.end_connect = v2.end_connect;
                    if (v2.end_connect != null)
                    {
                        if (v2.end_connect.start.uid == v2.end.uid)
                        {
                            v2.end_connect.start_connect = v1;
                        }
                    }
                    vl.remove(v2);
                    break;
                }
                
            }
                
        } while (optimizeDone);
        
            
            
        return vl;
    }
    void splitList(GFXVectorList vl, int maxResync, ArrayList<GFXVectorList> subLists)
    {
        if (maxResync == -1)
        {
            subLists.add(vl);
            return;
        }
        if (vl.size()<maxResync)
        {
            subLists.add(vl);
            return;
        }
        int s = vl.size()/2;

        GFXVectorList vl2 = new GFXVectorList();
        for (int i=s; i<vl.size(); i++)
        {
            GFXVector v = vl.get(i);
            if ((i==s) && (i>0))
            {
                // correct old end
                vl.get(i-1).end_connect = null;
                vl.get(i-1).end = new Vertex(vl.get(i-1).end);
                
                // correct new start
                vl.get(i).start_connect = null;
            }
            vl2.add(v);
        }
        for (GFXVector v: vl2.list) vl.remove(v);
        
        // correct possible circle
        if (vl2.get(vl2.size()-1).end_connect != null)
        {
            if (vl2.get(vl2.size()-1).end_connect == vl.get(0).start_connect)
            {
                vl.get(0).start_connect = null;
                vl.get(0).start = new Vertex(vl.get(0).start);
                vl2.get(vl2.size()-1).end_connect = null;
            }
        }
        splitList(vl, maxResync, subLists);
        splitList(vl2, maxResync, subLists);
    }
    
    public String createASMDraw_syncList(String name, boolean factor, int maxResync)
    {
        StringBuilder s = new StringBuilder();
        // actually this is nearly the same as a scenario - only the
        // data is kept in one list, not in several, and there
        // is a config byte to discern.
        
        // starting location for all entities is 0,0 of the vectorlist

        // split list to max resyncs (-1 = no additional resyncs)
        ArrayList<GFXVectorList> subLists1 = seperatePaths();
        ArrayList<GFXVectorList> subLists = new ArrayList<GFXVectorList>();
        for (GFXVectorList vl: subLists1)
        {
            splitList(vl, maxResync, subLists);
        }
        
        
        s.append(name).append(":\n");
        for (GFXVectorList vectorlist: subLists)
        {
            boolean first = true;
            // concatinate moves, if possible
            vectorlist = optimizeMove(vectorlist);

            // split where needed
            vectorlist.splitWhereNeeded(127);
         
            for (GFXVector vector: vectorlist.list)
            {
                Vertex start = vector.start;
                Vertex end = vector.end;
                int pattern = vector.pattern&0xff;
                
                if (first)
                {
                    // first info is always a sync + move
                    // move might be 0,0 -> than the draw routine
                    // can do a beq...
                    int y =(int)start.y();
                    int x =(int)start.x();
                    
                    // moves, which are added from internal vectorlist drawing can be larger than 2 comp. byte
                    // split here needed in more moves
                    // this can only happen after a sync
                    do
                    {
                        int useX;
                        int useY;
                        if (y>127)
                        {
                            useY = 127;
                            y -= 127;
                        }
                        else if (y<-128)
                        {
                            useY = -128;
                            y += 128;
                        }
                        else
                        {
                            useY = y;
                            y -=useY;
                        }
                        if (x>127)
                        {
                            useX = 127;
                            x -= 127;
                        }
                        else if (x<-128)
                        {
                            useX = -128;
                            x += 128;
                        }
                        else
                        {
                            useX = x;
                            x -=useX;
                        }
                        if (factor)
                        {
                            // sync moves are not "blown up"
                            if (first)
                                s.append(" "+GFXVectorList.getDB()+" ").append(hexU(1)).append(", ").append(hex(useY)).append("").append(", ").append(hex(useX)).append("").append(" ; sync and move to y, x\n");
                            else
                                s.append(" "+GFXVectorList.getDB()+" ").append(hexU(0)).append(", ").append(hex(useY)).append("*BLOW_UP").append(", ").append(hex(useX)).append("*BLOW_UP").append(" ; move to y, x\n");
                        }
                        else
                        {
                            if (first)
                                s.append(" "+GFXVectorList.getDB()+" ").append(hexU(1)).append(", ").append(hex(useY)).append(", ").append(hex(useX)).append(" ; sync and move to y, x\n");
                            else
                                s.append(" "+GFXVectorList.getDB()+" ").append(hexU(0)).append(", ").append(hex(useY)).append(", ").append(hex(useX)).append(" ; move to y, x\n");
                        }
                        first = false;
                    } while (((y!=0) || (x!=0)));
                }
                if (pattern == 0) // move
                {
                    s.append(" "+GFXVectorList.getDB()+" ").append(hexU(0)).append(", ");
                    s.append(getRelativeCoordString(vector, factor));
                    s.append(" ; mode, y, x\n");
                }
                else  // draw
                {
                    s.append(" "+GFXVectorList.getDB()+" ").append(hexU(255)).append(", ");
                    s.append(getRelativeCoordString(vector, factor));
                    s.append(" ; draw, y, x\n");
                }
            }
        }
        s.append(" "+GFXVectorList.getDB()+" ").append(hexU(2)).append(" ; endmarker \n");
        String text = s.toString();
        
        return text;
    }
 
    

    public ArrayList<Face> buildFacelist()
    {
        ArrayList<Face> faces = new ArrayList<Face>();
        HashMap<String, Face> faceMap = new HashMap<String, Face>();
        
        for (GFXVector vector: list)
        {
            Vertex a = vector.start;
            if (a != null)
            {
                for (String fas: a.face)
                {
                    fas = fas.substring(0, fas.indexOf("|"));
                    
                    Face face = faceMap.get(fas);
                    if (face == null)
                    {
                        face = new Face();
                        face.faceID = de.malban.util.UtilityString.Int0(fas);
                        faceMap.put(fas, face);
                        faces.add(face);
                    }
                    face.vertice.remove(a);
                    face.vertice.add(a);
                }
            }
            a = vector.end;
            if (a != null)
            {
                for (String fas: a.face)
                {
                    fas = fas.substring(0, fas.indexOf("|"));
                    Face face = faceMap.get(fas);
                    if (face == null)
                    {
                        face = new Face();
                        face.faceID = de.malban.util.UtilityString.Int0(fas);
                        faceMap.put(fas, face);
                        faces.add(face);
                    }
                    face.vertice.remove(a);
                    face.vertice.add(a);
                }
            }
        }
        for(Face face: faces)
            face.order();
        
        return faces;
    }    
    
    public void removePoints()
    {
        
        // remove non selected!
        ArrayList<GFXVector> toRemove = new ArrayList<GFXVector>();
        
        for (int i=0; i<size(); i++)
        {
            GFXVector v = get(i);
            if ((v.start.x() == v.end.x()) && (v.start.y() == v.end.y()))
            {
                if ((v.start_connect != null) && (v.end_connect!=null))
                {
                    
                    v.start_connect.end_connect = v.end_connect;
                    v.start_connect.uid_end_connect = v.uid_end_connect;

                    v.end_connect.start_connect = v.start_connect;
                    v.end_connect.uid_start_connect = v.uid_start_connect;
                }
                else if (v.start_connect != null)
                {
                    v.start_connect.end_connect = null;
                    v.start_connect.uid_end_connect = -1;
                    v.start_connect.setRelativ(false);
                }
                else if (v.end_connect != null)
                {
                    v.end_connect.start_connect = null;
                    v.end_connect.uid_start_connect = -1;
                    v.end_connect.setRelativ(false);
                }
                toRemove.add(v);
            }
                
                
        }
        for (GFXVector v: toRemove)
            remove(v);
    }
    public void removeDoubles()
    {
        doOrder();
        ArrayList<GFXVector> toRemove = new ArrayList<GFXVector>();
        
        for (int i=0; i<size(); i++)
        {
            GFXVector v1 = get(i);
            for (int j=i+1;j<size(); j++)
            {
                GFXVector v2 = get(j);
                if ((v1.start.equals(v2.start)) ||(v1.start.equals(v2.end)))
                {
                    if ((v1.end.equals(v2.start)) ||(v1.end.equals(v2.end)))
                    {
                        remove(v2);
                        j=i;
                    }
                }
            }
        }        
    }
    public boolean contains(Vertex v)
    {
        for (int i=0; i<size(); i++)
        {
            GFXVector v1 = get(i);
            if (v1.contains(v)) return true;
        }
        return false;
    }
    
    public void changeOrientation(GFXVector v)
    {
        Vertex oldStart = v.start;
        Vertex oldEnd = v.end;
        v.end = oldStart;
        v.start = oldEnd;
        
        GFXVector oldEndVector = v.end_connect;
        GFXVector oldStartVector = v.start_connect;
        v.end_connect = oldStartVector;
        v.start_connect = oldEndVector;
        
        int old_uid_start = v.uid_start_connect;
        int old_uid_end = v.uid_end_connect;
        v.uid_start_connect = old_uid_end;
        v.uid_end_connect = old_uid_start;
    }
    // there must be exactly 2 vectors given and they must be neighbors
    // the point in the middle will be removed,
    // from two vectors there will remain only one

    // assumes that there are NO other connections in the
    // vectorlist that connect to vector 2
    public void joinVectors(ArrayList<GFXVector> vlist)
    {
        if (vlist.size() != 2) return;
        GFXVector v1 = vlist.get(0);
        GFXVector v2 = vlist.get(1);
        
        if ((v1.end_connect!=null)&&(v1.end_connect.uid == v2.uid))
        {
            list.remove(v2);
            if (v1.end.uid == v2.start.uid)
            {
                GFXVector newEnd = v2.end_connect;
                v1.end = v2.end;
                v1.uid_end_connect = v2.uid_end_connect;
                v1.end_connect = v2.end_connect;
                
                if ((newEnd.start_connect!=null) && (newEnd.start_connect.uid == v2.uid))
                {
                    newEnd.start_connect = v2.start_connect;
                    newEnd.start = v1.end;
                    newEnd.uid_start_connect = v2.uid_start_connect;
                }
                if ((newEnd.end_connect!=null)&&(newEnd.end_connect.uid == v2.uid))
                {
                    newEnd.end_connect = v2.start_connect;
                    newEnd.end = v1.end;
                    newEnd.uid_end_connect = v2.uid_start_connect;
                }
                
            }

            else if (v1.end.uid == v2.end.uid)
            {
                GFXVector newEnd = v2.start_connect;
                v1.end = v2.start;
                v1.uid_end_connect = v2.uid_start_connect;
                v1.end_connect = v2.start_connect;
                
                if ((newEnd.start_connect!=null) &&(newEnd.start_connect.uid == v2.uid))
                {
                    newEnd.start_connect = v2.start_connect;
                    newEnd.start = v1.end;
                    newEnd.uid_start_connect = v2.uid_start_connect;
                }
                if ((newEnd.end_connect!=null) &&(newEnd.end_connect.uid == v2.uid))
                {
                    newEnd.end_connect = v2.start_connect;
                    newEnd.end = v1.end;
                    newEnd.uid_end_connect = v2.uid_start_connect;
                }
                
            }
        
        
        
        
        
        }
        else
        if ((v1.start_connect!=null) &&(v1.start_connect.uid == v2.uid))
        {
            list.remove(v2);
            if (v1.start.uid == v2.start.uid)
            {
                GFXVector newEnd = v2.end_connect;
                v1.start = v2.end;
                v1.uid_start_connect = v2.uid_end_connect;
                v1.start_connect = v2.end_connect;
                
                if ((newEnd.start_connect!=null) &&(newEnd.start_connect.uid == v2.uid))
                {
                    newEnd.start_connect = v2.start_connect;
                    newEnd.start = v1.start;
                    newEnd.uid_start_connect = v2.uid_start_connect;
                }
                if ((newEnd.end_connect!=null) &&(newEnd.end_connect.uid == v2.uid))
                {
                    newEnd.end_connect = v2.start_connect;
                    newEnd.end = v1.start;
                    newEnd.uid_end_connect = v2.uid_start_connect;
                }
                
            }

            else if (v1.start.uid == v2.end.uid)
            {
                GFXVector newEnd = v2.start_connect;
                v1.start = v2.start;
                v1.uid_start_connect = v2.uid_start_connect;
                v1.start_connect = v2.start_connect;
                
                if ((newEnd.start_connect!=null) &&(newEnd.start_connect.uid == v2.uid))
                {
                    newEnd.start_connect = v2.start_connect;
                    newEnd.start = v1.start;
                    newEnd.uid_start_connect = v2.uid_start_connect;
                }
                if ((newEnd.end_connect!=null) &&(newEnd.end_connect.uid == v2.uid))
                {
                    newEnd.end_connect = v2.start_connect;
                    newEnd.end = v1.start;
                    newEnd.uid_end_connect = v2.uid_start_connect;
                }
            }
        }
    }
}
