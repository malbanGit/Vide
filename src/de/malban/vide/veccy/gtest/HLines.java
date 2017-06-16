package de.malban.vide.veccy.gtest;
// HLines.java: Perspective drawing with hidden-line elimination.
// Uses: Point2D (Section 1.5), Point3D (Section 3.9), 
//       Tools2D (Section 2.13),
//       Obj3D, Input, Polygon3D, Tria (Section 6.3).

// Copied from Appendix D (discussed in Chapter 7) of
//    Ammeraal, L. (1998) Computer Graphics for Java Programmers,
//       Chichester: John Wiley.

import de.malban.graphics.GFXVector;
import de.malban.graphics.GFXVectorList;
import de.malban.graphics.Vertex;
import java.awt.*;
import java.util.*;

public class HLines 
{  
    public static int CALC_SCALE = 1000;
   
   private int maxX, maxY, centerX, centerY, nTria, nVertices;
   private Obj3D obj;    
   private Point2D imgCenter;
   private Tria[] tr;
   private int[] refPol;
   private int[][] connect;
   private int[] nConnect;
   private int chunkSize = 4;
   private double hLimit;
   private Vector polyList;

   Obj3D getObj(){return obj;}
   void setObj(Obj3D obj){this.obj = obj;}
   
   public HLines()
   {  
   }
/*
    public boolean setVectorlist(GFXVectorList vlist)
    {
        Obj3D obj = new Obj3D();
        obj.setVectorlist(vlist);
        setObj(obj);
        return true;
    }
   */
    public GFXVectorList processVectorlist(GFXVectorList vlist)
    {
        vlist = vlist.clone();
        HashMap<Vertex, Vertex> safety = new HashMap<Vertex, Vertex>();
        for (GFXVector vector: vlist.list)
        {
            Vertex start = vector.start;
            if (start != null)
            {
                if (safety.get(start) == null)
                {
                    start.z(-start.z());
                    safety.put(start, start);
                }
            }
            Vertex end = vector.end;
            if (end != null)
            {
                if (safety.get(end) == null)
                {
                    end.z(-end.z());
                    safety.put(end, end);
                }
            }
        }        
        
        GFXVectorList vl = new GFXVectorList();
        Obj3D obj = new Obj3D();
        obj.setVectorlist(vlist);
        setObj(obj);
        process(vl); 
        
        for (GFXVector vector: vl.list)
        {
            Vertex start = vector.start;
            if (start != null)
            {
                start.x(((int)(start.x()/CALC_SCALE)));
                start.y(((int)(start.y()/CALC_SCALE)));
                start.z(((int)(start.z()/CALC_SCALE)));
            }
            Vertex end = vector.end;
            if (end != null)
            {
                end.x(((int)(end.x()/CALC_SCALE)));
                end.y(((int)(end.y()/CALC_SCALE)));
                end.z(((int)(end.z()/CALC_SCALE)));
            }
        }        
        vl.removePoints(false);
        vl.removeDoubles();
        vl.doOrder();
        vl.connectWherePossible(false);
        return vl;
    }

   public void process(GFXVectorList vl)    
   {
       if (obj == null) return;
      Vector polyList = obj.getPolyList();
      if (polyList == null) return;
      int nFaces = polyList.size();
      if (nFaces == 0) return;
      float xe, ye, ze;
      Dimension dim = new Dimension();
      dim.width = HLines.CALC_SCALE;
      dim.height = HLines.CALC_SCALE;
      maxX = dim.width - 1; maxY = dim.height - 1;
      centerX = maxX/2; centerY = maxY/2;
      // ze-axis towards eye, so ze-coordinates of
      // object points are all negative. Since screen
      // coordinates x and y are used to interpolate for
      // the z-direction, we have to deal with 1/z instead
      // of z. With negative z, a small value of 1/z means
      // a small value of |z| for a nearby point. 

      // obj is a java object that contains all data,
      // with w, e and vScr parallel (with vertex numbers
      // as index values):
      // - Vector w (with Point3D elements)
      // - Array e (with Point3D elements)
      // - Array vScr (with Point2D elements)
      // - Vector polyList (with Polygon3D elements)

      // Every Polygon3D value contains:
      // - Array 'nrs' for vertex numbers (n elements)
      // - Values a, b, c, h for the plane ax+by+cz=h.
      // - Array t (with n-2 elements of type Tria)

      // Every Tria value consists of the three vertex
      // numbers A, B and C.
      obj.eyeAndScreen(dim, false);
      imgCenter = obj.getImgCenter();
      obj.planeCoeff();      // Compute a, b, c and h.

      hLimit = -1e-6 * obj.getRho(); 
   
      buildLineSet();

      // Construct an array of triangles in
      // each polygon and count the total number 
      // of triangles. 
      nTria = 0;
      for (int j=0; j<nFaces; j++)
      {  Polygon3D pol = (Polygon3D)(polyList.elementAt(j));
         if (pol.getNrs().length > 2 && pol.getH() <= hLimit) 
         {  pol.triangulate(obj); 
            nTria += pol.getT().length;
         }

      }
      tr = new Tria[nTria];    // Triangles of all polygons
      refPol = new int[nTria]; // tr[i] belongs to polygon refPol[i]
      int iTria = 0;

      for (int j=0; j<nFaces; j++)
      {  Polygon3D pol = (Polygon3D)(polyList.elementAt(j));
         Tria[] t = pol.getT(); // Triangles of one polygon
         if (pol.getNrs().length > 2 && pol.getH() <= hLimit) 
         {  for (int i=0; i<t.length; i++)
            {  Tria tri = t[i];
               tr[iTria] = tri;
               refPol[iTria++] = j;
            }
         }
      }
      
      Point3D[] e = obj.getE();
      Point2D[] vScr = obj.getVScr();
      for (int i=0; i<nVertices; i++)
      {  for (int j=0; j<nConnect[i]; j++)
         {  int jj = connect[i][j];
            lineSegment(e[i], e[jj], vScr[i], vScr[jj], i, jj, 0, vl);
         }
      }
      
      
        HashMap<Vertex, Integer> noDoubles = new HashMap<Vertex, Integer>();
      float unscaler = obj.getD();
        for (GFXVector vector: vl.list)
        {
            Vertex start = vector.start;
            if (start != null)
            {
                if (noDoubles.get(start) == null)
                {
                    noDoubles.put(start, new Integer(1));
                    double x = -start.y()/obj.getD()*obj.getRho();
                    double y = start.x()/obj.getD()*obj.getRho();
                   start.x(x);
                   start.y(y);
                }
            }
            Vertex end = vector.end;
            if (end != null)
            {
                if (noDoubles.get(end) == null)
                {
                    noDoubles.put(end, new Integer(1));
                    double x = -end.y()/obj.getD()*obj.getRho();
                    double y = end.x()/obj.getD()*obj.getRho();
                   end.x(x);
                   end.y(y);
                }
            }
        }      
      
   }
   private void buildLineSet()
   {  // Build the array
      // 'connect' of int arrays, where
      // connect[i] is the array of all
      // vertex numbers j, such that connect[i][j] is
      // an edge of the 3D object.
      polyList = obj.getPolyList();
      nVertices = obj.getVScr().length;
      connect = new int[nVertices][];
      nConnect = new int[nVertices];
      for (int i=0; i<nVertices; i++)
      nConnect[i] = 0;
      int nFaces = polyList.size();

      for (int j=0; j<nFaces; j++)
      {  Polygon3D pol = (Polygon3D)(polyList.elementAt(j));
         int[] nrs = pol.getNrs();
         int n = nrs.length;
         if (n > 2 && pol.getH() > 0) continue;  
         int ii = Math.abs(nrs[n-1]);
         for (int k=0; k<n; k++)
         {  int jj = nrs[k];
            if (jj < 0)
               jj = -jj; // abs
            else
            {  int i1 = Math.min(ii, jj), j1 = Math.max(ii, jj),
                   nCon = nConnect[i1];
               // Look if j1 is already present:
               int l;
               for (l=0; l<nCon; l++) if (connect[i1][l] == j1) break;
               if (l == nCon)  // Not found:
               {  if (nCon % chunkSize == 0)
                  {  int[] temp = new int[nCon + chunkSize];
                     for (l=0; l<nCon; l++) temp[l] = connect[i1][l];
                     connect[i1] = temp;
                  }   
                  connect[i1][nConnect[i1]++] = j1;
               }
            }
            ii = jj;
         }
      }
   }
   
   int iX(float x){return Math.round(centerX + x - imgCenter.x);}
   int iY(float y){return Math.round(centerY - y + imgCenter.y);}

   private void lineSegment(Point3D Pe, Point3D Qe,
      Point2D PScr, Point2D QScr, int iP, int iQ, int iStart, GFXVectorList vl)
   {  double u1 = QScr.x - PScr.x, u2 = QScr.y - PScr.y;
      double minPQx = Math.min(PScr.x, QScr.x);
      double maxPQx = Math.max(PScr.x, QScr.x);
      double minPQy = Math.min(PScr.y, QScr.y);
      double maxPQy = Math.max(PScr.y, QScr.y);
      double zP = Pe.z, zQ = Qe.z;
      double minPQz = Math.min(zP, zQ);
      Point3D[] e = obj.getE();
      Point2D[] vScr = obj.getVScr();

      for (int i=iStart; i<nTria; i++)
      {  Tria t = tr[i];
         int iA = t.iA, iB = t.iB, iC = t.iC;
         Point2D AScr = vScr[iA], BScr = vScr[iB], CScr = vScr[iC];

         // 1. Minimax test for x and y screen coordinates:
         if (maxPQx <= AScr.x && maxPQx <= BScr.x && maxPQx <= CScr.x 
          || minPQx >= AScr.x && minPQx >= BScr.x && minPQx >= CScr.x
          || maxPQy <= AScr.y && maxPQy <= BScr.y && maxPQy <= CScr.y
          || minPQy >= AScr.y && minPQy >= BScr.y && minPQy >= CScr.y)
             continue;

         // 2. Test if PQ is an edge of ABC:
         if ((iP == iA || iP == iB || iP == iC) &&
             (iQ == iA || iQ == iB || iQ == iC)) continue;

         // 3. Test if PQ is clearly nearer than ABC:
         Point3D Ae = e[iA], Be = e[iB], Ce = e[iC];
         double zA = Ae.z, zB = Be.z, zC = Ce.z;
         if (minPQz >= zA && minPQz >= zB && minPQz >= zC) continue;

         // 4. Do P and Q (in 2D) lie in a half plane defined
         //    by line AB, on the side other than that of C?
         //    Similar for the edges BC and CA.
         double eps = 0.001; // Relative to numbers of pixels
         if ((Tools2D.area2(AScr, BScr, PScr) < eps &&  Tools2D.area2(AScr, BScr, QScr) < eps) ||
             (Tools2D.area2(BScr, CScr, PScr) < eps &&  Tools2D.area2(BScr, CScr, QScr) < eps) ||
             (Tools2D.area2(CScr, AScr, PScr) < eps &&  Tools2D.area2(CScr, AScr, QScr) < eps))
             continue;

         // 5. Test (2D) if A, B and C lie on the same side
         //    of the infinite line through P and Q:
         double PQA = Tools2D.area2(PScr, QScr, AScr);
         double PQB = Tools2D.area2(PScr, QScr, BScr);
         double PQC = Tools2D.area2(PScr, QScr, CScr);
         
         if (PQA < +eps && PQB < +eps && PQC < +eps ||
             PQA > -eps && PQB > -eps && PQC > -eps)
            continue;

         // 6. Test if neither P nor Q lies behind the 
         //    infinite plane through A, B and C:
         int iPol = refPol[i];
         Polygon3D pol = (Polygon3D)polyList.elementAt(iPol);
         double a = pol.getA(), b = pol.getB(), c = pol.getC(),
            h = pol.getH(), eps1 = 1e-5 * Math.abs(h),
            hP = a * Pe.x + b * Pe.y + c * Pe.z,
            hQ = a * Qe.x + b * Qe.y + c * Qe.z;
         if (hP > h - eps1 && hQ > h - eps1)
            continue;

         // 7. Test if both P and Q behind triangle ABC:
         boolean PInside = 
            Tools2D.insideTriangle(AScr, BScr, CScr, PScr);
         boolean QInside = 
            Tools2D.insideTriangle(AScr, BScr, CScr, QScr);
         if (PInside && QInside) return;


         // 8. If P nearer than ABC and inside, PQ visible;
         //    the same for Q:
         double h1 = h + eps1;
         boolean PNear = hP > h1, QNear = hQ > h1;
         if (PNear && PInside || QNear && QInside) continue;

         // 9. Compute the intersections I and J of PQ
         // with ABC in 2D.
         // If, in 3D, such an intersection lies in front of
         // ABC, this triangle does not obscure PQ.
         // Otherwise, the intersections lie behind ABC and
         // this triangle obscures part of PQ:
         double lambdaMin = 1.0, lambdaMax = 0.0;
         for (int ii=0; ii<3; ii++)
         {  double v1 = BScr.x - AScr.x, v2 = BScr.y - AScr.y,
                   w1 = AScr.x - PScr.x, w2 = AScr.y - PScr.y,
                   denom = u2 * v1 - u1 * v2;
            if (denom != 0)
            {  double mu = (u1 * w2 - u2 * w1)/denom;
               // mu = 0 gives A and mu = 1 gives B.
               if (mu > -0.0001 && mu < 1.0001)
               {  double lambda = (v1 * w2 - v2 * w1)/denom;
                  // lambda = PI/PQ 
                  // (I is point of intersection)
                  if (lambda > -0.0001 && lambda < 1.0001)
                  {  if (PInside != QInside && 
                     lambda > 0.0001 && lambda < 0.9999)
                     {  lambdaMin = lambdaMax = lambda;
                        break; 
                        // Only one point of intersection
                     }
                     if (lambda < lambdaMin) lambdaMin = lambda;
                     if (lambda > lambdaMax) lambdaMax = lambda;
                  }
               }
            }
            Point2D temp = AScr; AScr = BScr; 
            BScr = CScr; CScr = temp;
         }
         float d = obj.getD();
         if (!PInside && lambdaMin > 0.001)
         {  double IScrx = PScr.x + lambdaMin * u1,
                   IScry = PScr.y + lambdaMin * u2;
            // Back from screen to eye coordinates:
            double zI = 1/(lambdaMin/zQ + (1 - lambdaMin)/zP),
                   xI = -zI * IScrx / d, yI = -zI * IScry / d;
            if (a * xI + b * yI + c * zI > h1) continue;
            Point2D IScr = new Point2D((float)IScrx, (float)IScry);
            if (Tools2D.distance2(IScr, PScr) >= 1.0)
               lineSegment(Pe, new Point3D(xI, yI, zI), PScr, 
                  IScr, iP, -1, i + 1, vl);  
         }
         if (!QInside && lambdaMax < 0.999) 
         {  double JScrx = PScr.x + lambdaMax * u1,
                   JScry = PScr.y + lambdaMax * u2;
            double zJ = 
               1/(lambdaMax/zQ + (1 - lambdaMax)/zP),
                  xJ = -zJ * JScrx / d, yJ = -zJ * JScry / d;
            double number = a * xJ + b * yJ + c * zJ;
            if (number > h1) continue;
            Point2D JScr = new Point2D((float)JScrx, (float)JScry);
            if (Tools2D.distance2(JScr, QScr) >= 1.0) 
               lineSegment(Qe, new Point3D(xJ, yJ, zJ),
                  QScr, JScr, iQ, -1, i + 1, vl);  
         }
         return; 
            // if no continue-statement has been executed
      }
      if (vl != null)
        addVector(vl, PScr.x, PScr.y, QScr.x, QScr.y);
   }
    void addVector(GFXVectorList vl, float x0, float y0, float x1, float y1)
    {
        GFXVector v = new GFXVector();
        Vertex start = new Vertex();
        start.x(x0);
        start.y(y0);
        Vertex end = new Vertex();
        end.x(x1);
        end.y(y1);
        v.start = start;
        v.end = end;
        vl.add(v);
    }
}

