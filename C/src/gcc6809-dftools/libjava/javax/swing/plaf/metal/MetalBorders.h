
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __javax_swing_plaf_metal_MetalBorders__
#define __javax_swing_plaf_metal_MetalBorders__

#pragma interface

#include <java/lang/Object.h>
extern "Java"
{
  namespace javax
  {
    namespace swing
    {
      namespace border
      {
          class Border;
      }
      namespace plaf
      {
        namespace basic
        {
            class BasicBorders$MarginBorder;
        }
        namespace metal
        {
            class MetalBorders;
        }
      }
    }
  }
}

class javax::swing::plaf::metal::MetalBorders : public ::java::lang::Object
{

public:
  MetalBorders();
  static ::javax::swing::border::Border * getButtonBorder();
  static ::javax::swing::border::Border * getToggleButtonBorder();
  static ::javax::swing::border::Border * getDesktopIconBorder();
  static ::javax::swing::border::Border * getTextFieldBorder();
  static ::javax::swing::border::Border * getTextBorder();
public: // actually package-private
  static ::javax::swing::border::Border * getToolbarButtonBorder();
  static ::javax::swing::border::Border * getMarginBorder();
  static ::javax::swing::border::Border * getRolloverBorder();
private:
  static ::javax::swing::border::Border * buttonBorder;
  static ::javax::swing::border::Border * toggleButtonBorder;
  static ::javax::swing::border::Border * desktopIconBorder;
  static ::javax::swing::border::Border * toolbarButtonBorder;
  static ::javax::swing::border::Border * textFieldBorder;
  static ::javax::swing::border::Border * textBorder;
  static ::javax::swing::border::Border * rolloverBorder;
  static ::javax::swing::plaf::basic::BasicBorders$MarginBorder * marginBorder;
public:
  static ::java::lang::Class class$;
};

#endif // __javax_swing_plaf_metal_MetalBorders__
