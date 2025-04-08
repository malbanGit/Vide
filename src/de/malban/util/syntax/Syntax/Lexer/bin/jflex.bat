@echo off
REM Please adjust JFLEX_HOME to suit your needs
REM (please do not add a trailing backslash)

REM set JFLEX_HOME=c:\t\Vide\src\de\malban\util\syntax\Syntax\Lexer\bin\jflex-1.6.1 
set JFLEX_HOME=c:\Dev\Vide\src\de\malban\util\syntax\Syntax\Lexer\bin\jflex-1.6.1 

java -Xmx128m -jar C:\Dev\Vide\src\de\malban\util\syntax\Syntax\Lexer\bin\jflex-1.6.1\lib\jflex-1.6.1.jar %1 %2 %3 %4 %5 %6 %7 %8 %9

move /Y M6809Lexer.java ..

