@echo off
set bin2s=C:\FreeBasic\bin\bin2s.exe
set as=C:\FreeBasic\bin\win32\as.exe

if not exist "%~dp1\%~n1%~x1" goto :error1
set ext=%~x1
set ext=%ext:~1,3%
set name=%~n1_%ext%

set bifile="%~dp1\%name%.bi"
%bin2s% "%~dp1\%~n1%~x1" > "%~dp1\%~n1.tmp.s"
if not exist "%~dp1\%~n1.tmp.s" goto :error2
%as% "%~dp1\%~n1.tmp.s" -o "%~dp1\%~n1_%ext%.o"
del "%~dp1\%~n1.tmp.s"
if not exist "%~dp1\%~n1_%ext%.o" goto :error3
echo extern as ulong %name%_size  alias "%name%_size" >%bifile%
echo dim shared as any ptr %name%_ptr >>%bifile%
echo asm mov dword ptr [%name%_ptr], offset %name% >>%bifile%
goto :eof

:error1
echo file not found '%1'
pause >nul
goto :eof

:error2
echo failed to generate assembly file from '%1'
pause >nul
goto :eof

:error3
echo failed to generate .o from '%1'
pause >nul

rem temp2_bas_size
rem temp2_bas_end
rem global temp2_bas
