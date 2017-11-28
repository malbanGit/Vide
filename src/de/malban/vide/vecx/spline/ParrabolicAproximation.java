/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.spline;

import de.malban.graphics.SingleVectorPanel;
import java.awt.Point;
import java.util.ArrayList;

/**
 * http://www.arndt-bruenner.de/mathe/10/parabeldurchdreipunkte.htm
 * @author malban
 */
public class ParrabolicAproximation {
    
   public static final int RESOLUTION = 10;
   public static ArrayList<Pt> getAproximation(ArrayList<Point> pList)
    {
        ArrayList<Point> ret = new ArrayList<Point>();
        
        for (int i=0;i<pList.size()-2; i++)
        {
            addParabolicPoints12(ret, pList.get(i), pList.get(i+1), pList.get(i+2));
        }
        addParabolicPoints23(ret, pList.get(pList.size()-3),pList.get(pList.size()-2), pList.get(pList.size()-1));
        
        // the öast two must be gotten manually
        
        return convertArray(ret);
    }
    static ArrayList<Pt> convertArray(ArrayList<Point> pList)
    {
        ArrayList<Pt> pt = new ArrayList<Pt>();
        for(Point p: pList)
        {
            pt.add(new Pt(p.x,p.y));
        }
        return pt;
    }
    
    static void addParabolicPoints12(ArrayList<Point> ret, Point p1 , Point p2, Point p3)
    {
        double x1 = p1.x;
        double x2 = p2.x;
        double x3 = p3.x;
        double y1 = p1.y;
        double y2 = p2.y;
        double y3 = p3.y;
        
        double x1s = x1*x1;
        double x2s = x2*x2;
        double x3s = x3*x3;
        
        // steps 
        double d = (int) Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))/100.0;
        double a = (x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2))/((x1-x2)*(x1-x3)*(x3-x2));
        double b = (x1s*(y2-y3)+x2s*(y3-y1)+x3s*(y1-y2))/((x1-x2)*(x1-x3)*(x2-x3));
        double c = (x1s*(x2*y3-x3*y2)+x1*(x3s*y2-x2s*y3)+x2*x3*y1*(x2-x3))/((x1-x2)*(x1-x3)*(x2-x3));
        
        if (x2<x1) 
        {
            for (double i=x1;i>x2;i-=d)
            {
                //  f(x) = ax² + bx + c
                int newY = (int) (a*(i*i) + b*i + c);
                ret.add(new Point((int) i, newY));
            }
            
        }
        else
        {
            for (double i=x1;i<x2;i+=d)
            {
                //  f(x) = ax² + bx + c
                int newY = (int) (a*(i*i) + b*i + c);
                ret.add(new Point((int) i, newY));
            }
        }
        
    }
    static void addParabolicPoints23(ArrayList<Point> ret, Point p1 , Point p2, Point p3)
    {
        double x1 = p1.x;
        double x2 = p2.x;
        double x3 = p3.x;
        double y1 = p1.y;
        double y2 = p2.y;
        double y3 = p3.y;
        
        double x1s = x1*x1;
        double x2s = x2*x2;
        double x3s = x3*x3;
        
        // steps 
        double d = (int) Math.sqrt((x2-x3)*(x2-x3)+(y2-y3)*(y2-y3))/100.0;
        double a = (x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2))/((x1-x2)*(x1-x3)*(x3-x2));
        double b = (x1s*(y2-y3)+x2s*(y3-y1)+x3s*(y1-y2))/((x1-x2)*(x1-x3)*(x2-x3));
        double c = (x1s*(x2*y3-x3*y2)+x1*(x3s*y2-x2s*y3)+x2*x3*y1*(x2-x3))/((x1-x2)*(x1-x3)*(x2-x3));
        

        if (x3<x2) 
        {
            for (double i=x2;i>x3;i-=d)
            {
                //  f(x) = ax² + bx + c
                int newY = (int) (a*(i*i) + b*i + c);
                ret.add(new Point((int) i, newY));
            }
            
        }
        else
        {
            for (double i=x2;i<x3;i+=d)
            {
                //  f(x) = ax² + bx + c
                int newY = (int) (a*(i*i) + b*i + c);
                ret.add(new Point((int) i, newY));
            }
        }        
        
    }
}
