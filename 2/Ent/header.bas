declare function distance(x1 as single,y1 as single,x2 as single,y2 as single) as single

randomize timer
#include "crt.bi"
#include "fbgfx.bi"
using fb

dim shared as integer scrnx,scrny,scf
dim shared as integer ff,ans,selected
dim shared as integer startprog
ff = FreeFile
scf = 1

Sub Init_Screen
    select case scf
    case 0
        scrnx = 800
        scrny = 600
        screenres scrnx,scrny,16,2,0
    case 1
        screeninfo scrnx,scrny
        screenres scrnx,scrny,16,2,1
    end select
end sub

dim shared as integer max_ent = 50
const pi = atn(1)*4

type entprop
    as integer ID
    as single x,y
    as uinteger clr
    as integer shape
    as integer rad
    as single speed
    as integer collide
    as single angle
    as single theta
    as single scx,scy
    as single velx,vely
    as integer sel
end type
dim shared as entprop ent(max_ent)

sub Init_Var(i as integer)
    with ent(i)
        .x = scrnx*rnd
        .y = scrny*rnd
        .ID = i
        .Clr = rgb(255*rnd,255*rnd,255*rnd)
        .shape = 2
        .rad = 15*rnd+5
        .collide = 0
        .speed = 2*rnd
        .angle = 360*rnd
        .theta = .angle*pi/180
        .scx = cos(.theta)
        .scy = sin(.theta)
        .velx = .speed * .scx
        .vely = .speed * .scy
        if i = selected then .sel = 1
    end with
end sub

sub FileWrite(i as integer)
    open "Data\" & i & ".txt" for binary as #ff
    if Err>0 then print "Error writing the file":Sleep:End
    put #ff,,ent(i)
    close
end sub

sub FileRead(i as integer)
    open "Data\" & i & ".txt" for binary as #ff
    if Err>0 then print "Error reading the file":Sleep:End
    get #ff,,ent(i)
    close
end sub

sub Controller(i as integer)
    with ent(i)
        if multikey(sc_w) then
            for j as integer = 0 to max_ent
                if distance(.x,.y,ent(j).x,ent(j).y) > .rad+ent(j).rad then
                    .y-=.05
                end if
            next j
        end if
        if multikey(sc_s) then
            for j as integer = 0 to max_ent
                if distance(.x,.y,ent(j).x,ent(j).y) > .rad+ent(j).rad then
                    .y+=.05
                end if
            next j
        end if
        if multikey(sc_a) then
            for j as integer = 0 to max_ent
                if distance(.x,.y,ent(j).x,ent(j).y) > .rad+ent(j).rad then
                    .x-=.05
                end if
            next j
        end if
        if multikey(sc_d) then
            for j as integer = 0 to max_ent
                if j <> i then
                    if distance(.x,.y,ent(j).x,ent(j).y) > .rad+ent(j).rad then
                        .x+=.05
                    end if
                end if
            next j
        end if
'        line(0,0)-(scrnx,scrny),rgb(.x,.y,.x+.y),"bf"
    end with
end sub

sub Core(i as integer)
    with ent(i)
        if i = selected then .sel = 1
        if i <> selected then .sel = 0
        
        '.theta+=.2*rnd
        
        .scx=cos(.theta)
        .scy=sin(.theta)
        
        .velx=.speed*.scx
        .vely=.speed*.scy
        
        select case .sel
        case 0
            .x+=.velx
            .y+=.vely
            for j as integer = 0 to max_ent
                if distance(.x,.y,ent(j).x,ent(j).y) < .rad+ent(j).rad then
                    if j <> i then
                        .x-=.velx
                        .y-=.vely
                        .theta += 180 mod 360
                        ent(j).theta += 180 mod 360
                    end if
                end if
            next j
        case 1
            Controller(i)
        end select
    end with
end sub

sub ScreenBorder(i as integer)
    with ent(i)
        if .x > scrnx then .x = 0
        if .x < 0 then .x = scrnx
        if .y > scrny then .y = 0
        if .y < 0 then .y = scrny
    end with
end sub

sub Render(i as integer)
    for Y as integer = -scrny to scrny step scrny
        for X as integer = -scrnx to scrnx step scrnx
            with ent(i)
                select case .shape
                case 1
                    line(X+.x-.rad,Y+.y-.rad)-(X+.x+.rad,Y+.y+.rad),.clr,BF
                case 2
                    circle(X+.x,Y+.y),.rad,.clr,,,,f
                end select
            end with
        next X
    next Y
end sub

function distance(x1 as single,y1 as single,x2 as single,y2 as single) as single
    dim as single d
    d = sqr(((x2-x1)^2)+((y2-y1)^2))
    return d
end function
