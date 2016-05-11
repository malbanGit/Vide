@echo off
set XYZ=%CD%
pushd ..\..\mess
mess.exe vectrex -cart %XYZ%\%1.bin  %2 %3 %4
popd

