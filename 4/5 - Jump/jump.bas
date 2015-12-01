#include "scrn.bas"
#include "fbgfx.bi"
using fb
randomize timer

'Make window
scrn()

'Declare the laws of physics
type physicsprop
    as single g
    as single floor,drag
end type
dim shared as physicsprop phy 'as phy

'Declare player properties
type playerprop
    as single x,y,vx,vy
    as ushort jump,mover,movel
    as single jforce,mforce
end type
dim shared as playerprop pl 'as pl

'Initiate and set variables
sub init()
    'Give the laws of physics variables. If no variables are given then divide God by zero...
    with phy
        .g = .6
        .drag = .2
        .floor = sc.y/1.2
    end with
    
    'Tell the player what-for and how it's gonna be. If the player does not like his genetics then idk
    with pl
        .x = 100
        .y = sc.y/2
        .jump = 0
        .jforce = 10
        .mforce = 2
    end with
end sub

'Get all human input here
sub controller()
    with pl
        if multikey(sc_escape)  then stop
        if multikey(sc_space and .jump = 0)   then
            .jump = 1
            .vy = .jforce
        end if
        if multikey(sc_a) then
            .movel = 1
            .vx = .mforce
        end if
        if multikey(sc_d) then
            .mover = 1
            .vx = .mforce
        end if
    end with
end sub

'After you got the input, let's figure out what the fuck to do with it.
sub calc()
    with pl
        if .jump then 'Math ~ Jumping
            .y-=.vy
            .vy-=phy.g
            if .y > phy.floor then
                .jump = 0
                .y = phy.floor
            end if
        end if
        if .movel then 'Math ~ Moving left
            .x-=.vx
            .vx-=phy.drag
            if .vx <= 0 then .movel = 0
        end if
        if .mover then 'More math ~ Moving right
            .x+=.vx
            .vx-=phy.drag
            if .vx <= 0 then .mover = 0
        end if
    end with
end sub

'Genesis 1:3 ~ And God said, "Let there be light," and there was light.
'God saw that the light was good; and God separated the light from the darkness...
sub render()
    'I think it's easier to color using this local variable
    dim as integer c
    
    cls
    
    c = 75 'So simple
    line(0,phy.floor+50)-(sc.x,sc.y),rgb(c,c,c),"bf" 'The gray box
    line(0,0)-(sc.x,phy.floor),rgb(80,157,225),"bf" 'The sky
    line(0,phy.floor)-(sc.x,phy.floor+50),rgb(120,220,10),"bf" 'The ground platform
    
    'Genesis 1:27 ~ So God created mankind in his own image, a fat blob circle.
    with pl
        c = 100 'So easy
        circle(.x,.y),25,rgb(c,c,c),,,1.5,f '<- Depressing
        if .jump = 1 then draw string(.x-9,.y-5),"^;-;^"
        if .mover = 1 and .jump = 0 then draw string(.x-9,.y-5),":D"
        if .movel = 1 and .jump = 0 then draw string(.x-9,.y-5),"(:"
        if .mover = 0 and .movel = 0 and .jump = 0 then draw string(.x-9,.y-5),"-.-"
    end with
    
    'I plan to replace almost everything in this sub with legitimate textures.
end sub

'===============================================================================Run

init()

'int main()
do
    controller() 'WASD, SPACE
    calc() 'Math
    
    'Stop right there criminal scum!
    screenlock
    render()
    screenunlock
    'Prison time sentence served. You are now a free man, go and color pixels now.
    
    'Gee look at the time; I am early, best wait some.
    sleep 15
loop until multikey(sc_escape)

'End of chapter...