#include "scrn.bas"
#include "fbgfx.bi"
using fb

#define fbc -a res/res.obj -s gui

randomize timer

declare sub init()
declare sub controller()
declare sub mouseLeftClick()
declare sub render()

declare function Dist_2d(x1 as single,y1 as single,x2 as single,y2 as single) as single

scrn(,,,,,"Graphing")

dim shared as integer half:half = sc.y/2
dim shared as uinteger c
dim as ubyte entmax
dim shared as event e
dim shared as uinteger selected = 0

do
    entmax = 50'*rnd
loop until entmax > 10

type entprop
    as integer v
    as single x,y
    as uinteger ID
end type
dim shared as entprop ent(1 to entmax)

type mouseprop
    as integer x,y
end type
dim shared as mouseprop m

sub init()
    for i as integer = lbound(ent) to ubound(ent)
        with ent(i)
            .ID = i
            
            if i = lbound(ent) then
                .v = (sc.y*rnd-half)/2
            else
                var mm = 50
                .v = ent(i-1).v+(mm*rnd-mm/2)
            end if
            
            .x = i*(sc.x/ubound(ent))-((sc.x/ubound(ent))/2)
            .y = half-.v
        end with
    next i
end sub

sub controller()
    getmouse(m.x,m.y)
    
    if (screenevent(@e)) then
        select case e.type
        case event_key_release
            if e.scancode = sc_r then init()
            if e.scancode = sc_space then selected = 0
            
        case event_mouse_button_press
            if e.button = button_left then MouseLeftClick()
        end select
    end if
end sub

sub MouseLeftClick()
    dim as single dis1,dis2
    for i as integer = lbound(ent) to ubound(ent)
       with ent(i)
            if i = lbound(ent) then
                dis1 = dist_2d(m.x,m.y,.x,.y)
            end if
        end with
    next i
end sub

sub render()
    screenlock
    cls
    c = 50: line(0,0)-(sc.x,sc.y),rgb(c,c,c),"bf"
    c = 128:line(0,half)-(sc.x,half),rgb(c,c,c)
    
    for i as integer = lbound(ent) to ubound(ent)
        var j=i+1
        
        with ent(i)
            line(.x,half-10)-(.x,half+10),rgb(c,c,c)
            
            if i <> ubound(ent) then
                line(.x,half-.v)-(ent(j).x,half-ent(j).v)
            end if
            
            circle(.x,half-.v),2
        end with
    next i
    
    if selected <> 0 then
        with ent(selected)
            line(.x,.y)-(m.x,m.y)
        end with
    end if
    
    screenunlock
end sub

function Dist_2d(x1 as single,y1 as single,x2 as single,y2 as single) as single
    return sqr(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1)))
end function

init()

do
    controller()
    
    
    render()
    
    
    sleep 1,1
loop until multikey(sc_escape)