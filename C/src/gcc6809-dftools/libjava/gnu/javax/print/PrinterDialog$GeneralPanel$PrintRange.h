
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_javax_print_PrinterDialog$GeneralPanel$PrintRange__
#define __gnu_javax_print_PrinterDialog$GeneralPanel$PrintRange__

#pragma interface

#include <javax/swing/JPanel.h>
extern "Java"
{
  namespace gnu
  {
    namespace javax
    {
      namespace print
      {
          class PrinterDialog$GeneralPanel;
          class PrinterDialog$GeneralPanel$PrintRange;
      }
    }
  }
  namespace java
  {
    namespace awt
    {
      namespace event
      {
          class ActionEvent;
          class FocusEvent;
      }
    }
  }
  namespace javax
  {
    namespace swing
    {
        class JLabel;
        class JRadioButton;
        class JTextField;
    }
  }
}

class gnu::javax::print::PrinterDialog$GeneralPanel$PrintRange : public ::javax::swing::JPanel
{

public: // actually package-private
  PrinterDialog$GeneralPanel$PrintRange(::gnu::javax::print::PrinterDialog$GeneralPanel *);
public:
  void focusGained(::java::awt::event::FocusEvent *);
  void focusLost(::java::awt::event::FocusEvent *);
private:
  void updatePageRanges();
public:
  void actionPerformed(::java::awt::event::ActionEvent *);
public: // actually package-private
  void updateForSelectedService();
private:
  ::javax::swing::JLabel * __attribute__((aligned(__alignof__( ::javax::swing::JPanel)))) to;
  ::javax::swing::JRadioButton * all_rb;
  ::javax::swing::JRadioButton * pages_rb;
  ::javax::swing::JTextField * from_tf;
  ::javax::swing::JTextField * to_tf;
public: // actually package-private
  ::gnu::javax::print::PrinterDialog$GeneralPanel * this$1;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_javax_print_PrinterDialog$GeneralPanel$PrintRange__
