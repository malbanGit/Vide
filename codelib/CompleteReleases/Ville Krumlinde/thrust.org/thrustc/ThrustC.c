// ThrustC.cpp : Defines the entry point for the console application.
//

#include <stdio.h>
#include <malloc.h>
#include <tchar.h>

#include "clip.h"

int _tmain(int argc, _TCHAR* argv[])
{

	char lines[] = {1, 
		//0, 20,0,20,32,  
	//  1, 0,0,100,0,
	  2, 0,32, 16,16  //type, x0,y0, x1,y1
	}; 

//	db 0,FullH      ;x0,y0
//  db FullW,HalfH  ;x1,y1

	char *result, *p;
	int i,j;

	char written;

	clip_xmin = 100;
	clip_xmax = clip_xmin + 256;
	clip_ymin = 100;
	clip_ymax = clip_ymin + 256;

	result = malloc(40);

	written = CohenSutherlandClip(lines,result, 90,100);

//	CohenSutherlandClip(120,50,120,150, 0, result);  //vert
//	CohenSutherlandClip(120,150, 120,50, 0, result);  //vert

//	CohenSutherlandClip(90,100, 110,100, 1, result);  //horiz
//	CohenSutherlandClip(300,100,90,100, 1);  //horiz

//	CohenSutherlandClip(50,50,120,85, 2);  //slope
//	CohenSutherlandClip(220,185,150,150, 2);  //slope

//	CohenSutherlandClip(100,100, 300,200, 2);  //slope

//	CohenSutherlandClip(300,200, 100,100, 2, result);  //slope
	
  p = result;
	for(i=0; i<written; i++) {
		j = *(p++);
  	printf("drawList: %d\n", j);
	}


	return 0;
}

