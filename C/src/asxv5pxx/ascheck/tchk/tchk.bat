ascheck -gloasxff tchk
echo -mxsu > tchk.lnk
echo tchk >> tchk.lnk
echo -b Area9=0x5000 >> tchk.lnk
echo -b Area11=0x5000 >> tchk.lnk
echo -e >> tchk.lnk
aslink -f tchk.lnk

