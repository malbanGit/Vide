
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __javax_security_auth_kerberos_DelegationPermission$1__
#define __javax_security_auth_kerberos_DelegationPermission$1__

#pragma interface

#include <java/security/PermissionCollection.h>
extern "Java"
{
  namespace java
  {
    namespace security
    {
        class Permission;
    }
  }
  namespace javax
  {
    namespace security
    {
      namespace auth
      {
        namespace kerberos
        {
            class DelegationPermission;
            class DelegationPermission$1;
        }
      }
    }
  }
}

class javax::security::auth::kerberos::DelegationPermission$1 : public ::java::security::PermissionCollection
{

public: // actually package-private
  DelegationPermission$1(::javax::security::auth::kerberos::DelegationPermission *);
public:
  void add(::java::security::Permission *);
  jboolean implies(::java::security::Permission *);
  ::java::util::Enumeration * elements();
private:
  ::java::util::Vector * __attribute__((aligned(__alignof__( ::java::security::PermissionCollection)))) permissions;
public: // actually package-private
  ::javax::security::auth::kerberos::DelegationPermission * this$0;
public:
  static ::java::lang::Class class$;
};

#endif // __javax_security_auth_kerberos_DelegationPermission$1__
