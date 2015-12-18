#include "fbgfx.bi"
#include "auios/auios.bi"

using auios

'==========================

type player
    as integer x,y
    as uinteger clr
    as ubyte size
    as ubyte canMove
end type

'==========================

declare function init() as integer
declare function controller() as integer
declare function calc() as integer
declare function render() as integer

declare function clearWindow(clr as uinteger = rgb(0,0,0)) as integer

'==========================

dim shared as AuWindow wnd
dim shared as player pl
dim shared as double timerStart,moveTime = 0.012
dim shared as integer zx,zy

'==========================
screeninfo(zx,zy)
wnd = AuWindowInit(800,600,"Zoom Test",32,1,0)
AuWindowCreate(wnd)

clearWindow(rgb(100,100,100))

init()
do
    if controller() then exit do
    calc()
    render()
    
    sleep 1,1
loop until inkey = chr(27)

end AuWindowDestroy(wnd)

'==========================

function init() as integer
    timerStart = timer
    zx = 320
    zy = 200
    window(0,0)-(zx,zy)
    with pl
        .x = 100
        .y = 50
        .clr = rgb(200,100,100)
        .size = 20
        .canMove = 1
    end with
    return 1
end function

function controller() as integer
    dim as integer res = 0
    
    if inkey = chr(27) then res = 1
    
    if pl.canMove then
        with pl
            .canMove = 0
            if multikey(fb.sc_w) then .y+=1
            if multikey(fb.sc_s) then .y-=1
            if multikey(fb.sc_a) then .x-=1
            if multikey(fb.sc_d) then .x+=1
        end with
    end if
    
    if multikey(fb.sc_up) then
        zx-=1
        zy-=1
        window(0,0)-(zx,zy)
    end if
    if multikey(fb.sc_down) then
        zx+=1
        zy+=1
        window(0,0)-(zx,zy)
    end if
    
    return res
end function

function calc() as integer
    if timer-timerStart > moveTime then
        pl.canMove = 1
        timerStart = timer
    end if
    return 0
end function

function render() as integer
    screenlock
        cls
        clearWindow(rgb(100,100,100))
        line(5,5)-(320-5,200-5),,b
        'Render player
        with pl
            line(.x,.y)-(.x+.size,.y+.size),.clr,bf
        end with
    screenunlock
    
    return 0
end function

'-----------------

function clearWindow(clr as uinteger) as integer
    with wnd
        line(0,0)-(320,200),clr,bf
    end with
    return 0
end function
