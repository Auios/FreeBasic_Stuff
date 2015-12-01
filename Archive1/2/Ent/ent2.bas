#include "header.bas"

Init_Screen() '95,169

Sub MainMenu()
    do
        locate(46,80):print "===Menu====="
        locate(47,80):print "1.  New Data"
        locate(48,80):print "2. Load Data"
        locate(50,80):print "0.      Quit"
        locate(51,80):print "============"
        locate(52,80):input "",ans
        cls
        
        select case ans
        case 0
            startprog = 0
            stop
        case 1
            for i as integer = 0 to Max_Ent
                Init_Var(i)
            next i
            StartProg = 1
        case 2
            for i as integer = 0 to Max_Ent
                FileRead(i)
            next i
            Startprog = 1
        end select
    loop until StartProg = 1
end sub

do
    select case startprog
    case 1
        screenlock
        cls
        for i as integer = 0 to max_ent
            Core(i)
            ScreenBorder(i)
            Render(i)
        next i
        screenunlock
        sleep 10
        if multikey(sc_escape) then
            cls
            for i as integer = 0 to max_ent
                FileWrite(i)
            next i
            startprog = 0
        end if
    case 0
        mainmenu()
    end select
loop until multikey(sc_q)

cls
print "Data Saved!"
sleep
stop
