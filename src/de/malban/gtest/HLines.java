package de.malban.gtest;
// HLines.java: Perspective drawing with hidden-line elimination.
// Uses: Point2D (Section 1.5), Point3D (Section 3.9), 
//       Tools2D (Section 2.13),
//       Obj3D, Input, Polygon3D, Tria (Section 6.3).

// Copied from Appendix D (discussed in Chapter 7) of
//    Ammeraal, L. (1998) Computer Graphics for Java Programmers,
//       Chichester: John Wiley.

import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.io.*;

public class HLines extends Frame
{  public static void main(String[] args)
   {  new HLines(args.length > 0 ? args[0] : null);
   }
   private MenuItem open, exportHPGL, exit, eyeUp, eyeDown, 
      eyeLeft, eyeRight, incrDist, decrDist;
   private CvHLines cv;
   private String sDir;
   
   public HLines(String argFileName)
   {  super("Hidden-lines algorithm");
      cv = new CvHLines();
      addWindowListener(new WindowAdapter()
         {public void windowClosing(WindowEvent e){System.exit(0);}});

      MenuBar mBar = new MenuBar();
      setMenuBar(mBar);
      Menu mF = new Menu("File"), mV = new Menu("View");
      mBar.add(mF); mBar.add(mV);

      open = new MenuItem("Open", new MenuShortcut(KeyEvent.VK_O));
      exportHPGL = new MenuItem("Export HP-GL");
      exit = new MenuItem("Exit", new MenuShortcut(KeyEvent.VK_Q));
      eyeDown = new MenuItem("Viewpoint Down",
         new MenuShortcut(KeyEvent.VK_DOWN));
      eyeUp = new MenuItem("Viewpoint Up",
         new MenuShortcut(KeyEvent.VK_UP));
      eyeLeft = new MenuItem("Viewpoint to Left", 
         new MenuShortcut(KeyEvent.VK_LEFT));
      eyeRight = new MenuItem("Viewpoint to Right",
         new MenuShortcut(KeyEvent.VK_RIGHT));

      incrDist = new MenuItem("Increase viewing distance",
         new MenuShortcut(KeyEvent.VK_INSERT));
      decrDist = new MenuItem("Decrease viewing distance",
         new MenuShortcut(KeyEvent.VK_DELETE));
      mF.add(open); mF.add(exportHPGL); mF.add(exit); 
      mV.add(eyeDown); mV.add(eyeUp); 
      mV.add(eyeLeft); mV.add(eyeRight); 
      mV.add(incrDist); mV.add(decrDist);
      MenuCommands mListener = new MenuCommands();
      open.addActionListener(mListener);
      exportHPGL.addActionListener(mListener);
      exit.addActionListener(mListener);
      eyeDown.addActionListener(mListener);
      eyeUp.addActionListener(mListener);
      eyeLeft.addActionListener(mListener);
      eyeRight.addActionListener(mListener);
      incrDist.addActionListener(mListener);
      decrDist.addActionListener(mListener);
      add("Center", cv);
      Dimension dim = getToolkit().getScreenSize();
      setSize(dim.width/2, dim.height/2);
      setLocation(dim.width/4, dim.height/4);
      if (argFileName != null) 
      {  Obj3D obj = new Obj3D();
         if (obj.read(argFileName)){cv.setObj(obj); cv.repaint();}
      }
      show();
   }
   
   void vp(float dTheta, float dPhi, float fRho) // Viewpoint
   {  Obj3D obj = cv.getObj();
      if (obj == null || !obj.vp(cv, dTheta, dPhi, fRho))
         Toolkit.getDefaultToolkit().beep();
   }

   class MenuCommands implements ActionListener
   {  public void actionPerformed(ActionEvent ae)
      {  if (ae.getSource() instanceof MenuItem)
         {  MenuItem mi = (MenuItem)ae.getSource();
            if (mi == open)
            {  FileDialog fDia = new FileDialog(HLines.this, 
                  "Open", FileDialog.LOAD);
               fDia.setDirectory(sDir);
               fDia.setFile("*.dat");
               fDia.show();	
               String sDir1 = fDia.getDirectory();
               String sFile = fDia.getFile();
               String fName = sDir1 + sFile;
               Obj3D obj = new Obj3D();
               if (obj.read(fName))
               {  sDir = sDir1;
                  cv.setObj(obj);
                  cv.repaint(); 
               }
            }  
            else
            if (mi == exportHPGL)
            {  Obj3D obj = cv.getObj();
               if (obj != null)
               {  cv.setHPGL(new HPGL(obj));
                  cv.repaint();
               }
               else 
                  Toolkit.getDefaultToolkit().beep();
            } 
            else
            if (mi == exit) System.exit(0); else
            if (mi == eyeDown) vp(0, .1F, 1); else
            if (mi == eyeUp) vp(0, -.1F, 1); else
            if (mi == eyeLeft) vp(-.1F, 0, 1); else
            if (mi == eyeRight) vp(.1F, 0, 1); else
            if (mi == incrDist) vp(0, 0, 2); else
            if (mi == decrDist) vp(0, 0, .5F);
         }
      }
   } 
}

// Class CvHLines:
// ===============

class CvHLines extends Canvas
{  private int maxX, maxY, centerX, centerY, nTria, nVertices;
   private Obj3D obj;    
   private Point2D imgCenter;
   private Tria[] tr;
   private HPGL hpgl;
   private int[] refPol;
   private int[][] connect;
   private int[] nConnect;
   private int chunkSize = 4;
   private double hLimit;
   private Vector polyList;
   private float maxScreenRange;

   Obj3D getObj(){return obj;}
   void setObj(Obj3D obj){this.obj = obj;}
   void setHPGL(HPGL hpgl){this.hpgl = hpgl;}

   public void paint(Graphics g) 
   {  if (obj == null) return;
      Vector polyList = obj.getPolyList();
      if (polyList == null) return;
      int nFaces = polyList.size();
      if (nFaces == 0) return;
      float xe, ye, ze;
      Dimension dim = getSize();
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
      maxScreenRange = obj.eyeAndScreen(dim);
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
            lineSegment(g, e[i], e[jj], vScr[i], vScr[jj], i, jj, 0);
         }
      }
      hpgl = null;
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

   private String toString(float t) 
   // From screen device units (pixels) to HP-GL units (0-10000):
   {  int i = Math.round(5000 + t * 9000/maxScreenRange);
      String s = "";
      int n = 1000;
      for (int j=3; j>=0; j--)
      {  s += i/n;
         i %= n;
         n /= 10;
      }
      return s;
   }

   private String hpx(float x){return toString(x - imgCenter.x);}
   private String hpy(float y){return toString(y - imgCenter.y);}
  
   private void drawLine(Graphics g, float x1, float y1, 
      float x2, float y2)
   {  if (x1 != x2 || y1 != y2)
      {  g.drawLine(iX(x1), iY(y1), iX(x2), iY(y2));
         if (hpgl != null)
         {  hpgl.write("PU;PA" + hpx(x1) + "," + hpy(y1));
            hpgl.write("PD;PA" + hpx(x2) + "," + hpy(y2) + "\n");
         }
      }
   }

   private void lineSegment(Graphics g, Point3D Pe, Point3D Qe,
      Point2D PScr, Point2D QScr, int iP, int iQ, int iStart)
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
         double eps = 0.1; // Relative to numbers of pixels
         if (Tools2D.area2(AScr, BScr, PScr) < eps && 
             Tools2D.area2(AScr, BScr, QScr) < eps ||
             Tools2D.area2(BScr, CScr, PScr) < eps && 
             Tools2D.area2(BScr, CScr, QScr) < eps ||
             Tools2D.area2(CScr, AScr, PScr) < eps && 
             Tools2D.area2(CScr, AScr, QScr) < eps) continue;

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
               lineSegment(g, Pe, new Point3D(xI, yI, zI), PScr, 
                  IScr, iP, -1, i + 1);  
         }
         if (!QInside && lambdaMax < 0.999) 
         {  double JScrx = PScr.x + lambdaMax * u1,
                   JScry = PScr.y + lambdaMax * u2;
            double zJ = 
               1/(lambdaMax/zQ + (1 - lambdaMax)/zP),
                  xJ = -zJ * JScrx / d, yJ = -zJ * JScry / d;
            if (a * xJ + b * yJ + c * zJ > h1) continue;
            Point2D JScr = new Point2D((float)JScrx, (float)JScry);
            if (Tools2D.distance2(JScr, QScr) >= 1.0) 
               lineSegment(g, Qe, new Point3D(xJ, yJ, zJ),
                  QScr, JScr, iQ, -1, i + 1);  
         }
         return; 
            // if no continue-statement has been executed
      }
      drawLine(g, PScr.x, PScr.y, QScr.x, QScr.y);
   }
}

// Class for HP-GL output:
// =======================

class HPGL
{  FileWriter fw;
   HPGL(Obj3D obj)
   {  String plotFileName = "", fName = obj.getFName();
      for (int i=0; i<fName.length(); i++)
      {  char ch = fName.charAt(i);
         if (ch == '.') break;
         plotFileName += ch;
      }
      plotFileName += ".plt";
      try
      {  fw = new FileWriter(plotFileName);
         fw.write("IN;SP1;\n");
      }
      catch (IOException ioe){}
   }

   void write(String s)
   {  try {fw.write(s); fw.flush();}catch (IOException ioe){}
   }
}
