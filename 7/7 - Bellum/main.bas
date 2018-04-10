#include once "crt.bi"
#include once "fbgfx.bi"
#include once "gl2d.bi"

#include once "fpscounter.bas"
#include once "tile.bas"

using FB, GL2D

randomize(timer())

dim as boolean runApp = true
dim as string k
dim as FPSCounter FPSCnt
dim as event e
dim shared as integer scrnx,scrny
scrnx = 1400
scrny = 900

ScreenInit(scrnx, scrny)
VsyncON()

while(runApp)
    FPSCnt.start()
    
    if(screenEvent(@e)) then
        select case e.type
        case EVENT_KEY_PRESS
            if(e.scanCode = SC_ESCAPE) then runApp = false
        end select
    end if
    
    clearScreen()
    begin2D()
        'Print FPS
        PrintScale(5,5,1,str(FPSCnt.getFPS()))
    end2D()
    
    'limitFPS(60)
    sleep(1,1)
    flip()
    
    FPSCnt.check()
wend

sleep()