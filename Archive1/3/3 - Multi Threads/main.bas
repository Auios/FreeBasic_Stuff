#include "fbgfx.bi"
using fb

declare sub Render(prm as any ptr)
declare sub Controller(prm as any ptr)
declare sub Logic(prm as any ptr)


dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,8,2,0

dim shared as integer delay = 20

dim as any ptr T_Render
dim as any ptr T_Controller
dim as any ptr T_Logic

dim shared as integer MaxEnt = 50
type P_Ent
    as single x,y
    as integer r,g,b
    as uinteger clr
    as single energy
end type
dim shared as P_Ent Ent(MaxEnt)

for i as integer = 1 to MaxEnt
    with ent(i)
        .x = scrnx * rnd
        .y = scrny * rnd
        
        .r = 255 * rnd
        .g = 255 * rnd
        .b = 255 * rnd
        .clr = rgb(.r,.g,.b)
        
        .energy = 50 * rnd
    end with
next i

sub Render(prm as any ptr)
        screenlock
            cls
            for i as integer = 1 to MaxEnt
                with ent(i)
                    circle(.x,.y),.energy,.clr
                end with
            next i
        screenunlock
        sleep 15
end sub

sub Controller(prm as any ptr)
    with ent(1)
            if multikey(sc_w) then
                .y-=5
            end if
            
            if multikey(sc_s) then
                .y+=5
            end if
            
            if multikey(sc_a) then
                .x-=5
            end if
            
            if multikey(sc_d) then
                .x+=5
            end if
    end with
    sleep 15
end sub

sub Logic(prm as any ptr)
    
end sub

dim shared as any ptr ii 
ii = MutexCreate

do
    T_Render = threadcreate(@Render,@ii)
    If T_Render = 0 Then
        Print "Error creating thread:"; ii
        sleep:stop
    End If
    T_Controller = threadcreate(@Controller,@ii)
    If T_Controller = 0 Then
        Print "Error creating thread:"; ii
        sleep:stop
    End If
'    controller(0)
'    render(0)
    
    threadwait(T_Controller)
    threadwait(T_Render)
    
    sleep 15
    
loop until multikey(sc_escape)

threadwait(T_Controller)
threadwait(T_Render)