#include "windows.bi"
#include "fbgfx.bi"
#include "aulib.bi"

#include "headers/AuFont.bas"

using fb, aulib

screencontrol(fb.SET_DRIVER_NAME,"GDI")
dim as AuWindow wnd
wnd.init()
wnd.show()

SetFont("Impact",15)

screenlock
    line(0,0)-(wnd.wdth,wnd.hght),rgb(200,200,200),bf
    printFont(5,10,"The newborn partner of our company is you!",rgb(255,0,0))
    printOutlineFont(50,50,"Hello world!",rgb(0,0,0),rgb(255,255,255),1)
screenunlock

sleep()

wnd.destroy()
end 0