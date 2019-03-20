
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_java_awt_java2d_AlphaCompositeContext__
#define __gnu_java_awt_java2d_AlphaCompositeContext__

#pragma interface

#include <java/lang/Object.h>
extern "Java"
{
  namespace gnu
  {
    namespace java
    {
      namespace awt
      {
        namespace java2d
        {
            class AlphaCompositeContext;
        }
      }
    }
  }
  namespace java
  {
    namespace awt
    {
        class AlphaComposite;
      namespace image
      {
          class ColorModel;
          class Raster;
          class WritableRaster;
      }
    }
  }
}

class gnu::java::awt::java2d::AlphaCompositeContext : public ::java::lang::Object
{

public:
  AlphaCompositeContext(::java::awt::AlphaComposite *, ::java::awt::image::ColorModel *, ::java::awt::image::ColorModel *);
  virtual void dispose();
  virtual void compose(::java::awt::image::Raster *, ::java::awt::image::Raster *, ::java::awt::image::WritableRaster *);
private:
  ::java::awt::AlphaComposite * __attribute__((aligned(__alignof__( ::java::lang::Object)))) composite;
  ::java::awt::image::ColorModel * srcColorModel;
  ::java::awt::image::ColorModel * dstColorModel;
  jfloat fs;
  jfloat fd;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_java_awt_java2d_AlphaCompositeContext__