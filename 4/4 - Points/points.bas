#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

scrn()

dim shared as integer max = 6

type entprop
    as ushort id
    as integer x,y
    as ushort direct
end type
dim shared as entprop ent(max)

sub init()
    for i as integer = 0 to max
        with ent(i)
            .id = i
            .x = sc.x*rnd
            .y = sc.y*rnd
            .direct = 3*rnd
        end with
    next i
end sub

sub controller()
    if multikey(sc_escape) then stop
    if multikey(sc_r) then init()
    if multikey(sc_space) then sleep
end sub

sub calc()
    for i as integer = 0 to max
        with ent(i)
            select case .direct
            case 0 'North East
                .x+=1:if .x > sc.x  then .direct = 1
                .y-=1:if .y < 0     then .direct = 2
            case 1 'North West
                .x-=1:if .x < 0     then .direct = 0
                .y-=1:if .y < 0     then .direct = 3
            case 2 'South East
                .x+=1:if .x > sc.x  then .direct = 3
                .y+=1:if .y > sc.y  then .direct = 0
            case 3 'South West
                .x-=1:if .x < 0     then .direct = 2
                .y+=1:if .y > sc.y  then .direct = 1
            end select
        end with
    next i
end sub

sub render()
    cls
    
    dim as integer d,c = 200
    line(0,0)-(sc.x,sc.y),rgb(c,c,c),"bf"
    for i as integer = 0 to max
        with ent(i)
            for j as integer = 0 to max
                if j <> i then
                    c = 150
                    d = 2
                    line(.x+d,.y)-(ent(j).x+d,ent(j).y),rgb(c,c,c)
                    line(.x-d,.y)-(ent(j).x-d,ent(j).y),rgb(c,c,c)
                    line(.x,.y+d)-(ent(j).x,ent(j).y+d),rgb(c,c,c)
                    line(.x,.y-d)-(ent(j).x,ent(j).y-d),rgb(c,c,c)
                    c = 75
                    d = 1
                    line(.x+d,.y)-(ent(j).x+d,ent(j).y),rgb(c,c,c)
                    line(.x-d,.y)-(ent(j).x-d,ent(j).y),rgb(c,c,c)
                    line(.x,.y+d)-(ent(j).x,ent(j).y+d),rgb(c,c,c)
                    line(.x,.y-d)-(ent(j).x,ent(j).y-d),rgb(c,c,c)
                    
                    c = 200
                    line(.x,.y)-(ent(j).x,ent(j).y),rgb(c,c,c)
                end if
            next j
        end with
    next i
    for i as integer = 0 to max
        with ent(i)
            c = 200
            circle(.x,.y),8,rgb(c,c,c),,,,f
            c = 120
            circle(.x,.y),5,rgb(c,c,c),,,,f
        end with
    next i
end sub

'===============================================================================Run

init()

do
    controller()
    calc()
    
    screenlock
    render()
    screenunlock
    
    sleep 5,1
loop 'until multikey(sc_escape)

screen 0
end 0