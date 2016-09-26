package de.malban.vide.veccy.gtest;
// Obj3D.java: A 3D object and its 2D representation.
// Uses: Point2D (Section 1.5), Point3D (Section 3.9),
//       Polygon3D, Input (Section 6.3).

// Copied from Appendix C (discussed in Section 6.3) of
//    Ammeraal, L. (1998) Computer Graphics for Java Programmers,
//       Chichester: John Wiley.

import de.malban.graphics.Face;
import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorList;
import de.malban.graphics.Matrix4x4;
import de.malban.graphics.Vertex;
import static de.malban.vide.veccy.gtest.HLines.CALC_SCALE;
import java.awt.*;
import java.util.*;

class Obj3D 
{  private float rho, d, theta=0.00F, phi=0.00F, rhoMin, rhoMax, 
      xMin, xMax, yMin, yMax, zMin, zMax, v11, v12, v13, v21, 
      v22, v23, v32, v33, v43, xe, ye, ze, objSize;
   private Point2D imgCenter;
   private double sunZ = 1/Math.sqrt(3), sunY = sunZ, sunX = -sunZ,
      inprodMin = 1e30, inprodMax = -1e30, inprodRange;
   private Vector w = new Vector();        // World coordinates
   private Point3D[] e;                    // Eye coordinates
   private Point2D[] vScr;                 // Screen coordinates
   private Vector polyList = new Vector(); // Polygon3D objects

   Vector getPolyList(){return polyList;}
   Point3D[] getE(){return e;}
   Point2D[] getVScr(){return vScr;}
   Point2D getImgCenter(){return imgCenter;}
   float getRho(){return rho;}
   float getD(){return d;}

   
   // expectes CCW (counter clockwise order)
   // for now, I add all polygones both ways
    public boolean setVectorlist(GFXVectorList vlist)
    {
        int pointNo = 1;
        HashMap<Vertex, Integer> noDoubles = new HashMap<Vertex, Integer>();
        HashMap<String, String> noDoublesVectors = new HashMap<String, String>();
        // all "single" points
        CALC_SCALE = 1000;
        for (GFXVector vector: vlist.list)
        {
            Vertex start = vector.start;
            if (start != null)
            {
                if (noDoubles.get(start) == null)
                {
                    noDoubles.put(start, new Integer(pointNo));
                    w.ensureCapacity(pointNo+1);
                    addVertex(pointNo, (float)start.x()*CALC_SCALE, (float)start.y()*CALC_SCALE, (float)start.z()*CALC_SCALE);
                    pointNo++;
                }
            }
            Vertex end = vector.end;
            if (end != null)
            {
                if (noDoubles.get(end) == null)
                {
                    noDoubles.put(end, new Integer(pointNo));
                    w.ensureCapacity(pointNo+1);
                    addVertex(pointNo, (float)end.x()*CALC_SCALE, (float)end.y()*CALC_SCALE, (float)end.z()*CALC_SCALE);
                    pointNo++;
                }
            }
        }
        initRho(); // Origin in center of object.

        // build poligon
        int fno =1;
        ArrayList<Face>faces = vlist.buildFacelist();
        for (Face face: faces)
        {
            Vector vnrs = new Vector();
            String vectorId = "";
            for (int i=0; i< face.vertice.size(); i++)
            {
                Vertex vertex = face.vertice.get(i);
                pointNo = noDoubles.get(vertex);
                vnrs.addElement(new Integer(pointNo)); 
                if (vectorId.length() == 0)
                {
                    vectorId+=vertex.uid+" ";
                }
                else
                {
                    vectorId+=vertex.uid+" ";
                    noDoublesVectors.put(vectorId, vectorId);
                    vectorId=vertex.uid+" ";
                }
            }
            polyList.addElement(new Polygon3D(vnrs));

            // add all poylogons clock and anti clockwise
            vnrs = new Vector();
            for (int i=face.vertice.size()-1; i>=0; i--)
            {
                Vertex vertex = face.vertice.get(i);
                pointNo = noDoubles.get(vertex);
                vnrs.addElement(new Integer(pointNo)); 
                if (vectorId.length() == 0)
                {
                    vectorId+=vertex.uid+" ";
                }
                else
                {
                    vectorId+=vertex.uid+" ";
                    noDoublesVectors.put(vectorId, vectorId);
                    vectorId=vertex.uid+" ";
                }
            }
            polyList.addElement(new Polygon3D(vnrs));
        }
        
        // add all NON face vectors also as a 2point polygon!
        for (GFXVector vector: vlist.list)
        {
            String vectorId = "";
            Vector vnrs = new Vector();
            Vertex start = vector.start;
            if (start != null)
            {
                vectorId+=start.uid+" ";
            }
            Vertex end = vector.end;
            if (end != null)
            {
                vectorId+=end.uid+" ";
            }
            if (noDoublesVectors.get(vectorId) != null) 
                continue;
            if (start != null)
            {
                vectorId+=start.uid+" ";
                pointNo = noDoubles.get(start);
                vnrs.addElement(new Integer(pointNo)); 
            }
            if (end != null)
            {
                pointNo = noDoubles.get(end);
                vnrs.addElement(new Integer(pointNo)); 
            }
            polyList.addElement(new Polygon3D(vnrs));
        }        
        return true;
    }

   private void addVertex(int i, float x, float y, float z)
   {  if (x < xMin) xMin = x; if (x > xMax) xMax = x;
      if (y < yMin) yMin = y; if (y > yMax) yMax = y;
      if (z < zMin) zMin = z; if (z > zMax) zMax = z;
      if (i >= w.size()) w.setSize(i + 1);
      w.setElementAt(new Point3D(x, y, z), i);
   }

   // rho is a meaure of the distance
   // of the viewer to the object
   // I take rho = max, to sort of eleminate perspective
   private void initRho()
   {  
      float dx = xMax - xMin, dy = yMax - yMin, dz = zMax - zMin;
      rhoMin = 0.6F * (float) Math.sqrt(dx * dx + dy * dy + dz * dz);
      rhoMax = 10000 * rhoMin;
      rho = 3 * rhoMin;
      rho =  rhoMin;
      rho = rhoMax;
   }

   float eyeAndScreen(Dimension dim, boolean isPaint)
      // Called in paint method of Canvas class
   {  
      int n = w.size();
      e = new Point3D[n];
      vScr = new Point2D[n];
      float xScrMin=1e30F, xScrMax=-1e30F, 
            yScrMin=1e30F, yScrMax=-1e30F;
      for (int i=1; i<n; i++)
      {  Point3D P = (Point3D)(w.elementAt(i));
         if (P == null)
         {  
             e[i] = null; vScr[i] = null;
         }  
         else
         {  
            float x = P.y;
            float y = -P.x;
            float z = P.z -rho;

            Point3D Pe = e[i] = new Point3D(x, y, z);
            float xScr = -Pe.x/-rho, yScr = -Pe.y/-rho;
            vScr[i] = new Point2D(xScr, yScr);
            if (xScr < xScrMin) xScrMin = xScr;
            if (xScr > xScrMax) xScrMax = xScr;
            if (yScr < yScrMin) yScrMin = yScr;
            if (yScr > yScrMax) yScrMax = yScr;
         }
      } 
      float rangeX = xScrMax - xScrMin, rangeY = yScrMax - yScrMin;

      d = 1.00F * Math.min(dim.width/rangeX, dim.height/rangeY);
      imgCenter = new Point2D(d * (xScrMin + xScrMax)/2, 
                              d * (yScrMin + yScrMax)/2);
      for (int i=1; i<n; i++)
      { 
         if (vScr[i] != null){vScr[i].x *= d; vScr[i].y *= d;}
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

}
