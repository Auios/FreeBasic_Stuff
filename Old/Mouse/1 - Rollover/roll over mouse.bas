#include "fbgfx.bi"
using fb

randomize timer

dim as integer scrnx,scrny,depth,pitch,rate,driver
ScreenRes 800,600,8,2,0
screeninfo scrnx,scrny,depth,pitch,rate,driver

dim as integer x,y,lastx,lasty
dim as integer size,col,pointcol,pointresult
dim as integer mousex,mousey,wheel,clip,mouseresult
dim as integer toggle,boxeskilled

dim as integer clicks

dim as string control = "BOX"

col=40
size=10
toggle = 1

mouseresult=setmouse(scrnx/2,scrny/2)

do
    
    if multikey(sc_escape) then control = "EXIT"
    if multikey(sc_r) then control = "CLEAR40"
    if multikey(sc_f) then control = "FULLSCREEN"
    
    'if multikey(sc_w) then control = "NORTH"
    'if multikey(sc_s) then control = "SOUTH"
    'if multikey(sc_d) then control = "EAST"
    'if multikey(sc_a) then control = "WEST"
    
    While Inkey <> "": Wend
    
    if clip = 1 and pointcol = 40 then clicks+=1
    if pointresult = 3 then mouseresult=setmouse(lastx,lasty)
    if pointresult = 15 then mouseresult=setmouse(lastx,lasty)
    
    lastx=mousex
    lasty=mousey
    mouseresult = getmouse(mousex,mousey,wheel,clip)
    pointresult = point(mousex,mousey)
    
    screenlock
    line (0,0) - (150,95),3,"bf"
    
    draw string (5,5), "X: "          & mousex
    draw string (5,15),"Y: "          & mousey
    draw string (5,25),"Color: "      & pointresult
    draw string (5,35),"Mouse: "      & (mouseresult-1) * -1
    draw string (5,45),"Clip: "       & clip
    draw string (5,55),"Wheel: "      & wheel
    draw string (5,65),"Color: "      & pointcol
    draw string (5,75),"Clicked: "    & clicks
    draw string (5,85),"Boxes Killed:"& boxeskilled
    screenunlock
    
    select case control
    case "MAIN"
        
        if pointresult = 40 then control = "CLEAR40"
        
    case "BOX"
        
        do
            x=scrnx*rnd
            y=scrny*rnd
        loop until (x<scrnx-size) and (y<scrny-size)
        
        screenlock
        line(x-size,y-size)-(x+size,y+size),col,bf
        screenunlock
        
        control="MAIN"
        
    case "CLEAR40"
        
        screenlock
        line(x-size,y-size)-(x+size,y+size),0,bf
        screenunlock
        
        boxeskilled+=1
        control = "BOX"
        
    case "FULLSCREEN"
        
        if toggle = 1 then
            screenres scrnx,scrny,8,2,toggle
            toggle = 0
        else
            screenres scrnx,scrny,8,2,toggle
            toggle = 1
        end if
        
        While Inkey <> "": Wend
        control = "MAIN"
        
    end select
    
    
    sleep 1
    
loop until control = "EXIT"