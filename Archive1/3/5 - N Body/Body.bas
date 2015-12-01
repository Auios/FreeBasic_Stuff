#include "scrn.bas"
#include "fbgfx.bi"
using fb
randomize timer

const timescale = 0.3
const Grav = 0.5

function Distance(x1 as single, y1 as single, x2 as single, y2 as single) as single
    return sqr((x2 - x1)^2 + (y2 - y1)^2)
end function

scrn(800,600,16,0)

dim shared as integer Slots
dim shared as integer Alive

Slots = 15
Alive = Slots

type EntProp
    as integer ID
    as single x,y
    as single vx,vy
    as uinteger clr
    as zstring*16 class
    as single mass
    as single radius
    as integer Used
end type
dim shared as EntProp Ent(Slots)

sub Initialize(i as integer)
    with ent(i)
        .ID = i
        .x = sc.x*rnd
        .y = sc.y*rnd
        .mass = 500 * rnd
        .used = 1
        .radius = sqr(.mass)
        .clr = rgb(255-.mass*.1,.mass*25,0)
    end with
end sub

sub Controller()
    if multikey(sc_escape) then stop
end sub

Sub NewBody1(i as integer)
    with ent(i)
        .ID = i
        .x = sc.x*rnd
        .y = sc.y*rnd
        .mass = 500 * rnd
        .used = 1
        .radius = sqr(.mass)
        .clr = rgb(255-.mass*.1,.mass*25,0)
        .vx = 0
        .vy = 0
    end with
end sub

sub DoMath(i as integer)
    with ent(i)
        for j as integer = 1 to Slots
            if ent(j).used = 0 then continue for
            if j <> .ID then
                dim as single dis = Distance(.x,.y,ent(j).x,ent(j).y)
                
                if dis <= .radius + ent(j).radius then
                    if .radius > ent(j).radius then
                        ent(j).Used = 0
                        
                        dim as single massratio = .mass/ent(j).mass
                        
                        .mass+=ent(j).mass
                        .radius = sqr(.mass)
                        
                        .vx = .vx+ent(j).vx * massratio
                        .vy = .vy+ent(j).vy * massratio
                    else
                        .used = 0
                        ent(j).radius+=.radius
                        dim as single massratio = ent(j).mass/.mass
                        
                        .mass+=ent(j).mass
                        ent(j).radius = sqr(ent(j).mass)
                        
                        ent(j).vx = ent(j).vx+.vx * massratio
                        ent(j).vy = ent(j).vy+.vy * massratio
                    end if
                    
                    Alive-=1
                end if
                
                dim as single disx = .x-ent(j).x
                dim as single disy = .y-ent(j).y
                dim as single force = ent(j).mass/dis
                dim as single acc=-force/.mass
                acc/=3
                
                acc*=timescale
                
                .vx+=disx*acc
                .vy+=disy*acc
                
                .x+=.vx
                .y+=.vy
            end if
        next j
        
        if Alive = 1 then
            for i as integer = 2 to Slots
                NewBody1(i)
                Alive+=1
            next i
        end if
    end with
end sub

Sub EdgeLoopBody(i as integer)
    with ent(i)
        if .x > sc.x then .x-=sc.x
        if .y > sc.y then .y-=sc.y
        if .x < 0 then .x+=sc.x
        if .y < 0 then .y+=sc.y
    end with
end sub

Sub EdgeLoopNew(i as integer)
    with ent(i)
        if .x > sc.x then NewBody1(i)
        if .y > sc.y then NewBody1(i)
        if .x < 0 then NewBody1(i)
        if .y < 0 then NewBody1(i)
    end with
end sub

sub CheckEdge(i as integer)
    var flag = 2
    
    select case flag
    case 1
        EdgeLoopBody(i)
    case 2
        EdgeLoopNew(i)
    end select
end sub

sub RenderAll(i as integer)
    with ent(i)
        circle(.x,.y),.radius,.clr,,,,f
        draw string(.x+.radius,.y+.radius),"Mass: " & .mass
    end with
end sub

sub RenderSingle()
    print Alive
end sub

for i as integer = 1 to Slots
    Initialize(i)
next i

do
    screenlock
    cls
        Controller()
        for i as integer = 1 to Slots
            if ent(i).used = 0 then continue for
            DoMath(i)
            CheckEdge(i)
            RenderAll(i)
        next
        RenderSingle()
    screenunlock
    sleep 10/timescale
loop until multikey(sc_escape)