package de.malban.gtest;
// Point3D.java: Representation of a point in 3D space.

// Copied from Section 3.9 of
//    Ammeraal, L. (1998) Computer Graphics for Java Programmers,
//       Chichester: John Wiley.

class Point3D
{  float x, y, z;
   Point3D(double x, double y, double z)
   {  this.x = (float)x; 
      this.y = (float)y; 
      this.z = (float)z;
   }
}
