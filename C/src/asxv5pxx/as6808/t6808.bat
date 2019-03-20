REM Local Variables
as6808 -gloabcxff t6808l
aslink -nxu t6808l
asxscn t6808l.lst
asxscn -i t6808l.rst
REM Global Variables
as6808 -gloacbxff t6808g
aslink -nxu -g extE=0 -g ix1E=0 -g ix2E=0 t6808g
asxscn t6808g.lst
asxscn -i t6808g.rst

