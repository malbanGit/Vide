@echo off
setlocal enableextensions enabledelayedexpansion
set GCC=..\..\gcc6809
set GCC_FLAGS=-quiet -W -Wall -Wextra -Wconversion -Wno-return-type -Werror -fomit-frame-pointer -fno-toplevel-reorder -mint8 -msoft-reg-count=0 -std=gnu99 -fno-time-report 
set GCC_INC=-I include -I %GCC%\inc
set TARGET=%1
if [%TARGET%] == [] (
	set TARGET=assemble
)
set "OPT=%2"
if [%OPT%] == [] (
	set "OPT=-O2"
)
call :main %TARGET% "%OPT%"
REM call :main assemble "%OPT%"
exit /B %ERRORLEVEL%

:find_source_files - path pattern
    set source_paths=
    set source_files=
	set files=
    for /r "%~1" %%P in ("%~2") do (
        set source_paths=!source_paths! "%%~fP"
        set source_files=!source_files! "%%~nP%%~xP"
		set files=!files! "%%~nP"
    )
goto :eof

:separator
	echo *************************************************************************
exit /B 0

:line
	echo -------------------------------------------------------------------------
exit /B 0

:remove - FILE
	set FILE=%1
	if exist %FILE% (
		echo removing %FILE%
		del %FILE% 
	)
exit /B 0

:wipe - FOLDER
	set FOLDER=%1
	call :remove .\%FOLDER%\*.i
	call :remove .\%FOLDER%\*.s
	call :remove .\%FOLDER%\*.lst
	call :remove .\%FOLDER%\*.rel
	call :remove .\%FOLDER%\*.rst
	call :remove .\%FOLDER%\*.map
	call :remove .\%FOLDER%\*.s19
	call :remove .\%FOLDER%\*.bin
	call :remove .\%FOLDER%\*.cnt
exit /B 0

:clean
	call :wipe bin
	call :wipe build
exit /B 0

:preprocess - SOURCE DEST GCC_OPT
	setlocal enableextensions enabledelayedexpansion
	set FILE=%~n1
	set SOURCE=%1
	set DEST=%2
	set GCC_OPT=-E %~3
	echo preprocessing %FILE%.c
	%GCC%\bin\gcc6809.exe %GCC_INC% %GCC_FLAGS% %GCC_OPT% -o %DEST%\%FILE%.i %SOURCE% || exit \b
exit /B 0

:compile - SOURCE DEST GCC_OPT
	setlocal enableextensions enabledelayedexpansion
	set FILE=%~n1
	set SOURCE=%1
	set DEST=%2
	set GCC_OPT=%~3
	echo compiling %FILE%.c
	%GCC%\bin\gcc6809.exe %GCC_INC% %GCC_FLAGS% %GCC_OPT% -o %DEST%\%FILE%.s %SOURCE% || exit \b
exit /B 0

:optimize - FILE FOLDER
	setlocal enableextensions enabledelayedexpansion
	set FILE=%1
	set FOLDER=%2
	%GCC%\optimize\rxrepl --no-backup --return-count -f .\%FOLDER%\%FILE%.s -a  --options %GCC%\optimize\rules_optimize.txt
	echo %ERRORLEVEL% line(s) optimized in %FILE%.s
exit /B %ERRORLEVEL%

:assemble - FILE FOLDER
	set FILE=%1
	set FOLDER=%2
	echo assembling %FILE%.s
	%GCC%\bin\as6809.exe -x -p -l -o -g .\%FOLDER%\%FILE%.rel .\%FOLDER%\%FILE%.s || exit \b
exit /B 0

:link - PROJECT FILES
	setlocal enabledelayedexpansion
	set PROJECT=%1
	set FILES=empty
	for %%F in (.\build\*.rel) do (
		if !FILES!==empty (
			set FILES=%%~nF.rel
		) else (
			set FILES=!FILES! %%~nF.rel
		)
	)
	echo linking !FILES!
	%GCC%\bin\aslink.exe -n -m -u -w -s -k %GCC%\lib\ -l libgcov.a -l as-libgcc.a -l libgcc.a .\build\%PROJECT%.s19 .\build\*.rel 1>nul || exit \b
exit /B 0

:getFilesize - FILE
	set filesize=%~z1
exit /B

:build - PROJECT
	set PROJECT=%1
	%GCC%\bin\srec2bin.exe -q .\build\%PROJECT%_rom.s19 .\build\%PROJECT%_rom.bin || exit \b
	call :getFilesize .\build\%PROJECT%_rom.bin
	@echo rom size is %fileSize% bytes
	%GCC%\bin\srec2bin.exe -q -o -0xc880 .\build\%PROJECT%_ram.s19 .\build\%PROJECT%_ram.bin || exit \b
	call :getFilesize .\build\%PROJECT%_ram.bin
	@echo ram size is %fileSize% bytes
	echo building %PROJECT%.bin
	@copy /b .\build\%PROJECT%_rom.bin+.\build\%PROJECT%_ram.bin .\bin\%PROJECT%.bin 1>nul || exit \b
	call :getFilesize .\bin\%PROJECT%.bin
	@echo bin size is %fileSize% bytes
exit /B 0

:copy - PROJECT
	set PROJECT=%1
	echo copying...
	copy .\build\%PROJECT%.bin C:\temp\%PROJECT%.bin || exit \b
exit /B 0

:make_clean - PROJECT
	set PROJECT=%1
	call :separator
	echo cleaning project %PROJECT% ...
	call :clean
exit /B 0

:make_preprocess - PROJECT "OPT"
	setlocal enableextensions enabledelayedexpansion
	set PROJECT=%1
	set "OPT=%2"
	call :make_clean %PROJECT%
	call :separator
	echo preprocessing project %PROJECT% ...
	for /R . %%F in (*.c) do (
		call :line
		set RELATIVE=%%F
		call :preprocess !RELATIVE:%CD%\=! build "%OPT%"
	)
exit /B 0

:make_compile - PROJECT OPT
	setlocal enableextensions enabledelayedexpansion
	set PROJECT=%1
	set "OPT=%2"
	call :make_preprocess %PROJECT% "%OPT%"
	call :separator
	echo compiling project %PROJECT% ...
	for /R . %%F in (*.c) do (
		call :line
		set RELATIVE=%%F
		call :compile !RELATIVE:%CD%\=! build "%OPT%"
	)
exit /B 0

:make_optimize - PROJECT OPT
	setlocal enableextensions enabledelayedexpansion
	set PROJECT=%1
	set "OPT=%2"
	call :make_compile %PROJECT% "%OPT%"
	set ASS_OPT=0
	call :separator
	echo optimizing project %PROJECT% ...
	call :line
	for %%F in (.\build\*.s) do	(
		call :optimize %%~nF build
		set /a "ASS_OPT=!ASS_OPT! + !ERRORLEVEL!"
	)
	call :line
	echo !ASS_OPT! line(s) optimized in all files
exit /B 0

:make_assemble - PROJECT OPT
	set PROJECT=%1
	set "OPT=%2"
	call :make_optimize %PROJECT% "%OPT%"
	call :separator
	echo assembling project %PROJECT% ...
	for %%F in (.\build\*.s) do	(
		call :assemble %%~nF build
	)
	call :separator
	call :wipe .\lib
	call :line
	echo installing %PROJECT% system libraries ...
	@copy .\build\*.lst .\lib 1>nul || exit \b
	@copy .\build\*.rel .\lib 1>nul || exit \b
exit /B 0

:make_link - PROJECT OPT
	set PROJECT=%1
	set "OPT=%2"
	call :make_assemble %PROJECT% "%OPT%"
	call :separator
	echo linking project %PROJECT% ...
	call :link %PROJECT%
exit /B 0

:make_build - PROJECT OPT
	set PROJECT=%1
	set "OPT=%2"
	call :make_link %PROJECT% "%OPT%"
	call :separator
	echo building project %PROJECT% ...
	call :build %PROJECT%
exit /B 0

:make_lint - PROJECT
	set PROJECT=%1
	set FILES=%GCC%\vectrex\include\*.h %GCC%\vectrex\source\*.c
	call :separator
	echo linting project %PROJECT% ...
	for /R . %%F in ("*.c") do (
		set RELATIVE=%%F
		set FILES=!FILES! !RELATIVE:%CD%\=!
	)
	for /R . %%F in ("*.h") do (
		set RELATIVE=%%F
		set FILES=!FILES! !RELATIVE:%CD%\=!
	)
	echo %FILES%
	start /B /W C:\Programme\Cppcheck\cppcheck -j 1 --quiet --language=c --enable=warning,style,performance,portability,information,missingInclude --inconclusive --std=c99 --template=gcc -I .\include -I .\source -I %GCC%\vectrex\include -I %GCC%\vectrex\source %FILES%
	FOR /L %%I IN (1,1,99999) DO REM adapt delay loop is output is interleaved
exit /B 0

:make_run - PROJECT
	set PROJECT=%1
	call :separator
	@del ..\..\ParaJVE\project\project.bin
	@copy .\bin\%PROJECT%.bin ..\..\ParaJVE\project\project.bin || exit \b
	@del ..\..\ParaJVE\project\project.png
	@copy .\overlay\%PROJECT%.png ..\..\ParaJVE\project\project.png
	@del ..\..\ParaJVE\project\project.pdf
	@copy .\manual\%PROJECT%.pdf ..\..\ParaJVE\project\project.pdf
	echo running project %PROJECT% ...
	start "%PROJECT%" /D ..\..\ParaJVE ParaJVE.exe -game="PROJECT" -config="project/configuration.xml"
exit /B 0

:make - TARGET PROJECT OPT
	set TARGET=%1
	set PROJECT=%2
	set "OPT=%3"
	@if %TARGET% == clean (
		@call :make_clean %PROJECT%
	) else if %TARGET% == preprocess (
		@call :make_preprocess %PROJECT% "%OPT%"
	) else if %TARGET% == compile (
		@call :make_compile %PROJECT% "%OPT%"
	) else if %TARGET% == optimize (
		@call :make_optimize %PROJECT% "%OPT%"
	) else if %TARGET% == assemble (
		@call :make_assemble %PROJECT% "%OPT%"
	) else if %TARGET% == link (
		@call :make_link %PROJECT% "%OPT%"
	) else if %TARGET% == build (
		@call :make_build %PROJECT% "%OPT%"
	) else if %TARGET% == lint (
		@call :make_lint %PROJECT%
	) else if %TARGET% == run (
		@call :make_run %PROJECT%
	) else (
		@echo ERROR - unknown target: clean, preprocess, compile, optimize, assemble, link, build, lint, run
		@exit /B 1
	)
	call :separator
	echo done
	call :separator
exit /B 0

:main - TARGET OPT
	set TARGET=%1
	if [%TARGET%] == [] (
		set TARGET=assemble
	)
	set "OPT=%2"
	if [%OPT%] == [] (
		set "OPT=-O0"
	)
	set PROJECT=
	for %%i in (.) do @set PROJECT=%%~ni
	if [%PROJECT%] == [] (
		@echo ERROR - could not determine project name
		@exit /B 1		
	) else (
		call :make %TARGET% %PROJECT% "%OPT%"
	)
exit /B 0
