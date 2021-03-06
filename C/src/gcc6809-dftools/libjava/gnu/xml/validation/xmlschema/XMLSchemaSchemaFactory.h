
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __gnu_xml_validation_xmlschema_XMLSchemaSchemaFactory__
#define __gnu_xml_validation_xmlschema_XMLSchemaSchemaFactory__

#pragma interface

#include <javax/xml/validation/SchemaFactory.h>
#include <gcj/array.h>

extern "Java"
{
  namespace gnu
  {
    namespace xml
    {
      namespace validation
      {
        namespace xmlschema
        {
            class XMLSchemaSchemaFactory;
        }
      }
    }
  }
  namespace javax
  {
    namespace xml
    {
      namespace transform
      {
          class Source;
      }
      namespace validation
      {
          class Schema;
      }
    }
  }
  namespace org
  {
    namespace w3c
    {
      namespace dom
      {
          class Document;
        namespace ls
        {
            class LSResourceResolver;
        }
      }
    }
    namespace xml
    {
      namespace sax
      {
          class ErrorHandler;
      }
    }
  }
}

class gnu::xml::validation::xmlschema::XMLSchemaSchemaFactory : public ::javax::xml::validation::SchemaFactory
{

public:
  XMLSchemaSchemaFactory();
  virtual ::org::w3c::dom::ls::LSResourceResolver * getResourceResolver();
  virtual void setResourceResolver(::org::w3c::dom::ls::LSResourceResolver *);
  virtual ::org::xml::sax::ErrorHandler * getErrorHandler();
  virtual void setErrorHandler(::org::xml::sax::ErrorHandler *);
  virtual jboolean isSchemaLanguageSupported(::java::lang::String *);
  virtual ::javax::xml::validation::Schema * newSchema();
  virtual ::javax::xml::validation::Schema * newSchema(JArray< ::javax::xml::transform::Source * > *);
private:
  static ::org::w3c::dom::Document * getDocument(::javax::xml::transform::Source *);
public: // actually package-private
  ::org::w3c::dom::ls::LSResourceResolver * __attribute__((aligned(__alignof__( ::javax::xml::validation::SchemaFactory)))) resourceResolver;
  ::org::xml::sax::ErrorHandler * errorHandler;
public:
  static ::java::lang::Class class$;
};

#endif // __gnu_xml_validation_xmlschema_XMLSchemaSchemaFactory__
