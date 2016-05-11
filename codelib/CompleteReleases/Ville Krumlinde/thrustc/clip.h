#pragma once


char CohenSutherlandClip(char *lineList,char *drawList,int offsetX,int offsetY);

//Global clip area
int clip_xmin, clip_ymin, clip_xmax,  clip_ymax;

//typedef struct {
//  int xmin, ymin, xmax,  ymax;
//} rectangle;

//rectangle clip;

