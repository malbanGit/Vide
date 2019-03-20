rem  Zip File Created  with Info-Zip   Zip v2.31
rem  Zip File Verified with Info-Zip UnZip v5.52
rem
rem  Remove Old Zipped Files and asxv5pxx.txt
rem
del as*.zip
del as*.txt
rem
rem  Zip The asxv5pxx Directory and Subdirectories
rem
cd ..\..\
asxv5pxx\zipper\zip.exe -r .\asxv5pxx\zipper\asxv5pxx.zip asxv5pxx\*.*
cd asxv5pxx\zipper
zip -T asxv5pxx.zip
rem
rem  Remove Non-Distribution Directories
rem
zip -d asxv5pxx.zip asxv5pxx\asxdoc\* asxv5pxx\asxhtmw\*
zip -T asxv5pxx.zip
rem
rem  Remove Zip and Unzip Utilities
rem
zip -d asxv5pxx.zip asxv5pxx\zipper\*.exe
zip -T asxv5pxx.zip
rem
rem  Remove Pad File
rem
zip -d asxv5pxx.zip asxv5pxx\asxv5p00.xml
zip -T asxv5pxx.zip
rem
rem  Copy Current readme.txt File To asxv5pxx.txt
rem  And Add To The Zip Archive
rem
copy ..\readme.txt asxv5pxx.txt
zip -g  asxv5pxx.zip asxv5pxx.txt
zip -T asxv5pxx.zip
rem
rem  Change Name To Current Version
rem
ren asxv5pxx.txt asxv5p00.txt
ren asxv5pxx.zip asxv5p00.zip
rem
rem  Final File Verification
rem
unzip -t asxv5p00.zip

