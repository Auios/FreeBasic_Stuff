'#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

screenRes(1200,600,32,0)

'Types
type EntProp
    as ushort used
    as uinteger ID
    as single x,y
    as single rx,ry
    as single vx,vy
    as single mass
end type
dim shared as uinteger MinEnt,MaxEnt
MinEnt = 1
MaxEnt = 50
dim shared as EntProp Ent()
redim preserve Ent(MinEnt to MaxEnt)

'Variables
dim shared as EVENT e

'Functions
function Distance(x1 as single, y1 as single, x2 as single, y2 as single) as single
    return sqr((x2 - x1)^2 + (y2 - y1)^2)
end function

function GiveID as uinteger
    static GlobID as uinteger
    GlobID+=1
    return GlobID
end function

'Subs
sub Init()
    for i as uinteger = MinEnt to MaxEnt
        with ent(i)
            .Used = 1
            .ID = GiveID()
            .x = 1200*rnd
            .y = 600*rnd
            .mass = 10*rnd
        end with
    next i
end sub

sub math()
    for i as integer = MinEnt to MaxEnt
        for j as integer = MinEnt to MaxEnt
            if i <> j then
                dim as single dis = distance(ent(i).x,ent(i).y,ent(j).x,ent(j).y)
                
                dim as single disx = ent(i).x-ent(j).x
                dim as single disy = ent(i).y-ent(j).y
                
                dim as single force = ent(j).mass/dis
                dim as single acc=-force/ent(i).mass
                
                acc/=10000000
                
                ent(i).vx+=disx*acc
                ent(i).vy+=disy*acc
                
                ent(i).x+=ent(i).vx
                ent(i).y+=ent(i).vy
            end if
        next j
    next i
end sub

sub Render()
    screenlock
    cls
    for i as uinteger = MinEnt to MaxEnt
        with ent(i)
            if .used = 1 then
                var t = 255
                .rx = (.rx+.x) shr 1
                .ry = (.ry+.y) shr 1
                circle(.rx,.ry),.mass,rgb(t,t,t),,,,F
'                pset(.x,.y),rgb(t,t,t)
            else
                continue for
            end if
        end with
    next i
    screenunlock
end sub

sub Controller()
    If (ScreenEvent(@e)) Then
        Select Case e.type
        'On key press
        Case EVENT_KEY_PRESS
            if multikey(sc_escape) then end
            if multikey(sc_r) then Init()
        end Select
    end if
end sub

'Initiate()
Init()

'Main Loop
sleep 500
do
    Math()
    Render()
    Controller()
    
    sleep 1,1
loop until multikey(sc_escape)