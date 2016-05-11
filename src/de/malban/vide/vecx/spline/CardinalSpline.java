/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.vide.vecx.spline;

import de.malban.vide.VideConfig;
import java.awt.Graphics2D;
import java.awt.geom.Ellipse2D;
import static java.lang.Math.pow;
import java.util.ArrayList;
import java.util.List;

/**
 * // see: http://johnsogg.blogspot.de/2010/01/cardinal-splines-and-catmull-rom.html
 * @author Malban
 */
public final class CardinalSpline  
{
  static VideConfig config = VideConfig.getConfig();
  private List<Pt> points;
  private List<Pt> interp;
  double tightness;

  public CardinalSpline() {
    setPoints(new ArrayList<>());
    this.interp = new ArrayList<>();
    setTightness(1);
  }

  public ArrayList<Pt> getPoints()
  {
      return (ArrayList<Pt>)this.interp;
  }
  
  public void setPoints(List<Pt> data) {
    this.points = data;
  }

  public void addPoint(Pt pt) 
  {
    points.add(pt);
  }
  String pl(List<Pt> pts)
  {
      StringBuilder ret = new StringBuilder();
      double xold=0;
      for (Pt p: pts)
      {
          ret.append(p.x).append(",").append(p.y).append("->");
          xold = p.x;
      }
      return ret.toString();
  }
  
  public void caculate() 
  {
//    System.out.println("In " + pl(points));  
    CardinalSpline.calculateSlopesCardinal(points, tightness);
    CardinalSpline.interpolateCardinal(interp, points);
//    System.out.println("Out " + pl(interp));  
  }

  public static double h1(double t) {
    return (2 * pow(t, 3) - 3 * pow(t, 2) + 1);
  }

  public static double h2(double t) {
    return (pow(t, 3) - 2 * pow(t, 2) + t);
  }

  public static double h3(double t) {
    return (-2 * pow(t, 3) + 3 * pow(t, 2));
  }

  public static double h4(double t) {
    return (pow(t, 3) - pow(t, 2));
  }

  public static void calculateSlopesCardinal(List<Pt> points, double tightness) {
    // calculate the tangent vector passing through each point. The magnitude will be somewhere
    // between zero and half the distance between the surrounding points.
    for (int i = 1; i < points.size() - 1; i++) 
    {
      Vec d = new Vec(points.get(i - 1), points.get(i + 1));
      Vec slope = d.getVectorOfMagnitude(tightness * (d.mag() / 2));
      points.get(i).setVec("slope", slope);
    }
    // don't forget the start/end points.
    if (points.size() > 2) {
      Pt first = points.get(0);
      Pt last = points.get(points.size() - 1);
      Vec d = new Vec(first, points.get(1));
      first.setVec("slope", d.getVectorOfMagnitude(tightness * (d.mag() / 2)));
      d = new Vec(points.get(points.size() - 2), last);
      last.setVec("slope", d.getVectorOfMagnitude(tightness * (d.mag() / 2)));
    }
  }

  public static void interpolateCardinal(List<Pt> interpolatedPoints, List<Pt> controlPoints) {
    interpolatedPoints.clear();
    for (int i = 0; i < controlPoints.size() - 1; i++) {
      interpolatedPoints.addAll(CardinalSpline.interpolateCardinalPatch(controlPoints.get(i),
          controlPoints.get(i + 1)));
    }
  }

  public static List<Pt> interpolateCardinalPatch(Pt a, Pt b) 
  {
        List<Pt> ret = new ArrayList<Pt>();
        Vec m0 = a.getVec("slope");
        Vec m1 = b.getVec("slope");
        
        // distance between the to points
        double c =Math.sqrt((a.x-b.x)*(a.x-b.x)+(a.y-b.y)*(a.y-b.y));
        
        // how strict do we want to "curve"
        int distance = (int)c / (config.splineDensity*100);
        if (distance<3) distance = 3;
//        distance = 20;
        if (m0 != null && m1 != null) 
        {
            for (int i = 0; i < distance; i++) 
            {
                double t = (double) i / ((double)distance);
                double x = a.x * h1(t) + m0.getX() * h2(t) + b.x * h3(t) + m1.getX() * h4(t);
                double y = a.y * h1(t) + m0.getY() * h2(t) + b.y * h3(t) + m1.getY() * h4(t);
                if ((!(Double.isNaN(x))) && (!(Double.isNaN(y))))
                    ret.add(new Pt(x, y));
            }
        }
        return ret;
  }

  public void setTightness(final double tightness) {
    if (tightness < 0 || tightness > 1) {
     // bug("calculateDirections(" + Debug.num(tightness) + "): input parameter should be in [0..1].");
    }
        CardinalSpline.this.tightness = tightness;
        CardinalSpline.calculateSlopesCardinal(points, tightness);
        CardinalSpline.interpolateCardinal(interp, points);
  }

  public static void bug(String what) {
    System.out.println("CatmullRom: "+ what);
  }

}