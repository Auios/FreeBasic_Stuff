' Example code for using getJoystick() with Xbox controllers by Auios

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

#include "fbgfx.bi"
#include "windows.bi"
using fb

screenres 800, 600, 32, 1, GFX_SHAPED_WINDOW

dim as XboxController myController
dim as integer result
const floatPrec = 1000

const pi = atn(1)*4
dim as single x, y
x = 400
y = 300

dim as point p
getCursorPos(@p)

dim as taginput keyEvent
keyEvent.type = INPUT_KEYBOARD
keyEvent.ki.wVK = &h1B
keyEvent.ki.wScan = MapVirtualKeyEx(&h1B, 0, cast(HKL,&hf0010413))

do
    screenLock()
    cls()
    line(0,0)-(800,600),rgb(220,220,200),bf
    result = getXboxController(JoystickID, myController)
    
    myController.triggers = cint(floatPrec * myController.triggers ) / floatPrec
    myController.lax = cint(floatPrec * myController.lax ) / floatPrec
    myController.lay = cint(floatPrec * myController.lay ) / floatPrec
    myController.rax = cint(floatPrec * myController.rax ) / floatPrec
    myController.ray = cint(floatPrec * myController.ray ) / floatPrec
    
    ' If you want to turn your analog input into a straight dpad input you can try this:
    ' x = cast(integer, x)
    ' y = cast(integer, y)
    
    myController.triggers = cast(integer, myController.triggers)
    
    print("Result       -> " & result)
    print("Buttons      -> " & myController.buttons)
    print("Triggers     -> " & myController.triggers)
    print("Left analog  -> (" & myController.lax & ", " & myController.lay & ")")
    print("Right analog -> (" & myController.rax & ", " & myController.ray & ")")
    print("DPad         -> (" & myController.dpadx & ", " & myController.dpady & ")")
    print("")
    
    for i as integer = 0 to 31
        If (myController.buttons And (1 Shl i)) Then
            Print "Button ";i;" pressed.    "
        Else
            Print "Button ";i;" not pressed."
        End If
    next i
    
    if(myController.buttons And (1 SHL 1)) then sendInput(1, @keyEvent, sizeof(keyEvent))
    
    x+=myController.lax
    y+=myController.lay
    
    circle(x,y),50,rgb(100,100,200),,,,f
    for yy as single = y-2 to y+2
        for xx as single = x-2 to x+2
            line(xx, yy)-(x + myController.rax * 50, y + myController.ray * 50), rgb(250,50,50)
            line(xx, yy)-(x + myController.lax * 50, y + myController.lay * 50), rgb(255,255,255)
        next xx
    next yy
    
    getCursorPos(@p)
    p.x+=myController.rax*2
    p.y+=myController.ray*2
    setCursorPos(p.x, p.y)
    
    screenUnlock()
    
    sleep(1,1)
loop until(inkey = chr(27))

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
