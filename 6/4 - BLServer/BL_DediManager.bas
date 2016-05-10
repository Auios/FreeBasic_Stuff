'Blockland Dedicated Server Manager
'Author: Auios

#include "windows.bi"
#include "crt.bi"

randomize timer

declare function getInput() as string
declare function startProgram(programName as string) as ulong
declare sub terminateApp(PID as dword)

enum menus
    exitProgram
    mainMenu
    options
end enum

dim as ubyte textClr = 4*rnd+10
dim as zstring*2 userInput
dim as menus menu = mainMenu

dim as ulong PID

color textClr

do
    cls
    select case(menu)
    case mainMenu
        printf(!"Main Menu\n")
        printf(!"1. Start server\n")
        printf(!"2. End server\n")
        printf(!"3. Options\n")
        printf(!"\n0. Exit\n")
        print(PID)
        userInput = getInput()
        
        select case(userInput)
        case "1"
            '.\blockland.exe ptlaaxobimwroe -dedicated -map skylands
            'run(".\start.bat")
            PID = startProgram("C:\Users\LoneA\Dropbox\Adat\Servers\Blockland\Logic\blockland.exe ptlaaxobimwroe -dedicated -map skylands")
        case "2"
            'taskkill /IM blockland.exe -F
            'shell("taskkill /IM blockland.exe -F")
            terminateApp(PID)
        case "3"
            menu = options
        case "0"
            menu = exitProgram
        end select
        
    case options
        printf(!"Options\n")
        printf(!"\n0. Go back\n")
        userInput = getInput()
        
        select case(userInput)
        case "0"
            menu = mainMenu
        end select
    end select
loop until(menu = exitProgram)

end(0)

function getInput() as string
    dim as string keyPress
    
    printf(!"Input: ")
    do
        keyPress = inkey()
    loop until len(keyPress) > 0
    
    return keyPress
end function

function startProgram(programName as string) as ulong
    'Credits: Ham62
    dim as STARTUPINFO tStart = type(sizeof(STARTUPINFO))
    dim as PROCESS_INFORMATION tInfo
    dim as ulong PID
    if CreateProcess(null,programName,null,null,true,0,null,null,@tStart,@tInfo) = 0 then Print "Failed to start process"
    return tinfo.dwProcessID
end function

sub terminateApp(pid as ulong)
    'Credits: https://perrohunter.com/how-to-kill-a-process-by-its-pid-on-windows/
    dim as handle handy
    handy = OpenProcess(SYNCHRONIZE or PROCESS_TERMINATE, TRUE, pid)
    terminateProcess(handy, 0)
    PID = 0
end sub