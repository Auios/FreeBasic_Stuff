#include "fbgfx.bi"
'#include "scrn.bas"
using fb

randomize timer

'scrn()
screenRes(800, 600, 32, 1, 0)

dim shared as uinteger oldsz,sz = 1
dim shared as ubyte R,G,B
dim shared as event e

sub saveImage()
    dim as uinteger buffer
    
    var filename = "img.txt"
    var ff = freefile
    
    open filename for output as #ff
    print #ff,800,600,sz
    for x as integer = 0 to 800-1
        for y as integer = 0 to 600-1
            buffer = point(x,y)
            print #ff,buffer
        next y
    next x
    
    close #ff
end sub

sub controller()
    if screenevent(@e) then
        select case e.type
        case event_key_press
            if e.scancode = sc_w then sz+=1
            if e.scancode = sc_s and sz > 1 then sz-=1
            if e.scancode = sc_r then sz = 4*rnd
            
            if e.scancode = sc_t then saveImage()
            
            if e.scancode = sc_enter then input "Size: ",sz
            
            if e.scancode = sc_escape then end 0
        case EVENT_KEY_REPEAT
            if e.scancode = sc_w then sz+=1
            if e.scancode = sc_s and sz > 1 then sz-=1
            if e.scancode = sc_r then sz = 4*rnd
            
            if e.scancode = sc_t then saveImage()
            
            if e.scancode = sc_enter then input "Size: ",sz
            
            if e.scancode = sc_escape then end 0
        end select
    end if
end sub

sub calc()
end sub

sub generateImage()
    for x as integer = 0 to 800 step sz
        for y as integer = 0 to 600 step sz
            var tx = (x - 800 / 2) / 800 * 16
            var ty = (y - 600 / 2) / 600 * 16
            R = (cos(sin(tx)*ty+sin(ty)*tx) * 127 + 128)
            G = (sin(cos(tx)*ty+sin(ty)*tx) * 127 + 128)
            B = (sin(sin(tx)*ty+cos(ty)*tx) * 127 + 128)
            line(x,y)-(x+sz,y+sz),rgb(R,G,B),"bf"
        next y
    next x
end sub

sub render()
    if oldsz <> sz then
        oldsz = sz
        screenlock
        cls
        
        generateImage()
        
        print sz
        screenunlock
    end if
end sub

do
    controller()
    calc()
    render()
    
    sleep 1,1
loop until multikey(sc_escape)

end 0