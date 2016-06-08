package de.malban.vide.vecx.spline;

import java.awt.event.MouseEvent;
import java.awt.geom.Point2D;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;







public class Pt extends Point2D.Double implements Comparable<Pt>
{
   public static double EQ_TOL = 1.0E-5D;
  public static int ID_COUNTER = 0;
  
  protected long time;
  protected Map<String, Object> attribs;
  protected final int id = ID_COUNTER++;
  
  public Pt()
  {
    this.attribs = new HashMap();
  }
  
  public Pt(int x, int y) {
    this((double)x, (double)y);
  }
  
  public Pt(double x, double y) {
    this(x, y, 0L);
  }
  
  public Pt(Vec direction) {
    this(direction.getX(), direction.getY());
  }
  
  public Pt(MouseEvent ev) {
    this(ev.getPoint().getX(), ev.getPoint().getY(), ev.getWhen());
  }
  
  public Pt(double x, double y, long time) {
    super(x, y);
    this.time = time;
  }
  
  public Pt(Point2D source, long time)
  {
    this(source.getX(), source.getY(), time);
  }
  
  public int getID() {
    return this.id;
  }
  
  public Map<String, Object> getAttribs() {
    if (this.attribs == null) {
      this.attribs = new HashMap();
    }
    return this.attribs;
  }
  


  public void scale(double amt)
  {
    setLocation(getX() * amt, getY() * amt);
  }
  
  public Pt getScaled(double amt) {
    return new Pt(getX() * amt, getY() * amt);
  }
  
  public int compareTo(Pt other) {
    if (getTime() < other.getTime())
      return -1;
    if (getTime() > other.getTime())
      return 1;
    return 0;
  }
  
  public boolean isSameLocation(Pt other)
  {
    return (Math.abs(getX() - other.getX()) < EQ_TOL) && (Math.abs(getY() - other.getY()) < EQ_TOL);
  }
  
  public static Comparator<Pt> sortByX() 
  {
    return new Comparator() {
      public int compare(Object aa, Object bb) {
        int ret = 0;
        Pt a = (Pt)aa;
        Pt b = (Pt)bb;
        if (a.getX() < b.getX()) {
          ret = -1;
        } else if (a.getX() > b.getX()) {
          ret = 1;

        }
        else if (a.getY() > b.getY()) {
          ret = 1;
        } else {
          ret = -1;
        }
        
        return ret;
      }
      
      public boolean equals(Object obj) {
        return false;
      }
    };
  }
  
  public int ix() {
    return (int)getX();
  }
  
  public int iy() {
    return (int)getY();
  }
  
   public static boolean eq(Pt a, Pt b, double tolerance)
   {
     double xOk = Math.abs(a.getX() - b.getX());
     double yOk = Math.abs(a.getY() - b.getY());
     return (xOk < tolerance) && (yOk < tolerance);
   }

  public boolean equals(Pt other)
  {
    if (other.compareTo(this) == 0) {} boolean basic =  eq(this, other, EQ_TOL);
    boolean advanced = basic ? getAttribs().equals(other.getAttribs()) : false;
    
    return (basic) && (advanced);
  }
  

  public Pt copy()
  {
    Pt twin = new Pt(getX(), getY(), getTime());
    if (this.attribs == null) {
      twin.attribs = null;
    } else {
      twin.attribs = ((HashMap)((HashMap)this.attribs).clone());
    }
    return twin;
  }
  
  public final void setTime(long time) {
    this.time = time;
  }
  
  public long getTime() {
    return this.time;
  }
  
  public void setAttribute(String name, Object value) {
    getAttribs().put(name, value);
  }
  
  public void setBoolean(String name, boolean value) {
    getAttribs().put(name, Boolean.valueOf(value));
  }
  
  public boolean getBoolean(String name) {
    return (getAttribs().containsKey(name)) && (((Boolean)getAttribute(name)).booleanValue());
  }
  


  public void setDouble(String name, double value)
  {
    getAttribs().put(name, value);
  }
  
  public void setString(String name, String value) {
    getAttribs().put(name, value);
  }
  
  public boolean hasAttribute(String name) {
    return getAttribs().containsKey(name);
  }
  
  public Object getAttribute(String name) {
    return getAttribs().get(name);
  }
  
  public void removeAttribute(String name) {
    getAttribs().remove(name);
  }
  
  public Vec getVec(String name) {
    return (Vec)getAttribute(name);
  }
  
  public void setVec(String name, Vec value) {
    setAttribute(name, value);
  }
  
  public double getDouble(String name) {
    Object shouldBeDouble = getAttribute(name);
    return (double)((java.lang.Double)shouldBeDouble);
  }
  
  public String getString(String name) {
    return (String)getAttribute(name);
  }
  
  public void setMap(String name, Map<?, ?> value) {
    getAttribs().put(name, value);
  }
  
  public Map<?, ?> getMap(String name) {
    return (Map)getAttribute(name);
  }
  
  public void setList(String name, List<?> value) {
    getAttribs().put(name, value);
  }
  
  public List<?> getList(String name) {
    return (List)getAttribute(name);
  }
}



