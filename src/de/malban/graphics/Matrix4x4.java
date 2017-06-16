/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package de.malban.graphics;

/**
 * see: http://www.opengl-tutorial.org/assets/faq_quaternions/index.html
 * https://www.ntu.edu.sg/home/ehchua/programming/opengl/CG_BasicsTheory.html
 * http://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=20&cad=rja&uact=8&ved=0ahUKEwinn_iK56fKAhUMFiwKHVzpDUU4ChAWCF4wCQ&url=http%3A%2F%2Fgamesnorthwest.net%2Fresources%2Fmodules%2Fco3301%2Fmaterials%2FWeek%25208%2FCO3301-8%2520Lecture.ppt&usg=AFQjCNH72WpNaW5cn4vkVwqgqDhxIbWIcg&bvm=bv.111396085,bs.1,d.bGg
 * @author malban
 */
public class Matrix4x4 {
    // x,y
    double[][] m = new double[4][4];
    
    
    public static Matrix4x4 getTranslocation(double xmove, double ymove, double zmove)
    {
        Matrix4x4 ma = new Matrix4x4();
        ma.m[3][0] = xmove;
        ma.m[3][1] = ymove;
        ma.m[3][2] = zmove;
        return ma;
    }
    public static Matrix4x4 getScaling(double xscale, double yscale, double zscale)
    {
        Matrix4x4 ma = new Matrix4x4();
        ma.m[0][0] = xscale;
        ma.m[1][1] = yscale;
        ma.m[2][2] = zscale;
        return ma;
    }
    // variant - transposes the given matrix
    public void transpose()
    {
        double[][] t = new double[4][4];
        
        for (int x = 0; x < 4; x++)
        {
            for (int y = 0; y < 4; y++)
            {
                t[x][y] = m[y][x];
            }
        }
        m = t;
    }
    // angle in Radianse
    public static Matrix4x4 getRotationX(double xangle)
    {
        //Math.toRadians(xangle)
        Matrix4x4 ma = new Matrix4x4();
        ma.m[1][1] = Math.cos(xangle);
        ma.m[2][1] = -Math.sin(xangle);
        
        ma.m[1][2] = Math.sin(xangle);
        ma.m[2][2] = Math.cos(xangle);
        return ma;
    }
    // angle in Radianse
    public static Matrix4x4 getRotationY(double yangle)
    {
        //Math.toRadians(xangle)
        Matrix4x4 ma = new Matrix4x4();
        ma.m[0][0] = Math.cos(yangle);
        ma.m[2][0] = Math.sin(yangle);
        
        ma.m[0][2] = -Math.sin(yangle);
        ma.m[2][2] = Math.cos(yangle);
        return ma;
    }
    // angle in Radianse
    public static Matrix4x4 getRotationZ(double zangle)
    {
        //Math.toRadians(xangle)
        Matrix4x4 ma = new Matrix4x4();
        ma.m[0][0] = Math.cos(zangle);
        ma.m[1][0] = -Math.sin(zangle);
        
        ma.m[0][1] = Math.sin(zangle);
        ma.m[1][1] = Math.cos(zangle);
        return ma;
    }
        
    public static Matrix4x4 getIdentity(double x, double y, double z)
    {
        Matrix4x4 ma = new Matrix4x4();
        return ma;
    }
    
    public Matrix4x4()
    {
        for (int x=0; x<4;x++)
        {
            for (int y=0; y<4;y++)
            {
                if (x==y)
                    m[x][y] = 1;
                else
                    m[x][y] = 0;
            }
        }
    }
    
    public void setValue(int x, int y, double value)
    {
        m[x][y] = value;
    }
    
    // invariant
    public Vertex multiply(Vertex v)
    {
        Vertex r = new Vertex(v);
        r.x(m[0][0]*v.x() + m[1][0]*v.y() + m[2][0]*v.z() + m[3][0]*v.w());
        r.y(m[0][1]*v.x() + m[1][1]*v.y() + m[2][1]*v.z() + m[3][1]*v.w());
        r.z(m[0][2]*v.x() + m[1][2]*v.y() + m[2][2]*v.z() + m[3][2]*v.w());
        r.w(m[0][3]*v.x() + m[1][3]*v.y() + m[2][3]*v.z() + m[3][3]*v.w());
        return r;
    }
    // variant
    public Vertex multiplyVariant(Vertex v)
    {
        double x = (m[0][0]*v.x() + m[1][0]*v.y() + m[2][0]*v.z() + m[3][0]*v.w());
        double y = (m[0][1]*v.x() + m[1][1]*v.y() + m[2][1]*v.z() + m[3][1]*v.w());
        double z = (m[0][2]*v.x() + m[1][2]*v.y() + m[2][2]*v.z() + m[3][2]*v.w());
        double w = (m[0][3]*v.x() + m[1][3]*v.y() + m[2][3]*v.z() + m[3][3]*v.w());
        
        v.x(x);
        v.y(y);
        v.z(z);
        v.w(w);
        return v;
    }
    
    // invariant
    public GFXVector multiply(GFXVector v)
    {
        GFXVector n = v.clone();
        n.start = multiply(v.start);
        n.end = multiply(v.end);
        return n;
    }

    // invariant! this + o
    public Matrix4x4 add(Matrix4x4 o)
    {
        Matrix4x4 n = new Matrix4x4();
        for (int x=0; x<4;x++)
        {
            for (int y=0; y<4;y++)
            {
                n.m[x][y] = m[x][y]+o.m[x][y];
            }
        }
        return n;
    }
    // invariant! this - o
    public Matrix4x4 sub(Matrix4x4 o)
    {
        Matrix4x4 n = new Matrix4x4();
        for (int x=0; x<4;x++)
        {
            for (int y=0; y<4;y++)
            {
                n.m[x][y] = m[x][y]-o.m[x][y];
            }
        }
        return n;
    }
    
    // two 4x4
    // invariant! this * o
    public Matrix4x4 mul(Matrix4x4 o)
    {
        Matrix4x4 n = new Matrix4x4();
        for (int x=0; x<4;x++)
        {
            Vertex v1 = o.columnToVertex(x);
            Vertex r = multiply(v1);
            n.vertexIntoColumn(r,0);
        }
        return n;
    }
    // VARIANT!
    private void vertexIntoColumn(Vertex v, int c)
    {
        m[c][0] = v.coord()[0];
        m[c][1] = v.coord()[1];
        m[c][2] = v.coord()[2];
        m[c][3] = v.coord()[3];
    }
    private Vertex columnToVertex(int c)
    {
        Vertex n = new Vertex();
        n.x(m[c][0]);
        n.y(m[c][1]);
        n.z(m[c][2]);
        n.w(m[c][3]);
        return n;
    }
}
