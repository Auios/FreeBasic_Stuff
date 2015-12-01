#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

scrn(,,,,"Texture Background")

dim shared as any ptr img

'img = imagecreate(500,500,rgba(0,0,0,255))
img = imagecreate(500,500)
bload "pap2.bmp",img

'Player Entity Properties
type entProp
    as single x,y,vx,vy
    as single walkSpeed,jumpSpeed,scale
    as uinteger clr
    
    as ubyte jumping
    
    declare sub jump
end type

sub entProp.jump()
    if jumping = 0 then
        jumping = 1
        vy = jumpSpeed
    end if
end sub
dim shared as entProp ent

'World Properties
type worldProp
    as single gravity,airFric,groundFric
end type
dim shared as worldProp world

sub init
    with ent
        .x = sc.x*rnd
        .y = sc.y*rnd
        .walkSpeed = .7
        .jumpSpeed = 2
        .scale = 50
        .jumping = 1
        .clr = rgba(100,200,100,255)
    end with
    
    with world
        .gravity = .02
        .airFric = .5
        .groundFric = 1
    end with
end sub

sub controller()
    with ent
'        if multikey(sc_w) then .vy=.
'        if multikey(sc_s) then .vy=.
        if multikey(sc_a) then .vx-=.walkSpeed
        if multikey(sc_d) then .vx+=.walkSpeed
        if multikey(sc_space) then .jump()
    end with
end sub

sub calc()
    with ent
        'Check borders
        if .x > sc.x   then .x = sc.x
        if .x < 0      then .x = 0
        if .y < 0      then .vy = 0
        if .y+.scale/2 > sc.y   then
            .jumping = 0
            .y = sc.y-.scale/2
        end if
        
        if .jumping then
            .vy-=world.gravity
            .y-=.vy
        end if
        
        .x+=.vx
        .vx+=(.vx*-1)*world.groundFric
        
    end with
end sub

sub render()
    screenlock
    cls
    line(0,0) - (sc.x,sc.y),rgba(255,255,255,100),"bf"
    
    'Render Entity
    with ent
        'line(.x,.y)-(.x+.scale,.y+.scale),.clr,"bf"
        circle(.x,.y),.scale/2,.clr,,,,f
    end with
    
    for ix as integer = 0 to sc.x step 500
        for iy as integer = 0 to sc.y step 500
            put(ix,iy),img
        next iy
    next ix
    screenunlock
end sub

'==========

init()

'Main
do
    controller()
    calc()
    render()
    
    sleep 1,1
loop until multikey(sc_escape)

imagedestroy(img)
end 0