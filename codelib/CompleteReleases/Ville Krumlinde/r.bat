rem 1=run in mess, 2=run in vecx, 3=upload to vecram, 4=record input
set proj=thrust


if %1.==. (
 cd \spel\mess
 mess vectrex -cart \data\code\vectrex\%proj%\%proj%.bin
 cd\data\code\vectrex\%proj%
) else if %1.==2. (
 cd ..\vecx
 vecx -c ..\%proj%\%proj%.bin
 cd ..\%proj%
) else if %1.==3. (
 cd ..\vecram
 veccy-win32.exe ..\%proj%\%proj%.bin
 cd ..\%proj%
) else if %1.==4. (
 cd VecxMod\Release
 vecxMod -c ..\..\%proj%.bin
 cd ..\..\
)

