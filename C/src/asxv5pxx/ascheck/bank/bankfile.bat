ascheck -gloaxwf bankfile.asm
echo -mxiu > bankfile.lnk
echo bf >> bankfile.lnk
echo bankfile >> bankfile.lnk
echo -e >> bankfile.lnk
aslink -f bankfile.lnk

