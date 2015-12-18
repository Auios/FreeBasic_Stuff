#include "fbgfx.bi"
using fb

declare sub initWindow()
declare sub initPlayer()

declare sub keyboard()
declare sub calc()
declare sub render()

randomize timer

type mywindow
    as integer w,h
    as zstring*48 nme
end type

type player
    as single x,y
    as single vx,vy
    as integer sz
    as ubyte isFalling
    
    declare sub jump()
end type

dim shared as myWindow wnd
dim shared as player oldPl,pl

'============================================

initWindow()
initPlayer()

render()

sleep 500

do
    keyboard()
    calc()
    render()
    
    sleep 1,1
loop until inkey = chr(27)

'============================================

sub initWindow()
    with wnd
        .w = 800
        .h = 600
        .nme = "Application"
        screenres .w,.h,32,1,0
        windowtitle .nme
    end with
end sub

sub initPlayer()
    with pl
        .x = wnd.w*rnd
        .y = 100
        .sz = 30
        .isFalling = 1
    end with
    oldPl = pl
end sub

sub keyboard()
    if multikey(sc_space) then pl.jump()
    if multikey(sc_a) then pl.vx= -1
    if multikey(sc_d) then pl.vx=  1
end sub

sub calc()
    if(pl.isFalling) then
        pl.vy-=0.0033
        pl.y-=pl.vy
        if(pl.y > wnd.h-100-pl.sz) then
            pl.isFalling = 0
        end if
    else
        pl.y = wnd.h-100-pl.sz
    end if
    
    pl.x+=pl.vx
    if pl.vx>0 then pl.vx-=0.1
    if pl.vx<0 then pl.vx+=0.1
    if pl.vx>0 and pl.vx < 0.1 then pl.vx = 0
    if pl.vx<0 and pl.vx >-0.1 then pl.vx = 0
end sub

sub render()
    screenlock
    cls
    line(0,0)-(wnd.w,wnd.h),rgb(100,100,100),bf
    line(0,wnd.h-100)-(wnd.w,wnd.h),rgb(200,200,200),bf
    with pl
        circle(.x,.y),.sz,rgb(200,200,200),,,,f
    end with
    screenunlock
end sub

sub player.jump()
    with this
        if .isFalling = 0 then
            .vy=1
            .isFalling = 1
        end if
    end with
end sub