package de.malban.gtest;
// Obj3D.java: A 3D object and its 2D representation.
// Uses: Point2D (Section 1.5), Point3D (Section 3.9),
//       Polygon3D, Input (Section 6.3).

// Copied from Appendix C (discussed in Section 6.3) of
//    Ammeraal, L. (1998) Computer Graphics for Java Programmers,
//       Chichester: John Wiley.

import java.awt.*;
import java.util.*;

class Obj3D 
{  private float rho, d, theta=0.30F, phi=1.3F, rhoMin, rhoMax, 
      xMin, xMax, yMin, yMax, zMin, zMax, v11, v12, v13, v21, 
      v22, v23, v32, v33, v43, xe, ye, ze, objSize;
   private Point2D imgCenter;
   private double sunZ = 1/Math.sqrt(3), sunY = sunZ, sunX = -sunZ,
      inprodMin = 1e30, inprodMax = -1e30, inprodRange;
   private Vector w = new Vector();        // World coordinates
   private Point3D[] e;                    // Eye coordinates
   private Point2D[] vScr;                 // Screen coordinates
   private Vector polyList = new Vector(); // Polygon3D objects
   private String fName = "";              // File name
   
   boolean read(String fName)
   {  Input inp = new Input(fName);
      if (inp.fails())return failing();
      this.fName = fName;
      xMin = yMin = zMin = +1e30F;
      xMax = yMax = zMax = -1e30F;
      return readObject(inp); // Read from inp into obj
   }

   Vector getPolyList(){return polyList;}
   String getFName(){return fName;}
   Point3D[] getE(){return e;}
   Point2D[] getVScr(){return vScr;}
   Point2D getImgCenter(){return imgCenter;}
   float getRho(){return rho;}
   float getD(){return d;}

   private boolean failing()
   {  Toolkit.getDefaultToolkit().beep();
      return false;
   }

   private boolean readObject(Input inp)
   {  for (;;)
      {  int i = inp.readInt();
         if (inp.fails()){inp.clear(); break;} 
         if (i < 0)
         {  System.out.println(
               "Negative vertex number in first part of input file");
            return failing();
         }
         w.ensureCapacity(i + 1);
         float x = inp.readFloat(), 
               y = inp.readFloat(), 
               z = inp.readFloat();
         addVertex(i, x, y, z);
      }
      shiftToOrigin(); // Origin in center of object.
      char ch; 
      int count = 0;
      do   // Skip the line "Faces:"
      {  ch = inp.readChar(); count++;
      }  while (!inp.eof() && ch != '\n');
      if (count < 6 || count > 8)
      {  System.out.println("Invalid input file"); return failing();
      }
      // Build polygon list:
      for (;;)
      {  Vector vnrs = new Vector();
         for (;;)
         {  int i = inp.readInt();
            if (inp.fails()){inp.clear(); break;} 
            int absi = Math.abs(i);
            if (i == 0 || absi >= w.size() || 
               w.elementAt(absi) == null)
            {  System.out.println("Invalid vertex number: " + absi +
               " must be defined, nonzero and less than " + w.size());
               return failing();
            }
            vnrs.addElement(new Integer(i)); 
         }
         ch = inp.readChar();
         if (ch != '.' && ch != '#') break;
         // Ignore input lines with only one vertex number:
         if (vnrs.size() >= 2)
            polyList.addElement(new Polygon3D(vnrs));
      }
      inp.close();
      return true;
   }

   private void addVertex(int i, float x, float y, float z)
   {  if (x < xMin) xMin = x; if (x > xMax) xMax = x;
      if (y < yMin) yMin = y; if (y > yMax) yMax = y;
      if (z < zMin) zMin = z; if (z > zMax) zMax = z;
      if (i >= w.size()) w.setSize(i + 1);
      w.setElementAt(new Point3D(x, y, z), i);
   }

   private void shiftToOrigin()
   {  float xwC = 0.5F * (xMin + xMax),
            ywC = 0.5F * (yMin + yMax),
            zwC = 0.5F * (zMin + zMax);
      int n = w.size();
      for (int i=1; i<n; i++)
         if (w.elementAt(i) != null)
         {  ((Point3D)w.elementAt(i)).x -= xwC;
            ((Point3D)w.elementAt(i)).y -= ywC;
            ((Point3D)w.elementAt(i)).z -= zwC;
         }
      float dx = xMax - xMin, dy = yMax - yMin, dz = zMax - zMin;
      rhoMin = 0.6F * (float) Math.sqrt(dx * dx + dy * dy + dz * dz);
      rhoMax = 1000 * rhoMin;
      rho = 3 * rhoMin;
   }

   private void initPersp()
   {  float costh = (float)Math.cos(theta), 
            sinth = (float)Math.sin(theta),
            cosph = (float)Math.cos(phi), 
            sinph = (float)Math.sin(phi);
      v11 = -sinth;   v12 = -cosph * costh;   v13 = sinph * costh;
      v21 = costh;    v22 = -cosph * sinth;   v23 = sinph * sinth; 
                      v32 = sinph;            v33 = cosph; 
                                              v43 = -rho;  
   } 

   float eyeAndScreen(Dimension dim)
      // Called in paint method of Canvas class
   {  initPersp();
      int n = w.size();
      e = new Point3D[n];
      vScr = new Point2D[n];
      float xScrMin=1e30F, xScrMax=-1e30F, 
            yScrMin=1e30F, yScrMax=-1e30F;
      for (int i=1; i<n; i++)
      {  Point3D P = (Point3D)(w.elementAt(i));
         if (P == null)
         {  e[i] = null; vScr[i] = null;
         }  
         else
         {  float x = v11 * P.x + v21 * P.y;
            float y = v12 * P.x + v22 * P.y + v32 * P.z;
            float z = v13 * P.x + v23 * P.y + v33 * P.z + v43;
            Point3D Pe = e[i] = new Point3D(x, y, z);
            float xScr = -Pe.x/Pe.z, yScr = -Pe.y/Pe.z;
            vScr[i] = new Point2D(xScr, yScr);
            if (xScr < xScrMin) xScrMin = xScr;
            if (xScr > xScrMax) xScrMax = xScr;
            if (yScr < yScrMin) yScrMin = yScr;
            if (yScr > yScrMax) yScrMax = yScr;
         }
      } 
      float rangeX = xScrMax - xScrMin, rangeY = yScrMax - yScrMin;
      d = 0.95F * Math.min(dim.width/rangeX, dim.height/rangeY);
      imgCenter = new Point2D(d * (xScrMin + xScrMax)/2, 
                              d * (yScrMin + yScrMax)/2);
      for (int i=1; i<n; i++)
      {  if (vScr[i] != null){vScr[i].x *= d; vScr[i].y *= d;}
      }
      return d * Math.max(rangeX, rangeY); 
      // Maximum screen-coordinate range used in CvHLines for HP-GL
   }

   void planeCoeff()
   {  int nFaces = polyList.size();

      for (int j=0; j<nFaces; j++)
      {  Polygon3D pol = (Polygon3D)(polyList.elementAt(j));
         int[] nrs = pol.getNrs();
         if (nrs.length < 3) continue;
         int iA = Math.abs(nrs[0]), // Possibly negative
             iB = Math.abs(nrs[1]), // for HLines.
             iC = Math.abs(nrs[2]);
         Point3D A = e[iA], B = e[iB], C = e[iC];
         double
            u1 = B.x - A.x, u2 = B.y - A.y, u3 = B.z - A.z,
            v1 = C.x - A.x, v2 = C.y - A.y, v3 = C.z - A.z,
            a = u2 * v3 - u3 * v2, 
            b = u3 * v1 - u1 * v3,
            c = u1 * v2 - u2 * v1,
            len = Math.sqrt(a * a + b * b + c * c), h;
            a /= len; b /= len; c /= len;
            h = a * A.x + b * A.y + c * A.z;
         pol.setAbch(a, b, c, h);
         Point2D A1 = vScr[iA], B1 = vScr[iB], C1 = vScr[iC];
         u1 = B1.x - A1.x; u2 = B1.y - A1.y;
         v1 = C1.x - A1.x; v2 = C1.y - A1.y;
         if (u1 * v2 - u2 * v1 <= 0) continue; // backface
         double inprod = a * sunX + b * sunY + c * sunZ;
         if (inprod < inprodMin) inprodMin = inprod;
         if (inprod > inprodMax) inprodMax = inprod;
      }
      inprodRange = inprodMax - inprodMin;
   }

   boolean vp(Canvas cv, float dTheta, float dPhi, float fRho) 
   {  theta += dTheta;
      phi += dPhi;
      float rhoNew = fRho * rho;
      if (rhoNew >= rhoMin && rhoNew <= rhoMax) 
         rho = rhoNew;
      else 
         return false;
      cv.repaint();
      return true;
   }

   int colorCode(double a, double b, double c)
   {  double inprod = a * sunX + b * sunY + c * sunZ;
      return (int)Math.round(
         ((inprod - inprodMin)/inprodRange) * 255);
   }
}
