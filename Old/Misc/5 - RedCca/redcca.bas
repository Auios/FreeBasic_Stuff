#include "fbgfx.bi"
#include "color16.bi"

using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1

dim shared as integer delay=15

type screendata
    as integer north    = 0
    as integer south    = scrny
    as integer east     = 0
    as integer west     = scrnx
end type
dim shared scr as screendata

#include "color.bi"

type box
    as integer xlen=32
    as integer ylen=128
    as integer xst=64
    as integer yst=64
    as integer isFilled=1
    as integer clr=2
end type
dim shared b as box

type foodfood
    as integer x
    as integer y
    as integer value
    as integer scale
    
    declare sub getEaten()
end type

type player
    as double x=scrnx*rnd
    as double y=scrny*rnd
    as double px,py'previous poses to erase
    as double speed=1
    as integer scale=5
    as string controls
    as uinteger col
    as integer isAlive=1
    as string chat
    as string nme
    
    declare sub eatPlayer(pl as player)
    declare sub die()
    declare sub eatFood(f as foodfood)
    declare sub respawn()
    declare sub poop()

end type


sub drawBox(b as box)
    draw "BM "& b.xst &","& b.yst
    draw "R"& b.xlen &" D"& b.ylen &"L"& b.xlen &" U"& b.ylen
    if b.isFilled = 1 then
        draw "BM +1,1"
        draw "P "& b.clr &","& b.clr
    end if
end sub

dim shared f as foodfood

sub foodfood.getEaten
    x=scrnx*rnd
    y=scrny*rnd
    value=5*rnd
    scale=3
end sub

sub player.eatFood(f as foodfood)
    f.getEaten
    scale+=f.value
end sub


sub checkFoodCol(pl as player,f as foodfood)
    if pl.x<f.x+f.value and pl.x>f.x-f.value and pl.y<f.y+f.value and pl.y>f.y-f.value then
        if pl.scale>f.value  then
            pl.eatFood(f)
        end if
    end if
end sub

dim p1 as player
dim p2 as player

p1.nme="Cca"
p2.nme="Red"
p1.controls="wasd"
p2.controls="arrows"
p1.col=col.red
p2.col=col.orange
p1.scale=10*rnd+5
p2.scale=10*rnd+5

sub player.die
    isAlive=0
end sub

sub player.respawn
    x=scrnx*rnd
    y=scrny*rnd
    scale=10*rnd+2
    isAlive=1
end sub

sub player.eatPlayer(pb as player)
    pb.die
    scale+=pb.scale
end sub

'sub player.poop
'    scale-=1
'    circle(x,y),2,col.brown
'end sub

sub erasePlayer(pl as player)
    circle(pl.px,pl.py),pl.scale,col.black
end sub

dim shared as string chat
sub movecon(pl as player)
    pl.px=pl.x
    pl.py=pl.y
    if pl.controls="wasd" then
        if pl.isAlive=1 then
            if multikey(sc_w) and pl.y-pl.speed > scr.north and point(pl.x,pl.y-pl.speed)=0 then pl.y-=pl.speed
            if multikey(sc_s) and pl.y+pl.speed > scr.south and point(pl.x,pl.y+pl.speed)=0 then pl.y+=pl.speed
            if multikey(sc_d) and pl.x+pl.speed > scr.east and point(pl.x-pl.speed,pl.y)=0 then pl.x+=pl.speed
            if multikey(sc_a) and pl.x-pl.speed > scr.west and point(pl.x+pl.speed,pl.y)=0 then pl.x-=pl.speed
'            if multikey(sc_q) and pl.scale > 1 then pl.poop
        end if
        if multikey(sc_q) and pl.isAlive=0 then pl.respawn
    end if
    
    if pl.controls="arrows" then
        if pl.isAlive=1 then
            if multikey(sc_up) and pl.y-pl.speed > scr.north and point(pl.x,pl.y-pl.speed)=0 then pl.y-=pl.speed
            if multikey(sc_down) and pl.y+pl.speed > scr.south and point(pl.x,pl.y+pl.speed)=0 then pl.y+=pl.speed
            if multikey(sc_right) and pl.x+pl.speed > scr.east and point(pl.x-pl.speed,pl.y)=0 then pl.x+=pl.speed
            if multikey(sc_left) and pl.x-pl.speed > scr.west and point(pl.x+pl.speed,pl.y)=0 then pl.x-=pl.speed
'            if multikey(sc_period) and pl.scale > 1 then pl.poop 'Has to do with these I KOnkow for sure.pl
        end if
        if multikey(sc_p) and pl.isAlive=0 then pl.respawn
    end if
    if multikey(sc_t) then locate(pl.y,pl.x):input "Cca: ",pl.chat
    if multikey(sc_l) then locate(pl.y,pl.x):input "Red: ",pl.chat
end sub

sub drawFood(f as foodfood)
    circle(f.x,f.y),f.scale,col.brown
end sub

sub checkCol(pl as player,pb as player)
    if pl.x<pb.x+pb.scale and pl.x>pb.x-pb.scale and pl.y<pb.y+pb.scale and pl.y>pb.y-pb.scale and pb.isAlive=1 and pl.isAlive=1 then
        if pl.scale>pb.scale then
            pl.eatPlayer(pb)
        elseif pl.scale<pb.scale then
            pb.eatPlayer(pl)
        end if
    end if
end sub

sub drawPlayer(pl as player)
    if pl.isalive=1 then
        circle(pl.x,pl.y),pl.scale,pl.col
    end if
    
    draw string (pl.x,pl.y),pl.nme & " " & pl.chat
end sub

sub updateStuff(pl as player)
    pl.speed=1/(pl.scale/5)
end sub

dim as integer ticks

do
    ticks+=1
    
    movecon(p1)
    movecon(p2)
    checkCol(p1,p2)
    checkCol(p2,p1)
    
    checkFoodCol(p1,f)
    checkFoodCol(p2,f)
    drawFood(f)
    drawFood(f)
    
    updateStuff(p1)
    updateStuff(p2)
    
    screenlock
    cls
    
    drawplayer(p1)
    drawplayer(p2)
    drawbox(b)
    screenunlock
    
    sleep delay
loop until multikey(sc_escape)

'To Do List:
'   Add projectiles
'   Add plant growth
'   Fix poop
'   Fix chat box
'   Make names disapear after death
