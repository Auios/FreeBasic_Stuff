#include "AuLib.bi"
#include "fbgfx.bi"

#include "Troop.bas"

using fb,aulib

randomize(timer())

dim as AuWindow wnd
wnd.init()
wnd.show()

dim as AuMouse ms
ms.hide()

dim as Event e

dim as boolean runApp = true

dim as Troop t
t.x = wnd.wdth/2
t.y = wnd.hght/2

while(runApp)
    dim as string k = inkey()
    if(k = chr(27)) then runApp = false
    
    if(multikey(sc_w)) then t.moveForward()
    if(multikey(sc_s)) then t.moveBackward()
    if(multikey(sc_a)) then t.turnLeft()
    if(multikey(sc_d)) then t.turnRight()
    
    if(screenEvent(@e)) then
        select case e.type
        case EVENT_MOUSE_MOVE
            ms.update()
        case EVENT_MOUSE_BUTTON_PRESS
            if(e.button = BUTTON_LEFT) then t.turnTo(ms.x,ms.y)
        end select
    end if
    
    t.Update()
    
    screenLock()
    cls()
    t.render()
    draw string(5,5),str(t.angle)
    draw string(5,15),str(t.targetAngle)
    draw string(5,25),str(t.targetAngle)
    
    'Draw mouse
    circle(ms.x,ms.y),1,,,,,f
    screenUnlock()
    
    sleep(1,1)
wend
