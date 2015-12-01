#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

scrn()

type playerProp
    as ushort isJumping,isRunning
    as single x,y,vx,vy
    as single jumpforce,moveforce,maxspeed
    
    declare constructor()
end type

type physicProp
    as single gravity,friction,drag
    
    declare constructor()
end type

constructor playerProp
    with this
        .isJumping = 0
        .x = sc.x*rnd
        .y = sc.y*rnd
        .jumpforce = 10
        .moveforce = 3
'        .maxspeed = 3
    end with
end constructor

constructor physicProp
    with this
        .gravity = .7
        .friction = .4
        .drag = .1
    end with
end constructor

sub controller()
    
end sub

sub calc()
    
end sub

sub render()
    
end sub

'===================================

dim as 