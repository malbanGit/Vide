package de.malban.gtest;
// Triangle.java: Class to store a triangle;
//    vertices in logical coordinates.
// Uses: Point2D (Section 1.5).

// Copied from Section 2.13 of
//    Ammeraal, L. (1998) Computer Graphics for Java Programmers,
//       Chichester: John Wiley.

class Triangle
{  Point2D A, B, C;
   Triangle(Point2D A, Point2D B, Point2D C)
   {  this.A = A; this.B = B; this.C = C;
   }
}
