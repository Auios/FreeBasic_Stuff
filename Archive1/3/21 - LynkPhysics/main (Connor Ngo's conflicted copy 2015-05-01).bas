#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

'Declares
declare function Distance(x1 as single, y1 as single, x2 as single, y2 as single) as single
declare function GiveID as uinteger

declare sub Init()
declare sub Math()
declare sub Render()
declare sub Controller()

scrn(1200,600,32,0,"Gravity Sim")

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
dim shared as uinteger TotalBounces

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
            .x = sc.x*rnd
            .y = sc.y*rnd
            .mass = 10*rnd
        end with
    next i
end sub

sub Math()
    for i as integer = MinEnt to MaxEnt
        for j as integer = MinEnt to MaxEnt
            if i <> j then
                with ent(i)
                    dim as single dis = distance(.x,.y,ent(j).x,ent(j).y)
                    
                    dim as single disx = .x-ent(j).x
                    dim as single disy = .y-ent(j).y
                    
                    dim as single force = ent(j).mass/dis
                    dim as single acc=-force/.mass
                    
                    acc/=10000000
                    
                    .vx+=disx*acc
                    .vy+=disy*acc
                    
                    .x+=.vx
                    .y+=.vy
                    
                    if .x < 0 or .x > sc.x then .x-=.vx:.vx*=-1:TotalBounces+=1
                    if .y < 0 or .y > sc.y then .y-=.vy:.vy*=-1:TotalBounces+=1
                    
                end with
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
                circle(.rx,.ry),.mass,rgba(t,t,t,192),,,,F
                'circle(.rx,.ry),.mass,rgb(t,t,t),,,,F
                'pset(.x,.y),rgb(t,t,t)
            else
                continue for
            end if
        end with
    next i
    
    draw string(15,15),"Total bounces: " & TotalBounces,rgb(255,0,255)
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

do
    Controller()
    Math()
    Render()
    
    sleep 1,1
loop until multikey(sc_escape)