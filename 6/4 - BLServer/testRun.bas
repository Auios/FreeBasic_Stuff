#include "windows.bi"
sub startProgram(programName as string)
    dim as STARTUPINFO tStart = type(sizeof(STARTUPINFO))
    dim as PROCESS_INFORMATION tInfo
    if CreateProcess(null,programName,null,null,true,0,null,null,@tStart,@tInfo) = 0 then Print "Failed to start process"
end sub

startProgram("start.bat")