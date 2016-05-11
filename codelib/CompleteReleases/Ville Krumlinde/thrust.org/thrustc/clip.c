// Cohen sutherland clipping
// Copyright (C) 2004  Ville Krumlinde
// Original was at http://www.daimi.au.dk/~mbl/cgcourse/wiki/cohen-sutherland_line-cli.html

#include "clip.h"


/*
 * define the coding of end points
 */
typedef char code;
enum {TOP = 0x1, BOTTOM = 0x2, RIGHT = 0x4, LEFT = 0x8};



/*
 * compute the code of a point relative to a rectangle
 */
static __inline code ComputeCode (int x, int y)
{
	code c = 0;
	if (y > clip_ymax)
		c |= TOP;
	else if (y < clip_ymin)
		c |= BOTTOM;
	if (x > clip_xmax)
		c |= RIGHT;
	else if (x < clip_xmin)
		c |= LEFT;
	return c;
}



//Line types
#define LINE_VERT  0   //straight vert
#define LINE_HORIZ 1   //straight horiz
#define LINE_SLOPE 2   //22.5 or 45 slope

#define SLOPE_DEG 1    //0=45 deg, 1=22.5 deg

static __inline void Clip(int *x, int *y,code C,char lineType,int x1,int y1)
{
	switch(lineType) {
		case LINE_VERT :
      //vertical, only top or bottom is possible, otherwise it would have been rejected
			if (C & TOP)
				*y = clip_ymax;
			else
				*y = clip_ymin;
			break;
		case LINE_HORIZ :
      //horizontal, only left or right is possible, otherwise it would have been rejected
			if (C & RIGHT)
				*x = clip_xmax;
			else
				*x = clip_xmin;
			break;
		case LINE_SLOPE :
 			if (C & TOP) {
    	  //clip x depending on how much of y is adjusted (positive or negative)
        int diff = ((*y - clip_ymax) << SLOPE_DEG);
        *x += *x<x1 ? diff : (0-diff);
				*y = clip_ymax;
			} else if (C & BOTTOM) {
        int diff = ((clip_ymin - *y) << SLOPE_DEG);
				*x += *x<x1 ? diff : (0-diff);
				*y = clip_ymin;
			} else if (C & RIGHT) {
        int diff = ((*x - clip_xmax) >> SLOPE_DEG);
        *y += *y<y1 ? diff : (0-diff);
        *x = clip_xmax;
      } else { //if (C & LEFT)
        int diff = ((clip_xmin - *x) >> SLOPE_DEG);
        *y += *y<y1 ? diff : (0-diff);
        *x = clip_xmin;
      }
			break;
	}
}


/*
 *	clip lines in lineList against global rectangle CLIP
 *  write clipped lines to drawList
 */
char CohenSutherlandClip(char *lineList,char *drawList,int offsetX,int offsetY)
{
	code C0, C1;
  int x0, y0, x1, y1, lineCount;
	char lineType;
	char written = 0;

  //These macros are necessary to make 6809 compiler correctly convert int<->char
  #define WRITE(x) { int i=(x); char c=i; *(drawList++)=c; written++;}
  #define READ ((int)(*(lineList++)))

	int vecX,vecY;

  lineCount = READ;
	while(lineCount--) {
		lineType = READ;
		x0 = offsetX + READ;
		y0 = offsetY + READ;
		x1 = offsetX + READ;
		y1 = offsetY + READ;

		C0 = ComputeCode (x0, y0);
		C1 = ComputeCode (x1, y1);

		for (;;) {

      #define VEC_Y(Y) (0-((Y) - clip_ymin)+127)

      /* trivial accept: both ends in rectangle */
			if ((C0 | C1) == 0) {
				//write vectrex screen coords to drawlist
				vecX = x0 - clip_xmin;
				vecY = VEC_Y(y0);

				WRITE(-1);     //set pen
				WRITE(vecY);
				WRITE(vecX - 128);
				WRITE(1);      //draw line to offset
				WRITE( VEC_Y(y1) - vecY );
				WRITE(x1 - clip_xmin - vecX);

				break;
			}

			/* trivial reject: both ends on the external side of the rectangle */
			if ((C0 & C1) != 0)
				break;

			/* normal case: clip end outside rectangle */
      if(C0)  {
        Clip(&x0,&y0,C0,lineType,x1,y1);
        C0 = ComputeCode(x0,y0);
      }  else { //if(C1)
        Clip(&x1,&y1,C1,lineType,x0,y0);
        C1 = ComputeCode(x1,y1);
      }

		}

	} //while linecount

	return written;
}


//---------------------------------
//Everything below is test-code: it is not used in the game
//---------------------------------


char *testlevel;

char* getTileP(int x, int y)
{
  char xsize;
  int offset;
  xsize = *testlevel;
  offset = (char)((char)xsize * (char)(y >> 4)) + (char)(x >> 4);
  return (testlevel+offset+1);
}


#define TileH 8
#define TileW 8
char collx,colly;
char collTest() {
//.X
//XX
  char r;
  r = (char)(colly >= (char)(TileH>>1));
  if(!r)
    r = (char)(colly >= (char)(TileW - collx));
  return r;
}


void testcall(char c) {
	//parameterordning, pushas omvänt, anroparen städar stacken
	CohenSutherlandClip(0,0,1,c<<3);
}

int shipX,viewX,curLevelEndX;
int makeScreenX() {
/*    screenx=x - viewx
    om negativt
      ;potential overlap
      overlap=CurLevelEndX-ViewX
      screenx=overlap+x
      om >=0 and (<256)
        draw
    annars
      om >256=offscreen
      else draw
      */
  int screenX;
  screenX = shipX - viewX;
  if(screenX<0) {
    int overlap = curLevelEndX - viewX;
    screenX = overlap + shipX;
    return screenX;
  } else {
    return screenX;
  }
}


int spx1,spx2,spy1,spy2;
#define spsize 8
char spriteCollTest() {
  return (spx1>=spx2 - (spsize/2)) && (spx1<=spx2 + (spsize/2)) &&
  (spy1>=spy2 - (spsize/2)) && (spy1<=spy2 + (spsize/2));
}


//        mTestAreaVsArea xmin1,xmax1,ymin1,ymax1,centerx2,centery2,Size2

#define spsize1 8
#define spsize2 10
int xmin1,xmax1,ymin1,ymax1;
void spriteAreaCollTest() {
    int xmin2,xmax2,ymin2,ymax2;
    xmin2=spx2 - (spsize2/2);
    xmax2=spx2 + (spsize2/2);
    ymin2=spy2 - (spsize2/2);
    ymax2=spy2 + (spsize2/2);

    if((xmin1 > xmax2) || (xmax1 < xmin2) ||
             (ymin1 > ymax2) || (ymax1 < ymin2))
      return; //miss
    xmin1=42; //hit
}


unsigned divu10(unsigned n) {
  unsigned q, r;
  q = (n >> 1) + (n >> 2);
  q = q + (q >> 4);
  q = q + (q >> 8);
  q = q >> 3;
  r = n - q*10;
  return q + ((r + 6) >> 4);
}

unsigned divu10_2(unsigned A) {
unsigned int Q,R;

  Q = ((A >> 1) + A) >> 1; /* Q = A*0.11 */
  Q = ((Q >> 4) + Q)     ; /* Q = A*0.110011 */
  Q = ((Q >> 8) + Q) >> 3; /* Q = A*0.00011001100110011 */
//  Q = ( ((char)Q) + Q) >> 3; /* Q = A*0.00011001100110011 */

  R = ((Q << 2) + Q) << 1;
  R = A - R; /* R = A - 10*Q */
  if (R >= 10) {
    R = R - 10;
    Q = Q + 1;
  }

  return R;
}



/*
  From this format:
    db 1                  ;count-1
    db -(SH*1),-(SW*1)    ;start pos
    db  (SH*0),-(SW*1)
    db $FF                ;end

  To this format:
    db 2  ;line count
    db 2  ;linetype, 0=vert, 1=horiz, 2=slope
    db FullW,0  ;x0,y0
    db 0,HalfH  ;x1,y1

  The resulting list can be sent to cohensutherlandclip()
*/
void BuildAbsLines(char *relLineList,char *absLineList)
{
  char x, y, dx, dy, lineCount, absLineCount;
  char lineType;
  char *countPtr;

  #define WRITE_C(X) { *(absLineList++)=X; }
  #define READ_C (*(relLineList++))

  //make space for linecount
  countPtr=absLineList;
  absLineList++;
  absLineCount=0;

  x=0; y=0;
  while( (lineCount=READ_C)!=-1 ) {
    y+=READ_C; x+=READ_C;
    while(lineCount--) {
      dy=READ_C; dx=READ_C;

      lineType=LINE_VERT;
      if(dy==0)
        lineType=LINE_HORIZ;
      else if(dx!=0)
        lineType=LINE_SLOPE;

      WRITE_C(lineType);
      WRITE_C(x);
      WRITE_C(y);
      y+=dy; x+=dx;
      WRITE_C(x);
      WRITE_C(y);
      absLineCount++;
    }
  }
  *countPtr=absLineCount;
}

