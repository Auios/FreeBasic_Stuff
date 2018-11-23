#include "fbgfx.bi"
#include "windows.bi"
using fb

type XboxController
    as integer buttons
    as single lax, lay
    as single rax, ray
    as single dpadx, dpady
    as single triggers
end type

function getXboxController(ID as long, xbct as xboxController) as integer
    return getJoystick(ID, xbct.buttons, xbct.lax, xbct.lay, xbct.triggers, xbct.ray, xbct.rax, , xbct.dpadx, xbct.dpady)
end function

const joystickID = 0

' Check to see if the joystick is okay.
if getJoystick(joystickID) Then
    Print "Joystick doesn't exist or joystick error."
    Print
    Print "Press any key to continue."
    Sleep
    End
end if

sub sendKey(code as ulong)
    dim as taginput keyEvent
    keyEvent.type = INPUT_KEYBOARD
    keyEvent.ki.wVK = code
    keyEvent.ki.wScan = MapVirtualKeyEx(keyEvent.ki.wVK, 0, cast(HKL,&hf0010413))
    sendInput(1, @keyEvent, sizeof(keyEvent))
end sub

dim as XboxController con

const floatPrec = 1000

dim as single start

dim as point p
getCursorPos(@p)

do
    getXboxController(JoystickID, con)
    
    con.triggers = cint(floatPrec * con.triggers ) / floatPrec
    con.lax = cast(integer, con.lax)
    con.lay = cast(integer, con.lay)
    con.rax = cint(floatPrec * con.rax ) / floatPrec
    con.ray = cint(floatPrec * con.ray ) / floatPrec
    
    con.triggers = cast(integer, con.triggers)
    
    if(timer() - start > 0.002) then
        if(con.lax < 0) then sendKey(65)
        if(con.buttons And (1 SHL 1)) then sendKey(27)
        
        getCursorPos(@p)
        p.x+=con.rax
        p.y+=con.ray
        setCursorPos(p.x, p.y)
        start = timer()
    end if
loop until(con.buttons And (1 SHL 6))

'   0   A
'   1   B
'   2   X
'   3   Y
'   4   Left
'   5   Right
'   6   Back
'   7   Start
'   8   Left Analog Button
'   9   Right Analog Button
