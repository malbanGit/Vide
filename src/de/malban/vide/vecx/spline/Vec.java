package de.malban.vide.vecx.spline;

import java.util.Comparator;







public class Vec
{
  public static final int DIR_LEFT = 1;
  public static final int DIR_RIGHT = 2;
  private double x;
  private double y;
  
  public Vec(double xComponent, double yComponent)
  {
    this.x = xComponent;
    this.y = yComponent;
  }
  


  public Vec(Pt a, Pt b)
  {
    this(b.getX() - a.getX(), b.getY() - a.getY());
  }
  /*     */   
  public Vec(Pt source) {
    this(source.getX(), source.getY());
  }
  
  public Vec(Vec source) {
    this.x = source.x;
    this.y = source.y;
  }
  



   public static double getAngleBetween(Vec a, Vec b) {
     double a1 = Math.atan2(b.getY(), b.getX());
     double a2 = Math.atan2(a.getY(), a.getX());
     double ret = a1 - a2;
     return ret;
   }


  public Comparator<Vec> sortByAngle_(Vec trueNorth)
  {
    return new Comparator() {
      public int compare(Object aa, Object bb) {  
        int ret = 0;
        Vec a = (Vec)aa;
        Vec b = (Vec)bb;
        double angleA = getAngleBetween(Vec.this, a);
        double angleB = getAngleBetween(Vec.this, b);
        if (angleA < angleB) {
          ret = -1;
        } else if (angleA > angleB) {
          ret = 1;
        }
        return ret;
      }
    };
  }
  
  public double getX() {
    return this.x;
  }
  
  public double getY() {
    return this.y;
  }
  
  public double mag() {
    return Math.sqrt(magSquared());
  }
  
  public double magSquared() {
    return this.x * this.x + this.y * this.y;
  }
  


   public static Pt getEndPoint(Pt pt, Vec vec) {
     return new Pt(pt.getX() + vec.getX(), pt.getY() + vec.getY());
   }
  public Pt add(Pt pt)
  {
    return getEndPoint(pt, this);
  }
   public static Vec getScaledVector(Vec vec, double scaleFactor) {
     double x = vec.getX() * scaleFactor;
     double y = vec.getY() * scaleFactor;
     return new Vec(x, y);
   }
   public static Vec getVectorOfMagnitude(Vec vec, double desiredMag) {
     double current = vec.mag();
     double scaleFactor = desiredMag / current;
     return getScaledVector(vec, scaleFactor);
   }
  
  public Vec getVectorOfMagnitude(double m) {
    return getVectorOfMagnitude(this, m);
  }
  
  public Vec getUnitVector() {
    return getVectorOfMagnitude(1.0D);
  }
  
  public Vec getNormal() {
    return new Vec(this.y, -1.0D * this.x);
  }
  
  public Vec getFlip() {
    return new Vec(-this.x, -this.y);
  }
}


