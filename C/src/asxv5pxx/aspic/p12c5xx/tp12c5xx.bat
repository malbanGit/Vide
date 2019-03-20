aspic -gloaxff tp12c5xx
asxscn tp12c5xx.lst
aslink -nxu -g extaddr=0 -g extreg=0 -g extvalu=0 tp12c5xx
asxscn -i tp12c5xx.rst

