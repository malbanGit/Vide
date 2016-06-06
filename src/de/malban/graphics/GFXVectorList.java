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
    LogPanel log = (LogPanel) Configuration.getConfiguration().getDebugEntity();
    private static int UID = 0;
    public int uid = ++UID;
    public int order = 0;
    static long tuid=0; // to build unique labels in code gen!
    
    
    public ArrayList<GFXVector> list = new ArrayList<>();
    
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
        
        for (GFXVector v : list)
        {
            GFXVector cv = (GFXVector) v.clone();

            // relative is not cloned
            // since if "single" cloned, vectors are not relative anymore!
            cv.relativ = v.relativ; 
            ret.add(cv); 
        }
        // postprocess vector cloning 
        // connections must be set!
        for (int i=0; i< list.size(); i++)
        {
            GFXVector oldv = list.get(i);
            GFXVector newv = ret.list.get(i);
            ret.setCloneStart(newv, oldv.uid_start_connect);
            ret.setCloneEnd(newv, oldv.uid_end_connect);
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
    private void setCloneStart(GFXVector vec, int oldCloneId)
    {
        if (oldCloneId == -1) return;
        for (GFXVector v : list)
        {
            if (v.getOldCloneUID() == oldCloneId)
            {
                vec.uid_start_connect = v.uid;
                vec.start_connect = v;
                vec.start = v.end;
                return;
            }
        }
    }
    private void setCloneEnd(GFXVector vec, int oldCloneId)
    {
        if (oldCloneId == -1) return;
        for (GFXVector v : list)
        {
            if (v.getOldCloneUID() == oldCloneId)
            {
                vec.uid_end_connect = v.uid;
                vec.end_connect = v;
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
        list = new ArrayList<>();
        int errorCode = 0;
//        StringBuilder xmlBuffer = new StringBuilder(xml);
        uid= xmlSupport.getIntElement("id", xml);errorCode|=xmlSupport.errorCode;
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
        setRelativeWherePossible(); // do connected vectors per IDs
        if (errorCode!= 0) return false;
        return true;
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
                v.start = v.start_connect.end;
            v.end_connect = getVectorID(v.uid_end_connect);
            if (v.end_connect != null)
                v.end = v.end_connect.start;
        }           
        for(GFXVector v: list)
        {
            v.setRelativ(((v.uid_end_connect != -1) && (v.uid_start_connect != -1)));
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
        HashMap<String, String> safetyNet = new HashMap<>();
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
                if (vA.start.uid == vB.start.uid)
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
                if (vA.end.uid == vB.end.uid)
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
    
    //
    public void doOrder()
    {
        // there can be actually circles with "startpoint" out of the circle
        // this can happen if more than one vectors are joined at one point!
        HashMap<String, String> safetyNet = new HashMap<>();
        
        ArrayList<GFXVector> newList = new ArrayList<>();
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
            safetyNet = new HashMap<>();
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
    public void fillgaps(boolean doLine)
    {
   
        connectWherePossible(true);
        doOrder();
        ArrayList<GFXVector> newList = new ArrayList<>();
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
                if ((Math.abs(v2.start.x()-v2.end.x()) > 127) || (Math.abs(v2.start.y()-v2.end.y()) > 127) || (Math.abs(v2.start.z()-v2.end.z()) > 127))
                {
                    splitHalf(newList, v2, pos++);
                }
            }
        }
        list = newList;
        
        
        // 2. do all start connects
        newList = new ArrayList<>();
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
                if ((Math.abs(v2.start.x()-v2.end.x()) > 127) || (Math.abs(v2.start.y()-v2.end.y()) > 127) || (Math.abs(v2.start.z()-v2.end.z()) > 127))
                {
                    splitHalf(newList, v2, pos++);
                }
            }
            v.order = pos++;
            newList.add(v);
            
        }
        list = newList;        
    }
    
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
            HashMap<String, String> safetyNet = new HashMap<>();
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
            safetyNet = new HashMap<>();
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
    
    
    
    String hex(int b)
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
        s+="$";
        s+=String.format("%02X",idata);
        return s;
    }
    String hexU(int b)
    {
        String s="";
        int idata = b;
        idata = idata & 0xff;
        s+="$";
        s+=String.format("%02X",idata);
        return s;
    }
    
    // assuming list is ordered
    // and vectors are continuous!
    String getRelativeCoordString(GFXVector v)
    {
        String ret = "";
//        double x = v.end.x() - v.start.x();
//        double y = v.end.y() - v.start.y();
        ret +=hex((int)getRelY(v))+", "+hex((int)getRelX(v));
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
    
    public String createASMMov_Draw_VLc_a(boolean includeMove, String name)
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
        s.append(" DB ").append(hex(count)).append(" ; number of lines to draw\n");

        boolean init = includeMove;
        for (GFXVector v : vl.list)
        {
            if (init)
            {
                init = false;
                s.append(" DB ").append(hex((int)v.start.y())).append(", ").append(hex((int)v.start.x())).append(" ; move to y, x\n");
            }
            s.append(" DB ").append(getRelativeCoordString(v)).append(" ; draw to y, x\n");
            
        }
        String text = s.toString();
        return text;
    }
    
    // if highbyte in a pattern is cleared
    // it is FORCED set!
    public String createASMDraw_VLp(String name)
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
                pattern +=128; // high byte is forcible set!
            }
            s.append(" DB ").append(hexU(pattern)).append(", ");
            s.append(getRelativeCoordString(v));
            if (warn)
                s.append(" ; WARN pattern high byte set!\n");
            else
                s.append(" ; pattern, y, x\n");
                
        }
        s.append(" DB ").append(hexU(1)).append(" ; endmarker (hight byte in pattern not set)\n");
        
        String text = s.toString();
        return text;
    }
    
    public String createASMDraw_VL_mode(String name, boolean includeInitialMove)
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
                s.append(" DB ").append(hexU(0)).append(", ").append(hex((int)v.start.y())).append(", ").append(hex((int)v.start.x())).append(" ; move to y, x\n");
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
            
            
            
            s.append(" DB ").append(hexU(mode)).append(", ");
            s.append(getRelativeCoordString(v));
            s.append(" ; mode, y, x\n");
                
        }
        s.append(" DB ").append(hexU(1)).append(" ; endmarker (1)\n");
        
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
        
        if (nv.end_connect != null)
        {
            nv.end_connect.start_connect = nv;
            nv.end_connect.uid_start_connect = nv.uid;
        }
        
        
        int pos = aList.indexOf(v);
        aList.add(pos+1, nv);
        
        HashMap<String, String> saftyNet = new HashMap<>();
        saftyNet.put(""+v.uid, "");
        saftyNet.put(""+nv.uid, "");

        for (int i=0; i<aList.size(); i++)
        {
            GFXVector vv = aList.get(i);
            if (saftyNet.get(""+vv.uid) != null) continue;
            if (vv.order >= newPos) vv.order++;
        }
    }

    public void splitWhereNeeded()
    {
        int splitValue = 127;
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
        
}
