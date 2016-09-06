#include <fstream.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdio.h>

const       MAXBUFF = 100000;

FILE *inFile;
FILE *outFile;
int len;

unsigned char buf[MAXBUFF];


int main( int argc, char* argv[] )
{
 int len;

 cout <<"\nCalling ";
 for (int ii=0;ii<argc;ii++)
   cout <<" "<<argv[ii];
 cout << "\n\n";
 if ( argc != 3 )
 {
  cout << "Usage: back <infile> <outfile>\n";
  return 0;
 }
 if (!strcmp(argv[1], argv[2]))
 {
  cout << "<infile> == <outfile>, NOT ALLOWED\n";
  return 1;
 }
 inFile=fopen(argv[1],"rb");
 if( !inFile )
 {
  cout << "A file error occured with " << argv[1] << "!\n";
  return 2;
 }
 outFile= fopen( argv[2],"wb");
 if( !outFile )
 {
  cout << "A file error occured with " << argv[2] << "!\n";
  return 2;
 }
 len=0;
 while( 1 )
 {
  if (!fread( &buf[len], 1,1,inFile ))
   break;
  len++;
  if (len > MAXBUFF-2)
  {
   cout << "Error, file to long!\n";
   exit(1);
  }
 }
 cout << "len = "<< len << "\n";
 len--;
 while( len>=0 )
 {
  fwrite( &buf[len], 1,1,outFile );
  len--;
 }
 fclose(outFile);
 fclose(inFile);
 return 0;
}

