/* { dg-xfail-if "long long not 64-bit" { m6809-*-* } { "*" } { "" } } */
struct{long long x:24,y:40;}v;
x(){v.y=0;}
